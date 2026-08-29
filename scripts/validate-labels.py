#!/usr/bin/env python3
"""Validate live GitHub labels against the canonical labels/*.yml files.

For every repository in repositories.txt, fetches the live label set with `gh`
and diffs it against labels/labels.yml plus the repository overlay
(labels/<repo>.yml).
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
MANIFEST = ROOT / "repositories.txt"

EXPECTED_REPOS = (
    "mux-runtime",
    "mux-compiler",
    "mux-website-api",
    "mux-website",
    ".github",
    "tree-sitter-mux",
    "mux-syntax-highlighting",
    "mux-examples",
    "mux-context",
)


def manifest_repos():
    """Read and validate the one organization repository manifest."""
    if not MANIFEST.is_file():
        raise ValueError(f"missing repository manifest: {MANIFEST}")

    repos = []
    for number, raw in enumerate(MANIFEST.read_text().splitlines(), 1):
        repo = raw.split("#", 1)[0].strip()
        if not repo:
            continue
        if not re.fullmatch(r"[A-Za-z0-9._-]+", repo):
            raise ValueError(f"invalid repository name on line {number}: {repo!r}")
        if repo in repos:
            raise ValueError(f"duplicate repository in manifest: {repo!r}")
        repos.append(repo)

    if tuple(repos) != EXPECTED_REPOS:
        raise ValueError(
            "repositories.txt must contain the exact nine muxlang repositories "
            f"in canonical order; found {repos!r}"
        )
    return repos


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


def verify_repo(repo):
    """Reject archived, forked, renamed, or non-default-branch targets."""
    out = subprocess.run(
        [
            "gh", "api", f"repos/muxlang/{repo}",
            "--jq", "[.full_name, .default_branch, .archived, .fork] | @tsv",
        ],
        check=True, capture_output=True, text=True,
    ).stdout.strip()
    full_name, default_branch, archived, fork = out.split("\t")
    if (
        full_name != f"muxlang/{repo}"
        or default_branch != "main"
        or archived != "false"
        or fork != "false"
    ):
        raise ValueError(
            f"refusing {repo}: expected active muxlang repository with main "
            f"default branch, got {out!r}"
        )


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
    try:
        all_repos = manifest_repos()
        requested = sys.argv[1:] or all_repos
        unknown = sorted(set(requested) - set(all_repos))
        if unknown:
            raise ValueError(f"repositories not in repositories.txt: {', '.join(unknown)}")
        if len(set(requested)) != len(requested):
            raise ValueError("a repository may be validated only once")
        base = parse_yaml(LABELS / "labels.yml")
        if not base:
            raise ValueError(f"canonical labels file is empty: {LABELS / 'labels.yml'}")
        overlays = {path.stem for path in LABELS.glob("*.yml")} - {"labels"}
        unknown_overlays = sorted(overlays - set(all_repos))
        if unknown_overlays:
            raise ValueError(
                "label overlays have no manifest repository: "
                + ", ".join(unknown_overlays)
            )
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2

    dirty = False

    print(f"Manifest: {len(all_repos)} repositories")
    for repo in requested:
        try:
            verify_repo(repo)
        except (OSError, ValueError, subprocess.CalledProcessError) as error:
            print(f"error: {repo}: {error}", file=sys.stderr)
            dirty = True
            continue

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
