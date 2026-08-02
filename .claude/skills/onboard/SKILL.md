---
name: onboard
description: "Interview the user about the new project (product, what it ships, audience, business model, design, tone, tech), read the context/ folder, then generate every foundation doc (constitution, brief, PRD, personas, roadmap, ADRs, design system, voice), components.json, features.json, every component scaffold and .mcp.json. Run once after cloning the template."
disable-model-invocation: true
argument-hint: "[app name (optional)]"
---

# /onboard — from empty template to fully specified project

You are running the one-time onboarding of a freshly cloned template. When this
flow ends, the repository contains every foundation document, a component
manifest, a features ledger, a runnable scaffold **per component** and the right
MCP configuration — enough for any future session to build features autonomously
with `/build-next`.

A project is not necessarily one app: it may ship a mobile app, an API and a
marketing site. Establishing that shape early (Project shape theme) is one of
this flow's main jobs.

**Conduct all interaction with the user in the user's language (detect from their
messages).** Generated documents are written in the language chosen during the
Process theme (default: the language the user answered the interview in).

If `$ARGUMENTS` contains an app name, record it as the working name; confirm it
during the Product theme.

## Re-run detection (always do this first)

If `docs/constitution.md` exists, this repository was already onboarded. Never
overwrite anything silently. Offer:

1. **Resume smoke test** — only offer if no `evidence/onboarding-smoke-*` proof
   exists: docs were generated but the post-restart smoke test never ran. Jump
   straight to Phase 6.
2. **Add a component** — the project grew a deliverable (an API, a site) after
   onboarding. Run the Project shape questions (Q-S1 follow-ups, Q-S3 wiring)
   and the Q-T1 stack question **for the new component only**, then:
   append it to `components.json`; run every Phase 5 step scoped to it (merge
   its MCP driver into `.mcp.json`, scaffold `apps/<id>/`, create
   `scripts/<id>/`, append its `.env.example` keys, write `.claude/rules/<id>.md`);
   extend the PRD, roadmap, `architecture.md`, `structure.md`, `tech-stack.md`
   and `features.json`; smoke-test it. Leave every existing component untouched
   and regenerate nothing else.
3. **Update** — re-read `context/` for new material, ask only about what changed,
   and update the affected docs (show a diff summary before writing).
4. **Regenerate one section** — user names a doc or area (e.g. "roadmap",
   "design"); redo only the phases that feed it.
5. **Cancel** — exit without touching anything.

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
- **One theme at a time**, in this order: Product → **Project shape** →
  Audience → Business model → Design → Tone → Tech & constraints → Process
  preferences.
- **Never skip the Project shape theme.** People describe the piece they have
  in mind and remember the API or the marketing site far too late. Asking
  "what else does this project ship?" early is what keeps the PRD, roadmap and
  scaffold correct — a single-component answer is a valid answer, an unasked
  question is not.
- **Skip what context/ already answered**: state the inferred answer in one line
  ("From your brief I take X — correct me if wrong") and move on.
- **Every question accepts "You decide"**: you choose, and you record the choice
  plus a one-line rationale in the relevant doc.
- **Budget**: at most 5 questions per theme (drop or merge the lowest-value gaps
  when a theme has more); total interview target ≤ 20 minutes.
- **After each theme**: reflect a 2-line summary back to the user before moving
  to the next theme.

## Phase 2 — Synthesis & approval gate (HARD GATE)

Produce ONE recap message covering: pitch, **the component list with the primary
one marked and how they wire together**, audience, business model, design
direction, tone of voice, recommended stack **per component with reasoning**,
doc language and process preferences. End with: "Shall I generate the project on this basis?"

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
5. `components.json` at the repo root (every deliverable, its stack, path, run
   script and verify method; exactly one `"primary": true`)
6. `docs/product/roadmap.md` (v0.1 walking skeleton → v1 → later)
7. `docs/tech/tech-stack.md` + one ADR in `docs/adr/` per major choice
8. `docs/tech/architecture.md`
9. `docs/tech/structure.md`
10. `docs/tech/testing.md`
11. `features.json` at the repo root, built from the PRD (every FR → one or more
    feature entries, each tagged with the `components` it touches,
    `passes: false`, priority from roadmap phase)

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

Load `.claude/skills/onboard/references/scaffold.md` and execute it for every
component in `components.json`, in `depends_on` order:

1. Write `.mcp.json` by **merging** the variants every component needs
   (`templates/mcp/*.json`), plus a backend block from
   `templates/mcp/backends.md` if a backend was chosen. Keep `context7` once.
2. Scaffold every component into `apps/<id>/`, in `depends_on` order — recipes
   per kind in scaffold.md (iOS, Expo, web app, marketing site, API, admin,
   CLI, library).
3. Create the two root dispatchers (`scripts/format.sh`,
   `scripts/verify-quick.sh`) and, per component, `scripts/<id>/{run,test,
   format,verify-quick}.sh`; `chmod +x` them all.
4. Append each component's required key **names** to `.env.example`, grouped
   under a per-component comment header (never values; never read `.env`).
5. Generate one rule file per component: `.claude/rules/<id>.md` scoped to
   `paths: ["apps/<id>/**"]`.
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
4. Smoke test **every component**, starting with the primary one: run its
   `scripts/<id>/run.sh` and capture proof per its `verify` method — a
   screenshot for `simulator`/`browser`, a request transcript (e.g. the
   `/health` response) for `http`, `--help` output for `cli`. Save them as
   `evidence/onboarding-smoke-<id>.png|.txt` and amend them into the onboarding
   commit (`git commit --amend --no-edit`) so onboarding stays a single commit.
   A component that cannot start yet (missing credentials, deferred to a later
   phase) is reported as such, not silently skipped.
5. Final message: recap what was generated and where (docs/, components.json,
   features.json, apps/, scripts/, .mcp.json), list each component with its
   smoke-test result, and close with: next step is `/build-next` to build the
   first feature; `/status` shows the dashboard anytime.

## Hard rules (recap)

- No file is written before the Phase 2 approval — the gate is absolute.
- Never edit anything under `templates/` — templates are copied and filled, not
  modified.
- Never read `.env`; only ever append key names to `.env.example`.
- Do not build product features here. Onboarding ends at the smoke test; feature
  work belongs to `/build-next`.
- Never assume a single component from silence. If the user never mentioned an
  API or a site, ask anyway — that is what Q-S1 is for.
- Do not touch `CLAUDE.md` beyond the single identity line.
- One feature of this skill is honesty: when you chose for the user ("You
  decide"), the rationale must be written down in the doc that carries the
  decision.
