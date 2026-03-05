# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| CURRENTUSER | Global User State Management | 🟡 Nearly Complete (PUBLIC deferred) |

### ON-HOLD

(None currently)

### DEFERRED

| Priority | Block | Name |
|----------|-------|------|
| 1 | FEEDS | Ranked Feeds & Mobile Performance |
| 2 | ROLES | Admin Role Management |
| 3 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred) |
| 4 | ESCROW | Payment Hold & Escrow |
| 5 | POLISH | Production Readiness |
| 6 | OAUTH | OAuth Provider Setup (status TBD) |
| 7 | MVP-GOLIVE | Production Go-Live |
| 8 | SENTRY | Error Tracking |
| 9 | IMAGE-OPTIMIZE | Image Optimization |
| 10 | KV-CONSISTENCY | KV Consistency Audit |
| 11 | PAGES-DEFERRED | Deferred Pages (7) — includes story IDs |
| 12 | EXTRA-SESSIONS | Extra Session Purchases — allow students to buy additional sessions with the same ST beyond the course plan |
| 13 | GOODWILL | Goodwill Points & Summon Help System (25 stories, all P2/P3) |
| 14 | FEED-PROMOTION | Feed Promotion — points & paid placement (3 stories, all P2/P3) |
| 15 | COURSE-LIMIT | Creator Course Limit — default 3 courses for new creators, admin-adjustable per user |

---

---

## Nearly Complete: CURRENTUSER

**Focus:** Global user state management with course-aware role checking
**Status:** 🔄 NEARLY COMPLETE (only PUBLIC remaining, deferred)

**Completed:** TypeScript types and `CurrentUser` class, `/api/me/full` endpoint, AppNavbar integration, localStorage caching with stale-while-revalidate, two-global architecture on `window.__peerloop`, permission model audit (all 13 methods verified, `canModerateFor` updated to three-tier check), all APP pages confirmed using AppLayout, AdminNavbar integration with session expiry detection and admin identity display (Session 261).

### CURRENTUSER.DEFERRED

*Items deferred due to schema gaps:*

| Item | Reason | Future Work |
|------|--------|-------------|
| `totalEarningsCents` on ST certifications | No aggregated field; would need SUM query on payouts | Add to SEEDDATA or POLISH block |
| `pendingPayoutCents` on ST certifications | Same as above | Add to SEEDDATA or POLISH block |

### CURRENTUSER.PUBLIC

*Public/marketing pages without shared navbar*

**Status:** 📋 PENDING (deferred — no standalone public pages exist yet)

**Current reality:** Login, signup, and reset-password all use AppLayout. No `/welcome` page exists. Placeholder pages now exist for `/terms`, `/privacy`, `/about`, etc. (BROKENLINKS block, Session 317) but use LandingLayout and don't need CurrentUser.

**When to revisit:** When standalone public pages are added that need API calls or networkState without AppLayout.

---

---

## Deferred: FEEDS

**Focus:** Ranked/algorithmic feeds and mobile performance optimization
**Status:** 📋 PENDING (awaiting client input on paid tier)
**Tech Doc:** `docs/tech/tech-002-stream.md`

**Completed:** Stream.io REST client (edge-compatible), feed groups (townhall, community, course, timeline), post/reaction/comment CRUD, TownHallFeed + CommunityFeed + CourseFeed + HomeFeed components, per-community and per-course feeds with fan-out on write, threaded comments via reactions. (COMMUNITY block, Sessions 54-58)

### FEEDS.RANKING
*Configure algorithmic feed ordering (requires paid Stream tier)*

**Ranking Formula Design:**

```json
{
  "score": "decay_gauss(time) * (1 + is_pinned*100) * (1 + priority*0.1) * (external.w_ann * is_announcement + external.w_course * is_course_post + external.w_comm)",
  "defaults": {
    "is_announcement": 0,
    "is_course_post": 0,
    "is_pinned": 0,
    "priority": 1
  }
}
```

**Activity Fields for Ranking:**

| Field | Type | Set By | Purpose |
|-------|------|--------|---------|
| `is_pinned` | 0/1 | Admin/Creator | Pinned posts always at top |
| `is_announcement` | 0/1 | System | Official announcements |
| `is_course_post` | 0/1 | System | Posts tagged to a course |
| `priority` | 1-10 | Creator | Boosted/promoted content |
| `course_id` | string | User | Course association (for display) |

**User Preference Weights:**

| Preference | Default | Description |
|------------|---------|-------------|
| `w_announcements` | 5 | Weight for official announcements |
| `w_courses` | 3 | Weight for course-related posts |
| `w_community` | 1 | Weight for general community posts |

**Tasks:**
- [ ] Confirm client wants ranked feeds (requires paid tier)
- [ ] Design ranking formula based on content priorities
- [ ] Create user preferences storage in D1 (or use defaults)
- [ ] Update post activity structure with ranking fields
- [ ] Configure ranked feed in Stream Dashboard
- [ ] Update API to pass `ranking_vars` at query time
- [ ] Test ranking behavior with sample data

### FEEDS.MOBILE
*Mobile-friendly feed performance*

**Done:** Basic pagination in feed queries.

**Remaining:**
- [ ] Verify all feed queries use pagination with `limit` + `offset`/`id_lt`
- [ ] Test feed load times on mobile network (3G simulation)
- [ ] Implement feed caching in React Query or similar
- [ ] Add loading skeletons for feed pagination

### FEEDS.LIMITATIONS
*Stream v2 constraints and workarounds*

**Constraints:**
- Cannot filter by custom fields server-side → Workaround: separate feeds per community/course (DONE)
- Cannot combine ranked + date filtering → Workaround: aggressive time decay (pending, needs RANKING)
- No full-text search → Workaround: D1 FTS5 index (not implemented)
- Real-time SDK is Node-only, incompatible with CF Workers → Polling or future WebSocket

### FEEDS.OPEN_QUESTIONS

| Question | Status |
|----------|--------|
| Paid tier for ranked feeds? | 🔄 Awaiting client input |
| Real-time updates? | 📋 Deferred (polling vs WebSocket) |

---

## Deferred: ROLES

Admin interface for managing user roles.

**Completed:** EDIT_UI — UserEditModal with 5 capability toggles, wired into UsersAdmin detail panel + row actions, admin warning banner, 5 API tests for role PATCH (Session 280).

### ROLES.CREATE_UI
*Add user creation to admin interface (optional)*

- [ ] Add "Create User" button to UsersAdmin
- [ ] Create UserCreateModal component
- [ ] Wire to `POST /api/admin/users` (requires password per DECISIONS.md)
- [ ] Add tests for admin user creation flow

### ROLES.AUDIT
*Role change tracking (optional, post-MVP)*

- [ ] Log role changes to audit table
- [ ] Show role history in user detail panel

---

## Nearly Complete: SEEDDATA

Database seeding strategy and empty state handling.
**Status:** 🟡 NEARLY COMPLETE (only EMPTY_STATE remaining, deferred to POLISH)

**Completed:** Full seed data overhaul (Session 285) — `migrations-dev/0001_seed_dev.sql` rewritten to cover all 58 schema tables (up from 18). Community/course restructuring: `comm-ai-for-you` (Guy, 3 courses), `comm-automation-majors` (Guy, 1 course), `comm-q-system` (Gabriel, 2 Q-System courses). Fixed data inconsistencies (Stripe Connect IDs, progress_percent, ST ratings). Populated all 40 previously empty tables: sessions, payments, certificates, social, homework, notifications, messaging, moderation, creator applications, onboarding, marketing. Mock-data.ts updated with 2 Gabriel Q-System courses. All 5,283 tests passing. Seeding tooling (`npm run db:setup:local`, `db:seed:local`) already existed.

### SEEDDATA.EMPTY_STATE (Deferred → POLISH)
*Test application behavior with empty database*
- [ ] Test each page with zero records
- [ ] Verify empty state messages display correctly
- [ ] Test first-user / first-course / first-enrollment flows
- [ ] Document which pages require seed data vs work empty

---

## Deferred: ESCROW

**Focus:** Payment hold period and admin-approved fund release
**Status:** 📋 PENDING
**User Stories:** US-P074 (P0), US-P075 (P0), US-P076 (P0)
**Sources:** CD-020 (Payment & Escrow), tech-003-stripe.md, payment-decisions.md

### ESCROW.CONTEXT

**Current implementation:** Transfers execute immediately after `checkout.session.completed` webhook — no hold period. Refunds clawback from future earnings if recipient has already been paid.

**What's missing:** The P0 user stories require escrow with admin release:
- US-P074: Hold funds until milestone completion
- US-P075: Clear release criteria for escrowed funds
- US-P076: Admin approves fund releases

**Current schema gap:** No escrow/hold columns exist in `payment_splits` or `payouts` tables. The CEAR page spec already shows "pending/in escrow" states in the UI.

**RUN-001 assumption:** "Pay after session completes, clawback if refund." tech-003 recommends 7-day delay for new Creators/S-Ts.

### ESCROW.SCHEMA
*Add hold/release columns to payment flow*

- [ ] Add `hold_until TEXT` to `payment_splits` — when NULL, transfer immediately; when set, hold until this datetime
- [ ] Add `released_by TEXT REFERENCES users(id)` to `payment_splits` — admin who released the hold
- [ ] Add `released_at TEXT` to `payment_splits` — when funds were released
- [ ] Decide: hold period per-user (new S-Ts get 7 days, established get 0) or per-transaction
- [ ] Update `payment_splits.status` CHECK to include `'held'` state: `('pending', 'held', 'paid', 'reversed')`

### ESCROW.TRANSFER_LOGIC
*Modify transfer creation to respect hold period*

- [ ] Update `checkout.session.completed` handler: create splits with `status='held'` + `hold_until` instead of immediately calling `stripe.transfers.create()`
- [ ] Create release mechanism: when hold expires or admin approves, call `stripe.transfers.create()` and update split to `status='paid'`
- [ ] Handle hold expiry: either Cron Trigger (see deferred Stripe Event Polling) or check-on-access pattern

### ESCROW.ADMIN_RELEASE
*Admin UI for approving fund releases (US-P076)*

- [ ] Add escrow view to PayoutsAdmin — list splits in `'held'` status
- [ ] "Release" button calls `POST /api/admin/payment-splits/:id/release`
- [ ] Release endpoint: validates hold, creates Stripe transfer, updates split status
- [ ] "Release All Eligible" bulk action for splits past their `hold_until` date
- [ ] Audit trail: `released_by` + `released_at` on each split

### ESCROW.CREATOR_VISIBILITY
*Show escrow state in Creator/S-T dashboards (CEAR page spec)*

- [ ] Update CEAR earnings display: show held vs available vs paid amounts
- [ ] Update S-T earnings display: same breakdown
- [ ] Show hold countdown ("Released in 5 days") on held splits

### ESCROW.HOLD_POLICY
*Define the business rules for hold periods*

- [ ] Decide: flat 7-day hold for all, or graduated (new S-Ts: 7 days, established: 0)?
- [ ] Decide: does the hold start at payment time or session completion time?
- [ ] Decide: can admin override hold (release early)?
- [ ] Document policy in DECISIONS.md

### ESCROW.TESTING
*Verify hold/release flows*

- [ ] Unit tests for hold logic (split created with correct `hold_until`, status transitions)
- [ ] Unit tests for release endpoint (auth, validation, Stripe transfer creation)
- [ ] Manual testing with Stripe Test Clocks — fast-forward time to verify hold expiry triggers release
- [ ] Manual testing of admin release UI

---

## Deferred: POLISH

Production readiness items.

### POLISH.VALIDATION
*Zod schema expansion (candidate)*
- [ ] API request body validation
- [ ] Webhook payload validation (Stripe, BBB)
- [ ] Form validation schemas
- [ ] Environment variable validation

### POLISH.ROLES
*Role-based access refinement (candidate)*
- [ ] Course-scoped vs global role semantics
- [ ] Multi-role user navigation
- [ ] Admin impersonation model

### POLISH.TECHNICAL_DEBT
- [ ] Status field inconsistency (boolean vs enum)
- [ ] Type-safe status helpers in `src/lib/db/`
- [ ] Document status patterns in DB-SCHEMA.md

### POLISH.DEFERRED_FEATURES
*Small features deferred from completed blocks*
- [ ] Session reminders — needs Cloudflare cron workers (from NOTIFY block)
- [ ] Compatible member matching — Jaccard similarity on shared topic interests (from ONBOARDING block)
- [ ] User → Member rename — platform-wide terminology update (from ONBOARDING block)
- [ ] Community filtering by topic on `/discover/communities` (from ONBOARDING block)

---

## Deferred: OAUTH

**Focus:** Register OAuth apps with Google and GitHub, add credentials to Cloudflare
**Status:** 📋 DEFERRED (status and blockers need to be ascertained)
**Tech Doc:** `docs/tech/tech-025-google-oauth.md` (includes GitHub instructions)

### OAUTH.CONTEXT

Code is fully implemented and tested for both providers:
- `src/pages/api/auth/google/` (index.ts + callback.ts)
- `src/pages/api/auth/github/` (index.ts + callback.ts)

What's missing: the **app registrations** that produce Client ID / Client Secret pairs. These must be created by someone with access to the Google Cloud Console and GitHub org settings.

### OAUTH.GOOGLE
*Client registers Peerloop as a Google OAuth app*

- [ ] Create Google Cloud project "Peerloop" (or use existing)
- [ ] Configure OAuth consent screen (External, scopes: openid, email, profile)
- [ ] Create OAuth 2.0 Client ID (Web application)
- [ ] Add authorized redirect URIs for production, preview, and localhost
- [ ] Add `GOOGLE_CLIENT_ID` + `GOOGLE_CLIENT_SECRET` to Cloudflare (Preview)
- [ ] Add `GOOGLE_CLIENT_ID` + `GOOGLE_CLIENT_SECRET` to Cloudflare (Production)
- [ ] Uncomment and fill in `.dev.vars` for local dev
- [ ] Test "Sign in with Google" end-to-end

### OAUTH.GITHUB
*Client registers Peerloop as a GitHub OAuth app*

- [ ] Create GitHub OAuth App at github.com/settings/developers (or org settings)
- [ ] Set callback URL to production callback
- [ ] Add `GITHUB_CLIENT_ID` + `GITHUB_CLIENT_SECRET` to Cloudflare (Preview)
- [ ] Add `GITHUB_CLIENT_ID` + `GITHUB_CLIENT_SECRET` to Cloudflare (Production)
- [ ] Uncomment and fill in `.dev.vars` for local dev
- [ ] Test "Sign in with GitHub" end-to-end

### OAUTH.NOTES

- Google consent screen verification may take 1-2 weeks for >100 users — start early
- GitHub only allows ONE callback URL per OAuth App — may need separate apps per environment
- Cloudflare Preview has dynamic subdomains — consider a dedicated staging domain for OAuth
- See `docs/tech/tech-025-google-oauth.md` for full setup walkthrough

---

## Deferred: MVP-GOLIVE

**Focus:** Production readiness for all external service providers
**Status:** ⏸️ DEFERRED (until launch decision)
**Last Audited:** Session 223 (2026-02-18)

All code is implemented and tested in dev/preview environments. Go-live requires adding production secrets to Cloudflare, registering endpoints in provider dashboards, and verifying DNS/domain configuration. No code changes expected — this is all infrastructure and configuration.

### Production Readiness Scorecard

| Provider | Code | Dev/Preview | Prod Secrets | Prod Config | Ready? |
|----------|:----:|:-----------:|:------------:|:-----------:|:------:|
| **Stripe** | ✅ | ✅ Staging webhook active | ❌ Deferred | ❌ Prod webhook not registered | 🟡 |
| **Stream.io** | ✅ | ✅ | ❌ Not set | ⚠️ Verify feed groups in prod app | 🟡 |
| **Resend** | ✅ | ✅ | ❌ Not set | ❌ Domain not verified, DNS not set | 🔴 |
| **BigBlueButton** | ✅ | ✅ Blindside Networks | ❌ Not set | ❌ Prod webhook not registered | 🟡 |
| **Google OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in Google Console | 🔴 |
| **GitHub OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in GitHub | 🔴 |
| **Cloudflare** | ✅ | ✅ | ❌ Not set | ✅ Bindings configured | 🟡 |

### MVP-GOLIVE.AUTH
*Re-evaluate auth approach before launch*

- [ ] Re-evaluate JWT auth vs Astro Sessions — assess whether any workarounds during development would be better served by session-based auth (see `docs/tech/tech-027-auth-sessions.md`)

### MVP-GOLIVE.STRIPE
*Payment processing and marketplace payouts*
**Tech Doc:** `docs/tech/tech-003-stripe.md` (comprehensive webhook docs added Session 223)

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

### MVP-GOLIVE.STREAM
*Activity feeds (GetStream.io)*
**Tech Doc:** `docs/tech/tech-002-stream.md`

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

### MVP-GOLIVE.RESEND
*Transactional email*
**Tech Doc:** `docs/tech/tech-004-resend.md`

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

### MVP-GOLIVE.BBB
*Video sessions (BigBlueButton via Blindside Networks)*
**Tech Doc:** `docs/tech/tech-001-bigbluebutton.md`

**What's done:** VideoProvider interface, BBB adapter (with `!` encoding and URL normalization fixes), session CRUD + join + reschedule APIs, webhook handler, `/session/[id]` page, SessionRoom with `window.open()` + polling, recording endpoint, StudentDashboard upcoming sessions. Blindside Networks selected as managed BBB provider (no self-hosting needed).

**Go-live steps:**
- [ ] Get production BBB_SECRET from Blindside Networks (Binoy Wilson, `binoy.wilson@blindsidenetworks.com`)
- [ ] Add `BBB_SECRET` to CF Dashboard Production secrets
- [ ] `BBB_URL` already in `wrangler.toml` for all environments
- [ ] Configure BBB webhooks to call `https://<production-domain>/api/webhooks/bbb`
- [ ] Test meeting creation, join URLs, and recording with Blindside server

**Note:** No server provisioning needed — Blindside Networks provides managed BBB SaaS.

### MVP-GOLIVE.OAUTH
*Social login (Google + GitHub)*
**Tech Doc:** `docs/tech/tech-025-google-oauth.md`

See OAUTH block for full checklist.

**Key lead-time item:** Google OAuth consent screen verification takes **1-2 weeks** for apps with >100 users. Start early.

### MVP-GOLIVE.CLOUDFLARE
*Infrastructure: D1, R2, KV, Pages*

**What's done:** All bindings configured in `wrangler.toml`. D1 databases exist (`peerloop-db` for prod, `peerloop-db-staging` for preview). R2 bucket `peerloop-storage` and KV namespace `SESSION` configured for both environments.

**Go-live steps:**
- [ ] Add all secrets to CF Dashboard Production tab:
  - `JWT_SECRET` (generate fresh with `openssl rand -base64 32`)
  - All provider secrets listed above (Stripe, Stream, Resend, BBB, OAuth)
- [ ] Run `npm run db:migrate:prod` to apply schema to production D1
- [ ] Run `npm run db:setup:local:clean` to test fresh-install flow (no dev seed data)
- [ ] Verify R2 bucket permissions for production reads/writes
- [ ] Verify KV `SESSION` namespace is accessible from production worker
- [ ] Configure custom domain in CF Pages (e.g., `peerloop.com`)
- [ ] Set up DNS records pointing domain to CF Pages

### MVP-GOLIVE.DOMAIN
*Production domain setup (prerequisite for most providers)*

**Why this matters:** Most provider registrations (Stripe webhook URL, OAuth callback URLs, Resend domain verification) require knowing the **exact production domain**. This should be decided first.

- [ ] Decide production domain (e.g., `peerloop.com`, `app.peerloop.com`)
- [ ] Configure domain in Cloudflare DNS
- [ ] Point domain to CF Pages deployment
- [ ] Verify HTTPS is working
- [ ] Update all provider configurations with final domain

### MVP-GOLIVE.EXECUTION_ORDER

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

---

## Deferred: SENTRY

**Focus:** Production error tracking and API observability via Sentry
**Status:** ⏸️ DEFERRED (until pre-production deploy)
**Tech Doc:** `docs/tech/tech-008-sentry.md` (implementation plan added Session 233)
**Last Audited:** Session 233 (2026-02-20)

### SENTRY.CONTEXT

**Current state:** 176 API files use bare `console.error` (~292 call sites) which is ephemeral on Cloudflare Workers — errors vanish after the request ends. No structured logging, no alerting, no error grouping. Sentry was selected (Session Dec 2025) but never integrated.

**What Sentry provides:**
- Automatic error capture with stack traces and source maps
- Ancillary context: user identity, request details, breadcrumb trail, feature tags
- Intelligent error grouping (reduces noise)
- Alerting to Slack/email (configurable by feature area: payment, auth, webhooks)
- Performance monitoring (API latency, DB query timing)

**Complementary to PostHog:** Sentry handles errors; PostHog handles analytics/replays. No overlap.

### SENTRY.PHASES

| Phase | Scope | Effort |
|-------|-------|--------|
| 1 | SDK setup + Astro integration + env vars | Small |
| 2 | API route migration (replace `console.error` → `captureApiError`) | Medium-Large (176 files) |
| 3 | React Error Boundary on key components | Small |
| 4 | User identification (wire into CurrentUser) | Small |
| 5 | Alert rules + Slack integration | Small (config only) |
| 6 | Source map upload in CI/CD | Small |

### SENTRY.TASKS

- [ ] Create Sentry project and get DSN
- [ ] Install `@sentry/astro` + `@sentry/cloudflare`
- [ ] Add `SENTRY_DSN` to `.dev.vars`, CF Preview, CF Production
- [ ] Add Astro integration to `astro.config.mjs`
- [ ] Create `src/lib/sentry.ts` shared error capture utilities
- [ ] Migrate payment/webhook routes (Priority 1, ~15 files)
- [ ] Migrate auth routes (Priority 2, ~10 files)
- [ ] Migrate user-facing routes (Priority 3, ~50 files)
- [ ] Migrate admin routes (Priority 4, ~50 files)
- [ ] Migrate feed/community routes (Priority 5, ~20 files)
- [ ] Add React Error Boundary to key components
- [ ] Wire user identification into CurrentUser init/clear
- [ ] Configure alert rules in Sentry Dashboard
- [ ] Configure Slack integration for error alerts
- [ ] Add source map upload to deploy pipeline
- [ ] End-to-end verification: trigger error → confirm in Sentry with full context

### SENTRY.TRIGGERS

Initiate this block when:
- MVP-GOLIVE execution begins (provider secrets being added)
- First staging deploy to production domain
- Before any real user traffic hits the platform

### SENTRY.DEPENDENCIES

| Dependency | Status | Why |
|------------|--------|-----|
| Production domain decided | In MVP-GOLIVE.DOMAIN | Sentry project needs environment config |
| CF Dashboard secrets access | In MVP-GOLIVE.CLOUDFLARE | `SENTRY_DSN` must be added |
| CI/CD pipeline exists | Not yet | Source map upload needs deploy hook |
| CurrentUser integration | In progress | User identification wires into Sentry |

---

## Deferred: IMAGE-OPTIMIZE

**Focus:** Image transformation and delivery optimization
**Status:** ⏸️ DEFERRED (post-MVP, when traffic warrants it)
**Tech Doc:** `docs/tech/tech-028-image-handling.md`

### IMAGE-OPTIMIZE.CONTEXT

**Current state:** Plain `<img>` tags rendering R2-stored images with no optimization. Course thumbnails uploaded to R2 via API. User avatars from OAuth or placeholder URLs.

**Why deferred:** Low image volume (~4 courses, <10 users). No measurable performance impact. Adding a pipeline adds vendor complexity with no current benefit.

### IMAGE-OPTIMIZE.OPTIONS

| Option | Best For | Migration Effort |
|--------|----------|-----------------|
| **Cloudinary** | Rich transforms, face detection, video | Re-upload or fetch-from-R2; URL helper needed |
| **CF Image Resizing** | Stay in CF ecosystem | Minimal — prefix R2 URLs with `/cdn-cgi/image/` params |
| **CF Images (managed)** | Simple variant-based | Not recommended — duplicates R2 storage |

### IMAGE-OPTIMIZE.TASKS

- [ ] Choose optimization service (Cloudinary vs CF Image Resizing)
- [ ] Create URL helper function for transform URLs
- [ ] Add responsive `srcset` to key components (CourseCard, Avatar, CourseHero)
- [ ] Add `loading="lazy"` to below-fold images
- [ ] Configure WebP/AVIF auto-format conversion
- [ ] Update avatar upload flow (currently no upload endpoint for users)
- [ ] Add image size validation and client-side preview
- [ ] Performance audit: measure before/after on mobile

### IMAGE-OPTIMIZE.TRIGGERS

Re-evaluate when any of these occur:
- Image count exceeds ~100
- Mobile performance audit shows image bottleneck
- User avatar uploads are implemented
- Video thumbnail generation is needed

---

## Deferred: KV-CONSISTENCY

**Focus:** Re-assess Cloudflare KV use cases against eventual consistency constraints
**Status:** ⏸️ DEFERRED (post-MVP, when KV is used beyond SESSION binding)
**Tech Doc:** `docs/tech/tech-029-cloudflare-kv.md`

### KV-CONSISTENCY.CONTEXT

**Current state:** KV namespace `SESSION` provisioned and bound in `wrangler.toml`. Not actively used by application code — the Astro adapter has access to it, but no `Astro.session` calls exist.

**The constraint:** KV is eventually consistent with up to 60-second propagation delay. Writes at one edge location may not be visible at other locations for up to a minute.

### KV-CONSISTENCY.AUDIT

When adding KV-dependent features, audit each use case:

- [ ] **Feature flags** — 60s staleness acceptable? (Usually yes)
- [ ] **Rate limiting** — Approximate counts across edges acceptable? (Usually yes)
- [ ] **API response cache** — Stale cache for 60s acceptable? (Usually yes)
- [ ] **Session revocation** — Logout delayed 60s at other edges? (Evaluate security posture)
- [ ] **Short-lived tokens** — Token valid at other edges after deletion? (Use TTL, not delete)

### KV-CONSISTENCY.ALTERNATIVES

If strong consistency is needed for a use case:

| Need | Solution |
|------|----------|
| Instant session revocation | Durable Objects (strongly consistent, higher cost) |
| Authoritative user state | D1 (already used) |
| Real-time counters | Durable Objects or D1 |
| Distributed locks | Durable Objects |

### KV-CONSISTENCY.TRIGGERS

Re-evaluate when:
- First KV-dependent feature is implemented beyond SESSION
- Astro Sessions are adopted for auth (consistency of logout matters)
- Multi-region user base makes 60s propagation noticeable
- Security audit flags session/permission staleness

---

## Deferred: PAGES-DEFERRED

**Focus:** 7 pages deferred per client directive — not yet designed for the Twitter-style left-side menu layout
**Status:** ⏸️ DEFERRED (post-MVP, pending client direction)
**Unimplemented stories:** 6 (US-S065, US-M004, US-C026, US-S081, US-P097, US-P099)

**Open question:** Current app pages use a Twitter-like left-side menu navigation. These more traditional/standard pages need layout decisions — do they use the same left-side menu pattern, or a different layout?

| Code | Page | Route | Stories | Notes |
|------|------|-------|---------|-------|
| HELP | Summon Help | `/help` | *(see GOODWILL block)* | Blocked on goodwill system |
| BLOG | Blog | `/blog` | — | Content not ready |
| CARE | Careers | `/careers` | — | Content not ready |
| CHAT | Course Chat | `/courses/:slug/chat` | US-S065, US-M004 | Superseded by community feeds |
| CNEW | Creator Newsletters | `/creating/newsletters` | US-C026 | Post-MVP |
| SUBCOM | Sub-Community | `/groups/:id` | US-S081, US-P097 | Post-MVP |
| CLOG | Changelog | `/changelog` | US-P099 | Gap story — no route exists yet |

---

## Deferred: GOODWILL

**Focus:** Goodwill points system — gamified participation tracking, power user tiers, and peer help ("Summon Help")
**Status:** ⏸️ DEFERRED (post-MVP, P2/P3 only)
**Stories:** 25 (23 P2 + 2 P3)
**Source:** CD-010, CD-011, CD-023
**Dependencies:** Requires new DB tables, points tracking service, Summon Help UI. HELP page in PAGES-DEFERRED is the front-end entry point.
**Blocks:** FEED-PROMOTION (depends on goodwill points to function)

### Story Inventory

**Student (8 stories):**

| Story | Description | Priority |
|-------|-------------|----------|
| US-S030 | Earn goodwill points through participation | P2 |
| US-S031 | See power user level/tier | P2 |
| US-S062 | Summon help from certified peers when stuck | P2 |
| US-S063 | See how many helpers are available on course page | P2 |
| US-S064 | Award goodwill points (10-25 slider) to helpers after summon session | P2 |
| US-S066 | Award "This Helped" points (5) to helpful chat answers | P2 |
| US-S067 | See goodwill balance and history (private view) | P2 |
| US-S068 | See total earned goodwill on public profile | P2 |

**Student-Teacher (7 stories):**

| Story | Description | Priority |
|-------|-------------|----------|
| US-T015 | Earn points for teaching activity | P2 |
| US-T024 | Toggle "Available to Help" status | P2 |
| US-T025 | Receive notifications for summon requests | P2 |
| US-T026 | Respond to summon requests, join chat/video | P2 |
| US-T027 | Earn goodwill points (10-25) for helping via Summon | P2 |
| US-T028 | Earn goodwill points (5) for answering chat questions | P2 |
| US-T029 | Earn availability bonus points (5/day) for being available | P2 |

**Platform (10 stories):**

| Story | Description | Priority |
|-------|-------------|----------|
| US-P051 | Track goodwill points for user actions | P2 |
| US-P052 | Calculate power user tiers based on points | P2 |
| US-P053 | Display leaderboards/rankings *(route exists at `/discover/leaderboard`, blocked on points data)* | P3 |
| US-P058 | Track ST points for teaching activity | P2 |
| US-P077 | Track goodwill point transactions | P2 |
| US-P078 | Enforce anti-gaming rules (daily caps, cooldowns, 5-min minimums) | P2 |
| US-P079 | Auto-award points for certain actions (availability, first mentoring, referrals) | P2 |
| US-P080 | Display available helpers count per course | P2 |
| US-P081 | Track summon help requests (create, respond, complete) | P2 |
| US-P082 | Unlock rewards at point thresholds (500, 1000, 2500, 5000) *(route exists at `/discover/leaderboard`, blocked on points data)* | P3 |

### GOODWILL.SCHEMA
*New database tables for points and summon help*

- [ ] `goodwill_points` — per-user balance and tier
- [ ] `goodwill_transactions` — point earn/spend ledger with action type, amount, cooldown tracking
- [ ] `summon_requests` — help requests (student → available S-T) with status lifecycle
- [ ] `point_thresholds` — tier definitions and reward unlocks (500/1000/2500/5000)

### GOODWILL.POINTS_ENGINE
*Core points tracking and calculation — US-P051, US-P052, US-P058, US-P077, US-P079*

- [ ] Points service: earn, spend, query balance
- [ ] Action→points mapping (participation, teaching, mentoring, referrals)
- [ ] Auto-award on triggers (first mentoring, daily availability)
- [ ] Power user tier calculation from cumulative points
- [ ] Transaction history API for private balance view (US-S067)
- [ ] Public profile points display (US-S068)

### GOODWILL.SUMMON_HELP
*Peer help system — US-S062, US-S063, US-S064, US-T024, US-T025, US-T026, US-T027*

- [ ] "Available to Help" toggle on S-T dashboard (US-T024)
- [ ] Available helpers count on course page (US-S063, US-P080)
- [ ] Summon request creation (student → matched S-T)
- [ ] Notification to available S-Ts (US-T025)
- [ ] Accept/join flow — chat or video (US-T026)
- [ ] Post-session points award slider: 10-25 points (US-S064, US-T027)
- [ ] Chat "This Helped" points: 5 points (US-S066, US-T028)
- [ ] S-T daily availability bonus: 5 points/day (US-T029)
- [ ] `/help` page UI (links to PAGES-DEFERRED.HELP)

### GOODWILL.TIERS
*Tiers, leaderboard, and rewards — US-S031, US-P053, US-P082*

- [ ] Tier display on user profiles and dashboards (US-S031)
- [ ] Wire `/discover/leaderboard` to live points data (US-P053, route exists)
- [ ] Reward unlocks at thresholds (US-P082)

### GOODWILL.ANTI_GAMING
*Abuse prevention — US-P078*

- [ ] Daily points cap per user
- [ ] Cooldown between summon sessions (e.g., 5-min minimum)
- [ ] Duplicate award prevention
- [ ] Admin visibility into anomalous point patterns

---

## Deferred: FEED-PROMOTION

**Focus:** Spend goodwill points or pay to promote posts/courses in feeds
**Status:** ⏸️ DEFERRED (post-MVP, P2/P3 only)
**Stories:** 3 (1 P2 + 2 P3)
**Source:** CD-024, CD-032
**Depends on:** GOODWILL (points spending), FEEDS (ranked feed support)

### Story Inventory

| Story | Description | Priority |
|-------|-------------|----------|
| US-S071 | Spend goodwill points to promote post to main feed | P3 |
| US-P085 | Process feed promotion requests (backend) | P3 |
| US-C047 | Pay for promoted placement of courses in feeds *(gap story — needs design)* | P2 |

### FEED-PROMOTION.USER
*Students spend goodwill points to boost posts — US-S071, US-P085*

- [ ] "Promote" action on post (spend X points)
- [ ] Backend: deduct points, set `promoted` flag on feed activity
- [ ] Promoted post rendering (badge/indicator in feed)
- [ ] Ranked feed integration (boosted weight for promoted posts)

### FEED-PROMOTION.CREATOR
*Creators pay to promote courses — US-C047*

- [ ] Promote course placement in discovery/feeds (paid, not points-based)
- [ ] Payment flow (Stripe) for promotion purchase
- [ ] Promotion duration and visibility rules
- [ ] Suggested route: `/creating/studio` or `/creating` settings

---

## Post-MVP Phases

*After PMF confirmation:*

| Phase | Purpose | Notes |
|-------|---------|-------|
| 11 | Goodwill Points System | → See **GOODWILL** block (25 stories) |
| 12 | Gamification (leaderboards, badges) | Partially covered by **GOODWILL.TIERS** |
| 13 | Database Backups & Disaster Recovery | |
| 14 | Full Legal/Compliance Review | |
| 15 | Scalability Optimization | |
| 16 | Mobile/PWA + R2 Video Streaming | |
| 17 | User Documentation/Help Center | |
| 18 | Localization/i18n | |

*Additional deferred features:*
- Certificate PDF generation (from CERTS block)
- "Schedule Later" video booking (from VIDEO block)
- Feed promotion (see **FEED-PROMOTION** block, 3 stories)

---

## Unimplemented Story Summary

**32 stories** remain unimplemented out of 402 total (92% complete). All are P2 or P3 — **zero P0/P1 gaps**.

| Block | Stories | Priority | Notes |
|-------|---------|----------|-------|
| GOODWILL | 25 | P2 (23), P3 (2) | Largest cluster — full subsystem |
| FEED-PROMOTION | 3 | P2 (1), P3 (2) | Depends on GOODWILL + FEEDS |
| PAGES-DEFERRED (CHAT) | 2 | P2 | Superseded by community feeds |
| PAGES-DEFERRED (SUBCOM) | 2 | P3 | User-created study groups |
| PAGES-DEFERRED (CNEW) | 1 | P3 | Creator newsletters |
| PAGES-DEFERRED (CLOG) | 1 | P2 | Changelog — gap story, no route |
| **Total** | **34** | | |

*Source: [ROUTE-STORIES.md](ROUTE-STORIES.md) §10 (On-Hold) and §11 (Gap)*

*Note: Count is 34 including US-P053 and US-P082 which have routes (`/discover/leaderboard`) but are blocked on the goodwill points data they need to display.*

---

*Last Updated: 2026-03-05 Session 334 (BBB session completion healing — shared completeSession(), teacher/creator manual complete endpoint, admin PATCH wired to shared function)*
