# State — Conv 197 (2026-05-26 ~14:59)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

The MATT-CUTOVER conv. Completed **[PROV]** (exhaustive `@matt-source` provenance pass: 35 components + token blocks marked, a 53-icon registry built via live Figma probe — `icon-provenance.ts` + `_INDEX.md`) and committed/pushed it. Then executed **[ROUTE-FLIP]** end-to-end: `/matt/*` namespace dissolved — Matt's design system is now the **root app**, legacy moved to **`/old/*`**. All 9 §8 steps done, all 5 gates green (6453 tests). The flip surfaced follow-on doc drift across several reference docs (post-flip path reconciliation). [ROUTE-FLIP] is committed by this /r-end.

## Completed

- [x] [PROV] Exhaustive @matt-source attribution — 35 components marked / 9 unmarked (=ours); token blocks (colors 477:8502, typography 40:485/40:493, semantics 40:484/40:482); icon registry (39 catalogue + 2 matt-embedded + 12 ours). matt-provenance.md §7 SETTLED, §9 execution record + matt-embedded class. (Committed 608346a2/6821e90, pushed.)
- [x] [ROUTE-FLIP] /matt→/, legacy→/old, namespace dissolved — 43 legacy entries → old/, 9 Matt pages → root, 83 imports rewritten, layout collision resolved, 139 /matt literals + nav active-matching fixed, 2 demo bridges removed, route map regenerated, docs updated. 5 gates green.

## Remaining

**MATT-CUTOVER tail:**
- [ ] [PROV-SWEEP] Collision-detection sweep [Opus] — greps @matt-source + enumerates unmarked primitives, probes Matt's Figma for name-matches. Must anchor on `@matt-source` at comment-line-start (grep-pollution lesson). Can import `icon-provenance.ts` directly.
- [ ] [NAV-APP-A] AppNavbar→Matt Sidebar swap [Opus] — **LIKELY MOOTED** by the flip (root already uses Matt's Sidebar via canonical AppLayout; AppNavbar now serves only /old). Confirm + close. NAV-RETROFIT likewise superseded.

**Post-flip doc reconciliation (siblings — could batch):**
- [ ] [URLDOC-RECONCILE] (#27) — rewrite url-routing.md §§1–7 + file tree for /old layout (§8 already done).
- [ ] [DEVGUIDE-MATT-RECONCILE] (#28) — DEVELOPMENT-GUIDE.md ~22 broken matt/ path refs + stale matt-design-system.md pointers (lines listed in task).
- [ ] [MDS-MATT-RECONCILE] (#29) — matt-design-system/ folder, 25 refs across 6 files.
- [ ] [MFRD-MATT-PATHS] (#30) — matt-frames-ready-for-dev.md, 24 refs. (DECISIONS.md 56 refs = historical, do NOT rewrite.)

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus] — stays UNMARKED (=ours) by design
- [ ] [RTB] Role Tab Bar design [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus] — likely middleware guard
- [ ] [MMP-PH5] roll-forward 11 Phase-5 pages / [MATT-EXEC-GRD] graduation / [MMP-PH3] verify status
- [ ] [SHOWMORE] / [CH-VARIANTS] / [ICN-NS] (icon namespacing — note: namespace now dissolved, re-scope)

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MCFRAME]
- [ ] [MEM-CAP-WATCH] MEMORY.md at 81% byte cap (re-confirmed Conv 197: 129/200 lines, 20745/25600 bytes)
- [ ] [RA-STALE] Drop MoreSlidePanel from role-audit-2026-04-15.md on next refresh

## TodoWrite Items

- [ ] #3 [PROV-SWEEP] [Opus] / #4 [DISC-UNIFY] [Opus] / #5 [NAV-APP-A] [Opus] (mooted?) / #6 [MATT-EXEC-PG2] [Opus] / #7 [MATT-EXEC-EXT] [Opus] / #8 [RTB] [Opus] / #9 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #10 [MMP-PH5] / #11 [MATT-EXEC-GRD] / #12 [MMP-PH3] / #13 [SHOWMORE] / #14 [CH-VARIANTS] / #15 [ICN-NS]
- [ ] #16 [HOWTOREG-ICN] / #17 [PLAY-CIRCLE-ICN] / #18 [ASSET-SWEEP-GATE] / #19 [FIGMA-MCP-DOC-HARVEST] / #20 [MFRD-LOOKUP] / #21 [ESOT-STRUCTURE] / #22 [BROWSER-FALLBACK] / #23 [TXTBTN] / #24 [MCFRAME]
- [ ] #25 [MEM-CAP-WATCH] / #26 [RA-STALE]
- [ ] #27 [URLDOC-RECONCILE] / #28 [DEVGUIDE-MATT-RECONCILE] / #29 [MDS-MATT-RECONCILE] / #30 [MFRD-MATT-PATHS]

## Key Context

- **The flip shipped:** Matt design system = root app; legacy = `/old/*`; `api/` stayed at `/api/`; `404.astro` at root. No redirects (not production — unbuilt root routes 404). All via `@`-aliases so page moves needed no per-page import fixes.
- **Provenance scheme live:** `@matt-source <node>` markers across components/tokens/icons. **Unmarked (in design-system layer) = ours.** Icon registry `src/components/icons/icon-provenance.ts` is the canonical machine source for [PROV-SWEEP]; `_INDEX.md` is the human view. Three icon classes: `matt-catalogue` / `matt-embedded` (Material glyph Matt curated) / `ours`.
- **Grep-pollution rule:** a "ours" prose note must NOT contain the literal `@matt-source` token. [PROV-SWEEP] matcher must anchor on `@matt-source` at start of a comment line.
- **Doc-reconciliation batch (#27–30):** the flip left stale `/matt`/`components/matt`/`layouts/matt` refs in url-routing §§1–7, DEVELOPMENT-GUIDE.md, matt-design-system/ folder, matt-frames-ready-for-dev.md. DECISIONS.md refs are historical-accurate — leave. page-connections.md + route-api-map.md already regenerated this conv.
- **Layout names post-flip:** `layouts/AppLayout.astro` = Matt's (canonical); `layouts/old/AppLayout.astro` = legacy; `LegacyAppLayout/Admin/Landing` untouched.
- Code branch `jfg-dev-13-matt`. [ROUTE-FLIP] commit lands in this /r-end (Step 6).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
