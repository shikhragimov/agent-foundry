---
name: status
description: >-
  Reports concise read-only status of a running program, script, job, training
  run, or similar workload. Backend is project-dependent (local process,
  scolab-cli, ssh, kubectl, etc.). Use when the user invokes /status or asks
  for runtime/ops status of something currently running.
disable-model-invocation: true
---

# Status

Invoke: **`/status`**

Read-only snapshot of what is running (or supposed to be). Be brief.

## Bindings

Read **only** `.agent/project.yaml` → `operations` (shared with job operator).

| Key | Meaning | Fallback |
|-----|---------|----------|
| `backend` | How to inspect: `local` / `scolab` / `ssh` / `kubectl` / project CLI | Detect from repo, terminals, chat context; ask if ambiguous |
| `target` | What to check: job, run id, process name, script, deployment | User mention → `job` → notable active work → ask |
| `job` | Alias for `target` (legacy / k8s Job name) | same as `target` |
| `namespace` | K8s namespace when `backend` is kubectl | current context default if unambiguous; else ask |
| `host` | Remote host when `backend` is ssh | ask if needed |
| `cwd` / `command` | Local working dir / how the process was started | detect from terminals / project docs |

Extra keys are allowed if the project’s ops CLI needs them; ignore unknown keys silently.

## Workflow

1. Resolve **target** (binding → user/chat → active terminals/jobs → ask once).
2. Resolve **backend** (binding → repo/ops docs → how this project usually runs → ask once).
3. Inspect with the matching read-only tooling, for example:
   - **local** — terminals folder, process list, log/output files for that run;
   - **scolab** — project’s `scolab-cli` (or documented alias) status/logs;
   - **ssh** — remote process/logs via ssh on the bound host;
   - **kubectl** — jobs/pods/deployments/events in the namespace;
   - **other** — project’s ops CLI if clearly documented or detected.
4. Summarize health: running / succeeded / failed / stuck / unknown; include
   age, restarts, last error, progress (epoch, step, %) when available.
5. Do **not** restart, kill, delete, apply, or otherwise mutate.
6. If access is missing, report that clearly and stop.

## Autonomy

- Read-only. No mutations.

## Result

```text
Status: healthy | degraded | down | idle | no-access
Findings: target, backend, short state (table or bullets)
Actions: none (read-only)
Verification: commands / sources used
Remaining blockers
Confidence
```
