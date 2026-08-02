<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/constitution.md. Filled once by /onboard, amended only via the
Amendment Procedure below. Replace every {{placeholder}}; delete all comments
(including this one) from the filled instance. Keep each article short and
imperative — this file is read before every significant decision, so every line
must earn its place. Adapted from the github/spec-kit constitution pattern (MIT). -->

# {{app_name}} — Constitution

- **Version:** 1.0.0 <!-- semver: MAJOR = article removed/reversed, MINOR = article added/expanded, PATCH = wording -->
- **Ratified:** {{date}}
- **Last amended:** {{date}}

The non-negotiable principles of this project. Every plan, implementation and
review is checked against these articles. A violation is a blocker, not a style
issue.

## Article I — Product Mission

{{one_sentence_mission}}
<!-- Exactly one sentence, from the onboarding interview: what the product does,
for whom, and the core problem it solves. Everything built must serve it. -->

## Article II — Quality Bar

1. A feature is **done** only when its acceptance scenarios pass **in the running
   component** (simulator, browser, real HTTP request or real command), never
   from reading code alone.
2. `features.json` `passes` may only be flipped to `true` with `evidence` set to
   a file under `evidence/` (convention: `evidence/F-XXX-<kebab-title>.<ext>` —
   `.png` for UI, `.txt` for API/CLI transcripts); the one-line justification
   goes in `PROGRESS.md`.
3. Regressions outrank new work: a previously passing feature that breaks is
   fixed before anything new is built.

## Article III — Spec-First Development

1. Every feature gets `specs/changes/<slug>/` (spec.md, plan.md, tasks.md)
   **before** implementation code is written. Slug = `F-XXX-kebab-title`.
2. Requirements use EARS notation (`WHEN <trigger> THE SYSTEM SHALL <behavior>`)
   with Given/When/Then acceptance scenarios.
3. Unknowns are marked `[NEEDS CLARIFICATION]` and resolved with the user —
   never silently guessed on P1-impacting questions.

## Article IV — Technical Principles

1. The stack in `docs/tech/tech-stack.md` is **binding** until an ADR supersedes
   it. Every hard-to-reverse choice (framework, storage, auth, payments, sync)
   requires an ADR in `docs/adr/`.
2. Simplicity is the default: the most boring solution that satisfies the spec
   wins. New dependencies need a stated reason and a docs check first.
3. Every deliverable is a component declared in `components.json`, living in
   `apps/<id>/`. A component never reaches into another's internals — it calls
   the published interface, in the direction `depends_on` declares. Adding a
   deliverable means adding a component, never a stray folder.
4. {{stack_specific_principle}}
<!-- One principle specific to the chosen stack, e.g. "SwiftUI-first: no UIKit
unless an ADR justifies it" or "Server components by default; client components
need a reason." -->

## Article V — Design Integrity

1. `docs/design/DESIGN.md` is law for all UI work. No screen is built before it
   exists; no token is invented outside it.
2. Generic AI aesthetics are banned: no identity fonts from the banned list, no
   cliché palettes, no template look. The signature element defined in DESIGN.md
   appears where it belongs.
3. Both light and dark appearance must feel designed, not derived.

## Article VI — Voice

`docs/design/voice.md` is law for all user-facing copy: labels, empty states,
errors, notifications. Forbidden words stay forbidden. Copy is reviewed against
voice.md exactly as code is reviewed against the spec.

## Article VII — Process

1. **One feature per session.** A session takes a feature from spec to verified
   evidence, then stops.
2. Commit at every logical unit with a descriptive message; append to
   `PROGRESS.md` before ending a session.
3. User approval gates (chosen at onboarding): {{approval_gates}}
<!-- e.g. "user approves each feature before implementation" or "user approves
at milestone boundaries only". Record the exact choice made in the interview. -->
4. Interaction with the user happens in the user's language; generated documents
   are written in {{docs_language}}.

## Article VIII — Non-Goals

This project deliberately does **not** do the following (mirror of the PRD
Non-Goals section — if they diverge, the PRD is corrected, not this list
silently ignored):

- {{non_goal_1}}
- {{non_goal_2}}
- {{non_goal_3}}
<!-- Copy from the PRD Non-Goals. A feature request that conflicts with a
non-goal requires an explicit user override recorded in an ADR. -->

## Amendment Procedure

1. Any agent or user may propose an amendment with rationale.
2. Amendments require **explicit user approval** — the agent never amends this
   file autonomously.
3. On approval: bump the version (semver rules above), update "Last amended",
   record the change in `PROGRESS.md`, and propagate impacts (PRD, ADRs,
   CLAUDE.md) in the same session.
