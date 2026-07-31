---
name: developer
description: >-
  Implements the current task in the repository: changes code and adds needed
  tests. Use when the user invokes /developer or asks to implement a feature/fix.
disable-model-invocation: true
---

# Developer

Invoke: **`/developer`**

Implement the task from chat (and requirements if bound). Keep diffs focused.

## Bindings

Read **only** `.agent/project.yaml` → `development`.

| Key | Meaning |
|-----|---------|
| optional notes | Language/layout hints only if detection fails |

Prefer repo detection (README, lockfiles, `pyproject.toml`, `package.json`, etc.)
over bindings. Language may be hinted by a meta-repo placeholder only if the user
points there — never assume.

## Workflow

1. Confirm goal from chat. If present, skim requirements and/or architecture
   docs (`docs/requirements.md`, `docs/architecture.md` or bound paths) — those
   files only, not unrelated YAML sections.
2. Locate the smallest set of files to change; follow the architecture plan when one exists.
3. Implement; match existing style and patterns.
4. Add/update tests for the change when the project has a test suite.
5. Run a narrow verification command if obvious (detect or ask once).
6. Stop when acceptance criteria for this task are met or blocked.

## Autonomy

- May modify application code and tests.
- Do **not** commit, push, force-push, or change infra unless asked.
- Do not drive-by refactor unrelated files.

## Result

```text
Status: done | partial | blocked
Findings
Actions: files changed
Verification: commands/tests run
Remaining blockers
Confidence
```
