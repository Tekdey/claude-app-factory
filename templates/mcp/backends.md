# Backend add-on blocks for `.mcp.json`

Copy-pasteable server entries that `/onboard` (or you, later) appends inside the
`mcpServers` object of the root `.mcp.json` when the project uses a backend. Add **one**
backend block at most — every server adds tools to the agent's context window.

After any edit to `.mcp.json`: restart Claude Code and approve the new server
(see `templates/mcp/README.md` for the trust/approval flow).

## Supabase (hosted Postgres, auth, storage, edge functions)

```json
"supabase": {
  "type": "http",
  "url": "https://mcp.supabase.com/mcp?project_ref=${SUPABASE_PROJECT_REF:-}&read_only=true&features=database,docs"
}
```

Notes:

- Authentication is OAuth in the browser on first use (run `/mcp` inside Claude Code to
  connect) — no token ever lives in this file.
- `project_ref` scopes the server to one Supabase project. Export `SUPABASE_PROJECT_REF`
  in your shell profile (also listed in `.env.example` for reference).
- `read_only=true` is the correct default for an autonomous agent: it can inspect schema,
  query data and search docs, but not mutate. Flip to `read_only=false` deliberately, only
  when the roadmap needs the agent to run migrations, and record that decision in an ADR.
- `features=database,docs` keeps the tool count lean; add `functions`, `debugging` or
  `development` to the comma list only when needed.

## Convex (reactive backend + database)

```json
"convex": {
  "command": "npx",
  "args": ["-y", "convex@latest", "mcp", "start"]
}
```

Notes:

- The MCP server is built into the Convex CLI — no separate package.
- It targets the **dev deployment only** by default and blocks production; that is exactly
  the safety posture an autonomous agent should have. Do not pass
  `--dangerously-enable-production-deployments`.
- Tools include table/data inspection, one-off queries, function runs and logs — enough
  for the agent to build and debug the full backend loop locally.

## GitHub (optional — issues, PRs, Actions)

```json
"github": {
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/"
}
```

Notes:

- Remote server with OAuth (run `/mcp` to authenticate) — zero credentials in config.
- **Optional and usually unnecessary**: this template already allows the `gh` CLI through
  Bash (with a permission prompt), which covers most PR/issue workflows with zero extra
  tool-context cost. Add this block only if the roadmap needs heavy autonomous GitHub work
  (triaging issues, managing Actions runs, code scanning).

## Operational guidance (all servers)

- **Pin majors once stable.** `@latest` is right for a fresh template (newest fixes), but
  once the app is under active development pin the major for reproducibility, e.g.
  `"xcodebuildmcp@2"` instead of `"xcodebuildmcp@latest"`, `"@playwright/mcp@0"` — then
  bump deliberately.
- **Set per-server timeouts for build-heavy servers.** `.mcp.json` supports an optional
  per-server `"timeout"` in milliseconds for tool-call wall clock. Xcode builds can be
  slow on first run; give XcodeBuildMCP room:

  ```json
  "XcodeBuildMCP": {
    "command": "npx",
    "args": ["-y", "xcodebuildmcp@latest", "mcp"],
    "env": { "XCODEBUILDMCP_SENTRY_DISABLED": "true" },
    "timeout": 600000
  }
  ```

- **Restart + approve after every edit.** `.mcp.json` is read at startup only; edits do
  nothing until Claude Code restarts, and new/changed servers may need re-approval.
- **`${VAR:-}` everywhere.** Any secret-bearing field must use default-empty expansion so
  the file loads even on a machine where the variable is unset.
- **One entry rule for remote servers.** Every entry with a `url` MUST carry
  `"type": "http"` — a `url` without `type` is a config error (silently skipped).
