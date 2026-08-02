<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/design/DESIGN.md. Filled by /design after the user picks a
direction from rendered previews. This document is LAW for all UI work
(constitution Article V): two layers — exact tokens (machine layer, kept in
sync with docs/design/tokens.css or the platform token file) AND taste rules
(when/how to apply them). Be specific: real values, not vibes. Replace every
{{placeholder}}; delete all comments from the filled instance. 9-section schema
adapted from VoltAgent/awesome-design-md (see THIRD_PARTY_NOTICES.md), plus a
10th section mapping the system onto each UI component. -->

# {{app_name}} — Design System

Direction: **{{direction_name}}** — chosen {{date}} from rendered candidates
(`evidence/design-candidate-{{n}}.png`).

## 1. Theme & Atmosphere

{{atmosphere_paragraph}}
<!-- 3-5 sentences: the feeling a screen should give in the first 3 seconds,
the cultural/visual references behind the direction, the emotional target for
Persona 1. End with the one-line design intent that settles arguments. -->

**Signature element:** {{signature_element_description}}
<!-- The ONE memorable thing a user recalls 5 seconds after seeing a screen —
a distinctive component, layout move, color behavior, or motion moment. Say
exactly where it appears and where it must NOT be repeated (boldness is spent
in one place). -->

## 2. Palette

<!-- Every color the app may use. Token names are semantic roles, not color
names. Values are exact (hex or platform equivalent) for BOTH modes. Usage
rules say where the token is allowed/forbidden. Anything not in this table is
forbidden. -->

| Token | Light | Dark | Role | Usage rules |
|---|---|---|---|---|
| `bg` | {{hex}} | {{hex}} | App background | {{rule}} |
| `surface` | {{hex}} | {{hex}} | Cards, sheets | {{rule}} |
| `text` | {{hex}} | {{hex}} | Primary text | {{rule}} |
| `text-muted` | {{hex}} | {{hex}} | Secondary text | {{rule}} |
| `accent` | {{hex}} | {{hex}} | The brand move: primary actions, key highlights | {{rule — where accent is allowed; keep it scarce}} |
| `danger` | {{hex}} | {{hex}} | Destructive, errors | {{rule}} |

**Palette logic:** {{dominant_vs_accent_logic}}
<!-- e.g. "dominant warm neutral field, one saturated accent used at most once
per screen". Dark mode is designed, not auto-inverted — note any token whose
dark value is deliberately NOT a simple inversion and why. -->

## 3. Typography

<!-- Named families with full fallback stacks and where each weight/size is
used. Identity fonts must NOT be from the banned list (Inter, Roboto, Arial,
system-ui, Space Grotesk, Poppins as identity — fallback stack only). -->

- **Display / identity:** {{display_font}} — {{weights}} — fallback: {{fallback_stack}}
- **Body:** {{body_font}} — {{weights}} — fallback: {{fallback_stack}}

| Role | Family | Size | Weight | Usage |
|---|---|---|---|---|
| Screen title | {{family}} | {{size}} | {{weight}} | {{usage}} |
| Section header | {{family}} | {{size}} | {{weight}} | {{usage}} |
| Body | {{family}} | {{size}} | {{weight}} | {{usage}} |
| Caption / meta | {{family}} | {{size}} | {{weight}} | {{usage}} |

{{type_personality_note}}
<!-- One line on how type carries the direction: tight tracking? oversized
numerals? etc. -->

## 4. Components

<!-- Concrete construction rules per core component. States are mandatory:
default / pressed / disabled / destructive where relevant. -->

- **Buttons:** {{shape_radius_border_fill}}; pressed: {{pressed_state}};
  disabled: {{disabled_state}}. Primary uses `accent`; secondary: {{secondary_style}}.
- **Cards:** {{card_construction}} (surface token, radius {{radius}}, border
  {{border_rule}}, elevation per section 6).
- **Inputs:** {{input_construction}}; focus state: {{focus_state}}; error state
  uses `danger` + copy per voice.md.
- **Lists:** {{list_construction}} (row height, separators, swipe actions,
  empty-state composition).
- {{app_specific_component}}: {{construction}}
<!-- Add the 1-3 components specific to THIS app (e.g. the habit ring, the
timeline row) — especially the signature element's component. -->

## 5. Layout & Spacing

- **Spacing scale:** {{scale}} <!-- e.g. 4 / 8 / 12 / 16 / 24 / 32 / 48 — only
  these values, ever. -->
- **Screen margins:** {{margins}}; **grid:** {{grid_or_stack_logic}}
- **Density stance:** {{spacious_or_dense}} — {{one_line_rule}}
<!-- e.g. "calm: one primary action per screen, generous whitespace above the
fold" or "dense: data-first tables, compact rows, no decorative padding". -->

## 6. Depth & Elevation

{{elevation_system}}
<!-- The chosen depth language: flat with borders? soft shadows? layered
surfaces? Define the levels actually used (e.g. level 0 bg, level 1 card,
level 2 sheet) with exact shadow/border values per mode. Ban uniform
shadow-on-everything. -->

## 7. Motion

- **Durations:** {{fast}}ms (micro-feedback) / {{base}}ms (transitions) /
  {{slow}}ms (rare, orchestrated moments)
- **Easing:** {{easing_curves}}
- **What animates:** {{animated_things}} <!-- short list, e.g. "state changes on
  the signature element, sheet presentation, list reorder". -->
- **What NEVER animates:** {{never_animated}} <!-- e.g. "text opacity on load,
  parallax backgrounds, anything during typing". Less motion reads less
  AI-generated; one orchestrated moment beats ten scattered effects. -->
- Respect the platform reduce-motion setting: all motion collapses to fades.

## 8. Guardrails

**Do:**
- {{project_do_1}}
- {{project_do_2}}
- Spend boldness in one place: the signature element carries the personality;
  everything around it stays disciplined.

**Don't:**
- {{project_dont_1}}
- {{project_dont_2}}
- No banned identity fonts; no purple-gradient-on-white, cream+serif+terracotta,
  or dark+neon-green cliché looks; no everything-rounded-2xl; no gradient-blob
  heroes; no uniform shadow on every element.

**Recognition test:** a screenshot with the logo removed must still be
identifiable as {{app_name}} — via {{what_makes_it_recognizable}}.

## 9. Agent Guide — Composing a New Screen

1. Read the feature's spec; identify the screen's ONE primary action.
2. Start from `bg`, place content on `surface` per section 4's constructions;
   margins and gaps only from the section 5 scale.
3. Type from the section 3 table only — no new sizes or weights.
4. `accent` appears {{accent_budget}} <!-- e.g. "at most once per screen, on the
   primary action" -->; the signature element appears only where section 1 allows.
5. Design empty, loading, and error states before polishing the happy path —
   copy comes from voice.md.
6. Check both modes against the section 2 table, then self-review against
   section 8 before showing the result.
7. When this document does not answer a styling question, choose the quieter
   option and note the gap — propose a DESIGN.md addition rather than
   improvising a new pattern.

## 10. Surfaces

<!-- Delete this section for a single-component project. ONE design system
covers every UI surface — same palette, same type, same voice — but surfaces
have different jobs. State the adaptation per component from components.json,
never a second design system. -->

| Surface | Component | Job | Density | Type scale | Motion | Signature element |
|---|---|---|---|---|---|---|
| {{surface_name}} | `{{component_id}}` | {{one_line_job}} | {{spacious_or_dense}} | {{which_end_of_the_section_3_scale}} | {{motion_level}} | {{present_or_absent}} |

Guidance to fill it honestly:

- **marketing-site** — persuades a stranger in five seconds: the largest end of
  the type scale, generous whitespace, exactly one dominant CTA per viewport,
  the signature element used at full strength. It is the loudest surface.
- **mobile-app / web-app** — serves a returning user: denser, quieter, faster.
  Boldness is spent on the one signature moment, everything else recedes.
- **admin** — information density wins over charm: compact rows, no decorative
  motion, but the same palette and type families so it still feels like the
  product.

Rules that hold across every surface (non-negotiable):

- Identical color tokens and font families — a surface may use a different
  *subset*, never a different *system*.
- The same voice (voice.md) everywhere, including error strings emitted by
  non-UI components.
- Light and dark both work on every surface.
