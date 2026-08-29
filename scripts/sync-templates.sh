#!/usr/bin/env bash
# Copy canonical issue templates into a checked-out muxlang repository.
# Usage: ./scripts/sync-templates.sh [--dry-run|--apply] <repo> <checkout>
# Dry-run is the default. --apply is required for local writes.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
MANIFEST="$ROOT/repositories.txt"
APPLY=false

die() {
  echo "error: $*" >&2
  exit 2
}

usage() {
  sed -n '2,4p' "$0"
}

contains_repo() {
  local candidate="$1"
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line##+([[:space:]])}"
    line="${line%%+([[:space:]])}"
    [[ -n "$line" && "$line" == "$candidate" ]] && return 0
  done < "$MANIFEST"
  return 1
}

validate_manifest() {
  "$ROOT/scripts/repository_manifest.py" "$MANIFEST" >/dev/null || \
    die "invalid repository manifest: $MANIFEST"
}

validate_destination() {
  local repo="$1"
  local requested="$2"
  [[ -d "$requested" ]] || die "destination is not a directory: $requested"
  DEST="$(cd "$requested" && pwd -P)"
  [[ "$DEST" != "$ROOT" ]] || die "destination cannot be the canonical .github checkout"
  [[ -d "$DEST/.git" || -f "$DEST/.git" ]] || die "destination is not a Git checkout: $DEST"

  local top remote metadata full_name default_branch archived fork
  top="$(git -C "$DEST" rev-parse --show-toplevel 2>/dev/null)" || \
    die "destination is not a Git worktree: $DEST"
  [[ "$top" == "$DEST" ]] || die "destination resolves outside its checkout: $DEST"
  remote="$(git -C "$DEST" remote get-url origin 2>/dev/null)" || \
    die "destination has no origin remote: $DEST"
  case "$remote" in
    "git@github.com:muxlang/$repo.git"|"https://github.com/muxlang/$repo.git"|"https://github.com/muxlang/$repo") ;;
    *) die "origin for $DEST is not muxlang/$repo: $remote" ;;
  esac
  [[ -z "$(git -C "$DEST" status --porcelain=v1)" ]] || \
    die "destination is dirty: $DEST"

  metadata="$(gh api "repos/muxlang/$repo" \
    --jq '[.full_name, .default_branch, .archived, .fork] | @tsv')" || \
    die "could not query muxlang/$repo"
  IFS=$'\t' read -r full_name default_branch archived fork <<< "$metadata"
  [[ "$full_name" == "muxlang/$repo" ]] || die "GitHub identity mismatch for $repo"
  [[ "$default_branch" == "main" ]] || die "muxlang/$repo does not use main as its default branch"
  [[ "$archived" == "false" && "$fork" == "false" ]] || \
    die "refusing archived or forked target muxlang/$repo"
}

make_stage() {
  local repo="$1"
  SRC="$ROOT/templates/$repo/ISSUE_TEMPLATE"
  [[ -d "$SRC" ]] || die "no canonical templates for $repo: $SRC"
  [[ -f "$ROOT/templates/shared/workflows/issue-triage.yml" ]] || \
    die "missing shared issue-triage workflow"
  [[ -f "$ROOT/templates/shared/labels.yml" ]] || die "missing shared labels bootstrap"

  STAGE="$(mktemp -d "${TMPDIR:-/tmp}/mux-template-sync.XXXXXX")"
  mkdir -p "$STAGE/ISSUE_TEMPLATE" "$STAGE/workflows"
  cp -a "$SRC/." "$STAGE/ISSUE_TEMPLATE/"
  cp "$ROOT/templates/shared/workflows/issue-triage.yml" "$STAGE/workflows/issue-triage.yml"
  cp "$ROOT/templates/shared/labels.yml" "$STAGE/labels.yml"
}

show_diff() {
  local status=0 file relative target
  diff_file() {
    local old="$1" new="$2" result=0
    if [[ -f "$old" && -f "$new" ]]; then
      diff -u "$old" "$new" || result=$?
    elif [[ -f "$new" ]]; then
      diff -u /dev/null "$new" || result=$?
    elif [[ -f "$old" ]]; then
      diff -u "$old" /dev/null || result=$?
    fi
    [[ "$result" -eq 0 ]] || status=1
  }

  while IFS= read -r -d '' file; do
    relative="${file#"$STAGE"/}"
    target="$DEST/.github/$relative"
    diff_file "$target" "$file"
  done < <(find "$STAGE" -type f -print0)
  if [[ -d "$DEST/.github/ISSUE_TEMPLATE" ]]; then
    while IFS= read -r -d '' file; do
      relative="${file#"$DEST"/.github/}"
      [[ -f "$STAGE/$relative" ]] || diff_file "$file" /dev/null
    done < <(find "$DEST/.github/ISSUE_TEMPLATE" -type f -print0)
  fi
  [[ -f "$DEST/.github/workflows/issue-triage.yml" && ! -f "$STAGE/workflows/issue-triage.yml" ]] && \
    diff_file "$DEST/.github/workflows/issue-triage.yml" /dev/null
  [[ -f "$DEST/.github/labels.yml" && ! -f "$STAGE/labels.yml" ]] && \
    diff_file "$DEST/.github/labels.yml" /dev/null
  # A diff is the successful dry-run result, so it must not trip set -e.
  return 0
}

apply_stage() {
  local backup
  local backed_templates=false backed_workflow=false backed_labels=false
  local installed_templates=false installed_workflow=false installed_labels=false
  backup="$(mktemp -d "${TMPDIR:-/tmp}/mux-template-rollback.XXXXXX")"
  mkdir -p "$backup/workflows"

  restore() {
    local status=$?
    if [[ "$status" -ne 0 ]]; then
      [[ "$installed_templates" == true ]] && rm -rf "$DEST/.github/ISSUE_TEMPLATE"
      [[ "$installed_workflow" == true ]] && rm -f "$DEST/.github/workflows/issue-triage.yml"
      [[ "$installed_labels" == true ]] && rm -f "$DEST/.github/labels.yml"
      [[ "$backed_templates" == true ]] && mv "$backup/ISSUE_TEMPLATE" "$DEST/.github/ISSUE_TEMPLATE"
      [[ "$backed_workflow" == true ]] && mv "$backup/workflows/issue-triage.yml" "$DEST/.github/workflows/issue-triage.yml"
      [[ "$backed_labels" == true ]] && mv "$backup/labels.yml" "$DEST/.github/labels.yml"
    fi
    trap - RETURN
    return "$status"
  }
  trap restore RETURN

  if [[ -d "$DEST/.github/ISSUE_TEMPLATE" ]]; then
    mv "$DEST/.github/ISSUE_TEMPLATE" "$backup/ISSUE_TEMPLATE"
    backed_templates=true
  fi
  if [[ -f "$DEST/.github/workflows/issue-triage.yml" ]]; then
    mv "$DEST/.github/workflows/issue-triage.yml" "$backup/workflows/issue-triage.yml"
    backed_workflow=true
  fi
  if [[ -f "$DEST/.github/labels.yml" ]]; then
    mv "$DEST/.github/labels.yml" "$backup/labels.yml"
    backed_labels=true
  fi
  mkdir -p "$DEST/.github/workflows"
  mv "$STAGE/ISSUE_TEMPLATE" "$DEST/.github/ISSUE_TEMPLATE"
  installed_templates=true
  mv "$STAGE/workflows/issue-triage.yml" "$DEST/.github/workflows/issue-triage.yml"
  installed_workflow=true
  mv "$STAGE/labels.yml" "$DEST/.github/labels.yml"
  installed_labels=true
  echo "Applied. Rollback bundle: $backup"
  trap - RETURN
}

shopt -s extglob
validate_manifest
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run) APPLY=false; shift ;;
    --apply) APPLY=true; shift ;;
    --help|-h) usage; exit 0 ;;
    --*) die "unknown option: $1" ;;
    *) break ;;
  esac
done
[[ "$#" -eq 2 ]] || { usage >&2; exit 2; }
REPO="$1"
CHECKOUT="$2"
contains_repo "$REPO" || die "repository is not in repositories.txt: $REPO"
[[ "$REPO" != ".github" ]] || die "muxlang/.github is the canonical source, not a sync destination"
validate_destination "$REPO" "$CHECKOUT"
make_stage "$REPO"
trap 'rm -rf "$STAGE"' EXIT

if [[ "$APPLY" == true ]]; then
  apply_stage
else
  echo "Dry run. No files will be changed in $DEST."
  show_diff
fi
