# State — Conv 198 (2026-05-26 ~15:51)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Pure docs conv: completed the **post-flip doc-reconciliation batch** (#25–28) left over from Conv 197's [ROUTE-FLIP]. Reconciled stale `/matt/*` path and route refs across four docs — url-routing.md, DEVELOPMENT-GUIDE.md, the matt-design-system/ folder (6 files), and matt-frames-ready-for-dev.md. Key framing decision (user chose **Option B**): keep canonical content intact and confine churn to status banners + status tables rather than mass-rewriting every reference. Code repo untouched. All four docs verified free of stale code-path/route refs this conv.

## Completed

- [x] [URLDOC-RECONCILE] (#25) — url-routing.md: §§1–7 kept as canonical URL design + post-flip status banner at § Route Categories; file tree rewritten to real post-flip layout; Implementation-Status `/matt/*` row → root/legacy split; §8 note softened; References entries added
- [x] [DEVGUIDE-MATT-RECONCILE] (#26) — DEVELOPMENT-GUIDE.md: ~20 `components/matt/X`→`components/X` etc. path/route/import refs fixed; namespace prose updated; verified `matchHref` + component locations before editing
- [x] [MDS-MATT-RECONCILE] (#27) — matt-design-system/ folder: INDEX.md post-flip banner; concrete code-path + route/behavior refs fixed across 01/02/03/05/06; 03 got a Conv-190 supersession pointer (resolved a contradiction with DEVGUIDE); 05 cross-ref repointed to renamed heading
- [x] [MFRD-MATT-PATHS] (#28) — matt-frames-ready-for-dev.md: bulk path/route promotion out of matt/ + prose stragglers + post-flip Status note

## Remaining

**MATT-CUTOVER tail:**
- [ ] [PROV-SWEEP] Collision-detection sweep [Opus] — greps @matt-source + enumerates unmarked primitives, probes Matt's Figma for name-matches. Anchor on `@matt-source` at comment-line-start. Can import `icon-provenance.ts` directly.
- [ ] [NAV-APP-A] AppNavbar→Matt Sidebar swap [Opus] — LIKELY MOOTED by the flip (root already uses Matt's Sidebar via canonical AppLayout; AppNavbar now serves only /old). Confirm + close. NAV-RETROFIT likewise superseded.

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus] — stays UNMARKED (=ours) by design
- [ ] [RTB] Role Tab Bar design [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus] — likely middleware guard
- [ ] [MMP-PH5] roll-forward 11 Phase-5 pages / [MATT-EXEC-GRD] graduation / [MMP-PH3] verify status
- [ ] [SHOWMORE] / [CH-VARIANTS] / [ICN-NS] (icon namespacing — namespace now dissolved, re-scope)

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MCFRAME]
- [ ] [MEM-CAP-WATCH] MEMORY.md at 81% byte cap (re-confirmed Conv 198: 129/200 lines, 20745/25600 bytes)
- [ ] [RA-STALE] Drop MoreSlidePanel from role-audit-2026-04-15.md on next refresh

## TodoWrite Items

- [ ] #1 [PROV-SWEEP] [Opus] / #2 [NAV-APP-A] [Opus] (mooted?) / #3 [MATT-EXEC-PG2] [Opus] / #4 [MATT-EXEC-EXT] [Opus] / #5 [RTB] [Opus] / #6 [DISC-UNIFY] [Opus] / #7 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #8 [MMP-PH5] / #9 [MATT-EXEC-GRD] / #10 [MMP-PH3] / #11 [SHOWMORE] / #12 [CH-VARIANTS] / #13 [ICN-NS]
- [ ] #14 [HOWTOREG-ICN] / #15 [PLAY-CIRCLE-ICN] / #16 [ASSET-SWEEP-GATE] / #17 [FIGMA-MCP-DOC-HARVEST] / #18 [MFRD-LOOKUP] / #19 [ESOT-STRUCTURE] / #20 [BROWSER-FALLBACK] / #21 [TXTBTN] / #22 [MCFRAME]
- [ ] #23 [MEM-CAP-WATCH] / #24 [RA-STALE]

## Key Context

- **Post-flip doc state is now clean.** All four reconciliation docs verified free of stale `components/matt`/`layouts/matt`/`pages/matt`/`@components/matt`/`/matt/<route>` refs this conv. Remaining `matt` strings are legitimate: doc-file names (`matt-provenance.md`, `matt-pre-plan.md`, `matt-design-system.md`), the "Matt" designer, the `data-matt` JSX attribute, and intentional historical-context notes ("promoted from `components/matt/icons/`", post-flip banners).
- **DECISIONS.md + matt-pre-plan.md remain historical** (NOT rewritten) — append-only decision log + execution plan; their `/matt/*` refs are correct as dated record.
- **Auto-generated route docs** (page-connections.md, route-api-map.md) were already regenerated Conv 197 with 0 stale matt refs / 423 `/old/` refs — confirmed current by docs agent this conv.
- **Reconciliation pattern established** (see Learnings.md + DOC-DECISIONS.md): post-flip path drift → add one status banner + confine churn to a single status table, rather than mass-rewriting. Doc-type drives the ratio: timeless-design (banner) / living-guide (path swaps) / historical-spec (contextualize) / machine-lookup (bulk replace_all).
- **Component promotion map** (post-flip, for any future ref fixes): `src/components/matt/X` → `src/components/X` (clean one-level promotion); `src/layouts/matt/AppLayout.astro` → `src/layouts/AppLayout.astro`; `src/pages/matt/…` → root; legacy at `src/pages/old/` + `src/layouts/old/`. `matchHref` (MainNav.tsx) treats `/` exactly post-flip.
- Code branch `jfg-dev-13-matt`. This conv's docs changes will be committed in Step 6 (docs repo only; code repo clean).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
