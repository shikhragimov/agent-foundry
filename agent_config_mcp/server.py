"""MCPServer app: resources + get_bundle (Streamable HTTP)."""

from __future__ import annotations

import logging
from typing import Any

from mcp.server.mcpserver import MCPServer
from mcp.types import ToolAnnotations

from agent_config_mcp.catalog import (
    DocRef,
    catalog_path,
    projects_root,
    read_doc,
    resolve_agent_instructions,
    resolve_project_agents,
    shared_docs,
)

logger = logging.getLogger(__name__)

_INSTRUCTIONS = (
    "Agent Config MCP is read-only. It serves instruction markdown for lab agents.\n"
    "\n"
    "Map: rules/catalog.json — each entry is uri (MCP resource) → path under "
    "agent-foundry (usually rules/*.md). Upstream sources for refresh: "
    "stash/rules-upstream.md.\n"
    "\n"
    "At session start call get_bundle(project=<folder>) once. Optional agent=<id> "
    "adds config/agents/<id>.md. You can also read shared resources by uri "
    "(agent-config://shared/...). Does not replace graph-memory or Dead Simple Manager."
)


def create_mcp() -> MCPServer:
    mcp = MCPServer(
        name="agent-config",
        instructions=_INSTRUCTIONS,
    )
    root = projects_root()
    logger.info("agent-config catalog=rules/catalog.json projects=%s", root.name)

    def _register_resource(doc: DocRef) -> None:
        display = doc.rel_path or doc.path.name

        @mcp.resource(
            doc.uri,
            name=doc.uri.rsplit("/", 1)[-1],
            title=doc.title,
            description=f"Markdown: {display}",
            mime_type="text/markdown",
        )
        def _read() -> str:
            text, err = read_doc(doc)
            if err:
                raise FileNotFoundError(err)
            if text is None:
                raise FileNotFoundError(f"optional missing: {display}")
            return text

    for ref in shared_docs():
        _register_resource(ref)

    @mcp.tool(
        title="Get instruction bundle",
        description=(
            "Return shared lab instructions (from rules/ via rules/catalog.json) "
            "plus optional project AGENTS.md and agent overlay, concatenated. "
            "Call once at session start. "
            "project: folder name (e.g. infra, graph-memory-mcp). "
            "agent: optional id for config/agents/<id>.md."
        ),
        annotations=ToolAnnotations(readOnlyHint=True),
    )
    def get_bundle(
        project: str | None = None,
        agent: str | None = None,
    ) -> dict[str, Any]:
        refs: list[DocRef] = list(shared_docs())
        if project:
            pref = resolve_project_agents(project, root)
            if pref:
                refs.append(pref)
        if agent:
            aref = resolve_agent_instructions(agent)
            if aref:
                refs.append(aref)

        sections: list[dict[str, Any]] = []
        missing: list[str] = []
        parts: list[str] = []

        for ref in refs:
            display = ref.rel_path or ref.path.name
            text, err = read_doc(ref)
            if err:
                missing.append(err)
                sections.append(
                    {
                        "uri": ref.uri,
                        "title": ref.title,
                        "ok": False,
                        "error": err,
                        "path": display,
                    }
                )
                continue
            if text is None:
                missing.append(f"optional missing: {display}")
                sections.append(
                    {
                        "uri": ref.uri,
                        "title": ref.title,
                        "ok": False,
                        "error": "optional missing",
                        "path": display,
                    }
                )
                continue
            sections.append(
                {
                    "uri": ref.uri,
                    "title": ref.title,
                    "ok": True,
                    "path": display,
                    "chars": len(text),
                }
            )
            parts.append(f"<!-- {ref.uri} | {ref.title} -->\n\n{text.rstrip()}\n")

        return {
            "success": True,
            "catalog": "rules/catalog.json",
            "project": project,
            "agent": agent,
            "sections": sections,
            "missing": missing,
            "bundle": "\n---\n\n".join(parts),
        }

    return mcp


def create_app():
    """ASGI app for uvicorn (Streamable HTTP at /mcp)."""
    return create_mcp().streamable_http_app(
        streamable_http_path="/mcp",
        json_response=True,
        stateless_http=True,
    )
