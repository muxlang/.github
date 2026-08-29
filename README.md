<div align="center">

<img src="https://mux-lang.dev/img/mux-logo.png" alt="Mux Logo" width="120">

# .github

**Organization-level defaults for the [muxlang](https://github.com/muxlang) org**

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](LICENSE)
[![Sonar Quality Gate](https://sonarcloud.io/api/project_badges/measure?project=muxlang_.github&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=muxlang_.github)

</div>

Shared community-health files, the org profile, and the canonical sources that
sync labels and issue templates into every repo.

---

## What's here

| Path | What it is |
|------|------------|
| `profile/README.md` | The org profile shown on the [organization page](https://github.com/muxlang) |
| `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` | Shared community-health defaults |
| `repositories.txt` | The nine-repository organization manifest |
| `labels/` | Canonical label YAML and per-repo overlays |
| `templates/<repo>/` | Canonical issue template sources synced to each repo |
| `scripts/sync-labels.sh` | Apply label YAML to org repos (`gh` CLI required) |
| `scripts/sync-templates.sh` | Copy `templates/<repo>/` into a repo checkout |
| `scripts/validate-labels.py` | Diff live labels against the canonical YAML; exits nonzero on drift |

---

## How syncing works

Per-repo `.github/ISSUE_TEMPLATE/`, `.github/workflows/issue-triage.yml`, and
`.github/labels.yml` are synced from `templates/` here via
`scripts/sync-templates.sh`. Do not copy templates or invent labels in individual
repos - change them here and re-sync.

Policy and workflow rules:
[mux-context/docs/repo-governance.md](https://github.com/muxlang/mux-context/blob/main/docs/repo-governance.md).

---

## Related repositories

| Repo | What it is |
|------|------------|
| [mux-compiler](https://github.com/muxlang/mux-compiler) | The language, compiler, and CLI (the canonical Mux version) |
| [mux-runtime](https://github.com/muxlang/mux-runtime) | Runtime + standard library linked by compiled programs |
| [mux-website](https://github.com/muxlang/mux-website) | Docs site (mux-lang.dev) and playground UI |
| [mux-website-api](https://github.com/muxlang/mux-website-api) | Compile/run API behind the playground |
| [tree-sitter-mux](https://github.com/muxlang/tree-sitter-mux) | Tree-sitter grammar + highlight queries |
| [mux-syntax-highlighting](https://github.com/muxlang/mux-syntax-highlighting) | TextMate grammar, VSCode extension, canonical syntax spec |
| [mux-examples](https://github.com/muxlang/mux-examples) | Intentional teaching examples and their expected output |
| [mux-context](https://github.com/muxlang/mux-context) | Cross-repo architecture, design rationale, glossary, releases |

---

## FOSS Usage:

Thank you to the following companies who have allowed this project to use their services under FOSS terms:

[Greptile](https://www.greptile.com): The War on Bugs [![Greptile: The War on Bugs](https://www.greptile.com/badge.svg)](https://www.greptile.com/?utm_source=oss_badge&utm_medium=readme&utm_campaign=greptile_for_open_source)

[SonarQube Cloud](https://sonarcloud.io): Continuous Code Quality and Security ![SonarQube Cloud](https://img.shields.io/badge/-black?style=flat&logo=sonarqubecloud&logoColor=white)

[Blacksmith](https://www.blacksmith.sh): The fastest way to run your GitHub Actions

## License

[MIT](LICENSE) - Maintained by [Derek Corniello](https://github.com/DerekCorniello)
