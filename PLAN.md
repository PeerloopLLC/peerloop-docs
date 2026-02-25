# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| TESTING | Test Coverage Expansion | 🔄 In Progress |
| CURRENTUSER | Global User State Management | 🟡 Nearly Complete (PUBLIC deferred) |

### ON-HOLD

(None currently)

### DEFERRED

| Priority | Block | Name |
|----------|-------|------|
| 1 | S-T-CALENDAR | Availability Calendar & Creator-as-ST |
| 2 | RATINGS | Ratings & Feedback System |
| 3 | FEEDS | Feed Architecture & Algorithmic Feeds |
| 4 | ROLES | Admin Role Management |
| 5 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred) |
| 6 | ESCROW | Payment Hold & Escrow |
| 7 | POLISH | Production Readiness |
| 8 | OAUTH | OAuth Provider Setup (status TBD) |
| 9 | MVP-GOLIVE | Production Go-Live |
| 10 | SENTRY | Error Tracking |
| 11 | IMAGE-OPTIMIZE | Image Optimization |
| 12 | KV-CONSISTENCY | KV Consistency Audit |
| 13 | PAGES-DEFERRED | Deferred Pages (6) |

---

## In Progress: TESTING

**Focus:** Critical E2E flows and webhook testing
**Status:** 🔄 IN PROGRESS

**Completed:** API tests (169 files), component tests (64 files), page tests (60/60), SSR data layer tests (40 tests). See `tests/README.md`.

### TESTING.E2E
*Critical user flow tests (Playwright)*

**Scope:** 3 flows for MVP confidence

- [ ] **Browse → Enroll:** CBRO → CDET → checkout → CSUC
- [ ] **Auth → Dashboard:** LGIN → SDSH → view enrollments
- [ ] **Admin Overview:** admin login → ADMN → AUSR → view user

### TESTING.WEBHOOKS (Deferred)
*Deferred until manual integration testing complete*

- Stripe webhooks (payment_intent.succeeded, payout.paid)
- BBB callbacks (meeting_ended)

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

**Current reality:** Login, signup, and reset-password all use AppLayout. No `/welcome` page exists. Most planned public pages (terms, privacy, about, etc.) don't exist yet.

**When to revisit:** When standalone public pages are added that need API calls or networkState without AppLayout.

---

## Next Action: RESEND-DOMAIN

**Focus:** Verify sending domain in Resend to unblock email testing
**Status:** 📋 PENDING (Client action required)
**Effort:** ~5 minutes

**Why now:** API key is verified working (Session 252), but without a verified domain Resend restricts recipients to the account owner only. No email notifications can be tested until this is done — it blocks moderator invites, creator application notifications, payment receipts, etc.

**Steps (client does this in Resend + Cloudflare dashboards):**
- [ ] Log into Resend dashboard → Domains → Add domain (`mail.peerloop.com` recommended, or `peerloop.com`)
- [ ] Copy the 3 DNS records Resend provides
- [ ] Log into Cloudflare dashboard → DNS for `peerloop.com` → Add the 3 records
- [ ] Back in Resend → Click Verify → Confirm green checkmark
- [ ] Test: send email to a non-owner address (e.g., `fgorrie@bio-software.com`)

**After verification:**
- Update `from` address in `src/lib/email.ts` if using subdomain (e.g., `notifications@mail.peerloop.com`)
- All dev/staging email testing unblocked

---

---

## Deferred: S-T-CALENDAR

**Focus:** Enhanced availability management — month views, exception dates, and Creator-as-ST toggle
**Status:** 📋 PENDING (needs planning)

**Completed:** Creator-teaching foundation — self-certification API (skip enrollment check for creator), auto-set `can_teach_courses`, payment split fix (creator-as-ST keeps 85/15), "Course Creator" badge on S-T listings, "My Teaching" card on Creator Dashboard, `CurrentUser` helpers (`getCoursesTeachingAsCreator`, `isTeachingOwnCourse`), seed data (Guy as S-T for all courses), enrollment query bugfix (`student_id` not `user_id`), 17 new tests. (Session 282)

### S-T-CALENDAR.CONTEXT

**Current State (Session 282 update):**

| Component | Status | Location |
|-----------|--------|----------|
| Weekly availability editor (7-day grid) | ✅ Implemented | `AvailabilityEditor.tsx` |
| `PUT /api/me/availability` (save recurring slots) | ✅ Implemented | `src/pages/api/me/availability.ts` |
| `GET /api/student-teachers/[id]/availability` (expand to dates) | ✅ Implemented | Expands weekly → concrete dates, 2-week lookahead |
| Timezone support (24 timezones) | ✅ Implemented | Validated on save |
| Buffer time between sessions | ✅ Implemented | 0-60 minutes configurable |
| Conflict detection (booked sessions excluded) | ✅ Implemented | In availability lookup |
| Creator self-certification as S-T | ✅ Implemented | `student-teachers.ts` POST (Session 282) |
| Payment split: creator-as-ST (85/15) | ✅ Implemented | `create-session.ts` (Session 282) |
| "Course Creator" badge on S-T listings | ✅ Implemented | `CourseTabs.tsx`, `CourseSTList.tsx` (Session 282) |
| "My Teaching" card on Creator Dashboard | ✅ Implemented | `CreatorTeachingSummary.tsx` (Session 282) |
| Month-view availability editor | ❌ Missing | — |
| One-off exceptions (vacation, holidays) | ❌ Missing | — |
| Creator-as-ST availability toggle | ❌ Missing | — |

**The weekly-only limitation:** The current editor shows a generic week — Mon-Sun with time slots. Students booking via `SessionBooking.tsx` see a month calendar with available dates highlighted, but the *editor* is week-only. S-Ts can't say "I'm unavailable next Thursday specifically" or "I'm available every day this month except the 15th."

**The Creator-as-ST toggle problem:** Creators can now self-certify as S-Ts and teach their own courses with proper payment splits and dashboard visibility. But there's no mechanism for a Creator to say "I'm stepping back from teaching — let my S-Ts handle it" without deactivating their entire ST certification. They need a lightweight toggle that:
- Hides them from student booking while active S-Ts exist
- Auto-activates them when no other S-Ts are available (fill-the-gap)
- Or simply lets them manually toggle teaching availability on/off

### S-T-CALENDAR.MONTH-VIEW
*Month-based availability editor alongside or replacing weekly view*

- [ ] Design decision: replace weekly editor, or add month view as second tab?
- [ ] Month grid showing recurring slots expanded to real dates
- [ ] Click date to override: add extra availability or mark unavailable
- [ ] Visual distinction: recurring (from weekly pattern) vs one-off (override)
- [ ] Navigate between months (next/previous)
- [ ] Sync: changes to weekly pattern auto-reflect in month view

### S-T-CALENDAR.EXCEPTIONS
*One-off availability overrides*

- [ ] New `availability_exceptions` table (or add `is_recurring = 0` rows to `availability`)
- [ ] `POST /api/me/availability/exceptions` — Add exception date (unavailable or extra available)
- [ ] `DELETE /api/me/availability/exceptions/:id` — Remove exception
- [ ] Update `GET /api/student-teachers/[id]/availability` to subtract exceptions from expanded slots
- [ ] UI: click a date in month view → "Mark Unavailable" / "Add Extra Hours"
- [ ] Bulk exceptions: "Block Dec 24-Jan 2" for holidays
- [ ] Write tests for exception logic (recurring slot minus exception = no availability)

### S-T-CALENDAR.CREATOR-AS-ST
*Creator teaching availability toggle*

**The problem:** Creators who are also S-Ts for their own courses can crowd out dedicated S-Ts. A Creator may want to teach occasionally (when S-Ts are busy) but not appear as the default booking option.

- [ ] Design decision: per-course toggle vs global toggle?
- [ ] Add `teaching_active` flag to `student_teachers` table (or use `is_active` with clearer semantics)
- [ ] UI toggle on Creator dashboard or teaching settings: "Available to teach [Course X]"
- [ ] When toggled off: Creator's ST record stays but doesn't appear in booking availability
- [ ] When toggled on: Creator appears as bookable S-T alongside other S-Ts
- [ ] Auto-activate logic (optional): if course has zero active S-Ts, Creator auto-becomes available
- [ ] Update `GET /api/student-teachers/[id]/availability` to respect toggle
- [ ] Update `SessionBooking.tsx` teacher selection to filter by active teaching status

### S-T-CALENDAR.BOOKING-INTEGRATION
*Ensure calendar changes flow to student booking*

- [ ] Month-view exceptions reflected in student booking calendar immediately
- [ ] Creator-as-ST toggle reflected in teacher picker immediately
- [ ] Lookahead window: configurable (currently 2 weeks) — extend to 4 weeks for month view?
- [ ] Time zone display: show S-T's timezone + student's timezone side by side

### S-T-CALENDAR.TESTING

- [ ] Exception override tests: recurring + exception = correct available slots
- [ ] Creator-as-ST toggle tests: toggled off → not bookable, toggled on → bookable
- [ ] Month-view expansion tests: weekly pattern correctly fills month grid
- [ ] Booking conflict tests: exception on date with existing booking → warn/block
- [ ] Edge cases: S-T changes timezone mid-week; exception on a day with no recurring slot

---

## Deferred: RATINGS

**Focus:** Multi-level rating system for teaching quality and course materials
**Status:** 📋 PENDING
**Tech Doc:** `docs/tech/tech-022-ratings-feedback.md`

### RATINGS.CONTEXT

**Current State (Session 178):**
- `session_assessments` - Existing table for post-session pulse ratings (mutual ST↔Student)
- `enrollment_reviews` - New table for completion reviews (Student→ST teaching quality)
- `student_teachers.rating` / `rating_count` - Added columns for per-course ST ratings

**Gap:** Course materials quality (Creator's work) is rated together with teaching quality (ST's work). Students cannot distinguish between "great teacher, outdated materials" vs "weak teacher, excellent materials."

**Solution:** Two new features:
1. **Course Materials Rating** - Separate `course_reviews` table for content quality
2. **Enrollment Expectations** - Capture student goals at enrollment for review context

### RATINGS.MATERIALS
*Course materials rating system (course_reviews table)*

**Schema:**
```sql
CREATE TABLE IF NOT EXISTS course_reviews (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL UNIQUE REFERENCES enrollments(id) ON DELETE CASCADE,
  reviewer_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id TEXT NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT NOT NULL,
  clarity_rating INTEGER CHECK (clarity_rating >= 1 AND clarity_rating <= 5),
  relevance_rating INTEGER CHECK (relevance_rating >= 1 AND relevance_rating <= 5),
  depth_rating INTEGER CHECK (depth_rating >= 1 AND depth_rating <= 5),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

**Tasks:**
- [ ] Add `course_reviews` table to schema
- [ ] Add `rating`, `rating_count` columns to `courses` table
- [ ] Create `POST /api/enrollments/:id/course-review` endpoint
- [ ] Create `GET /api/enrollments/:id/course-review` endpoint
- [ ] Create `GET /api/courses/:id/reviews` endpoint (public listing)
- [ ] Update `CourseReviewModal` to two-step flow (ST review → Materials review)
- [ ] Add course rating display to course detail page
- [ ] Add course rating badge to browse/search cards
- [ ] Add materials feedback to Creator dashboard
- [ ] Write tests for course review endpoints

### RATINGS.EXPECTATIONS
*Student expectations capture at enrollment*

**Schema:**
```sql
CREATE TABLE IF NOT EXISTS enrollment_expectations (
  id TEXT PRIMARY KEY,
  enrollment_id TEXT NOT NULL UNIQUE REFERENCES enrollments(id) ON DELETE CASCADE,
  primary_goal TEXT CHECK (primary_goal IN ('career_change', 'skill_upgrade', 'personal_interest', 'academic', 'other')),
  timeline TEXT CHECK (timeline IN ('under_1_month', '1_to_3_months', '3_to_6_months', 'no_rush')),
  prior_experience TEXT CHECK (prior_experience IN ('beginner', 'some_exposure', 'intermediate', 'advanced')),
  referral_source TEXT CHECK (referral_source IN ('search', 'social', 'referral', 'creator_content', 'other')),
  learning_hopes TEXT NOT NULL,
  additional_notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT,
  update_count INTEGER NOT NULL DEFAULT 0
);
```

**Tasks:**
- [ ] Add `enrollment_expectations` table to schema
- [ ] Create `POST /api/enrollments/:id/expectations` endpoint
- [ ] Create `GET /api/enrollments/:id/expectations` endpoint
- [ ] Create `PATCH /api/enrollments/:id/expectations` endpoint (update after sessions)
- [ ] Add expectations capture to post-purchase confirmation page
- [ ] Add "Update your goals?" prompt to session rating view
- [ ] Display expectations alongside reviews in Creator/ST dashboard
- [ ] Write tests for expectations endpoints

### RATINGS.DISPLAY
*Rating display and analytics*

- [ ] Show completion reviews on ST profile page (`/@handle`)
- [ ] Add rating trend charts to ST analytics (`/teaching/analytics`)
- [ ] Add rating breakdown by course to Creator dashboard
- [ ] Show course materials rating on course browse/search

### RATINGS.OPEN_QUESTIONS

| Question | Options | Status |
|----------|---------|--------|
| Module-level ratings? | Rate individual modules as completed | 🔄 Considering |
| Sub-rating weighting | Affect overall or just context? | 🔄 Considering |
| Minimum reviews for display | Show rating only after N reviews? | 🔄 Considering |
| Review responses | Allow STs to respond to reviews? | 🔄 Considering |
| Expectations privacy | Hide from public review display? | 🔄 Considering |
| Expectations history | Store versioned history or just current? | 🔄 Considering |

---

## Deferred: FEEDS

**Focus:** Stream.io feed architecture decisions and algorithmic feed configuration
**Status:** 📋 PENDING
**Tech Doc:** `docs/tech/tech-002-stream.md` (Ranked Feeds section added Session 180)

### FEEDS.CONTEXT

**Current State (Session 180):**
- `townhall:main` feed exists — platform-wide community feed
- TownHallFeed component with client-side course filtering
- No ranked/algorithmic ordering configured
- No per-course feeds implemented yet

**Key Findings from Research:**
1. **Stream v2 cannot filter by custom fields server-side** — separate feeds needed for each filterable category
2. **Ranked feeds cannot combine with date filtering** — no "top posts since yesterday" server-side
3. **Client-side filtering doesn't scale for mobile** — downloading thousands of posts to filter locally is unacceptable
4. **Ranked feeds support external parameters** — per-user personalization at query time
5. **Separate feeds have no per-feed cost** — pricing is API calls + activities, not feed count

### FEEDS.ARCHITECTURE
*Decide feed structure based on use cases*

**Options to Evaluate:**

| Option | Feeds Created | Use Case Fit | Trade-offs |
|--------|---------------|--------------|------------|
| **A: Townhall Only** | 1 | Simple community | No filtering, all-or-nothing |
| **B: Townhall + Per-Course** | 1 + N courses | Course discussions | Write to 2 feeds per course post |
| **C: Townhall + Announcements + Per-Course** | 2 + N | Separated content types | 2-3 writes per post |
| **D: Per-Course Only** | N | No global community | Isolated silos |
| **E: Townhall + Per-User** | 1 + N users | Personal timelines | Fan-out complexity |

**Decision Criteria:**
- [ ] Does client need "show only announcements"? → Separate announcements feed
- [ ] Does client need "show only course X posts"? → Per-course feeds required
- [ ] Does client need "show my followed content"? → Timeline/following feeds
- [ ] Does client need global community view? → Townhall feed
- [ ] What's the expected post volume per day?
- [ ] What's the expected number of courses at scale?

**Tasks:**
- [ ] Discuss with client: What filtering use cases are required?
- [ ] Discuss with client: Is algorithmic ranking wanted? (requires paid tier)
- [ ] Document chosen architecture in DECISIONS.md
- [ ] Update `docs/tech/tech-002-stream.md` with final architecture

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

### FEEDS.LIMITATIONS
*Document and plan for Stream v2 limitations*

**Cannot Do Server-Side:**
- Filter by custom fields (e.g., "only posts about Python")
- Combine ranked feeds with date ranges (e.g., "top posts since yesterday")
- Full-text search across posts

**Platform Constraint:**
- Stream real-time SDK is Node-only; incompatible with Cloudflare Workers. Real-time feed updates require polling or a future WebSocket solution.

**Workarounds:**

| Limitation | Workaround | Implementation |
|------------|------------|----------------|
| Filter by topic | Separate feeds per topic | Fan-out on write |
| Date + ranking | Aggressive time decay | Tune decay function |
| Text search | D1 FTS5 index | Hybrid D1 + Stream |

**Tasks:**
- [ ] Identify which limitations affect PeerLoop use cases
- [ ] Choose workaround strategy for each
- [ ] Document in DECISIONS.md

### FEEDS.IMPLEMENTATION
*Implementation tasks after architecture decisions*

- [ ] Create feed groups in Stream Dashboard
- [ ] Update `src/lib/stream.ts` for new feed operations
- [ ] Create API endpoints for each feed type
- [ ] Update post creation to fan-out to multiple feeds (if needed)
- [ ] Implement user preferences UI (if personalized feeds)
- [ ] Update TownHallFeed component for new architecture
- [ ] Create course-specific feed component (if per-course feeds)
- [ ] Write tests for feed operations
- [ ] Document feed architecture in tech doc

### FEEDS.MOBILE
*Ensure mobile-friendly feed performance*

**Requirements:**
- Max 25 activities per API call
- Pagination via `limit` + `offset` (ranked) or `id_lt` (chronological)
- No client-side filtering of large datasets
- Efficient caching strategy

**Tasks:**
- [ ] Verify all feed queries use pagination
- [ ] Test feed load times on mobile network (3G simulation)
- [ ] Implement feed caching in React Query or similar
- [ ] Add loading skeletons for feed pagination

### FEEDS.OPEN_QUESTIONS

| Question | Options | Status |
|----------|---------|--------|
| Paid tier for ranked feeds? | Free (chronological only) vs Paid (ranked) | 🔄 Awaiting client input |
| Per-course feeds needed? | Yes (separate) vs No (tags only) | 🔄 Awaiting client input |
| Announcements separate? | Dedicated feed vs Tag in townhall | 🔄 Awaiting client input |
| User personalization? | Fixed ranking vs Per-user weights | 🔄 Awaiting client input |
| Real-time updates? | Polling vs WebSocket (future) | 📋 Deferred |

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

**What's done:** Complete Stripe Connect integration — checkout, transfers (with idempotency keys), refunds, 7 webhook handlers (including dispute handling with transfer reversal), self-healing status sync, Express onboarding flow tested end-to-end. Staging webhook active at `staging.peerloop.pages.dev` (Session 224).

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
- [ ] Stripe Event Polling via Cron Trigger — catch-up for missed webhooks (no user-triggered self-healing for transfers, disputes, payout failures)
- [ ] Extended self-healing — reconcile transfer/dispute status on relevant page loads (alongside Cron Trigger)
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

**Focus:** 6 pages deferred per client directive — not yet designed for the Twitter-style left-side menu layout
**Status:** ⏸️ DEFERRED (post-MVP, pending client direction)

**Open question:** Current app pages use a Twitter-like left-side menu navigation. These more traditional/standard pages need layout decisions — do they use the same left-side menu pattern, or a different layout?

| Code | Page | Route | Notes |
|------|------|-------|-------|
| HELP | Summon Help | `/help` | Post-MVP |
| BLOG | Blog | `/blog` | Content not ready |
| CARE | Careers | `/careers` | Content not ready |
| CHAT | Course Chat | `/courses/:slug/chat` | Post-MVP |
| CNEW | Creator Newsletters | `/dashboard/creator/newsletters` | Post-MVP |
| SUBCOM | Sub-Community | `/groups/:id` | Post-MVP |

---

## Post-MVP Phases

*After PMF confirmation:*

| Phase | Purpose |
|-------|---------|
| 11 | Goodwill Points System |
| 12 | Gamification (leaderboards, badges) |
| 13 | Database Backups & Disaster Recovery |
| 14 | Full Legal/Compliance Review |
| 15 | Scalability Optimization |
| 16 | Mobile/PWA + R2 Video Streaming |
| 17 | User Documentation/Help Center |
| 18 | Localization/i18n |

*Additional deferred features:*
- Certificate PDF generation (from CERTS block)
- "Schedule Later" video booking (from VIDEO block)

---

*Last Updated: 2026-02-25 Session 285 (Full seed data overhaul: all 58 schema tables seeded, community/course restructuring, 2 Gabriel Q-System courses, mock-data.ts updated, 5,283 tests passing.)*
