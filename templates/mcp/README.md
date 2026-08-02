# MCP server variants

This folder holds the per-platform building blocks that `/onboard` uses to assemble the
project's `.mcp.json` (the file at the repo root that gives the agent its build/test/drive
tools). The template ships with the **iOS** variant already active at the root, because that
is the default platform. Onboarding rewrites it to match the platform you actually choose.

## Files

| File                 | Contents                                                              | Used when                         |
| -------------------- | --------------------------------------------------------------------- | --------------------------------- |
| `ios.json`           | XcodeBuildMCP (build + simulator + UI automation) + context7           | Native iOS (SwiftUI)              |
| `web.json`           | Playwright MCP (headless, isolated browser) + context7                 | Web app (PWA, Vite/Next.js)       |
| `cross-platform.json`| mobile-mcp (iOS simulator + Android emulator interaction) + context7   | Expo / React Native               |
| `backends.md`        | Copy-pasteable add-on blocks: Supabase, Convex, GitHub                 | A backend was chosen at onboarding|

Every variant keeps **context7** (up-to-date library docs — fixes stale training data) and
nothing else beyond the one platform driver. That is deliberate context hygiene: every MCP
server adds its tool definitions to the agent's context window, so we ship the minimum set
that closes the autonomous loop (build → launch → snapshot → interact → screenshot).

## How onboarding assembles `.mcp.json`

1. Copy the chosen variant over the repo root: `cp templates/mcp/<platform>.json .mcp.json`.
2. If a backend was chosen, append the matching server block from `backends.md` inside the
   `mcpServers` object (Supabase or Convex; GitHub only if the user asked for it).
3. Validate the result (`jq . .mcp.json`).
4. Tell the user to **restart Claude Code** — `.mcp.json` is only read at startup.

Never hand-edit the files in this folder for a specific project; edit the root `.mcp.json`
instead. This folder is the pristine source for future re-runs of `/onboard`.

## Approval and trust flow (important)

Project-scoped servers declared in `.mcp.json` sit in a *pending approval* state until the
user approves them interactively. The template's `.claude/settings.json` sets
`"enableAllProjectMcpServers": true` to smooth this, **but since Claude Code v2.1.196 that
committed auto-approval only takes effect after the user has accepted the workspace-trust
dialog**. Practical consequence:

1. Launch `claude` in the repo folder.
2. Accept the workspace-trust prompt.
3. Approve the project MCP servers when prompted (or they are auto-enabled once trusted).
4. After **any** later edit to `.mcp.json`: restart Claude Code and approve again if asked.

If approvals get into a confusing state, `claude mcp reset-project-choices` clears all
previous accept/reject choices for this project.

## Environment variables

All secrets use `${VAR:-}` expansion so `.mcp.json` always loads, even when the variable is
unset (the server simply runs keyless / at lower rate limits). Expansion reads the **shell
environment where you launch `claude`** — export keys in your shell profile, not just in
`.env` (the agent is denied read access to `.env` by design):

- `CONTEXT7_API_KEY` — optional, free at context7.com/dashboard, raises rate limits.
- `SUPABASE_PROJECT_REF` — only if the Supabase backend block is added.

## Switching platform later

You can change platform after onboarding (e.g. iOS → Expo):

1. `cp templates/mcp/<new-platform>.json .mcp.json`
2. Re-append your backend block from `backends.md` if you use one.
3. Restart Claude Code, accept the approval prompt.
4. Expect follow-up work: the app scaffold in `app/`, `scripts/*.sh` and
   `.claude/rules/` are stack-specific — ask the agent to migrate them and record the
   decision in an ADR (`docs/adr/`), since a platform change is a hard-to-reverse choice.

## Hardening tips

See `backends.md` for operational guidance that applies to all servers: pinning major
versions once the project is stable, adding per-server `timeout` values for build-heavy
servers, and the restart-and-approve rule after edits.
