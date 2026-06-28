# Mux

**The programming language for everyone.** Mux is a statically-typed,
reference-counted language that combines Python's readability, Go's simplicity, and
Rust's type safety, compiled to native code via LLVM.

- **Website & docs:** [mux-lang.dev](https://mux-lang.dev)
- **Install:** `curl -fsSL https://raw.githubusercontent.com/muxlang/mux-compiler/main/scripts/install.sh | sh`
- **Try it online:** the playground at [mux-lang.dev](https://mux-lang.dev)

## Repositories

| Repo | What it is |
|------|------------|
| [mux-compiler](https://github.com/muxlang/mux-compiler) | The compiler + CLI (lexer, parser, semantics, LLVM codegen). The canonical "Mux version". |
| [mux-runtime](https://github.com/muxlang/mux-runtime) | Runtime + standard library for compiled programs. Plain stable Rust, no LLVM. Published to crates.io. |
| [mux-website](https://github.com/muxlang/mux-website) | The documentation site (mux-lang.dev) + the docs AI assistant + indexing tools. |
| [mux-website-api](https://github.com/muxlang/mux-website-api) | The Fly.io compile/run API behind the playground. |
| [tree-sitter-mux](https://github.com/muxlang/tree-sitter-mux) | Tree-sitter grammar + highlight queries (Neovim, Helix, Emacs). |
| [mux-syntax-highlighting](https://github.com/muxlang/mux-syntax-highlighting) | TextMate grammar, VSCode extension, editor configs, and the canonical syntax spec. |

## Getting involved

- New to the language? Start with the [docs](https://mux-lang.dev).
- Want to contribute? Each repo has its own `README.md` and `AGENTS.md`; shared
  contribution guidelines live in this repo's `CONTRIBUTING.md`.
- Found a bug or have an idea? Open an issue in the relevant repo.

Mux is MIT-licensed and welcomes contributions.
