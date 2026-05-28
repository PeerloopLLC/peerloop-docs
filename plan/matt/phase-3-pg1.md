# Phase 3 — First page [MATT-EXEC-PG1]

**Status:** ✅ COMPLETE (Conv 175)
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 Phase 3
**Page:** `/matt/course/[slug]` (now `/course/[slug]` post-Conv 197 [ROUTE-FLIP], see [cutover.md](cutover.md))

---

## Summary

First `/matt/course/[slug]` page end-to-end. Built `src/components/matt/entity/CourseHeader.astro` (dark image hero with gradient overlay; iterated to 2-column layout: LEFT title + tagline + metadata row creator/rating/level; RIGHT ✓-includes list + "$X • Enroll Now ›" pill; top-right overlay back-chevron + book glyph; min-height 240px via inline style — see `[TWLG-MIN-H]`) and `src/pages/matt/course/[slug]/index.astro` (thin page using existing `fetchCourseTabData` loader; AppLayout `entity=course`; SubNav 7 course tabs: About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources; About body with 4 Cards: About / What you'll learn (2-col objectives) / Prerequisites / Who this is for).

HTTP 200, astro check clean. Visual diff iteration vs Matt's `Course.svg` complete.

## Conv 175 — strategic decisions captured

- **Phase 4 scope A: ship Button + Card + SectionTitle + retrofit, defer 5 primitives** — highest-leverage primitives (used everywhere) shipped first; retrofitting existing CourseHeader CTA and About body produces immediate visible improvement. Remaining 5 primitives are dep'd on Phase 5 pages. (See [phase-4-prm.md](phase-4-prm.md).)
- **"What's included" lives in the CourseHeader hero overlay, not the About body** — matches Matt's design; hero is the conversion-density block. CourseHeader takes `includes` prop; body now has 4 Cards (About / What you'll learn / Prerequisites / Who this is for) instead of 5.
- **"Meet the Creator" is a SubNav tab, not an About body section** — matches Matt's design. Creator-tab route deferred to Phase 5 as `[MATT-CREATOR-TAB]` (later replaced by `[MATT-SUBNAV-ROUTING]` Conv 186; Creator became one of 6 tabs in `VALID_TABS`). Course-page SubNav now: About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources.

## Conv 175 — patterns established

- **Matt-page assembly pattern** — thin page (<100 lines) composing `AppLayout(entity=course) → CourseHeader → SubNav → body Cards with SectionTitle headings`. First instance at `src/pages/matt/course/[slug]/index.astro`; follow this shape for future `/matt/*` pages.
- **Visual-diff symlink pattern** — `public/_matt-ref/` (gitignored or removed pre-commit) symlinks Matt's Figma SVG exports so chrome can fetch them for side-by-side diff. Use BEFORE building, not after. Pre-plan §9 visual-validation gate has to fire BEFORE the structural build, not after (Conv 175 learning: built Phase 3 + Phase 4 entirely against pre-plan prose without opening Matt's SVG; visual was far off; mid-conv pivot to symlink-diff worked but should have been Step 1).

## Conv 187 — CourseHeader re-validated to Matt's Default frame (reverses Conv 184/185 creator trio)

Probed `517:8935` (Default variant of 3-variant set `517:8934`) → found `CourseHeader.astro` had drifted. Matt shows all metadata as plain WHITE IconLabelChips over the dark image, NOT the UserIcon + EntityPill + EntityLink creator trio Convs 184/185 built. Rewrote `CourseHeader.astro` → `CourseHeader.tsx` to match Matt (white on-dark IconLabelChip ×4, course Button CTA, Primary-Light back button, added missing student count). User confirmed ("B" — keep the reversal). The trio still belongs in the future "Meet the Creator" tab. (External-source-of-truth + C178-REVAL precedent.)

## Open

- [ ] **[MATT-COURSE-POLISH]** Conv 175 — Body section visual polish — user noted "items in front of the page need work" after hero refinement landed. Course page body Cards (About / What you'll learn / Prerequisites / Who this is for) need typography/spacing/visual tuning to match Matt's `Course About.svg`. (Partially addressed Conv 190 — see [phase-5-pg2.md](phase-5-pg2.md).)
- [ ] **[TWLG-MIN-H]** Conv 175 — Tailwind 4 arbitrary-value `min-h-[480px]` (and later `min-h-[240px]`) didn't take effect on `CourseHeader.astro` despite the class appearing in rendered HTML — Tailwind didn't generate the CSS rule. Workaround: inline `style="min-height: 240px"` in the bgStyle string. Suspect interaction with Conv 174 `--spacing-*` global override (the override may affect Tailwind 4's arbitrary-value parsing for height-axis utilities). Root cause + fix is a `[TSV]` follow-up — when bundling all breakpoint/spacing discrepancies together, audit arbitrary-value behavior too.
- [x] **[MATT-ICON-SWAP]** Conv 194 — DONE on the inline-SVG goal. The original target (`CourseHeader.astro` inline-SVG paths) no longer exists — the file became `CourseHeader.tsx`, which has 0 inline SVGs and uses full MattIcon; the live `CourseHero.tsx` also has 0 inline SVGs (uses `@components/ui/icons` React primitives). Residual: the live hero is still on the legacy icon set, not MattIcon → folded into [MATT-EXEC-EXT] (Phase 6) as the live-hero→MattIcon migration. (See [phase-6-ext.md](phase-6-ext.md).)
- [x] **[MATT-CREATOR-TAB]** Conv 186 — REPLACED by `[MATT-SUBNAV-ROUTING]`. Course SubNav routing pattern resolved as `/matt/course/[slug]/[...tab].astro` mirroring existing `/discover/course/[slug]/[...tab].astro` — Creator is now one of 6 tabs in `VALID_TABS = ['about','modules','reviews','resources','teachers','creator']`, not a separate route. (See [phase-5-pg2.md](phase-5-pg2.md).)
