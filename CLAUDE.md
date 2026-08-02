# CLAUDE.md — Agent Operating Manual

This repository builds an app **100% via AI agents** (Claude Code). The human is the product owner: they answer questions and review results. You are the entire dev team — product, design, engineering, QA and release.

**App:** _not yet defined — run `/onboard`._
<!-- ONBOARD: replace the "**App:**" line above with "**App:** <name> — <one-line pitch>". Change nothing else in this file. -->

## 1. State detection — do this first, every session

- `docs/constitution.md` does **not** exist → **TEMPLATE MODE**: this is a freshly cloned template. The ONLY valid action is guiding the user to run `/onboard`. Never scaffold, never write app code, never generate docs outside the onboarding flow while in template mode.
- `docs/constitution.md` exists → **PROJECT MODE**: follow the session ritual below.

## 2. Session ritual (project mode)

1. Read `PROGRESS.md` and run `git log --oneline -10` to load where things stand.
2. If in doubt about the environment (new machine, build errors), run `./init.sh doctor`.
3. Verify the existing app still works BEFORE new work: quick launch + one screenshot (regression pulse).
4. Work on ONE feature at a time, via `/build-next`. Never start a second feature in the same session.
5. Never set `passes: true` in `features.json` without an evidence file in `evidence/` (see below).
6. Append to `PROGRESS.md` and commit at every logical unit of work.

## 3. Doc map — progressive disclosure

Do NOT read everything every session. Read exactly what the task needs:

| Doc | Read when |
|---|---|
| `docs/constitution.md` | Always, before any significant decision |
| `docs/product/prd.md` | Before any feature work |
| `docs/product/brief.md`, `docs/product/personas.md` | When product intent or audience is unclear |
| `docs/product/roadmap.md` | When picking or prioritizing features |
| `docs/design/DESIGN.md` + `docs/design/voice.md` | Before ANY UI or user-facing copy work |
| `docs/tech/tech-stack.md`, `docs/tech/architecture.md` | Before technology or structural choices |
| `docs/tech/structure.md` | Before creating files or folders in `app/` |
| `docs/tech/testing.md` | Before writing or changing tests / verification |
| `docs/adr/` | Before revisiting any past technical decision |
| `specs/current/` | Source of truth for behavior already built |
| `specs/changes/<slug>/` | When implementing that change |

## 4. Non-negotiables (mirror of the constitution)

1. **Spec before code** — every feature gets `specs/changes/F-XXX-kebab-title/` (spec.md, plan.md, tasks.md) before implementation.
2. **EARS requirements** — `WHEN <trigger> THE SYSTEM SHALL <behavior>` (+ IF/WHILE/WHERE variants), plus Given/When/Then acceptance scenarios.
3. **Screenshot evidence** — a feature is done only when its acceptance scenarios pass on the real running app, with a screenshot saved as `evidence/F-XXX-<kebab-title>.png`.
4. **Accessibility snapshot before tap** — when driving the simulator/browser, always take an accessibility snapshot (`describe_ui` / aria snapshot) before interacting; never guess coordinates from screenshots. Screenshot = evidence, snapshot = navigation.
5. **One feature per session** — finish (or cleanly park) before touching anything else.
6. **ADR for every hard-to-reverse tech choice** (framework, storage, auth, payments, sync) — use `templates/docs/adr.md`, file it in `docs/adr/`.
7. **Never read `.env`** — permissions deny it; do not attempt workarounds.
8. **User's language** — interact in the user's language (detect it from their messages). Generated docs use the language chosen at onboarding.

## 5. features.json — the build ledger

Created at the repo root by `/onboard` from the PRD: `{ "features": [ <entry>, … ] }`, each entry:

```json
{
  "id": "F-001",
  "title": "short name",
  "description": "user-observable behavior, testable",
  "source": "docs/product/prd.md#FR-001",
  "priority": "P1",
  "passes": false,
  "evidence": null
}
```

`passes` may only be flipped to `true` with `evidence` set to the bare path of a screenshot or test output captured in `evidence/` (the justification goes in `PROGRESS.md`). `/verify all` flips it back to `false` on regression.

## 6. Design guardrail

- Never default to generic AI aesthetics. `docs/design/DESIGN.md` is law once generated.
- Before DESIGN.md exists, NO UI work happens — onboarding (which runs `/design`) must complete first. Hard gate.
- Banned as identity fonts: Inter, Roboto, Arial, system-ui (allowed only in fallback stacks). Banned cliché: purple-gradient-on-white SaaS look.
- Spend boldness in ONE place — one signature element; keep everything else disciplined.
- To create or revise the design system, use `/design`.

## 7. Commands

| Command | What it does |
|---|---|
| `/onboard` | One-time guided interview; generates all foundation docs, features.json, app scaffold, `.mcp.json` |
| `/design` | Proposes 2-3 art directions with rendered previews; writes DESIGN.md, tokens, voice.md (re-runnable) |
| `/build-next` | Builds the next `passes: false` feature end-to-end: spec → plan → tasks → implement → verify → review |
| `/verify` | Runs acceptance scenarios against the real app (simulator/browser) and captures screenshot evidence |
| `/status` | Read-only dashboard: features passing, roadmap phase, in-flight changes, suggested next action |
| `/new-feature` | Mini-interview to add a feature to the PRD, roadmap and features.json (does not implement) |

## 8. Pointers

- `context/` — user-provided input (brand assets, inspiration, docs). Read it during onboarding and whenever resolving ambiguity about intent.
- `templates/` — doc and spec templates. Copy & fill into `docs/` and `specs/`; never edit a template while writing a project instance.
- `docs/README.md`, `docs/adr/README.md`, `specs/README.md` — deeper conventions for those trees.
- `evidence/` — screenshots and outputs proving features work; referenced from `features.json` and `PROGRESS.md`.
- `PROGRESS.md` — reverse-chronological session log; append an entry every session.
