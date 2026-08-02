---
name: status
description: "Show a compact project dashboard: features passing vs total and per component, roadmap phase, in-flight spec changes, last session summary and the suggested next action. Read-only — use whenever the user asks where the project stands."
---

# /status — where are we?

Conduct all interaction with the user in the user's language (detect from their messages).

This skill is strictly read-only: gather, then report. Do not modify any file, do not launch any component, do not commit, do not flip any `passes` flag. If verification seems needed, suggest `/verify` — never run it from here.

## Gather

### 1. components.json (what ships)

Read it first: it gives the component list, which is `primary`, and each one's `verify` method. Every count below is broken down by component. If it is missing, treat the project as single-component and say so.

### 2. features.json (the ledger)

If `features.json` is missing (or `docs/constitution.md` does not exist), the template has not been onboarded: report "template mode — onboarding not done", suggest `/onboard`, and stop.

Schema reminder:

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

Compute with `jq`:

```bash
jq -r '[.features[] | select(.passes)] | length' features.json     # passing
jq -r '.features | length' features.json                           # total
jq -r '[.features[] | select(.passes | not)] | sort_by(.priority, .id) | .[0] | "\(.id) (\(.priority)) \(.title)"' features.json  # next pick

# per component (first id in `components` = where it is proven)
jq -r '[.features[] | select(.components != null)] | group_by(.components[0])[] |
  "\(.[0].components[0]): \([.[] | select(.passes)] | length)/\(length)"' features.json
```

Also break down passing/total per priority (P1, P2, P3).

### 3. PROGRESS.md

Read the top entry (the log is reverse-chronological): last session's date, what was done, feature ids touched, suggested next step.

### 4. Git

`git log --oneline -10` and `git status --short` — recent activity and whether uncommitted work is sitting in the tree.

### 5. specs/changes/

List `specs/changes/*/`. For each folder, read the spec.md status header (DRAFT / APPROVED / DONE) and, if tasks.md exists, count checked vs total boxes. Folders not marked DONE are **in flight**.

### 6. Roadmap phase

Read `docs/product/roadmap.md`. The current phase is the first phase whose feature ids are not yet all passing. Note its exit criteria and which ids still block it.

## Report — compact dashboard

Render something like (adapt labels to the user's language):

```
<Product name> — 14/32 features passing (P1 8/9 · P2 5/14 · P3 1/9)
Components: ios 9/18 (primary) · api 4/9 · web 1/5
Phase: v0.1 walking skeleton — blocked by F-009
In flight: specs/changes/F-009-offline-cache (APPROVED, tasks 3/7)
Git: clean tree, last commit "feat(F-008): login flow" (yesterday)
Last session (2026-08-01): F-008 shipped — evidence/F-008-login-flow.png
Next: /build-next F-009 (P1) — offline cache
```

Omit the Components line for a single-component project. Keep it under ~15 lines. No walls of text; the dashboard IS the deliverable.

## Suggested next action (pick the first that applies)

1. Onboarding missing → `/onboard`.
2. An in-flight change folder exists → resume it: `/build-next F-XXX`.
3. Uncommitted changes but no in-flight folder → suspect drift: `/verify`, then commit or discard.
4. All current-phase features passing → `/verify all` before declaring the phase's exit criteria met, then start the next phase with `/build-next`.
5. A component declared in `components.json` has no scaffold under `apps/<id>/` → it was deferred or never set up: point at `/onboard` ("Add a component").
6. Everything passing, roadmap exhausted → `/new-feature` or a roadmap review with the user.
