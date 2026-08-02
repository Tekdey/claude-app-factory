---
name: verify
description: "Verify features against their acceptance scenarios by driving the real running components — simulator, browser, HTTP requests or CLI — and capturing evidence. Use after implementing, or to run a regression pass."
argument-hint: "[F-XXX | <component-id> | all]"
---

# /verify — prove behavior on the running components

Conduct all interaction with the user in the user's language (detect from their messages).

Core principle: **never mark PASS from code reading alone — the component must actually run.** A scenario passes only when you (or the `app-tester` agent) executed it against the launched component and captured proof at the assertion moment.

If `docs/constitution.md` does not exist, onboarding has not run: say so and suggest `/onboard` instead.

## The two manifests

`components.json` tells you **how** to verify: each component's `path`, its `run` script and its `verify` method (`simulator` · `browser` · `http` · `cli` · `none`). Read it first — a feature is verified through the method of the **first** component in its `components` list, with any `depends_on` component started beforehand.

`features.json` is the ledger of **what** to verify. Its schema:

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

`passes` may only be flipped to true with `evidence` = bare path to a screenshot / test output captured in `evidence/`; the one-line justification goes in your report and in PROGRESS.md. Only ever edit the `passes` and `evidence` fields of existing entries.

## Modes — `$ARGUMENTS` decides

### `/verify F-012` — one feature, full acceptance run

1. Find the feature in `features.json` and its spec: `specs/changes/F-012-<kebab-title>/spec.md`. If the change folder was archived long ago and requirements now live only in `specs/current/`, use those.
2. Start the feature's components: its `depends_on` first, then the component that carries the proof — `scripts/<id>/run.sh` for each.
3. Execute every acceptance scenario AS-1…AS-n:
   - **Given** — reach the precondition (seed data, navigate).
   - **When** — perform the interaction (through the UI, an HTTP request or a command, per the verify method).
   - **Then** — check the observable outcome; capture proof at the assertion moment.
4. Evidence naming: primary file `evidence/F-XXX-<kebab-title>.<ext>` (e.g. `evidence/F-012-streak-badge.png`); additional scenarios `…-as2.<ext>`, failures `…-fail.<ext>`. Extension follows the verify method: `.png` for `simulator`/`browser`, `.txt` for `http`/`cli`.
5. Report PASS/FAIL per scenario, each with its evidence path.
6. Ledger update:
   - All scenarios PASS and the primary evidence file exists → you may set `"passes": true` with the evidence path.
   - Any FAIL → `passes` must be (or become) `false`; keep the failing proof file and quote a short excerpt of the component's logs in your report.

### `/verify <component-id>` — one component's regression pass

Same as `/verify all` below, restricted to features whose `components` include that id. Useful after changing something shared (an API contract, a design token).

### `/verify all` — regression pass

1. Take every feature with `"passes": true`, grouped by component (start each component once, verify all its features, move on — restarting a simulator per feature is wasteful), in id order within a group.
2. For each, execute ONE core scenario (AS-1, or the most representative one) with the same discipline and evidence naming as above.
3. Any FAIL → flip that feature's `passes` back to `false` (keep its old `evidence` path for reference) and append a regression entry to `PROGRESS.md`: date, feature id, what broke, evidence of the failure.
4. Report a compact table: id / title / result / evidence path, then totals.

### `/verify` — default: recently touched features

1. Determine what changed: `git status --short`, `git diff --name-only`, and the last few commits.
2. Map changed files to features: in-flight `specs/changes/<slug>/` folders (their plan.md lists exact file paths), feature ids in recent commit messages, and the latest `PROGRESS.md` entry.
3. Verify each mapped feature as in single-feature mode.
4. If nothing maps, say so and offer `/verify all` or `/verify F-XXX`.

## Driving discipline (binding — same rules as /build-next and the app-tester agent)

- **`simulator` / `browser`** — always take an accessibility snapshot (`snapshot_ui` on iOS, aria snapshot in the browser) before tapping or clicking; never guess coordinates from screenshots. Screenshot = evidence, snapshot = navigation. Tool names differ per MCP server (XcodeBuildMCP vs Playwright vs mobile-mcp): discover them from your available tools; do not assume.
- **`http`** — issue the real requests against the running API (curl is denied by permissions; use the component's own test runner, e.g. vitest + supertest, or a script under `apps/<id>/`). Evidence is a `.txt` transcript: method, path, request body, status code, response body, one per scenario. Cover the failure scenarios too (validation, unauthorized) — an API that only proves its happy path is not verified.
- **`cli`** — run the real commands; evidence is a `.txt` transcript of command, output and exit code.
- **`none`** (library) — its unit test run is the evidence; save the test output as `.txt`.
- Delegating to the `app-tester` agent is encouraged for long scenario lists — it follows this same discipline and returns per-scenario PASS/FAIL plus evidence paths.
- Prefer deterministic runs: seeded/demo data, animations-off flags, fixed clock and a test database as defined in `docs/tech/testing.md`, when the component provides them.
- On FAIL, capture the failing proof file AND a relevant log excerpt from the component; a bare "it failed" is not a report.

## Reporting

End every run with:

- Per-scenario verdict lines: `AS-1 PASS — evidence/F-012-streak-badge.png` / `AS-3 FAIL — evidence/F-012-streak-badge-as3-fail.png (button disabled)`.
- Ledger changes made (which `passes` flags moved, with justification).
- Suggested next step: fix via `/build-next F-XXX` if something failed, `/status` otherwise.
