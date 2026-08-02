<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/adr/NNNN-title.md — 4-digit number starting 0001, kebab-case
title, e.g. docs/adr/0003-local-first-sqlite.md. An ADR is MANDATORY for every
hard-to-reverse choice: platform, framework, storage, auth, payments, sync, and
anything expensive to undo. Write it WHEN the decision is made, not after.
Update the index table in docs/adr/README.md in the same commit. Replace every
{{placeholder}}; delete all comments from the filled instance. MADR-lite format
(adr.github.io/madr). -->

# ADR-{{NNNN}} — {{decision_title}}

- **Status:** {{Proposed | Accepted | Superseded by ADR-XXXX}}
- **Date:** {{date}}
- **Deciders:** {{agent + user, or agent (delegated)}}
<!-- If the user delegated with "you decide", write "agent (delegated)" and make
the rationale strong enough to survive a later challenge. -->

## Context

{{context_paragraph}}
<!-- 2-6 sentences: the situation forcing a decision, the constraints that
matter (from constitution, PRD NFRs, budget, platform), and why now. No
solution talk yet. -->

## Decision

{{decision_statement}}
<!-- One or two sentences, active voice: "We use X for Y." Then any scope
limits: what this decision does NOT cover. -->

## Consequences

### Good

- {{positive_consequence_1}}
- {{positive_consequence_2}}

### Bad

- {{negative_consequence_1}}
<!-- Every real decision has costs. An ADR with no downsides listed is
advertising, not a record — name the tradeoff accepted. -->

## Alternatives Considered

<!-- One line each: alternative — why rejected. 2-4 alternatives. "Do nothing"
is often a legitimate alternative worth listing. -->
- **{{alternative_1}}** — {{why_rejected_one_liner}}
- **{{alternative_2}}** — {{why_rejected_one_liner}}
- **{{alternative_3}}** — {{why_rejected_one_liner}}
