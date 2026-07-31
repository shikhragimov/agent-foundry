---
name: requirements-analysis
description: >-
  Analyzes a task into goal, scope, constraints, scenarios, edge cases, and
  acceptance criteria; writes a requirements file. Use when the user invokes
  /requirements_analysis or asks to clarify/capture requirements.
disable-model-invocation: true
---

# Requirements Analysis

Invoke: **`/requirements_analysis`**

Turn the current chat task into clear, testable requirements. Portable — no
project-specific hardcoding.

## Bindings

Read **only** `.agent/project.yaml` → `requirements` (see `skills/_portable/BINDING.md` if present).

| Key | Meaning | Default if missing |
|-----|---------|-------------------|
| `output` | Path for the requirements doc | `docs/requirements.md` |

## Workflow

1. Use **chat context** as the task source (do not ask the user to restate it).
2. Infer goal, actors, in-scope / out-of-scope, constraints, assumptions.
3. List main scenarios + edge cases + failure modes.
4. Write **acceptance criteria** that are observable (Given/When/Then or bullets).
5. Ask clarifying questions **only** when choices materially change scope or risk.
6. Write/update the `output` file. Prefer merge/update over blind wipe if a prior
   requirements doc exists for the same task.

## Do not

- Implement code or run broad refactors.
- Load unrelated project docs unless needed to resolve a conflict.
- Invent requirements the user never implied — mark assumptions explicitly.

## Result

```text
Status: drafted | updated | blocked-questions
Findings: goal + scope summary
Actions: path written
Verification: acceptance criteria count / open questions
Remaining blockers
Confidence
```
