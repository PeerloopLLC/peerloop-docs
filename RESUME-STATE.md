# State — Conv 192 (2026-05-25 ~14:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Demo-prep continuation. Fixed two instances of the Conv 174 spacing-bridge hijack in place (home-page footer + dashboard main-panel icons → arbitrary `[Npx]`), quantified the broad hijack (3,894 utils / 354 legacy files vs 11 matt files) and decided to **leave it** — legacy gets migrated onto Matt incrementally, fixed per-component. Split the 1,717-line `matt-design-system.md` into a `matt-design-system/` folder (INDEX + 7 concern files, byte-lossless, stub at old path) and recorded the convention in `DOC-DECISIONS.md`. Built `/matt/courses` (approach B — thin Matt-native index reusing the `fetchCourseBrowseData` loader + `CourseEmbedCard` grid) to bridge into the `/matt/course/[slug]` family. All gates green where run; commits land in /r-end Step 6.

## Completed

- [x] Home footer padding fixed (`Footer.astro`, both variants, hijacked utils → arbitrary px)
- [x] Dashboard main-panel icons fixed (`index.astro` `h-12 w-12` containers + clock → `h-[48px]`)
- [x] [LEGACY-SPACING-AUDIT] quantified + decision to do nothing broad (fix per-component)
- [x] Matt design/style doc-update check — [CH-DOCSYNC] confirmed already done
- [x] [MDS-SPLIT] matt-design-system.md → folder (INDEX + 01–07), byte-lossless, stub + docs/INDEX.md repointed
- [x] DOC-DECISIONS.md §2 doc-split convention entry
- [x] [MATT-COURSES-INDEX] /matt/courses built (approach B), DOM-verified
- [x] Regenerated route maps (page-connections / route-api-map / route-map.generated.ts) for /matt/courses

## Remaining

**New this conv:**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (add primary_topic_id to loader first) [Opus]
- [ ] [URLDOC-MATT] Backfill /matt/* routes into url-routing.md (pre-existing gap)
- [ ] [MATT-SUBNAV-STUBS] Build/stub remaining Matt SubNav targets (/matt/saved, /matt/teachers, /matt/todo — 404 like /matt/courses was)

**NAV-RETROFIT (live block):**
- [ ] [NAV-ICON-SWAP] / [NAV-SIBLINGS] / [LEGACY-SPACING-AUDIT] (per-component now) / [NAV-APP-A] / [VTPRD]

**Course-tab polish:**
- [ ] [CRS-MOBILE] / [SHOWMORE] / [ENTITY-VIS-AUDIT] / [CH-VARIANTS] / [MATT-ICON-SWAP]

**Bigger Matt blocks:**
- [ ] [MATT-EXEC-PG2] / [MMP-PH5] (blocked MacMiniM4) / [MATT-EXEC-EXT] [Opus] / [MATT-EXEC-GRD] / [MMP-PH3] / [RTB] [Opus]

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-GRADUATE] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [MFRD-LOOKUP] / [TXTBTN] / [LH-VERIFY] / [MEM-CAP-WATCH]

## TodoWrite Items

- [ ] #1 [NAV-ICON-SWAP] / #2 [NAV-SIBLINGS] / #3 [LEGACY-SPACING-AUDIT] / #4 [NAV-APP-A] / #5 [VTPRD]
- [ ] #6 [CRS-MOBILE] / #7 [SHOWMORE] / #8 [ENTITY-VIS-AUDIT] / #9 [CH-VARIANTS] / #10 [MATT-ICON-SWAP]
- [ ] #11 [MATT-EXEC-PG2] / #12 [MMP-PH5] (blocked) / #13 [MATT-EXEC-EXT] [Opus] / #14 [MATT-EXEC-GRD] / #15 [MMP-PH3] / #16 [RTB] [Opus]
- [ ] #17 [HOWTOREG-ICN] / #18 [PLAY-CIRCLE-ICN] / #19 [ASSET-SWEEP-GATE] / #20 [FIGMA-MCP-DOC-HARVEST] / #21 [MFRD-GRADUATE] / #22 [ESOT-STRUCTURE] / #23 [BROWSER-FALLBACK] / #24 [MFRD-LOOKUP] / #25 [TXTBTN] / #26 [LH-VERIFY] / #27 [MEM-CAP-WATCH]
- [ ] #29 [DISC-UNIFY] [Opus] / #30 [URLDOC-MATT] / #31 [MATT-SUBNAV-STUBS]

## Key Context

- **Spacing-bridge decision (Conv 192):** Do NOT revert the `--spacing-*` override (would break /matt) and do NOT mass-convert legacy. 3,894 hijacked utils / 354 legacy files vs 11 matt files. Fix per-component with arbitrary `[Npx]` as legacy→Matt migration reaches each. Recorded in DECISIONS.md (appended to Conv 191 entry).
- **Doc-split pattern (Conv 192):** oversized as-designed spec → folder (INDEX + concern files) + stub-with-§N-mapping at old path. Recorded DOC-DECISIONS.md §2. matt-design-system.md is now a 20-line stub; real content in `docs/as-designed/matt-design-system/`.
- **/matt/courses:** reuses `fetchCourseBrowseData` loader + `CourseEmbedCard` (CTA → /matt/course/[slug]). No shared discover components forked. [DISC-UNIFY] = make /discover/courses share the loader too (needs primary_topic_id added).
- **Matt SubNav links to 404s:** /matt/saved, /matt/teachers, /matt/todo (tracked [MATT-SUBNAV-STUBS]). matt/index SubNav is a preview stub.
- Dev server + Chrome bridge were left running on :4321.
- Commits land in /r-end Step 6 (this state written pre-commit).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
