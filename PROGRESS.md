# PROGRESS

Session log for this project — **newest entry first**. Every working session MUST
append an entry at the top of the log with:

- **Date** — ISO date of the session
- **Done** — what was accomplished, in one or two lines
- **Features** — feature IDs touched (from `features.json`), if any
- **Next** — the suggested next step for the following session

This file is the agent's cross-session memory: it is injected at session start
(SessionStart hook), read by `/status`, and updated at the end of every
`/build-next` run. Keep entries short; details belong in `specs/changes/` and
git history.

---

## 2026-08-02 — Template instantiated

- **Done:** Template instantiated — onboarding not yet run. No product docs, no
  component manifest, no scaffolds, no features registry exist yet.
- **Features:** none (`features.json` is created by onboarding from the PRD).
- **Next:** run `/onboard` in Claude Code to interview the product owner and
  generate the foundation docs, `components.json`, each component's scaffold in
  `apps/<id>/` and `features.json`.
