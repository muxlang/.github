# Organization governance

This repository is the canonical source for muxlang issue labels, issue forms,
and shared issue-triage policy. It is consumed by all nine repositories listed
in [repositories.txt](repositories.txt).

Cross-repository facts and the canonical agent guidance live in
[`mux-context/SKILL.md`](https://github.com/muxlang/mux-context/blob/main/SKILL.md).
Keep changes here compatible with [repo governance](https://github.com/muxlang/mux-context/blob/main/docs/repo-governance.md).

The manifest is authoritative. Scripts must reject unknown repositories and
must validate a destination before writing. Treat synced files as generated
consumers of this repository, not as hand-edited sources.

Run `python3 -m py_compile scripts/validate-labels.py` and
`bash -n scripts/sync-labels.sh scripts/sync-templates.sh` for the local
quality check. See [CONTRIBUTING.md](CONTRIBUTING.md) and the
[governance policy](https://github.com/muxlang/mux-context/blob/main/docs/repo-governance.md)
for the workflow and merge rules.
