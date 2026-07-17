# Security Policy

This policy applies to all repositories in the [muxlang](https://github.com/muxlang)
organization (the compiler, runtime, website, playground API, and tooling).

## Supported versions

Mux is in **alpha** and moves fast. Security fixes land on `main` and ship in the
next release; only the latest release of each repository is supported. There are
no long-term-support branches. The compiler version reported by `mux --version`
is the canonical "Mux version".

## Reporting a vulnerability

**Please do not open a public issue for a security problem, and do not post
details in discussions or pull requests.**

Report privately through GitHub's private vulnerability reporting:

1. Go to the affected repository's **Security** tab.
2. Click **Report a vulnerability** (under "Advisories").
3. Describe the issue with enough detail to reproduce it.

This opens a private advisory visible only to you and the maintainers. If you
cannot use private reporting, contact the maintainer
[@DerekCorniello](https://github.com/DerekCorniello) directly and privately.

Please include, where you can:

- the repository and version or commit affected,
- a description of the vulnerability and its impact,
- steps or a minimal case to reproduce it,
- any relevant logs, `.mux` input, or generated IR.

## What to expect

- We aim to acknowledge a report within a few days.
- We will confirm the issue, keep you updated on progress, and credit you in the
  advisory and release notes unless you ask us not to.
- Once a fix is released, we publish the advisory with the details.

## Scope

The Mux toolchain compiles and runs untrusted code by design (notably the
playground API, which executes user-submitted programs in a sandbox). Reports
that are especially valuable include:

- sandbox escapes or resource-exhaustion bypasses in the playground API,
- compiler or runtime memory-safety issues reachable from valid Mux input,
- vulnerable dependencies with a practical exploit path in a shipped artifact.

Thank you for helping keep Mux and its users safe.
