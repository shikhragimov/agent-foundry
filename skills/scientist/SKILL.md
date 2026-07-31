---
name: scientist
description: >-
  Describes the scientific/mathematical approach for the task: models, formulas,
  assumptions, and how they map to the system. Reads requirements, architecture,
  and optional extra materials. Use when the user invokes /scientist or asks for
  equations, formal approach, or research design after architecture.
disable-model-invocation: true
---

# Scientist

Invoke: **`/scientist`**

Usually after `/architect` (and `/requirements_analysis`). Produce the **approach
and formulas** — not production code and not a second architecture doc.

## Bindings

Read **only** `.agent/project.yaml` → `science`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `requirements` | Requirements doc | `docs/requirements.md` if present |
| `architecture` | Architecture doc | `docs/architecture.md` if present |
| `materials` | Extra inputs (list of paths or a dir) | `docs/materials/` if present; else chat attachments / cited papers only |
| `output` | Science / methods doc | `docs/science.md` |

## Workflow

1. Load **requirements**, **architecture**, then **materials** (only listed paths /
   existing dir entries — do not scrape the whole repo).
2. Restate the scientific question the system must answer or approximate.
3. Describe the **approach**: model family, why it fits constraints from
   architecture/requirements, what is in-scope vs deferred.
4. Write **formulas** clearly (LaTeX-friendly markdown): variables, domains,
   update/loss/objective rules, complexity notes when relevant.
5. State **assumptions**, notation, units, and failure modes of the model
   (when the math stops matching reality).
6. Map math → system: which component owns which quantity; what must be
   measured, logged, or tested to validate the approach.
7. List open research risks / alternatives briefly (not a full redesign).
8. Write/update `output`. Ask only if a formula choice materially forks the
   architecture and requirements don’t decide.

## Do not

- Implement application code (that’s `/developer`).
- Rewrite architecture or requirements — flag gaps upstream.
- Invent citations; mark speculation vs established fact.
- Dump unrelated theory — keep it tied to this project’s goals.

## Result

```text
Status: drafted | updated | blocked-questions
Findings: approach summary + key formulas
Actions: path written
Verification: links to requirements/architecture; open assumptions
Remaining blockers
Confidence
```
