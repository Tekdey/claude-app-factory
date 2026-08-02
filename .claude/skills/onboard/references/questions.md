# Onboarding question bank

Eight themes, asked in this order: **Product → Project shape → Audience →
Business model → Design → Tone → Tech & constraints → Process preferences.**

Question id prefixes: `Q-P` Product · `Q-S` Project shape · `Q-A` Audience ·
`Q-B` Business model · `Q-D` Design · `Q-V` Tone/Voice · `Q-T` Tech ·
`Q-W` Process (workflow).

How to use this bank:

- The bank deliberately holds more questions than the per-theme budget
  (5). "Skip if" rules plus grouping keep each theme within budget; when a whole
  theme is a gap, drop the question marked *lowest value* first.
- Every question implicitly offers **"You decide"** — you pick, and you record
  the choice + one-line rationale in the doc that carries it.
- With AskUserQuestion: group questions of the same theme, max 4 per call, mark
  exactly one option per question as recommended. Without it: numbered questions
  with lettered options, so the user can answer "1A, 2C".
- Options below are starting points — always adapt wording and recommendations
  to what Phase 0 revealed. A recommendation must never contradict `context/`.

---

## Theme 1 — Product

Typically answered by: a brief, pitch deck or notes in `context/docs/`.

### Q-P1 · One-sentence pitch
- **Ask**: "In one sentence: what is the app, who is it for, and what problem
  does it solve?"
- **Options**: free text. If the user struggles, draft 2–3 candidate pitches
  from `context/` and let them pick or edit one.
- **Recommended**: —
- **Skip if**: any document in `context/docs/` states product + audience +
  problem (quote the sentence back for confirmation).

### Q-P2 · Current alternatives and their pain
- **Ask**: "How do people solve this today (app, spreadsheet, paper, nothing),
  and what is the most painful part of that?"
- **Options**: free text; prompt with examples if needed ("too slow / too
  complex / doesn't exist / spread across 3 tools").
- **Recommended**: —
- **Skip if**: competitor or market analysis in `context/docs/` covers it.

### Q-P3 · Must-haves and explicit non-goals
- **Ask**: "List the 3–5 capabilities v1 cannot ship without — and name at
  least 2 things that are explicitly OUT of scope."
- **Options**: free text. Push back if the must-have list exceeds 5: "which one
  would you cut first?"
- **Recommended**: —
- **Skip if**: an MVP scope or feature list exists in `context/docs/`.
- Non-goals feed the PRD Non-Goals section and constitution Article VIII — do
  not let the user skip the OUT-of-scope half.

### Q-P4 · North-star metric
- **Ask**: "Three months after launch, which single number tells you it's
  working?"
- **Options**: (a) weekly active users · (b) core actions completed per user
  per week **(recommended — usage beats vanity)** · (c) paying conversions ·
  (d) day-30 retention · (e) other (name it).
- **Skip if**: success metrics stated in `context/docs/`.

### Q-P5 · Competitor references, love and hate *(lowest value in this theme)*
- **Ask**: "Name 2–3 competitor or reference products. What do they get right,
  and what do they get wrong?"
- **Options**: free text.
- **Recommended**: —
- **Skip if**: `context/inspiration/links.md` or competitor notes in
  `context/docs/` exist.

---

## Theme 2 — Project shape

**Ask this theme early and never skip it entirely.** Most people describe the
piece they have in mind (usually the app) and only remember the API or the
marketing site much later — by which time the PRD, roadmap and scaffold are
already built around a single deliverable. Surfacing every component here is
what makes the rest of the onboarding correct.

Typically answered by: an architecture note or scope section in `context/docs/`.

### Q-S1 · What does this project ship?
- **Ask**: "Beyond the main thing you just described, what else does this
  project need to ship? Pick everything that applies — it is normal to have
  several."
- **Options** *(multi-select)*: (a) mobile app (iOS/Android) · (b) web app
  (the product itself, behind login) · (c) marketing site / landing page ·
  (d) API or backend **you write yourself** (as opposed to a managed backend
  like Supabase — that is `Q-T3`) · (e) admin dashboard / back-office ·
  (f) CLI or automation tool · (g) shared library or SDK · (h) nothing else,
  a single component.
- **Recommended**: none — this is a factual question, never guess. If the user
  hesitates, walk the product story out loud: "someone hears about it *(site?)*,
  signs up *(app?)*, their data lives somewhere *(API? managed backend?)*, and
  you need to moderate or support them *(admin?)*."
- **Follow-up for each component picked**: a short id (kebab-case: `ios`, `api`,
  `web`, `admin`), and whether it is in scope for **v1** or later — a component
  planned for later is still recorded in `components.json` with its features
  parked in a later roadmap phase, so the architecture accounts for it now.
- **Skip if**: `context/docs/` states the full system scope — quote it back for
  confirmation, never assume a single component from silence.

### Q-S2 · Which component is the centre of gravity?
- **Ask**: "Which one *is* the product in your head — the one that must be
  excellent, the others serving it?"
- **Options**: the components picked in Q-S1.
- **Recommended**: the one the user described first in Q-P1.
- **Why it matters**: it becomes `"primary": true` in `components.json`, drives
  the design system's main surface, the onboarding smoke test, and the default
  view of `/status`.
- **Skip if**: only one component exists — it is primary by definition.

### Q-S3 · How do the components talk to each other? *(skip if single component)*
- **Ask**: "Roughly how do these fit together — which one calls which, and is
  anything shared between them?"
- **Options**: (a) app + site both call the API **(recommended for the classic
  app + API + landing shape)** · (b) the site is fully standalone, just a CTA
  linking out · (c) shared design tokens or types package between components ·
  (d) let the agent propose the wiring in `architecture.md` and confirm.
- **Feeds**: `depends_on` in `components.json`, the system diagram in
  `architecture.md`, and the build order in the roadmap (a component that others
  depend on is built first).
- **Skip if**: an architecture doc in `context/docs/` covers it.

---

## Theme 3 — Audience

Typically answered by: persona docs, market research in `context/docs/`.

### Q-A1 · Primary user
- **Ask**: "Who is the primary user? Pick the closest profile."
- **Options**: (a) busy professional 25–45, comfortable with apps
  **(recommended default if nothing suggests otherwise)** · (b) mainstream
  casual user, low tech patience · (c) expert / power user who wants density
  and shortcuts · (d) teens / students · (e) seniors, accessibility-first ·
  (f) an internal team (colleagues).
- **Skip if**: persona or audience material in `context/docs/`.

### Q-A2 · Day-in-the-life and trigger moment
- **Ask**: "Walk me through their typical day. What exact moment makes them
  open the app, and what frustrates them most at that moment?"
- **Options**: free text (this is a proxy question — it feeds personas AND
  design/tone; never replace it with 'describe your target audience').
- **Recommended**: —
- **Skip if**: a persona doc with day-in-the-life detail exists.

### Q-A3 · Buyer vs user
- **Ask**: "Is the person who pays the same person who uses it?"
- **Options**: (a) yes — consumer app (B2C) **(recommended default)** ·
  (b) no — a company buys, employees use (B2B) · (c) prosumer — individuals
  pay for their own professional tool.
- **Skip if**: business model material in `context/docs/` answers it.

### Q-A4 · Market, languages, accessibility
- **Ask**: "Which market(s) and language(s) at launch? Any accessibility
  requirements beyond the basics?"
- **Options**: (a) home market + its language only **(recommended for v1)** ·
  (b) home + English · (c) multi-language from day one · Accessibility:
  screen-reader + dynamic type support is always on; flag anything extra
  (motor, cognitive, contrast).
- **Skip if**: stated in `context/docs/`.

### Q-A5 · Usage context *(lowest value in this theme)*
- **Ask**: "Where and how is the app mostly used?"
- **Options**: (a) one-handed, on the go, seconds at a time · (b) couch /
  tablet, relaxed sessions · (c) at a desk, long sessions · (d) offline-heavy
  (travel, field work) · (e) mixed **(recommended if unsure)**.
- **Skip if**: obvious from the product (e.g. a running tracker).

---

## Theme 4 — Business model

Typically answered by: business plan or pricing notes in `context/docs/`.
For an internal/personal tool, ask Q-B1 only and skip the rest of the theme.

### Q-B1 · Revenue model
- **Ask**: "How does this make money?"
- **Options**: (a) free, no revenue (internal / portfolio / mission) ·
  (b) paid up-front · (c) freemium + subscription **(recommended default for
  consumer apps)** · (d) free + in-app purchases · (e) ads ·
  (f) B2B licensing / seats.
- **Skip if**: revenue model in `context/docs/`.

### Q-B2 · Freemium split
- **Ask**: "What is free vs paid, and is there a trial?" *(only if Q-B1 =
  freemium/subscription/IAP)*
- **Options**: (a) core loop free, power features paid **(recommended)** ·
  (b) free tier with quota limits · (c) full app, time-limited trial.
- **Skip if**: Q-B1 answer was (a), (b), (e) or context covers pricing.

### Q-B3 · Pricing anchor *(lowest value in this theme)*
- **Ask**: "What do comparable products charge? Where do you want to sit?"
- **Options**: (a) below market · (b) at market **(recommended)** · (c) premium
  above market · (d) no idea — benchmark competitors and propose (record as a
  PRD open question).
- **Skip if**: pricing in `context/docs/`, or no revenue model.

### Q-B4 · Unfair advantage
- **Ask**: "Why you? What do you have that a competitor can't easily copy?
  (audience, expertise, data, distribution, brand — 'nothing yet' is a valid
  answer)"
- **Options**: free text.
- **Recommended**: —
- **Skip if**: covered in `context/docs/`. Feeds the Lean Canvas directly.

### Q-B5 · Budget & timeline constraints
- **Ask**: "Any deadline or budget constraint that should shape scope?"
- **Options**: (a) ship a usable v1 in weeks — cut aggressively
  **(recommended default)** · (b) 1–3 months, polish matters · (c) side
  project, no deadline · (d) hard external deadline (give the date).
- **Skip if**: stated in context.

---

## Theme 5 — Design

Typically answered by: `context/brand/` (assets = LAW) and
`context/inspiration/` (`love-*` / `hate-*` files, `links.md`).
Full taxonomy of directions: `.claude/skills/design/references/directions.md`.

### Q-D1 · Love / hate references
- **Ask**: "Name 2–3 apps or sites whose look you LOVE and one you HATE — and
  say what, specifically, in each. Screenshots into `context/inspiration/`
  (`love-*.png` / `hate-*.png`) are even better."
- **Options**: free text + optional file drop.
- **Recommended**: —
- **Skip if**: `context/inspiration/` already holds love/hate references.

### Q-D2 · Aesthetic direction
- **Ask**: "Pick the aesthetic family that feels closest — `/design` will show
  you 2–3 rendered directions to choose from anyway, so this only seeds it."
- **Options** (from the design skill's taxonomy): (a) minimal / utilitarian ·
  (b) warm editorial · (c) bold brutalist · (d) playful rounded · (e) luxury
  dark · (f) retro-future · (g) neo-nature / organic · (h) technical /
  data-dense · (i) soft neumorphic-lite · (j) agent's wildcard — surprise me
  **(recommended when the user has no strong opinion)**.
- **Skip if**: brand guide in `context/brand/` imposes a direction, or the
  love-references converge clearly on one family (state which).

### Q-D3 · Existing brand assets
- **Ask**: "Do you have existing brand assets (logo, colors, fonts, guide)?"
- **Options**: (a) yes — I'll drop them in `context/brand/` now (wait for
  them) · (b) no — create the identity from scratch **(recommended if
  `context/brand/` is empty)**.
- **Skip if**: `context/brand/` is non-empty — then assets are LAW: extract
  palette/fonts in Phase 0 and confirm, don't re-ask.

### Q-D4 · Color anchor & dark mode
- **Ask**: "Any color that MUST appear (or must NOT)? And dark mode?"
- **Options** color: free (accept vague answers like "something warm" — the
  design phase turns them into tokens) · none — designer's choice. Dark mode:
  (a) light only · (b) dark only · (c) both, designed intentionally
  **(recommended)**.
- **Skip if**: brand palette exists in `context/brand/`.

### Q-D5 · Density & motion
- **Ask**: "Should screens feel spacious and calm, or dense and informative?
  And motion?"
- **Options** density: (a) spacious-calm **(recommended for consumer)** ·
  (b) dense-informative (right for expert/data tools). Motion: (a) none ·
  (b) subtle and purposeful **(recommended)** · (c) expressive.
- **Skip if**: inspiration references make it obvious (state the inference).

### Q-D6 · Signature element *(lowest value — /design can propose one)*
- **Ask**: "What should someone remember 5 seconds after seeing one screen?
  A shape, a color move, an interaction, a voice?"
- **Options**: free text · "You decide" **(recommended — the design phase
  proposes one per direction)**.
- **Skip if**: brand guide defines one.

---

## Theme 6 — Tone of voice

Typically answered by: brand guide with voice section in `context/brand/`.

### Q-V1 · Dinner-party persona
- **Ask**: "If the app were a person at a dinner party, how do they talk?"
- **Options**: (a) warm expert — knows a lot, never condescends
  **(recommended default)** · (b) playful buddy — jokes, energy, emoji ·
  (c) calm professional — precise, neutral, zero fluff · (d) irreverent wit —
  personality with edges · (e) luxe-reserved — few words, all weight.
- **Skip if**: voice/tone defined in `context/brand/`.

### Q-V2 · Formality & vocabulary
- **Ask**: "Formal or informal address (in languages with a T–V distinction,
  e.g. tu/vous, du/Sie, tú/usted)? Technical jargon or plain words? Emoji in
  the UI?"
- **Options** address: (a) informal **(recommended for consumer)** ·
  (b) formal (B2B, seniors, luxury). Jargon: plain words unless the
  audience is expert. Emoji: (a) never · (b) rare, functional
  **(recommended)** · (c) frequent.
- **Skip if**: brand guide covers it; align with Q-A1 audience.

### Q-V3 · Error & empty-state register
- **Ask**: "When something fails or a screen is empty, how should it sound?"
- **Options**: (a) factual — state it and move on · (b) reassuring — calm,
  next step always offered **(recommended)** · (c) lightly humorous — only if
  Q-V1 chose a playful persona.
- **Skip if**: voice guide covers it.

### Q-V4 · Name, tagline, forbidden words
- **Ask**: "Is the app name final? A tagline? Any words to never use?"
- **Options**: free text. If no name: offer to shortlist 5 candidates after
  the interview (record as a PRD open question, don't block).
- **Recommended**: —
- **Skip if**: name/tagline in `context/`, or given via `$ARGUMENTS`
  (confirm it).

---

## Theme 7 — Tech & constraints

Typically answered by: technical notes in `context/docs/`. Run
`./init.sh doctor` before this theme if the environment matters to the
recommendation (e.g. is Xcode present?).

### Q-T1 · Stack per component
- **Ask**: one stack question **per component declared in Q-S1**, in
  `depends_on` order (dependencies first). Group them into a single
  AskUserQuestion call when there are 2–4 components.

For a **mobile app** component, the honest tradeoffs:

| | iOS native (SwiftUI) | Cross-platform (Expo/RN) | Web app (PWA) |
|---|---|---|---|
| Look & feel | Best-in-class native | Near-native | Browser-bound |
| Needs a Mac | Yes (Xcode) | **No** (EAS cloud builds) | No |
| Reach | iPhone/iPad only | iOS + Android, one codebase | Any device, no install |
| Store review | Yes | Yes (both stores) | None — instant deploys |
| Offline | Strong | Good | Limited (service workers) |
| Agent verifies via | iOS simulator (XcodeBuildMCP) | Simulator/emulator (mobile-mcp) | Browser (Playwright MCP) |

- **mobile-app** → (a) iOS native SwiftUI **(recommended if the doctor check
  shows a Mac + Xcode and the product is iOS-first — this template's default)** ·
  (b) cross-platform Expo **(recommended if Android matters or no Mac)** ·
  (c) web/PWA instead.
- **web-app** → (a) Next.js **(recommended when SEO, routing or server
  rendering matter)** · (b) Vite + React (lighter SPA) · (c) other (name it).
- **marketing-site** → (a) Astro **(recommended — ships near-zero JS, best
  Lighthouse scores for a landing page)** · (b) Next.js (recommended only if it
  shares components with an existing Next web app) · (c) plain HTML/CSS for a
  one-pager.
- **api** → (a) Node + Express + TypeScript **(recommended — ubiquitous,
  trivial for the agent to test over HTTP)** · (b) Fastify (same, faster,
  stricter schemas) · (c) Python + FastAPI · (d) other (name it). Also ask the
  datastore: PostgreSQL **(recommended)** · SQLite (single-node, simplest) ·
  managed (see Q-T3).
- **admin** → default to the same stack as the web app, sharing its design
  tokens; only diverge on request.
- **cli / library** → language follows the component it serves unless stated.
- **Skip if**: `context/docs/` states the stack for that component.
- Each answer becomes one ADR (`docs/adr/`) and one row in `tech-stack.md`.
  Record the `verify` method it implies (`simulator`, `browser`, `http`, `cli`,
  or `none` for a library proven by its unit tests) in `components.json` — that is how `/verify` knows how to prove features.

### Q-T2 · Accounts, sync, offline
- **Ask**: "Do users need accounts? Multiple devices? Does it work offline?"
- **Options**: (a) no accounts, local-only data **(recommended when viable —
  simplest, most private, fastest to ship)** · (b) accounts + cloud sync ·
  (c) offline-first with background sync (hardest — needs a real reason).
- **Skip if**: stated in context. Whatever is chosen triggers an ADR.

### Q-T3 · Imposed services
- **Ask**: "Any services you're set on (Supabase, Firebase, Stripe, analytics
  provider…), or does the agent decide?"
- **Options**: (a) agent decides, one ADR per choice **(recommended)** ·
  (b) here's my list (name them — each still gets an ADR recording it as
  imposed).
- **Skip if**: stack constraints in `context/docs/`.

### Q-T4 · Data sensitivity & compliance
- **Ask**: "Anything sensitive in the data? (personal data/GDPR, health,
  payments, minors) Anything App-Store-review-sensitive?"
- **Options**: (a) nothing special **(recommended default)** · (b) personal
  data — GDPR hygiene · (c) health data — extra care + disclaimers ·
  (d) payments — PCI stays with the provider · (e) minors — age gates.
- **Skip if**: stated in context. Feeds NFRs and architecture security notes.

### Q-T5 · Priority ranking *(lowest value — defaults are sane)*
- **Ask**: "Rank these four: speed-to-ship, visual polish, performance, test
  coverage."
- **Options**: (a) speed > polish > performance > coverage **(recommended for
  a v1)** · (b) polish > speed > performance > coverage (brand-led) ·
  (c) balanced — no strong ordering · (d) custom ranking.
- **Skip if**: obvious from Q-B5.

---

## Theme 8 — Process preferences

Rarely in context/ — usually all asked, but they are quick.

### Q-W1 · Documentation language
- **Ask**: "In which language should the generated docs be written?"
- **Options**: (a) the language you're answering in **(recommended)** ·
  (b) English (wider tooling/reviewer compatibility) · (c) another language
  (ask which).
- **Skip if**: user already stated a preference.

### Q-W2 · How hands-on?
- **Ask**: "How involved do you want to be while the agent builds?"
- **Options**: (a) approve every feature before it's marked done · (b) approve
  at milestones (end of each roadmap phase), agent runs between them
  **(recommended)** · (c) fully autonomous — I'll review when curious.
- Feeds constitution Article VII (process gates).

### Q-W3 · Commit & push policy
- **Ask**: "Git policy?"
- **Options**: (a) commit per logical unit, local only — I push myself
  **(recommended)** · (b) commit + push to a working branch · (c) open PRs
  via `gh` for review.
- Feeds constitution Article VII.

### Q-W4 · Anything else
- **Ask**: "Anything else the agent should know before it starts? Constraints,
  fears, past failures, strong opinions — free text."
- **Options**: free text; "nothing" is fine.
- **Recommended**: —
- Never skip this one — it regularly surfaces the most important constraint of
  the whole interview.
