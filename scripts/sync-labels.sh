#!/usr/bin/env bash
# Apply canonical labels from labels/*.yml to muxlang repositories.
# Usage: ./scripts/sync-labels.sh [--dry-run|--apply] [repo ...]
# Dry-run is the default. --apply is required for GitHub mutations.
set -euo pipefail
shopt -s extglob

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/repositories.txt"
EXPECTED_REPOS=(
  mux-runtime
  mux-compiler
  mux-website-api
  mux-website
  .github
  tree-sitter-mux
  mux-syntax-highlighting
  mux-examples
  mux-context
)

die() {
  echo "error: $*" >&2
  exit 2
}

read_manifest() {
  [[ -f "$MANIFEST" ]] || die "missing repository manifest: $MANIFEST"
  MANIFEST_REPOS=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    repo="${line%%#*}"
    repo="${repo##+([[:space:]])}"
    repo="${repo%%+([[:space:]])}"
    [[ -z "$repo" ]] && continue
    [[ "$repo" =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid repository name: $repo"
    for existing in "${MANIFEST_REPOS[@]}"; do
      [[ "$existing" != "$repo" ]] || die "duplicate repository: $repo"
    done
    MANIFEST_REPOS+=("$repo")
  done < "$MANIFEST"

  [[ "${#MANIFEST_REPOS[@]}" -eq "${#EXPECTED_REPOS[@]}" ]] || \
    die "repositories.txt must contain exactly nine repositories"
  for expected in "${EXPECTED_REPOS[@]}"; do
    printf '%s\n' "${MANIFEST_REPOS[@]}" | grep -Fxq -- "$expected" || \
      die "repositories.txt is missing $expected"
  done
}

contains_repo() {
  local candidate="$1"
  local manifest_repo
  for manifest_repo in "${MANIFEST_REPOS[@]}"; do
    [[ "$manifest_repo" == "$candidate" ]] && return 0
  done
  return 1
}

verify_target() {
  local repo="$1"
  local metadata full_name default_branch archived fork
  metadata="$(gh api "repos/muxlang/$repo" \
    --jq '[.full_name, .default_branch, .archived, .fork] | @tsv')" || \
    die "could not query muxlang/$repo"
  IFS=$'\t' read -r full_name default_branch archived fork <<< "$metadata"
  [[ "$full_name" == "muxlang/$repo" ]] || die "unexpected repository identity for $repo"
  [[ "$default_branch" == "main" ]] || die "muxlang/$repo does not use main as its default branch"
  [[ "$archived" == "false" && "$fork" == "false" ]] || \
    die "refusing archived or forked target muxlang/$repo"
}

parse_targets() {
  APPLY=false
  TARGETS=()
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dry-run) APPLY=false ;;
      --apply) APPLY=true ;;
      --help|-h)
        sed -n '2,4p' "$0"
        exit 0
        ;;
      --*) die "unknown option: $1" ;;
      *) TARGETS+=("$1") ;;
    esac
    shift
  done
  if [[ "${#TARGETS[@]}" -eq 0 ]]; then
    TARGETS=("${MANIFEST_REPOS[@]}")
  fi
  for repo in "${TARGETS[@]}"; do
    contains_repo "$repo" || die "repository is not in repositories.txt: $repo"
  done
}

validate_label_file() {
  local file="$1"
  [[ -f "$file" ]] || die "missing label file: $file"
  grep -Eq '^- name:' "$file" || die "label file has no labels: $file"
}

apply_yaml() {
  local repo="$1"
  local file="$2"
  local name="" color="" description=""

  while IFS= read -r line; do
    case "$line" in
      "- name:"*)
        name="${line#- name:}"
        name="${name#\"}"; name="${name%\"}"
        name="${name##+([[:space:]])}"; name="${name%%+([[:space:]])}"
        ;;
      "  color:"*)
        color="${line#  color: }"
        color="${color#\"}"; color="${color%\"}"
        ;;
      "  description:"*)
        description="${line#  description: }"
        if [[ -n "$name" && -n "$color" ]]; then
          if [[ "$APPLY" == true ]]; then
            gh label create "$name" \
              --repo "muxlang/$repo" \
              --color "$color" \
              --description "$description" \
              --force
          else
            printf 'Would sync muxlang/%s label %q\n' "$repo" "$name"
          fi
          name=""
          color=""
          description=""
        fi
        ;;
    esac
  done < "$file"
}

read_manifest
parse_targets "$@"

# Validate every target and source before making the first write. This keeps a
# typo in a later target from leaving earlier repositories half-synced.
for repo in "${TARGETS[@]}"; do
  verify_target "$repo"
  validate_label_file "$ROOT/labels/labels.yml"
  if [[ -f "$ROOT/labels/$repo.yml" ]]; then
    validate_label_file "$ROOT/labels/$repo.yml"
  fi
done

if [[ "$APPLY" == true ]]; then
  echo "Applying canonical labels to ${#TARGETS[@]} repositories ..."
else
  echo "Dry run. No labels will be changed."
fi

for repo in "${TARGETS[@]}"; do
  echo "Syncing muxlang/$repo ..."
  apply_yaml "$repo" "$ROOT/labels/labels.yml"
  if [[ -f "$ROOT/labels/$repo.yml" ]]; then
    apply_yaml "$repo" "$ROOT/labels/$repo.yml"
  fi
done

echo "Done."
