# .claude/rules/ — path-scoped rules

Rule files in this directory are Markdown files with a `paths:` frontmatter
listing glob patterns. Claude Code loads a rule **only when the agent touches
files matching those globs** — unlike CLAUDE.md, which loads every session.
This keeps stack-specific conventions out of the always-on context budget.

## How it works

- Each rule is a file `.claude/rules/<name>.md`.
- YAML frontmatter declares `paths:` with one or more globs.
- The body is plain Markdown: conventions, dos/don'ts, snippets.
- Keep each rule short (~20 lines) — it is injected verbatim when triggered.

## Who writes rules here

The template ships **no rules** — only this README. `/onboard` (Phase 5)
generates stack-specific rule files for the platform chosen during the
interview, e.g. `swiftui.md` for an iOS app, or `react.md` for a web app.
You can add or edit rules by hand at any time; they take effect on the next
session (or when the matching files are next touched).

## Example

A generated `swiftui.md` looks like this (shown here as an example only —
do not create it by hand; onboarding writes the real one for your stack):

```markdown
---
paths:
  - "app/**/*.swift"
---

# SwiftUI conventions

- Never hard-code colors, fonts, spacing or radii: use the design tokens
  defined by docs/design/DESIGN.md (DesignTokens.swift).
- One View per file; the file name matches the primary type.
- Views stay dumb: business logic lives in observable model types.
- Every user-facing string goes through the tone rules in
  docs/design/voice.md.
- Add an accessibility identifier to every interactive element — the
  app-tester agent relies on them to drive the simulator.
```
