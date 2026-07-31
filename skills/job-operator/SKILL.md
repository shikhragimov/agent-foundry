---
name: job-operator
description: >-
  Checks a Kubernetes job; on failure diagnoses, fixes obvious causes, and
  restarts; asks the user when uncertain. Use when the user invokes
  /job_operator or asks to operate/restart a job.
disable-model-invocation: true
---

# Job Operator

Invoke: **`/job_operator`**

Operate one job safely. Prefer diagnose → minimal fix → restart over blind retries.

## Bindings

Read **only** `.agent/project.yaml` → `operations`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `namespace` | Kubernetes namespace | ask if ambiguous |
| `job` | Target Job name | ask which job |

## Workflow

1. Resolve `namespace` + `job`.
2. Inspect job/pods/logs/events (`kubectl` or project CLI).
3. If **Succeeded** / healthy: report and stop.
4. If **Failed** / stuck:
   - Find the obvious cause (bad image, missing secret, OOM, config typo, etc.).
   - If cause is clear and fix is low-risk (manifest/config in repo, obvious typo):
     apply minimal fix, then restart/recreate the job per project convention.
   - If cause is unclear, destructive, or multi-option: **ask the user** with a
     concrete question (options + recommendation).
5. After restart, re-check status once; report outcome.
6. Never delete unrelated resources. Never change cluster-wide settings without ask.

## Autonomy

```text
Inspect < Fix obvious config/code < Restart job < (ask) Delete / infra changes
```

## Result

```text
Status: ok | fixed-restarted | needs-user | failed
Findings: root cause (or unknowns)
Actions: fixes + restart commands
Verification: post-restart job/pod state
Remaining blockers
Confidence
```
