<!-- TEMPLATE: instructions for the agent filling it.
Destination: docs/design/voice.md. Filled by /design from the tone theme of the
onboarding interview. This document is LAW for all user-facing copy
(constitution Article VI): labels, buttons, empty states, errors, notifications,
store copy. Fill the examples with THIS app's real features — generic examples
teach nothing. Replace every {{placeholder}}; delete all comments from the
filled instance. -->

# {{app_name}} — Voice & UX Writing

## The Dinner-Party Persona

If {{app_name}} were a person at a dinner party, they would be:
{{dinner_party_description}}
<!-- 2-4 sentences from the interview answer: how they talk, what they never
do, how they handle someone's bad news (= error states). This is the intuition
test for any copy: "would this person say that?" -->

## Adjectives

| We are | We are never |
|---|---|
| {{adjective_1}} | {{anti_adjective_1}} |
| {{adjective_2}} | {{anti_adjective_2}} |
| {{adjective_3}} | {{anti_adjective_3}} |
| {{adjective_4}} | {{anti_adjective_4}} |
| {{adjective_5}} | {{anti_adjective_5}} |

## Formality

- **Register:** {{formality_level}} <!-- e.g. "casual but competent — contractions
  yes, slang no". -->
- **T–V distinction (languages that have one):** {{formal_or_informal}} — used consistently everywhere,
  including notifications and store copy.
- **Jargon:** {{jargon_policy}} <!-- plain words vs domain terms Persona 1
  actually uses. -->

## Vocabulary

| Concept | We say | We never say |
|---|---|---|
| {{concept_1}} | {{preferred_term}} | {{forbidden_terms}} |
| {{concept_2}} | {{preferred_term}} | {{forbidden_terms}} |

**Forbidden words (global):** {{forbidden_words_list}}
<!-- From the interview + defaults worth keeping: "oops", "oopsie", corporate
filler ("leverage", "seamless"), guilt-tripping phrasing. -->

## Patterns per Surface

- **Buttons:** imperative verb first, ≤ 3 words, outcome-named ({{button_example}}
  — never "OK", "Submit", "Yes").
- **Empty states:** never blank, never scolding. Structure = what this space
  will show + the one action to start. Example: "{{empty_state_example}}"
- **Error messages:** structure = **what happened + why + next step**, in the
  persona's register, no blame, no error codes as the headline.
  Example: "{{error_example}}"
- **Success moments:** {{success_register}} <!-- how much celebration this brand
  allows — from a quiet checkmark to real warmth. Tie to the signature element
  if motion is involved. --> Example: "{{success_example}}"
- **Notifications:** earn the interruption — concrete, personal, actionable in
  one line; sent only when the user gains something now. Example:
  "{{notification_example}}"

## Emoji Policy

{{emoji_policy}}
<!-- Explicit: none / rare and functional (where exactly) / part of the voice
(which set, which surfaces). "Rare" without rules becomes "everywhere". -->

## Microcopy Examples — Good vs Bad

<!-- 3 pairs using real app features. The bad examples should be the plausible
generic thing an agent would write without this document. -->

| Situation | Good | Bad |
|---|---|---|
| {{situation_1}} | "{{good_copy}}" | "{{bad_copy}}" |
| {{situation_2}} | "{{good_copy}}" | "{{bad_copy}}" |
| {{situation_3}} | "{{good_copy}}" | "{{bad_copy}}" |
