from __future__ import annotations

import argparse
import logging


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="agent-config-mcp",
        description="Serve agent instruction markdown over Streamable HTTP MCP.",
    )
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8090)
    parser.add_argument(
        "--projects-root",
        default=None,
        help="Override AGENT_CONFIG_PROJECTS_ROOT (default: parent of agent-foundry).",
    )
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"],
    )
    args = parser.parse_args()

    logging.basicConfig(level=getattr(logging, args.log_level))

    if args.projects_root:
        import os

        os.environ["AGENT_CONFIG_PROJECTS_ROOT"] = args.projects_root

    from agent_config_mcp.server import create_app

    app = create_app()

    try:
        import uvicorn
    except ImportError as exc:
        raise SystemExit("uvicorn required: pip install uvicorn") from exc

    logging.getLogger(__name__).info(
        "Agent Config MCP: http://%s:%s/mcp", args.host, args.port
    )
    uvicorn.run(app, host=args.host, port=args.port, log_level=args.log_level.lower())


if __name__ == "__main__":
    main()
