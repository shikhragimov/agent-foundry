# agent-foundry

Portable agent skills + example project bindings (Cursor + Antigravity), plus a thin **agent-config MCP** that serves instruction markdown over Streamable HTTP.

```text
.agent/project.yaml          # example — copy into your repo as needed
skills/                      # source of truth (role skills, etc.)
skills/_portable/BINDING.md
scripts/install-skills.sh    # install into IDE discovery paths
agent_config_mcp/            # Streamable HTTP MCP (get_bundle + resources)
rules/                       # local served markdown + catalog.json (uri → path; gitignored)
stash/                       # upstream refresh hints (gitignored)
config/agents/               # optional per-agent overlays
```

## Skills install

```bash
./scripts/install-skills.sh
```

Targets:

- `~/.cursor/skills/<name>` — Cursor
- `~/.gemini/config/skills/<name>` — Antigravity / Gemini (all workspaces)

Never touches `~/.cursor/skills-cursor`. After install, reload the IDE.

Options: `--dry-run`, `--cursor-only`, `--gemini-only`.  
Legacy alias: `./scripts/link-to-cursor.sh`.

## Agent config MCP

Thin read-only Streamable HTTP MCP: serves instruction markdown. URI map is local `rules/catalog.json` (not in git).

```bash
uv sync
uv run agent-config-mcp --host 127.0.0.1 --port 8090
# http://127.0.0.1:8090/mcp
```

Session start: `get_bundle(project="<folder>")` once. Optional `agent=<id>` adds `config/agents/<id>.md`.
