<div align="center">

<img src="https://mux-lang.dev/img/mux-logo.png" alt="Mux Logo" width="140">

# Mux

### The programming language for everyone

Mux is a statically-typed, reference-counted language that combines Python's
readability, Go's simplicity, and Rust's type safety - compiled to native code
via LLVM.

[![Website](https://img.shields.io/badge/mux--lang.dev-visit-2ea6ff.svg?style=flat-square)](https://mux-lang.dev)
[![Docs](https://img.shields.io/badge/docs-read-blue.svg?style=flat-square)](https://mux-lang.dev/docs/getting-started/quick-start)
[![Playground](https://img.shields.io/badge/playground-try%20online-orange.svg?style=flat-square)](https://mux-lang.dev/playground)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](https://github.com/muxlang/mux-compiler/blob/main/LICENSE)

</div>

---

## Get started

```bash
# Install (Linux/macOS)
curl -fsSL https://raw.githubusercontent.com/muxlang/mux-compiler/main/scripts/install.sh | sh

# Or on Windows (PowerShell)
irm https://raw.githubusercontent.com/muxlang/mux-compiler/main/scripts/install.ps1 | iex

# Run your first program
mux run hello.mux
```

Or skip the install and **[try it in the playground](https://mux-lang.dev/playground)**.

## Editor support

- **VS Code:** install [Mux Language Support](https://marketplace.visualstudio.com/items?itemName=mux-lang.language-mux).
- **Neovim:** install the [Mux plugin](https://github.com/muxlang/tree-sitter-mux) with your plugin manager. It provides syntax highlighting and starts `mux lsp`.

Both integrations use the compiler's built-in language server. Install Mux
0.13.0 or newer first.

## Why Mux?

- **Simple & readable** - clean, semicolon-free syntax with Python-like clarity.
- **Type safe** - strong static typing, no implicit conversions, errors caught at compile time.
- **Fast & native** - LLVM-powered compilation to real native binaries.
- **Memory safe** - reference counting, no GC pauses and no borrow-checker ceremony.
- **Modern** - generics, interfaces, tagged unions, and exhaustive pattern matching.

## The repositories

| Repo | What it is |
|------|------------|
| [mux-compiler](https://github.com/muxlang/mux-compiler) | The compiler + CLI (lexer, parser, semantics, LLVM codegen). The canonical "Mux version". |
| [mux-runtime](https://github.com/muxlang/mux-runtime) | Runtime + standard library for compiled programs. Plain stable Rust, no LLVM. Existing crates.io releases remain available, but new versions are consumed from a pinned git commit. |
| [mux-website](https://github.com/muxlang/mux-website) | The documentation site (mux-lang.dev) + the docs AI assistant + indexing tools. |
| [mux-website-api](https://github.com/muxlang/mux-website-api) | The Fly.io compile/run API behind the playground. |
| [tree-sitter-mux](https://github.com/muxlang/tree-sitter-mux) | Tree-sitter grammar + highlight queries (Neovim, Helix, Emacs). |
| [mux-syntax-highlighting](https://github.com/muxlang/mux-syntax-highlighting) | TextMate grammar, VSCode extension, editor configs, and the canonical syntax spec. |
| [mux-context](https://github.com/muxlang/mux-context) | Cross-repo knowledge hub: architecture, design rationale, feature map, glossary, and the release process. |

## Getting involved

- **New to the language?** Start with the [docs](https://mux-lang.dev).
- **Curious how it fits together?** Read [mux-context](https://github.com/muxlang/mux-context).
- **Want to contribute?** Each repo has its own `README.md` and `AGENTS.md`; shared
  guidelines live in [CONTRIBUTING.md](https://github.com/muxlang/.github/blob/main/CONTRIBUTING.md).
- **Found a bug or have an idea?** Open an issue in the relevant repo - or, if
  you're unsure which, in [mux-context](https://github.com/muxlang/mux-context/issues) for triage.

## FOSS Usage:

Thank you to the following companies who have allowed this project to use their services under FOSS terms:

[Greptile](https://www.greptile.com): The War on Bugs [![Greptile: The War on Bugs](https://www.greptile.com/badge.svg)](https://www.greptile.com/?utm_source=oss_badge&utm_medium=readme&utm_campaign=greptile_for_open_source)

[SonarQube Cloud](https://sonarcloud.io): Continuous Code Quality and Security ![SonarQube Cloud](https://img.shields.io/badge/-black?style=flat&logo=sonarqubecloud&logoColor=white)

[Blacksmith](https://www.blacksmith.sh): The fastest way to run your GitHub Actions

<div align="center">

Mux is MIT-licensed and welcomes contributions.

</div>
