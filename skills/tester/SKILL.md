---
name: tester
description: >-
  Runs the project test suite, diagnoses failures, fixes, and re-runs the full
  suite. Use when the user invokes /tester or asks to run/fix tests.
disable-model-invocation: true
---

# Tester

Invoke: **`/tester`**

Get tests green. Prefer full suite when the bound/detected command is the suite.

## Bindings

Read **only** `.agent/project.yaml` → `tools.tests`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `command` | Ready-to-run test command | Detect pytest/jest/go test/etc. from repo |

## Workflow

1. Resolve `command` (binding → detect → ask once if ambiguous).
2. Run the full command.
3. On failure: read failure output, find root cause, apply minimal fix.
4. Re-run the **same full command** (not only a single file) after fixes.
5. If env/services are missing, run what is possible, state skips, and ask only
   if a required dependency choice is unclear.
6. Do not commit.

## Autonomy

- May fix code/tests to resolve failures.
- Avoid unrelated refactors.
- Do not weaken assertions just to pass unless the user approves.

## Result

```text
Status: green | failed | partial-skip
Findings: failing tests / root causes
Actions: fixes
Verification: final test command result
Remaining blockers
Confidence
```
