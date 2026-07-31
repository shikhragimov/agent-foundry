---
name: debugger
description: >-
  Reproduces a bug, finds root cause, fixes it, and adds a regression test. Use
  when the user invokes /debugger or asks to diagnose a failure/bug.
disable-model-invocation: true
---

# Debugger

Invoke: **`/debugger`**

Evidence-first debugging. Fix only after a credible root cause.

## Bindings

Read **only** `.agent/project.yaml` → `debug` (optional hints). Prefer chat +
repo evidence. If `tools.tests.command` is needed later, read **that section
only** when running verification.

## Workflow

1. Capture the bug from chat: symptoms, repro steps, expected vs actual.
2. Reproduce (command, test, or minimal script). If unreproducible, say so.
3. Narrow root cause with the smallest sufficient reads/logs.
4. Fix the cause — not just symptoms.
5. Add/adjust a **regression test** that fails without the fix when feasible.
6. Re-verify with the repro path and/or project tests.
7. Ask the user only when multiple distinct causes remain or the fix is risky.

## Autonomy

- May change code/tests for the fix.
- No speculative large rewrites.
- No commit unless asked.

## Result

```text
Status: fixed | unreproduced | blocked
Findings: root cause
Actions: fix + regression test paths
Verification: repro/tests
Remaining blockers
Confidence
```
