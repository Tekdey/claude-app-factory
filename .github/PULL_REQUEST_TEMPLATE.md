<!--
Thanks for contributing. This checklist mirrors CONTRIBUTING.md — untick
anything that does not apply and say why, rather than deleting the line.
-->

## What changes, and why

<!-- What behavior does the agent gain, lose or stop getting wrong? Link the issue if there is one. -->

Closes #

## Which part of the machinery

<!-- e.g. .claude/skills/verify/SKILL.md + the app-tester agent -->

## How you tested it

<!--
Prompt surfaces are only tested by running them. Say what you actually ran:
which command, in a clone at which path, and what came out. "Read the diff"
is not a test.
-->

- [ ] Cloned the template to a temp dir and ran the affected command(s) end to end
- [ ] Inspected the generated output: no `{{placeholder}}` or `<!-- TEMPLATE: -->` left, files land where the docs say

<details><summary>What I ran and what I saw</summary>

```
```

</details>

## Checklist

**Schemas**

- [ ] If a `features.json` field changed, all **6** copies are byte-identical: `CLAUDE.md` §6, `build-next`, `verify`, `status`, `new-feature` SKILL.md, `onboard/references/generation.md` §11 — and `templates/features.example.json` is still a valid instance
- [ ] If a `components.json` field changed, both copies match: `CLAUDE.md` §5 and `generation.md` §5 — and `templates/components.example.json` is still a valid instance
- [ ] If a `kind` or `verify` enum changed, the prose lists were updated too (`questions.md` Q-S1, `README.md` component table, `templates/mcp/README.md`)

**Budgets**

- [ ] `CLAUDE.md` ≤ 150 lines, every `SKILL.md` ≤ 200, agents ≤ 130, rules ~20, references ~500 — checked with `wc -l`
- [ ] Detail that grew a skill was moved into `references/`, not left in the SKILL body

**Validation**

- [ ] `jq . .mcp.json templates/*.json` — every JSON file parses
- [ ] `bash -n .claude/hooks/*.sh init.sh` — every shell file parses
- [ ] Any YAML added under `.github/` parses

**Cross-references**

- [ ] Every path, file and `§section` I mention exists and still says what I claim
- [ ] Command tables agree: `CLAUDE.md` §8 and `README.md`
- [ ] Skill ↔ reference ↔ template links still resolve

**Docs**

- [ ] `README.md` / `CONTRIBUTING.md` / `SECURITY.md` updated if the change is user-visible
- [ ] `THIRD_PARTY_NOTICES.md` updated if I adapted material from another project
- [ ] English only, everywhere — including comments and the commit message

**Scope**

- [ ] No product code: no `apps/`, no `components.json`/`features.json` at the root, no filled `docs/product/`, no `evidence/` screenshots
- [ ] Conventional-commit subject, one concern per PR
