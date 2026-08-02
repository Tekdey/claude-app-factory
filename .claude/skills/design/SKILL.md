---
name: design
description: "Generate or revise the app's visual design system: propose 2-3 distinct art directions with rendered previews, let the user pick, then write docs/design/DESIGN.md, design tokens and voice.md. Used by /onboard and re-runnable anytime."
disable-model-invocation: true
argument-hint: "[revise|new]"
---

# /design — art direction and design system

Conduct all interaction with the user in the user's language (detect from their messages). All generated docs are written in the project's documentation language chosen during onboarding.

You are producing the visual identity that every future UI session will obey. A generic result here poisons every screen the agents build afterwards. Slow down, think like a design lead, and never show the user a candidate you have not critiqued first.

## Outputs

| File | Source template | Purpose |
|---|---|---|
| `docs/design/DESIGN.md` | `templates/docs/design.md` | The 9-section design system — law for all UI work |
| `docs/design/tokens.css` | contract below | Machine-readable tokens (shadcn CSS-variable contract) |
| `docs/design/voice.md` | `templates/docs/voice.md` | Tone of voice and UX-writing rules |
| `.claude/skills/brand/SKILL.md` (generated) | inline template below | Thin auto-trigger wrapper so the brand applies itself |
| `evidence/design-candidate-<n>.html` + `.png` | built in Phase 4 | Rendered previews, kept as history |

## Mode selection

- `$ARGUMENTS` = `new`, or `docs/design/DESIGN.md` does not exist → run the full flow (Phases 1-8).
- `$ARGUMENTS` = `revise`, or `DESIGN.md` already exists → ask what to change (one token? a component rule? the whole direction?). For token/rule tweaks: edit DESIGN.md + tokens.css + the brand skill in sync, rebuild one preview to show the effect, done. For a direction change: run the full flow, but present the current direction as one of the candidates so the user compares old vs new.

## Phase 1 — Gather inputs

Read, in this order (skip what does not exist):

1. `docs/product/brief.md`, `docs/product/prd.md`, `docs/product/personas.md` — product, audience, feature names. Previews in Phase 4 must use REAL feature and screen names from the PRD, never invented filler.
2. `context/brand/*` — **existing brand assets are LAW.** Extract the palette (name the hex values you see), fonts, logo shapes, and any brand guide rules. Candidates may interpret the brand, never contradict it.
3. `context/inspiration/*` — `love-*` files show desired qualities, `hate-*` files show what to avoid, `links.md` lists references. Describe each image to yourself and extract the qualities (density, warmth, contrast, shape language), not the literal pixels.
4. Onboarding design answers if this run was invoked from `/onboard` (aesthetic direction picked, color anchor, dark mode need, spacious vs dense, motion level, signature element wish, loved/hated apps).

If run standalone with no brief and no onboarding answers, ask first (AskUserQuestion when available, max 4 per call; otherwise numbered questions with lettered options): what the app does, 2-3 loved apps + 1 hated with why, aesthetic family (offer the taxonomy from `references/directions.md`), color anchor + dark mode, spacious vs dense + motion level. Every question offers "You decide" as an option.

## Phase 2 — Load the thinking tools

Read `references/aesthetics.md` (how to think: purpose/tone/constraints/differentiation, typography, color conviction, motion restraint) and `references/directions.md` (the taxonomy of aesthetic families used as generation seeds). Keep `references/anti-slop.md` for the critique pass in Phase 3.

## Phase 3 — Generate candidate directions (two-pass, mandatory)

**Pass 1 — draft.** Produce 2-3 candidate directions, **deliberately far apart from each other** (different families from `references/directions.md`, different temperature, different shape language — if two candidates could be confused in a thumbnail, replace one). Each candidate is:

- **A name** — evocative, project-specific (e.g. "Darkroom Ledger", not "Option B").
- **One sentence of intent** — what feeling it optimizes for and why it fits THIS product and audience.
- **A compact token set:**
  - 4-6 colors as named hex values with semantic roles (dominant surface, ink, primary action, one sharp accent, semantic danger; light AND dark values).
  - 2 type roles minimum with SPECIFIC named faces that are not on the banned list (characterful display + complementary body; optional mono/utility for data). State weights.
  - Spacing scale (base unit + steps), radius stance (one number or a deliberate mix), shadow/elevation stance, motion stance (none / one orchestrated moment / expressive — with durations).
  - **One signature element** — the single thing a user remembers 5 seconds after seeing one screen.

**Pass 2 — self-critique.** Before showing anything, run every candidate through `references/anti-slop.md`. Any candidate matching a known slop look, a banned identity font, or failing the positive tests gets revised or replaced. State to yourself what you changed and why. Only then present.

## Phase 4 — Rendered previews (show, don't describe)

For each surviving candidate, build `evidence/design-candidate-<n>.html`:

- One self-contained file: all CSS inline, fonts via Google Fonts / Fontshare `<link>` (fine for a local preview) with the full fallback stack declared.
- 2-3 realistic screens of THIS app side by side (e.g. its actual main list, its actual detail view, its actual empty state) using real feature names and realistic data from the PRD. No lorem ipsum, no "Feature One".
- Both light and dark rendered on the same page (two columns or stacked sections).
- The signature element must be visible.

Render and capture each preview to `evidence/design-candidate-<n>.png`:

- Web/browser MCP available (e.g. Playwright): navigate to the `file://` URL, screenshot.
- Otherwise: any available preview/screenshot capability of the environment.
- Nothing available: keep the HTML files, tell the user to open them in a browser (give the absolute paths), and continue once they have looked.

## Phase 5 — The user picks

Present the candidates: name, one-line intent, preview path/screenshot for each. Use AskUserQuestion when available with one option per candidate plus "Mix elements" and "None — try a different direction". Then ask for tweaks (color warmer? denser? different display face?). Apply tweaks to the chosen candidate, regenerate its preview and screenshot, confirm. Iterate until the user says it's right — this is the cheapest moment to change direction; after this it is law.

## Phase 6 — Emit the design system

1. **`docs/design/DESIGN.md`** from `templates/docs/design.md` — fill all 9 sections (theme & atmosphere; palette table with light/dark/role/usage; typography with fallback stacks; components; layout & spacing; depth & elevation; motion; guardrails incl. the signature element and anti-slop reminders; agent guide for composing new screens). Record the loved/hated references and the rejected candidates' names in section 1 so future sessions know what was already considered.
2. **`docs/design/tokens.css`** — the shadcn CSS-variable contract so community themes stay drop-in compatible: `:root { … }` and `.dark { … }` blocks defining at minimum `--background`, `--foreground`, `--card`, `--card-foreground`, `--popover`, `--popover-foreground`, `--primary`, `--primary-foreground`, `--secondary`, `--secondary-foreground`, `--muted`, `--muted-foreground`, `--accent`, `--accent-foreground`, `--destructive`, `--destructive-foreground`, `--border`, `--input`, `--ring`, `--radius`, plus `--font-display`, `--font-body` and any project-specific tokens. Every value must trace back to DESIGN.md — DESIGN.md is the source of truth, tokens.css is derived.
3. **iOS projects:** the app also needs `DesignTokens.swift` (Color/Font/spacing extensions mirroring tokens.css) inside the app source. If `app/` already exists, write it next to the app entry point (e.g. `app/<AppName>/<AppName>/DesignTokens.swift`). If `app/` is not scaffolded yet (normal when running inside `/onboard`), write the exact Swift file content into DESIGN.md section 9 (Agent guide) under a heading "iOS token file — create at scaffold time" so the scaffold phase places it.
4. **`docs/design/voice.md`** from `templates/docs/voice.md` — dinner-party persona, adjectives/anti-adjectives, formality (explicit T–V form where the language has one), vocabulary tables, per-surface UX-writing patterns, emoji policy, good/bad microcopy examples using this app's real screens.

## Phase 7 — Generate the brand skill

Write `.claude/skills/brand/SKILL.md` (generated — it does not exist in the template). It must auto-trigger, so NO `disable-model-invocation` field:

```markdown
---
name: brand
description: "Apply the app's design system and tone of voice. Use whenever building or modifying UI or writing user-facing copy."
---

# {{App name}} brand

Before ANY UI or user-facing copy work: read `docs/design/DESIGN.md` and `docs/design/voice.md`. They are law; this file is only the fast path.

The 5 rules most often violated on this project:
1. {{Most important project-specific rule, e.g. "All color comes from tokens.css variables — never a raw hex in a component"}}
2. {{Typography rule, e.g. "Display face <name> only for screen titles; body is <name>; never <banned font> as identity"}}
3. {{Signature element rule, e.g. "Every primary screen carries <signature element> — never remove or restyle it"}}
4. {{Voice rule, e.g. "Errors: what happened + why + next step, <register>, never apologize twice"}}
5. {{Layout/motion rule, e.g. "Spacing on the <base>px scale only; motion only <stance>"}}
```

Replace each `{{…}}` with this project's real rules, chosen from what the user cared about most during selection.

## Phase 8 — Wrap up

Keep all `evidence/design-candidate-*.html/.png` files (they are the record of what was considered). Summarize: chosen direction name, signature element, files written. If invoked from `/onboard`, return control to it. If standalone, remind the user: existing screens are not restyled automatically — run `/build-next` for new work, or ask explicitly for a restyle pass; commit the design docs.

## Hard rules

- Never skip the Pass 2 anti-slop critique, and never show an uncritiqued candidate.
- `context/brand/` assets are law; candidates interpret, never contradict.
- Previews use real product content — no lorem, no placeholder feature names.
- Banned identity fonts (see `references/anti-slop.md`) never appear as display or body identity — fallback stacks only.
- Light AND dark must both be designed (not auto-inverted) in every candidate and in the final tokens.
- One signature element per direction — spend boldness there and keep the rest disciplined.
