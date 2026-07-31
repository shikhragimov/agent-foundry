---
name: pre-committer
description: >-
  Runs the project pre-commit command, fixes failures, and re-runs until clean
  or blocked. Use when the user invokes /pre_committer or asks to prep for commit.
disable-model-invocation: true
---

# Pre-Committer

Invoke: **`/pre_committer`**

Make the tree pass pre-commit checks. Fix only what hooks require.

## Bindings

Read **only** `.agent/project.yaml` → `tools.pre_commit`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `command` | Ready-to-run pre-commit command | Detect `.pre-commit-config.yaml` → `pre-commit run --all-files` (prefix with `uv run` / `poetry run` if that is the project norm) |

## Workflow

1. Resolve `command` (binding → detect → ask if still unclear).
2. Review relevant diff for obvious breakages (optional, keep light).
3. Run the command.
4. On failure: fix root cause (format, lint, types, trivial bugs hooks expose).
5. Re-run until green or the same failure repeats without a safe fix.
6. Do **not** create a git commit unless the user explicitly asks.

## Autonomy

- May edit files to satisfy hooks.
- Must not skip hooks (`--no-verify`) or disable checks permanently without asking.

## Result

```text
Status: green | failed | blocked
Findings: hook failures
Actions: fixes applied
Verification: last pre-commit result
Remaining blockers
Confidence
```
