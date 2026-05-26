# State — Conv 200 (2026-05-26 ~18:43)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 200 was a **doc-sync-system cost-reduction pass (DTUNE)** — no MATT-DESIGN-PUSH work. After a docs assessment + contrarian critique, discovered the existing `docsRegistry` (Convs 132–137) already had the 4-category tier model, so the work became *re-tuning* not building. Shipped A+B (machinery/policy) + C (content cleanup) across **3 pushed commits**: vendor docs → `manual` (category-gated out of the drift hook + `/r-end` docs agent), CLAUDE.md policy rewrite, 4 frozen docs archived to `docs/archive/`, and `reactjs.md` de-staled + vendor snapshot banners. The Matt design-system build (DISC-UNIFY etc.) is untouched and remains the main pending work.

## Completed

- [x] [DTUNE-V] vendor-docs `driftCheck`→`manual` + category gate in tech-doc-sweep.sh (A3/B1)
- [x] [DTUNE-R] `/r-end` docs agent re-scoped: driftCheck-only, "no docs" valid, no gap-spiral (B2)
- [x] [DTUNE-P] CLAUDE.md "When Working with a Technology" rewritten + Maintenance-Tiers table (A2/B3)
- [x] [DTUNE-D] doc-sync-strategy.md §8 records the re-tuning (A1)
- [x] C2 — 4 frozen docs → `docs/archive/` with provenance banners + ref/registry updates (commit e2a1e99)
- [x] C1 — `reactjs.md` refreshed + snapshot banner on 17 vendor docs (commit 47159e4)
- [x] All 3 commits pushed to origin/main (63f8dc2, e2a1e99, 47159e4)

## Remaining

**Matt design-system build (Opus):**
- [ ] [DISC-UNIFY] Migrate /discover/courses onto fetchCourseBrowseData (+primary_topic_id) [Opus]
- [ ] [MATT-EXEC-PG2] Enroll/Session families [Opus]
- [ ] [MATT-EXEC-EXT] Phase 6 extrapolation primitives + live-hero→MattIcon residual [Opus]
- [ ] [RTB] Role Tab Bar design [Opus] — confirmed NOT yet drawn by Matt (PROV-MATCH); greenfield
- [ ] [ADMIN-REDIRECT-BLANK] non-admin /admin/* blank-200 instead of 302 [Opus]
- [ ] [MMP-PH5] Roll-forward 11 Phase-5 pages
- [ ] [MATT-EXEC-GRD] Graduation
- [ ] [MMP-PH3] Verify status
- [ ] [SHOWMORE] Show-more behavior
- [ ] [CH-VARIANTS] Card/component variants

**Re-scoped (larger/blocked):**
- [ ] [ICN-NS] Legacy→MattIcon convergence — 204 non-/old files still import legacy icons.tsx/Icon.astro [Opus]
- [ ] [HOWTOREG-ICN] Harvest how_to_reg — BLOCKED (not in live Components file; needs Happy Path file key or per-encounter harvest)

**Infra / tooling / watches:**
- [ ] [ASSET-SWEEP-GATE] asset sweep gate / [FIGMA-MCP-DOC-HARVEST] — gate the deferred PROV-MATCH automation
- [ ] [MFRD-LOOKUP] permanent Ready-for-Dev drift lookup maintenance
- [ ] [ESOT-STRUCTURE] external source-of-truth structure
- [ ] [BROWSER-FALLBACK] document Playwright chromium fallback when Chrome MCP disconnects
- [ ] [TXTBTN] watch for inline text-styled action button across Phase 5 routes
- [ ] [MEM-CAP-WATCH] MEMORY.md at byte cap (81%, 20835/25600) — prune or offload before truncation; NOT addressed Conv 200
- [ ] [DTUNE-WATCH] validate `/r-end` docs-agent produces fewer doc tasks over next few convs; tighten Agent 3 prompt if vendor/prose tasks still appear (new Conv 200)

## TodoWrite Items

- [ ] #1 [DISC-UNIFY] [Opus] / #2 [MATT-EXEC-PG2] [Opus] / #3 [MATT-EXEC-EXT] [Opus] / #4 [RTB] [Opus] / #5 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #6 [MMP-PH5] / #7 [MATT-EXEC-GRD] / #8 [MMP-PH3] / #9 [SHOWMORE] / #10 [CH-VARIANTS]
- [ ] #11 [ICN-NS] [Opus] / #12 [HOWTOREG-ICN]
- [ ] #13 [ASSET-SWEEP-GATE] / #14 [FIGMA-MCP-DOC-HARVEST] / #15 [MFRD-LOOKUP] / #16 [ESOT-STRUCTURE] / #17 [BROWSER-FALLBACK] / #18 [TXTBTN] / #19 [MEM-CAP-WATCH] / #24 [DTUNE-WATCH]

## Key Context

- **DTUNE shipped (Conv 200), pushed.** Doc maintenance tiers = the 4 `docsRegistry` categories: **driftCheck = auto-maintained; manual/archival/generated = editorial/leave-alone; unmatched paths default to `manual`.** Resolve any doc's tier: `node .claude/scripts/docs-registry.mjs doc-category <relpath>`.
- **Category gate** lives in `tech-doc-sweep.sh` (skips non-driftCheck docs); the SessionStart drift hook (`tech-doc-drift.sh`) is an unchanged thin wrapper that inherits the behavior. Vendor docs no longer flag.
- **`/r-end` docs agent** now maintains driftCheck only and treats "no docs changed" as valid — [DTUNE-WATCH] tracks confirming this holds (it's prompt-based, not a hard gate).
- **archive/** = `docs/archive/` (archival category). `orig-pages-map.md` deliberately left in place (6 active incoming refs).
- **Matt-build context** is NOT re-summarized here (this conv did none) — it lives in PLAN.md §MATT-DESIGN-PUSH and the Conv 199 session docs (provenance tooling `npm run prov:sweep`, Matt's live Figma file `UpDNMiIEO8y3J7ZHkm356b`, icon-harvest pattern). [DISC-UNIFY] is the recommended next task.
- **Baseline NOT run this conv** — only the drift-detection integration test (18/18) was run; no full 5-gate (the code repo had zero changes). Treat any prior baseline as a hypothesis per CLAUDE.md.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
