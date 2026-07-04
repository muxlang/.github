#!/usr/bin/env bash
# Copy canonical issue templates (and shared bootstrap files) into a repo checkout.
# Usage: ./scripts/sync-templates.sh <repo> <path-to-repo-checkout>
#
# Example:
#   ./scripts/sync-templates.sh mux-runtime ../mux-runtime
set -euo pipefail

REPO="${1:?usage: sync-templates.sh <repo> <dest>}"
DEST="${2:?usage: sync-templates.sh <repo> <dest>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/templates/$REPO/ISSUE_TEMPLATE"

if [[ ! -d "$SRC" ]]; then
  echo "error: no templates for repo '$REPO' at $SRC" >&2
  exit 1
fi

mkdir -p "$DEST/.github/ISSUE_TEMPLATE" "$DEST/.github/workflows"
cp -r "$SRC/." "$DEST/.github/ISSUE_TEMPLATE/"
cp "$ROOT/templates/shared/workflows/issue-triage.yml" "$DEST/.github/workflows/issue-triage.yml"
cp "$ROOT/templates/shared/labels.yml" "$DEST/.github/labels.yml"

echo "Synced templates, issue-triage workflow, and labels bootstrap to $DEST"
