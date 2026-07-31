---
name: devils-auditor
description: >-
  Adversarial review: finds false claims, unfinished work, weak spots, and
  failure scenarios; writes a devil's-audit report. Use when the user invokes
  /devils_auditor or wants a red-team style audit.
disable-model-invocation: true
---

# Devil’s Auditor

Invoke: **`/devils_auditor`**

Assume the happy path is wrong. Hunt false confidence.

## Bindings

Read **only** `.agent/project.yaml` → `devils_audit`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `audit` | Prior audit report to attack | `reports/audit.md` if present |
| `output` | Devil’s audit report path | `reports/devils_audit.md` |

Optionally skim chat + the prior audit. Do **not** load unrelated YAML sections.

## Workflow

1. Read prior audit (if any) and claimed “done” items from chat/requirements.
2. Actively search for:
   - false or overstated claims
   - unfinished / stubbed behavior
   - missing edge cases and failure modes
   - tests that don’t prove the requirement
   - single points of failure, race/error-handling gaps
   - docs that hide risk
3. Propose concrete break scenarios (how it fails in prod).
4. Write `output`. Prefer evidence (paths, commands, missing tests) over vibes.
5. Do not fix by default — expose risk. Fix only if asked.

## Autonomy

- Report-first, adversarial tone OK if evidence-backed.
- No drive-by refactors.

## Result

```text
Status: reported
Findings: false claims / gaps / break scenarios
Actions: report path
Verification: evidence strength
Remaining blockers
Confidence
```
