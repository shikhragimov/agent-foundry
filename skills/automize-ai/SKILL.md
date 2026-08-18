---
name: automize-ai
description: >-
  Mines recent agent chat for a repeated mechanical workflow and writes a
  re-runnable project-local tool into the bound output directory. Use when the
  user invokes /automize_ai, asks to automate the last conversation, or to
  capture a frequent agent task (reports, metrics, plots, canvas, harvest) as
  something they can re-run.
disable-model-invocation: true
---

# Automize AI

Invoke: **`/automize_ai`**

Turn a thing the user keeps asking the agent to do into a **project-local**
artifact they can re-run. The loop can be anything this repo actually does —
commands, plots, a canvas, a report — not a new portable skill.

User reviews the result. Do not commit.

---

## Bindings

Read **only** `.agent/project.yaml` → `automize_ai`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `output` | Directory for captured tools | **ask** — do not guess a folder name |

If `output` is missing, stop and ask. Do not hardcode a default path.

Do not invent a portable skill for the captured loop. It stays under `output`.

---

## Resolve what to capture

Pick **one** workflow:

1. User named it (or listed steps) → that.
2. Else this chat already did real work before `/automize_ai` → that work.
3. Else the previous conversation in this workspace (not this invocation),
   using whatever history is already available — do not assume an IDE's
   on-disk chat layout.
4. If still empty → ask once.

Ignore the automize request itself. If several repeats exist, pick the most
recent **mechanical** one and mention the others.

---

## What to automate vs leave

**Automate** — same shape every time; the agent re-derives how.

Examples of shape (not an allowlist): fetch/compute current numbers; the
usual charts or canvas; a status+report pack; a harvest/export; a shell or
notebook the agent pastes again.

**Do not automate** — a new judgment call each time: next experiment,
architecture debate, one-off exploration, unique bug hunts.

Split: *«покажи метрики / графики как всегда»* → yes. *«что запускать
дальше»* → no.

---

## Mine sources (don't dump)

Current chat first. Then only enough to reconstruct the **working** sequence.

1. **This chat** — the user ask plus the steps that actually succeeded
   (whatever tools those were).
2. **Earlier turns** in this workspace, if needed and already reachable.
3. **Repo files the chat already used** — helpers, notebooks, tools
   already under `output`. Detect; don't assume a log filename convention.

Never copy secrets or `.env` into the tool. Parameterize what varies
(ids, dates, hosts, paths).

---

## Prefer update in `output`

Before writing anything, list the bound `output` directory.

If a tool there already does this workflow (same user ask, same
entrypoint, overlapping README) → **update that tool in place**:
entrypoint, README, `INDEX.md` line. Do not create a sibling folder.

Same job with a new wrinkle (extra plot, new flag, different source) →
extend the existing tool. Only create a new `<tool-name>/` when nothing
in `output` covers it. If two folders could match, pick the closer one;
if unclear, ask once.

---

## Distill

| Piece | Meaning |
|-------|---------|
| User ask | Recurring request in their words |
| Stable steps | The sequence that worked last time |
| Varies | CLI args / env — infer from what changed across runs |
| Already exists | Call it; don't rewrite |
| One-off inline | Extract into the tool |
| Out of scope | Judgment, not mechanics |

Prefer wrapping what already worked over a new architecture. Encode the
repeatable loop (commands, plot recipe, canvas spec) — not a framework.

Form follows the loop:

- commands → script (or thin wrapper around existing scripts)
- charts / canvas → generator that rebuilds that view
- mixed → small folder with a README and one entrypoint

---

## Write the tool

Create **or update** under **bound** `output` only:

```text
<output>/<tool-name>/
  README.md      # what, how to run, args, assumptions, not-in-scope
  <entrypoint>   # script, notebook, canvas recipe — whatever matches
  INDEX.md line  # one line in <output>/INDEX.md
```

`tool-name`: short kebab-case from the ask.

**README.md:** how to run, required args, assumptions, source (chat date),
what it does **not** do.

**Entrypoint:** give the script arguments for anything that changes
next time (a job name, id, path, date). Infer them from the chat —
don't hardcode the last run's value. Call existing project code;
extract pasted one-offs into files. Fail loud if this workflow's
prerequisites are missing. No production refactors. No new foundry skill
unless asked.

Do not run a destructive capture. A cheap dry-run / `--help` is ok.

---

## Autonomy

- Write only under bound `output` (plus `INDEX.md` there).
- Do not modify app code unless the captured loop already required it.
- Do not commit.
- Stop for review. If the loop is still a judgment call, report that and
  write nothing.

---

## Result

```text
Status: captured | updated | skipped-judgment | blocked
Findings: path — one sentence: what the script does
Actions: how to run, with args
Verification: dry-run / --help if any
Remaining blockers
Confidence
```
