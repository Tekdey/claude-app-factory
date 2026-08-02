# Setup recipes (Phase 5)

Everything here is driven by **`components.json`** (written in Phase 3): you run
each step once per component, in `depends_on` order (dependencies first).

Substitute `{{AppName}}` (PascalCase product name), `{{app-slug}}` (lowercase,
hyphen-free) and `{{BUNDLE_ID}}` before writing any file. Default bundle id:
`com.{{app-slug}}.app` — if the user mentioned an Apple Developer account or a
company domain, use their reverse-DNS prefix instead (one quick confirmation,
don't interview again).

**Invariants that every command relies on — never deviate:**

| Thing | Path |
|---|---|
| Component source | `apps/<id>/` |
| Component scripts | `scripts/<id>/{run,test,format,verify-quick}.sh` |
| Root dispatchers (called by hooks) | `scripts/format.sh`, `scripts/verify-quick.sh` |
| Component rule file | `.claude/rules/<id>.md` with `paths: ["apps/<id>/**"]` |

Order of operations: **1** `.mcp.json` → **2** scaffolds → **3** scripts →
**4** `.env.example` → **5** rule files → **6** CLAUDE.md identity line.

---

## 1. Assemble .mcp.json

Collect the servers **every** component needs, merge them into one
`mcpServers` object, and write it to `.mcp.json` at the repo root (overwrite —
the template ships the iOS variant by default).

| Component `verify` | Source variant | Server |
|---|---|---|
| `simulator` (native iOS) | `templates/mcp/ios.json` | XcodeBuildMCP |
| `simulator` (Expo/RN) | `templates/mcp/cross-platform.json` | mobile-mcp |
| `browser` | `templates/mcp/web.json` | Playwright |
| `http`, `cli`, `none` | — | none needed (Bash covers it) |

Rules:

1. Merge, don't concatenate: one `mcpServers` object, unique keys. A project
   with an iOS app **and** a marketing site gets XcodeBuildMCP **and**
   Playwright — that is expected, not bloat.
2. Keep the `context7` entry exactly once — it is the documentation lookup and
   must survive the merge.
3. If a backend was chosen (Q-T3 / ADRs): open `templates/mcp/backends.md` and
   copy the matching block (Supabase / Convex / GitHub) into the same object.
   Follow that file's notes on version pinning and timeouts.
4. Add nothing else. Every extra server costs tokens in every future session.
5. Validate: `jq . .mcp.json` must succeed.

**Changes take effect only after the user restarts Claude Code and approves the
servers** — Phase 6 handles that handoff.

## 2. Scaffold each component in apps/<id>/

Create `apps/` if needed (`mkdir -p apps`). Each component's own folder,
`apps/<id>/`, must not exist yet — if it does, that component is already
scaffolded: skip it and say so rather than overwriting. (This is what makes the
"Add a component" re-run safe: existing components are left untouched.)

Run the recipe matching each component's `kind` + stack. After each scaffold,
launch it once locally to confirm it starts, then move to the next (proof
capture happens in Phase 6).

### mobile-app · iOS native (SwiftUI) → `apps/<id>/`

Target layout: `apps/<id>/{{AppName}}.xcodeproj` + sources in
`apps/<id>/{{AppName}}/`.

Preferred routes, in order:

1. **Xcode GUI (default — most reliable)** — ask the user to do it once by
   hand: Xcode → New Project → iOS App, Product Name `{{AppName}}`, Bundle
   Identifier `{{BUNDLE_ID}}`, Interface SwiftUI, Language Swift, Storage
   None, save into `apps/<id>/`. Takes them under a minute; wait, then verify.
   Yields exactly the target layout above.
2. **XcodeBuildMCP `scaffold_ios_project`** — only when the
   `project-scaffolding` workflow is enabled. XcodeBuildMCP ships **simulator
   tools only by default**, so this tool is usually absent: check your available
   tools before choosing this route, and do not waste a turn hunting for it.
   Note it produces a **different layout** — a `.xcworkspace`, an app shell
   project and an SPM feature package — so the verify command and every
   `scripts/<id>/*.sh` must use `-workspace "apps/<id>/{{AppName}}.xcworkspace"`
   instead of `-project …xcodeproj`.
3. **Manual project files** — last resort: write a minimal SwiftUI app
   (`{{AppName}}App.swift` with `@main` App struct, `ContentView.swift`,
   `Assets.xcassets`) plus a minimal `project.pbxproj`. The pbxproj format is
   plain text but unforgiving — only attempt if routes 1 and 2 are impossible,
   and verify immediately with a build.

Pick the simulator ONCE and reuse it everywhere. Resolve it to a UDID: device
names now repeat across installed runtimes, so `-destination "name=…"` can be
ambiguous.

```bash
SIM_UDID=$(xcrun simctl list devices available -j \
  | jq -r '[.devices[][] | select(.name=="iPhone 16")][0].udid // empty')
[ -n "$SIM_UDID" ] || SIM_UDID=$(xcrun simctl list devices available -j \
  | jq -r '[.devices[][] | select(.isAvailable)][0].udid')
xcodebuild -project "apps/<id>/{{AppName}}.xcodeproj" -scheme "{{AppName}}" \
  -destination "id=$SIM_UDID" -derivedDataPath build -quiet build
```

Record the chosen device name in `docs/tech/tech-stack.md` and use `id=$SIM_UDID`
in the scripts below (they resolve it the same way).

**Design tokens:** `docs/design/DESIGN.md` §9 contains an "iOS token file —
create at scaffold time" block written by `/design`. Copy it now to
`apps/<id>/{{AppName}}/DesignSystem/DesignTokens.swift` and add the matching
light/dark color sets to `Assets.xcassets`. Skipping this leaves every rule file
pointing at a token file that does not exist.

### mobile-app · cross-platform (Expo / React Native) → `apps/<id>/`

```bash
npx create-expo-app@latest apps/<id> --template blank-typescript --no-agents-md
rm -rf apps/<id>/.git          # create-expo-app always git-inits and has no --no-git
rm -f apps/<id>/CLAUDE.md apps/<id>/AGENTS.md
rm -rf apps/<id>/.claude
```

The cleanup is not optional: a nested `.git` makes the whole component invisible
to this repository, and a nested `CLAUDE.md` / `.claude/settings.json` competes
with this repo's operating manual and can enable plugins the user never
approved. **No scaffold may leave a `CLAUDE.md`, `AGENTS.md` or `.claude/`
inside `apps/<id>/` — check after every create command.**

Then, inside `apps/<id>/`:

- Add jest so the test script works: `npx expo install jest-expo jest @types/jest --dev`
  and add `"test": "jest --ci --passWithNoTests"`, `"typecheck": "tsc --noEmit"`
  and `"jest": { "preset": "jest-expo" }` to package.json. Without
  `--passWithNoTests` the test script fails the moment the component is created,
  before anyone has written a test.
- Note for the final recap: **no Mac needed** for device builds —
  `npx eas build` compiles iOS/Android in Expo's cloud. Local simulator run
  (Mac only): `npx expo run:ios` or Expo Go via `npx expo start`.

### web-app → `apps/<id>/`

- Next.js (SEO/SSR matters): `npx create-next-app@latest apps/<id> --ts --app --no-src-dir`
- Vite + React (SPA behind a login): `npm create vite@latest apps/<id> -- --template react-ts`,
  then `npm i -D vitest` and add `"test": "vitest run --passWithNoTests"` plus
  `"typecheck": "tsc -b --noEmit"` to package.json. **`tsc -b` is load-bearing**:
  create-vite emits a solution-style root tsconfig (`{"files": [], "references":
  […]}`) that plain `tsc --noEmit` silently ignores, checking zero files.
- Browser automation comes from the Playwright **MCP server**, which manages its
  own browser install — do not add Playwright as an app dependency.

### marketing-site → `apps/<id>/`

```bash
npm create astro@latest apps/<id> -- --template minimal --no-install --no-git --no-ai --skip-houston
cd apps/<id> && npm install && npm i -D @astrojs/check typescript
```

Add `"typecheck": "astro check"` to package.json. All three parts matter:
`--no-ai` stops Astro writing its own `AGENTS.md`/`CLAUDE.md` into the
component; `@astrojs/check` must be installed or `astro check` prompts to
install it and, with no TTY (exactly how the Stop hook runs it), **exits 0
without checking anything** — a permanently green gate.

- Astro is the default because a landing page should ship near-zero JS; it also
  keeps the marketing surface independent from the product's app framework.
- Wire the primary CTA to the real destination as soon as it exists (App Store
  URL, or the web app's sign-up route) — leave a single, clearly named constant
  for it rather than scattering the link.
- If the user chose Next.js instead (shared components with an existing web
  app), use the web-app recipe and record the reason in the tech-stack ADR.

### api → `apps/<id>/`

```bash
mkdir -p apps/<id>/src && cd apps/<id>
npm init -y
npm i express
npm i -D typescript tsx vitest supertest @types/express @types/node @types/supertest
npx tsc --init --rootDir src --outDir dist --strict --module nodenext --moduleResolution nodenext --target es2022
```

Then in `apps/<id>/package.json` set `"type": "module"` and the scripts:
`"dev": "tsx watch src/server.ts"`, `"build": "tsc"`,
`"test": "vitest run --passWithNoTests"`, `"typecheck": "tsc --noEmit"`.

`tsc --init` leaves the config incomplete for this layout — add to
`apps/<id>/tsconfig.json`:

```jsonc
  "compilerOptions": { /* … */ "types": ["node"] },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
```

Without `include`/`exclude` the default `**/*` fights `rootDir: src` and both
`build` and `typecheck` hard-fail as soon as a file lives outside `src/`.
Without `"types": ["node"]`, `process` only typechecks by accident (via a
transitive `@types/node`).

Minimum viable server (`src/server.ts`) exposing a health route the agent can
verify immediately:

```ts
import express from "express";

export const app = express();
app.use(express.json());
app.get("/health", (_req, res) => res.json({ status: "ok" }));

const port = Number(process.env.PORT ?? 3000);
if (process.env.NODE_ENV !== "test") {
  app.listen(port, () => console.log(`listening on :${port}`));
}
```

Export `app` separately from `listen` so `supertest` can drive it in-process —
that is what makes `verify: http` fast and deterministic.

**ESM + nodenext: every relative import needs the compiled `.js` extension**, even
though the file on disk is `.ts`. Write the reference test at
`apps/<id>/src/server.test.ts` (inside `src/`, per the tsconfig above):

```ts
import { describe, it, expect } from "vitest";
import request from "supertest";
import { app } from "./server.js";   // .js — NOT "./server"

describe("GET /health", () => {
  it("reports ok", async () => {
    const res = await request(app).get("/health");
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: "ok" });
  });
});
```

This test is also the shape every `verify: http` acceptance scenario takes.

Datastore: follow the ADR. PostgreSQL → add the driver plus a migration tool and
document the connection env var in `.env.example`. SQLite → a file under
`apps/<id>/data/` with the path in `.env.example` and the file gitignored.

### admin → `apps/<id>/`

Same recipe as `web-app`, sharing the design tokens. Keep it a separate
component (separate deploy, separate auth surface) unless the user asked for a
route inside the main web app.

### cli → `apps/<id>/`

Node + TypeScript with a `bin` entry in package.json, or the language of the
component it serves. Add `"typecheck": "tsc --noEmit"` and
`"test": "vitest run --passWithNoTests"` to package.json. Must print `--help`
and exit 0 — that is its smoke test.

### library → `apps/<id>/`

Plain package with the stack's standard layout, `verify: none` (its unit tests
are the proof). Consumers import it via a workspace reference; record that in
`architecture.md`.

## 3. Create scripts/

Two layers: **per-component** scripts holding the real commands, and two **root
dispatchers** that the hooks call.

```bash
mkdir -p scripts/<id>            # one per component
chmod +x scripts/*.sh scripts/*/*.sh
bash -n scripts/*.sh scripts/*/*.sh
```

Contract (see `scripts/README.md`): each script exits non-zero on failure;
`verify-quick.sh` must stay under 60 seconds **in total** across components.

### Conventions every component script follows

- Starts with `#!/usr/bin/env bash` and `set -euo pipefail`.
- `run.sh`, `test.sh`, `verify-quick.sh` `cd` **into the component**:
  `cd "$(dirname "$0")/../../apps/<id>"`.
- `format.sh` stays at the **repo root** (`cd "$(dirname "$0")/../.."`) because
  it receives repo-relative paths from the dispatcher. Full shape:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
TARGET="${1:-apps/<id>/}"
case "$TARGET" in
  apps/<id>/*|apps/<id>/) ;;
  *) exit 0 ;;
esac
npx prettier --write --ignore-unknown --log-level warn "$TARGET"
```

- Never call a tool through bare `npx` in a gate: `npx <tool>` silently
  downloads a same-named package when the tool is absent locally (`npx tsc`
  fetches an unrelated `tsc@2.0.4`). Always go through a package.json script
  (`npm run typecheck`), which fails loudly instead.

### Root dispatchers (write these verbatim, they are stack-independent)

`scripts/format.sh` — the post-edit hook passes it the edited file path:

```bash
#!/usr/bin/env bash
# Route a file to its component's formatter. Called by .claude/hooks/post-edit.sh.
set -uo pipefail
cd "$(dirname "$0")/.."
target="${1:-}"
[ -n "$target" ] || exit 0
# The hook passes an ABSOLUTE path — reduce it to a repo-relative one, resolving
# symlinks on both sides (macOS /tmp vs /private/tmp would otherwise no-op).
root=$(pwd -P)
if [ -e "$target" ]; then
  target="$(cd "$(dirname "$target")" && pwd -P)/$(basename "$target")"
fi
target="${target#"$root"/}"
case "$target" in
  apps/*) id="${target#apps/}"; id="${id%%/*}" ;;
  *) exit 0 ;;
esac
fmt="scripts/${id}/format.sh"
[ -x "$fmt" ] || exit 0
"$fmt" "$target"
```

`scripts/verify-quick.sh` — the Stop hook gate:

```bash
#!/usr/bin/env bash
# Fast sanity gate across every component. Called by .claude/hooks/stop-gate.sh.
set -uo pipefail
cd "$(dirname "$0")/.."
status=0
for script in scripts/*/verify-quick.sh; do
  [ -x "$script" ] || continue
  id="${script#scripts/}"; id="${id%/verify-quick.sh}"
  # Skip a component whose dependencies are not installed yet — a gate that
  # fails because nothing is installed teaches the agent to ignore the gate.
  if [ -f "apps/$id/package.json" ] && [ ! -d "apps/$id/node_modules" ]; then
    echo "skipping $id (dependencies not installed)" >&2
    continue
  fi
  if ! "$script"; then
    echo "verify-quick failed: $script" >&2
    status=1
  fi
done
exit "$status"
```

### iOS component scripts

`scripts/<id>/run.sh`:

```bash
#!/usr/bin/env bash
# Build the app and launch it in the iOS simulator.
set -euo pipefail
cd "$(dirname "$0")/../.."
APP_NAME="{{AppName}}"
BUNDLE_ID="{{BUNDLE_ID}}"
SIMULATOR="${SIMULATOR:-iPhone 16}"
xcodebuild -project "apps/<id>/${APP_NAME}.xcodeproj" -scheme "$APP_NAME" \
  -destination "platform=iOS Simulator,name=${SIMULATOR}" \
  -derivedDataPath build -quiet build
xcrun simctl boot "$SIMULATOR" >/dev/null 2>&1 || true
open -a Simulator
APP_PATH="$(find build/Build/Products -maxdepth 2 -name "${APP_NAME}.app" | head -n 1)"
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted "$BUNDLE_ID"
```

`scripts/<id>/format.sh`:

```bash
#!/usr/bin/env bash
# Format Swift sources; receives one file path, or defaults to the component.
set -euo pipefail
cd "$(dirname "$0")/../.."
TARGET="${1:-apps/<id>/}"
case "$TARGET" in
  *.swift|apps/<id>/) ;;
  *) exit 0 ;;
esac
command -v swiftformat >/dev/null 2>&1 || exit 0
swiftformat "$TARGET" --quiet
```

`scripts/<id>/test.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
APP_NAME="{{AppName}}"
xcodebuild -project "apps/<id>/${APP_NAME}.xcodeproj" -scheme "$APP_NAME" \
  -destination "platform=iOS Simulator,name=${SIMULATOR:-iPhone 16}" \
  -derivedDataPath build -quiet test
```

`scripts/<id>/verify-quick.sh`: the cheapest check that catches real breakage —
`swiftformat --lint apps/<id>/` when swiftformat is installed, otherwise the
same `xcodebuild build` as `test.sh` but guarded so it is skipped when the
derived-data cache is cold:

```bash
if [ ! -d build/Build ]; then
  echo "skipping iOS build gate (no warm derived data yet)" >&2
  exit 0
fi
```

A full first-run `xcodebuild` takes minutes and blows the 60s budget at every
session stop; the full build belongs in `test.sh` and in `/verify`.

### Expo component scripts

```bash
# run.sh — dev server + simulator on macOS, Expo Go elsewhere
cd "$(dirname "$0")/../../apps/<id>"
if [ "$(uname)" = "Darwin" ]; then npx expo start --ios; else npx expo start; fi
```

`test.sh` → `npm test`; `verify-quick.sh` → `npm run typecheck`;
`format.sh` → `npx prettier --write --ignore-unknown --log-level warn "$TARGET"`
guarded by `case "$TARGET" in apps/<id>/*|apps/<id>/) ;; *) exit 0 ;; esac`.

### web-app / marketing-site / admin component scripts

```bash
# run.sh — dev server (foreground; agents run it in the background)
cd "$(dirname "$0")/../../apps/<id>" && npm run dev
```

`test.sh` → `npm test`; `verify-quick.sh` → `npm run typecheck`; `format.sh` →
prettier, scoped exactly like the Expo one.

### api component scripts

```bash
# run.sh
cd "$(dirname "$0")/../../apps/<id>" && npm run dev
```

`test.sh` → `npm test` (vitest + supertest); `verify-quick.sh` →
`npm run typecheck`; `format.sh` → prettier, scoped to `apps/<id>/`.

### cli / library component scripts

```bash
# run.sh — for a CLI, running it with --help IS its smoke test
cd "$(dirname "$0")/../../apps/<id>" && npm start -- --help
```

`test.sh` → `npm test` (a library's test suite is its only proof: `verify: none`);
`verify-quick.sh` → `npm run typecheck`; `format.sh` → prettier, scoped to
`apps/<id>/`. A `library` component has no meaningful `run.sh`: write one that
prints a one-line explanation and exits 0, so `./init.sh start <id>` stays
predictable.

## 4. Append to .env.example

Append only the key **names** each component actually needs, grouped by
component with a comment header, never a real value — and never touch `.env`
itself (reading it is denied by permissions, by design):

```
# --- api ---
# Postgres connection string (see docs/adr/0003-datastore.md)
DATABASE_URL=
# Port the API listens on (defaults to 3000)
PORT=

# --- ios ---
# Base URL the app calls in development
API_BASE_URL=
```

`CONTEXT7_API_KEY` and `SUPABASE_PROJECT_REF` may already be present from the
template — don't duplicate lines that exist.

## 5. Generate one rule file per component

Path-scoped rules load only when matching files are edited (see
`.claude/rules/README.md`). Write **one file per component**, named
`.claude/rules/<id>.md`, so two components sharing a stack still get their own
scoped conventions. Adapt state-management and folder names to what
`docs/tech/architecture.md` and `docs/tech/structure.md` actually say.

### iOS component

```markdown
---
paths: ["apps/<id>/**"]
---
# <id> — SwiftUI conventions

- One primary View per file; file name matches the type name.
- Screens go in `Screens/`, reusable views in `Components/`, models in
  `Models/` — exact map in docs/tech/structure.md.
- NEVER hardcode colors, fonts, spacing or radii. Use the design tokens
  generated from docs/design/DESIGN.md (DesignTokens.swift).
- State management follows docs/tech/architecture.md (@Observable models by
  default); no singletons for view state.
- Every interactive element gets `.accessibilityIdentifier("…")` — the
  app-tester agent drives the app through the accessibility tree, not pixels.
- Support Dynamic Type; custom controls get accessibility labels.
- Add a `#Preview` with representative sample data for every screen.
- Async work uses structured concurrency (`.task`); never block the main actor.
- Errors surface per voice.md (what happened + why + next step) — no bare `print`.
- Motion follows DESIGN.md §7 and respects Reduce Motion.
- Network calls go through the single API client; base URL from configuration,
  never hardcoded.
```

### Expo component

```markdown
---
paths: ["apps/<id>/**"]
---
# <id> — Expo / React Native conventions

- TypeScript strict; no `any` without a justifying comment.
- Screens follow the router convention in docs/tech/structure.md; shared UI in
  `components/`, logic in `lib/`.
- Style ONLY through the theme module generated from docs/design/DESIGN.md —
  no inline hex colors or magic numbers.
- Every touchable gets `testID` + `accessibilityLabel` — the app-tester agent
  drives the accessibility tree, not pixels.
- State management follows docs/tech/architecture.md; keep server/local state
  separation explicit.
- Lists use `FlatList`/`FlashList` with stable keys.
- Handle safe areas and keyboard avoidance on every screen.
- Errors surface per voice.md (what happened + why + next step).
- Animations respect the motion rules of DESIGN.md §7 and Reduce Motion.
```

### web-app / marketing-site / admin component

```markdown
---
paths: ["apps/<id>/**"]
---
# <id> — Web conventions

- TypeScript strict; no `any` without a justifying comment.
- Components/pages placement per docs/tech/structure.md.
- Style ONLY through the CSS variables in docs/design/tokens.css — no inline
  hex colors or magic numbers; light AND dark themes must both work.
- Semantic HTML first (button/nav/main/form); ARIA only where semantics fall
  short — the app-tester agent drives the accessibility tree, not pixels.
- Interactive elements are keyboard-reachable with visible focus states.
- State management follows docs/tech/architecture.md; URL is state where it
  makes sense (shareable views).
- Errors surface per voice.md (what happened + why + next step).
- Motion follows DESIGN.md §7 and respects prefers-reduced-motion.
- Marketing surfaces: no client JS unless it earns its weight; images sized and
  lazy-loaded; the primary CTA destination lives in one named constant.
```

### api component

```markdown
---
paths: ["apps/<id>/**"]
---
# <id> — API conventions

- TypeScript strict, ESM, `type: module`. No `any` without a justifying comment.
- Layering: route handler → service → data access. Handlers stay thin: parse,
  delegate, format. No SQL or business rules inside a route.
- Validate every request body and query param at the boundary; reject with the
  documented error shape `{ error: { code, message } }` — one shape everywhere.
- Status codes: 400 validation, 401 unauthenticated, 403 unauthorized,
  404 missing, 409 conflict, 422 semantic, 500 only for genuine bugs.
- Never leak internals in error messages or logs (no stack traces, no secrets,
  no raw SQL) — the client-facing text follows voice.md.
- Every endpoint has a vitest + supertest test covering success, validation
  failure and the unauthorized case. Tests drive the exported `app`, never a
  live network port.
- Authorization is checked per resource, not just per route — a user must never
  read or write another user's data.
- Secrets come from environment variables declared in `.env.example`; never
  read `.env` and never commit values.
- Migrations are forward-only and checked in; document each in the ADR that
  introduced the schema change.
```

### cli / library component

```markdown
---
paths: ["apps/<id>/**"]
---
# <id> — CLI / library conventions

- TypeScript strict, ESM. No `any` without a justifying comment.
- Public surface is explicit: one entry point exporting exactly what consumers
  need. Everything else stays internal — other components import the entry
  point, never a deep path.
- A CLI prints actionable errors to stderr and exits non-zero; `--help` always
  works and lists every command. Output follows voice.md.
- No breaking change to the public surface without an ADR — consumers listed in
  components.json `depends_on` must be updated in the same feature.
- Every exported function has a unit test; the test run IS this component's
  evidence.
```

## 6. Update the CLAUDE.md identity line

Replace the app placeholder in the identity paragraph at the top of `CLAUDE.md`
with the real product name and one-line pitch. **Change nothing else in
CLAUDE.md** — its rules, doc map and guardrails are template-level and not
yours to edit.

## Final reminder

`.mcp.json` edits only apply after the user **restarts Claude Code, accepts
workspace trust and approves the MCP servers**. Do not attempt to call the new
servers in this session; Phase 6 of the SKILL handles the restart-and-resume
handoff (iOS excepted — `xcodebuild`/`xcrun simctl` already work over Bash, and
`api`/`cli` components verify over plain Bash too).
