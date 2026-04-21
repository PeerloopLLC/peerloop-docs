# Webhook Miss-Resilience

**Type:** Architecture / Operational Readiness
**Status:** 🚧 IN PROGRESS — Phase A (verification-only, Conv 141). No code fixes in this pass.
**Created:** 2026-04-20
**Related:** `docs/reference/stripe.md`, `docs/reference/bigbluebutton.md`, `PLAN.md §MVP-GOLIVE.STAGING-VERIFY`, `../Peerloop/scripts/trigger-webhook.sh`

---

## Purpose

Catalog every Stripe and BBB webhook event the platform consumes, document whether the system can heal if a webhook is **missed** (never arrives, or arrives after long delay), and record what was actually verified on staging vs. what was established only by code inspection.

The output of this document drives two follow-up blocks:
- `[VF]` / `BBB-FIX` — BBB-specific fixes (cron triggers, one-sided-crash timeout, etc.)
- A future Stripe fixes block — catch-up polling for refunds, disputes, payouts; missing handlers

---

## Methodology

**Target environment:** `peerloop-staging` Worker at `https://peerloop-staging.brian-1dc.workers.dev` (seeded via `npm run db:setup:staging:dev`, fixtures match local dev per `migrations-dev/0001_seed_dev.sql`).

**Harness:** `scripts/trigger-webhook.sh` extended Conv 141 to accept `ENV_TARGET=staging`, reading credentials + base URL from `.dev.vars.staging` (gitignored; template in `.dev.vars.staging.example`).

**Verification rows are labeled:**
- **✅ LIVE** — scenario actually executed against staging; DB pre/post state captured.
- **📖 CODE** — path exists in code but not exercised end-to-end in this pass (typically needs real BBB meeting/Stripe event, or a fix to land first).
- **❌ MISSING** — no healing path exists today; documented as a gap.

**Idempotency tests** fire the same webhook twice and assert the second fire is a no-op on mutable fields (e.g. `ended_at` does not change).

**Miss tests** would fire no webhook, then invoke the healing trigger (admin endpoint, SSR page load, or cron) and assert DB converges. Several miss tests remain deferred — see §Untested Scenarios below.

---

## BBB Events

| Event | Handler | Idempotent? | Healing if missed | Healing trigger | Verified? |
|-------|---------|-------------|-------------------|-----------------|-----------|
| `room_started` | `src/pages/api/webhooks/bbb.ts` | ✅ `UPDATE … WHERE status='scheduled'` guard | ❌ None — session stays `scheduled` if webhook lost | — | 📖 CODE — no healing to verify |
| `room_ended` / `meeting-ended` | `src/pages/api/webhooks/bbb.ts` → `completeSession()` in `src/lib/booking.ts` | ✅ `completeSession()` returns early if already `completed` | ✅ `reconcileBBBSessions()` queries BBB `getMeetingInfo()`; completes inactive meetings | **Manual** — admin hits `/api/admin/sessions/cleanup` (no cron) | ✅ LIVE (delivery + idempotency); 📖 CODE (miss path) |
| `participant_joined` | `src/pages/api/webhooks/bbb.ts` → `session_attendance` INSERT | ⚠️ Naive INSERT — duplicate rows on re-delivery (non-fatal) | N/A (attendance is secondary) | — | 📖 CODE |
| `participant_left` (both parties) | `src/pages/api/webhooks/bbb.ts` → `detectEmptyRoomAndComplete()` in `src/lib/video/bbb.ts` | ✅ Updates most recent `left_at IS NULL` row only | ✅ Empty-room triggers auto-complete — but only if *both* participants fire `participant_left` | Webhook itself | 📖 CODE |
| `participant_left` (one crashes, other left) | Same handler | — | ❌ No timeout — session stuck `in_progress` until `reconcileBBBSessions()` runs manually | — | 📖 CODE — **gap** |
| `recording_ready` / `rap-publish-ended` | `src/pages/api/webhooks/bbb.ts` | ✅ `UPDATE … WHERE recording_url IS NULL` guard | ✅ `reconcileBBBSessions()` calls `getRecordings()` and backfills | **Manual** — same admin endpoint | 📖 CODE |
| BBB analytics callback | `src/pages/api/webhooks/bbb-analytics.ts` (JWT HS512 auth) | ⚠️ Needs verification | — | — | 📖 CODE |

### BBB live-verified scenarios (Conv 141)

| # | Scenario | Pre-state (`ses-david-n8n-3`) | Action | Post-state | Outcome |
|---|----------|-------------------------------|--------|------------|---------|
| B1 | `meeting-ended` delivered | `status=scheduled`, `ended_at=null` | Forged HMAC-signed POST via harness | `status=completed`, `ended_at=2026-04-20T12:09:17Z` | ✅ Handler mutates DB correctly |
| B2 | `meeting-ended` re-fired (idempotency) | `status=completed`, `ended_at=2026-04-20T12:09:17Z` | Same forged POST | Unchanged | ✅ `completeSession()` no-ops on already-completed |

### BBB observations

🟠 **`duration_minutes` never populated from webhook payload.** The webhook payload includes `duration: 5400` (seconds), but the handler does not read it. `duration_minutes` relies on `ended_at − started_at`. If `room_started` was missed (or the session was completed directly from `scheduled`), duration is unrecoverable. Consider: parse `duration` from payload as a fallback when `started_at` is null.

🟠 **Handler accepts `meeting-ended` on a `scheduled` session** (no prior `room_started`). Arguably correct (the session ended regardless of whether we tracked its start), but in production BBB should not emit `meeting-ended` for a meeting that never started. Worth adding a sanity log if this ever happens — could indicate a dropped `room_started`.

### BBB gaps (severity-ranked)

🔴 **No `[triggers.crons]` in `wrangler.toml`.** Every BBB healing path today says "cron" but today requires an admin to manually POST `/api/admin/sessions/cleanup`. Without automation, any missed webhook = stuck state until a human intervenes.

🔴 **Empty-room auto-complete needs both participants to fire `participant_left`.** If one participant's browser crashes (no webhook), the session stays `in_progress` forever — nothing times it out. `reconcileBBBSessions()` catches it eventually, but only when invoked.

🟠 **No timeout / no-show detection without admin action.** `detectNoShows()` + `detectStaleInProgress()` exist in `src/lib/booking.ts` but both run only via the admin cleanup endpoint.

🟢 **Duplicate `participant_joined` rows on webhook re-delivery.** Non-fatal; attendance is secondary. `INSERT OR IGNORE` or `EXISTS` guard would fix.

---

## Stripe Events

| Event | Handler (`src/pages/api/webhooks/stripe.ts`) | Idempotent? | Healing if missed | Healing trigger | Verified? |
|-------|---------------------------------------------|-------------|-------------------|-----------------|-----------|
| `checkout.session.completed` | Creates enrollment, transaction, transfers | ✅ `SELECT id FROM enrollments WHERE id=?` guard before insert | ✅ `createEnrollmentFromCheckout()` in `src/lib/enrollment.ts` via `/api/stripe/verify-checkout` | ✅ **Automatic** — called by `/course/[slug]/success.astro` SSR + `MyCourses.tsx` client localStorage recovery (Session 324) | 📖 CODE — Stripe staging harness deferred |
| `charge.refunded` | Reverses transaction, enrollment, Stream unfollow, marks splits `reversed` | ⚠️ State-idempotent but no event-ID guard | ❌ **None** — no polling, no page-load reconcile | — | 📖 CODE — **gap** |
| `account.updated` | Syncs `stripe_account_status`, `stripe_payouts_enabled` | ✅ State-idempotent `UPDATE` | ❌ **None** — stale account status blocks payouts silently | — | 📖 CODE — **gap** |
| `transfer.created` | Marks `payment_splits.status='paid'` | ✅ `UPDATE … WHERE status='pending'` guard | ⚠️ Partial — acts as safety net for missed `checkout.session.completed` only; no healing if `transfer.created` itself is missed | — | 📖 CODE |
| `charge.dispute.created` | Freezes enrollment, notifies admin | ⚠️ No event-ID guard — duplicate admin notifications on retry | ❌ **None** — admin never notified if webhook lost | — | 📖 CODE — **gap** |
| `charge.dispute.closed` | Won → re-enable; lost → cancel + reverse transfers | ⚠️ State-idempotent | ❌ **None** — outcome unknown until manual Stripe Dashboard check | — | 📖 CODE — **critical gap** |
| `transfer.reversed` | Would confirm transfer reversal | N/A | N/A | — | ❌ **MISSING — handler commented out** |
| `account.application.deauthorized` | Would handle creator Stripe disconnect | N/A | N/A | — | ❌ **MISSING — handler commented out** |
| `payout.failed` | Would notify creator of failed payout | N/A | N/A | — | ❌ **MISSING — requires separate "Connected accounts" webhook registration** |
| `checkout.session.expired` | Would clean up pending enrollments | N/A | N/A | — | ❌ MISSING — low priority |

### Stripe gaps (severity-ranked)

🔴 **`charge.dispute.closed` lost → we never know the outcome.** If the dispute is *lost* and we miss the webhook, transfer reversals don't run, the platform loses money, and the creator keeps theirs. No polling catches this today. **Recommended fix:** hourly cron calling `stripe.disputes.list()` and reconciling closed disputes against local `transactions.status`.

🔴 **`transfer.reversed` handler is commented out.** Any refund or lost-dispute reversal we initiate has no confirmation path. Without this handler, we cannot assert a reversal succeeded; `payment_splits.status` can stay non-`reversed` indefinitely.

🔴 **`account.application.deauthorized` not handled.** A creator who manually disconnects their Stripe account from the platform stays `active` in our DB — all future payouts fail silently. Either implement the handler or add a cron that polls `stripe.accounts.list()` for `requirements.disabled_reason`.

🟠 **`payout.failed` requires separate webhook registration.** The main Stripe webhook endpoint doesn't receive Connected-account events. Without a second endpoint + handler, payout failures are silent.

🟠 **Missed `charge.refunded` has no healing.** Platform doesn't learn about the refund; transfer isn't reversed. Student keeps course access (minor) and creator keeps their cut (major). No polling.

🟠 **Stale `account.updated` status has no reconciliation.** When a creator's Stripe account goes into requirements-disabled state and we miss the webhook, payouts block silently until the next `account.updated` fires.

🟢 **No envelope-level event-ID deduplication** (no `processed_webhook_events` table). Relies on functional/state idempotency (e.g., `UPDATE WHERE status='pending'`). Safe for DB state, but dispute/refund retries can send duplicate admin notifications.

### Stripe verification deferred

[VS] (PLAN.md) requires the harness to post Stripe events directly at the staging webhook endpoint with valid signatures using `STRIPE_WEBHOOK_SECRET`. `stripe trigger` only forwards to `stripe listen` (localhost) and `stripe events resend --webhook-endpoint <id>` requires a pre-existing event in Stripe's history. A direct-sign POST helper is the next increment of `[VH]`.

---

## System-Wide Gaps (both providers)

🔴 **No `[triggers.crons]` configured.** `wrangler.toml` has no scheduled triggers. Every healing mechanism that says "cron" is today "admin runs an endpoint" — which means nothing runs automatically on staging or production. This is the single highest-impact gap: implementing it unlocks automated healing for BBB `room_ended` / `recording_ready` *and* whatever Stripe polling we add.

🟠 **No webhook event-ID deduplication table.** A `processed_webhook_events (event_id PRIMARY KEY, ...)` table with an early-return check at the top of each handler would make retries provably safe (currently safe via functional idempotency, but brittle for notification side-effects).

🟢 **`webhook_log` table exists** (captures all incoming payloads + headers) — useful for forensics but not used for dedup.

---

## Untested Scenarios (Phase A deferrals)

These require live BBB meetings or a direct-sign Stripe harness and are out of scope for Phase A:

| Scenario | Why deferred | Plan |
|----------|--------------|------|
| Missed `room_ended` + `reconcileBBBSessions()` heals | Needs a real BBB meeting on Blindside `rna1` that actually ended | Pair-test in `[VF]` block |
| Missed `recording_ready` + `getRecordings()` backfill | Needs a real recorded BBB meeting | Pair-test in `[VF]` block |
| Empty-room one-sided crash (one `participant_left` fires, other doesn't) | Same as above | Pair-test in `[VF]` |
| All Stripe events on staging | `[VH]` Stripe direct-sign helper not yet implemented | Next increment of `[VH]` |

---

## References

- Harness: `../Peerloop/scripts/trigger-webhook.sh`, `../Peerloop/scripts/dev-webhooks.sh`, `../Peerloop/.dev.vars.staging.example`
- Stripe handler: `../Peerloop/src/pages/api/webhooks/stripe.ts`
- BBB handler: `../Peerloop/src/pages/api/webhooks/bbb.ts`
- BBB reconciliation: `../Peerloop/src/lib/booking.ts` (`completeSession()`, `detectNoShows()`, `detectStaleInProgress()`, `reconcileBBBSessions()`)
- Enrollment self-healing (Session 324): `../Peerloop/src/lib/enrollment.ts` (`createEnrollmentFromCheckout()`) + `../Peerloop/src/pages/api/stripe/verify-checkout.ts`
- Admin trigger for BBB reconcile: `../Peerloop/src/pages/api/admin/sessions/cleanup.ts`
- PLAN blocks: `MVP-GOLIVE.STAGING-VERIFY`, future `BBB-FIX` (driven by `[VF]`)
