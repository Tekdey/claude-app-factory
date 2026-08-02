<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/tech/structure.md. Filled by /onboard right after the scaffold
exists, so the tree below reflects REAL folders. Read before creating any file.
The placement rules are the point of this document: an agent with a new file to
create should find its home here without thinking. Replace every
{{placeholder}}; delete all comments from the filled instance. -->

# {{app_name}} — Code Structure

## Folder Map

<!-- The real tree of app/ after scaffold, annotated. Keep depth ≤ 3; one
comment per folder saying what belongs there. Example shape for iOS below —
replace with the actual stack's layout. -->

```
app/{{AppName}}/
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
