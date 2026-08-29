#!/usr/bin/env python3
"""Load and validate the canonical muxlang repository manifest."""

from pathlib import Path
import re

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


def load(path: Path) -> tuple[str, ...]:
    """Return the manifest after enforcing its exact canonical contents."""
    if not path.is_file():
        raise ValueError(f"missing repository manifest: {path}")

    repos: list[str] = []
    for number, raw in enumerate(path.read_text().splitlines(), 1):
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
    return EXPECTED_REPOS


if __name__ == "__main__":
    import sys

    try:
        for repository in load(Path(sys.argv[1])):
            print(repository)
    except (OSError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(2) from error
