# scripts/ — project-defined scripts

This folder ships empty (only this README). The onboarding flow (`/onboard`)
generates four scripts tailored to the chosen stack:

| Script | Contract |
|--------|----------|
| `run.sh` | Build & launch the app (simulator or dev server). Also used by `./init.sh start`. |
| `format.sh <file>` | Format the given file in place. Called by the PostToolUse hook after every edit. |
| `test.sh` | Run the full test suite. |
| `verify-quick.sh` | Fast sanity gate (build/typecheck/lint). Called by the Stop hook before a session may end. |

## Contract rules

1. **Optional by design.** Hooks call these scripts only if they exist and are
   executable — a missing script is a silent no-op, never an error. That is why
   a freshly cloned template works before onboarding.
2. **Exit codes are the API.** Every script must exit non-zero on failure; that
   is the only signal hooks understand. No exit-0-with-error-text.
3. **Keep them fast.** `verify-quick.sh` must finish in under 60 seconds — it
   runs at every session stop. Put slow, exhaustive suites in `test.sh`.
4. **Run from the repo root.** Scripts are invoked as `./scripts/<name>.sh` from
   the repository root. Only `format.sh` takes an argument (one file path); the
   others take none.

If you change stacks or tooling later, update these scripts (or ask the agent
to) — the hooks and skills that call them never change.
