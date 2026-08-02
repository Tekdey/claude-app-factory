<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/product/roadmap.md. Filled by /onboard after the PRD, updated
by /new-feature when placing new features. Feature ids MUST match features.json
(F-001...). Phase membership sets priority in features.json: v0.1 features are
P1, v1 features are P2, post-launch are P3. v0.1 is a WALKING SKELETON — the
thinnest end-to-end slice that a real user could use for the core job, ugly
edges allowed, core value present. Replace every {{placeholder}}; delete all
comments from the filled instance. -->

# {{app_name}} — Roadmap

## Phase Overview

| Phase | Goal | Features | Exit criteria |
|---|---|---|---|
| v0.1 walking skeleton | {{v01_goal}} | {{v01_feature_ids}} | {{v01_exit}} |
| v1 launch | {{v1_goal}} | {{v1_feature_ids}} | {{v1_exit}} |
| v1.x post-launch | {{v1x_goal}} | {{v1x_feature_ids}} | {{v1x_exit}} |

## v0.1 — Walking Skeleton

**Goal:** {{v01_goal_sentence}}
<!-- One sentence: the single end-to-end job a user can complete. If a feature
is not required to complete that job once, it is not v0.1. Typically 4-8
features. MULTI-COMPONENT: the skeleton must cut through EVERY v1 component —
one thin slice proving app ↔ API ↔ site actually wire together beats three
polished components that have never talked to each other. -->

**Features:** <!-- ordered by dependency: a provider ships before its consumer -->
- F-001 — {{title}} `{{component_id}}`
- F-002 — {{title}} `{{component_id}}`

**Exit criteria:** {{v01_exit_criteria}}
<!-- Observable and binary, e.g. "Persona 1 can complete the core job on a
clean install with evidence screenshots for every v0.1 feature." -->

## v1 — Launch Scope

**Goal:** {{v1_goal_sentence}}
<!-- What makes the skeleton shippable to strangers: polish on core flows,
onboarding, settings, the monetization mechanics if any, store-readiness. -->

**Features:**
- F-0XX — {{title}} `{{component_id}}`
- F-0XX — {{title}} `{{component_id}}`

**Exit criteria:** {{v1_exit_criteria}}

## v1.x — Post-Launch

**Goal:** {{v1x_goal_sentence}}
<!-- Everything valuable but not launch-blocking. It is fine for this list to
be loose — it firms up as real usage teaches us. -->

**Features:**
- F-0XX — {{title}}

**Exit criteria:** {{v1x_exit_criteria}}

## Sequencing Notes

<!-- Dependencies and ordering constraints across features, e.g. "F-007 sync
requires F-002 local persistence first". /build-next respects priority order
(P1 > P2 > P3, then id order) but reads this section for hard dependencies. -->
{{sequencing_notes}}

## Component Coverage

<!-- Delete for a single-component project. Every component in components.json
appears here with the phase that first delivers it — this is the check that
prevents a deliverable from being silently forgotten. A component with no
features in any phase is a bug in this roadmap. -->

| Component | First delivered in | Feature ids | Notes |
|---|---|---|---|
| `{{component_id}}` | {{phase}} | {{ids}} | {{note}} |
