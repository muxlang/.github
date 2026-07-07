#!/usr/bin/env bash
# Delete retired labels from all muxlang repos.
set -euo pipefail

REPOS=(
  mux-compiler mux-runtime mux-website-api mux-syntax-highlighting
  mux-website tree-sitter-mux mux-context .github
)
RETIRED=(
  "priority: urgent" "priority: high" "priority: medium" "priority: low"
  "needs tested" "bug" "feature"
  # Mangled variants created by the old sync-labels.sh quote-stripping bug;
  # the leading double-quote character is part of the live label name.
  '"priority: urgent' '"priority: high' '"priority: medium' '"priority: low'
)

for repo in "${REPOS[@]}"; do
  echo "Retiring labels on muxlang/$repo ..."
  for label in "${RETIRED[@]}"; do
    gh label delete "$label" --repo "muxlang/$repo" --yes 2>/dev/null || true
  done
done

echo "Done."
