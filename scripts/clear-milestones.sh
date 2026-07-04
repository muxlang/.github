#!/usr/bin/env bash
# Bulk-clear milestones from all issues in a repo (issues are not deleted).
# Usage: ./scripts/clear-milestones.sh <repo>
set -euo pipefail

REPO="${1:?usage: clear-milestones.sh <repo>}"
FULL="muxlang/$REPO"

echo "Clearing milestones on $FULL ..."
gh api "repos/$FULL/issues?state=all&per_page=100" --paginate \
  --jq '.[] | select(.milestone != null) | .number' | while read -r num; do
  id="$(gh issue view "$num" --repo "$FULL" --json id -q .id)"
  gh api graphql -f query="
    mutation {
      clearMilestone(input: {issueId: \"$id\"}) {
        issue { number }
      }
    }"
  echo "  cleared #$num"
done

echo "Closing milestones on $FULL ..."
gh api "repos/$FULL/milestones?state=all" --jq '.[].number' | while read -r n; do
  gh api -X PATCH "repos/$FULL/milestones/$n" -f state=closed
  echo "  closed milestone #$n"
done

echo "Done."
