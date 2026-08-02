# Security Policy

This repository ships no runtime code and no dependencies. What it ships is a
**configuration for an autonomous coding agent** — so the security surface is
exactly three things:

| Surface | File(s) | What it controls |
|---|---|---|
| Permission rules | `.claude/settings.json` | Which tools and shell commands the agent may run without asking |
| Hooks | `.claude/hooks/*.sh` | Shell-level interception: what is blocked, formatted, or gated at session start/stop |
| MCP servers | `.mcp.json`, `templates/mcp/` | Which external processes and remote endpoints the agent is given as tools |

Every one of these is plain text in your own clone. Read them — a template that
configures an agent is only as trustworthy as the copy you actually run.

## What the template denies by default

`.claude/settings.json` splits tools into `allow` (silent), `ask` (confirm), and
`deny` (refused). The notable ones:

- **Denied outright:** reading `.env` and its environment variants, reading
  `secrets/**`, editing `.env`, `curl`, `wget`, and `sudo`. Network fetches and
  privilege escalation are not part of the build loop, so they are simply off.
- **Ask first:** `git push`, `gh`, and `rm` — the operations that leave the
  machine or destroy work.
- **Allowed:** editing files, and the build/test/format commands for the
  supported stacks (`npm`, `npx`, `node`, `swift`, `xcodebuild`, `xcrun simctl`,
  `jq`), plus the project's own `./init.sh` and `./scripts/*`.

`.claude/hooks/guard.sh` runs before **every** Bash command and blocks a short
list of things a permission glob cannot express: `rm -rf` on `/` or `~`,
force-pushing to `main`/`master`, `git reset --hard` without explicit user
approval, `sudo`, piping `curl`/`wget` into a shell, reading or writing `.env`
through `cat`/`grep`/redirection, `git commit --no-verify`, `chmod 777`, and
`kill -1`. The hook is deliberately fail-open: if `jq` is missing or its input is
unparsable it exits 0 rather than breaking the session — it is a guardrail
against agent mistakes, **not a sandbox against a determined attacker**.

Treat all of this as defense in depth for an agent working on your behalf. It is
not a security boundary against untrusted input. Run the agent on a machine
where you would be comfortable running the commands yourself, and review its
diffs before pushing.

## Review `.mcp.json` before trusting a workspace

MCP servers are external programs the agent can call. `.mcp.json` in a cloned
workspace tells Claude Code to run them. The template ships two — XcodeBuildMCP
(installed on demand via `npx`) and the hosted context7 documentation server —
and `/onboard` rewrites the file with the drivers your components need.

**Before accepting the workspace-trust prompt in any repo derived from this
template, read `.mcp.json`.** Check what each server is, where it comes from,
and what endpoint it talks to. A `.mcp.json` committed by someone else is code
execution on your machine, exactly like a `postinstall` script.

Two practical notes: project MCP servers stay pending until you accept workspace
trust (`enableAllProjectMcpServers: true` only applies afterwards), and any edit
to `.mcp.json` requires restarting Claude Code and re-approving. If approvals
get confused, `claude mcp reset-project-choices` clears them.

## Secrets

- Real secrets go in **`.env`**, which is git-ignored and which the agent is
  denied from reading — by permissions *and* by `guard.sh`. Do not work around
  it; the deny rule is load-bearing.
- **`.env.example`** is committed and holds **key names only, never values**. It
  is intentionally readable: `/onboard` appends each component's key names to it.
  If you add a key there, add the name and a comment — nothing else.
- MCP servers read secrets from the **shell environment where you launch
  `claude`**, using `${VAR:-}` expansion so the file still loads when a variable
  is unset. Export them in your shell profile; the agent never sees the file
  they came from.
- Never commit a token, a `.env`, a simulator recording, or a screenshot in
  `evidence/` that shows credentials or personal data. Generated evidence is
  committed by design — look at it before you push.

## Reporting a vulnerability

Report privately through GitHub: **Security → Advisories → Report a
vulnerability** on this repository. Please do not open a public issue, and
please do not disclose publicly until a fix is available.

Useful details: the file involved (`.claude/settings.json`, a hook, an MCP
variant), the command or prompt that reproduces it, what the agent was able to
do that it should not have been, and your Claude Code version.

We aim to acknowledge reports promptly, but this is a volunteer project — there
is no response-time guarantee.

## Supported versions

There is no release process yet: **`main` is the only supported version.** There
are no tags, no branches, and no backported patches. A fix lands on `main`, and
existing projects pick it up by copying the changed file (usually a hook, a
setting, or a skill) into their own repo — since a project created from this
template is a full copy, it does not track upstream automatically.
