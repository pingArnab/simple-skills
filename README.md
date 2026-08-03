# Portable Agent Skills

Two independent, open-format Agent Skills for safer AI-assisted work:

- **`ask-first`** resolves material ambiguity with evidence-backed recommendations before action.
- **`demo-first`** previews user-facing changes and requires explicit approval before production implementation.

Both skills follow the [`SKILL.md` Agent Skills format](https://agentskills.io/specification). They can activate automatically from their descriptions or be invoked explicitly using the syntax supported by your harness, such as `$ask-first` in Codex or `/ask-first` in Claude Code.

## Install

Each installer accepts:

- a skill: `all`, `ask-first`, or `demo-first`;
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

### PowerShell

```powershell
.\install.ps1 -Skill all -Harness auto -Project C:\path\to\project
```

If Windows blocks local scripts under the current execution policy, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Skill all -Harness auto -Project C:\path\to\project
```

### POSIX shell

```sh
sh ./install.sh --skill all --harness auto --project /path/to/project
```

### Node.js

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
install.ps1
install.sh
install.mjs
```

The optional `agents/openai.yaml` files provide Codex UI metadata. Other harnesses can ignore them.
