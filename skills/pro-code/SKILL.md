---
name: pro-code
description: Write professional, production-quality code instead of demo-grade code. Use when the user asks for professional, production-ready, clean, or high-quality code, or asks to consider time and memory complexity, language-specific standards and idioms, documentation, or best practices. Always applies complexity analysis, official language conventions, native documentation, and robustness; applies logging and tests only by user preference or project structure. Supports explicit invocation as pro-code.
---

# Pro Code

Write code a senior engineer would approve in review. Match the project first, the language's official conventions second, and personal taste never.

## Settings

Honor settings the user supplies inline or in project instructions, for example `Logging: OFF, Testing: AUTO`.

| Setting | Values | Default |
| --- | --- | --- |
| Logging | `ON`, `OFF`, `AUTO` | `AUTO` |
| Testing | `ON`, `OFF`, `AUTO` | `AUTO` |

## Always apply

### 1. Complexity

- Choose the algorithm and data structure with the best time and space complexity for the stated or inferred scale. If scale is unknown and it changes the design, ask once or state the assumed scale.
- Document Big-O for time and space on non-trivial functions, and justify the choice against the naive approach in a line or two.
- Avoid needless allocations and copies. Stream or batch large data instead of loading it all into memory.
- Do not optimize prematurely: prefer clarity unless scale or a measured bottleneck says otherwise.

### 2. Language standards

- Follow the current official style guide and idioms for the language and version in use. Detect them from the project (config, lockfiles, existing code) before assuming.
- Examples: Python PEP 8/257/484 with modern type syntax; Java Google style and records; TypeScript `strict` and no `any`; Go Effective Go and `gofmt`; Rust `rustfmt`, Clippy, and `Result` over `unwrap` in library code; C# nullable reference types and async/await.
- State the style guide, linter, and doc format you are following in one line before the code.
- Use modern language features and avoid deprecated APIs. Write idiomatic code, not a translation from another language.

### 3. Documentation

- Use the language's native doc format (docstrings, Javadoc, TSDoc, GoDoc, XML docs, Rustdoc) on every public module, type, and function: purpose, parameters, return value, errors, and an example where it helps.
- Comments explain why, never what. Remove noise comments.

### 4. Robustness

- Validate inputs and handle edge cases: empty, null, oversized, malformed, concurrent.
- Use specific error types. Never swallow errors silently or use bare catch-alls.
- Set timeouts and use bounded retries with backoff for I/O and network calls.
- Keep secrets out of code; keep configuration separate from logic.
- Guard against injection, path traversal, and unsafe deserialization where inputs cross a trust boundary.

### 5. Structure

- Small single-responsibility units, clear names, no magic numbers, no hidden globals.
- Inject dependencies so units stay testable even when tests are not requested.
- Avoid over-engineering: no speculative abstractions, no unnecessary dependencies.

## Apply by preference or project structure

### Logging

- `ON`: add logging with the project's or language's standard library, correct levels, lazy or structured formatting, and no secrets or PII.
- `OFF`: add no logging code.
- `AUTO`: if the project already uses a logging library, follow its conventions. If it does not, add none unless the code is a long-running service or job, or has failure paths that are hard to diagnose without logs. Log at boundaries only (I/O, external calls, handled errors), never inside hot loops.

### Testing

- `ON`: write tests with the project's or language's standard framework covering normal, edge, and failure cases.
- `OFF`: write no tests, but keep the code easy to test.
- `AUTO`: if the project has a test directory or framework, add tests matching its layout and naming. Otherwise skip tests and say so.

When a choice depends on project structure you cannot see, inspect the repository first. If it is still unclear, ask one short question rather than guessing.

## Output

1. Design and assumptions, including which optional items were applied and why.
2. Code.
3. Tests, only if applied.
4. Complexity analysis and trade-offs.
5. Improvements worth making with more time, if any.

Ask clarifying questions before coding when requirements are ambiguous in ways that change the design.

## Final check

Before replying, confirm the code was run or linted where tooling is available, complexity is documented, public APIs are documented, and no logging or tests were added against the user's settings.
