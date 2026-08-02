---
name: build-next
description: "Build exactly one feature from features.json end to end: regression pulse, spec, plan, tasks, implementation, verification against the real running components with captured evidence, adversarial review, and progress logging. The core development loop — run once per feature."
disable-model-invocation: true
argument-hint: "[feature id (F-012) or component id (api)]"
---

# /build-next — ship one feature, prove it works

Conduct all interaction with the user in the user's language (detect from their messages). Files you write use the project's documentation language recorded during onboarding.

## Ritual

### 0. Gate: onboarding must be done

If `docs/constitution.md` does not exist, this repo is a freshly cloned template. Refuse politely: explain that the foundation docs do not exist yet and that the user should run `/onboard` first. Stop here — do not scaffold, do not code.

### 1. Load state

Read, in this order:

1. `PROGRESS.md` — latest entries (reverse-chronological: what happened last session, suggested next step).
2. `components.json` — what this project ships, where each component lives (`apps/<id>/`), how to run it (`scripts/<id>/run.sh`) and how it proves itself (`verify`). You need this before you can build or verify anything.
3. `features.json` — the autonomous-build ledger. Its schema:

```json
{
  "$comment": "Autonomous-build ledger. Anthropic long-running-agent harness pattern.",
  "features": [
    {
      "id": "F-001",
      "title": "short name",
      "description": "user-observable behavior, testable",
      "components": ["ios"],
      "source": "docs/product/prd.md#FR-001",
      "priority": "P1",
      "passes": false,
      "evidence": null
    }
  ]
}
```

4. `git log --oneline -5` — recent commits.

### 2. Regression pulse (fast — one flow)

Before any new work, confirm the existing product still works:

- Start the components involved in the last passing feature via `scripts/<id>/run.sh` (a component with `depends_on` needs its dependencies running first — an app talking to a local API needs that API up).
- Exercise ONE flow: the feature most recently marked passing (check PROGRESS.md; fallback: highest id with `"passes": true`).
- Capture proof per the component's `verify` method — UI: accessibility snapshot before any tap, then screenshot (screenshot = evidence, snapshot = navigation); `http`: replay the key request and check the response; `cli`: re-run the command.
- If no feature passes yet, just confirm each v1 component builds and starts.

If a component fails to build or the flow is broken, STOP: fixing the regression IS this session's work. Flip the broken feature's `passes` to `false`, log the regression in PROGRESS.md, and treat the fix as the picked feature (skip step 3).

### 3. Pick the feature

- If `$ARGUMENTS` contains a feature id (e.g. `F-012`), use that feature. `$ARGUMENTS` may also name a component id (e.g. `api`) — then pick the next unbuilt feature of that component.
- Otherwise pick the first `"passes": false` entry ordered by priority (P1 > P2 > P3), then by dependency (a feature whose component others `depend_on` comes first — build the endpoint before the screen consuming it), then by id.

Announce the pick with one line of reasoning. If the user requested a feature that already passes, confirm they really want a rework before proceeding.

### 4. Spec the change

Create `specs/changes/<slug>/` where slug = `F-XXX-kebab-title` (e.g. `specs/changes/F-012-streak-badge/`). Write three files, each from its template:

| File | Template | Content |
|---|---|---|
| `spec.md` | `templates/specs/spec.md` | user story; EARS requirements (`WHEN <trigger> THE SYSTEM SHALL <behavior>` + IF/WHILE/WHERE variants); Given/When/Then acceptance scenarios numbered AS-1…; edge cases; out of scope |
| `plan.md` | `templates/specs/plan.md` | technical approach; exact files to create/modify; constitution check; design-system check for UI features |
| `tasks.md` | `templates/specs/tasks.md` | small checkboxed tasks, each naming exact file paths, `[P]` where parallelizable |

Rules while speccing:

- Read the feature's `source` anchor in `docs/product/prd.md` first. Read `docs/tech/structure.md` before naming any file path — every path lives under `apps/<id>/` for one of the feature's `components`.
- A feature spanning several components (e.g. `["ios", "api"]`) stays ONE change folder: spec it from the user's point of view, and let plan.md list the files on both sides. Build the dependency side first so the consumer can be verified against something real.
- For any UI feature, read `docs/design/DESIGN.md` and `docs/design/voice.md` BEFORE writing plan.md — the design check must name the tokens and components you will use.
- Mark unknowns `[NEEDS CLARIFICATION: …]` in spec.md. If any marker blocks a P1 requirement, ask the user at most 3 targeted questions (use AskUserQuestion when available), record answers in the spec's clarifications log, then continue. Otherwise decide yourself and record the assumption in spec.md.

### 5. Implement

Work through tasks.md top to bottom:

- One task at a time; check its box (`- [x]`) the moment it is done.
- Follow plan.md's file list — if reality forces a deviation, update plan.md and say why.
- Commit per logical unit with a clear message referencing the feature id (e.g. `feat(F-012): add streak badge view`).
- Run `scripts/<id>/test.sh` for each touched component before each commit (`scripts/verify-quick.sh` covers all of them for a fast gate).

### 6. Verify

Run the `/verify` flow for this feature (`.claude/skills/verify/SKILL.md` — same discipline, do not improvise a lighter one):

- Execute every acceptance scenario (AS-1…) from spec.md against the real running components. You may delegate the driving to the `app-tester` agent.
- Verification follows the **first** component's `verify` method: `simulator`/`browser` → accessibility snapshot before every interaction (never guess coordinates), screenshot at each assertion moment; `http` → issue the real requests and record request + response; `cli` → run the real commands and record the output.
- Save the primary evidence file as `evidence/F-XXX-<kebab-title>.<ext>` — `.png` for UI, `.txt` for `http`/`cli` (e.g. `evidence/F-012-streak-badge.png`, `evidence/F-003-habits-crud-endpoints.txt`); extra scenarios as `…-as2.<ext>`.
- Any FAIL → return to step 5, fix, re-verify. Never rationalize a failure away.

### 7. Adversarial review

Launch the `reviewer` agent on the diff of this feature. Give it: the diff (or commit range), `specs/changes/<slug>/spec.md`, `docs/constitution.md`, `docs/design/DESIGN.md`, and `docs/design/voice.md` for user-facing copy.

- Fix every BLOCKER and WARN finding; use judgment on NITs.
- If a fix changes behavior, re-run step 6 for the affected scenarios.

### 8. Record the pass

Only after steps 6 and 7 both succeed:

1. In `features.json`, set the feature's `"passes": true` and `"evidence"` to the evidence file path (e.g. `"evidence/F-012-streak-badge.png"`). The file must exist on disk — check. Never touch the `components` field here.
2. Merge the requirement deltas from `specs/changes/<slug>/spec.md` into `specs/current/` so the living spec reflects the system as built.
3. Mark the change folder DONE in its spec.md status header (archive-in-place; the folder stays for history).

### 9. Log and commit

- Append an entry to `PROGRESS.md` (newest first): date, what was done, feature ids touched, next suggested step.
- Final commit for the ledger/spec/progress updates (e.g. `chore(F-012): mark passing with evidence`).

### 10. Report

Short recap in chat: feature shipped, evidence path, review findings fixed, and the next suggested feature (computed by the step-3 rules). Point the user to `/build-next` for the next one, or `/status` for the big picture.

## HARD RULES (non-negotiable, repeat to yourself)

- ONE feature per invocation. Never start a second, however tempting.
- Never set `"passes": true` without an evidence file that actually exists at the recorded path. `evidence` = bare path to a screenshot / test output captured in `evidence/`; the one-line justification goes in `PROGRESS.md`.
- No UI work without having read `docs/design/DESIGN.md` in this session.
- Never create source files outside `apps/<id>/` for a component declared in `components.json`. A new deliverable means a new component entry (`/onboard` → "Add a component"), never a stray folder.
- Accessibility snapshot before every tap/click — never guess coordinates from screenshots. Screenshot = evidence, snapshot = navigation.
- Never mark a scenario PASS from code reading alone — the component must actually run.
