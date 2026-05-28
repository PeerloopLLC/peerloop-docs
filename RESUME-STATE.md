# State — Conv 206 (2026-05-28 ~07:00)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 206 was a CC infrastructure conv — no application code touched. Key outcomes: (1) Encoded a new behavioral rule `§Investigative Framings — Surface Findings Before Acting` in CLAUDE.md after user pushback on the MEMORY.md audit ("I cannot know what you will find"), backed by `memory/feedback_audit_surface_findings_first.md`. (2) Trimmed MEMORY.md from 86% to 68% of cap (4,614 bytes saved). (3) Pruned CLAUDE.md from 533 → 286 lines via `/r-prune-claude` (after fixing its tilde-literal-path bug); created `docs/reference/CLAUDE-OFFLOAD.md` (316 lines). (4) Built `/r-coherence-check` — subsumed `/r-optimize` (deleted), 4 structural + 7 semantic + DEFERRED contradiction, tiered invocation via `--deep`, `.claude/coherence-ack.md` suppression list, `coherenceCheck.markers` in config.json, diff preview for semantic fixes. (5) Ran the new skill structural + `--deep`; applied STALE fix (deleted `project_skill_portability.md` — claimed `$CLAUDE_PROJECT_DIR` is the convention, superseded Conv 162) + GAP fix (added Multi-conv scope carve-out to CLAUDE.md §Solution Quality). Path bugs in 2 skills fixed (`r-prune-claude`, `r-coherence-check`).

## Completed

- [x] [MEM-CAP-WATCH] MEMORY.md full audit (option C) — 86% → 68%; stub-pointered 8 entries, consolidated 3 inline blocks, retired 4 stale entries
- [x] CLAUDE.md §Investigative Framings rule added (placement A — top-level § between §Critical Rule and §Skills)
- [x] memory/feedback_audit_surface_findings_first.md written + MEMORY.md index line
- [x] /r-prune-claude `!`-backtick path bugs fixed (tilde-literal); Step 4 scoped reference validation added
- [x] CLAUDE.md pruned (533 → 286 lines, 46% line / 33% byte reduction); docs/reference/CLAUDE-OFFLOAD.md created
- [x] /r-coherence-check skill built — subsumed /r-optimize (deleted); 296 lines; 10 categories; ack mechanism; diff preview
- [x] All 5 P1–P5 improvements applied (tiered invocation, ack file, configurable markers, diff preview, description cleanup)
- [x] /r-coherence-check `$ARGUMENTS` bug fixed (always-load + body-side parsing)
- [x] /r-coherence-check structural + --deep runs; STALE + GAP fixes applied (multi-conv-scope carve-out promoted to CLAUDE.md)
- [x] feedback_default_durable_no_ask.md followup edit (marked multi-conv-scope as promoted Conv 206)

## Remaining

**Carried-forward backlog (Conv 205 originals + new this conv):**
- [ ] [STANDIN-MATT] [Opus] Retrofit @stand-in pages + build Matt pages for 7 discover destinations
- [ ] [DISC-DROP] [Opus] Finish discover-page migration (Stages 3+4 + cleanup debts)
- [ ] [DISC-RTB-RECONCILE] [Opus] Reconcile discover role-tabs vs Matt role-tab-bar slot
- [ ] [AICODING-SEED] AI Coding topic shows 3 vs expected 2
- [ ] [DISC-UNIFY] Superseded by DISC-DROP (pointer)
- [ ] [RTMIG-4] [Opus] Route migration fork A — Home pilot follow-on
- [ ] [E2E-MIG] E2E migration
- [ ] [E2E-GATE] [Opus] E2E gate
- [ ] [PREFLIP-WT] Pre-flip worktree teardown
- [ ] [MATT-EXEC-PG2] [Opus] Matt execution page 2
- [ ] [MATT-EXEC-EXT] [Opus] Matt execution extension
- [ ] [RTB] [Opus] Role-tab-bar slot
- [ ] [ADMIN-REDIRECT-BLANK] Admin redirect blank page
- [ ] [MMP-PH5] [Opus] Matt master plan phase 5
- [ ] [MATT-EXEC-GRD] Matt execution grid
- [ ] [MMP-PH3] [Opus] Matt master plan phase 3
- [ ] [SHOWMORE] Show-more UI
- [ ] [CH-VARIANTS] Chat/Channel variants
- [ ] [ICN-NS] [Opus] Icon-namespace consolidation
- [ ] [HOWTOREG-ICN] How-to register icon
- [ ] [ASSET-SWEEP-GATE] Asset-sweep gate
- [ ] [MFRD-LOOKUP] Matt-Figma-Ready-for-Dev lookup
- [ ] [ESOT-STRUCTURE] External Source-Of-Truth structure
- [ ] [BROWSER-FALLBACK] Browser-fallback handling
- [ ] [TXTBTN] Text-button variant
- [ ] [DTUNE-WATCH] Drift-tuning watch
- [ ] [SKILL-DISCOVERY-AUDIT] NEW this conv — watch for low-usage skills (Conv 206 /r-optimize forgetting pattern)

## TodoWrite Items

- [ ] #1 [STANDIN-MATT] [Opus] / #2 [DISC-DROP] [Opus] / #3 [DISC-RTB-RECONCILE] [Opus]
- [ ] #4 [AICODING-SEED] / #5 [DISC-UNIFY]
- [ ] #6 [RTMIG-4] [Opus] / #7 [E2E-MIG] / #8 [E2E-GATE] [Opus] / #9 [PREFLIP-WT]
- [ ] #10 [MATT-EXEC-PG2] [Opus] / #11 [MATT-EXEC-EXT] [Opus] / #12 [RTB] [Opus] / #13 [ADMIN-REDIRECT-BLANK]
- [ ] #14 [MMP-PH5] [Opus] / #15 [MATT-EXEC-GRD] / #16 [MMP-PH3] [Opus] / #17 [SHOWMORE] / #18 [CH-VARIANTS]
- [ ] #19 [ICN-NS] [Opus] / #20 [HOWTOREG-ICN] / #21 [ASSET-SWEEP-GATE] / #22 [MFRD-LOOKUP]
- [ ] #23 [ESOT-STRUCTURE] / #24 [BROWSER-FALLBACK] / #25 [TXTBTN] / #27 [DTUNE-WATCH] / #28 [SKILL-DISCOVERY-AUDIT]

## Key Context

- **CLAUDE.md** restructured: behavioral rules in CLAUDE.md (286 lines / 20 KB); reference content in `docs/reference/CLAUDE-OFFLOAD.md`. 9 back-links in CLAUDE.md point to OFFLOAD section anchors.
- **§Investigative Framings** is the new behavioral rule; verb test = "tell me what's true / what's there / what's wrong" → surface first; otherwise proceed per §Solution Quality. Picking an option WITHIN an audit framing authorizes the *approach*, not the execution.
- **Multi-conv-scope carve-out** to §Solution Quality: pause and present scope tradeoff before committing to durable paths that span multiple convs.
- **/r-coherence-check** has 2 modes: default = 4 structural checks (cheap, deterministic, surface-only); `--deep` adds 7 semantic categories (opus-max judgment + apply-fixes). `--deep` always loads full content into pre-computed context (not conditional on `$ARGUMENTS` — that broke at Conv 206 [DEEP-INVOKE-BUG]). Mode detection happens in skill body, not bash.
- **/r-prune-claude** Step 4 now does scoped post-execute reference validation; emits "consider /r-coherence-check" pointer in Step 5 report.
- **Skill `!`-backtick discipline:** always tilde-literal paths (`~/projects/peerloop-docs/...`), never relative or `$VAR`. Per Conv 162 sweep + Conv 206 r-prune-claude/r-optimize/r-coherence-check fixes.
- **Skill argument-passing reality:** harness appends `ARGUMENTS: <args>` to skill body prompt text. `$ARGUMENTS` is NOT populated in `!`-backtick bash. Parse args in skill body's Step 0.
- **MEMORY.md cap:** now at 68% bytes; healthy headroom (~8 KB) for new entries.
- **Stale mirror state:** mirror's `project_skill_portability.md` + MEMORY.md line still present at this conv's start; will be removed by Step 5b live→mirror sync of THIS /r-end.
- **All 5 baseline gates** NOT re-verified this conv (no application code touched). Code-repo `package-lock.json` drift was npm-install no-op.
- **Branch:** `jfg-dev-13-matt` (code), `main` (docs).
- **Next-conv directive:** Continue [STANDIN-MATT] — building Matt pages for the 7 discover destinations is the critical-path unblocker for DISC-DROP Stages 3-4.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
