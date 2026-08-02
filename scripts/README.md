# scripts/ — project-defined scripts

This folder ships empty (only this README). The onboarding flow (`/onboard`)
generates two layers, driven by `components.json`:

```
scripts/
├── format.sh                 # root dispatcher — routes a file to its component
├── verify-quick.sh           # root dispatcher — runs every component's gate
└── <component-id>/           # one folder per component in components.json
    ├── run.sh
    ├── test.sh
    ├── format.sh
    └── verify-quick.sh
```

## Root dispatchers (what the hooks call)

| Script | Contract |
|--------|----------|
| `format.sh <file>` | Normalises the (absolute) path the hook passes into a repo-relative one, reads its `apps/<id>/…` prefix and delegates to `scripts/<id>/format.sh`. Called by the PostToolUse hook after every edit. |
| `verify-quick.sh` | Runs every `scripts/*/verify-quick.sh` and fails if any of them fails. Called by the Stop hook before a session may end. |

The hooks only ever know these two paths — that is what keeps them stable as
components are added.

## Per-component scripts

| Script | Contract |
|--------|----------|
| `<id>/run.sh` | Build & launch that component (simulator, dev server, API process). Also used by `./init.sh start <id>`. |
| `<id>/format.sh <file>` | Format the given file in place, using that component's formatter. |
| `<id>/test.sh` | Run that component's full test suite. |
| `<id>/verify-quick.sh` | Fast sanity gate for that component (build/typecheck/lint). |

## Contract rules

1. **Optional by design.** Hooks and dispatchers call these scripts only if they
   exist and are executable — a missing script is a silent no-op, never an
   error. That is why a freshly cloned template works before onboarding.
2. **Exit codes are the API.** Every script must exit non-zero on failure; that
   is the only signal hooks understand. No exit-0-with-error-text.
3. **Keep them fast.** `verify-quick.sh` must finish in under 60 seconds **in
   total across every component** — it runs at every session stop. Put slow,
   exhaustive suites in `test.sh`.
4. **Working directory.** Scripts are invoked from the repository root.
   `run.sh`, `test.sh` and `verify-quick.sh` `cd` **into their component**
   (`cd "$(dirname "$0")/../../apps/<id>"`); `format.sh` stays at the **repo
   root** (`cd "$(dirname "$0")/../.."`) because it receives repo-relative
   paths. Only the `format.sh` scripts take an argument (one file path).
5. **No bare `npx` in a gate.** `npx <tool>` silently downloads a same-named
   package when the tool is absent locally, which turns a gate into a false
   failure — or worse, a false pass. Call tools through a package.json script
   (`npm run typecheck`) so a missing dependency fails loudly.
6. **Startup order.** A component listed in another's `depends_on` must be
   running first — `run.sh` starts one component, not the whole system;
   document any required sequence in `docs/tech/tech-stack.md`.

If you add a component later (`/onboard` → "Add a component") its script folder
is created alongside the others; the dispatchers pick it up automatically with
no edit. If you change stacks or tooling, update the component's scripts (or ask
the agent to) — the hooks and skills that call them never change.
