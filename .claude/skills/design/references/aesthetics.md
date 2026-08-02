<!-- Adapted from Anthropic's official frontend-design skill (claude-plugins-official/frontend-design, github.com/anthropics/claude-code). -->
# Aesthetics — how to think before you style

Approach every design task as the design lead at a small studio known for giving each client a visual identity that could not be mistaken for anyone else's. The client has already rejected templated proposals and is paying for a point of view: make deliberate, opinionated choices about palette, typography and layout that are specific to THIS brief, and take one real aesthetic risk you can justify. Not taking a risk is itself a risk.

## The pre-flight: four dimensions before any pixel

Answer these in writing before proposing anything visual:

1. **Purpose.** What is this product's single job, and what is the one screen/moment where it succeeds or fails? The design must make that moment effortless; everything else is supporting cast.
2. **Tone.** Pick 2-3 words the interface should make a user feel (from the brief, personas and voice answers — e.g. "calm, capable" vs "electric, alive"). Every token choice must be defensible against those words.
3. **Constraints.** Platform conventions (iOS/web), existing brand assets in `context/brand/` (they are law), accessibility needs from the brief, dark mode requirement, performance/motion budget.
4. **Differentiation.** What will make a screenshot of this app recognizable with the logo cropped out? If you cannot answer, you are about to produce a template.

## Ground it in the subject

The product's own world — its materials, instruments, artifacts and vernacular — is where distinctive choices come from. A recipe app can borrow from parchment, enamel pots and handwritten cards; a running app from track surfaces, split timers and race bibs. Before reaching for a generic palette, name three concrete things from the product's world and ask what qualities (texture, contrast, shape language, rhythm) they could lend the interface. Build with the brief's real content throughout — real feature names, real data shapes, real user situations.

## Typography carries the personality

Type does more identity work than any other token. Pair a display and a body face deliberately — not the families you would reach for on any other project:

- A **characterful display face** used with restraint (titles, key numbers, the signature moment).
- A **complementary body face** that stays comfortable at paragraph and label sizes.
- Optionally a **utility/mono face** for data, captions or code.

Set a clear scale with intentional weights, widths and spacing — the type treatment should be memorable on its own, not a neutral delivery vehicle. **Banned as identity fonts: Inter, Roboto, Arial, system-ui, Space Grotesk, Poppins** — fallback stacks only (see `anti-slop.md`). On iOS, San Francisco is acceptable as the body workhorse, but then the display face and the rest of the system must carry the identity.

## Color with conviction

Describe the palette as 4-6 **named** hex values with semantic roles, not a mood of "some blues". Commit: one dominant surface color that sets the temperature, plus one sharp accent, beats five timid mid-saturation tones every time. Encode the palette as tokens (CSS variables / Swift constants) so commitment is enforced mechanically. Design light and dark as two first-class renderings of the same identity — same temperature logic, re-tuned contrast — never an automatic inversion.

## Structure is information

Structural devices — numbering, eyebrows, dividers, section labels — must encode something true about the content, not decorate it. Numbered markers (01/02/03) are only honest when the content is genuinely a sequence. Before adding any structural device, state what information it carries; if the answer is "rhythm", cut it or replace it with spacing.

## Motion: one orchestrated moment

Less motion reads as more considered — scattered hover effects and per-element animations are a hallmark of generated UI. Choose deliberately: either near-none (offer state changes 120-200ms of ease), or ONE orchestrated moment (a page-load stagger, a single signature transition) executed perfectly. Always respect `prefers-reduced-motion` / the platform's Reduce Motion setting. Durations and easings live in the token set, nowhere else.

## Spend your boldness in one place

Pick the single element this app will be remembered by — a signature component, an unexpected type treatment, one wild accent — and let everything around it stay quiet and disciplined. Cut any decoration that does not serve the brief: before shipping a screen, take one look and remove one accessory. Match complexity to the vision — maximalist directions need elaborate execution, minimal directions need precision in spacing, type and detail. Elegance is executing the chosen vision well.

## Copy is design material

Words exist in an interface to make it easier to use. Write from the user's side of the screen: name things by what people control ("notifications", not "webhook config"). Active voice; a control says exactly what happens ("Save changes", not "Submit") and keeps its name through the whole flow. Errors state what happened, why, and the next step — never vague, never over-apologizing. Empty states are invitations to act, not shrugs. Once `docs/design/voice.md` exists, it overrides these generics with the project's own register.

## The quality floor (meet it silently)

Never announce these; never skip them either:

- Responsive down to small screens; no horizontal scroll of the page body.
- Visible keyboard focus states; hit targets ≥ 44pt on touch.
- Text contrast meets WCAG AA in BOTH light and dark.
- Reduced-motion honored; nothing conveys meaning by color alone.
- Real content tested: long names, empty lists, the 3-digit edge cases.

## Two-pass discipline

First **brainstorm** a compact token plan (colors, type roles, layout concept, signature element — one-sentence prose and quick wireframe sketches). Then **critique** that plan against `anti-slop.md` before building: for each part, ask whether you would have produced roughly the same thing for a similar brief about a different product. Where the answer is yes, that part is a default — revise it and note why. Only then write code, deriving every color and type decision from the revised plan. Do the iteration in your thinking; show the user only candidates you would defend.
