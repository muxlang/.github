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

## A first taste

```mux
// Error handling with Result types
func divide(int a, int b) returns result<int, string> {
    if b == 0 {
        return err("division by zero")
    }
    return ok(a / b)
}

// Pattern matching with exhaustive checking
func main() returns void {
    match divide(10, 2) {
        ok(value) {
            print("Result: " + value.to_string())
        }
        err(error) {
            print("Error: " + error)
        }
    }
}
```

## Get started

```bash
# Install (Linux/macOS)
curl -fsSL https://raw.githubusercontent.com/muxlang/mux-compiler/main/scripts/install.sh | sh

# Run your first program
mux run hello.mux
```

Or skip the install and **[try it in the playground](https://mux-lang.dev/playground)**.

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
| [mux-runtime](https://github.com/muxlang/mux-runtime) | Runtime + standard library for compiled programs. Plain stable Rust, no LLVM. Published to crates.io. |
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

<div align="center">

Mux is MIT-licensed and welcomes contributions.

</div>
