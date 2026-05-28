# Phase 5 — Remaining pages [MATT-EXEC-PG2]

**Status:** 🔥 IN PROGRESS — course-tab family complete (Convs 188–190); Enroll family + Session family + 5 other routes pending
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 Phase 5
**Blocks on:** [MATT-EXEC-CMP] Phase 4.5 (✅ 13/13 primitives — see [phase-4.5-cmp.md](phase-4.5-cmp.md))

---

## Summary

Phase 5 builds the remaining `/matt/*` pages. **Course-tab family decomposed Conv 188** (Decision: Option A — per-tab `.astro` body components rendered by a `tab ===` switch in `[...tab].astro`; `index.astro`/About untouched; shell duplicated across the two route files, accepted, noted for future dedup; later consolidated Conv 190 [RTCONS] — see below).

**All 6 course tabs now built** (Conv 188 [RESTAB] + [TCHTAB]; Conv 189 [CRTTAB] + [RVWTAB] + [MODTAB] + [FEEDTAB]) — the course-tab family is complete.

**Remaining under this parent:**

- **Enroll family** — `/matt/course/[slug]/checkout`
- **Session family** — `/matt/session/[id]/{prepare,room,after}`
- Plus `/matt/`, `/matt/login`, `/matt/teacher/[handle]`, `/matt/teacher/[handle]/schedule`, `/matt/certification/[id]`

Conv 188 triage corrected the Ready-for-Dev lookup (rows 3-8): the course tabs are NEW page-level card composites (SessionCard / ReviewCard / TeacherCard), NOT thin anchor-list shells as the lookup's "expected primitives" guessed; Matt's frames are happy-path instance snapshots (Resources = empty state only).

**Conv 190 shell rewrite ([SBAR-REWRITE], Decision 2):** the `/matt/*` shell now matches Matt's Layout Desktop `81:1483` — grey page bg (`#f8fafc`) + floating white rounded content card, transparent sidebar with always-white active pill, `«` double-chevron collapse, and a role-aware bottom Profile cluster (`src/lib/roles.ts` `describeRoles`; Visitor fallback when logged out). This is shell/assembly work shared by every remaining PG2 page, landed ahead of the Enroll/Session families. (See [phase-2-shell.md](phase-2-shell.md) for shell detail.)

## Course-tab family checklist (✅ COMPLETE)

- [x] **[RESTAB]** ResourcesTab Conv 188 — built Matt's empty state; harvested `folder.svg` (40px Material icon, 42nd Matt icon) normalized to `currentColor`; wired into `[...tab].astro` switch; static (no API). Verified live.
- [x] **[TCHTAB]** TeachersTab Conv 188 — header + bio-card composite reading live D1 via the SSR loader; role-based entity palette (`.entity-creator` purple = Creator / `.entity-student-teacher` blue, reconciling Conv 184's blue claim); Button `variant="student" property1="Small"`; mail icon = `message` (Conv 178 rename); stat chips mapped to real loader data (students_taught / rating_count) not Matt's demo "Courses Created". Verified live. Surfaced + fixed `[ENTITY-CASCADE-BUG]`.
- [x] **[CRTTAB]** CreatorTab Conv 189 — built props-driven (`CreatorTab.astro`) composing UserIcon/EntityPill/Button/IconLabelChip/MattIcon; identity/bio/3 computed stat chips from real loader data. The 4 sections with no schema counterpart (Expertise / Teaching Philosophy / Qualifications / Why-Learn) render Matt's verbatim copy as **static grey** via a `staticContent` prop (no schema change, per user directive — flip flag to restore color when data arrives); `CREATOR_STATIC` constants in the route. Cosmetic fixes: `leading-normal` on wrapping text (works around global `--body-default-line-height: 1`, root-cause deferred to `[LH-VERIFY]`); restored Matt's light-blue quote background. Verified live. (Bottom-spacing folded into `[MATT-COURSE-POLISH]`; mobile → new `[CRS-MOBILE]`.)
- [x] **[RVWTAB]** ReviewsTab Conv 189 — built (`ReviewsTab.astro`) reading the existing `course_reviews` table via a new loader query (not a schema change): per-review rating/body/author/timestamp real; reaction pills static (no reactions table). Reuses UserIcon/MattIcon/IconLabelChip/Button + the extracted `CourseEmbedCard`. Verified live.
- [x] **[MODTAB]** ModulesTab Conv 189 — built (`ModulesTab.astro`) one card per `course_curriculum` row (1:1 per `[MOD-SCHEMA]`); number/title/description/duration all real (titles match Matt verbatim on `intro-to-claude-code`). The "N Modules" sub-count + "posts" pill omitted (no schema source; user chose "omit both"). Verified live.
- [x] **[FEEDTAB]** Course Feed tab Conv 189 — built `MattCourseFeed.tsx` client island fetching the **existing** `GET /api/feeds/course/[slug]` (real Stream-backed activities; same API the legacy `CourseFeed.tsx` uses). Composer + SocialPost list; real posts verified live, no console errors. Frame `480:10833` user-supplied. Extracted `CourseEmbedCard.tsx` (shared embedded-course card) and refactored ReviewsTab to reuse it; added a viewer query + shared `courseEmbed` to the route. All six course sub-tabs now render in `[...tab].astro` (feed/modules/creator/teachers/reviews/resources).

**Conv 190 polish (course-tab family):** fixed two Conv 189 bugs ([COURSE-TAGS-LOADER] JOIN tags + [REVIEW-COUNT] reviews.length); added Matt-sourced SubNav leading icons ([SNV-ICONS]); **consolidated the two course-page routes into one catch-all** ([RTCONS], Decision 1 — `index.astro` deleted, About now the empty-segment `'about'` view, shared `_course-tabs.ts` is the single SubNav-config source for the former two files, eliminating the duplicated-shell drift class). Made the SubNav sticky (`self-start`) + fixed a design-system-wide letter-spacing token bug ([MATT-COURSE-POLISH] — see [phase-1-tokens.md](phase-1-tokens.md)).

## Conv 188 — [MATT-SUBNAV-ROUTING] + course-tab decomposition

- `[MATT-SUBNAV-ROUTING]` COMPLETE. Created `/matt/course/[slug]/[...tab].astro` mirroring `/discover/course/[slug]/[...tab].astro`: `VALID_TABS = ['feed','modules','creator','teachers','reviews','resources']`, invalid → 302 redirect to base, shell (breadcrumb + SubNav + CourseHeader) + per-tab placeholder body. Fixed a latent `SubNav.astro` active-state bug — `startsWith` prefix matching kept the section-index item (About, whose href is a prefix of all tab hrefs) Selected on every child route; replaced with **most-specific-match-wins** (single longest matching href across items+subItems). Routing demonstrated live in the Chrome bridge across all 7 tabs (URL reported per click; `matt-subnav-routing.gif` exported → `.scratch/screenshots/`). Verified via curl: base→About Selected; `/feed`→Feed Selected + About demoted; `/bogus`→302. Gates green. Replaced the deleted `[MATT-CREATOR-TAB]` — Creator is now one of the tabs, not a separate route.

- `[MOD-SCHEMA]` RESOLVED. Matt's Modules frame groups "N Modules" under "1-on-1 Sessions", conflicting with the 1:1 session-module design. User clarified the real product model: every session has exactly one Module; Matt's/creators' nested "Modules" are **Sub-Modules** (term misuse). No session→many-modules data model needed. Saved to memory `project_module_submodule_model.md`; unblocks `[MODTAB]` (build each card as one session/module with an inner "N Sub-Modules" count).

- `[ENTITY-CASCADE-BUG]` FIXED. A role-color "corner dot" reading `var(--Entity-Primary)` rendered gray; live-DOM probe showed the var correct at the element but computed color = `:root` default. Root cause: `tokens-tailwind-bridge.css` declared cascade-driven `--color-entity-primary/background` under plain `@theme`, which resolves the inner `var(--Entity-*)` once at `:root` so utilities ignore the use-site cascade. This had **silently broken EntityPill / EntityLink / UserIcon-initials role colors app-wide** (all rendered the gray default inside `.entity-*` contexts). Fixed by moving the two entity tokens to a new `@theme inline` block (emits the variable reference directly so it re-evaluates at the element). Re-verified on the showcase: pills now resolve Course/Creator/Student backgrounds; role dot purple. Surfaced via the opt-in `roleDot` prop added to `UserIcon.tsx` (enabled in TeachersTab; default off, existing avatars unchanged). **New standing pattern:** cascade-driven Tailwind 4 tokens MUST live in `@theme inline`; static tokens stay in plain `@theme`.

## Conv 190 — course-tab polish + [SBAR-REWRITE]

- `[REVIEW-COUNT]` `[...tab].astro:224` Reviews header passed `data.course.rating_count` (34 — the star-rating denominator) above only 2 rendered review cards; swapped to `data.reviews.length`.
- `[RTCONS]` Consolidated the two course-page routes into one catch-all (Decision 1). Browser verification of `[SNV-ICONS]` found icons rendered on `/feed` etc. but NOT the bare About page — a second `courseTabs` array lived in a separate `index.astro`. First extracted a shared `_course-tabs.ts` (`buildCourseTabs(slug)`, `_`-prefix excludes from routing), then folded About into `[...tab].astro` as the empty-segment `'about'` view (renders body instead of redirecting), added conditional title/breadcrumb, deleted `index.astro`, regenerated `route-map.generated.ts`. Verified all 7 routes + invalid-tab 302 (no loop). Removes the whole "edited one route, forgot the other" drift class + the redirect-loop lock-in.
- `[SBAR-STICKY]` Sidebar aux cluster sticky fix. (Detail in [phase-2-shell.md](phase-2-shell.md).)
- `[MATT-COURSE-POLISH]` SubNav sticky `lg:top-16 lg:self-start` + letter-spacing token fix. (Detail in [phase-1-tokens.md](phase-1-tokens.md).)
- `[SBAR-REWRITE]` Sidebar + shell rewritten to match Matt's Layout Desktop `81:1483`. (Detail in [phase-2-shell.md](phase-2-shell.md).)

## Conv 192 — Phase 5 thin index + doc split

- `[MDS-SPLIT]` Conv 192 — matt-design-system.md (1,717 lines / 145 KB, 6 numbered sections, §5 conflating 3 concerns) split into `docs/as-designed/matt-design-system/` (INDEX.md + 01–07 concern files via `sed` line-range slices + breadcrumb headers; §5 split at line 642/Button into `05-color-and-tokens.md` + `06-component-primitives.md`). Old path → stub pointer with §N→file mapping. **Byte-for-byte lossless** verified. `docs/INDEX.md` line 88 repointed to the folder INDEX. Convention recorded in `DOC-DECISIONS.md §2`. 103 inbound refs (mostly immutable session archives) preserved via the stub at near-zero cost.
- `[MATT-COURSES-INDEX]` New `src/pages/matt/courses.astro` (approach B — thin Matt-native index: Matt AppLayout + SubNav, reuses existing `fetchCourseBrowseData` loader, grid of existing `CourseEmbedCard` whose CTA already targets `/matt/course/[slug]`). Fills the 404 where `/matt/index.astro`'s SubNav linked to `/matt/courses`. Rejected approach A (copy `/discover/courses` + retarget link base — the `/discover/course/${slug}` hrefs are hardcoded in shared `ExploreCard.tsx`/`ExploreCourseTabs.tsx`/role-tab components, so retargeting = forking 5+ production components). DOM-verified: 6 cards, 6 CTAs all `/matt/course/[slug]`, click-through resolves.
- `[LEGACY-SPACING-AUDIT]` Quantified the Conv 174 spacing-bridge blast radius (**3,894** hijacked-step utilities across **354 legacy files** vs **11 `matt/` files** depending on the new meaning) and resolved it: **do-nothing-broad** — leave the override, fix spacing per-component as the legacy→Matt migration reaches each. Stays open as opportunistic per-component reminder, NOT a sweep.

## Open

- [ ] **[MATT-EXEC-PG2]** (TodoWrite #10, [Opus]) — the umbrella; Enroll + Session families + 5 other routes pending.
- [ ] **[SHOWMORE]** Conv 188 — Show-More affordance for Teachers + Reviews tabs. Matt's frames show a "Show More" control; omitted from the Conv 188 TeachersTab build (single bio card shown). Build when populating multi-item states.
- [ ] **[FEED-COMPOSER-USER]** Conv 189 — On `/matt/` the Feed composer shows a "?" avatar / disabled state when logged-out (`canPost` false). Acceptable for the design demo but note for the real auth-aware flow.
- [x] **[SNV-ICONS]** Conv 188 → DONE Conv 190. Probed Matt's course page `419:6162` for SubNav glyphs; mapped through icon catalogue (`feed`/`module`/`resource`/`review`/`student-teacher`/`creator`/`info` extrapolated for About).
- [x] **[MNV-STYLE]** Conv 188 → DONE Conv 190 (then extended by `[SBAR-REWRITE]`). Replaced Sidebar emoji placeholders with MattIcon glyphs.
- [x] **[COURSE-TAGS-LOADER]** Conv 189 → FIXED Conv 190. Added `JOIN tags t ON ct.tag_id = t.id` (`courses.ts:327`). Verified tsc 0 / `tests/ssr/courses.test.ts` 20/20.
- [x] **[CRS-MOBILE]** Conv 189 → DONE Conv 194 (literal scope). At ~500–768px the course SubNav + tabs do NOT overflow/clip/wrap (Chrome on macOS clamps window to ~500px min). Surfaced AppNavbar slide-out panel bleed below lg → fixed as `[MPB]`. Deeper Matt-frame mobile breakpoint work remains under Phase 6.
