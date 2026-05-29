# State — Conv 215 (2026-05-29 ~10:20)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Task-list triage + tooling conv (no major feature block advanced). Built a new `/r-start` Step 7.5 that auto-generates `.scratch/conv-tasks.md` every conv — a plain-language, theme-grouped companion to the terse TodoWrite codes (stable filename so the VS Code tab stays valid across convs; mandatory row-count==task-count coverage check). Enriched ~14 thin/opaque task descriptions from PLAN/git archaeology (key fix: **#11 RTB = "Role Tab Bar", not "real task board"**). Pruned the task list 31 → 20 active (deleted 6 under-specified/superseded, completed 4 via verification). Two small code fixes: AICODING-SEED (re-filed 2 Q-System courses' primary topic top-014→top-015) and TW-V4-FLAGS (7 components, Tailwind v3→v4 className renames; all gates green).

## Completed

- [x] [LOCKFILE-CI-CHECK] (#31) — verified npm ci clean tree, drift sentinel matches (sha256)
- [x] [AICODING-SEED] (#3) — Q-System courses re-filed top-014→top-015; AI Coding=1 / Prompt Engineering=2 primary
- [x] [MMP-PH3] (#15) — confirmed already complete (Conv 185); closed
- [x] [TW-V4-FLAGS] (#30) — 7 components fixed (bg-linear-to + outline-hidden); check-tailwind-v4 ✓0, tsc/astro/lint green
- [x] New `/r-start` Step 7.5 companion-file feature + `.scratch/conv-tasks.md`
- [x] Task-list triage: 31 → 20 active (deleted #4/#22/#23/#25/#26/#27; completed #3/#15/#30/#31; enriched 14)
- [x] [OPM-REGEN] (#27) — retired obsolete (generator+source gone); froze `orig-pages-map.md` with banner

## Remaining

- [ ] (standing block backlog — see TodoWrite Items below; no single WIP this conv)

## TodoWrite Items

- [ ] #1: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #2: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar slot [Opus]
- [ ] #5: [RTMIG-4] Per-page /old→root conversion via Matt-shell loop [Opus]
- [ ] #6: [E2E-MIG] Re-point e2e to new routes incrementally
- [ ] #7: [E2E-GATE] Structural-change tier + goto-target resolver check [Opus]
- [ ] #8: [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done
- [ ] #9: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll/Session families + 5 routes) [Opus]
- [ ] #10: [MATT-EXEC-EXT] Phase 6 extrapolation primitives (build lazily per page) [Opus]
- [ ] #11: [RTB] Design the Role Tab Bar component (design-spec doc) [Opus]
- [ ] #12: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* yields blank 200 instead of redirect [Opus]
- [ ] #13: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via MCP (machine-pinned M4) [Opus]
- [ ] #14: [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] #16: [SHOWMORE] Show-More affordance for Teachers + Reviews tabs
- [ ] #17: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (597:6504 / 685:13240)
- [ ] #18: [ICN-NS] 204-file legacy→MattIcon convergence [Opus]
- [ ] #19: [HOWTOREG-ICN] How-to-register-icon doc
- [ ] #20: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #21: [MFRD-LOOKUP] Matt frames-ready-for-dev lookup
- [ ] #24: [TXTBTN] Watch — TextButton primitive if 3+ inline-text-button instances appear in Phase 5
- [ ] #28: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro

## Key Context

- **`.scratch/conv-tasks.md` is the new task companion** — auto-regenerated each `/r-start` (Step 7.5), stable filename, user keeps it open in VS Code. Don't date its filename. Coverage rule: file row-count must equal active task count.
- **#11 RTB = Role Tab Bar** (a Matt design-system component), NOT "real task board" — the subject was corrected this conv. #2 DISC-RTB-RECONCILE consumes it.
- **#3 AICODING-SEED applies on next `db:setup:local:dev`** — the seed edit (top-014→top-015 for `crs-intro-q-system` + `crs-intermediate-q-system`) is committed-to-file only; user chose NOT to re-seed this conv. Local DB still has old assignments until re-seeded.
- **#13 MMP-PH5 is machine-pinned to MacMiniM4** — source `.scratch/matt-figma-*.md` are gitignored and live only on M4; the page-rollforward half must run there, not M4Pro.
- **#25 DTUNE-WATCH + #26 SKILL-DISCOVERY-AUDIT were deleted** as unrecoverable (triggers predate Conv 211 consolidation). Re-add with proper scope only if the user recalls their original intent.
- Code repo `jfg-dev-13-matt`: this conv's commit includes the seed re-file + 7 TW-v4 component fixes. Docs commit includes the r-start Step 7.5 feature + orig-pages-map frozen banner.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
