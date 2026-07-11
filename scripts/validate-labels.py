#!/usr/bin/env python3
"""Validate live GitHub labels against the canonical labels/*.yml files.

For every muxlang repo, fetches the live label set with `gh` and diffs it
against labels/labels.yml plus the repo's overlay (labels/<repo>.yml).
Reports labels that are MISSING (canonical but not live), EXTRA (live but
not canonical), or DRIFTED (color or description differs).

Usage: ./scripts/validate-labels.py [repo ...]
Exits nonzero if any repo diverges. Requires gh (authenticated) and python3.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LABELS = ROOT / "labels"

ALL_REPOS = [
    "mux-compiler", "mux-runtime", "mux-website-api",
    "mux-syntax-highlighting", "mux-website", "tree-sitter-mux",
    "mux-context", ".github",
]


def parse_yaml(path):
    """Parse the flat '- name/color/description' label YAML (no deps)."""
    labels = {}
    name = color = None
    for raw in path.read_text().splitlines():
        m = re.match(r'^- name:\s*(.+)$', raw)
        if m:
            name = m.group(1).strip().strip('"')
            continue
        m = re.match(r'^\s+color:\s*(.+)$', raw)
        if m:
            color = m.group(1).strip().strip('"')
            continue
        m = re.match(r'^\s+description:\s*(.*)$', raw)
        if m and name and color:
            labels[name] = (color.lower(), m.group(1).strip().strip('"'))
            name = color = None
    return labels


def live_labels(repo):
    # gh api --paginate follows Link headers, so repos with more than one
    # page of labels are fully covered (gh label list caps at its --limit).
    out = subprocess.run(
        ["gh", "api", f"repos/muxlang/{repo}/labels", "--paginate",
         "--jq", ".[] | {name, color, description}"],
        check=True, capture_output=True, text=True,
    ).stdout
    return {
        l["name"]: (l["color"].lower(), l["description"] or "")
        for l in (json.loads(line) for line in out.splitlines() if line)
    }


def main():
    repos = sys.argv[1:] or ALL_REPOS
    base = parse_yaml(LABELS / "labels.yml")
    dirty = False

    for repo in repos:
        expected = dict(base)
        overlay = LABELS / f"{repo}.yml"
        if overlay.exists():
            expected.update(parse_yaml(overlay))
        live = live_labels(repo)

        missing = sorted(set(expected) - set(live))
        extra = sorted(set(live) - set(expected))
        drifted = sorted(
            n for n in set(expected) & set(live) if expected[n] != live[n]
        )

        print(f"=== {repo} ===")
        if not (missing or extra or drifted):
            print("  OK: exact match")
            continue
        dirty = True
        for n in missing:
            print(f"  MISSING : {n!r} (run sync-labels.sh {repo})")
        for n in extra:
            print(f"  EXTRA   : {n!r} (add to a labels yml or retire it)")
        for n in drifted:
            print(f"  DRIFTED : {n!r} live={live[n]} expected={expected[n]}")

    return 1 if dirty else 0


if __name__ == "__main__":
    sys.exit(main())
