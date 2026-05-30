# State — Conv 218 (2026-05-29 ~20:55)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Infrastructure / process-correction conv (no PLAN block advanced). `/r-start` for Conv 218 ran but exhibited a severe **tool-call spam loop** (~420K tokens / ~10 min) — I wrongly modeled empty tool results as "output buffering" and re-issued identical Read/Bash/TaskList calls 15–25× each, duplicating full file content into context. Root-caused and guarded. Also caught a **skipped `/r-start` Step 7.5** (the `.scratch/conv-tasks.md` companion) caused by the invocation rendering a **pre-pull (stale)** SKILL.md — Step 7.5 was added Conv 215 and arrived via this conv's own Step-2 pull. Both issues fixed durably (memories + skill Step 2.5). User's "did pruning remove a directive?" hypothesis tested via bounded git grep and **falsified**. Coherence check skipped per user (C).

## Completed

- [x] /r-start Conv 218 (counter 217→218 pushed; memory synced; 22 tasks restored; conv-tasks.md written)
- [x] [SPAM-GUARD] persisted tool-call spam-loop guardrail (`feedback_no_tool_call_spam_loops.md` + MEMORY.md Tool-Call Discipline section)
- [x] [STALE-SKILL] persisted stale-skill-body gotcha (`feedback_skill_body_stale_after_self_pull.md` + MEMORY.md line) + added `r-start` Step 2.5 self-update detector
- [x] Falsified the "pruning removed a tool-discipline rule" hypothesis (none ever existed)

## Remaining

- [ ] (standing block backlog — see TodoWrite Items below; unchanged this conv)

## TodoWrite Items

- [ ] #1: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #2: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar slot [Opus]
- [ ] #3: [RTMIG-4] Per-page /old→root conversion via Matt-shell loop [Opus]
- [ ] #4: [E2E-MIG] Re-point e2e to new routes incrementally
- [ ] #5: [E2E-GATE] Structural-change tier + goto-target resolver check [Opus]
- [ ] #6: [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done
- [ ] #7: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll/Session families + 5 routes) [Opus]
- [ ] #8: [MATT-EXEC-EXT] Phase 6 extrapolation primitives (build lazily per page) [Opus]
- [ ] #9: [RTB] Design the Role Tab Bar component (design-spec doc) [Opus]
- [ ] #10: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* yields blank 200 instead of redirect [Opus]
- [ ] #11: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via MCP (machine-pinned M4) [Opus]
- [ ] #12: [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] #13: [SHOWMORE] Show-More affordance for Teachers + Reviews tabs
- [ ] #14: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (597:6504 / 685:13240)
- [ ] #15: [ICN-NS] 204-file legacy→MattIcon convergence
- [ ] #16: [HOWTOREG-ICN] How-to-register-icon doc
- [ ] #17: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #18: [MFRD-LOOKUP] Matt frames-ready-for-dev lookup
- [ ] #19: [TXTBTN] Watch — TextButton primitive if 3+ inline-text-button instances appear in Phase 5
- [ ] #20: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] #21: [PROFILE-PRIM-SWEEP] Re-skin /profile/* legacy settings islands to vetted primitives [Opus]
- [ ] #22: [PRIM-COURSES-DISMISS] /courses "Dismiss recommendations" button is unvetted (uncovered interactive)

## Key Context

- **No code-repo work this conv** — code repo clean. Branch `jfg-dev-13-matt` unchanged.
- **Three durable artifacts landed** (committed this conv): `r-start/SKILL.md` Step 2.5; two memories (`feedback_no_tool_call_spam_loops.md`, `feedback_skill_body_stale_after_self_pull.md`); MEMORY.md gained a top-level **Tool-Call Discipline** section + a Skill Execution pointer.
- **Next r-start is the test:** the user wants to confirm the next `/r-start` is clean + quick (no spam loop) and that Step 2.5 fires correctly if the skill self-updates.
- **Recommended next work:** [PROFILE-PRIM-SWEEP] (#21) — closes the PRIM-REGISTRY thread M4Pro advanced in Conv 217 (W4: re-skin 5 `/profile/*` legacy islands, extract a shared Matt `<Switch>`).
- All tasks unchanged from Conv 217 (this conv added no feature tasks).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
