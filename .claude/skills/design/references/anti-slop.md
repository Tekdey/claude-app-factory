# Anti-slop critique checklist

Run this checklist on EVERY candidate direction in Phase 3 (before showing the user) and once more on the final DESIGN.md before emitting. Answer each item honestly, in writing (in your reasoning). A candidate that fails a **hard fail** item gets revised or replaced — never shown as-is. A candidate that trips a **smell** gets one targeted fix.

The point is not "never use cream or serif or dark mode". Every look below is legitimate when the brief genuinely calls for it. The point is that these looks appear as *defaults regardless of subject* — if your candidate matches one, you must be able to state the project-specific reason. "It looks nice" is not a reason.

## 1. The three known AI-slop looks — hard fail if matched without justification

1. **The cream + serif + terracotta startup look.** Warm cream background (near `#F4F1EA`), high-contrast serif display, terracotta/burnt-orange accent, generous whitespace, "tasteful" and interchangeable. If your candidate is within squinting distance of this, change at least the surface temperature or the accent family — or show written proof the brief demands exactly this.
2. **The dark + neon-green cyber look.** Near-black background, single acid-green (or vermilion) accent, mono or techno type, glow effects. Appears whenever "tech" or "developer" is in the brief. Same rule: justify from THIS product or move.
3. **The purple-gradient SaaS look.** Violet-to-blue gradient (usually on white), rounded-2xl cards, soft drop shadows everywhere, emoji-decorated feature grid. The default "modern app" answer. Hard fail on the gradient-as-identity; purple as a flat, committed brand color can survive if argued.

Watch-list (not the big three, but rising defaults): the broadsheet look (hairline rules, zero radius, newspaper columns) applied to non-editorial products; the "new neutral" stack of Satoshi/Clash Display + monochrome + one accent, which is becoming the 2026 Inter.

## 2. Banned identity fonts — hard fail

**Inter, Roboto, Arial, system-ui, Space Grotesk, Poppins** must never be the display or body identity of the app. They are allowed **only** inside fallback stacks (e.g. `font-family: "Fraunces", Georgia, serif;` / `"Schibsted Grotesk", Inter, system-ui, sans-serif;`). If a candidate's personality collapses when you imagine it in Arial, the type isn't carrying identity — pick faces that are a choice, and be ready to say what each face contributes.

## 3. Smell tests — fix on detection

- **Timid palette.** Every color mid-saturation, nothing dominant, accents that whisper. Test: name the ONE dominant color and the ONE sharpest accent. If you can't, or they're the same weight, commit harder — a dominant + a sharp accent beats five polite pastels.
- **Everything-rounded-2xl.** The same 12-16px radius on every card, button, input and image. Radius is a voice, not a default: pick a stance (sharp, mixed-with-intent, or fully round) and vary it with meaning (e.g. interactive vs container).
- **Gradient-blob hero.** Decorative gradient blobs/mesh floating behind content, purple-cyan glow, "abstract shapes" filler. If a background needs decoration, derive it from the product's world (texture, pattern, data) or leave it quiet.
- **Uniform shadow.** One `box-shadow` copy-pasted on every element at the same elevation. Elevation is information — define 2-3 levels in the token set, state what lives at each, and let most things sit flat.

## 4. Positive tests — ALL must pass

- **Signature element exists.** There is ONE memorable element you can name in a sentence ("the oversized amber day-counter with tabular numerals", "the hand-drawn checkmark animation"). Not two, not zero. Boldness is spent there; everything around it is quiet.
- **Recognizable without the logo.** Imagine a screenshot of the main screen with the logo removed, next to five competitor screenshots. A returning user can pick yours out. If not, the identity lives only in the logo — which means there is no identity.
- **Light AND dark both designed.** Dark mode is not `filter: invert` with fixed bugs: surfaces keep their temperature, the accent is re-tuned for dark contrast, shadows become edges or glows deliberately, and both modes were actually rendered in the preview.
- **Every token has a job.** Each of the 4-6 colors has a semantic role you can state ("dominant surface", "primary action", "danger"). A color with no role is decoration debt — cut it.
- **Candidates are far apart.** (Phase 3 only.) Shrink all candidate previews to thumbnails in your mind: if two could be confused, they are one direction with a costume change — replace one with a different family from `directions.md`.

## 5. How to run the critique

1. For each candidate, work through sections 1-4 in order; write one line per item: PASS / FAIL / SMELL + evidence ("accent `#E2725B` = terracotta on cream `#F5F2EB` → look #1 → shifting surface cool + accent to oxblood").
2. Ask the calibration question: *if I got a similar brief for a different product, would I have produced roughly this?* If yes, it's a default, not a choice — revise the part that would repeat.
3. Fix, then re-run the failed items once. Two consecutive fails on the same candidate → replace it with a different family rather than sanding the same one.
4. Keep one sentence per candidate summarizing what the critique changed — it goes in DESIGN.md section 1 (considered-and-rejected notes) so future sessions don't re-litigate.
