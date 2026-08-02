<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/tech/structure.md. Drafted by /onboard in Phase 3 from the
scaffold recipes, then CORRECTED in Phase 5 once the scaffolds exist so the
trees below reflect REAL folders. One section per component in
components.json, plus the repo-level map. Read before creating any file.
The placement rules are the point of this document: an agent with a new file to
create should find its home here without thinking. Replace every
{{placeholder}}; delete all comments from the filled instance. -->

# {{app_name}} — Code Structure

## Repo Map

<!-- Top level only. Every component from components.json appears under apps/,
with its scripts under scripts/<id>/ and its conventions in .claude/rules/<id>.md. -->

```
apps/
├── {{component_id}}/           # {{component_kind}} — see its section below
└── {{other_component_id}}/     # {{other_component_kind}}
scripts/
├── format.sh                   # dispatcher → scripts/<id>/format.sh
├── verify-quick.sh             # dispatcher → every scripts/<id>/verify-quick.sh
└── {{component_id}}/           # run.sh · test.sh · format.sh · verify-quick.sh
docs/ · specs/ · evidence/      # conventions in their own READMEs
```

### Cross-component rules

<!-- The rules that prevent a monorepo from turning into mud. Adapt, keep short. -->

- A component NEVER imports another component's internal files. It calls its
  published interface (HTTP endpoint, exported package entry point) — the
  allowed direction is whatever `depends_on` in components.json declares.
- Shared code lives in its own component (`kind: library`) or is duplicated
  deliberately; two components quietly reaching into the same relative path is
  a bug.
- {{shared_types_rule}} <!-- e.g. "API response types are generated from the
  OpenAPI spec into each consumer" — or "duplicated by hand, kept in sync by
  the contract tests in apps/api/tests/contract" -->

## Component: {{component_id}} ({{component_kind}})

<!-- Repeat this whole section for every component. The real tree after
scaffold, annotated. Keep depth ≤ 3; one comment per folder saying what belongs
there. Example shape for an iOS component below — replace with the actual
stack's layout. -->

```
apps/{{component_id}}/
├── {{AppName}}App.{{ext}}      # entry point — composition only, no logic
├── Features/                   # one folder per user-facing feature
│   └── {{FeatureName}}/        # screen(s) + feature-local state + subviews
├── Models/                     # domain types + persistence models
├── Services/                   # persistence, sync, notifications — no UI imports
├── DesignSystem/               # tokens + shared components ONLY (from DESIGN.md)
└── Resources/                  # assets, localized strings
```

## Placement Rules

<!-- The "where does X go" answers, one line each. Cover at least: new feature
screens, shared UI components, domain models, service/IO code, tests, assets. -->
- New feature screens go in `{{features_path}}/<FeatureName>/`, one folder per
  feature matching the feature title in `features.json`.
- Shared, reusable UI components go in `{{design_system_path}}` — a component
  used by a single feature stays in that feature's folder until a second feature
  needs it.
- Domain models go in `{{models_path}}`; they never import UI code.
- Anything touching disk, network, or OS services goes in `{{services_path}}`.
- Tests mirror the source tree: `{{tests_path}}/<same_subpath>`.
- Design tokens live ONLY in `{{tokens_path}}` — never hard-code a color, font,
  or spacing value in a feature file.

## Naming Conventions

<!-- Actual conventions for the stack: file naming, type naming, test naming.
Keep to what the linter/formatter cannot already enforce. -->
- Files: {{file_naming_rule}}
- Types: {{type_naming_rule}}
- Tests: {{test_naming_rule}} (e.g. `{{ExampleName}}Tests`)
- Feature folders: PascalCase matching the feature title, e.g. `F-004 Streak
  counter` → `StreakCounter/`.

## Import Rules

<!-- The dependency direction, as prohibitions — easy to review mechanically. -->
- `Features/*` may import `Models`, `Services`, `DesignSystem`. Features never
  import other features — shared behavior moves down into `Models`/`Services`.
- `Services` may import `Models`; never `Features` or `DesignSystem`.
- `Models` imports nothing above the standard library.
- {{stack_specific_import_rule}}
