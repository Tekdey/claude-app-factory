<!-- TEMPLATE: instructions for the agent filling it.
Destination: specs/changes/<slug>/tasks.md where slug = F-XXX-kebab-title.
Filled by /build-next from plan.md's file table; checked off during
implementation (edit the box to [x] the moment a task's verify step passes,
commit per logical unit). Task rules: small (one sitting), names EXACT files,
has its own verify step. [P] marks tasks safe to parallelize (no shared files
with other [P] tasks). Task format adapted from github/spec-kit (MIT). -->

# {{feature_id}} — Tasks

Change: `specs/changes/{{slug}}/` · Spec: [spec.md](spec.md) · Plan: [plan.md](plan.md)

## Tasks

<!-- Format (one line per task):
- [ ] T1 [P] description — files: path/a, path/b — verify: how
Order = execution order unless Dependencies says otherwise. Typical shape:
models → services → UI → wiring → scenario run. Keep 4-10 tasks; more means
the feature was too big for one session. -->

- [ ] T1 {{description}} — files: `{{path_a}}` — verify: {{how}}
- [ ] T2 [P] {{description}} — files: `{{path_b}}`, `{{path_c}}` — verify: {{how}}
- [ ] T3 {{description}} — files: `{{path_d}}` — verify: {{how}}
- [ ] T4 Run acceptance scenarios AS-1..AS-{{n}} in the {{simulator_or_browser}}
  — files: none — verify: all scenarios PASS; screenshot saved to
  `evidence/{{slug}}.png`

## Dependencies

<!-- Only non-obvious ordering constraints, e.g. "T3 needs T1's model compiled".
Write "Sequential as listed" if none. -->
- {{dependency_note}}

## Definition of Done

- [ ] All tasks above checked
- [ ] All acceptance scenarios in spec.md PASS **on the running app** (never
  from code reading)
- [ ] Evidence screenshot exists at `evidence/{{slug}}.png`
- [ ] `features.json` entry `{{feature_id}}` flipped to `passes: true` with the
  evidence path
- [ ] Requirement deltas merged into `specs/current/`; spec.md status set to DONE
- [ ] `PROGRESS.md` appended; final commit made
