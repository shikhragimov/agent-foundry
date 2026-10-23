---
name: ui-ux
description: >-
  Designs or reviews UI/UX for games, web, and infographics: hierarchy,
  composition, interaction density, interaction, and visual language. Writes a
  UI doc or review report. Use when the user invokes /ui_ux or asks for UI/UX
  design, HUD/layout critique, visual hierarchy, or presentation polish.
disable-model-invocation: true
---

# UI / UX

Invoke: **`/ui_ux`**

Medium-agnostic design skill for **games**, **web**, and **infographics**.
Produce a concrete presentation decision — not app code (leave that to
`/developer`).

Modes (pick from chat; default = design if no surface exists, else review):

| Mode | When | Output |
|------|------|--------|
| **design** | New surface / redesign brief | UI decision doc |
| **review** | Existing UI, screenshots, scenes, mockups | Critique report |

## Bindings

Read **only** `.agent/project.yaml` → `ui_ux`.

| Key | Meaning | Fallback |
|-----|---------|----------|
| `medium` | `game` / `web` / `infographic` / `auto` | Detect from repo (Godot/Unity → game; HTML/React → web; charts/notebooks → infographic); ask if tied |
| `requirements` | Requirements input | `docs/requirements.md` if present |
| `architecture` | Optional architecture | `docs/architecture.md` if present |
| `references` | Moodboards, shots, existing screens | chat attachments / paths named by user |
| `output` | Design doc path | `docs/ui.md` |
| `review_output` | Review report path | `reports/ui_review.md` |

## Workflow

1. Resolve **medium** and **mode**. Skim requirements / architecture / existing
   presentation code only as needed — do not reload the whole repo.
2. Restate the **job of the surface** in one sentence (who, what decision or
   action, in what context). If that is unclear, ask once.
3. Apply **core principles** below, then the **medium delta**.
4. **Design mode:** one primary direction + briefly rejected alternatives.
   Cover hierarchy, layout regions, density, interaction model, feedback,
   visual tokens (palette / type / motion), accessibility / readability,
   and an implementation sketch for `/developer` (ordered steps, touch files).
5. **Review mode:** findings ordered by impact (blocks understanding → clutter
   → taste). Each finding: severity + concrete fix. Do not mass-edit unless
   asked after the report.
6. Write `output` or `review_output`. Ask only when two directions are
   materially different and requirements don’t decide.
7. Do **not** implement presentation code in this skill.

## Core principles (all media)

- **One job per surface / section.** If a region does two jobs, split or cut.
- **Hierarchy first.** Brand/title/primary signal must win the first glance;
  supporting text loses to it on purpose.
- **Composition, not dashboard.** The first view reads as one composed picture
  unless the product *is* a dashboard/map/HUD that needs multi-panel density.
- **Reduce clutter.** Cut competing labels, badge piles, redundant chrome,
  decorative boxes that don’t carry meaning.
- **Real visual anchor.** Prefer product, place, data, or playfield over
  abstract filler gradients as the main idea.
- **Density matches tempo.** Slow reading (docs, charts) can be dense; fast
  play / scan needs fewer simultaneous signals.
- **Feedback is part of UX.** State changes (select, hit, error, load, win)
  need a clear signal; silence is a bug when the user acted.
- **Tokens over one-offs.** Define a small set of colors, type roles, spacing,
  motion — reuse; don’t invent a new look per widget.
- **Avoid AI-default looks** unless the brief asks for them: purple/indigo
  gradients; warm cream + serif + terracotta; broadsheet hairlines; dark +
  glow + pill chips + emoji chrome; multi-layer shadow stacks.
- **Preserve existing systems.** If a design system / art bible / HUD language
  already exists, extend it — don’t rebrand casually.

## Medium deltas

### Game

- Playfield wins; HUD serves, never steals the frame.
- Separate **world feedback** (VFX, audio, unit poses) from **chrome** (bars,
  menus). Prefer diegetic signals when they stay readable.
- Readability at play speed: contrast, silhouette, motion telegraph for
  threats/affordances; fog/camera must not hide critical interactables unfairly
  unless that *is* the mechanic.
- Camera, selection, and targeting are UX — document framing and dead zones.
- No direct “command the unit” chrome if the product forbids it; levers must
  match the control model (flags, decrees, build, …).
- First minutes: teach through layout and feedback, not a wall of tutorial text.

### Web

- Branded pages: brand is a hero-level signal, not only nav text.
- Landing / promo: first viewport ≈ brand + one headline + one support line +
  one CTA group + one dominant image/plane. No stats strips, schedule chips,
  or promo stickers on the hero.
- Full-bleed hero by default for promotional surfaces; avoid inset media cards
  in the hero unless the design system requires them.
- Cards only when they hold a real interaction; otherwise prefer open layout.
- Desktop and mobile both must work; state breakpoints that change hierarchy.
- Expressive type with purpose; avoid default Inter/Roboto/Arial/system stacks
  for marketing surfaces unless the system already mandates them.

### Infographic / data viz

- One narrative arc: question → evidence → takeaway.
- Data-ink over decoration; every ink mark must earn its place.
- Chart type matches the question (rank, part-to-whole, change over time,
  correlation) — don’t default to fancy charts.
- Prefer direct labels over remote legends when space allows.
- Annotation > ornament; call out the point the reader should not miss.
- Scales, units, and comparisons must be honest (no truncated-axis tricks
  unless explicitly labeled and justified).

## Design doc shape (`docs/ui.md`)

```markdown
# UI / UX — <surface name>

## Job of the surface
## Medium & constraints
## Direction (chosen)
## Rejected alternatives
## Hierarchy & layout
## Interaction & feedback
## Visual language (tokens)
## Medium-specific notes
## Implementation sketch (for /developer)
## Open questions
```

## Review report shape (`reports/ui_review.md`)

```markdown
# UI review — <surface>

## Scope
## Verdict
## Findings
### [blocker|major|minor] short title
- Evidence:
- Fix:
## Leave alone
## Checklist for /developer (optional)
```

## Result

```text
Status: drafted | reviewed | blocked-questions
Findings: medium, mode, top decisions or top issues
Actions: path written
Verification: maps to surface job / AC
Remaining blockers
Confidence
```

## Autonomy

- Write the design doc or review report.
- No presentation/app code unless the user explicitly asks after the doc/report.
- No drive-by rebrands of an existing visual system.
