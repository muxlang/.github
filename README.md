# .github

Organization-level defaults for the [muxlang](https://github.com/muxlang) org:

- `profile/README.md` - the org profile shown on the [organization page](https://github.com/muxlang).
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` - shared community-health defaults.
- `labels/` - canonical label YAML and per-repo overlays.
- `templates/<repo>/` - canonical issue template sources synced to each repo.
- `scripts/sync-labels.sh` - apply label YAML to org repos (`gh` CLI required).
- `scripts/sync-templates.sh` - copy `templates/<repo>/` into a repo checkout.
- `scripts/retire-labels.sh` - delete retired labels org-wide.
- `scripts/clear-milestones.sh` - bulk-clear milestones from a repo's issues.

Policy and workflow rules:
[mux-context/docs/repo-governance.md](https://github.com/muxlang/mux-context/blob/main/docs/repo-governance.md).

Per-repo `.github/ISSUE_TEMPLATE/`, `.github/workflows/issue-triage.yml`, and
`.github/labels.yml` are synced from `templates/` here via `scripts/sync-templates.sh`.
Do not copy templates or invent labels in individual repos.
