# Simple Skill

[![skills.sh](https://skills.sh/b/pingArnab/simple-skills)](https://skills.sh/pingArnab/simple-skills)

Small, focused skills for AI coding agents. Simple Skill favors clear, easy-to-adopt workflows over large, production-oriented instruction sets. Each skill does one useful thing well and can be used independently.

## Available skills

- **`ask-first`** resolves material ambiguity with evidence-backed recommendations before acting.
- **`demo-first`** previews user-facing changes and requires explicit approval before production implementation.
- **`pro-code`** writes production-quality code with complexity analysis, language-specific standards, and documentation, plus optional logging and tests.

These skills follow the [Agent Skills `SKILL.md` format](https://agentskills.io/specification). They can activate automatically from their descriptions or be invoked explicitly using the syntax supported by your harness, such as `$ask-first` in Codex or `/ask-first` in Claude Code.

## Usage

Invoke a skill by name, or let it activate automatically from its description. Use `/<skill>` in Claude Code or `$<skill>` in Codex.

### ask-first

Option: confidence policy, which you can state up front. Otherwise the skill asks, or defaults to `Risk-based`.

| Value | Description |
| --- | --- |
| `Risk-based` (default) | Ask only when ambiguity could materially change the result; infer conventional, reversible details and disclose them. |
| `Threshold` | Ask unless confidence meets a threshold you choose, such as 90%. |
| `Strict` | Ask about every unspecified choice, including minor implementation details. |

```text
/ask-first Add SSO to the admin app. Policy: Threshold 90%
```

### demo-first

Option: demo type, which you can pick up front. Otherwise the skill recommends one from project context. Production implementation starts only after explicit approval.

| Value | Description |
| --- | --- |
| `Project-stack prototype` | Disposable prototype in the existing runnable UI stack. Best when realistic behavior or visual fidelity matters. |
| `Standalone HTML` | Isolated, dependency-free preview. Best for portability or when no suitable UI stack exists. |
| `Design or wireframe` | Structure-only artifact. Best for validating intent before interaction code is worthwhile. |

```text
/demo-first Redesign the settings page. Demo type: Standalone HTML
```

### pro-code

Options: `Logging` and `Testing`, each defaulting to `AUTO`. Set them inline or in project instructions.

| Setting | Value | Description |
| --- | --- | --- |
| `Logging` | `ON` | Always add logging using the standard library, correct levels, and no secrets or PII. |
| | `OFF` | Add no logging code. |
| | `AUTO` (default) | Follow the project's logging library if present; otherwise add logging only for long-running services or hard-to-diagnose failures. |
| `Testing` | `ON` | Always write tests covering normal, edge, and failure cases. |
| | `OFF` | Write no tests, but keep the code easy to test. |
| | `AUTO` (default) | Add tests matching the project's layout if it has a test framework or directory; otherwise skip and say so. |

```text
/pro-code Write a rate limiter in Go. Logging: OFF, Testing: ON
```

## Install

### skills.sh

Install every Simple Skill with the official skills.sh CLI:

```sh
npx skills add pingArnab/simple-skills --skill '*'
```

Install a single skill instead:

```sh
npx skills add pingArnab/simple-skills --skill ask-first
```

Use `--agent` to target a specific coding agent, such as `--agent codex` or `--agent claude-code`. See the [skills CLI documentation](https://www.skills.sh/docs/cli) for all options.

### Repository installers

Each bundled installer accepts:

- a skill: `all` or any skill currently in `skills/`;
- a harness: `auto`, `agents`, `codex`, `claude`, `copilot`, or `all`;
- a project directory;
- an optional custom target directory;
- a force flag to replace an existing installation.

`auto` installs into detected project skill directories and defaults to `.agents/skills`. Harness destinations are:

| Harness | Project destination |
| --- | --- |
| [Open Agent Skills](https://agentskills.io/specification) / [Codex](https://developers.openai.com/codex/skills) | `.agents/skills` |
| [Claude Code](https://code.claude.com/docs/en/skills) | `.claude/skills` |
| [GitHub Copilot](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills) | `.github/skills` |

#### PowerShell

```powershell
.\install.ps1 -Skill all -Harness auto -Project C:\path\to\project
```

If Windows blocks local scripts under the current execution policy, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Skill all -Harness auto -Project C:\path\to\project
```

#### POSIX shell

```sh
sh ./install.sh --skill all --harness auto --project /path/to/project
```

#### Node.js

```sh
node install.mjs --skill all --harness auto --project /path/to/project
```

Use `-Target` in PowerShell or `--target` in the shell and Node installers for another harness or a personal/global skill directory. Relative custom targets resolve from the selected project.

### Manual copy

Copy either directory under `skills/` into a skill discovery directory supported by the target harness. Keep each skill folder intact so `SKILL.md` remains at its root.

Existing installations are never replaced unless `-Force` or `--force` is supplied.

## Repository layout

```text
skills/
  ask-first/
    SKILL.md
    agents/openai.yaml
  demo-first/
    SKILL.md
    agents/openai.yaml
  pro-code/
    SKILL.md
    agents/openai.yaml
skills.sh.json
install.ps1
install.sh
install.mjs
```

The optional `agents/openai.yaml` files provide Codex UI metadata. Other harnesses can ignore them.
