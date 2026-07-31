# agent-foundry

Portable agent skills + example project bindings (Cursor + Antigravity).

```text
.agent/project.yaml          # example — copy into your repo as needed
skills/                      # source of truth (role skills, etc.)
skills/_portable/BINDING.md
scripts/install-skills.sh    # install into IDE discovery paths
```

Install (copies skills — IDEs often miss symlinked skill folders):

```bash
./scripts/install-skills.sh
```

Targets:

- `~/.cursor/skills/<name>` — Cursor
- `~/.gemini/config/skills/<name>` — Antigravity / Gemini (all workspaces)

Never touches `~/.cursor/skills-cursor`. After install, reload the IDE.

Options: `--dry-run`, `--cursor-only`, `--gemini-only`.  
Legacy alias: `./scripts/link-to-cursor.sh`.
