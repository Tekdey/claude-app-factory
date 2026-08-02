# Contributing to claude-app-factory

Thanks for being here. This document is short on ceremony and long on the two or
three things that actually break if you get them wrong.

## What this repo is (and what a contribution is)

This repo is a **GitHub template**, not an application. Cloning it gives you an
empty machine; `/onboard` turns that machine into a project. Nothing here ships
to an end user.

So a contribution **changes the machinery**: the skills under `.claude/skills/`,
the agents, the hooks, the doc templates, the scaffold recipes, the docs that
explain them.

A contribution **never adds product code**. If your branch contains `apps/`,
`components.json`, `features.json`, `docs/constitution.md`, filled documents in
`docs/product/`, or screenshots in `evidence/`, you generated a project instead
of improving the template — those paths only exist in *user* repositories, not
in this one. The single exception is `templates/*.example.json`, which are
schema references for a fictional habit tracker and are deliberately committed.

## Repo layout — what lives where

| Path | What it holds | Touch it when |
|---|---|---|
| `CLAUDE.md` | The always-loaded agent operating manual: state detection, session ritual, non-negotiables, the two schemas | You change a rule that applies to *every* session |
| `.claude/skills/<name>/SKILL.md` | One command (`/onboard`, `/build-next`, …): the whole flow the agent follows | You change what a command does |
| `.claude/skills/<name>/references/` | Progressive-disclosure detail the skill loads on demand (question bank, generation checklist, scaffold recipes) | You change *how* a step is executed, not *whether* it happens |
| `.claude/agents/` | Subagent definitions (`app-tester`, `explorer`, `reviewer`) | You change delegation or verification behavior |
| `.claude/hooks/` | Shell hooks wired in `.claude/settings.json` (guard, post-edit, session-context, stop-gate) | You change what is blocked, formatted or gated |
| `.claude/settings.json` | Permissions (allow / ask / deny) + hook wiring | You change the security surface — see `SECURITY.md` |
| `.claude/rules/` | Path-scoped conventions, generated per component by `/onboard`. Ships with only a README | You change the rule format or the README's example |
| `templates/docs/`, `templates/specs/` | Skeletons the skills copy and fill | You change the shape of a generated document |
| `templates/mcp/` | Per-platform `.mcp.json` building blocks + `backends.md` | You add or change a driver |
| `.mcp.json` | The template's default MCP set (iOS + context7); `/onboard` rewrites it | Rarely — change `templates/mcp/` instead |
| `init.sh` | `doctor` (environment diagnostic) and `start <id>` | You change environment requirements |
| `scripts/README.md` | The script contract `/onboard` generates against | You change the dispatcher / per-component contract |
| `context/`, `docs/`, `specs/`, `evidence/` | Empty trees with READMEs, filled in user repos | You change the conventions documented in those READMEs |

## Testing a change to the template

There is no CI, and there is no unit test suite — the deliverable is a prompt
surface, so the only real test is running it. Do this before opening a PR:

```bash
# 1. Cheap structural checks (always)
jq . .mcp.json templates/*.json          # every JSON file parses
bash -n .claude/hooks/*.sh init.sh       # every shell file parses
./init.sh doctor                         # environment still diagnoses cleanly

# 2. Real test: run the template end to end, outside this repo
#    (commit your change first — git clone copies HEAD, not your working tree)
rm -rf /tmp/caf-test && git clone . /tmp/caf-test && cd /tmp/caf-test
rm -rf .git && claude
```

Then in that clone: accept workspace trust, approve the MCP servers, run
`/onboard`, and answer the interview as a plausible product owner. Afterwards,
check what came out:

- `docs/` — every generated document is filled: **zero** `{{placeholder}}`
  markers, zero `<!-- TEMPLATE: … -->` comments left behind.
- `components.json` and `features.json` — `jq .` parses them, exactly one
  component has `"primary": true`, every `features[].components` id exists in
  `components.json`, and every entry starts `"passes": false, "evidence": null`.
- `apps/<id>/` and `scripts/<id>/` exist for each declared component, and
  `scripts/<id>/run.sh` actually launches it.
- `.mcp.json` contains one driver per verify method plus a single `context7`.
- `.claude/rules/<id>.md` exists per component with a `paths:` frontmatter
  pointing at `apps/<id>/**`.
- `PROGRESS.md` has a new entry, `evidence/` has the smoke-test proof.

If your change touches `/build-next` or `/verify`, keep going in that clone:
build one feature and confirm `passes: true` is only ever set alongside a file
that exists in `evidence/`. Describe in the PR what you ran and what you saw.
"I read the diff and it looks right" is not a test of a prompt.

**Never run `/onboard` in a clone of this repo that you intend to commit from.**
It writes a full project on top of the template.

## Conventions you must respect

### 1. The duplicated schemas must stay identical

`features.json` and `components.json` are parsed by several skills, so their
schema blocks are repeated verbatim where the agent needs them at hand. If you
change a field, change it **everywhere in the same commit** — a drifted copy
means the agent writes one shape and reads another.

The `features.json` entry schema appears in **6 files**:

- `CLAUDE.md` (§6)
- `.claude/skills/build-next/SKILL.md`
- `.claude/skills/verify/SKILL.md`
- `.claude/skills/status/SKILL.md`
- `.claude/skills/new-feature/SKILL.md`
- `.claude/skills/onboard/references/generation.md` (§11)

plus `templates/features.example.json`, which must stay a valid *instance* of it.

The `components.json` entry schema appears in **2 files**:

- `CLAUDE.md` (§5)
- `.claude/skills/onboard/references/generation.md` (§5)

plus `templates/components.example.json` as the instance.

The entry bodies must be byte-identical: same keys, same order, same example
values (`"F-001"`, `"components": ["ios"]`, `"priority": "P1"`, …). Only the
surrounding wrapper differs — `CLAUDE.md` shows the bare entry, the skills wrap
it in `{ "features": [ … ] }`. Check with:

```bash
# features.json — must list the 6 files above + templates/features.example.json
grep -rl '"passes": false,' CLAUDE.md .claude/skills templates

# components.json — must list the 2 files above + templates/components.example.json
grep -rl '"primary": false,' CLAUDE.md .claude/skills templates
```

The **enum values** live in the same places plus a few prose spots — changing
`kind` or `verify` means updating `CLAUDE.md` §5, `generation.md` §5, the Q-S1
options in `.claude/skills/onboard/references/questions.md`, the component table
in `README.md`, and the driver table in `templates/mcp/README.md`.

### 2. Line budgets — context is the scarce resource

Everything under `CLAUDE.md` and `SKILL.md` is loaded into the agent's context
window *before it does any work*. Lines spent there are lines not available for
reasoning about the user's product. That is why the budgets are hard:

| File | Budget | Currently |
|---|---|---|
| `CLAUDE.md` | 150 lines | 119 |
| any `SKILL.md` | 250 lines | 72–217 (`/onboard` is the outlier, and is the one flow that earns it) |
| `.claude/agents/*.md` | 130 lines | 51–124 |
| `.claude/rules/*.md` | ~20 lines | see `.claude/rules/README.md` |
| `references/*.md` | 650 lines | 39–625 (`scaffold.md` is near the ceiling) |

The budgets tighten as a file loads earlier and more often: `CLAUDE.md` is
loaded every session no matter what, a `SKILL.md` only when its command runs,
and a `references/` file only when that step is reached. Reference files are
therefore the pressure valve — detail belongs there, not in a SKILL body. If a
skill needs to grow, move detail into `references/` and link to it.
`scaffold.md` is close to its ceiling; a change adding much to it should also
remove something, or split it (one file per component kind is the obvious cut).

```bash
wc -l CLAUDE.md .claude/skills/*/SKILL.md .claude/agents/*.md \
      .claude/skills/*/references/*.md
```

### 3. Everything is English

Docs, prompts, comments, commit messages. The *agent* interacts in the user's
language at runtime (that behavior is specified in the prompts) — the repo
itself is English-only.

### 4. Prompts are code — write them like code

- Say what the agent must do, in the imperative, with the failure mode named.
  Vague guidance produces vague behavior.
- Prefer a table or a numbered procedure over a paragraph.
- Every hard rule should say what happens if it is violated, so the agent can
  self-correct.
- Never add a rule to `CLAUDE.md` that only matters to one command — put it in
  that command's skill.
- Templates use `{{lower_snake_case}}` placeholders and nothing else.

## Adding a new component kind

A "kind" is a deliverable type (`mobile-app`, `api`, `cli`, …). Adding one means
teaching the whole chain about it. Four places must change, in this order:

1. **Scaffold recipe** — add a `### <kind> → apps/<id>/` section to
   `.claude/skills/onboard/references/scaffold.md` §2: how to create it, its
   minimal runnable "hello" state, and what the smoke test proves.
2. **Scripts** — add its `run.sh` / `format.sh` / `test.sh` / `verify-quick.sh`
   bodies to `scaffold.md` §3. They must honor the contract in
   `scripts/README.md`: run from the repo root, exit non-zero on failure, and
   `verify-quick.sh` stays inside the shared 60-second budget.
3. **Rule file** — add its `### <kind> component` block to `scaffold.md` §5, so
   `/onboard` generates `.claude/rules/<id>.md` scoped to `apps/<id>/**` with
   that stack's conventions (~20 lines).
4. **MCP variant — only if it needs a driver.** If the kind is verified by
   driving a UI, add or reuse a variant in `templates/mcp/` and list it in
   `templates/mcp/README.md`. Kinds verified over Bash (`http`, `cli`, `none`)
   need **no** MCP server — do not add one.

Then update the enums and the tables that describe them (see §1 above), and pick
the kind's `verify` method from the existing five — `simulator`, `browser`,
`http`, `cli`, `none`. **Adding a sixth verify method is a much bigger change**:
it touches `/verify`, `/build-next`, the `app-tester` agent and the evidence
extension convention. Open an issue first.

## Proposing a new command or skill

The bar is high: every command's `description` is loaded at session start, so a
new one taxes every session forever. Open an issue before writing it, covering:

- **The gap** — what a user must do by hand today, and why `/build-next`,
  `/verify`, `/new-feature` or `/design` can't absorb it.
- **The trigger** — is it user-invoked only (`disable-model-invocation: true`,
  like `/onboard`) or should the model reach for it on its own?
- **The contract** — what it reads, what it writes, and what it refuses to do.
  A command that can flip `passes` must capture evidence.
- **The budget** — where it lands under 200 lines, and what moves to
  `references/`.

If it is accepted, ship it as `.claude/skills/<name>/SKILL.md` with `name` and
`description` frontmatter, add it to the tables in `CLAUDE.md` §8 and
`README.md`, and — if it touches the ledger — to the schema-consumer list above.

## Commits and pull requests

Conventional-commit subject, imperative, lowercase, no trailing period:

```
feat: multi-component projects — app + API + site in one repo
fix: root format.sh received absolute paths from the hook and never matched
docs: explain the MCP approval flow after workspace trust
```

Types in use: `feat`, `fix`, `docs`, `refactor`, `chore`.

The body is where the value is. Explain **what behavior changed for the agent**
and why, in bullets — the existing history is the reference for the level of
detail expected. If Claude Code co-authored the change, keep the
`Co-Authored-By:` trailer.

One concern per PR. Fill in the pull-request checklist honestly; it mirrors this
document. Bug reports and proposals go through the issue forms in
`.github/ISSUE_TEMPLATE/`.

## Code of conduct and security

Participation is governed by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Do not
open a public issue for a vulnerability — follow [SECURITY.md](SECURITY.md).

By contributing, you agree your work is licensed under the MIT terms in
[LICENSE](LICENSE). If you adapt material from another project, add it to
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) in the same PR.
