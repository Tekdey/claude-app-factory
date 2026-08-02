---
name: onboard
description: "Interview the user about the new app (product, audience, business model, design, tone, tech), read the context/ folder, then generate every foundation doc (constitution, brief, PRD, personas, roadmap, ADRs, design system, voice), features.json, the app scaffold and .mcp.json. Run once after cloning the template."
disable-model-invocation: true
argument-hint: "[app name (optional)]"
---

# /onboard — from empty template to fully specified project

You are running the one-time onboarding of a freshly cloned app-creator template.
When this flow ends, the repository contains every foundation document, a
features ledger, a runnable app scaffold and the right MCP configuration — enough
for any future session to build features autonomously with `/build-next`.

**Conduct all interaction with the user in the user's language (detect from their
messages).** Generated documents are written in the language chosen during the
Process theme (default: the language the user answered the interview in).

If `$ARGUMENTS` contains an app name, record it as the working name; confirm it
during the Product theme.

## Re-run detection (always do this first)

If `docs/constitution.md` exists, this repository was already onboarded. Never
overwrite anything silently. Offer:

1. **Resume smoke test** — only offer if `evidence/onboarding-smoke.png` is
   missing: docs were generated but the post-restart smoke test never ran. Jump
   straight to Phase 6.
2. **Update** — re-read `context/` for new material, ask only about what changed,
   and update the affected docs (show a diff summary before writing).
3. **Regenerate one section** — user names a doc or area (e.g. "roadmap",
   "design"); redo only the phases that feed it.
4. **Cancel** — exit without touching anything.

If `docs/constitution.md` does not exist, run the full flow below, phase by
phase, in order.

## Phase 0 — Context ingestion

Before asking a single question, read everything the user dropped in `context/`:

1. Inventory the folder recursively: `context/brand/`, `context/inspiration/`,
   `context/docs/` (any file type: md, txt, pdf, png, jpg…).
2. Actually read every file. View images and describe what you see. In
   `context/inspiration/`, treat `love-*.png` as positive references and
   `hate-*.png` as anti-references; read `links.md` if present. In
   `context/brand/`, extract palette, fonts and logo traits — existing brand
   assets are binding for the design phase.
3. Build an **"already answered" map**: for each question id in
   `.claude/skills/onboard/references/questions.md`, note whether the context
   answers it and with what.
4. Detect the user's language from the context files and their first message.
5. Report back in 3–5 lines: what you found, what it already answers, what
   remains to ask. If `context/` is empty, say so and move on — it is optional.

## Phase 1 — Interview

Load `.claude/skills/onboard/references/questions.md` (the full question bank)
and conduct the interview under these rules:

- **Tooling**: use the AskUserQuestion tool whenever it is available — group
  related questions, max 4 questions per call, concrete options, exactly one
  option flagged as recommended. If the tool is unavailable, fall back to
  numbered questions with lettered options in chat (user answers "1A, 2C…").
- **One theme at a time**, in this order: Product → Audience → Business model →
  Design → Tone → Tech & constraints → Process preferences.
- **Skip what context/ already answered**: state the inferred answer in one line
  ("From your brief I take X — correct me if wrong") and move on.
- **Every question accepts "You decide"**: you choose, and you record the choice
  plus a one-line rationale in the relevant doc.
- **Budget**: at most 5 questions per theme (drop or merge the lowest-value gaps
  when a theme has more); total interview target ≤ 20 minutes.
- **After each theme**: reflect a 2-line summary back to the user before moving
  to the next theme.

## Phase 2 — Synthesis & approval gate (HARD GATE)

Produce ONE recap message covering: pitch, audience, business model, design
direction, tone of voice, recommended stack **with reasoning**, doc language and
process preferences. End with: "Shall I generate the project on this basis?"

**Nothing is written to disk before the user explicitly approves.** If the user
asks for changes, adjust and re-present the recap. Do not proceed on silence or
a vague answer.

## Phase 3 — Doc generation

Load `.claude/skills/onboard/references/generation.md` and follow it doc by doc.
Generation order (each filled from its `templates/docs/*` skeleton — never edit
the templates themselves):

1. `docs/constitution.md`
2. `docs/product/brief.md` (vision + full Lean Canvas)
3. `docs/product/personas.md`
4. `docs/product/prd.md` (EARS FRs, non-goals, success metrics)
5. `docs/product/roadmap.md` (v0.1 walking skeleton → v1 → later)
6. `docs/tech/tech-stack.md` + one ADR in `docs/adr/` per major choice
7. `docs/tech/architecture.md`
8. `docs/tech/structure.md`
9. `docs/tech/testing.md`
10. `features.json` at the repo root, built from the PRD (every FR → one or more
    feature entries, `passes: false`, priority from roadmap phase)

Then run the **self-review pass** defined in generation.md: scan every generated
doc for leftover placeholders, contradictions and unresolved
`[NEEDS CLARIFICATION]` markers; ask the user at most 5 follow-up questions to
resolve them; fix the docs.

## Phase 4 — Design

Run the `/design` skill flow: read `.claude/skills/design/SKILL.md` and follow
it — do not duplicate its logic here. It proposes 2–3 rendered art directions
(previews saved under `evidence/`), lets the user pick, then writes
`docs/design/DESIGN.md`, the design tokens and `docs/design/voice.md`.

Design is not optional: no UI work is allowed in this repo before
`docs/design/DESIGN.md` exists.

## Phase 5 — Setup (MCP, scaffold, scripts, rules)

Load `.claude/skills/onboard/references/scaffold.md` and execute it for the
chosen platform:

1. Write `.mcp.json` from the matching `templates/mcp/*.json` variant, appending
   a backend block from `templates/mcp/backends.md` if a backend was chosen.
2. Scaffold the app in `app/` (iOS SwiftUI, Expo, or web — recipes in
   scaffold.md).
3. Create `scripts/run.sh`, `scripts/format.sh`, `scripts/test.sh`,
   `scripts/verify-quick.sh` for the stack and `chmod +x` them.
4. Append the stack's required key **names** to `.env.example` (never values;
   never read `.env`).
5. Generate the stack rule file in `.claude/rules/` (e.g. `swiftui.md`).
6. Update the identity line at the top of `CLAUDE.md` with the app name and
   one-line pitch — change **nothing else** in CLAUDE.md.

## Phase 6 — Smoke test & handoff

1. Update `PROGRESS.md`: append an entry (date, "onboarding completed", stack
   and platform chosen, next step `/build-next`).
2. Make **one** git commit: `chore: onboard <app-name>` (docs, scaffold,
   scripts, config, PROGRESS.md).
3. If `.mcp.json` changed this session (it did, unless this is a resume), tell
   the user: **restart Claude Code and approve the MCP servers**, then run
   `/onboard` again — re-run detection will offer "Resume smoke test".
   Exception: for iOS, `xcodebuild` and `xcrun simctl` work over plain Bash, so
   you may run the smoke test immediately and still remind the user to restart
   afterwards for the full MCP toolset.
4. Smoke test: build and launch the scaffold via the platform MCP (or the iOS
   Bash fallback), take a screenshot, save it to `evidence/onboarding-smoke.png`,
   and amend it into the onboarding commit (`git commit --amend --no-edit`) so
   onboarding stays a single commit.
5. Final message: recap what was generated and where (docs/, features.json,
   app/, scripts/, .mcp.json), show the smoke-test screenshot, and close with:
   next step is `/build-next` to build the first feature; `/status` shows the
   dashboard anytime.

## Hard rules (recap)

- No file is written before the Phase 2 approval — the gate is absolute.
- Never edit anything under `templates/` — templates are copied and filled, not
  modified.
- Never read `.env`; only ever append key names to `.env.example`.
- Do not build product features here. Onboarding ends at the smoke test; feature
  work belongs to `/build-next`.
- Do not touch `CLAUDE.md` beyond the single identity line.
- One feature of this skill is honesty: when you chose for the user ("You
  decide"), the rationale must be written down in the doc that carries the
  decision.
