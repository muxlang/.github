#!/usr/bin/env bash
# Apply canonical labels from labels/*.yml to muxlang repos.
# Usage: ./scripts/sync-labels.sh [repo ...]
# With no args, syncs every repo in ALL_REPOS below.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ALL_REPOS=(
  mux-compiler
  mux-runtime
  mux-website-api
  mux-syntax-highlighting
  mux-website
  tree-sitter-mux
  mux-context
  .github
)

apply_yaml() {
  local repo="$1"
  local file="$2"
  local name="" color="" description=""

  while IFS= read -r line; do
    case "$line" in
      "- name:"*)
        name="${line#- name:}"
        # Trim whitespace BEFORE stripping quotes: quoted names like
        # "priority: urgent" used to keep their leading quote because the
        # strip ran against ' "priority: urgent"' and missed.
        name="${name#"${name%%[![:space:]]*}"}"
        name="${name%"${name##*[![:space:]]}"}"
        name="${name#\"}"
        name="${name%\"}"
        ;;
      "  color:"*)
        color="${line#  color: }"
        color="${color#\"}"
        color="${color%\"}"
        ;;
      "  description:"*)
        description="${line#  description: }"
        if [[ -n "$name" && -n "$color" ]]; then
          gh label create "$name" \
            --repo "muxlang/$repo" \
            --color "$color" \
            --description "$description" \
            --force
          name=""
          color=""
          description=""
        fi
        ;;
    esac
  done < "$file"
}

sync_repo() {
  local repo="$1"
  echo "Syncing muxlang/$repo ..."
  apply_yaml "$repo" "$ROOT/labels/labels.yml"
  if [[ -f "$ROOT/labels/$repo.yml" ]]; then
    apply_yaml "$repo" "$ROOT/labels/$repo.yml"
  fi
}

if [[ "$#" -gt 0 ]]; then
  TARGETS=("$@")
else
  TARGETS=("${ALL_REPOS[@]}")
fi

for repo in "${TARGETS[@]}"; do
  sync_repo "$repo"
done

echo "Done."
