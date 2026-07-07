# MVP-GOLIVE — Production readiness for external services

**Focus:** Production readiness for all external service providers
**Status:** ⏸️ DEFERRED (until launch decision)
**Last Audited:** Session 223 (2026-02-18)

All code is implemented and tested in dev/preview environments. Go-live requires adding production secrets to Cloudflare, registering endpoints in provider dashboards, and verifying DNS/domain configuration. No code changes expected — this is all infrastructure and configuration.

> **Also a pre-launch gate (non-provider): icon licensing/trademark — see `CURRENT-TASKS.md [ICON-LIC]`.** Add a third-party-notices file (Heroicons MIT + Material Symbols Apache 2.0 both require attribution) and run a brand-logo trademark review (`brand-icons.tsx` — Google Sign-In / Stripe badge rules + `currentColor` recoloring). Surfaced Conv 370 during [ICN-NS]; needs counsel sign-off.

## Production Readiness Scorecard

| Provider | Code | Dev/Preview | Prod Secrets | Prod Config | Ready? |
|----------|:----:|:-----------:|:------------:|:-----------:|:------:|
| **Stripe** | ✅ | ✅ Staging webhook active | ❌ Deferred | ❌ Prod webhook not registered | 🟡 |
| **Stream.io** | ✅ | ✅ | ❌ Not set | ⚠️ Verify feed groups in prod app | 🟡 |
| **Resend** | ✅ | ✅ | ❌ Not set | ❌ Domain not verified, DNS not set | 🔴 |
| **BigBlueButton** | ✅ | ✅ Blindside Networks | ❌ Not set | ❌ Prod webhook not registered | 🟡 |
| **Google OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in Google Console | 🔴 |
| **GitHub OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in GitHub | 🔴 |
| **Cloudflare** | ✅ | ✅ | ❌ Not set | ✅ Bindings configured | 🟡 |

## MVP-GOLIVE.AUTH
*Re-evaluate auth approach before launch*

- [ ] Re-evaluate JWT auth vs Astro Sessions — assess whether any workarounds during development would be better served by session-based auth (see `docs/as-designed/auth-sessions.md`)

## MVP-GOLIVE.STRIPE
*Payment processing and marketplace payouts*
**Tech Doc:** `docs/reference/stripe.md` (comprehensive webhook docs added Session 223)

**What's done:** Complete Stripe Connect integration — checkout, transfers (with idempotency keys), refunds, 7 webhook handlers (including dispute handling with transfer reversal), self-healing status sync, Express onboarding flow tested end-to-end. Staging webhook active at `staging.peerloop.pages.dev` (Session 224). Enrollment self-healing fallback for missed webhooks — success page SSR + /courses localStorage bridge (Session 324). Fixed `enrollments.student_teacher_id` FK mismatch (was inserting st-xxx instead of usr-xxx, Session 324). Fixed teacher profile session count JOINs and ST booking URL pre-selection (Session 324).

**Go-live steps:**
- [ ] Add `STRIPE_SECRET_KEY` (`sk_live_...`) to CF Dashboard Production secrets
- [ ] Register webhook endpoint in Stripe Dashboard (live mode):
  - URL: `https://<production-domain>/api/webhooks/stripe`
  - Events: `checkout.session.completed`, `charge.refunded`, `account.updated`, `transfer.created`, `charge.dispute.created`, `charge.dispute.closed`
- [ ] Copy generated `whsec_...` to CF Dashboard as `STRIPE_WEBHOOK_SECRET`
- [ ] Update `STRIPE_PUBLISHABLE_KEY` in `wrangler.toml` top-level `[vars]` to `pk_live_...`
- [ ] Test with real $1 charge → verify webhook arrives → refund immediately
- [ ] Configure Stripe branding (Dashboard → Settings → Branding):
  - [ ] Update account display name from "Alpha Peer LLC" to "Peerloop"
  - [ ] Upload Peerloop logo/icon (appears on Connect onboarding left panel)
  - [ ] Set brand color and accent color to match Peerloop palette

**Caveat:** Live-mode keys were intentionally deferred (Session 207, tech-026) to prevent accidental real charges during development.

**Pre-launch hardening:**
- [ ] Stripe Event Polling via Cron Trigger — catch-up for missed webhooks (enrollment self-healing done in Session 324; still needed for transfers, disputes, payout failures)
- [ ] Extended self-healing — reconcile transfer/dispute status on relevant page loads (enrollment self-healing done in Session 324; extend pattern to other entities)
- [ ] Dynamic admin lookup for dispute notifications (currently hardcoded to `'usr-admin'`; should query for admin role)
- [ ] Dispute evidence submission tooling (currently admin responds via Stripe Dashboard directly)
- [ ] `payout.failed` webhook endpoint (requires separate Connected accounts webhook in Stripe Dashboard)
- [ ] `checkout.session.expired` handler (clean up pending enrollments from abandoned checkouts)
- [ ] `transfer.reversed` handler (safety net for confirming transfer reversals)
- [ ] `/api/dev/simulate-checkout` endpoint (dev-only, skips Stripe Checkout redirect for faster manual testing)

## MVP-GOLIVE.STREAM
*Activity feeds (GetStream.io)*
**Tech Doc:** `docs/reference/stream.md`

**What's done:** REST API client (edge-compatible, no Node SDK), feed groups configured in dev app, enrollment-triggered follow relationships, course discussion feeds.

**Current config:**
- Dev/Preview app: `1457190` (configured in `wrangler.toml [env.preview.vars]`)
- Production app: `1456912` (configured in `wrangler.toml` top-level `[vars]`)

**Go-live steps:**
- [ ] Add `STREAM_API_SECRET` (prod app secret) to CF Dashboard Production secrets
- [ ] Verify Stream Dashboard (prod app `1456912`) has all feed groups:
  - `townhall` (flat), `course` (flat), `community` (flat)
  - `notification` (notification), `timeline` / `timeline_aggregated` (aggregated)
- [ ] Test feed creation and activity posting against prod app
- [ ] Verify token generation works with prod app credentials

**Note:** `STREAM_API_KEY` and `STREAM_APP_ID` are non-secrets already in `wrangler.toml`.

## MVP-GOLIVE.RESEND
*Transactional email*
**Tech Doc:** `docs/reference/resend.md`

**What's done:** SDK integrated, React Email templates framework, Cloudflare Workers compatible.

**API key status:** Verified working (Session 252, 2026-02-22). Dev key can send emails successfully. Without a verified domain, Resend restricts recipients to the account owner's email only.

**Go-live steps (CRITICAL — has lead time):**
- [ ] **Domain verification** — see **RESEND-DOMAIN** section above (moved out of go-live; do ASAP to unblock testing)
- [ ] Add `RESEND_API_KEY` (prod key `re_ZpBp...`) to CF Dashboard Production secrets
- [ ] Complete email templates: welcome, verification, password reset, session booking, payment receipt
- [ ] Test email delivery to real inboxes (check spam scoring)
- [ ] Implement email verification flow (depends on domain verification)
- [ ] Test moderator invite flow end-to-end (email delivery requires domain verification)
- [ ] (Optional) Configure Resend webhooks for bounce/complaint handling

**Caveat:** Without domain verification, emails send from `onboarding@resend.dev` which looks unprofessional and may be spam-filtered. Start DNS setup early.

## MVP-GOLIVE.BBB
*Video sessions (BigBlueButton via Blindside Networks)*
**Tech Doc:** `docs/reference/bigbluebutton.md`

**What's done:** VideoProvider interface, BBB adapter (with `!` encoding and URL normalization fixes), session CRUD + join + reschedule APIs, webhook handler, `/session/[id]` page, SessionRoom with `window.open()` + polling, recording endpoint, StudentDashboard upcoming sessions. Blindside Networks selected as managed BBB provider (no self-hosting needed).

**Go-live steps:**
- [ ] Get production BBB_SECRET from Blindside Networks (Binoy Wilson, `binoy.wilson@blindsidenetworks.com`)
- [ ] Add `BBB_SECRET` to CF Dashboard Production secrets
- [ ] `BBB_URL` already in `wrangler.toml` for all environments
- [ ] Configure BBB webhooks to call `https://<production-domain>/api/webhooks/bbb`
- [ ] Test meeting creation, join URLs, and recording with Blindside server

**Note:** No server provisioning needed — Blindside Networks provides managed BBB SaaS.

## MVP-GOLIVE.OAUTH
*Social login (Google + GitHub)*
**Tech Doc:** `docs/reference/google-oauth.md`

See OAUTH block for full checklist.

**Key lead-time item:** Google OAuth consent screen verification takes **1-2 weeks** for apps with >100 users. Start early.

## MVP-GOLIVE.CLOUDFLARE
*Infrastructure: D1, R2, KV, Pages*

**What's done:** All bindings configured in `wrangler.toml`. D1 databases exist (`peerloop-db` for prod, `peerloop-db-staging` for preview). R2 bucket `peerloop-storage` configured for both environments. KV namespace `SESSION` removed Conv 095 (unused — re-add for feature flags post-MVP).

**Go-live steps:**
- [ ] Add all secrets to CF Dashboard Production tab:
  - `JWT_SECRET` (generate fresh with `openssl rand -base64 32`)
  - All provider secrets listed above (Stripe, Stream, Resend, BBB, OAuth)
- [ ] Run `npm run db:migrate:prod` to apply schema to production D1
- [ ] Run `npm run db:setup:local:clean` to test fresh-install flow (no dev seed data)
- [ ] Verify R2 bucket permissions for production reads/writes
- [ ] Re-add KV `SESSION` namespace if feature flags needed (removed Conv 095)
- [ ] Configure custom domain in CF Pages (e.g., `peerloop.com`)
- [ ] Set up DNS records pointing domain to CF Pages

## MVP-GOLIVE.DOMAIN
*Production domain setup (prerequisite for most providers)*

**Why this matters:** Most provider registrations (Stripe webhook URL, OAuth callback URLs, Resend domain verification) require knowing the **exact production domain**. This should be decided first.

- [ ] Decide production domain (e.g., `peerloop.com`, `app.peerloop.com`)
- [ ] Configure domain in Cloudflare DNS
- [ ] Point domain to CF Pages deployment
- [ ] Verify HTTPS is working
- [ ] Update all provider configurations with final domain

## MVP-GOLIVE.EXECUTION_ORDER

Recommended order based on dependencies and lead times:

| Step | Provider | Why This Order | Lead Time |
|------|----------|---------------|-----------|
| 1 | **Domain** | All other providers need the production URL | Hours |
| 2 | **Cloudflare** | Secrets + DB migration; foundation for everything | Hours |
| 3 | **Resend** | DNS verification has variable wait time | Hours-24h |
| 4 | **Google OAuth** | Consent screen verification takes 1-2 weeks | **1-2 weeks** |
| 5 | **GitHub OAuth** | Quick registration, no verification needed | Minutes |
| 6 | **Stream.io** | Just add secret + verify feed groups | Minutes |
| 7 | **Stripe** | Register webhook + add secrets; test last | Hours |
| 8 | **BBB** | Heaviest infra; can defer if needed | Days-weeks |

## MVP-GOLIVE.OAUTH (absorbed Conv 095)

Code implemented and tested for both Google and GitHub OAuth. Missing: app registrations in provider consoles.

- [ ] Google: Create project, consent screen, OAuth Client ID, redirect URIs, add secrets to CF
- [ ] GitHub: Create OAuth App, callback URL, add secrets to CF
- [ ] Google consent screen verification: **1-2 weeks** for >100 users — start early
- [ ] See `docs/reference/google-oauth.md` for full walkthrough

## MVP-GOLIVE.CRON-CLEANUP (absorbed Conv 095; extended Conv 141 / Phase B)

**Status:** Phase A (infra) ✅ COMPLETE | Phase B (BBB-FIX) ✅ COMPLETE (Conv 142) | Prod cron deploy **GATED on the MVP-GOLIVE launch decision**. The original ~2026-04-28 "1-week staging health" gate has long since passed and is no longer the blocker — the blocker is that **production has never been launched** (no prod secrets, prod D1 unmigrated; see scorecard at top). Prod `peerloop-cron` is currently **NOT deployed** — a Conv-262 premature `deploy:cron:prod` was reverted the same conv (see the prod-cron item below).

Currently `detectNoShows()` + `detectStaleInProgress()` + `reconcileBBBSessions()` run manually via admin. For production, add automated scheduled runs.

**Architectural decision (Conv 141):** `@astrojs/cloudflare 13` does not expose `workerEntryPoint` — the Astro Worker cannot cleanly add a `scheduled()` export. Decision: deploy cron as a **separate standalone Worker** (`peerloop-cron` / `peerloop-cron-staging`) sharing D1/R2 bindings via binding IDs. Cleaner separation, reusable for future Stripe polling cron.

**Phase A (Infra) — COMPLETE:**

- [x] Investigate Astro + CF adapter dual exports (`fetch` + `scheduled`) — resolved: adapter doesn't support; use separate Worker
- [x] Refactor `src/pages/api/admin/sessions/cleanup.ts` — extracted shared logic into `src/lib/cleanup.ts` (called by both the admin endpoint and the cron Worker)
- [x] Create `../Peerloop/workers/cron/` standalone Worker — `wrangler.toml`, `src/index.ts` with `scheduled()` export, shared D1/R2 bindings
- [x] Add `[triggers.crons]` to cron Worker's wrangler.toml (`*/15 * * * *` staging, `*/30 * * * *` prod)
- [x] Add npm scripts `deploy:cron:staging` / `deploy:cron:prod`
- [x] Deploy to staging; verified `wrangler tail` shows scheduled runs ✅ **First run 2026-04-21T09:30:35Z recovered 1 real missed BBB recording_ready webhook**

**Phase B scope (driven by `docs/as-designed/webhook-miss-resilience.md`):**

- [x] BBB-FIX: one-sided-crash timeout — `detectOrphanedParticipants()` function wired before `detectStaleInProgress` (Conv 142)
- [x] BBB-FIX: `INSERT OR IGNORE` guard on `participant_joined` attendance insert with partial unique index (Conv 142)
- [x] BBB-FIX: `duration_minutes` fallback — `completeSession()` backfill via `COALESCE(started_at, ?)` (Conv 142)
- [ ] Prod cron deploy — `deploy:cron:prod` + set prod BBB_SECRET (awaiting 1-week staging health gate, ~2026-04-28). **The cron Worker now ALSO runs `refreshDiscoveryRails` (DISCOVERY-RAILS, Conv 261)**, and the main-app prod deploy serves `/api/discovery/rails` — both land HERE at launch, NOT as standalone feature deploys. Prod KV `DISCOVERY_CACHE` (`5fb43d64e4d94cf881b9cbeb349733f1`) is already wired in `wrangler.toml` ×3 + `workers/cron/wrangler.toml`. ⚠️ Conv 262 prematurely ran `deploy:cron:prod` from the `jfg-dev-13-matt` dev branch; the prod `peerloop-cron` Worker was **deleted the same conv** to restore the not-deployed state. (Staging deploy of the discovery cron remains the active/verified target.)
- [ ] Notification batching (daily digest vs individual alerts) — deferred; low priority until volume grows

## MVP-GOLIVE.STAGING-VERIFY (absorbed Conv 095)

Unified staging integration tests for all external services. Replaces BBB-VERIFY remaining items.

**Webhook miss-resilience (BBB + Stripe — Conv 141/143/144):** ✅ Phase A complete for both providers. BBB scenarios live-verified Conv 141/142. Stripe: direct-sign harness Conv 143, all 7 scenarios live-verified on staging Conv 144. Phase A uncovered a **production-blocker Stripe bug** (`constructEvent` → `constructEventAsync` — SubtleCryptoProvider sync-context failure on CF Workers since the Conv 114 migration; every Stripe webhook silently HTTP 400'd in staging). Fix deployed Conv 144. Three Phase B Stripe follow-ups added: [VD] `(student, course)` UNIQUE race, [VW] `webhook_log` `ctx.waitUntil()`, [VA] STRIPE_SECRET_KEY mode audit.

- [x] BBB: Harness extended + live-verified on staging; Phase B BBB-FIX block scoped; see CRON-CLEANUP
- [x] [VH] Stripe direct-sign POST helper — 7 events (`stripe-*-direct`) + `stripe-direct-raw` (Conv 143)
- [x] [VS] Stripe staging end-to-end verification — Conv 144: all 7 scenarios LIVE (S1–S7). See `docs/as-designed/webhook-miss-resilience.md §Stripe live-verified scenarios (Conv 144)`. Also hardened harness with `STUDENT_ID`/`COURSE_ID`/`SESSION_ID`/`TEACHER_ID`/`CREATOR_ID`/`TEACHER_CERT_ID` env-var overrides (was only `PENDING_ENR`/`CHECKOUT_ID`/`PI_ID`/`AMOUNT`). Also landed Stripe Mode Discipline decision (local=Test, staging=Sandbox, prod=Live) in `docs/DECISIONS.md §8` + `docs/reference/stripe.md`
- [x] **[Stripe constructEventAsync fix]** Prod-blocker bugfix (Conv 144) — `src/lib/stripe.ts` + `src/pages/api/webhooks/stripe.ts:64` switched to `await constructEventAsync()`. Deployed to staging 2026-04-21 version `254fa8e9`. Unit tests (17/17) pass
- [ ] Stream: verify feed creation + activity posting against staging app
- [ ] Resend: plus-addressed email capture (`fgorrie+{handle}@bio-software.com`), verify delivery
- [x] **[VD]** `handleCheckoutCompleted` early-return on `(student, course)` dedup (Phase B Stripe — Conv 145). Added partial-index-predicate-matching SELECT in `src/lib/enrollment.ts` after existing `pending_enrollment_id` idempotency check; matches `status IN ('enrolled', 'in_progress')` predicate exactly; on collision logs `ADMIN_ALERT duplicate_enrollment_attempt` warning and returns existing enrollment ID idempotently. Test added: `blocks duplicate-purchase when (student, course) already active`. Avoids SQLITE_CONSTRAINT_UNIQUE → HTTP 500 → Stripe retry storm when a fresh `pending_enrollment_id` collides with an existing enrollment for same student + course.
- [x] **[VW]** `webhook_log` INSERT wrapped in `ctx.waitUntil()` for Stripe + BBB (Phase B Stripe — Conv 145). Wrapped fire-and-forget `db.prepare(...).run().catch(...)` in `locals.cfContext.waitUntil(...)` at `src/pages/api/webhooks/stripe.ts:75-85` and `src/pages/api/webhooks/bbb.ts:80-90`; updated test helper `cfContext` stub from `{}` to real shape with `waitUntil` + `passThroughOnException` no-ops. Fixes default-case (short-path) events losing their log entry due to fire-and-forget race with Worker context termination.
- [x] **[VA]** Audit staging Worker `STRIPE_SECRET_KEY` is a Sandbox `sk_test_` (not Test-mode) (Phase B Stripe — Conv 145). Built admin-gated `/api/admin/stripe-mode` endpoint (`src/pages/api/admin/stripe-mode.ts` + 4 tests) using `stripe.accounts.retrieveCurrent()`; deployed to staging Version `e5f00fb0`; verified staging account_id `acct_1SkSfYRu7i9fxxy0` = Sandbox workbench (not Test-mode `acct_1SkSfMRyHGcVUhoO`); mode aligned with webhook secret. Mode-split risk averted: `stripe.transfers.list()` will work correctly (no mode mismatch → reversals run as designed).
- [x] **[VL]** Rotate leaked `sk_test_...PP6iSq` Test-mode key (Phase B Stripe — Conv 145). Safe-grep audit: 5 occurrences in docs-repo Extracts (all redacted stubs, no full value leaked); `.dev.vars` clean; code repo clean. Stripe CLI cache refreshed via `stripe login` (Test-mode Standard key now current); final verification `grep -c "PP6iSq" ~/.config/stripe/config.toml` → 0. Hygiene complete; Test-mode only — does NOT affect Sandbox/staging or Live.
- [ ] **[STRIPE-UI-UPDATE]** Update `docs/reference/stripe.md` §Stripe Mode Discipline + §Per-Environment Webhook Configuration with note about Stripe Dashboard UI merging Test-mode into the Sandboxes listing page (screenshot: banner "Test mode is now part of sandboxes, so you can manage all of your test environments in one place.") — account-level isolation unchanged (`acct_1SkSfMRyHGcVUhoO` Test vs `acct_1SkSfYRu7i9fxxy0` Sandbox), but navigation has shifted from separate toggle to unified Sandboxes page. Discovered Conv 145 [VA] verification step.

## MVP-GOLIVE.RECORDING-PERSIST (absorbed Conv 095)

Cookie-based `.m4v` download implemented (Conv 037). Remaining:

- [ ] Verify `recording_url` populated by webhook on live BBB session
- [ ] Verify cookie-based download produces valid `.m4v`
- [ ] Confirm BBB shared secret matches `BBB_SECRET`
- [ ] Recording playback/download UI on session detail page
- [ ] Admin: expose `recording_size_bytes`, query recording status across sessions
