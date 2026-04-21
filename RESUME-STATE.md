# State — Conv 142 (2026-04-21 ~07:50)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Phase B code fixes landed green — [IO] partial unique index + `INSERT OR IGNORE`, [DF] `started_at` backfill centralized in `completeSession`, and [CT] new `detectOrphanedParticipants` BBB-authoritative cron pass. Admin cleanup endpoint + `CleanupSummary` extended with `orphaned_completed`. Staging cron Worker redeployed (`36fc5b5a-5d58-…`); now in the 1-week health-gate window before prod deploy. All 5 baseline gates green (tsc / astro check / lint / 6409-test suite / build).

## Completed

- [x] /r-start Conv 142 (10 tasks transferred from Conv 141)
- [x] [IO] Partial unique index `idx_session_attendance_open_unique` + `INSERT OR IGNORE` on `session_attendance`
- [x] [DF] `completeSession(…, durationSeconds?)` with `COALESCE` `started_at` backfill; threaded through `handleRoomEnded`
- [x] [CT] `detectOrphanedParticipants()` function in `src/lib/booking.ts`; wired into `runSessionCleanup` before `detectStaleInProgress`
- [x] `CleanupSummary.orphaned_completed[]` field + `counts.orphaned_completed`; admin endpoint response surfaces it
- [x] +11 tests across 3 suites (bbb.test.ts +4, booking.test.ts +6, cleanup.test.ts +1)
- [x] Redeployed `peerloop-cron-staging` — version `36fc5b5a-5d58-4a84-b431-55958b59b674`; schedule unchanged
- [x] Full baseline verified: tsc clean, astro check 0/0/0, full test suite 6409/6409, build 6.85s

## Remaining

- [ ] [PD] Prod cron Worker deploy [Opus] — `npm run deploy:cron:prod` + set prod BBB_SECRET. Now blocked only by staging health gate (1 full clean week from today's redeploy = 2026-04-28)
- [ ] [VH] Build webhook miss-resilience harness — Stripe direct-sign POST helper remaining (BBB portion done). Signature format: `t=<ts>,v1=<hmac-sha256(secret, ts+"."+payload)>`. Unblocks [VS].
- [ ] [VS] Stripe miss-resilience scenarios — 7 scenarios listed in Conv 141; blocked by [VH]
- [ ] [LE] `react-hooks/exhaustive-deps` rule not found in `MemberDirectory.tsx:141` — NEW; eslint config drift (rule plugin not registered or version mismatch); pre-existing, surfaced during Conv 142 baseline
- [ ] [PC] Audit /w-sync-skills pre-computed context generator (Conv 140 carryover)
- [ ] [CM] Codify confirmations-stand-unless-revoked pattern (Conv 140 carryover, watch-only)
- [ ] [TC] TEST-COVERAGE.md drift cleanup (Conv 140 carryover, cosmetic, 14 items)
- [ ] [SY] /w-sync-skills divergence detection (Conv 140 carryover)

## TodoWrite Items

- [ ] #6: [PD] Prod cron Worker deploy [Opus]
- [ ] #1: [VH] Build webhook miss-resilience harness
- [ ] #2: [VS] Stripe miss-resilience scenarios
- [ ] #11: [LE] react-hooks/exhaustive-deps rule missing in MemberDirectory.tsx:141
- [ ] #7: [PC] Audit /w-sync-skills pre-computed context generator
- [ ] #8: [CM] Codify confirmations-stand-unless-revoked pattern
- [ ] #9: [TC] TEST-COVERAGE.md drift cleanup
- [ ] #10: [SY] /w-sync-skills divergence detection

## Key Context

**Staging infrastructure (LIVE):**
- `peerloop-cron-staging` now running version `36fc5b5a-5d58-4a84-b431-55958b59b674` with Phase B fixes. Schedule `*/15 * * * *` unchanged. Do NOT redeploy unless fixing something — verify health with `npm run cf:tail:cron:staging`.
- 1-week health gate begins today (2026-04-21). Clean-week threshold for [PD]: 2026-04-28.

**Phase B architecture (now in staging):**
- `src/lib/cleanup.ts` `runSessionCleanup()` runs 4 passes in order: noShows → orphaned (BBB-auth, new) → staleInProgress (DB, +1h) → reconcileBBBSessions (BBB-auth + recording recovery). Strict narrowing cascade: each pass sees a smaller candidate set; once orphan-detect completes a session, reconcile sees it as `status = 'completed'` and skips the BBB API call.
- `detectOrphanedParticipants` requires BBB provider; silently skipped when `bbb` is null.
- Attendance rows force-closed with `left_at = scheduled_end` and per-row `duration_seconds` computed in JS.
- Admin endpoint `/api/admin/sessions/cleanup` response now includes `orphaned_completed[]` array.

**Schema invariant added (pre-launch, 0001_schema.sql):**
- `CREATE UNIQUE INDEX idx_session_attendance_open_unique ON session_attendance(session_id, user_id) WHERE left_at IS NULL` — at-most-one-open-attendance-row invariant. Paired with `INSERT OR IGNORE` in `handleParticipantJoined` to make duplicate webhook deliveries silent no-ops while still allowing legitimate rejoins (row closes → constraint no longer applies).

**completeSession signature changed:**
- `completeSession(db, sessionId, endedAt?, durationSeconds?)` — 5 call sites, only the BBB webhook's `handleRoomEnded` passes duration. Others degrade gracefully to `scheduled_start` via `COALESCE(started_at, ?)` in the UPDATE.

**New lint error surfaced (not introduced by this conv):**
- `src/components/discover/MemberDirectory.tsx:141` — `react-hooks/exhaustive-deps` rule not found. Likely eslint plugin registration drift. [LE].

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
