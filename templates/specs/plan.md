<!-- TEMPLATE: instructions for the agent filling it.
Destination: specs/changes/<slug>/plan.md where slug = F-XXX-kebab-title.
Filled by /build-next after spec.md is APPROVED, before tasks.md. The
constitution check is a real gate: an unjustified violation stops the plan.
File paths must be exact — vague plans produce vague code. Replace every
{{placeholder}}; delete all comments from the filled instance. Constitution
check + complexity table adapted from github/spec-kit (MIT). -->

# {{feature_id}} — Implementation Plan

## Approach

{{approach_summary}}
<!-- 3-8 sentences: the technical route chosen and why it is the simplest one
that satisfies every requirement in spec.md. Name the pattern reused from the
existing codebase. If two routes were close, one line on why this one won. -->

## Constitution Check

<!-- Check the plan against docs/constitution.md BEFORE implementing. List each
touched article with a verdict. Any violation goes to the Complexity table with
a justification — or the plan changes. -->

| Article | Verdict |
|---|---|
| II Quality bar | {{pass_or_note}} |
| III Spec-first | {{pass_or_note}} |
| IV Tech principles | {{pass_or_note — new dependency? needs ADR?}} |
| V Design integrity | {{pass_or_note}} |
| VII Process | {{pass_or_note}} |

<!-- Also confirm: no file is touched outside the apps/<id>/ folders this
feature declares, and no component reaches into another's internals. -->

### Complexity Table

<!-- Only rows for actual violations/exceptions. Empty = write "No exceptions". -->

| Exception | Why needed | Simpler alternative rejected because |
|---|---|---|
| {{exception}} | {{why}} | {{why_simpler_fails}} |

## Design Check (UI features)

<!-- Delete this section only for features with zero UI surface. -->
- DESIGN.md read this session: {{yes_date}}
- Tokens used: {{token_list}} — all from DESIGN.md section 2/3/5; no new values.
- New components needed: {{none_or_list}}
  <!-- A new component must be composed from existing tokens and follow section
  4 constructions; if it deserves system status, propose a DESIGN.md addition. -->
- Copy surfaces in this feature: {{surfaces}} — written per voice.md patterns.

## Component Impact

<!-- Delete for a single-component project. One row per component this feature
touches — they must match the `components` array of its features.json entry.
Build order follows depends_on: the provider before its consumer, so the
consumer can be verified against something real. -->

| Component | Build order | What changes | Contract touched? |
|---|---|---|---|
| `{{component_id}}` | 1 | {{what}} | {{no_or_which_contract}} |
| `{{component_id_2}}` | 2 | {{what}} | {{no_or_which_contract}} |

<!-- If a contract between components changes, say here which side moves first,
how the other stays compatible, and that BOTH sides get re-verified. -->

## Files to Create / Modify

<!-- Exact paths, always under `apps/<component-id>/`. One row per file: what
changes and why. This table is the skeleton tasks.md is built from. -->

| File | Action | What changes |
|---|---|---|
| `apps/{{component_id}}/{{path/to/file_1}}` | create | {{what}} |
| `apps/{{component_id}}/{{path/to/file_2}}` | modify | {{what}} |
| `apps/{{component_id}}/{{path/to/test_file}}` | create | {{unit_tests_for_what}} |

## Data Model Changes

{{data_model_changes_or_none}}
<!-- New/changed entities, fields, migrations. State the migration/compat story
for existing user data. "None" if no persistence is touched. -->

## Risks

<!-- 1-3 real risks with mitigations. Think: regressions in neighboring
features, platform quirks, state edge cases. -->
- {{risk_1}} → mitigation: {{mitigation_1}}
- {{risk_2}} → mitigation: {{mitigation_2}}

## Rollback

{{rollback_note}}
<!-- How to undo if verification fails hard: usually "revert the commits of
this change folder — no migration/data cleanup needed" or the explicit extra
steps if data or config was touched. Commits per logical unit make this cheap. -->
