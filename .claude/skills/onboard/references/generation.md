# Doc generation checklist (Phase 3)

Ground rules for every document:

- **Copy & fill**: each doc starts from its skeleton under `templates/docs/` —
  read the template, follow its embedded `<!-- TEMPLATE: ... -->` guidance,
  replace every `{{placeholder}}`. Never modify the template files themselves.
- **Language**: the language chosen in Q-W1. One language across all docs.
- **Traceability**: when a decision came from "You decide", write the decision
  AND its one-line rationale into the doc that carries it.
- **No leftovers**: a finished doc contains zero `{{placeholders}}`, zero
  template comments, zero unresolved `[NEEDS CLARIFICATION]` markers (unresolved
  ones go into the follow-up loop at the bottom of this file).
- **Order matters**: generate in the sequence below — each doc feeds the next
  (brief → PRD → architecture chain).

---

## 1. docs/constitution.md

- **Template**: `templates/docs/constitution.md`
- **Inputs**: Q-P1 (mission), Q-P3 (non-goals), Q-T5 (quality priorities),
  Q-W2 + Q-W3 (process gates, git policy), platform choice Q-T1.
- **Quality bar**: version `1.0.0`, ratified with today's date. Article I is
  the one-sentence mission verbatim from the approved recap. Article VII
  encodes the exact approval gates and git policy the user chose. Article VIII
  mirrors the PRD non-goals (keep the two in sync). Every article must be
  enforceable — if you can't imagine a session violating it, cut it.

## 2. docs/product/brief.md

- **Inputs**: whole Product + Business themes (Q-P1…P5, Q-B1…B5), context/docs.
- **Template**: `templates/docs/brief.md`
- **Quality bar**: vision paragraph in the user's own words where possible; all
  9 Lean Canvas blocks filled (Problem, Customer Segments + early adopters,
  UVP, Solution, Channels, Revenue Streams, Cost Structure, Key Metrics,
  Unfair Advantage — "none yet" is honest and acceptable); "why now" and the
  3-month success definition (Q-P4 north-star) present.

## 3. docs/product/personas.md

- **Template**: `templates/docs/personas.md`
- **Inputs**: Audience theme (Q-A1…A5), any persona material in context/.
- **Quality bar**: 1–3 personas maximum. Each has a name, role, tech comfort,
  a day-in-the-life paragraph built from Q-A2 (not generic filler), the trigger
  moment, a success moment, and fears/objections. A reader should be able to
  predict the persona's reaction to a feature.

## 4. docs/product/prd.md

- **Template**: `templates/docs/prd.md`
- **Inputs**: brief.md, personas.md, Q-P3 (scope), Q-S1 (components),
  Q-T4 (compliance → NFRs), Q-V4 (naming), open items from the interview.
- **Quality bar**:
  - Every functional requirement is EARS-formatted and testable:
    `WHEN <trigger> THE SYSTEM SHALL <behavior>` (+ IF/WHILE/WHERE variants),
    numbered `FR-001…`; non-functional requirements numbered `NFR-001…`.
  - Each FR carries at least one Given/When/Then acceptance scenario.
  - **Non-Goals section is mandatory** and lists Q-P3's out-of-scope items.
  - **No tech choices inside the PRD** — the PRD says WHAT, never which
    framework/database/service.
  - **One PRD for the whole product**, never one per component: the value
    proposition is shared. Group FRs under a heading per component when the
    project ships several (`### Mobile app`, `### API`, `### Marketing site`),
    and tag each FR with the component ids it needs — this is what feeds the
    `components` field of every features.json entry. An FR whose behavior spans
    two components stays ONE requirement, described from the user's point of
    view.
  - Open Questions section holds anything genuinely undecided; Clarifications
    log table (date / question / answer) starts with any Phase 1 "You decide"
    calls worth recording.

## 5. components.json (repo root)

- **Model file**: `templates/components.example.json` (schema reference — do not
  copy its example content).
- **Inputs**: Q-S1 (what ships), Q-S2 (primary), Q-S3 (wiring), Q-T1 (stack per
  component).
- **Schema** (exact — `/build-next`, `/verify`, `/status` and the scaffold all
  parse this):

```json
{
  "$comment": "Component manifest — every deliverable this project ships.",
  "components": [
    {
      "id": "api",
      "name": "human-readable name",
      "kind": "mobile-app | web-app | marketing-site | api | admin | cli | library",
      "stack": "Express 5 · TypeScript · PostgreSQL",
      "path": "apps/api",
      "run": "scripts/api/run.sh",
      "verify": "simulator | browser | http | cli | none",
      "primary": false,
      "depends_on": []
    }
  ]
}
```

- **Construction rules**:
  - One entry per component from Q-S1, **including components deferred to a
    later phase** — the architecture must account for them now.
  - `id`: short kebab-case, unique, stable (it appears in `apps/<id>/`,
    `scripts/<id>/`, `.claude/rules/<id>.md` and every features.json entry).
  - `path` is always `apps/<id>` and `run` is always `scripts/<id>/run.sh` — no
    exceptions, so every command can compute them from the id alone.
  - `verify` follows the kind: `mobile-app` → `simulator` (or `browser` for a
    PWA), `web-app`/`marketing-site`/`admin` → `browser`, `api` → `http`,
    `cli` → `cli`, `library` → `none` (proven by its unit tests).
  - Exactly one component has `"primary": true` (Q-S2; the only one if there is
    a single component).
  - `depends_on` lists component ids this one calls at runtime (Q-S3). No
    cycles — if two components need each other, extract the shared part or
    record why in an ADR.
  - Validate before committing: `jq . components.json`.

## 6. docs/product/roadmap.md

- **Template**: `templates/docs/roadmap.md`
- **Inputs**: prd.md, components.json, Q-B5 (timeline), Q-T5 (priorities).
- **Quality bar**: phased — **v0.1 walking skeleton** (the thinnest end-to-end
  slice that launches, shows real data and proves the architecture; typically
  3–6 features), **v1** (launch scope = the Q-P3 must-haves), **v1.x**
  (post-launch). Each phase: goal, feature ids (matching features.json), exit
  criteria. Every PRD FR maps into a phase or is explicitly deferred.
- **Multi-component ordering**: the walking skeleton must cut through **all**
  v1 components — one thin slice proving app ↔ API ↔ site actually wire
  together beats three polished components that have never talked to each
  other. Within a phase, order features by `depends_on` (a component others
  depend on ships its part first). A component deferred to a later phase gets
  its own phase entry so it is never silently forgotten.

## 7. docs/tech/tech-stack.md + ADRs

- **Templates**: `templates/docs/tech-stack.md`, `templates/docs/adr.md`
- **Inputs**: Q-T1…T5, `./init.sh doctor` results, imposed services (Q-T3).
- **Quality bar**: **one table per component** (layer / choice / version / why /
  ADR link), in `components.json` order; local dev commands section lists each
  component's `scripts/<id>/` entry points as Phase 5 will create them; key-libraries
  policy (prefer boring, check context7 docs before adding a dependency).
- **ADRs**: one per major choice, `docs/adr/NNNN-title.md`, 4-digit numbering
  starting `0001`, MADR format from the template. **ADR triggers** — write one
  whenever you decide: platform/framework, storage/persistence, auth provider,
  backend service (Supabase/Convex/Firebase/none), payments, sync/offline
  strategy, analytics/crash reporting, any other hard-to-reverse choice.
  Imposed services (Q-T3b) still get an ADR with status "accepted (imposed by
  owner)". Add each ADR to the index table in `docs/adr/README.md`.

## 8. docs/tech/architecture.md

- **Template**: `templates/docs/architecture.md`
- **Inputs**: tech-stack.md, Q-T2 (accounts/sync/offline), Q-T4 (security).
- **Quality bar**: system context diagram (mermaid) showing **every component**
  from `components.json` and the calls between them (Q-S3 wiring), plus any
  external service; per-component module breakdown; data flow; state management pattern (named — the
  stack rule file in Phase 5 will reference it); sync/offline strategy matching
  Q-T2; error handling strategy consistent with voice.md's error register;
  security notes covering Q-T4's answer.

## 9. docs/tech/structure.md

- **Template**: `templates/docs/structure.md`
- **Inputs**: architecture.md, components.json, the scaffold layout Phase 5 will
  create. Draft it here, then **re-open it at the end of Phase 5** and correct
  any folder the real scaffold named differently — a structure.md that lies
  about the tree is worse than none.
- **Quality bar**: one folder map per component (`apps/<id>/`) with placement
  rules ("new feature screens go in …"), naming conventions, import rules, plus
  a top-level map of the repo showing `apps/`, `scripts/` and what may import
  what across components. Must match what the scaffold recipe actually creates —
  write it against `.claude/skills/onboard/references/scaffold.md` for each
  chosen stack.

## 10. docs/tech/testing.md

- **Template**: `templates/docs/testing.md`
- **Inputs**: Q-T5 (coverage priority), each component's `verify` method.
- **Quality bar**: test pyramid for agents (unit on logic, snapshot where cheap,
  E2E acceptance scenarios = source of truth); what NOT to test; **a section per
  `verify` method** stating how proof is captured — `simulator`/`browser` →
  `.png` screenshot at the assertion moment, `http` → `.txt` transcript of
  requests and responses, `cli` → `.txt` transcript of commands and output;
  the evidence filename convention `evidence/F-XXX-<kebab-title>.<ext>`;
  deterministic-mode requirements (seeded data, animations-off flag, fixed
  clock, test database) so `/verify` runs are reproducible.

## 11. features.json (repo root)

- **Model file**: `templates/features.example.json` (schema reference — do not
  copy its example content).
- **Schema** (exact — `/build-next`, `/verify` and `/status` all parse this):

```json
{
  "$comment": "Autonomous-build ledger. Anthropic long-running-agent harness pattern.",
  "features": [
    {
      "id": "F-001",
      "title": "short name",
      "description": "user-observable behavior, testable",
      "components": ["ios"],
      "source": "docs/product/prd.md#FR-001",
      "priority": "P1",
      "passes": false,
      "evidence": null
    }
  ]
}
```

- **Construction rules**:
  - Source of truth: PRD FRs + roadmap phases. Every FR yields one or more
    features; every feature's `source` points at its FR anchor
    (`docs/product/prd.md#FR-001`) — which resolves only because the PRD
    template gives each FR heading an explicit `<a id="FR-001"></a>`.
  - **Infrastructure is never its own feature.** A database connection, a
    migrations runner, project wiring, an API contract package: none of them is
    user-observable, so none can carry an FR or an acceptance scenario. Fold
    each into the first feature that needs it ("the API's DB connection ships
    inside F-001 Account and session endpoints"), and let the onboarding smoke
    test be the proof that the component starts at all.
  - **Granularity**: one feature = one independently verifiable behavior. If you
    can't capture proof of it passing (screenshot for UI, request transcript for
    an API), it's not a feature — fold infra work into the feature that first
    needs it. If it takes more than one session, split it.
  - `components`: the component ids it touches, **first = where evidence is
    captured**. A feature spanning app + API lists both (`["ios", "api"]`) and
    is proven end-to-end through the UI. Prefer splitting when each half is
    independently valuable (an API endpoint usable on its own gets its own
    feature).
  - 15–40 features is the typical healthy range for a v1 single-component app;
    expect 25–60 across a multi-component project.
  - `id`: `F-001…` sequential, ordered by roadmap phase, then by dependency
    (`depends_on` first — the API endpoint before the screen consuming it),
    then priority.
  - `priority` from roadmap phase: v0.1 walking skeleton → `P1`, v1 → `P2`,
    post-launch → `P3`.
  - Every entry starts `"passes": false, "evidence": null`. **Only** `/verify`
    evidence (a file in `evidence/`) ever flips `passes` to true — never here.
  - Validate before committing: `jq . features.json` and `jq . components.json`.

---

## Self-review pass (mandatory, after all docs are written)

Scan everything you generated and check:

1. **No leftovers**: zero `{{placeholders}}`, template comments, filler prose,
   or unresolved `[NEEDS CLARIFICATION]` markers.
2. **Pitch coherence**: the one-sentence pitch is identical (or a strict
   summary) across constitution Article I, brief.md and prd.md overview.
3. **Scope coherence**: PRD Non-Goals == constitution Article VIII; nothing in
   the roadmap contradicts a non-goal.
4. **Ledger coherence**: every roadmap feature id exists in features.json and
   vice versa; every PRD FR is covered by ≥1 feature or explicitly deferred in
   the roadmap; every `source` anchor resolves to a real FR heading.
5. **EARS validity**: every FR parses as WHEN/IF/WHILE/WHERE … THE SYSTEM
   SHALL …; every FR has ≥1 acceptance scenario.
6. **Stack coherence**: every ADR-triggering choice has its ADR; tech-stack
   table links resolve; structure.md matches the scaffold recipe; testing.md
   names the correct verification MCP for the platform.
7. **Language**: one doc language throughout (Q-W1); formality register consistent with
   Q-V2 anywhere user-facing copy appears in examples.
8. **JSON valid**: `jq . features.json` succeeds.

Resolve what you can yourself. For genuine ambiguities, ask the user **at most
5 follow-up questions** (spec-kit /clarify style: one at a time, concrete
options, recommended answer), record each answer in the PRD Clarifications log,
and fix the affected docs. Anything still open after 5 goes to the PRD Open
Questions section — do not stall onboarding on it.

Note: Phase 4 (`/design`) later adds `docs/design/DESIGN.md`, the token file,
`docs/design/voice.md` and the thin `.claude/skills/brand/SKILL.md` (generated)
— do not create any of those here.
