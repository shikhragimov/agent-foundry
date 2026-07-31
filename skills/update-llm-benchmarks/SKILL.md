---
name: update-llm-benchmarks
description: >-
  Updates LLM_models_benchnmarks.md with current frontier model scores and
  use-case notes. Use when the user asks to refresh, update, or rebuild the LLM
  benchmarks table, compare recent models (Grok, Fable, Sol, Terra, Opus,
  Gemini, etc.), or sync model leaderboard data into that file.
---

# Update LLM models & benchmarks

Refresh `LLM_models_benchnmarks.md` in this repo with current public benchmark
data. Keep the existing file structure; do not invent a new layout unless the
user asks.

## Target file

Resolve path relative to this skill / repo root:

- Primary: `LLM_models_benchnmarks.md` (repo root of `agent-foundry`)
- If missing: create it using the structure below

## Workflow

1. **Read** the current `LLM_models_benchnmarks.md` end-to-end.
2. **Parse** existing columns, models, footnotes, and section order. Preserve
   column set unless a benchmark is clearly obsolete or the user asks to change
   it.
3. **Fetch fresh data** (web search + fetch official / aggregator pages). Prefer
   primary sources over blogs. Record the date of the refresh.
4. **Merge models**:
   - Update scores for every model already in the table.
   - Add new frontier models that belong in a top-~15 list (see selection rules).
   - Drop or demote only if clearly superseded *and* outside top ~15; prefer
     keeping historical names if still widely used in Cursor / APIs.
5. **Rewrite the file in English** (body, headers, comments, takeaways).
6. **Bold top-3** numeric values **per benchmark column** (highest wins). Ties:
   bold all tied for a top-3 slot.
7. Use `—` for missing / non-comparable scores. Never invent numbers.
8. Briefly tell the user what changed (new models, big rank moves, data gaps).

## Required table structure

Keep this shape (column names may evolve only with user approval):

```markdown
# LLM models & benchmarks

Updated: **YYYY-MM-DD**. Scores are public max/high settings where stated.
**Bold** = top 3 in that column. `—` = no comparable public figure.

Sources: [links…]

| Model | Lab | AA Index ↑ | Arena Elo ↑ | SWE-Pro % ↑ | Term-Bench 2.1 % ↑ | Agents' Last Exam % ↑ | Best for | $/M in·out | Ctx |
|---|---|---:|---:|---:|---:|---:|---|---|---|
| … | … | … | … | … | … | … | … | … | … |

### How to read the benchmarks
- short bullet per column

### Short takeaways
- 3–5 bullets
```

Optional footnotes after the table for methodology caveats (e.g. index version
drift, harness mismatch on SWE-Pro).

## Model selection (target ~15 rows)

Include a balanced frontier set when data exists:

- Anthropic: Fable / Mythos / latest Opus / Sonnet
- OpenAI: latest GPT flagship tiers (e.g. Sol / Terra / Luna) + prior flagship if still relevant
- xAI: latest Grok
- Google: latest Gemini Pro
- Plus strong contenders from Arena / AA Index (Kimi, Muse, GLM, Sakana, etc.)

Prefer models that agents actually pick in Cursor or major APIs. Cap near 15
unless the user asks for more.

## Data sources (check in this order)

1. Artificial Analysis Intelligence Index / model leaderboard  
   https://artificialanalysis.ai/
2. LMArena / Chatbot Arena text leaderboard  
   https://arena.ai/leaderboard/text
3. Lab posts / model cards (OpenAI, Anthropic, Google DeepMind, xAI, …)
4. Aggregators for coding boards when needed: BenchLM SWE-Pro / SWE-Verified  
   https://benchlm.ai/

Cross-check conflicting numbers; prefer the lab’s own eval table or AA/Arena
over secondary blogs. If sources disagree, pick one, footnote the conflict.

## Scoring rules

- Use the strongest publicly reported setting (max / xhigh / thinking) unless the
  file already standardizes on another tier — then stay consistent and note it.
- Do not mix incompatible harnesses silently; if SWE-Pro setups differ, keep
  published figures but mention the caveat in footnotes / takeaways.
- Pricing: API $/M input·output when known (`5·30` style). Context: advertised
  window (`1M`, `500K`).
- **Best for**: one short English phrase (agents, SWE, cheap/fast, multimodal,
  writing/research, self-host, …).

## Editing discipline

- Laconic: dense table, short bullets — no essay.
- Do not delete unrelated sections the user added unless obsolete.
- Do not commit git changes unless the user asks.
- After writing, re-scan the table: every numeric column must have exactly the
  top-3 (or tied) cells bolded; no bold on non-top values.

## Done criteria

- [ ] File read before write
- [ ] English throughout
- [ ] Scores refreshed from current public sources
- [ ] New frontier models added when warranted
- [ ] Top-3 bolding correct per column
- [ ] Updated date + sources list present
- [ ] User got a short change summary
