# State — Conv 195 (2026-05-26 ~12:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Docs/planning-only conv. Settled the **collision-provenance design** (how to tell Matt-drawn vs Claude-built primitives once Matt starts redrawing things we've built) and the **routing flip** (`/matt/*`→`/`, legacy→`/old/*`, namespace dissolve). Authored `docs/as-designed/matt-provenance.md`, added the **MATT-CUTOVER** PLAN block + tasks #24–26. Then ran a plan-mode coherence/comprehensiveness review (3 Explore agents) that caught a `/fraser`-vs-`/old` contradiction and several ROUTE-FLIP gaps — all fixed via doc edits. No code touched.

## Completed

- [x] Settled collision-provenance design; authored `docs/as-designed/matt-provenance.md` (two-axis model, 5 decisions, `@matt-source` marker spec, reconciliation-via-git, detection sweep, §8 ROUTE-FLIP checklist)
- [x] Added MATT-CUTOVER block to PLAN.md (ACTIVE row + body); created tasks #24 [PROV] / #25 [ROUTE-FLIP] / #26 [PROV-SWEEP]
- [x] Plan-mode coherence/comprehensiveness review (3 Explore agents)
- [x] Fixed `/fraser`→`/old` across `url-routing.md` §8 + `matt-pre-plan.md` (2 spots agents missed, caught by verification grep)
- [x] Added Phase-6-unmarked note, icon Material sub-task, no-redirect decision to matt-provenance.md
- [x] Confirmed /schedule reminder = cloud push via Claude app (not macOS Notification Center) via claude-code-guide agent

## Remaining

**Matt design system / cutover (Opus-tagged):**
- [ ] [PROV] Exhaustive @matt-source attribution pass — BEFORE flip; light (38/44 components already cite nodes); icon Material-distinction sub-task (NOT Opus — rote marking of locked spec)
- [ ] [ROUTE-FLIP] Flip /matt→/, legacy→/old, dissolve namespace [Opus] — full §8 checklist in matt-provenance.md (legacy-out-first, api/ exclusion, layout collision, 225 URLs, demo bridges)
- [ ] [PROV-SWEEP] Collision-detection sweep [Opus] — later workstream
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [NAV-APP-A] Approach-A AppNavbar→Matt Sidebar swap [Opus] — likely mooted by ROUTE-FLIP; NAV-RETROFIT stays until flip lands
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus] — stays UNMARKED (= ours) by design
- [ ] [RTB] Role Tab Bar design [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus] — likely fix: middleware guard
- [ ] [MMP-PH5] roll-forward 11 Phase-5 pages / [MATT-EXEC-GRD] graduation / [MMP-PH3] verify status
- [ ] [SHOWMORE] / [CH-VARIANTS]
- [ ] [ICN-NS] icon namespacing — overlaps ROUTE-FLIP namespace dissolve; fold/clarify at flip time

**Harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN] / [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-LOOKUP] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK] / [TXTBTN] / [MCFRAME]
- [ ] [MEM-CAP-WATCH] MEMORY.md at 81% byte cap (confirmed this conv: 129/200 lines, 20745/25600 bytes)
- [ ] [RA-STALE] Drop MoreSlidePanel from role-audit-2026-04-15.md on next refresh

## TodoWrite Items

- [ ] #1 [DISC-UNIFY] [Opus] / #2 [NAV-APP-A] [Opus] / #3 [MATT-EXEC-PG2] [Opus] / #4 [MATT-EXEC-EXT] [Opus] / #5 [RTB] [Opus] / #6 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #7 [MMP-PH5] / #8 [MATT-EXEC-GRD] / #9 [MMP-PH3] / #10 [SHOWMORE] / #11 [CH-VARIANTS]
- [ ] #12 [HOWTOREG-ICN] / #13 [PLAY-CIRCLE-ICN] / #14 [ASSET-SWEEP-GATE] / #15 [FIGMA-MCP-DOC-HARVEST] / #16 [MFRD-LOOKUP] / #17 [ESOT-STRUCTURE] / #18 [BROWSER-FALLBACK] / #19 [TXTBTN]
- [ ] #20 [MEM-CAP-WATCH] / #21 [MCFRAME] / #22 [ICN-NS] / #23 [RA-STALE]
- [ ] #24 [PROV] / #25 [ROUTE-FLIP] [Opus] / #26 [PROV-SWEEP] [Opus]

## Key Context

- **Provenance scheme (matt-provenance.md):** `@matt-source <figma-node>` marks Matt-authoritative artifacts; **unmarked (within design-system layer) = ours**. Two axes: domain (structural — route/layout tree, `/old` self-documents throwaway) vs authorship (the marker — collision axis). Mark BEFORE the flip (matt/ folder is a free audit aid the flip destroys). Reconciliation = adding the marker when Matt redraws; git diff = audit trail.
- **MATT-CUTOVER trigger:** "after today's demo" (2026-05-26). [PROV] runs before [ROUTE-FLIP].
- **ROUTE-FLIP is pure file-move + link-rewrite, NO redirect/middleware** (not a production app — unbuilt root routes 404). Blast radius: 225 `/matt` URLs/29 files, 83 `@components/matt/*` imports, ~13 Matt routes→root, ~85 legacy→/old (EXCLUDE `src/pages/api/`), layout-name collision (`layouts/matt/AppLayout.astro` vs legacy), 2 demo bridges to remove, route-map regen via `node scripts/route-api-map.mjs`.
- **`/old` is authoritative** (superseded `/fraser` — now fixed in url-routing.md §8 + matt-pre-plan.md).
- **NAV-RETROFIT stays active until the flip ships**, then superseded (user decision).
- **/schedule reminders** push via Claude app (not macOS), cloud-run (no terminal dependency) — for the eventual post-demo flip nudge if wanted.
- Code branch jfg-dev-13-matt; no code changed this conv. Commits land in Step 6 (this state pre-commit).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
