# Portable skill bindings

## Config file

Prefer `.agent/project.yaml` at the repository root.

Fallback (if present): path noted in chat, or `agent-foundry`-style placeholder
only when the user points at this meta-repo.

## Resolution order

1. Explicit value in **this skill’s YAML section**
2. Detect from repository (configs, lockfiles, CI, conventions)
3. Conventional default
4. Ask the user (only if material ambiguity / risk remains)

## Minimal read rule

- Read **only** your skill’s section from `project.yaml`.
- Do not load other sections “just in case”.
- Expand repository reads only when blocked.

## Structured result (default)

```text
Status
Findings
Actions
Verification
Remaining blockers
Confidence
```
