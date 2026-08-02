# Aesthetic direction taxonomy

Ten named families with two uses: (1) as options in the onboarding/design interview ("which of these feels right?"), (2) as generation seeds when drafting candidate directions in Phase 3 of `/design`.

Rules of use:

- Fonts listed are **examples that fit the family, not mandates** — pick faces that fit the specific product, and always check them against the banned list in `anti-slop.md`.
- Families can be **remixed** (e.g. "warm editorial structure with a technical mono for data"), but a remix must still land far from the other candidates shown.
- Every family has a **danger** — the cliché version of itself. The two-pass critique exists to catch exactly that.

---

## 1. Minimal / Utilitarian

- **Mood:** precise, quiet, confident, tool-like, invisible-until-needed.
- **Palette logic:** one near-neutral dominant surface (warm OR cool, pick a side — pure #FFF/#000 is a non-choice), ink at high contrast, a single saturated functional accent used only for actions and state. 4 colors can be enough.
- **Type logic:** one excellent grotesque or neo-grotesque doing display AND body through weight/size contrast (e.g. Instrument Sans, Schibsted Grotesk, IBM Plex Sans); optional mono for data (IBM Plex Mono).
- **Suits:** productivity tools, utilities, developer-adjacent products, anything used 50 times a day.
- **Danger:** so restrained it has no identity at all — this family NEEDS its signature element (a distinctive focus ring, a characterful empty state, an unexpected accent hue) or it becomes wireframe.

## 2. Warm Editorial

- **Mood:** literate, calm, crafted, magazine-like, trustworthy.
- **Palette logic:** warm paper-toned surface, deep ink (not pure black), one rich accent drawn from print tradition (oxblood, forest, indigo). Dark mode is "reading at night": warm dark, not slate.
- **Type logic:** a characterful serif display with real presence (Fraunces, Newsreader, Source Serif 4) over a quiet humanist body; generous line-height; type scale does the hierarchy work, not boxes.
- **Suits:** content, journaling, learning, coaching, food, culture — products people read.
- **Danger:** THIS is the family closest to AI-slop look #1 (cream + serif + terracotta). If the draft lands on a cream `#F4F1EA` surface with a terracotta accent, change the temperature or the accent — prove the choice, don't inherit it.

## 3. Bold Brutalist

- **Mood:** loud, raw, honest, poster-like, anti-corporate.
- **Palette logic:** stark high-contrast base (paper white/carbon black) + 1-2 shockingly saturated accents used at full strength; solid blocks, no gradients ever.
- **Type logic:** oversized condensed or black display weights (Archivo Black, Anton, Bricolage Grotesque) set tight; body stays legible and plain; visible borders (2px+) instead of shadows.
- **Suits:** creative tools, music, events, streetwear-adjacent, young audiences, brands with attitude.
- **Danger:** unusable in daily-driver apps if every screen shouts. Keep brutalism in the display layer (titles, headers, empty states) and make forms/lists calmly usable.

## 4. Playful Rounded

- **Mood:** friendly, optimistic, bouncy, approachable, forgiving.
- **Palette logic:** light cheerful surface, 3-4 saturated candy hues with clear role separation, soft shadows; dark mode stays playful (deep blue-purple night, not gray).
- **Type logic:** rounded or geometric sans with personality (Baloo 2, Fredoka, Gantari, Quicksand for display; a sturdier sans for body so it doesn't get mushy).
- **Suits:** habit trackers, family/kids products, social, health encouragement, anything fighting user guilt.
- **Danger:** toy syndrome — all-rounded-everything with confetti reads as childish and imprecise. Anchor it with disciplined spacing and one grown-up structural element (sharp data table, precise numerals).

## 5. Luxury Dark

- **Mood:** reserved, precious, dense-with-restraint, after-dark, expensive.
- **Palette logic:** near-black dominant with warmth (espresso, ink-navy, charcoal-green — never flat #000), ivory/champagne text, one metallic or jewel accent used sparingly (gold, oxidized bronze, deep emerald). Light mode is the inversion challenge: warm gallery white, same jewel accent.
- **Type logic:** high-contrast serif or refined display face (Cormorant, Marcellus, EB Garamond) for titles, tracked-out small caps for labels, understated sans body (e.g. Jost, Figtree).
- **Suits:** finance, wine/spirits, jewelry, private clubs, premium services, portfolios.
- **Danger:** AI-slop look #2 lives next door (near-black + acid green). Keep accents precious-metal or jewel-toned, never neon; keep contrast AA-legible — luxury is not gray-on-black.

## 6. Retro-Future

- **Mood:** nostalgic-technical, CRT-meets-spaceship, optimistic past-vision-of-future.
- **Palette logic:** either warm 70s-terminal (amber/green phosphor on deep brown-black) or 80s-console (off-white hardware beige + one signal orange/red); scanline/grain texture as an option, used once.
- **Type logic:** a mono or semi-mono doing real work (DM Mono, Space Mono as utility, Chivo Mono) + a wide techno display used very sparingly (Michroma, Unica One); avoid full-on sci-fi cliché faces.
- **Suits:** dev tools, games, audio/synth apps, communities with in-jokes, products that celebrate computing.
- **Danger:** legibility sacrificed to theme (glow effects, low-contrast phosphor). The theme lives in surfaces and accents; body text stays crisp. Also: this is a costume — confirm the audience is in on it.

## 7. Neo-Nature / Organic

- **Mood:** grounded, breathing, tactile, seasonal, humane.
- **Palette logic:** earth-derived but modern — sage, clay, moss, sand — with one vivid botanical accent (poppy, marigold); surfaces slightly textured or gradient-shifted like daylight; dark mode is dusk, not black.
- **Type logic:** a soft-serif or humanist display with organic curves (Fraunces soft axis, Gelasio, Cabinet Grotesk) + warm sans body; occasional hand-drawn or irregular element as the signature.
- **Suits:** wellness, gardening, outdoors, sustainability, mindfulness, food-growing.
- **Danger:** the greenwash template (sage + beige + leaf icon) is its slop form. Earn it: pull the palette from the product's ACTUAL subject (the specific plant, mineral, season), not from "nature" in the abstract.

## 8. Technical / Data-Dense

- **Mood:** instrumental, exact, high-signal, cockpit, trust-through-precision.
- **Palette logic:** neutral engineered surface (cool gray or blueprint blue-gray), restrained ink, a strict functional color code (ok/warn/error/info) that is used for MEANING only — decoration never borrows semantic colors.
- **Type logic:** tabular-figure sans (IBM Plex Sans, Archivo) + a serious mono for numbers and code (JetBrains Mono, IBM Plex Mono); small sizes with generous letter-spacing for labels; density from tight line-height, not tiny fonts.
- **Suits:** dashboards, finance pro tools, monitoring, logistics, analytics-heavy products, power users.
- **Danger:** density without hierarchy = wall of numbers. Establish 2-3 zoom levels (overview number → grouped panel → raw table) and one calm focal metric per screen.

## 9. Soft Neumorphic-Lite

- **Mood:** tactile, cushioned, physical, calm, device-like.
- **Palette logic:** one mid-light tinted surface family (the tint IS the identity — pick a hue, not gray) with elements extruded from it via paired light/dark soft shadows; one saturated accent for primary actions; dark mode uses deep tinted surfaces with subtle glow edges.
- **Type logic:** rounded-geometric sans (Sora, Manrope, Gantari) with strong weight contrast; numerals matter (dials, counters) — pick a face with good ones.
- **Suits:** smart-home, audio controls, timers, health devices, single-purpose "appliance" apps.
- **Danger:** classic neumorphism fails accessibility (insufficient contrast between element and surface). "Lite" means: soft shadows for RESTING states only, but real borders/contrast for interactive and focused states. Test contrast first.

## 10. Agent's Wildcard

- **Mood:** whatever THIS product's world actually looks like — derived, not chosen from a menu.
- **How it works:** ignore the taxonomy. Go back to the product's subject matter (Phase 1 inputs) and pull the direction from its real-world materials, instruments and vernacular: a climbing app from rope, rock texture and carabiner steel; an invoicing app from carbon-copy paper and rubber stamps; a stargazing app from star charts and observatory brass. Name 3 concrete artifacts from the product's world, extract palette + type + signature from them.
- **Suits:** any product with a strong physical or cultural world; users bored by every option above; briefs that say "surprise me".
- **Danger:** theme-park kitsch — copying artifacts literally instead of abstracting them. Extract the QUALITIES (texture, contrast, shape language) and rebuild them as a modern token system. This family MUST still pass the full anti-slop checklist; "creative" is not an exemption.
