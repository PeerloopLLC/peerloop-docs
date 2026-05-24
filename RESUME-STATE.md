# State — Conv 186 (2026-05-24 ~12:20)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 186 was a design-intake + architecture-clarification conv with near-zero code footprint. Built `.scratch/matt-frames-ready-for-dev.md` — a 32-row drift-detection lookup covering all of Matt's "Ready For Dev" frames across 3 pages (Components ✅ 12 sections, α1 Happy Path ✅ 15 frames, Layout ✅ 5 frames), each row pairing a frame node + status banner + "Last Touched" date for on-demand drift checks. Audited the SocialPost subtree (clean), resolved the Course SubNav route shape (mirror `/discover/course/[slug]/[...tab].astro`), and surfaced 7 route-shape sub-assumptions feeding `[MATT-EXEC-FLAGS]`. No code changes; substantive output is the lookup file + 11 new tasks + doc/memory corrections.

## Completed

- [x] [SP-AUDIT] SocialPost subtree audited — clean per `feedback_reuse_existing_components.md`
- [x] [ASSET-SWEEP] Verified zero embedded Figma URLs in `src/` (45 SVGs already harvested permanently)
- [x] [MFRD-DESIGN] Designed drift-detection workflow (status-banner probes + side-effect Material-icon discovery)
- [x] [MFRD-SEED] Seeded `.scratch/matt-frames-ready-for-dev.md` with 32 rows (Components / Happy Path / Layout all ✅ COMPLETE)
- [x] [SUBNAV-PATTERN] Resolved Course SubNav route shape — mirror `/discover/course/[slug]/[...tab].astro`
- [x] [TASK-CLEANUP] Deleted 3 redundant tasks (#10 CMP-EXT-ICN, #16 MATT-CREATOR-TAB, #19 MDR)
- [x] figma-mcp.md + memory mirror corrected — `get_design_context` reclassified selection-free-with-explicit-nodeId

## Remaining

**Lead candidates (Matt design build-out):**
- [ ] [MMP-PH4] [Opus] Phase 4 — re-render Course In Feed (`519:9096`) + visual diff vs Matt's Figma. NOTE: verify whether `Hero Course in Feed` (`502:12911`, lookup row 31) is identical to `519:9096` at kickoff.
- [ ] [MMP-PH3] Parent block — substantially advanced; remaining = dark-hero variants + missing icons
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch + Content/Happy/Home re-render
- [ ] [MATT-EXEC-FLAGS] [Opus] Resolve route-shape assumptions (1 of 7 done). Resolved: Course SubNav = `[...tab].astro`. Pending: Home-variant shape, other page-level SubNavs, non-tab dynamic routes, Enroll route family (rows 9-12), Session lifecycle family (rows 13-15), Home variant family (rows 2,16).
- [ ] [MATT-SUBNAV-ROUTING] Wire SubNav primitives to URL-aware active-state + create `/matt/course/[slug]/[...tab].astro` (VALID_TABS: about/modules/reviews/resources/teachers/creator)
- [ ] [MATT-EXEC-PG2] Phase 5: build remaining /matt/* routes (thin-shell page assembly)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw)
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6
- [ ] [RTB] [Opus] Role Tab Bar design-spec
- [ ] [CMP-ICN-REGISTRY] [Opus] Registry shape deferred to MMP-PH4 empirical re-render
- [ ] [DARK-HERO-VARS] [Opus] Build dark-hero variants of IconLabelChip + Button

**Asset harvest + discipline (Conv 186):**
- [ ] [STARS2-ICN] Harvest stars_2 Material icon (needed by MMP-PH4 Course In Feed)
- [ ] [ACCESSIBILITY-ICN] Harvest accessibility_new Material icon (needed by MMP-PH4)
- [ ] [HOWTOREG-ICN] Harvest how_to_reg Material icon (needed by MMP-PH5 Happy Path home)
- [ ] [VIDEO-COMMENT-ICN] Harvest video_comment Material icon
- [ ] [PLAY-CIRCLE-ICN] Harvest play_circle Material icon
- [ ] [ASSET-SWEEP-GATE] Add Figma-URL grep guard to /w-codecheck
- [ ] [FIGMA-MCP-DOC-HARVEST] Add "asset harvest discipline" section to docs/reference/figma-mcp.md

**Lookup maintenance + graduation (Conv 186):**
- [ ] [MFRD-LOOKUP] Maintain Matt Ready-for-Dev frames drift lookup (permanent task)
- [ ] [MFRD-GRADUATE] Graduate matt-frames-ready-for-dev.md from .scratch/ to docs/reference/ (file substantially complete — 32 rows + 3 page markers)

**Audits + memory (Conv 186):**
- [ ] [MATT-IDX-AUDIT] Audit /matt/index.astro for inline HTML that should use existing primitives (run post-MMP-PH4, pre-MMP-PH5)
- [ ] [ESOT-STRUCTURE] Strengthen feedback_external_source_of_truth_first.md with "probe before claiming structure" rule
- [ ] [BROWSER-FALLBACK] Document Playwright chromium as fallback path when Chrome MCP disconnects
- [ ] [GVD-SELFREE-VERIFY] Confirm get_variable_defs works selection-free with explicit nodeId (only get_design_context exercised this conv)
- [ ] [TXTBTN] Watch for "inline text-styled action button" pattern repeating across Phase 5 routes

**Watch tasks (carrying forward):**
- [ ] [MCP-SEL-MISFIRE] Watch for repeat Figma MCP selection-state proxy misfires (Conv 186 added strong selection-free evidence — revisit reference_figma_mcp_behavior.md)
- [ ] [LH-VERIFY] Verify Figma lineHeight:100 interpretation as ratio 1.0 (load-bearing for MMP-PH4 visual diff)
- [ ] [MEM-CAP-WATCH] Monitor MEMORY.md cap; prune by Conv 190 (was 73% bytes at Conv 186 /r-start)

## TodoWrite Items

All 30 pending tasks (#1-9, 11-15, 17-18, 20-33) are captured in the Remaining section above with mnemonic codes preserved. `[Opus]` suffixes on: #1 MMP-PH4, #4 DARK-HERO-VARS, #9 CMP-ICN-REGISTRY, #11 MATT-EXEC-FLAGS (newly tagged Conv 186), #13 MATT-EXEC-EXT, #18 RTB.

## Key Context

- **`.scratch/matt-frames-ready-for-dev.md` is the conv's primary artifact** (gitignored — survives via scratch, not git history). 32 rows, each = frame node + status banner node + "Last Touched" raw+ISO + App Components. Drift-check workflow + Material-icon side-effect discovery documented in the file header. 3 pages marked ✅ COMPLETE.

- **All 32 frames share `Last Touched: May 20, '26`** — Matt's single batch-promotion review pass. Future drift checks: when N>5 banners flip to a new shared date, that's one Matt session — plan one batch review, not N reviews.

- **4 route families surfaced** (drives [MATT-EXEC-FLAGS] #11): (a) Components singletons, (b) Home variants (`Home /` prefix = home-page states: Feed, Course Completed), (c) Course SubNav tabs (`[...tab].astro` — RESOLVED), (d) Page-prefixed flows = Enroll funnel (Enroll→Success→Choose Teacher→Session Scheduled) + Session lifecycle (Prepare→During→After). Naming convention: `Home /` = variant/state, `Page /` = standalone screen.

- **Course SubNav routing DECIDED**: mirror `/discover/course/[slug]/[...tab].astro` (Astro rest-spread, path-based not query-string, VALID_TABS const, React island History API). Implementation = [MATT-SUBNAV-ROUTING] #31.

- **Name-collision catches**: section frame `Button Primary` (`40:482`) has banner title `Buttons`; user label `Page Template` → Matt's banner `Layout Desktop`. Banner wins per source-of-truth rule. `Hero Course Header` (`517:8934`) maps directly to `CourseHeader.astro` (Conv 184).

- **ControlBar.tsx purpose resolved**: it's the in-session control bar for `Page / Session During` (row 14) — was a code-orphan flagged earlier this conv.

- **Memory correction this conv**: `get_design_context` reclassified from selection-REQUIRED to selection-free-with-explicit-nodeId (11 parallel probes, no Figma desktop selection). figma-mcp.md + memory mirror updated. `get_variable_defs` inferred same-rule but NOT retested → [GVD-SELFREE-VERIFY] #32.

- **No code-repo changes this conv.** Docs repo: RESUME-STATE.md cycle + session files + figma-mcp.md + DECISIONS/DOC-DECISIONS/TIMELINE + PLAN.md + memory mirror.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
