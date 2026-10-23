# Skills registry

Portable skills from this repo. Installed via `./scripts/install-skills.sh` as **copies** into `~/.cursor/skills` (Cursor) and `~/.gemini/config/skills` (Antigravity/Gemini). Does not touch `~/.cursor/skills-cursor`. Symlinks are avoided for skills because Cursor/Antigravity often fail to discover them. Source of truth: `<repo>/skills/` (no project `.cursor/skills` mirror).

| Skill | Slash | Binding (`.agent/project.yaml`) | What it does | Autonomy | Notes |
|-------|-------|----------------------------------|--------------|----------|-------|
| sharpen | `/sharpen` | — | Adaptive design interview: resolve ambiguity, challenge assumptions, shared understanding before implementation | Interview only; no implementation | Modes: Quick / Standard / Deep; one question at a time |
| requirements-analysis | `/requirements_analysis` | `requirements` | Goal, scope, constraints, scenarios, edge cases → requirements file | Write requirements doc only | Default output: `docs/requirements.md` |
| architect | `/architect` | `architecture` | Requirements → design decision + implementation plan | Write architecture doc; no app code | After requirements, before developer; default `docs/architecture.md` |
| scientist | `/scientist` | `science` | Approach + formulas; maps math to system | Write science doc; no app code | Reads requirements, architecture, optional `materials` → `docs/science.md` |
| ui-ux | `/ui_ux` | `ui_ux` | UI/UX design or review for game / web / infographic | Write UI doc or review; no app code | Medium auto-detect; default `docs/ui.md` / `reports/ui_review.md` |
| developer | `/developer` | `development` | Implements task; edits code + needed tests | Modify code/tests; no commit | Prefer repo detection; use `docs/architecture.md` if present |
| pre-committer | `/pre_committer` | `tools.pre_commit` | Run pre-commit, fix, re-run until green | Fix for hooks only; no `--no-verify` | Distinct from legacy `pre-commiter` (one *t*) still in `~/.cursor/skills` |
| tester | `/tester` | `tools.tests` | Full test suite → diagnose → fix → re-run full suite | Fix code/tests; don’t weaken asserts | Uses ready-to-run `command` from YAML |
| debugger | `/debugger` | `debug` | Repro → root cause → fix → regression test | Fix + regression test; no commit | Evidence-first; ask if cause unclear |
| auditor | `/auditor` | `audit` | Align requirements / architecture / code / tests / docs → report | Report-first; no fix by default | Output default: `reports/audit.md` |
| devils-auditor | `/devils_auditor` | `devils_audit` | Adversarial review: false claims, stubs, break scenarios | Report-first | Often follows `/auditor`; output `reports/devils_audit.md` |
| angels-advocate | `/angels_advocate` | `angels_advocate` | Steelmans / defends decisions under critique | Report-first | Pair with `/devils_auditor`; concede fair hits |
| security-reviewer | `/security_reviewer` | `security_review` | Threat-focused security review → report | Report-first; no fix by default | Not Cursor’s built-in `/review-security` subagent |
| anti-slop | `/anti_slop` | `anti_slop` | Hunt AI filler, stale generated docs/data, verbose prose, fawning; propose delete | Report-first; cleanup only if asked | Output default: `reports/anti_slop.md` |
| status | `/status` | `operations` | Runtime status of a run/job/process (local, scolab, ssh, kubectl, …) | **Read-only** | Backend from binding or project detect |
| job-operator | `/job_operator` | `operations` | Diagnose failed job; obvious fix + restart; else ask | Inspect < fix < restart; ask before risky | Uses `operations.namespace` + `operations.job` |
| automize-ai | `/automize_ai` | `automize_ai` | Mine last chat for a repeated mechanical loop → tool in bound `output` | Write tool only; user reviews; no commit | Output path from YAML only; form follows the loop (script, plots, canvas, …) |
| update-llm-benchmarks | `/update-llm-benchmarks` | — (this repo file) | Refresh `LLM_models_benchnmarks.md` from public leaderboards | Writes that markdown file | English table; bold top-3 per column |

## Shared conventions

- **Thin skills:** logic in `SKILL.md`; project specifics only in `.agent/project.yaml` (skill reads **its section only**).
- **Resolution:** binding → repo detect → defaults → ask user.
- **Result shape:** Status / Findings / Actions / Verification / Remaining blockers / Confidence.
- **Meta (not a skill):** `skills/_portable/BINDING.md` — not linked to `~/.cursor`.

## Also in `~/.cursor/skills` (not from this registry)

| Entry | Status |
|-------|--------|
| `auditor-legacy-graph-memory` | Old local auditor (renamed backup) |
| `pre-commiter` | Old local pre-commit skill (single *t*) |
