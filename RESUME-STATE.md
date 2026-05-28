# State — Conv 210 (2026-05-28 ~15:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 210 was a plan-file infrastructure refactor (Block: misc). Migrated the MATT block family (MATT-DESIGN-PUSH + MATT-CUTOVER + STANDIN-MATT) from inline PLAN.md content to a new `plan/matt/` subdirectory with 11 files (README + 7 per-phase files + cutover.md + standin-matt.md), moved COMPLETED_PLAN.md → plan/COMPLETED.md, and updated `/r-start` skill + all `COMPLETED_PLAN.md` references for hybrid plan-file mode. PLAN.md shrank from 2769 → 1933 lines (-30%). No code repo changes; no PLAN feature block advanced.

## Completed

- [x] [PMM-DIR] Create plan/ + plan/matt/ dirs + git mv COMPLETED_PLAN.md → plan/COMPLETED.md
- [x] [PMM-MATT-README] Write plan/matt/README.md
- [x] [PMM-MATT-PHASES] Write 9 phase files + cutover.md + standin-matt.md
- [x] [PMM-CONV-EXTRACT] Fold MATT-related Conv N Items into the right phase file
- [x] [PMM-IDX] Rewrite PLAN.md as thin index with B-richness for migrated ACTIVE rows
- [x] [PMM-SKILLS] Update /r-start SKILL.md for hybrid plan-file mode + all COMPLETED_PLAN.md references
- [x] [PMM-VERIFY] Verify /r-start Step 8 pre-computed context surfaces MATT WIP correctly

## Remaining

- [ ] [STANDIN-MATT] [Opus] Retrofit /profile — substantive design work
- [ ] [DISC-DROP] [Opus] Finish discover-page migration Stages 3+4
- [ ] [DISC-RTB-RECONCILE] [Opus]
- [ ] [AICODING-SEED]
- [ ] [DISC-UNIFY] pointer to DISC-DROP
- [ ] [RTMIG-4] [Opus]
- [ ] [E2E-MIG]
- [ ] [E2E-GATE] [Opus]
- [ ] [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus]
- [ ] [MATT-EXEC-EXT] [Opus]
- [ ] [RTB] [Opus]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] [MMP-PH5] [Opus]
- [ ] [MATT-EXEC-GRD]
- [ ] [MMP-PH3] [Opus]
- [ ] [SHOWMORE]
- [ ] [CH-VARIANTS]
- [ ] [ICN-NS] [Opus]
- [ ] [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE]
- [ ] [MFRD-LOOKUP]
- [ ] [ESOT-STRUCTURE]
- [ ] [BROWSER-FALLBACK]
- [ ] [TXTBTN]
- [ ] [DTUNE-WATCH]
- [ ] [SKILL-DISCOVERY-AUDIT]
- [ ] [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] [PROF-SUBNAV-DEAD] Profile SubNav has 3 dead links
- [ ] [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] [SETTINGS-REND-WATCH] Watch this conv's /r-end run for unexpected permission prompts under tightened Conv 209 settings

## TodoWrite Items

- [ ] #1: [STANDIN-MATT] [Opus] Retrofit /profile — substantive design work
- [ ] #2: [DISC-DROP] [Opus] Finish discover-page migration Stages 3+4
- [ ] #3: [DISC-RTB-RECONCILE] [Opus]
- [ ] #4: [AICODING-SEED]
- [ ] #5: [DISC-UNIFY] pointer to DISC-DROP
- [ ] #6: [RTMIG-4] [Opus]
- [ ] #7: [E2E-MIG]
- [ ] #8: [E2E-GATE] [Opus]
- [ ] #9: [PREFLIP-WT]
- [ ] #10: [MATT-EXEC-PG2] [Opus]
- [ ] #11: [MATT-EXEC-EXT] [Opus]
- [ ] #12: [RTB] [Opus]
- [ ] #13: [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #14: [MMP-PH5] [Opus]
- [ ] #15: [MATT-EXEC-GRD]
- [ ] #16: [MMP-PH3] [Opus]
- [ ] #17: [SHOWMORE]
- [ ] #18: [CH-VARIANTS]
- [ ] #19: [ICN-NS] [Opus]
- [ ] #20: [HOWTOREG-ICN]
- [ ] #21: [ASSET-SWEEP-GATE]
- [ ] #22: [MFRD-LOOKUP]
- [ ] #23: [ESOT-STRUCTURE]
- [ ] #24: [BROWSER-FALLBACK]
- [ ] #25: [TXTBTN]
- [ ] #26: [DTUNE-WATCH]
- [ ] #27: [SKILL-DISCOVERY-AUDIT]
- [ ] #28: [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] #29: [PROF-SUBNAV-DEAD] Profile SubNav has 3 dead links
- [ ] #30: [SETTINGS-WATCHER] Investigate external rewriter
- [ ] #38: [SETTINGS-REND-WATCH] Watch this conv's /r-end run for unexpected permission prompts under tightened Conv 209 settings

## Key Context

- **New plan/ subdirectory structure** established Conv 210:
  - `plan/COMPLETED.md` — was `COMPLETED_PLAN.md` at repo root; moved via `git mv` (history preserved)
  - `plan/matt/` — MATT family (11 files: README + phase-1 through phase-7 + cutover + standin-matt)
  - Future block migrations follow the same pattern: `plan/<slug>/` (single block) or `plan/<family>/<sub>.md` (family of related blocks)

- **Hybrid plan-file mode** for `/r-start`:
  - PLAN.md ACTIVE-table rows for migrated blocks end with `→ [plan/<slug>/README.md](plan/<slug>/README.md)`
  - `/r-start` Step 8 has a new pre-computed line that crawls `plan/*/README.md` (head -40 per file) so resume context surfaces migrated-block status
  - Non-migrated blocks read inline from PLAN.md as before

- **COMPLETED_PLAN.md references updated everywhere** to `plan/COMPLETED.md`:
  - `.claude/config.json` (4 hits in docs lists)
  - `.claude/skills/{r-commit,r-end,r-start}/SKILL.md` + `r-end/refs/{fmt-docs,fmt-update-plan}.md`
  - `CLAUDE.md`, `docs/INDEX.md` (tree + lookup table), `docs/DOCS-REORG-MAP.md`
  - Session-archive docs under `docs/sessions/**` left alone (historical)

- **MATT block status (snapshot from plan/matt/README.md):**
  - Phase 1 (tokens) ✅ Conv 174
  - Phase 2 (shell) ✅ Conv 174 + 175 + 190 [SBAR-REWRITE]
  - Phase 3 (first page) ✅ Conv 175
  - Phase 4 (primitives A+B) ✅ Convs 175-177
  - Phase 4.5 (CMP + MMP-PH4) ✅ Conv 185 + Conv 187
  - Phase 5 🔥 IN PROGRESS — course-tab family done Convs 188-190; Enroll + Session families + 5 other routes pending
  - Phase 6 → ongoing per-page (Home slice done Conv 203; STANDIN slice 11 form primitives Conv 207)
  - Phase 7 [ ] pending
  - Cutover ✅ Conv 197 [ROUTE-FLIP] + Conv 198 doc reconciliation + Conv 199 [PROV-SWEEP]+[PROV-MATCH]
  - STANDIN-MATT 🔥 login/signup/onboarding/404 retrofitted Convs 207-208; /profile pending

- **Settings-permissions watch:** `[SETTINGS-REND-WATCH]` (#38) — first unattended /r-end run under Conv 209's tightened settings happens THIS conv. The `bash <path>/script.sh` form for `advance-drift-baseline.sh` was NOT added to settings (per Conv 209 user choice to surface gaps empirically). If a permission prompt appears during /r-end, capture the command shape and consider adding to settings.json allow list.

- **External watcher** `[SETTINGS-WATCHER]` (#30) — still pending; M4Pro has an unidentified process rewriting `.claude/settings.local.json` between CC edits. CC should consider re-reading settings files before each Write to avoid stomping watcher additions.

- **Baselines:** No baseline gates run this conv (docs-only, no code repo changes). Last green: Conv 207 (tsc 0; astro check 1290/0/0/0; lint 0; build clean; tests 6452/6452).

- **Branch:** code repo CLEAN end of conv (no changes). Docs repo has 11 modified + RESUME-STATE.md (this file) + plan/matt/ new — all will be in this conv's commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
