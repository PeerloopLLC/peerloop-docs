# State — Conv 199 (2026-05-26 ~16:37)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Closed out the **MATT-CUTOVER tail + provenance detection** cluster. Confirmed `[NAV-APP-A]` mooted by the route flip; built the thin half of `[PROV-SWEEP]` (validator `scripts/prov-sweep.ts` + candidate registry `scripts/prov-candidates.ts` + `npm run prov:sweep`); ran `[PROV-MATCH]` live against Matt's Figma — **no collisions** (RoleTabBar not drawn; two name-matches were node-type false positives). Then continued closing similar work: `[RA-STALE]` (doc), `[MCFRAME]` (memory fold-in), `[PLAY-CIRCLE-ICN]` (harvested + wired). Two grab-bag items honestly **re-scoped, not closed**: `[ICN-NS]` (204-file legacy→MattIcon migration) and `[HOWTOREG-ICN]` (gated on Phase-5 build).

## Completed

- [x] [NAV-APP-A] confirmed mooted by route flip (AppNavbar renders only at `/old/*`)
- [x] [PROV-SWEEP] built thin validator + candidate registry + npm script + matt-provenance.md §6a
- [x] [PROV-MATCH] ran live Figma probe — no collisions, recorded matt-provenance.md §10
- [x] [RA-STALE] dropped removed MoreSlidePanel from role-audit-2026-04-15.md
- [x] [MCFRAME] folded "don't MC-question when user steers with specifics" into feedback_conversational_brevity memory
- [x] [PLAY-CIRCLE-ICN] harvested play_circle (matt-embedded, 319:10972) + wired into VideoClipAnchor + _INDEX.md

## Remaining

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus]
- [ ] [RTB] Role Tab Bar design [Opus] — NOTE: confirmed NOT yet drawn by Matt (PROV-MATCH); greenfield for us
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus]
- [ ] [MMP-PH5] roll-forward 11 Phase-5 pages
- [ ] [MATT-EXEC-GRD] graduation
- [ ] [MMP-PH3] verify status
- [ ] [SHOWMORE] Show-more behavior
- [ ] [CH-VARIANTS] Card/component variants

**Re-scoped this conv (larger/blocked than grab-bag framing):**
- [ ] [ICN-NS] Legacy→MattIcon convergence — 204 non-/old files still import legacy icons.tsx/Icon.astro [Opus]. Namespace dissolve IS done; this is the icon-SYSTEM migration. Legacy icon files die with /old retirement; open Q is migrate-now vs ride.
- [ ] [HOWTOREG-ICN] Harvest how_to_reg — BLOCKED: not in live Components file UpDNMiIEO8y3J7ZHkm356b, not name-findable in .scratch exports, no code usage yet. Needs Happy Path Figma file key OR defer to Phase-5 build (harvest per-encounter).

**Infra / tooling / watches:**
- [ ] [ASSET-SWEEP-GATE] asset sweep gate / [FIGMA-MCP-DOC-HARVEST] — these two gate the deferred PROV-MATCH automation (tracked in PLAN as [PROV-MATCH-AUTO]: filter section-type nodes out of the candidate pool)
- [ ] [MFRD-LOOKUP] permanent Ready-for-Dev drift lookup maintenance
- [ ] [ESOT-STRUCTURE] external source-of-truth structure
- [ ] [BROWSER-FALLBACK] document Playwright chromium fallback when Chrome MCP disconnects
- [ ] [TXTBTN] watch for inline text-styled action button across Phase 5 routes
- [ ] [MEM-CAP-WATCH] MEMORY.md at byte cap — re-confirm; grew slightly this conv (MCFRAME marker added)

## TodoWrite Items

- [ ] #3 [DISC-UNIFY] [Opus] / #4 [MATT-EXEC-PG2] [Opus] / #5 [MATT-EXEC-EXT] [Opus] / #6 [RTB] [Opus] / #7 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #8 [MMP-PH5] / #9 [MATT-EXEC-GRD] / #10 [MMP-PH3] / #11 [SHOWMORE] / #12 [CH-VARIANTS]
- [ ] #13 [ICN-NS] [Opus] / #14 [HOWTOREG-ICN]
- [ ] #16 [ASSET-SWEEP-GATE] / #17 [FIGMA-MCP-DOC-HARVEST] / #18 [MFRD-LOOKUP] / #19 [ESOT-STRUCTURE] / #20 [BROWSER-FALLBACK] / #21 [TXTBTN] / #23 [MEM-CAP-WATCH]

## Key Context

- **Provenance tooling is live.** `npm run prov:sweep` (= `tsx scripts/prov-sweep.ts`) validates provenance bookkeeping + emits the collision-candidate manifest. Candidate registry is `scripts/prov-candidates.ts` (component+token; hand-maintained — add Phase-6 extrapolations here as they land). Icon candidates live in `src/components/icons/icon-provenance.ts` (`source:'ours'`). Marker accept-rule: `@matt-source` + node-shaped ref (`\d+:\d+`). Both files are in `scripts/`, outside tsconfig `include` — they don't touch the type-check gate.
- **PROV-MATCH result (Conv 199):** no collisions. Every unmarked primitive stays ours. Section-type nodes are false-positive sources — the deferred automation ([PROV-MATCH-AUTO] in PLAN) must filter `<section>`/status-component nodes out of the candidate pool.
- **Matt's live Figma** = file `UpDNMiIEO8y3J7ZHkm356b`, only Cover (151:2561) + Components (1:269) pages. Happy Path designs are NOT in this file (exist as `.scratch/matt-main/happy-path/` exports). Auth: Dev seat on Peerloop Pro team (sufficient for reads).
- **Icon harvest pattern (read-only):** `get_design_context` on the node → curl the asset URL → raw SVG → perl-normalize `var(--fill-0, white)`→`currentColor` (mask `<rect>` stays `#D9D9D9`), fix `<svg>` to `width/height/viewBox`. MattIcon name type auto-derives from the `./svg/*.svg` glob — dropping a file in registers it.
- **Verification this conv:** `tsc --noEmit` exits 0. Full 5-gate baseline NOT run (scripts/ outside type-check scope; only VideoClipAnchor.tsx + icon-provenance.ts in app scope, both tsc-clean). play-circle.svg uses the same mask pattern as accessibility-new.svg (renders fine, not browser-verified).
- Code branch `jfg-dev-13-matt`. This conv's changes committed in Step 6 (both repos).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
