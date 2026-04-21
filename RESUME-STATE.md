# State — Conv 144 (2026-04-21 ~18:15)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 144 closed [VS] Stripe miss-resilience by live-verifying all 7 Stripe webhook scenarios against staging. The bigger outcome was uncovering and fixing a **production-blocking Stripe bug** (`constructEvent` → `constructEventAsync` — SubtleCryptoProvider sync-context failure on CF Workers since the Conv 114 migration; every Stripe webhook had been silently HTTP 400'd in staging). Fix deployed (version `254fa8e9`), 6409/6409 tests pass. Also codified **Stripe Mode Discipline** (local=Test, staging=Sandbox, prod=Live) as a durable project rule after confusion during secret rotation exposed that Peerloop's Stripe-mode model was undocumented.

## Completed

- [x] [VS] Stripe miss-resilience scenarios — all 7 scenarios LIVE verified on staging (S1–S7) with pre/post DB captures. Published under new §Stripe live-verified scenarios (Conv 144) table in `docs/as-designed/webhook-miss-resilience.md`
- [x] Production-blocker Stripe bugfix — `constructEvent` → `constructEventAsync` in `src/lib/stripe.ts` + `src/pages/api/webhooks/stripe.ts:64`. Deployed to staging (version `254fa8e9`). 6409/6409 tests pass
- [x] Stripe Mode Discipline decision — recorded in `docs/DECISIONS.md §8`; documented in `docs/reference/stripe.md` (new §Stripe Mode Discipline sidebar + §Staging + §Connected Accounts rewrites)
- [x] `scripts/trigger-webhook.sh` — 6 seed constants (`SESSION_ID`/`TEACHER_ID`/`STUDENT_ID`/`COURSE_ID`/`CREATOR_ID`/`TEACHER_CERT_ID`) now env-overridable
- [x] Stripe Dashboard staging webhook endpoint URL fix (`pages.dev/api/webhooks/` → `workers.dev/api/webhooks/stripe`) + re-enabled + secret rotated (old immediate-expired)
- [x] `PLAN.md §MVP-GOLIVE.STAGING-VERIFY` updated — [VS] checked off, [VD]/[VW]/[VA]/[VL] added, bugfix logged
- [x] Timeline: 3 entries added (constructEventAsync fix, Stripe Mode Discipline decision, 7-scenario live verification)
- [x] `docs/reference/SCRIPTS.md` + `DEVELOPMENT-GUIDE.md` — docs-agent added Workers-vs-Node runtime split notes + harness env-var override usage

## Remaining

### Conv 144 Phase B follow-ups (Stripe hardening)
- [ ] [VD] Pre-check (student, course) in handleCheckoutCompleted [Opus] — production bug: SQLITE_CONSTRAINT_UNIQUE → HTTP 500 → Stripe retry storm when a fresh `pending_enrollment_id` collides with an already-enrolled (student, course) pair. Add early-return guard on `(student_id, course_id)` dedup, log distinctive admin-alert warning. See webhook_log entry `a5209fca-45a3-41cb-bf92-e6e28b3a5ec6`
- [ ] [VW] Wrap webhook_log INSERT in ctx.waitUntil() (Stripe + BBB) — fire-and-forget INSERT races Worker termination in short-path handlers (discovered S7 default-case). Low impact today (forensics-only), high impact if dedup-by-event-id is ever added. Applies to `src/pages/api/webhooks/stripe.ts:75-80` and likely `src/pages/api/webhooks/bbb.ts`
- [ ] [VA] Audit staging Worker `STRIPE_SECRET_KEY` is Sandbox-scoped — mode-split risk: if Worker verifies Sandbox-signed webhooks but calls Test-mode API, `stripe.transfers.list()` in refund/dispute paths silently returns empty and reversals never run
- [ ] [VL] Rotate leaked `sk_test_...PP6iSq` Test-mode API key — hygiene. Test-mode only; does NOT affect Sandbox or Live. Conv 144 transcript leak via `stripe config --list`

### Documentation follow-up
- [ ] [FD] Extend `feedback_no_paste_tokens_in_chat.md` for Claude-initiated diagnostic leaks — existing memory covers user-paste; Conv 144 exposed the adjacent pattern of unredacted `od -c`, `stripe config --list`, `env`, `wrangler secret list --json` dumps. Add concrete safe-vs-unsafe examples

### Carryover (Conv 143 artifacts)
- [ ] [HV] Add HMAC-over-JSON verification pattern note — document wrapper-script pattern from Conv 143's 3 failed attempts in `docs/as-designed/webhook-miss-resilience.md`
- [ ] [EG] Document ESLint v10 unknown-rule gotcha — unknown rules in disable comments are hard errors in v10 (silent pre-v10). Add to PACKAGE-UPDATES notes
- [ ] [LE-TRIAGE] Triage 31 react-hooks/exhaustive-deps warnings across 26 files — hottest: `ExploreAllTab.tsx` (3), `MyStudents.tsx`/`CommunityAllTab.tsx`/`ExploreFeeds.tsx` (2 each)

### Carryover (Conv 140 artifacts)
- [ ] [CM] Codify confirmations-stand-unless-revoked pattern — watch-only
- [ ] [TC] TEST-COVERAGE.md drift cleanup — cosmetic, 14 items
- [ ] [PC] Audit /w-sync-skills pre-computed context generator
- [ ] [SY] /w-sync-skills divergence detection

### Blocked
- [ ] [PD] Prod cron Worker deploy [Opus] — blocked by 1-week staging health gate until **2026-04-28** (earliest). Staging cron clean since Conv 141; production deploy unlocks when gate clears

## TodoWrite Items

- [ ] #1: [PD] Prod cron Worker deploy [Opus] — `npm run deploy:cron:prod` + set prod BBB_SECRET. Blocked until 2026-04-28
- [ ] #3: [LE-TRIAGE] Triage 31 react-hooks/exhaustive-deps warnings
- [ ] #4: [HV] Add HMAC-over-JSON verification pattern note to webhook-miss-resilience.md
- [ ] #5: [EG] Document ESLint v10 unknown-rule gotcha in PACKAGE-UPDATES notes
- [ ] #6: [CM] Codify confirmations-stand-unless-revoked pattern
- [ ] #7: [TC] TEST-COVERAGE.md drift cleanup (cosmetic, 14 items)
- [ ] #8: [PC] Audit /w-sync-skills pre-computed context generator
- [ ] #9: [SY] /w-sync-skills divergence detection
- [ ] #10: [VL] Rotate leaked sk_test_ Test-mode key (hygiene)
- [ ] #11: [VA] Audit staging Worker STRIPE_SECRET_KEY mode
- [ ] #12: [VD] Pre-check (student, course) in handleCheckoutCompleted [Opus]
- [ ] #13: [VW] Wrap webhook_log INSERT in ctx.waitUntil() (Stripe + BBB)
- [ ] #14: [FD] Extend feedback_no_paste_tokens_in_chat.md for Claude-initiated diagnostic leaks

## Key Context

**constructEventAsync fix — will be committed in Step 6 of /r-end:**
- `src/lib/stripe.ts` `constructWebhookEvent` — `async`, delegates to `stripe.webhooks.constructEventAsync()`
- `src/pages/api/webhooks/stripe.ts:64` — `await` added on the call
- Deployed to staging as version `254fa8e9` BEFORE this /r-end commit lands. The commit brings the code repo up to the state already running in staging
- Same bug is presumed live in PROD Worker (if ever deployed); verify before go-live that prod Worker version includes the fix

**Stripe Sandbox vs Test Mode confusion:**
- CLI's `stripe login` defaults to Test mode; Sandbox requires re-auth into the Sandbox workbench
- `stripe trigger` fires Test-mode events that do NOT reach Sandbox endpoints — use direct-sign harness for Sandbox verification
- All three modes use `sk_test_` / `pk_test_` prefixes (Test + Sandbox both) — the Dashboard's `Alpha Peer LLC sandbox` banner is the only visual distinguisher
- Hard rule enforced: every `.dev.vars*` + every `wrangler secret put --env <x>` is single-mode

**Harness improvements shipped (will be committed in Step 6):**
- `scripts/trigger-webhook.sh` — 6 seed constants now env-overridable via `${VAR:-default}` pattern
- S1 on staging must use a non-seed-enrolled (student, course) pair — e.g. `STUDENT_ID=usr-jennifer-kim` + `COURSE_ID=crs-intro-to-n8n` works because Jennifer has only `enr-jennifer-claude-code`, not n8n

**Conv 144 production bugs found:**
- [VD] `(student, course)` UNIQUE collision → HTTP 500 → Stripe retry storm. The DB raw error was `D1_ERROR: UNIQUE constraint failed: enrollments.student_id, enrollments.course_id`. Handler dedupes on `pending_enrollment_id` only
- [VW] `webhook_log` fire-and-forget INSERT at `stripe.ts:75-80` races Worker termination in short-path handlers

**Diagnostic patterns established:**
- `wrangler tail --env staging` is FIRST diagnostic for opaque 5xx on deployed Workers, not last-resort
- Staging re-seed (`npm run db:setup:staging:dev`) gives known baseline for multi-scenario verification
- For Stripe-side verification: direct-sign harness (`scripts/trigger-webhook.sh` with `ENV_TARGET=staging`) is the definitive tool; Stripe CLI + `stripe trigger` requires correct mode auth and is fragile

**Secret leaks in Conv 144 transcript (all rotated/contained):**
- `whsec_dc1e8988…` — partial (first 16 chars) of old webhook secret via `od -c`. Key has since been rotated, old expired immediate. Prefix has no remaining blast radius
- `sk_test_…PP6iSq` — full Test-mode API key via `stripe config --list`. Test mode only (not Sandbox, not Live). Tracked in [VL] for rotation as hygiene

**Priority queue for Conv 145** (after any /r-start carry-forward processing):
1. [VD] + [VW] — natural webhook-hardening pair, both Conv 144 findings
2. [VA] — quick 10-min Worker secret-mode audit
3. [VL] — 5-min Stripe Dashboard rotation (user-driven)
4. [FD] — feedback memory extension (15 min doc work)
5. [HV], [EG], [LE-TRIAGE] — Conv 143 carryovers
6. [CM], [TC], [PC], [SY] — Conv 140 carryovers
7. [PD] — earliest 2026-04-28 when staging health gate clears

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
