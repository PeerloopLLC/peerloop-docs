# State — Conv 287 (2026-06-15 ~09:35)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Picked up the E2E pair (#10 → #11). Fixed and committed **10 of 55** e2e failures (commit `45582070`): seed-data-verification 10→14/14 (system-feed admin-only per Conv 259 + Sarah's intentional in-progress n8n enrollment — both verified vs code+seed), admin-overview 5→6/6 + auth-dashboard + browse-enroll login bucket routed through the shared `login()` helper, plus a stale `current-user.ts` doc-comment fix. Full-suite run revealed E2E-MIG is far larger than the carried-forward "10/14" implied (55 failures). Per user decision, **checkpointed the 10 fixes and deferred the ~45 UI-structure-drift residual**. 27 tasks remain + 1 new (MEM-PRUNE).

## Completed

- [x] [E2E-MIG] partial — 10/55 e2e failures fixed + committed (`45582070`); seed-data 14/14, admin-overview 6/6, login bucket → shared helper, current-user.ts doc-comment
- [x] r-start task transfer (27) + conv-tasks.md regen + RESUME-STATE delete

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #3 [Opus] — port ~89 legacy /old/* → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED profile cluster)
- [ ] [ICN-NS] #9 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [E2E-MIG] #10 — **residual ~45 UI-structure-drift failures** across ~17 specs. Bucket A = already-shipped route-migration/Matt-restyle drift (fixable now: browse lost 'Courses' heading, /learning lost h1 'My Learning', feeds-hub/settings/profiles/discovery/course-detail/my-feeds-card etc.). Bucket B = ROLE-STUDIOS-coupled dashboard headings (HELD until #2 unblocks — fixing now = false-green re-churn). Also 1 parallel-contamination flake: seed-data:489 passes isolated, fails under full parallel load (needs DB headroom). Full residual map in task #10 description.
- [ ] [E2E-GATE] #11 — ⛔ transitively blocked: can't add e2e to baseline gate until suite green (needs E2E-MIG complete + ROLE-STUDIOS shipped)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23
- [ ] [COMMONS-DATE] #24 · [DISCCARD-DEL] #25 · [FEED-LANE-RENDER] #26 · [STREAM-PURGE] #27
- [ ] [MEM-PRUNE] #28 — run /r-prune-memory; MEMORY.md at 80% of SessionStart auto-load cap (20404/25600 bytes)

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] · #2 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [SSR-LOADER-DEAD] · #5 [CT-RESTYLE] · #6 [PRIM-MATCH-INDEX] · #7 [TXTBTN] · #8 [PROFILE-PRIM-SWEEP] · #9 [ICN-NS] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [SHOWMORE] · #13 [PREFLIP-WT] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [OLD-PORTED-CLEANUP] · #17 [LEARN-ISLAND-RESTYLE] · #18 [CREATE-ISLAND-RESTYLE] · #19 [TEACH-ISLAND-RESTYLE] · #20 [TRIAGE-RESTYLE] · #21 [V217-WATCH] · #22 [COURSEDETAIL-DEAD] · #23 [NUDGE-CACHE-FLASH] · #24 [COMMONS-DATE] · #25 [DISCCARD-DEL] · #26 [FEED-LANE-RENDER] · #27 [STREAM-PURGE] · #28 [MEM-PRUNE]

## Key Context

- **E2E-MIG fix strategy (proven this conv):** failing assertions were stale tests, NOT app bugs. System feed is admin-only since SYS-RENAME (Conv 259) — `current-user.ts:630` `if (systemFeed && this.isAdmin)`; non-admins get 0 system feeds. Sarah has an intentional in-progress n8n enrollment (`migrations-dev/0001_seed_dev.sql:374` + `:1048` enrolled_at bump). Verify against code+seed before editing any test.
- **Login bug pattern:** `getByLabel('Password')` hits a strict-mode violation (the "Show password" toggle shares the aria-label). Fix = route through shared `e2e/helpers.ts` `login()` (uses `getByPlaceholder('Enter your password')`). Conv 286 fixed the helper; Conv 287 fixed 3 inline copies. Grep `grep -rln "getByLabel('Password')" e2e/` — now only helpers.ts (intentional).
- **e2e run recipe:** `cd ../Peerloop && npm run db:setup:local:dev` then `npx playwright test [spec] --reporter=line`. Dev server auto-starts/reuses on :4321. Full suite ~3.7m. Re-seed before full runs (parallel write-contamination headroom).
- **NOT re-verified this conv:** the 5 baseline gates (tsc/astro/lint/vitest/build). Only the changed e2e specs were run. e2e is excluded from the vitest gate.
- **Baseline carry-forward (unchanged from Conv 286, not re-verified this conv):** vitest 401 files / 6742 cases green.
- **Decision routed:** docs/decisions/06-testing-ci.md (don't update test expectations to match in-flight UI).
- **Changes committed at Step 6 (this r-end):** docs repo only — RESUME-STATE, session files, PLAN.md note, decisions routing, conv-tasks. Code repo already clean (E2E fixes in `45582070`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
