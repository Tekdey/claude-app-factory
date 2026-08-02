<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/tech/tech-stack.md. Filled by /onboard once the platform and
services are decided. Every row that represents a hard-to-reverse choice needs
an ADR — create it from templates/docs/adr.md and link it here. This document is
BINDING (constitution Article IV): agents follow it until an ADR supersedes a
row. Replace every {{placeholder}}; delete all comments from the filled
instance. -->

# {{app_name}} — Tech Stack

## Stack Table

<!-- One row per layer actually used; delete rows that do not apply. Version =
the pinned or minimum version. Why = one honest line. ADR = link for every
hard-to-reverse choice (platform, framework, storage, auth, payments, sync);
"—" only for trivially reversible picks. -->

| Layer | Choice | Version | Why | ADR |
|---|---|---|---|---|
| Platform | {{platform}} | {{min_os_or_target}} | {{why}} | [ADR-0001](../adr/0001-{{slug}}.md) |
| Language | {{language}} | {{version}} | {{why}} | — |
| UI framework | {{ui_framework}} | {{version}} | {{why}} | [ADR-000X](../adr/000X-{{slug}}.md) |
| Persistence | {{persistence}} | {{version}} | {{why}} | [ADR-000X](../adr/000X-{{slug}}.md) |
| Backend / sync | {{backend_or_none}} | {{version}} | {{why}} | [ADR-000X](../adr/000X-{{slug}}.md) |
| Auth | {{auth_or_none}} | {{version}} | {{why}} | [ADR-000X](../adr/000X-{{slug}}.md) |
| Testing | {{test_frameworks}} | {{version}} | {{why}} | — |

## Local Development Commands

<!-- The exact commands an agent runs in this repo. Keep in sync with
scripts/*.sh — the scripts are the canonical entry points; list raw equivalents
for context. -->

| Task | Command |
|---|---|
| Run the app | `./scripts/run.sh` ({{raw_equivalent}}) |
| Format | `./scripts/format.sh` ({{raw_equivalent}}) |
| Full test suite | `./scripts/test.sh` ({{raw_equivalent}}) |
| Quick verification (< 60s) | `./scripts/verify-quick.sh` ({{raw_equivalent}}) |

## Key Libraries Policy

1. **Prefer boring.** Platform-native and standard-library solutions beat
   third-party dependencies. A new dependency needs: a problem the platform
   cannot solve reasonably, an actively maintained library, and a one-line
   justification in the plan that introduces it.
2. **Check documentation before adding or upgrading.** Use the context7 MCP
   server to read current docs for any library before writing code against it —
   training-data knowledge of APIs goes stale.
3. **Pin versions.** Record the version here when a library is adopted; upgrades
   are deliberate acts noted in `PROGRESS.md`, not side effects.
4. Hard-to-reverse additions (anything touching data format, auth, payments, or
   sync) require an ADR before the dependency lands.

## Environment & Secrets

<!-- List required environment variables by NAME only (values live in .env,
which agents never read). State where each is obtained. -->
- `{{ENV_VAR_NAME}}` — {{what_it_is_and_where_to_get_it}}
