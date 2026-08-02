<!-- TEMPLATE: instructions for the agent filling it.
Destination: specs/changes/<slug>/spec.md where slug = F-XXX-kebab-title.
Filled by /build-next BEFORE any implementation. Source material: the feature's
FR in docs/product/prd.md. Requirements in EARS notation; scenarios must be
executable against the running app by /verify. Mark unknowns
[NEEDS CLARIFICATION: question] — any P1-impacting marker must be resolved with
the user (max 3 questions) before implementation; log answers below. Replace
every {{placeholder}}; delete all comments from the filled instance. Structure
adapted from github/spec-kit (MIT) + Kiro EARS notation. -->

# {{feature_id}} — {{feature_title}}

- **Status:** DRAFT <!-- DRAFT → APPROVED (plan ready, ambiguities resolved) →
  DONE (verified; deltas merged into specs/current/; folder kept for history). -->
- **Source:** [{{FR_id}}](../../../docs/product/prd.md#{{fr_anchor}})
- **Feature entry:** `features.json` → `{{feature_id}}`
- **Evidence target:** `evidence/{{slug}}.png` <!-- slug already starts with the feature id -->

## User Story

As {{persona}}, when {{situation}}, I want {{capability}}, so that {{outcome}}.

## Requirements (EARS)

<!-- Numbered R1, R2... Every requirement independently testable. Use the
variant that fits: WHEN (event) / IF (condition) / WHILE (continuous state) /
WHERE (context). -->
- R1: WHEN {{trigger}} THE SYSTEM SHALL {{behavior}}.
- R2: IF {{condition}} THE SYSTEM SHALL {{behavior}}.
- R3: {{requirement}}

## Acceptance Scenarios

<!-- Numbered AS-1... Each scenario is a concrete run /verify can execute in
the simulator/browser: real starting state, real actions, observable outcome.
AS-1 is the primary scenario — its assertion moment is the evidence screenshot. -->

### AS-1 — {{scenario_name}} (primary)

- **Given** {{precondition_concrete_state}}
- **When** {{user_actions}}
- **Then** {{observable_result}}

### AS-2 — {{scenario_name}}

- **Given** {{precondition}}
- **When** {{action}}
- **Then** {{observable_result}}

## Edge Cases

<!-- What happens when things are empty, extreme, repeated, interrupted,
offline. One line each: case → expected behavior. Cover at least: empty state,
invalid input, and the relevant boundary (midnight, max length, no network...). -->
- {{edge_case_1}} → {{expected_behavior}}
- {{edge_case_2}} → {{expected_behavior}}

## Out of Scope

<!-- What this change deliberately does NOT include, especially adjacent ideas
that came up while speccing. Prevents scope creep during implementation. -->
- {{out_of_scope_1}}
- {{out_of_scope_2}}

## Clarifications

<!-- Convention: unknowns above are marked [NEEDS CLARIFICATION: question]
inline. Resolve P1-impacting ones with the user before APPROVED status; replace
each marker with the answer and log it here. Write "None needed" if the spec
had no markers. -->

| Date | Question | Answer |
|---|---|---|
| {{date}} | {{question}} | {{answer}} |
