# State — Conv 189 (2026-05-24 ~20:54)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 189 completed the `/matt/course/[slug]` SubNav tab family under MATT-EXEC-PG2: built **CreatorTab** (static-grey unbacked sections per user directive), **ReviewsTab** (real `course_reviews` via a new loader query + static reaction pills), **ModulesTab** (1:1 session cards from `course_curriculum`), and the **Course Feed** tab (client island reusing the existing `/api/feeds/course/[slug]`). Extracted a shared `CourseEmbedCard` and refactored ReviewsTab to use it. All six course sub-tabs (feed/modules/creator/teachers/reviews/resources) now render in `[...tab].astro`. All five gates were green (test 6453 pass at the Reviews loader change; later tabs additive).

## Completed

- [x] [CRTTAB] CreatorTab — `staticContent` grey treatment for Expertise/Philosophy/Qualifications/Why-Learn; cosmetic fixes (leading-normal, light-blue quote)
- [x] [RVWTAB] ReviewsTab — real `course_reviews` (loader query added); reaction pills static
- [x] [MODTAB] ModulesTab — 1:1 session cards; sub-count + posts pill omitted
- [x] [FEEDTAB] Course Feed — client island on existing `/api/feeds/course/[slug]`; composer + SocialPost list
- [x] Extracted `CourseEmbedCard.tsx`; refactored ReviewsTab to reuse it
- [x] All six course sub-tabs handled in `[...tab].astro`

## Remaining

**Course-tab polish (held cross-cutting batch):**
- [ ] [SNV-ICONS] Add leading icons to course SubNav items (mapping in prior state)
- [ ] [MNV-STYLE] Match Sidebar/MainNav icons + type to Matt
- [ ] [MATT-COURSE-POLISH] Body polish incl. bottom spacing under content/SubNav
- [ ] [CRS-MOBILE] Mobile breakpoint for course SubNav + tab layout (all tabs cram at 390px)
- [ ] [SHOWMORE] "Show More" expand affordance (Teachers + Reviews + Feed)
- [ ] [ENTITY-VIS-AUDIT] Eyeball entity-heavy pages after the @theme inline fix
- [ ] [CH-VARIANTS] CourseHeader Enrolled (597:6504) + Scheduled (685:13240)
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon system

**Bug-fixes surfaced this conv:**
- [ ] [COURSE-TAGS-LOADER] `course_tags` query typed `{tag_id,name}` but `SELECT *` returns no `name`
- [ ] [REVIEW-COUNT] Reviews header `rating_count` (34) vs rendered rows (2) — switch to `reviews.length` or fix counter

**Bigger Matt blocks:**
- [ ] [MATT-EXEC-PG2] parent — course tabs done; Enroll (rows 9-10), Choose Teacher (11), Session `/matt/session/[id]` (12-15) remain
- [ ] [MMP-PH5] Phase 5 graduation
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6 extrapolation primitives + CourseInFeed Mobile (502:12958)
- [ ] [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] [MMP-PH3] parent (substantially advanced)
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**Asset harvests (premature until frames deep-probed):**
- [ ] [HOWTOREG-ICN] / [VIDEO-COMMENT-ICN] / [PLAY-CIRCLE-ICN]

**Tooling + docs:**
- [ ] [ASSET-SWEEP-GATE] Figma-URL grep guard in /w-codecheck
- [ ] [FIGMA-MCP-DOC-HARVEST] asset-harvest discipline section in figma-mcp.md
- [ ] [MFRD-GRADUATE] graduate matt-frames-ready-for-dev.md to docs/reference/
- [ ] [ESOT-STRUCTURE] "probe before claiming structure" rule
- [ ] [BROWSER-FALLBACK] document Playwright fallback
- [ ] [MEM-ICON-COUNT] MEMORY.md Icon System: 42 SVGs / MattIcon.tsx (was 39/.astro)

**Watch / permanent:**
- [ ] [MFRD-LOOKUP] maintain Ready-for-Dev drift lookup (permanent)
- [ ] [TXTBTN] watch inline text-styled action button pattern
- [ ] [LH-VERIFY] verify Figma lineHeight:100 = ratio 1.0 — **now has visible evidence** (`--body-default-line-height: 1` cramps wrapped copy)
- [ ] [MEM-CAP-WATCH] monitor MEMORY.md cap; prune by Conv 190

## TodoWrite Items

- [ ] #4 [SHOWMORE] / #5 [SNV-ICONS] / #6 [MNV-STYLE] / #7 [ENTITY-VIS-AUDIT] / #8 [MATT-COURSE-POLISH] / #9 [CH-VARIANTS] / #10 [MATT-ICON-SWAP]
- [ ] #11 [MATT-EXEC-PG2] / #12 [MMP-PH5] / #13 [MATT-EXEC-EXT] [Opus] / #14 [MATT-EXEC-GRD] / #15 [MMP-PH3] / #16 [RTB] [Opus]
- [ ] #17–19 icon harvests / #20–26 tooling+docs / #27–29 watches / #30 [CRS-MOBILE]
- [ ] #32 [COURSE-TAGS-LOADER] / #33 [REVIEW-COUNT]

## Key Context

- **Four data verdicts, one per tab:** CreatorTab = static grey (no schema; `CREATOR_STATIC` consts in route, `staticContent` prop); Reviews = real `course_reviews` (loader `reviews` field); Modules = real `course_curriculum` 1:1; Feed = real via existing `/api/feeds/course/[slug]` client island.
- **`staticContent` grey-provenance pattern:** unbacked sections render grey; flip the flag to restore color when data arrives.
- **`CourseEmbedCard.tsx`** is the shared embedded-course card (Reviews + Feed); distinct from CourseAnchor (no pill, stacked metadata).
- **Test course note:** use `intro-to-claude-code` for Matt-fidelity (clean 1:1 curriculum, titles match Matt verbatim); `ai-tools-overview` has 2 seeded reviews + rougher curriculum seed.
- **All 5 gates green** at the Reviews loader change (test 6453/371 files). Later tab additions (Modules/Feed components + route) are additive; test not re-run for those.
- **Branch `jfg-dev-13-matt`** retained. Nothing was pushed mid-conv; the `/r-end` commit carries all of it.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
