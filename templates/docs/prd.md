<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/product/prd.md. Filled by /onboard after the brief; /new-feature
appends new FR sections marked "added <date>". Quality bar: every FR is testable
EARS, Non-Goals are mandatory, NO technology choices in this document (stack
lives in docs/tech/tech-stack.md). Every FR here becomes a feature entry in
features.json. Replace every {{placeholder}}; delete all comments from the
filled instance. Section structure adapted from snarktank/ai-dev-tasks
(Apache-2.0). -->

# {{app_name}} — Product Requirements Document

## 1. Overview

{{overview_paragraph}}
<!-- 3-5 sentences: what the product is, who it is for, the core problem it
solves. Consistent with docs/product/brief.md — link, don't repeat the canvas. -->

## 2. Goals

<!-- 3-5 measurable goals. Outcomes, not features. -->
- G-1: {{goal_1}}
- G-2: {{goal_2}}
- G-3: {{goal_3}}

## 3. User Stories

<!-- One story per significant job-to-be-done, tied to a persona from
docs/product/personas.md. Format: As <persona>, when <situation>, I want
<capability>, so that <outcome>. Group by roadmap phase if helpful. -->
- US-1: As {{persona}}, when {{situation}}, I want {{capability}}, so that {{outcome}}.
- US-2: {{user_story_2}}
- US-3: {{user_story_3}}

## 4. Functional Requirements

<!-- The heart of the document. Rules:
- Numbered FR-001, FR-002... — never renumber, never reuse a retired number.
- EARS notation: WHEN <trigger> THE SYSTEM SHALL <behavior>. Variants:
  IF <condition> THE SYSTEM SHALL...; WHILE <state> THE SYSTEM SHALL...;
  WHERE <context> THE SYSTEM SHALL...
- Each FR is independently testable and user-observable. If you cannot imagine
  the proof that closes it (a screenshot for UI, a request/response for an API),
  rewrite it.
- Group FRs under a heading per component when the project ships several
  (### Mobile app / ### API / ### Marketing site), and tag each FR with the
  components it needs — this feeds the `components` field in features.json. An
  FR whose behavior spans two components stays ONE requirement, written from the
  user's point of view, not split by implementation layer.
- Each FR gets a heading anchor (### FR-001 — Title) because features.json
  references docs/product/prd.md#FR-001.
- Mark unresolved decisions [NEEDS CLARIFICATION: question] and resolve them via
  the Clarifications Log before implementation. -->

### FR-001 — {{fr_title}}

WHEN {{trigger}} THE SYSTEM SHALL {{behavior}}.

- Acceptance: Given {{precondition}}, When {{action}}, Then {{observable_result}}.

### FR-002 — {{fr_title}}

{{ears_requirement}}

- Acceptance: {{given_when_then}}

## 5. Non-Goals

<!-- Mandatory. What this product deliberately does NOT do, with a short reason
each. Mirrored in constitution Article VIII. /new-feature must surface any
conflict with this list and require an explicit override recorded in an ADR. -->
- {{non_goal_1}} — {{reason}}
- {{non_goal_2}} — {{reason}}
- {{non_goal_3}} — {{reason}}

## 6. Design Considerations

<!-- Product-level design constraints only (audience, accessibility, platform
conventions, density, one-handed use...). The visual system itself lives in
docs/design/DESIGN.md; copy rules live in docs/design/voice.md — reference them,
never restate tokens here. -->
{{design_considerations}}

## 7. Technical Considerations

<!-- Constraints, not choices: offline expectations, data sensitivity,
compliance (GDPR, health, payments), performance expectations users will notice,
App Store review considerations. Actual stack choices belong in
docs/tech/tech-stack.md + ADRs. -->
{{technical_considerations}}

### Non-Functional Requirements

<!-- Numbered NFR-001... — measurable, EARS where it fits. Cover only what
matters for THIS product: performance, offline, accessibility, privacy. -->
- NFR-001: {{nfr_1}}
- NFR-002: {{nfr_2}}

## 8. Success Metrics

<!-- From the brief's Key Metrics — restate the north star and how each goal
G-x will be measured. Numbers, however humble. -->
- {{metric_1}}
- {{metric_2}}

## 9. Open Questions

<!-- Anything unresolved that does not block v0.1. Review this list every time
/new-feature or /build-next touches a related area. Write "None" if empty. -->
- {{open_question_1}}

## Clarifications Log

<!-- Append-only. Every [NEEDS CLARIFICATION] resolved with the user lands here,
then the marker is replaced in the FR text. -->

| Date | Question | Answer |
|---|---|---|
| {{date}} | {{question}} | {{answer}} |
