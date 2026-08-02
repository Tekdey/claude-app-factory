<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/tech/testing.md. Filled by /onboard for the chosen stack.
This defines what "verified" means for an autonomous agent — /verify and
/build-next follow it literally. Replace every {{placeholder}}; delete all
comments from the filled instance. -->

# {{app_name}} — Testing Strategy

## The Test Pyramid for Agents

Priorities are inverted from human teams: the **top** of the pyramid — the app
actually running — is the source of truth, because agents are the ones most
tempted to declare victory from code reading.

1. **E2E acceptance scenarios (source of truth).** Every feature's
   Given/When/Then scenarios from `specs/changes/<slug>/spec.md` are executed
   against the real running component, using the method its `components.json`
   entry declares — one line per component below:

   | Component | `verify` | Driven with | Discipline |
   |---|---|---|---|
   | `{{component_id}}` | {{verify_method}} | {{mcp_server_or_test_runner}} | {{discipline}} |

   For `simulator`/`browser`: accessibility snapshot before every interaction —
   never guess coordinates from a screenshot; screenshot = evidence, snapshot =
   navigation. For `http`: issue the real requests and assert on status codes and
   response bodies, covering validation and unauthorized paths, not just the
   happy one. A feature without a passing run against the real component is not
   done, whatever the unit tests say.
2. **Unit tests on logic.** Pure logic — {{examples_of_core_logic}} (e.g. streak
   computation, date handling, parsing, pricing rules) — gets fast unit tests in
   `{{tests_path}}` using {{unit_test_framework}}. Test behavior, not structure.
3. **Snapshot/component tests where cheap.** {{snapshot_policy}}
   <!-- e.g. "snapshot tests for DesignSystem components only" or "none — the
   E2E screenshots cover visual regressions for now". Cheap or absent; never a
   maintenance burden. -->

## What NOT to Test

- The framework itself ({{ui_framework}} rendering, navigation plumbing).
- Trivial mappings and pass-through code with no branching.
- Private implementation details — if refactoring breaks the test but not the
  behavior, the test was wrong.
- Visual pixel-perfection beyond snapshots — DESIGN.md compliance is checked by
  review, not asserted in tests.

## Evidence

- Every verified feature has a proof file at `evidence/F-XXX-<kebab-title>.<ext>`,
  captured at the assertion moment of its acceptance scenario. The extension
  follows the proving component's `verify` method in components.json:
  `simulator`/`browser` → `.png` screenshot of the screen state proving the Then
  clause; `http`/`cli` → `.txt` transcript of the requests/commands with their
  responses, status codes and exit codes; `none` (library) → `.txt` test output.
- `features.json` `passes: true` requires the `evidence` field to hold that
  file's bare path (justification goes in `PROGRESS.md`). No evidence file →
  not passed.
- Multi-scenario features may add `evidence/F-XXX-<kebab-title>-as2.<ext>` etc.; the
  main file covers the primary scenario. Failing runs keep their proof file too —
  failure evidence speeds up the fix.
- Onboarding smoke tests live at `evidence/onboarding-smoke-<component-id>.<ext>`.

## Deterministic Mode

Autonomous verification requires reproducible runs:

- **Seeded data:** {{seed_mechanism}} — a launch argument/env flag (e.g.
  `{{SEED_FLAG_NAME}}`) that loads a fixed dataset so scenarios start from a
  known state. Scenarios never depend on leftover state from previous runs.
- **Animations off:** {{animations_off_flag}} — a flag that disables/accelerates
  animations so snapshots and screenshots are stable.
- **Frozen time where it matters:** {{time_control_approach}} for logic that
  depends on "today" (streaks, reminders) so tests do not rot at midnight.
- Reset between scenarios: {{reset_mechanism}} (e.g. reinstall app / clear
  storage) whenever a scenario requires a clean install.

## Commands

| Task | Command | Budget |
|---|---|---|
| Full suite, one component | `./scripts/{{component_id}}/test.sh` | {{full_budget}} |
| Quick gate, every component (runs at session stop) | `./scripts/verify-quick.sh` | < 60s total |
