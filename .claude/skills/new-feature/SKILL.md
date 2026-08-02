---
name: new-feature
description: "Add a new feature to the product plan via a short interview: writes a PRD addendum (new FR in EARS format), places it on the roadmap and creates its features.json entry. Planning only — implementation happens later through /build-next."
disable-model-invocation: true
argument-hint: "[description]"
---

# /new-feature — plan it, don't build it

Conduct all interaction with the user in the user's language (detect from their messages). Written artifacts use the project's documentation language recorded during onboarding.

Gate: if `docs/constitution.md` does not exist, onboarding has not run — refuse politely and point to `/onboard`.

## 1. Mini-interview (max 5 questions — merge the closest two if all six apply)

Treat `$ARGUMENTS`, if provided, as the initial feature description. Use AskUserQuestion when available (concrete options with a recommended default); otherwise numbered questions with lettered options in chat. Skip anything the description already answers. Every question offers "You decide" — if chosen, decide and record your rationale.

1. **What** — the user-observable behavior, in one testable sentence?
2. **Who benefits** — which persona from `docs/product/personas.md` (or a new one)?
3. **Which component(s)** — read `components.json` and offer its ids; a feature may span several (e.g. app + API), first one = where evidence gets captured. If the idea needs a deliverable that does not exist yet (a marketing site, an admin), say so and point to `/onboard` → "Add a component" — do not invent a component here.
4. **Priority** — P1 / P2 / P3 relative to the existing roadmap?
5. **Scope** — in v1, or post-launch (v1.x)?
6. **Success signal** — how will we observe that it works? (feeds the acceptance scenarios — phrase it in terms of the first component's `verify` method: a visible screen state, an HTTP response, a command output)

Reflect a 2-line summary back to the user before writing anything.

## 2. Conflict check (before any write)

Read the Non-Goals section of `docs/product/prd.md` and the non-goals article of `docs/constitution.md`.

- If the feature conflicts with a non-goal: surface the conflict explicitly (quote the non-goal), and require an explicit user override.
- On override: record the decision as an ADR — next 4-digit number, `docs/adr/NNNN-title.md`, from `templates/docs/adr.md` — capturing context, the overridden non-goal, and consequences. Also update the PRD's Non-Goals section to match the new reality.
- No override → stop; write nothing; suggest rephrasing the idea so it fits, if the user wants.

## 3. Write the plan artifacts

1. **PRD addendum** — append to `docs/product/prd.md` a new functional requirement with the next free FR number, titled and marked `(added YYYY-MM-DD)`. Requirements in EARS notation (`WHEN <trigger> THE SYSTEM SHALL <behavior>` + IF/WHILE/WHERE variants) plus at least one Given/When/Then acceptance scenario. Add an NFR entry too if the interview surfaced a non-functional constraint. Never renumber or rewrite existing FRs.
2. **Roadmap placement** — add the feature to the matching phase in `docs/product/roadmap.md` (v1 or v1.x per the scope answer), referencing its feature id.
3. **features.json entry** — append an entry with the next free id, matching the ledger schema exactly:

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

New entries always start with `"passes": false` and `"evidence": null`; `components` holds ids that exist in `components.json`; `source` anchors to the FR you just added (e.g. `docs/product/prd.md#FR-023`). Validate the file after editing (`jq . features.json`).

## 4. Record and hand off

- Append a short `PROGRESS.md` entry (newest first): date, "planned F-XXX <title>", phase placement, next suggested step.
- One commit: `docs: plan F-XXX <kebab-title>`.
- Tell the user clearly: **nothing was implemented.** When ready, run `/build-next F-XXX` to build it now, or plain `/build-next` to respect priority order. `/status` shows where it landed.

## Rules

- This skill never touches `apps/` code and never creates `specs/changes/` folders — the spec/plan/tasks trio is `/build-next`'s job, done at build time (slug `F-XXX-kebab-title`).
- One feature per invocation; several ideas → run the skill once per idea.
- Do not edit `templates/` files — copy their structure into the instance documents.
- Do not flip any existing `passes` flag or modify existing ledger entries.
