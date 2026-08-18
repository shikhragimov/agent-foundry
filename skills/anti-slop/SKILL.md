---
name: anti-slop
description: >-
  Scans code and project docs for AI slop and low-quality filler; proposes what
  to delete or rewrite. Also hunts stale generated docs/data, verbose LLM
  prose, fawning, and unprofessional agent junk that should not be committed.
  Use when the user invokes /anti_slop or asks to remove AI-generated junk,
  bloat, or non-human code smell before review/merge.
disable-model-invocation: true
---

# Anti-Slop

Invoke: **`/anti_slop`**

Hunt AI-generated filler and project junk that should not survive in serious
code. **Report-first** — propose deletes/rewrites; do not mass-edit unless the
user asks after the report.

Goal: code and docs that a skeptical reviewer would not dismiss as:

> I've validated that it's slop, and likely a big security risk. Lines of code
> is not a good measurement of quality, especially when it comes to something
> that could be a security disaster, like an internet browser.
>
> One commit with 44k+ lines, this read me, the write up in this post,
> everything is screaming AI slop
>
> What is this total abomination of AI slop.

Volume is not quality. Marketing README + giant dump ≠ a project.

Agents over-produce. Cut generated docs and data that nobody asked for
and that will rot; local one-offs that should not be committed; lectures
where a short sentence would do. Prefer **delete**. Be laconic. Do not
commit unless asked.

---

## Bindings

Read **only** `.agent/project.yaml` → `anti_slop`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `scope` | Paths/globs | chat → recent diff / focused dirs — not the whole monorepo unless asked |
| `output` | Report path | `reports/anti_slop.md` |

---

## Workflow

1. Resolve scope (chat → binding → recent diff / new files → ask if huge).
2. Sample code, tests, configs, docs, comments, dumps the agent just added.
   Cite path + short snippet. If a careful human would not commit it →
   **Remove**. If it only restates code or the previous sentence → Remove
   or Rewrite shorter.
3. Score against the catalog. Skip taste nits a careful human might write.
4. Each finding: **Remove** / **Rewrite** / **Keep** (reason).
5. Order: should-not-commit > stale generated docs/data > verbosity >
   fawning > theater.
6. Write `output` + a delete/rewrite checklist by impact.
7. Clean up only if asked. No drive-by refactors.

---

## Catalog

Flag when there is no strong project-specific reason.

### Surplus artifacts (don't commit)

Agents pad the tree. Delete if unasked-for, already true in code, or
stale the next time the code moves:

- Extra markdown: READMEs, changelogs, guides, architecture essays that
  restate the file tree, session notes, “what I did”
- Generated data dumps, sample outputs, plots, caches left in the repo
- Local one-offs: scratch scripts, personal helpers, experiment leftovers
- Scaffold: empty packages, stubs, placeholder pages, demo as production
- Duplicate helper/util/manager layers that only forward calls
- Mega dumps that invent a surface nobody requested

### Verbose AI prose

Default LLM voice is a lecture. Cut until it is dry and short.

- A paragraph that repeats the last paragraph or the code beside it
- Narrating comments (`# increment counter`); docstrings that restate
  the signature
- Chat residue: “Let’s…”, “I’ll now…”, “Here we…”, “Note that…”,
  “In conclusion…”, “It is important to note…”
- Inflated names: `Enhanced`, `Advanced`, `Improved`, `Ultimate`, `Helper2`
- Emoji headers, horizontal rules, bold-everything
- Marketing words with no contract: “seamless”, “robust”, “comprehensive”,
  “enterprise-grade”, “leverage”, “utilize”

### Fawning & unprofessional

Tone that belongs in a chatbot, not a repo:

- Sycophancy: “Great question”, “You’re absolutely right”, “Happy to help”,
  “I hope this helps”, “Feel free to…”
- Hedging and apology as filler; performative warmth; “as an AI…”
- Over-polite or salesy README; emoji/exclamation where a dry sentence
  would do
- Agent scratch left in files: status recaps, “what I did”, TODO-as-diary

### Theater (looks finished, isn’t)

- Catch-all try/except that swallows or only logs
- Tests that assert mocks/constants, not behavior; snapshot theater
- Types/factories/DI for a single impl
- Copy-pasted retry/logging; one-function microfiles; service/repository
  layers on a script
- Handwavy auth/crypto/parsing; “security” comments instead of controls

---

## What not to flag

- Dense domain logic that is ugly but intentional
- Brief comments that explain *why*
- Docs a human maintains as the contract (API, ops runbook) — not a restatement
- Existing project voice and patterns
- Marked generated paths; mechanical vendor/lockfile/codegen diffs

If unsure: **Keep** + note the doubt. Do not rewrite for style alone.

---

## Report format

```markdown
# Anti-slop report

## Scope
## Verdict
one paragraph: don't-commit / stale docs / verbosity — what to delete first

## Findings
### [Remove|Rewrite|Keep] path — short title
- Evidence:
- Why it reads as agent slop:
- Suggested action:

## Delete / rewrite checklist
ordered by impact

## Left alone on purpose
optional
```

---

## Result

```text
Status: reported | cleaned
Findings: Remove / Rewrite / Keep counts; top deletes
Actions: report path; files changed if cleaned
Verification: scope covered
Remaining blockers
Confidence
```

---

## Autonomy

- Write the report. Edit the tree only if asked.
- Never treat lines-of-code, file count, or “completeness” as quality.
