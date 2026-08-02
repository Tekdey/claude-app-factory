# context/ — drop your knowledge here

Everything in this folder is read **first** by `/onboard` (Phase 0 — context
ingestion), before a single question is asked. Any question your documents
already answer is skipped: the agent states the inferred answer and moves on,
and you can correct it if the inference is wrong. The agent also comes back to
this folder later, whenever it needs to resolve an ambiguity during the build.

Any file type works: Markdown, plain text, PDF (read page by page), images
(described visually). Nothing here is required — an empty `context/` just means
a slightly longer interview.

## What to drop where

### `brand/` — existing visual identity

- logo files (any format)
- brand colors, fonts, or a full brand guide / design system
- existing marketing material that defines the look

Anything here is treated as **law** by the design phase: palettes and typefaces
are extracted from your assets, not invented.

### `inspiration/` — what you love and hate

- screenshots of apps whose look you **love** — name them `love-*.png`
- screenshots of apps whose look you **hate** — name them `hate-*.png`
- links to sites or apps: list them in a `links.md`, one per line, with a short
  "why" (what specifically you like or dislike about each)

### `docs/` — product knowledge

- briefs, notes, back-of-a-napkin idea dumps
- competitor analysis, market research
- existing specs, requirement documents, user feedback
- any relevant PDF

## Adding context later

You can drop new files here at any time after onboarding. They are picked up by
a re-run of `/onboard` (update mode) and consulted whenever the agent hits an
ambiguity that your documents might resolve.
