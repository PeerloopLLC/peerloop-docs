# State — Conv 143 (2026-04-21 ~09:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Two closed tasks: [VH] Stripe direct-sign POST helper (7 event commands + `stripe-direct-raw` escape hatch, SDK-verified signing + end-to-end delivery smoke-tested via local capture server) and [LE] eslint-plugin-react-hooks registration (rules-of-hooks: error, exhaustive-deps: warn; 0 errors, 31 warnings surfaced across 26 files as future triage work). [VS] is now unblocked; harness is pure data-capture work for it.

## Completed

- [x] /r-start Conv 143 (8 tasks transferred from Conv 142)
- [x] [VH] Stripe direct-sign POST helper — 7 event commands + `stripe-direct-raw` escape hatch; SDK-verified signing + end-to-end delivery proof
- [x] [LE] `react-hooks/exhaustive-deps` rule registration — `eslint-plugin-react-hooks@^7.1.1` installed, `rules-of-hooks: error` + `exhaustive-deps: warn`, baseline green (0 errors, 31 warnings)
- [x] Docs updated: `webhook-miss-resilience.md` (harness table), `SCRIPTS.md` (agent-added), `DEVELOPMENT-GUIDE.md` (new ESLint section, agent-added)
- [x] PLAN.md updated: [VH] checked off in §MVP-GOLIVE.STAGING-VERIFY; [LE-TRIAGE] added to §POLISH.TECHNICAL_DEBT

## Remaining

- [ ] [PD] Prod cron Worker deploy [Opus] — blocked by staging health gate until 2026-04-28
- [ ] [VS] Stripe miss-resilience scenarios — UNBLOCKED Conv 143; run 7 `-direct` commands against staging, capture pre/post DB state, update webhook-miss-resilience.md
- [ ] [LE-TRIAGE] Triage 31 react-hooks/exhaustive-deps warnings across 26 files — hottest: `ExploreAllTab.tsx` (3), `MyStudents.tsx`/`CommunityAllTab.tsx`/`ExploreFeeds.tsx` (2 each)
- [ ] [HV] Add HMAC-over-JSON verification pattern note to webhook-miss-resilience.md (document the wrapper-script pattern from Conv 143's 3 failed attempts)
- [ ] [EG] Document ESLint v10 unknown-rule gotcha in PACKAGE-UPDATES notes
- [ ] [CM] Codify confirmations-stand-unless-revoked pattern (Conv 140 carryover, watch-only)
- [ ] [TC] TEST-COVERAGE.md drift cleanup (Conv 140 carryover, cosmetic, 14 items)
- [ ] [PC] Audit /w-sync-skills pre-computed context generator (Conv 140 carryover)
- [ ] [SY] /w-sync-skills divergence detection (Conv 140 carryover)

## TodoWrite Items

- [ ] #1: [PD] Prod cron Worker deploy [Opus] — `npm run deploy:cron:prod` + set prod BBB_SECRET. Blocked by 1-week staging health gate (clean since 2026-04-21).
- [ ] #3: [VS] Stripe miss-resilience scenarios — 7 scenarios in `docs/as-designed/webhook-miss-resilience.md` §Stripe events. [VH] complete; harness commands ready. Run each against staging with seed-data IDs and capture pre/post DB state.
- [ ] #5: [PC] Audit /w-sync-skills pre-computed context generator
- [ ] #6: [CM] Codify confirmations-stand-unless-revoked pattern
- [ ] #7: [TC] TEST-COVERAGE.md drift cleanup (cosmetic, 14 items)
- [ ] #8: [SY] /w-sync-skills divergence detection
- [ ] #9: [LE-TRIAGE] Triage 31 react-hooks/exhaustive-deps warnings
- [ ] #10: [HV] Add HMAC-over-JSON verification pattern note to webhook-miss-resilience.md
- [ ] #11: [EG] Document ESLint v10 unknown-rule gotcha in PACKAGE-UPDATES notes

## Key Context

**Harness commands shipped (will be committed in Step 6):**
- `scripts/trigger-webhook.sh` — `load_stripe_secret()`, `generate_stripe_signature()`, `send_stripe_webhook()` helpers
- 7 per-event commands: `stripe-checkout-direct`, `stripe-refund-direct`, `stripe-dispute-created-direct`, `stripe-dispute-closed-direct`, `stripe-account-updated-direct`, `stripe-transfer-created-direct`, `stripe-transfer-reversed-direct`
- `stripe-direct-raw <type> <json-file|->` escape hatch
- Env-var overrides: `CHARGE_ID`, `DISPUTE_ID`, `DISPUTE_STATUS`, `ACCOUNT_ID`, `PEERLOOP_USER_ID`, `TRANSFER_ID`, `AMOUNT`, etc. (see each case in the script)
- Signing: `t=<unix_ts>,v1=<hex_hmac_sha256(secret, "<ts>.<raw_payload>")>` — verified against `stripe.webhooks.constructEvent()` Conv 143

**Lint baseline (will be committed in Step 6):**
- `eslint-plugin-react-hooks@^7.1.1` installed as devDep
- `eslint.config.js` registers plugin; `rules-of-hooks: error`, `exhaustive-deps: warn`
- 0 errors, 31 warnings, exit 0. The one disable comment in `MemberDirectory.tsx:141` now valid.
- 31 warnings distribution: see `docs/sessions/2026-04/20260421_0924 Extract.md §Changes` for full file tally; hottest: `ExploreAllTab.tsx` (3)

**ESLint v10 gotcha:**
- Unknown rules in disable comments are hard errors in v10 (silent-ignored pre-v10). Applies to anyone reviewing other disable-comment references in the codebase — grep with plugin registry to find more.

**Harness verification technique (from [VH]):**
- To HMAC a JSON payload through a shell layer, NEVER interpolate the JSON into a double-quoted bash command. Use a wrapper script that reads the payload via stdin (`cat`) so no shell quote-parsing touches the signing input. Node `spawnSync('bash', [wrapper], { input: PAYLOAD })` was the pattern that worked.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
