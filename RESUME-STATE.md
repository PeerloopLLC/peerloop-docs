# State — Conv 281 (2026-06-14 ~12:46)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Memory-system maintenance conv. After `/r-start` (280→281, 32 tasks transferred), ran **[MEM-CAP]**: `/r-prune-memory` (17 re-flatten + 1 extract) took MEMORY.md 89%→83%, then `/r-coherence-check --all` bundled the Figma entries (**[FIGMA-BUNDLE]**) and PLATO satellites, merged the baseline stubs, retired 3 stale files, and fixed several index/wikilink issues — landing at **78%** (20008 bytes, 117 lines), under the 80% SessionStart warn with margin. No code changes. The memory work propagates to the other machine via the Step-5b live→mirror sync committed this conv.

## Completed

- [x] /r-start Conv 280→281 (32 tasks transferred, 0-diff memory sync)
- [x] [MEM-CAP] #15 — MEMORY.md 89% → 78% via prune + coherence-check; structural sweep clean
- [x] [FIGMA-BUNDLE] #33 — `figma-context.md` bundle (READ-ONLY guardrail §1 + reuse + MCP-behavior + tokenize-probe), one load-on-demand trigger with safety headline inline; 4 source files deleted, wikilinks repointed
- [x] Coherence full cleanup: PLATO bundle (4 satellites deleted — already duplicated in plato-context.md), baseline-stub merge, retired `project_currentuser_optimize` + `project_course_page_merge`, folded `project_matt_collaboration_style` into the phase-out entry, fixed `project_feeds_hub` index line (Conv-224 resolution), indexed `rename-lessons.md`, repaired 3 hyphen-form dangling wikilinks

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production (do not build for MVP)
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (wants old-vs-new dashboard comparison)
- [ ] [RTMIG-4] #3 [Opus] — main unblocked loop: ~89 legacy `/old/*` → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED cluster)
- [ ] [ICN-NS] #9 · [E2E-MIG] #10 · [E2E-GATE] #11 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #16 · [OLD-PORTED-CLEANUP] #17
- [ ] [LEARN-ISLAND-RESTYLE] #18 · [CREATE-ISLAND-RESTYLE] #19 · [TEACH-ISLAND-RESTYLE] #20 · [TRIAGE-RESTYLE] #21
- [ ] [V217-WATCH] #22 · [COURSEDETAIL-DEAD] #23 · [NUDGE-CACHE-FLASH] #24 · [NUDGE-TC-V2] #25 · [TW-V4] #26 · [TEST-FILE-COUNT] #27 · [PLAN-RENUM] #28
- [ ] [COMMONS-DATE] #29 · [DISCCARD-DEL] #30 · [TESTDOC-DRIFT] #31 · [SYS-RENAME-COSMETIC] #32

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] (DEFERRED) · #2 [ROLE-STUDIOS] [Opus] (BLOCKED) · #3 [RTMIG-4] [Opus] · #4–#14 · #16–#32 (see Remaining for the full code list)

## Key Context

- **MEMORY.md now at 78%** of the 25 KB SessionStart byte cap (20008/25600), 117 lines. Headroom restored; [MEM-CAP] closed. Reaching the 70% target would need further entry retirement, not byte-trimming (file is at its density floor).
- **`figma-context.md`** is the new load-on-demand Figma hub (4 sections; §1 is the READ-ONLY/never-write GUARDRAIL, headline also inline in the MEMORY.md trigger line). Bundled the 3 Figma-MCP entries + tokenize-probe. `plato-context.md` is the analogous PLATO hub (now sole-indexed; 4 satellites deleted).
- **Memory dir: 89→77 sub-files.** Live→mirror synced + committed this conv, so the other machine picks up the cleanup at its next `/r-start` (pull → mirror→live).
- **No code changes this conv** — code repo clean, no baseline run needed/claimed.
- **Next** = [RTMIG-4] #3 is the main unblocked loop; [SYS-RENAME-COSMETIC] #32 is a quick residual sweep. ROLE-STUDIOS still blocked by client.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
