# Third-party notices

This template adapts patterns, document schemas, workflow shapes and prompt
material from the open projects listed below. Adaptations are pattern-level
(structures, checklists, flows) rather than verbatim redistributions of source
code; where a file is a close adaptation, it carries a one-line comment
crediting the source. Thank you to all of these projects.

## github/spec-kit

- **URL:** https://github.com/github/spec-kit
- **License:** MIT
- **Adapted:** the constitution-first pattern (`docs/constitution.md` with
  semver-versioned articles and an amendment procedure), the overridable
  doc-templates directory (`templates/`), the clarify-style follow-up questions
  after generation, and the spec → plan → tasks command chain used by
  `/build-next`.

## BMAD-METHOD

- **URL:** https://github.com/bmad-code-org/BMAD-METHOD
- **License:** MIT
- **Adapted:** the persona-driven onboarding interview — themed question rounds
  (product, audience, business model, design, tone, tech) with per-theme
  summaries — and the brief → PRD → architecture document handoff chain.

## Agent OS (buildermethods/agent-os)

- **URL:** https://github.com/buildermethods/agent-os
- **License:** MIT
- **Adapted:** the three-layer information architecture (standards / product /
  specs) reflected in `docs/` + `specs/`, the plan-product onboarding flow
  shape, and the re-run behavior of `/onboard` (offer update / regenerate a
  section / cancel when docs already exist).

## OpenSpec (Fission-AI/OpenSpec)

- **URL:** https://github.com/Fission-AI/OpenSpec
- **License:** MIT
- **Adapted:** the change-based spec lifecycle — one `specs/changes/<slug>/`
  folder per feature, whose requirement deltas are merged into
  `specs/current/` when the change is verified (archive-in-place).

## ai-dev-tasks (snarktank/ai-dev-tasks)

- **URL:** https://github.com/snarktank/ai-dev-tasks
- **License:** Apache-2.0
- **Adapted:** the "ask clarifying questions before writing the PRD" flow, the
  PRD section structure in `templates/docs/prd.md`, and the granular
  task-decomposition pattern in `templates/specs/tasks.md`.

## Anthropic engineering blog & official skills

- **URL:** https://www.anthropic.com/engineering and
  https://github.com/anthropics/skills
- **License:** see the repository and site for terms
- **Adapted:** the long-running autonomous agent harness pattern (persistent
  feature ledger `features.json`, session ritual, progress log, evidence-based
  completion), and the frontend-design skill's aesthetics framework (adapted in
  `.claude/skills/design/references/aesthetics.md`).

## VoltAgent/awesome-design-md

- **URL:** https://github.com/VoltAgent/awesome-design-md
- **License:** see repository
- **Adapted:** the 9-section machine-readable design-system document schema
  used by `templates/docs/design.md` and `docs/design/DESIGN.md`.

## Lean Canvas (Ash Maurya, LEANSTACK)

- **URL:** https://leanstack.com/lean-canvas
- **License:** Lean Canvas is adapted from the Business Model Canvas
  (Strategyzer) and is licensed under CC BY-SA 3.0
- **Adapted:** the 9-block canvas structure used in `templates/docs/brief.md`
  and the generated `docs/product/brief.md`.
