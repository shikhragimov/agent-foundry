---
name: angels-advocate
description: >-
  Steelmans and defends challenged decisions against criticism from chat,
  reviewers, or /devils_auditor. Separates fair hits from weak attacks; keeps
  warranted concessions. Use when the user invokes /angels_advocate, asks to
  steelman a decision, or defend a design under critique.
disable-model-invocation: true
---

# Angel’s Advocate

Invoke: **`/angels_advocate`**

Counterpart to Devil’s Auditor: **defend** the decision under fire — strongest
honest case, not cheerleading. (Same job people call *steelman*.)

## Bindings

Read **only** `.agent/project.yaml` → `angels_advocate`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `critique` | Prior critique to answer | `reports/devils_audit.md` if present; else chat critique |
| `decision` | Optional note of what is being defended | Infer from chat |
| `output` | Defense report path | `reports/angels_advocate.md` |

## Workflow

1. State the **decision / claim** being defended (one paragraph).
2. Load critique sources (chat, external review, bound `critique` file). List
   attacks as discrete points.
3. For each attack:
   - **Concede** if fair and material (say what changes).
   - **Refute** with evidence (code, constraints, tradeoffs, requirements).
   - **Reframe** if the critic optimizes a different objective — make the
     objective conflict explicit.
4. Give the **strongest steelman** of the original decision: why a reasonable
   team would still choose it under stated constraints.
5. End with: keep / amend / revisit — and which critique points remain open.
6. Do not “win” by ignoring real risks. Do not implement code unless asked.

## Autonomy

- Report-first advocacy. Evidence over rhetoric.
- No silent scope change of the original decision.

## Result

```text
Status: defended | partially-conceded | withdrawn-recommendation
Findings: point-by-point (concede / refute / reframe)
Actions: report path
Verification: evidence cited
Remaining blockers: open critique items
Confidence
```
