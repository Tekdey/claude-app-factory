# Architecture Decision Records (ADRs)

An ADR captures one significant technical decision: the context that forced it, the decision itself, its consequences (good and bad), and the alternatives that were rejected. Format is MADR-lite — see the template at `templates/docs/adr.md`.

## Why ADRs in an AI-built repo

Agents across sessions have no shared memory beyond the repo. Without ADRs, a fresh session will happily re-litigate (or silently reverse) a decision made three sessions ago. An ADR makes the decision durable: before revisiting any past technical choice, read the relevant ADR first; to change the decision, write a new ADR that supersedes it — never edit history.

## Numbering and naming

- 4-digit sequential numbering starting at `0001`.
- Filename: `NNNN-short-kebab-title.md` (e.g. `0001-use-swiftui-with-swiftdata.md`).
- Statuses: `proposed` → `accepted`; later `deprecated` or `superseded by NNNN`.

## When an ADR is mandatory

Write an ADR for every hard-to-reverse choice, at minimum:

- Framework / platform (SwiftUI vs Expo vs web stack, navigation approach)
- Storage / database (local persistence, cloud database, migration strategy)
- Authentication (provider, session model)
- Payments (provider, subscription model)
- Sync / offline strategy
- Any third-party service the app becomes dependent on
- Anything else that would cost more than a day to undo

Small reversible choices (a helper library, a lint rule) do NOT need an ADR — a line in the relevant doc is enough.

## Process

1. Copy `templates/docs/adr.md` to `docs/adr/NNNN-title.md` with the next free number.
2. Fill every section — "Alternatives considered" with one-line why-rejected is not optional.
3. Add a row to the index below.
4. Link the ADR from `docs/tech/tech-stack.md` or `docs/tech/architecture.md` where the choice appears.

## Index

| # | Title | Status | Date |
|---|-------|--------|------|
