# Contributing to Mux

Thanks for your interest in contributing! These are the shared guidelines for all
[muxlang](https://github.com/muxlang) repositories. Individual repos may add their
own `CONTRIBUTING.md` or `AGENTS.md` with repo-specific details (build toolchains,
testing, etc.) - always check the repo you are working in.

## Where to contribute

| You want to work on... | Repo |
|------------------------|------|
| Compiler, language features, CLI | [mux-compiler](https://github.com/muxlang/mux-compiler) |
| Runtime / standard library (no LLVM needed) | [mux-runtime](https://github.com/muxlang/mux-runtime) |
| Docs, website, playground UI | [mux-website](https://github.com/muxlang/mux-website) |
| Playground compile/run API | [mux-website-api](https://github.com/muxlang/mux-website-api) |
| Tree-sitter grammar (Neovim/Helix/Emacs) | [tree-sitter-mux](https://github.com/muxlang/tree-sitter-mux) |
| TextMate / VSCode / editor highlighting | [mux-syntax-highlighting](https://github.com/muxlang/mux-syntax-highlighting) |

Not sure where something belongs? Open an issue in
[mux-compiler](https://github.com/muxlang/mux-compiler/issues) and it can be routed.

## Workflow

1. Fork the repo (or branch, if you have access). Name branches `type/short-desc`,
   e.g. `feat/new-thing` or `bug/xyz-fix`.
2. Read the repo's `README.md` and `AGENTS.md` to set up your environment.
3. Make focused changes; keep commits clean and descriptive.
4. Run the repo's checks (formatting, lint, tests) before pushing - CI runs them too.
5. Open a pull request, link any related issue, and respond to review feedback.

## Standards

- Write clean, idiomatic, production-ready code; follow the patterns already in the repo.
- No special characters (em-dashes, emojis, non-ASCII) in code, comments, or commits.
- Keep CI green. Don't disable checks to get a merge through.
- Be respectful - see the [Code of Conduct](CODE_OF_CONDUCT.md).

## Reporting bugs and requesting features

Use the issue templates in the relevant repo. Include enough detail to reproduce
(version from `mux --version`, OS, a minimal example).
