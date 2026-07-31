---
name: auditor
description: >-
  Checks alignment of requirements, architecture, implementation, tests, and
  docs; writes an audit report. Use when the user invokes /auditor or asks for
  a compliance/architecture audit.
disable-model-invocation: true
---

# Auditor

Invoke: **`/auditor`**

Cross-check that the system matches what it claims. **Report-first** — do not
fix unless the user asks after the report.

## Bindings

Read **only** `.agent/project.yaml` → `audit`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `requirements` | Requirements doc path | `docs/requirements.md` if present |
| `architecture` | Architecture doc path (from `/architect`) | `docs/architecture.md` if present |
| `output` | Audit report path | `reports/audit.md` |

## Workflow

1. Load bound requirements/architecture files if they exist; otherwise discover
   closest equivalents (README, features docs) without boiling the ocean.
2. Sample implementation + tests for the scoped area (chat scope, or whole
   stated feature if clear).
3. Check: requirements ↔ code ↔ tests ↔ docs/architecture contradictions,
   missing acceptance coverage, dead claims, undocumentated critical behavior.
4. Severity: Critical / Major / Minor / Info.
5. Write `output` report. Do not commit. Do not “fix everything” by default.

## Autonomy

- Read-heavy; write the report file.
- Code changes only if the user explicitly asks to remediate after review.

## Result

```text
Status: reported
Findings: counts by severity + top issues
Actions: report path
Verification: scope covered
Remaining blockers
Confidence
```
