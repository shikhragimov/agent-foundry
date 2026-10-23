"""URI → file map loaded from rules/catalog.json (relative paths only)."""

from __future__ import annotations

import json
import os
from dataclasses import dataclass
from pathlib import Path

_CATALOG_REL = Path("rules") / "catalog.json"


def foundry_root() -> Path:
    return Path(__file__).resolve().parents[1]


def projects_root() -> Path:
    env = os.environ.get("AGENT_CONFIG_PROJECTS_ROOT")
    if env:
        return Path(env).expanduser().resolve()
    # agent-foundry/ → projects/
    return foundry_root().parent


def _safe_under(base: Path, rel: str) -> Path | None:
    """Resolve rel under base; reject .. / absolute / escape."""
    raw = (rel or "").strip().replace("\\", "/")
    if not raw or raw.startswith("/") or ".." in Path(raw).parts:
        return None
    path = (base / raw).resolve()
    try:
        path.relative_to(base.resolve())
    except ValueError:
        return None
    return path


def rel_to_foundry(path: Path) -> str:
    try:
        return path.resolve().relative_to(foundry_root().resolve()).as_posix()
    except ValueError:
        try:
            return path.resolve().relative_to(projects_root().resolve()).as_posix()
        except ValueError:
            return path.name


@dataclass(frozen=True)
class DocRef:
    uri: str
    title: str
    path: Path
    optional: bool = False
    rel_path: str = ""


def catalog_path() -> Path:
    return foundry_root() / _CATALOG_REL


def shared_docs() -> list[DocRef]:
    """Shared resources from rules/catalog.json (paths relative to foundry root)."""
    path = catalog_path()
    if not path.is_file():
        raise FileNotFoundError(f"missing catalog: {_CATALOG_REL.as_posix()}")
    data = json.loads(path.read_text(encoding="utf-8"))
    entries = data.get("shared") or []
    base = foundry_root()
    out: list[DocRef] = []
    for item in entries:
        uri = str(item.get("uri") or "").strip()
        title = str(item.get("title") or uri).strip()
        rel = str(item.get("path") or "").strip()
        if not uri or not rel:
            continue
        resolved = _safe_under(base, rel)
        if resolved is None:
            continue
        out.append(
            DocRef(
                uri=uri,
                title=title,
                path=resolved,
                rel_path=rel.replace("\\", "/"),
            )
        )
    return out


def resolve_project_agents(project: str, root: Path | None = None) -> DocRef | None:
    """Find AGENTS.md for a project folder name (under projects/)."""
    root = root or projects_root()
    name = project.strip().strip("/")
    if not name or ".." in name or name.startswith("."):
        return None
    candidates = [
        (root / name / "AGENTS.md", f"{name}/AGENTS.md"),
        (root / name / "Agents.md", f"{name}/Agents.md"),
        (root / "riverlab" / name / "AGENTS.md", f"riverlab/{name}/AGENTS.md"),
        (root / "riverlab" / name / "Agents.md", f"riverlab/{name}/Agents.md"),
    ]
    for path, rel in candidates:
        if path.is_file():
            return DocRef(
                uri=f"agent-config://project/{name}/agents",
                title=f"AGENTS.md ({name})",
                path=path,
                rel_path=rel,
            )
    return DocRef(
        uri=f"agent-config://project/{name}/agents",
        title=f"AGENTS.md ({name})",
        path=candidates[0][0],
        optional=True,
        rel_path=candidates[0][1],
    )


def resolve_agent_instructions(agent_id: str) -> DocRef | None:
    """Optional overlay: config/agents/<id>.md (relative to foundry)."""
    name = agent_id.strip().strip("/")
    if not name or ".." in name or "/" in name or name.startswith("."):
        return None
    rel = f"config/agents/{name}.md"
    path = foundry_root() / "config" / "agents" / f"{name}.md"
    return DocRef(
        uri=f"agent-config://agent/{name}/instructions",
        title=f"Agent overlay ({name})",
        path=path,
        optional=True,
        rel_path=rel,
    )


def read_doc(ref: DocRef) -> tuple[str | None, str | None]:
    """Return (text, error). Missing optional → (None, None)."""
    path = ref.path
    display = ref.rel_path or rel_to_foundry(path)
    if not path.is_file():
        if ref.optional:
            return None, None
        return None, f"missing: {display}"
    try:
        return path.read_text(encoding="utf-8"), None
    except OSError as exc:
        return None, f"read error {display}: {exc}"
