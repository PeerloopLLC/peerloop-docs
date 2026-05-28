# STRIPE-E2E-DEV — Dev-level Stripe E2E stress test

**Focus:** End-to-end Stripe integration stress test run at the Dev level — real browser, real Test-mode cards, real `stripe listen` webhook tunnel — as a rehearsal before Staging and Prod rollouts
**Status:** 📋 DEFERRED — scoped Conv 145, ready for Plan Mode
**Priority:** High — prerequisite for go-live confidence
**Origin:** Conv 145 [VD/VW/VA/VL] drain pass exposed that our existing confidence in Stripe rests on three disjoint surfaces (unit tests, harness-driven direct-sign webhook replay, one-time staging live-verification). None of them covers the "real user in a real browser with real card input routing to a real tunnel" path. That's the gap this block closes.

## Why this block exists

Conv 144 proved that integration-level Stripe bugs are real, non-theoretical, and can hide for months:
- `constructEvent` → `constructEventAsync` on CF Workers — every staging webhook had been HTTP 400'd for ~8 weeks before live-verification caught it
- `(student, course)` UNIQUE collision on duplicate-purchase — would have been a retry storm in production
- `webhook_log` INSERT racing Worker termination on short-path handlers — forensics-critical data loss

Each of those surfaced only when a real webhook hit a real handler in a real environment. Unit tests with mocks couldn't see them. The harness direct-sign tool is good for scenario-matrix coverage but can't catch runtime-specific bugs. The staging live-verification is high-value but expensive (needs deploy + Sandbox Dashboard setup + secret rotation discipline) and therefore rare — once per block, roughly.

Dev-level E2E fills the rapid-iteration slot: fix a bug, rerun the scenario in under 2 minutes, no deploy, no shared state, no coordination. That's what turns "probably works" into "demonstrably works" at the velocity of normal development.

## Current confidence surface (as of Conv 145)

| Surface | Coverage | Misses |
|---|---|---|
| Vitest unit tests (`tests/api/webhooks/stripe.test.ts`, 18 tests) | Handler logic with mocked Stripe SDK | Runtime bugs (async/sync crypto), frontend integration, real Stripe event shapes, DB sequence effects |
| Harness direct-sign replay (`scripts/trigger-webhook.sh`) | Signature verification + handler dispatch for 7 event types locally and on staging | Real card-entry UI, real Checkout session state, connected-account onboarding, dispute lifecycle |
| Staging live-verification (Conv 144, 7 scenarios S1–S7) | Real Worker runtime + real Sandbox Stripe + real webhook tunnel | One-shot, not CI-gated; requires deploy cycle; rare to re-run; no browser-driven UI step |
| `/api/admin/stripe-mode` diagnostic (Conv 145 [VA]) | Mode alignment at any time, for any env with the endpoint deployed | Doesn't exercise the payment flow itself |

**What nothing on this list covers**: a student clicks Enroll on the course page → arrives at Stripe Checkout → types `4242 4242 4242 4242` → returns to `/success` → the success page SSR self-heals → enrollment appears in the app navigation → an email gets sent. That full-stack path is the actual production user flow, and today it has zero automated coverage.

## What Dev E2E testing buys us — and why it matters for Staging and Live

The value chain is three-layered:

**Dev layer (this block):** high-fidelity, low-cost, fast iteration
- Catches handler-integration bugs that unit tests can't see (wrong redirect URL, missing DB field, silent failure in error path, race conditions between webhook handler and success-page SSR)
- Exercises the *browser-to-Stripe-to-handler-to-DB-to-UI* loop in its entirety
- Makes edge cases cheap to probe: declined cards, dispute cards, 3DS-required cards, expired cards, zero-decimal currencies
- Anyone on the team can reproduce a reported bug locally in minutes
- Shared vocabulary: "run scenario S4" becomes a thing people say, not a thing they reinvent

**Staging layer (already established by Conv 144):** Worker runtime + real Stripe infrastructure
- Catches bugs that only appear in the Cloudflare Worker runtime (SubtleCryptoProvider, execution time limits, `waitUntil` lifecycle)
- Validates secret-slot discipline (STRIPE_SECRET_KEY ↔ STRIPE_WEBHOOK_SECRET alignment within the Sandbox workbench)
- Exercises the direct-to-Stripe webhook delivery path without a local tunnel in between
- Expensive per run — deploy cycle, Sandbox Dashboard setup, secret rotation discipline — so typically one full pass per significant Stripe change

**Live layer (future go-live):** real money, real customers, one-shot
- The $1 real-charge smoke test during go-live is the final verification
- No acceptable failure rate for integration bugs — customer trust is set by their first interaction
- Anything caught here is a reputation-damaging incident, not a bug report

**The compounding effect:** each layer catches a different class of issue. Dev layer catches *functional* issues cheaply; Staging layer catches *runtime / infrastructure* issues at moderate cost; Live layer is the final confirmation. Skipping the Dev layer means functional bugs get caught at Staging cost or (worse) Live cost. The Conv 144 bugs that hid for 8 weeks are a preview of how much you pay for a missing Dev-layer tier.

**What this block does NOT replace:**
- The 18 unit tests (different abstraction, sub-second feedback)
- The staging live-verification pass (different infrastructure, Worker-specific)
- The eventual Live $1 smoke test during go-live cutover

## Scope tiers (pick one as MVP, layer others later)

**Tier A — Paper walkthrough** (~60 min, docs only)
- New `docs/guides/stripe-dev-e2e.md` with prerequisite checklist, 11 numbered scenarios (see table below), expected DB state + verification query for each, screenshot checkpoints, troubleshooting table
- Test-card appendix (the 6 standard Stripe magic numbers: success `4242…`, decline `4000…0002`, insufficient funds `4000…9995`, 3DS-required `4000…3155`, dispute `4000…9979`, expired `4000…0069`)
- `stripe trigger` recipe appendix for CLI-synthesized events (dispute flow specifically)

**Tier B — Scripted orchestrator** (adds ~90 min on top of A, one new script)
- `scripts/dev-stripe-smoke.sh` automates the deterministic scenarios (direct-signed `checkout.session.completed` → verify DB → direct-signed `charge.refunded` → verify DB → etc.), leveraging existing `scripts/trigger-webhook.sh`. Manual UI-driven steps (real card payment, real onboarding) stay manual.

**Tier C — Playwright E2E suite** (~half-day, new test files)
- `tests/e2e/stripe-smoke.spec.ts` drives a real browser against `npm run dev:webhooks`. Stripe Checkout iframe interaction is the tricky part. Flagged as `describe.skip` in CI by default (requires live Stripe CLI auth) but runnable locally via `npm run test:e2e:stripe`.

**Tier D — Claude-MCP-driven interactive verification** (new idea surfaced Conv 145)
- Claude drives Chrome via the claude-in-chrome MCP bridge, starts `stripe listen` as a background process, walks through scenarios, produces a pass/fail report with screenshots. Not CI-grade; session-grade. Lets a human ask "verify scenario S6 still works" and get a report in ~5 minutes without writing or running test code themselves. Feasibility hinges on whether the MCP bridge handles Stripe's cross-origin iframes cleanly — unknown until tried.

## Scenarios to cover (minimum set, 11 rows)

| # | Scenario | Driver | Webhook(s) | DB effect to verify | Notes |
|---|---|---|---|---|---|
| 1 | Creator onboarding happy path | Browser + Stripe Express form | `account.updated` | `users.stripe_account_status='active'`, `stripe_payouts_enabled=1` | Requires completing Stripe Connect Express UI in Test mode |
| 2 | Enrollment, valid card | Browser + card `4242…` | `checkout.session.completed` → `transfer.created` (platform) | New rows in `enrollments`, `transactions`, `payment_splits` (2-3 per enrollment); course `student_count++` | Happy path — most common real flow |
| 3 | Enrollment, declined card | Browser + card `4000…0002` | None (Stripe declines before session completes) | No DB change | User sees error in Checkout UI |
| 4 | Enrollment, 3DS-required | Browser + card `4000…3155` | `checkout.session.completed` (after 3DS challenge) | Same as #2 | Exercises the 3DS flow real European traffic will use |
| 5 | Full refund | Admin UI | `charge.refunded` | `enrollments.status='cancelled'`, `transactions.status='refunded'`, `payment_splits.status='reversed'`; Stream unfollow | Admin-initiated from `/admin/payments` |
| 6 | Partial refund | Admin UI | `charge.refunded` | `transactions.status='partially_refunded'`, enrollment stays active | Admin 50% refund |
| 7 | Dispute created | Card `4000…9979` or `stripe trigger` | `charge.dispute.created` | `enrollments.status='disputed'`, `transactions.status='disputed'`, admin notification created | Duplicate-purchase [VD] guard also applies here — student stays disputed if they try to re-enroll |
| 8 | Dispute won | `stripe trigger charge.dispute.closed` | `charge.dispute.closed` (status=won) | Enrollment restored to `'enrolled'`, transaction `'completed'` | Requires CLI-synthesized event |
| 9 | Dispute lost | `stripe trigger` + Dashboard update | `charge.dispute.closed` (status=lost) | Enrollment cancelled, transfers reversed, admin notification | Exercises the full transfer-reversal path |
| 10 | Account status change → restricted | Sandbox Dashboard action | `account.updated` | `users.stripe_account_status='restricted'` | Disable payouts in Sandbox test-account settings |
| 11 | Self-healing path (webhook miss) | Browser + simulated webhook drop | — (no event) | `/api/stripe/verify-checkout` + success.astro SSR heal create the enrollment on success-page load | Verifies the Session 324 self-heal fallback still works; simulate by stopping `stripe listen` right before completing checkout, then restarting + visiting `/success` |

## Pre-requisites / preconditions this block needs

- [ ] Local D1 seeded with `db:setup:local:stripe` — produces at least one Creator with Test-mode `stripe_account_id`, at least one Teacher with a certification, at least one priced course (`price_cents > 0`)
- [ ] Stripe CLI authenticated to Test mode — `stripe login` into the default workbench, not Sandbox. CLI config currently in state verified Conv 145 [VL]
- [ ] `.dev.vars` holds Test-mode `sk_test_` / `pk_test_` + current `whsec_` from `stripe listen` (stable per-machine — changes only on re-auth)
- [ ] No second `stripe listen` process running (two tunnels compete for the same account's events)
- [ ] `/api/admin/stripe-mode` endpoint (Conv 145 [VA]) is available on Dev — trivially so, since it's in `src/pages/api/admin/` — for parallel diagnostic use during testing

## Open questions for Plan Mode

1. **Which tier is the right MVP?** Default recommendation: Tier A (paper walkthrough) — highest leverage per hour, foundation for the others, surfaces ambiguities a script would otherwise have to resolve. B and C and D can layer on.
2. **Does the Chrome MCP bridge handle Stripe Checkout iframes?** Answer is unknown until we try. If yes, Tier D becomes very attractive (Claude-driven rehearsals on demand). If no, fallback is `stripe trigger` for the webhook step with browser only for pre-checkout and post-success.
3. **Do we repeat the full matrix on Sandbox (staging) after Dev passes?** Conv 144 did scenarios S1–S7 on Sandbox; this block would add 4 more (onboarding, 3DS, partial refund, self-heal). Staging matrix should grow to match, but schedule (before each Stripe-touching PR? monthly? pre-go-live only?) is a Plan Mode question.
4. **Do we need a Dev counterpart to `/api/admin/stripe-mode` for webhook-secret verification?** An endpoint that returns the currently-loaded `STRIPE_WEBHOOK_SECRET` *hash* (not value) would let us verify `stripe listen`'s whsec matches `.dev.vars` without a diff on the filesystem. Marginal value; flag for discussion.
5. **Does Stripe Dashboard's Test-mode-into-Sandboxes-listing UI change (noted Conv 145 [VA] screenshot) require any doc updates before we write the walkthrough?** Probably a one-paragraph note in the Tier A prerequisites section, but worth verifying current state against the doc before writing.
6. **Is there value in adding `charge.succeeded` and `payment_intent.succeeded` to the coverage matrix?** Current handler doesn't subscribe to them (handler uses `checkout.session.completed` as the creation trigger), but Stripe fires them too. Plan Mode should decide: ignore, observe-only, or wire them up.
7. **Seed-data sensitivity:** the existing `stripe` seed (`migrations-dev/0002_seed_stripe.sql`) pre-fills `stripe_account_id` values for seed Creators. Are these real Test-mode `acct_...` that work against the current Test-mode workbench, or fake strings? If fake, #1 onboarding is the actual first step for every fresh Dev setup — which reshapes the walkthrough.

## Risks / unknowns flagged for Plan Mode

- 🟠 **Stripe Checkout iframe automation** untested with claude-in-chrome MCP — may force Tier D into a hybrid browser/CLI shape
- 🟠 **`stripe trigger`'s payloads are generic**, not tied to real charges — scenarios #8 and #9 may require Sandbox-side dispute-state manipulation to produce realistic test state
- 🟠 **Connected-account webhook testing** (e.g., `payout.failed`) needs `stripe listen --forward-connect-to` separately — either second tunnel or different URL routing. Currently deferred in `stripe.md` as "requires separate Connected-accounts webhook endpoint"
- 🟠 **Dispute-card `4000…9979` timing** — Stripe normally takes minutes to fire `charge.dispute.created` after a dispute card is used; the walkthrough should note the expected latency so scenarios don't look "stuck"
- 🟢 **Cost:** Test-mode charges are free — no real-money risk at any point

## Exit criteria

**Minimum (Tier A):**
- `docs/guides/stripe-dev-e2e.md` exists, covers all 11 scenarios, has been run end-to-end by at least one team member with pass notes attached
- Every scenario has a documented expected DB state + verification query + at least one screenshot

**Stretch (Tier B/C/D):**
- Tier B scripted orchestrator produces green for 5 consecutive runs across 2 days
- Tier C Playwright suite runs clean locally, `describe.skip` gate in CI documented
- Tier D: a Claude-driven interactive session successfully walks through ≥ 6 of 11 scenarios with screenshot trail

**Confidence signal:** after this block, the answer to "would we be comfortable doing the go-live $1 smoke test today?" shifts from "mostly, but we'd double-check things" to "yes — we have a rehearsal we've run end-to-end".

## References

- `docs/DECISIONS.md §8 Stripe Mode Discipline` — the env × mode mapping
- `docs/reference/stripe.md §Stripe Mode Discipline (CRITICAL)`, `§Per-Environment Webhook Configuration`, `§Connected Accounts Are Per-Mode AND Per-Environment`
- `docs/as-designed/webhook-miss-resilience.md` — Stripe events + Conv 144 live-verified S1–S7 scenarios (starting point for our 11-scenario matrix)
- `scripts/dev-webhooks.sh` + `scripts/trigger-webhook.sh` — existing Dev harness
- `scripts/check-env.sh` — Dev prerequisite validator (called by `dev-webhooks.sh`)
- `tests/api/webhooks/stripe.test.ts` — 18 unit tests; don't duplicate this coverage
- `src/pages/api/webhooks/stripe.ts` + `src/lib/enrollment.ts` — current handler entry points (post-Conv 145 [VD]/[VW])
- `src/pages/api/admin/stripe-mode.ts` (Conv 145 [VA]) — the mode-diagnostic endpoint to call during/before each scenario
- Conv 144 Extract + Conv 145 Extract — the integration-bug history this block is designed to prevent repeating
