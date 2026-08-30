#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/sync-labels.sh"

output="$(APPLY=false apply_yaml test-repo "$ROOT/scripts/tests/quoted-label.yml")"
[[ "$output" == *'priority:\ urgent'* ]] || {
  echo "quoted label value was not parsed" >&2
  exit 1
}
[[ "$output" != *'"priority:'* ]] || {
  echo "quoted label value retained its opening quote" >&2
  exit 1
}
