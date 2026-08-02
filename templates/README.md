# Templates

This folder holds the **source templates** for every document the agent generates
during the life of a project. Templates are consumed by skills — never by hand.

## How templates are consumed

1. A skill (`/onboard`, `/design`, `/build-next`, `/new-feature`) **copies** a
   template to its destination path, then **fills** it.
2. The `<!-- TEMPLATE: ... -->` comment at the top of each template contains
   instructions for the agent filling it. **Remove that comment** (and every
   per-section guidance comment) from the filled instance.
3. Replace every `{{placeholder}}` with real content. A filled document must
   contain **zero** `{{...}}` markers and zero guidance comments — if a section
   truly does not apply, write "Not applicable — <reason>" instead of deleting it
   silently.

## Rules

- **Never edit a template to customize a specific project.** Templates belong to
  the reusable machinery; project content belongs in the filled instance
  (`docs/`, `specs/`). Editing a template is only correct when improving the
  template for *all future* documents.
- **Never link to a template from a filled document.** Filled documents stand on
  their own.
- The `{{placeholder}}` convention: lowercase snake_case between double braces,
  e.g. `{{app_name}}`, `{{feature_id}}`. Anything else in a template is literal
  text to keep.

## Template map

| Template | Destination (filled instance) | Filled by |
|---|---|---|
| `docs/constitution.md` | `docs/constitution.md` | `/onboard` |
| `docs/brief.md` | `docs/product/brief.md` | `/onboard` |
| `docs/prd.md` | `docs/product/prd.md` | `/onboard` (appended by `/new-feature`) |
| `docs/personas.md` | `docs/product/personas.md` | `/onboard` |
| `docs/roadmap.md` | `docs/product/roadmap.md` | `/onboard` (updated by `/new-feature`) |
| `docs/tech-stack.md` | `docs/tech/tech-stack.md` | `/onboard` |
| `docs/architecture.md` | `docs/tech/architecture.md` | `/onboard` |
| `docs/structure.md` | `docs/tech/structure.md` | `/onboard` |
| `docs/testing.md` | `docs/tech/testing.md` | `/onboard` |
| `docs/adr.md` | `docs/adr/NNNN-title.md` (4-digit, from 0001) | `/onboard`, `/build-next`, `/new-feature` |
| `docs/design.md` | `docs/design/DESIGN.md` | `/design` |
| `docs/voice.md` | `docs/design/voice.md` | `/design` |
| `specs/spec.md` | `specs/changes/<slug>/spec.md` | `/build-next` |
| `specs/plan.md` | `specs/changes/<slug>/plan.md` | `/build-next` |
| `specs/tasks.md` | `specs/changes/<slug>/tasks.md` | `/build-next` |
| `components.example.json` | schema reference only — `/onboard` generates `components.json` from the Project shape answers | `/onboard` |
| `features.example.json` | schema reference only — `/onboard` generates `features.json` from the PRD | `/onboard` |

`<slug>` = `F-XXX-kebab-title` (feature id + kebab-cased short title), e.g.
`specs/changes/F-004-streak-counter/`.

MCP server configuration templates live in `templates/mcp/` — see
`templates/mcp/README.md` for how `/onboard` assembles `.mcp.json` from them.
