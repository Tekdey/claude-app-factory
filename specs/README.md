# specs/ — Change-based spec lifecycle

Two tiers, adapted from OpenSpec's living-spec + change-folder model and Kiro's 3-file spec:

- **`specs/current/`** — the LIVING spec: what the built system actually does today, expressed as EARS requirements. One markdown file per capability (e.g. `specs/current/habit-tracking.md`, `specs/current/notifications.md`). Empty until the first feature ships.
- **`specs/changes/<slug>/`** — one folder per feature in flight or shipped. Slug = `F-XXX-kebab-title`, matching the feature id in `features.json` (e.g. `F-004-habit-reminders`).

## The three files per change (created by /build-next from templates/specs/)

| File | Role |
|---|---|
| `spec.md` | WHAT: user story, EARS requirements (`WHEN <trigger> THE SYSTEM SHALL <behavior>` + IF/WHILE/WHERE), numbered Given/When/Then acceptance scenarios (AS-1…), edge cases, out of scope. Header carries feature id and status: `DRAFT` → `APPROVED` → `DONE`. |
| `plan.md` | HOW: technical approach, constitution check, design-system check (for UI features), exact files to create/modify, data model changes, risks, rollback note. |
| `tasks.md` | Checkboxed tasks, each naming exact file paths and how to verify it; `[P]` marks tasks safe to parallelize. |

## Lifecycle

1. `/build-next` picks the next feature and creates `specs/changes/<slug>/` with the three files.
2. Ambiguities are marked `[NEEDS CLARIFICATION]` in spec.md and resolved with the user before implementation (bounded questions, answers recorded in the clarifications log).
3. Implementation proceeds task-by-task from tasks.md, checking boxes and committing per logical unit.
4. `/verify` executes the acceptance scenarios against the real running app and captures evidence to `evidence/F-XXX-<kebab-title>.png`.
5. Once verified: **merge the requirement deltas into `specs/current/`** — add, modify or remove the affected EARS requirements in the relevant capability file (create the file if the capability is new).
6. Mark the change folder **DONE** in its spec.md header. **Archive-in-place**: the folder stays exactly where it is, as permanent history. Nothing is moved or deleted.

## Rules

- `specs/current/` is the source of truth for built behavior. Trust it over memory; when in doubt, verify against the running app and fix the spec if it drifted.
- Never edit `specs/current/` directly to describe future work — all changes flow through a `specs/changes/<slug>/` folder.
- One change folder = one feature = one `features.json` entry. No omnibus folders.
- A folder whose spec.md is not `DONE` and has no recent commits is in-flight or abandoned; `/status` lists these.
