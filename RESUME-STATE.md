# State — Conv 190 (2026-05-25 ~09:52)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 190 advanced MATT-DESIGN-PUSH (MATT-EXEC-PG2). Fixed two Conv-189 course-tab bugs, added Matt-sourced SubNav icons, then — driven by live browser review via /chrome — consolidated the two course-page routes into one catch-all, rewrote the Sidebar **and** the AppLayout shell to match Matt's Layout Desktop (81:1483), fixed a design-system-wide letter-spacing token bug, and added a reusable role-display helper. All 5 baseline gates green this conv (test 6453/371). Dev server left running on :4321.

## Completed

- [x] [COURSE-TAGS-LOADER] `courses.ts` JOIN tags (real tag names)
- [x] [REVIEW-COUNT] Reviews header → `reviews.length`
- [x] [SNV-ICONS] course SubNav icons (Matt 419:6162; About=`info` extrapolation)
- [x] [RTCONS] consolidated course routes — deleted `index.astro`, shared `_course-tabs.ts`, About via empty-segment `'about'` view; regenerated route-map
- [x] [MNV-STYLE] sidebar emoji → MattIcon
- [x] [SBAR-STICKY] sidebar viewport-pinned (`lg:sticky lg:h-screen`)
- [x] [MATT-COURSE-POLISH] SubNav sticky (`self-start`) + bottom padding + **letter-spacing token fix** (-2.2px → -0.022em ×4)
- [x] [SBAR-REWRITE] Sidebar + shell to Matt Layout Desktop (grey #f8fafc page + white card, transparent sidebar, « collapse top-right, active white pill, aux descriptions, Profile identity); Logo Small; MainNav gap-24; `roles.ts` (`describeRoles`); UserIcon `size` prop; AppLayout user fetch; harvested `chevrons-left` (43rd icon)

## Remaining

**Sidebar/shell follow-ups (this conv's work):**
- [ ] [MDS-SHELL] doc-sync matt-design-system.md to the SBAR-REWRITE shell (grey-page/white-card, transparent sidebar, active pill, double-chevron collapse, Logo Small, gap-24, Profile cluster)
- [ ] [MATT-PROFILE-VERIFY] visually verify logged-in Profile row (real avatar + name + "Admin + N more") — only Visitor state confirmed this conv; real login needs user-entered password
- [ ] [MEM-ICON-COUNT] MEMORY.md Icon System → 43 SVGs / MattIcon.tsx (chevrons-left added)

**Course-tab polish (held batch):**
- [ ] [CRS-MOBILE] mobile breakpoint for course SubNav + tabs
- [ ] [SHOWMORE] "Show More" expand (Teachers + Reviews + Feed)
- [ ] [ENTITY-VIS-AUDIT] eyeball entity-heavy pages after @theme inline fix
- [ ] [CH-VARIANTS] CourseHeader Enrolled (597:6504) + Scheduled (685:13240)
- [ ] [MATT-ICON-SWAP] hero overlay inline-SVG → icon system

**Bigger Matt blocks:**
- [ ] [MATT-EXEC-PG2] Enroll (rows 9-10), Choose Teacher (11), Session `/matt/session/[id]` (12-15)
- [ ] [MMP-PH5] Phase 5 graduation
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6 extrapolation primitives + CourseInFeed Mobile (502:12958)
- [ ] [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] [MMP-PH3] parent (substantially advanced)
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**Asset harvests (premature until frames deep-probed):**
- [ ] [HOWTOREG-ICN] / [VIDEO-COMMENT-ICN] / [PLAY-CIRCLE-ICN]

**Tooling + docs:**
- [ ] [ASSET-SWEEP-GATE] Figma-URL grep guard in /w-codecheck
- [ ] [FIGMA-MCP-DOC-HARVEST] asset-harvest discipline in figma-mcp.md
- [ ] [MFRD-GRADUATE] graduate matt-frames-ready-for-dev.md to docs/reference/
- [ ] [ESOT-STRUCTURE] "probe before claiming structure" rule
- [ ] [BROWSER-FALLBACK] document Playwright fallback

**Watch / permanent:**
- [ ] [MFRD-LOOKUP] maintain Ready-for-Dev drift lookup (permanent)
- [ ] [TXTBTN] watch inline text-styled action button pattern
- [ ] [LH-VERIFY] verify Figma lineHeight:100 = ratio 1.0
- [ ] [MEM-CAP-WATCH] monitor MEMORY.md cap; prune

## TodoWrite Items

- [ ] #4 [CRS-MOBILE] / #5 [SHOWMORE] / #6 [ENTITY-VIS-AUDIT] / #7 [CH-VARIANTS] / #8 [MATT-ICON-SWAP]
- [ ] #11 [MATT-EXEC-PG2] / #12 [MMP-PH5] / #13 [MATT-EXEC-EXT] [Opus] / #14 [MATT-EXEC-GRD] / #15 [MMP-PH3] / #16 [RTB] [Opus]
- [ ] #17–19 icon harvests / #20–24 tooling+docs / #25 [MEM-ICON-COUNT] / #26–29 watches
- [ ] #33 [MDS-SHELL] / #34 [MATT-PROFILE-VERIFY]

## Key Context

- **Matt shell pattern (NEW this conv):** page bg `#f8fafc` + content is a floating white rounded-20 card with soft shadow; sidebar transparent. The active nav **white pill** only pops because of the grey page — sidebar-only changes won't look right without the shell.
- **`describeRoles(caps)` in `src/lib/roles.ts`:** hierarchy Admin>Creator>Teacher>Moderator>Student (from `UserProfileHeader.tsx`; Student base-only). 1→role, 2→"A, B" (higher first), 3+→"A + N more". Reuse it anywhere a compact multi-role label is needed.
- **`_course-tabs.ts` pattern:** `_`-prefixed route-private helper exports `buildCourseTabs(slug)` — single SubNav-config source shared by the consolidated `[...tab].astro` (About = empty segment). Deleting it / duplicating it is what caused the original icon-drift bug.
- **Figma letterSpacing is %:** `-2.2` = `-0.022em`, NOT `-2.2px`. Token fix applied to body-medium/-medium-bold/-large/-large-medium.
- **`position: sticky` on a flex child needs `self-start`** (else it stretches to row height and can't travel).
- **Login for testing:** `/api/auth/dev-login` is email-only impersonation, but user requires REAL login with user-entered password via /chrome. Test-user passwords last rotated Conv 167 (2026-05-20); value in DECISIONS.md / 2026-05-20 session docs.
- **Dev server running** on :4321 (background) — user kept it for the conv; not killed.
- All changes uncommitted at state-write time; committed in /r-end Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
