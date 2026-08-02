# Setup recipes (Phase 5)

Everything in this file is parameterized by the platform chosen in Q-T1.
Substitute `{{AppName}}` (PascalCase app name), `{{app-slug}}` (lowercase,
hyphen-free) and `{{BUNDLE_ID}}` before writing any file. Default bundle id:
`com.{{app-slug}}.app` — if the user mentioned an Apple Developer account or a
company domain, use their reverse-DNS prefix instead (one quick confirmation,
don't interview again).

Order of operations: **1** `.mcp.json` → **2** app scaffold → **3** scripts →
**4** `.env.example` → **5** stack rule file → **6** CLAUDE.md identity line.

---

## 1. Assemble .mcp.json

1. Pick the variant for the platform:
   - iOS native → `templates/mcp/ios.json`
   - Web → `templates/mcp/web.json`
   - Cross-platform Expo → `templates/mcp/cross-platform.json`
2. Copy its content to `.mcp.json` at the repo root (overwrite — the template
   ships the iOS variant by default).
3. If a backend was chosen (Q-T3 / ADRs): open `templates/mcp/backends.md`,
   copy the matching server block (Supabase / Convex / GitHub) into the
   `mcpServers` object. Follow that file's guidance notes (version pinning,
   timeouts).
4. Keep the `context7` entry that every variant already contains — it is the
   documentation lookup and must survive assembly.
5. Add nothing else. Context hygiene: every extra MCP server costs tokens in
   every future session.
6. Validate: `jq . .mcp.json` must succeed.

**Changes take effect only after the user restarts Claude Code and approves the
servers** — Phase 6 handles that handoff.

## 2. Scaffold the app in app/

`app/` must not exist yet (fresh template). If it does, stop and ask.

### iOS native (SwiftUI)

Target layout: `app/{{AppName}}/{{AppName}}.xcodeproj` + sources in
`app/{{AppName}}/{{AppName}}/`.

Preferred routes, in order:

1. **XcodeBuildMCP scaffold tool** — if the XcodeBuildMCP server is already
   approved in this session, use its project-scaffold tool (discover the exact
   tool name from the available tools; it takes app name, bundle id, path).
2. **Xcode GUI (most reliable fallback)** — ask the user to do it once by
   hand: Xcode → New Project → iOS App, Product Name `{{AppName}}`, Bundle
   Identifier `{{BUNDLE_ID}}`, Interface SwiftUI, Language Swift, Storage
   None, save into `app/`. Takes them under a minute; wait, then verify.
3. **Manual project files** — last resort: write a minimal SwiftUI app
   (`{{AppName}}App.swift` with `@main` App struct, `ContentView.swift`,
   `Assets.xcassets`) plus a minimal `project.pbxproj`. The pbxproj format is
   plain text but unforgiving — only attempt if routes 1 and 2 are impossible,
   and verify immediately with a build.

Whatever the route, verify before moving on:

```bash
xcodebuild -project "app/{{AppName}}/{{AppName}}.xcodeproj" -scheme "{{AppName}}" \
  -destination "platform=iOS Simulator,name=iPhone 16" -derivedDataPath build -quiet build
```

(If "iPhone 16" doesn't exist, pick a device from
`xcrun simctl list devices available`, and use that name in the scripts below.)

### Cross-platform (Expo / React Native)

```bash
npx create-expo-app@latest app --template blank-typescript
```

Then, inside `app/`:

- Add jest so `scripts/test.sh` works:
  `npx expo install jest-expo jest @types/jest` and add
  `"test": "jest --ci"` + `"jest": { "preset": "jest-expo" }` to package.json.
- Note for the user (goes in the final recap): **no Mac needed** for device
  builds — `npx eas build` compiles iOS/Android in Expo's cloud. Local
  simulator run (Mac only): `npx expo run:ios` or Expo Go via `npx expo start`.

### Web (Vite or Next.js)

- Default (SPA / app-like product): `npm create vite@latest app -- --template react-ts`
- If SEO/SSR genuinely matters (content-heavy, public pages):
  `npx create-next-app@latest app --ts --app --no-src-dir` (record the choice
  in the tech-stack ADR either way).
- Add vitest so `scripts/test.sh` works:
  `cd app && npm i -D vitest` and add `"test": "vitest run"` to package.json.
- Playwright note: browser automation comes from the Playwright **MCP server**
  (`templates/mcp/web.json`), which manages its own browser install on first
  run — do not add Playwright as an app dependency for verification.

After any scaffold: launch it once locally to confirm it starts, then move on
(the screenshot proof happens in Phase 6).

## 3. Create scripts/

Write the four scripts below for the chosen stack, then:

```bash
chmod +x scripts/run.sh scripts/format.sh scripts/test.sh scripts/verify-quick.sh
bash -n scripts/*.sh
```

Contract (see `scripts/README.md`): hooks call these if present; each exits
non-zero on failure; `verify-quick.sh` must stay under 60 seconds.

### iOS scripts

`scripts/run.sh`:

```bash
#!/usr/bin/env bash
# Build the app and launch it in the iOS simulator.
set -euo pipefail
cd "$(dirname "$0")/.."
APP_NAME="{{AppName}}"
BUNDLE_ID="{{BUNDLE_ID}}"
SIMULATOR="${SIMULATOR:-iPhone 16}"
xcodebuild -project "app/${APP_NAME}/${APP_NAME}.xcodeproj" -scheme "$APP_NAME" \
  -destination "platform=iOS Simulator,name=${SIMULATOR}" \
  -derivedDataPath build -quiet build
xcrun simctl boot "$SIMULATOR" >/dev/null 2>&1 || true
open -a Simulator
APP_PATH="$(find build/Build/Products -maxdepth 2 -name "${APP_NAME}.app" | head -n 1)"
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted "$BUNDLE_ID"
```

`scripts/format.sh`:

```bash
#!/usr/bin/env bash
# Format Swift sources. The post-edit hook calls this with the edited file path;
# with no argument it formats all of app/.
set -euo pipefail
cd "$(dirname "$0")/.."
TARGET="${1:-app/}"
case "$TARGET" in
  *.swift) ;;
  app/) ;;
  *) exit 0 ;;
esac
command -v swiftformat >/dev/null 2>&1 || exit 0
swiftformat "$TARGET" --quiet
```

`scripts/test.sh`:

```bash
#!/usr/bin/env bash
# Full test suite on the simulator.
set -euo pipefail
cd "$(dirname "$0")/.."
APP_NAME="{{AppName}}"
xcodebuild -project "app/${APP_NAME}/${APP_NAME}.xcodeproj" -scheme "$APP_NAME" \
  -destination "platform=iOS Simulator,name=${SIMULATOR:-iPhone 16}" \
  -derivedDataPath build -quiet test
```

`scripts/verify-quick.sh`:

```bash
#!/usr/bin/env bash
# Fast sanity gate (< 60s incremental): does it still compile?
set -euo pipefail
cd "$(dirname "$0")/.."
APP_NAME="{{AppName}}"
xcodebuild -project "app/${APP_NAME}/${APP_NAME}.xcodeproj" -scheme "$APP_NAME" \
  -destination "platform=iOS Simulator,name=${SIMULATOR:-iPhone 16}" \
  -derivedDataPath build -quiet build
```

(First run is slow; incremental builds against the cached `build/` derived data
stay well under 60s. If tests are ever fast enough, tighten this later.)

### Expo scripts

`scripts/run.sh`:

```bash
#!/usr/bin/env bash
# Start the dev server and open the app on the iOS simulator (Mac) —
# on other hosts, run without --ios and use Expo Go or an EAS build.
set -euo pipefail
cd "$(dirname "$0")/../app"
if [ "$(uname)" = "Darwin" ]; then
  npx expo start --ios
else
  npx expo start
fi
```

`scripts/format.sh`:

```bash
#!/usr/bin/env bash
# Format sources. The post-edit hook calls this with the edited file path;
# with no argument it formats all of app/.
set -euo pipefail
cd "$(dirname "$0")/.."
TARGET="${1:-app/}"
case "$TARGET" in
  app/*|app/) ;;
  *) exit 0 ;;
esac
npx prettier --write --ignore-unknown --log-level warn "$TARGET"
```

`scripts/test.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../app"
npm test
```

`scripts/verify-quick.sh`:

```bash
#!/usr/bin/env bash
# Fast sanity gate (< 60s): typecheck only.
set -euo pipefail
cd "$(dirname "$0")/../app"
npx tsc --noEmit
```

### Web scripts

`scripts/run.sh`:

```bash
#!/usr/bin/env bash
# Start the dev server (foreground — agents should run it in the background).
set -euo pipefail
cd "$(dirname "$0")/../app"
npm run dev
```

`scripts/format.sh`: same as the Expo version above (prettier,
`--ignore-unknown`, scoped to `app/`).

`scripts/test.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../app"
npm test
```

`scripts/verify-quick.sh`:

```bash
#!/usr/bin/env bash
# Fast sanity gate (< 60s): typecheck only.
set -euo pipefail
cd "$(dirname "$0")/../app"
npx tsc --noEmit
```

## 4. Append to .env.example

Append only the key **names** the chosen stack/backend actually needs, each
with a one-line comment — never a real value, and never touch `.env` itself
(reading it is denied by permissions, by design). Examples:

```
# Supabase project ref (backend chosen at onboarding) — dashboard > project settings
SUPABASE_PROJECT_REF=
```

`CONTEXT7_API_KEY` and `SUPABASE_PROJECT_REF` may already be present from the
template — don't duplicate lines that exist.

## 5. Generate the stack rule file in .claude/rules/

Path-scoped rules load only when matching files are edited (see
`.claude/rules/README.md`). Write exactly one rule file for the stack, adapting
the state-management and folder names to what `docs/tech/architecture.md` and
`docs/tech/structure.md` actually say.

### iOS → `.claude/rules/swiftui.md`

```markdown
---
paths: ["app/**/*.swift"]
---
# SwiftUI conventions

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
```

### Expo → `.claude/rules/react-native.md`

```markdown
---
paths: ["app/**/*.ts", "app/**/*.tsx"]
---
# Expo / React Native conventions

- TypeScript strict; no `any` without a justifying comment.
- Screens follow the router convention in docs/tech/structure.md; shared UI in
  `components/`, logic in `lib/`.
- Style ONLY through the theme module generated from docs/design/DESIGN.md —
  no inline hex colors or magic numbers.
- Every touchable gets `testID` + `accessibilityLabel` — the app-tester agent
  drives the accessibility tree, not pixels.
- State management follows docs/tech/architecture.md; keep server/local state
  separation explicit.
- Lists use `FlatList`/`FlashList` with stable keys — never map over arrays in
  scrollviews for long content.
- Handle safe areas and keyboard avoidance on every screen.
- Errors surface per voice.md (what happened + why + next step).
- Animations respect the motion rules of DESIGN.md §7 and Reduce Motion.
```

### Web → `.claude/rules/react.md`

```markdown
---
paths: ["app/**/*.ts", "app/**/*.tsx", "app/**/*.css"]
---
# Web app conventions

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
```

## 6. Update the CLAUDE.md identity line

Replace the app placeholder in the identity paragraph at the top of `CLAUDE.md`
with the real app name and one-line pitch (e.g. "This repository builds
**{{AppName}}** — <one-line pitch> — 100% via AI agents…"). **Change nothing
else in CLAUDE.md** — its rules, doc map and guardrails are template-level and
not yours to edit.

## Final reminder

`.mcp.json` edits only apply after the user **restarts Claude Code, accepts
workspace trust and approves the MCP servers**. Do not attempt to call the new
servers in this session; Phase 6 of the SKILL handles the restart-and-resume
handoff (iOS excepted — `xcodebuild`/`xcrun simctl` already work over Bash).
