# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| ~~CURRENTUSER~~ | ~~Global User State Management~~ | ✅ COMPLETE — Conv 024 → COMPLETED_PLAN.md |
| ~~DATETIME-FIX~~ | ~~SQLite datetime() vs ISO String Comparison Fix~~ | ✅ COMPLETE — Conv 027 → COMPLETED_PLAN.md |
| DEV-WEBHOOKS | Dev Webhook Environment — scripted setup for Stripe + BBB webhook testing | 📋 PENDING |
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING |
| ~~FEED-INTEL~~ | ~~Feed Intelligence Layer~~ | ✅ COMPLETE → COMPLETED_PLAN.md |
| ~~SMART-FEED~~ | ~~Smart Feed~~ | ✅ COMPLETE → COMPLETED_PLAN.md |
| ~~IMAGES-DISPLAY~~ | ~~Entity Image Display~~ | ✅ COMPLETE — Conv 023 → COMPLETED_PLAN.md |
| ~~TEACHER-COURSE-VIEW~~ | ~~Teacher Course Detail Page~~ | ✅ COMPLETE — Conv 030 → COMPLETED_PLAN.md |
| ~~ROLE-AWARE-PAGE-FEATURES~~ | ~~Role-Aware Page Features — contextual links/actions per viewer role using CurrentUser~~ | ✅ COMPLETE — Conv 046 → COMPLETED_PLAN.md |
| ~~UNIFIED-DASHBOARD~~ | ~~Unified Member Dashboard — single `/dashboard` page combining Learning/Teaching/Creating views~~ | ✅ COMPLETE — Conv 054 → COMPLETED_PLAN.md |
| ~~EXPLORE-COURSES~~ | ~~Role-Aware Explore Course Pages~~ | ✅ COMPLETE — Conv 042 → COMPLETED_PLAN.md |
| DOC-SYNC-STRATEGY | Documentation Sync Strategy — reduce manual doc maintenance, automate drift detection | 📋 PENDING |
| ~~EXPLORE-COMMUNITIES-FEEDS~~ | ~~Role-Aware Community & Feed Discovery — extend explore pattern to `/discover/communities` and `/discover/feeds`~~ | ✅ COMPLETE — Conv 045 → COMPLETED_PLAN.md |
| ~~TAG-TAXONOMY~~ | ~~Tag Taxonomy Redesign — rename categories→topics, topics→tags, multi-tag courses~~ | ✅ COMPLETE — Conv 054 → COMPLETED_PLAN.md |
| ~~ADMIN-INTEL~~ | ~~Admin Intelligence Layer — contextual admin content on member-facing pages~~ | ✅ COMPLETE — Conv 058 → COMPLETED_PLAN.md |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |

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
| 12 | EXTRA-SESSIONS | Extra Session Purchases — allow students to buy additional sessions with the same Teacher beyond the course plan |
| 13 | GOODWILL | Goodwill Points & Summon Help System (25 stories, all P2/P3) |
| 14 | FEED-PROMOTION | Feed Promotion — points & paid placement (3 stories, all P2/P3) |
| 15 | COURSE-LIMIT | Creator Course Limit — default 3 courses for new creators, admin-adjustable per user |
| 16 | POSTHOG | Product Analytics — SDK integration, event tracking, session replays |
| 17 | MOCK-DATA-MIGRATION | Component Data Migration — remove mock-data imports, wire real API data |
| 18 | RATINGS-EXT | Ratings Extensions — enrollment expectations, materials rating, display |
| 19 | SESSION-CREDITS | Session Credits — free sessions from disputes, promotions, referrals, goodwill | Schema exists (`session_credits`); only used in admin dispute resolution. Discovered Session 348. |
| 20 | COURSE-FOLLOWS | Course Follows — subscribe to course updates without enrolling | Schema exists (`course_follows`); no code implementation. Discovered Session 348. |
| 21 | AVAIL-OVERRIDES | Availability Overrides — one-off schedule exceptions for teachers | Schema exists (`availability_overrides`); feature not built. Discovered Session 348. |
| 22 | CERT-APPROVAL | Certificate Lifecycle — student page, creator approval, PDF generation, public view | 4 phases: (1) student cert page + dead link fixes, (2) creator approval flow, (3) PDF generation + R2, (4) public shareable page. 7 admin/API endpoints built, 0 UI pages. See expanded block below. |
| 23 | FILE-UPLOADS | File Upload Endpoints — dedicated upload API for profile photos, course materials | R2 helpers exist; no POST upload endpoints. Includes user avatar upload/selection (currently static placeholder). Capabilities review Session 359; Conv 007 seed data review. |
| 24 | AUDIT-LOG | User Activity Audit Log — daily-rotating action log with per-user isolation | No logging infrastructure exists. Capabilities review Session 359. |
| 25 | ~~CURRENTUSER-REFRESH~~ | ~~CurrentUser Refresh~~ — absorbed into CURRENTUSER-OPTIMIZE Phase 1 |
| 26 | E2E-LIFECYCLE | E2E Lifecycle Tests — cross-user flows that verify end-to-end UI behavior |
| 27 | WORKFLOW-TESTS | Branching Workflow Tests — integration tests for multi-step flows with decision-point variants |
| 28 | EMAIL-TZ | Per-User Timezone in Emails — format notification/email times in recipient's timezone (requires `timezone` column on users table) |
| 29 | PUBLIC-PAGES | Public Page Coherence — unified header/footer/nav/currentUser strategy for public pages |
| 30 | E2E-GAPS | E2E Test Gaps — Playwright tests for multi-user flows not coverable by integration tests |
| 31 | RECORDING-PERSIST | Session Recording Persistence — capture BBB recording URLs and store recordings to R2 | Cookie-based `.m4v` download implemented (Conv 037, CD-038). Schema updated. Needs end-to-end verification + admin UI. |
| 32 | MSG-TEACHER | Message Teacher from Course Page — "Message" button on availability cards for logged-in users | Requires messaging feature extension. Noted during ENROLL-AVAIL (Conv 008). |
| 33 | ADMIN-SETTINGS-UI | Admin Settings UI — edit platform_stats values (availability_window_days, smart_feed_*, etc.) | No admin UI for platform settings yet. `availability_window_days` added Conv 008. 13 smart_feed_* parameters added Conv 017-020 (weights, decay, page size, diversity cap, discovery frequency/max). |
| 34 | FEED-PRIVACY | Community & Course Feed Privacy Toggle — creator/admin can set communities and course feeds to private | Schema: `communities.is_public` exists (default 1); courses need `feed_public` column (default 1). No toggle UI or API exists. SMART-FEED discovery respects these flags. Conv 017. |
| 35 | IMAGE-MGMT | Image Management — upload, crop, and manage images for users, courses, communities, and The Commons | **Display complete** (Conv 023: unified fallback, community covers, FeedsHub images, feed avatar enrichment). Schema columns exist. R2 helpers exist but no upload endpoints. Remaining: user avatar upload/selection, course thumbnail upload (creator), community cover upload (creator), admin override for The Commons image. Extends FILE-UPLOADS block. |
| 36 | RESPONSIVE | Responsive & Mobile Review — site-wide responsive audit across all pages and breakpoints | No systematic mobile review done yet. Dashboard sub-column layouts (`lg:grid-cols-2`), calendar views, feed pages all need verification. Conv 034. |
| 37 | ~~CONTEXT-ACTIONS-FAB~~ | ~~Context Actions FAB Retrofit~~ | Superseded by ADMIN-INTEL (Conv 056). Original concept of page-level action buttons per role absorbed into ADMIN-INTEL's entity-centric admin content approach. |
| 38 | ~~ADMIN-PAGE-ROLE~~ | ~~Admin Role in Page UIs~~ | Superseded by ADMIN-INTEL (Conv 055). Original Conv 046 insight expanded into full block with 6 phases. |

---

---


## Deferred: E2E-GAPS

**Focus:** Playwright E2E tests for multi-user flows not coverable by integration tests
**Status:** 📋 PENDING

### E2E-GAPS.SESSION-INVITE

- [ ] Two-browser Playwright test: Teacher sends invite → Student sees notification → Student accepts → Session created → Both land in session room
- [ ] Reschedule variant: All modules booked → invite reschedules next session
- [ ] Expired invite: Student clicks stale notification → expiry message shown
- [ ] Decline flow: Student declines → redirected to course page

### E2E-GAPS.BOOKING

- [ ] Full booking wizard: teacher select → date → time → confirm → session room
- [ ] Reschedule via booking page: cancel old session → pick new time

### E2E-GAPS.SESSION-LIFECYCLE

- [ ] Session join → video room → completion → rating (two-browser)

---

## Active: FEED-INTEL

**Focus:** D1 activity index alongside Stream.io — Stream stores content durably, D1 provides cross-feed queries, unread counts, and smart surfacing
**Status:** ✅ Phase 1 DONE (Conv 015-016), Phase 2-3 future
**Conv:** 015-016

**Problem:** Stream.io flat feeds are a chronological append log. They store posts, reactions, and comments reliably, but cannot answer: "How many new posts since this user last visited?" or "Show me recent activity across ALL my feeds ranked by relevance." Every cross-feed query requires N separate Stream API calls with client-side aggregation. This blocks the client's vision of feeds as 50% of learning.

**Root cause:** Stream's flat feeds don't support:
- Unread/unseen counts per user (only notification feeds do)
- Activity count since a timestamp
- Cross-feed aggregation queries
- Server-side filtering by date range on ranked feeds

**Solution: CQRS pattern — Stream as write model, D1 as read model**

Stream stays as the durable content store (posts, reactions, comments, threading). D1 gets a thin metadata index (~150 bytes/row) that answers navigation questions: "what happened since I last looked?"

### Schema Design

```sql
-- When did user last visit each feed?
CREATE TABLE feed_visits (
  user_id TEXT NOT NULL,
  feed_type TEXT NOT NULL,        -- 'townhall' | 'community' | 'course'
  feed_id TEXT NOT NULL,          -- community slug or course slug
  last_visited_at TEXT NOT NULL,  -- ISO timestamp
  PRIMARY KEY (user_id, feed_type, feed_id)
);

-- Lightweight index of recent feed activity (content stays in Stream)
CREATE TABLE feed_activities (
  id TEXT PRIMARY KEY,
  feed_type TEXT NOT NULL,
  feed_id TEXT NOT NULL,
  actor_id TEXT NOT NULL,          -- user who posted
  activity_type TEXT NOT NULL,     -- 'post' | 'reply' | 'reaction'
  stream_activity_id TEXT,         -- links back to Stream for full content
  created_at TEXT NOT NULL
);
CREATE INDEX idx_feed_activities_feed ON feed_activities(feed_type, feed_id, created_at);
CREATE INDEX idx_feed_activities_created ON feed_activities(created_at);
```

### How It Works

**Post creation (write-time indexing):**
1. Existing: call `stream.addActivity()` → post stored in Stream
2. New: INSERT one row into `feed_activities` → index updated
3. No polling needed — every post flows through our API endpoints

**Badge counts on `/feeds` hub:**
```sql
SELECT fa.feed_type, fa.feed_id, COUNT(*) as new_count
FROM feed_activities fa
LEFT JOIN feed_visits fv
  ON fa.feed_type = fv.feed_type
  AND fa.feed_id = fv.feed_id
  AND fv.user_id = ?
WHERE (fa.feed_type, fa.feed_id) IN (/* user's feeds */)
  AND fa.created_at > COALESCE(fv.last_visited_at, '1970-01-01')
GROUP BY fa.feed_type, fa.feed_id
```
→ Single D1 query, zero Stream API calls. Returns badge counts for all feeds at once.

**Feed visit:**
1. User navigates to `/community/python-devs`
2. Upsert `feed_visits` with `last_visited_at = NOW()`
3. Badge clears on next `/feeds` hub load

### Data Lifecycle

- **Retention:** 90-day TTL on `feed_activities`. Weekly cron prunes old rows.
- **Pruning is safe:** D1 index is metadata only. Thread content lives in Stream forever. A pruned row just means a 91-day-old post won't count as "new" (correct behavior).
- **Replies to old posts:** A reply is a new `feed_activities` row (fresh timestamp). Parent post is fetched from Stream when user opens the thread.
- **D1 storage at Genesis scale:** ~80 users × ~10 posts/day × 150 bytes ≈ 45KB/month. Negligible.
- **Rebuild:** If D1 index is lost, it can be rebuilt from Stream (fetch recent activities per feed). No data loss scenario.

### Future Capabilities (unlocked by this architecture)

These are NOT in scope for the initial implementation but become possible:

- **Cross-feed "what's new" digest:** Single SQL query for "all new activity across all my feeds, ordered by recency"
- **Smart surfacing:** "Posts from your teacher," "threads you participated in that got new replies" — SQL joins against users/enrollments
- **Engagement analytics:** Query `feed_activities` for posting patterns, peak hours, most active feeds
- **Real-time badges via SSE:** Push badge updates instead of polling — D1 insert triggers notification

### Implementation Phases

**Phase 1 ✅ (Conv 015-016):** `feed_visits` + `feed_activities` tables, dual-write in all post/comment endpoints, badge API, badge UI on FeedsHub + MyFeeds card, auto-routing `FeedActivityCard`, course comments/reactions endpoints. 18 unit/integration + 12 E2E tests. Architecture doc: `docs/as-designed/feeds.md`.

**Phase 1 deferred item:** Pruning cron for `feed_activities` — observing real D1 data growth before deciding retention period and trigger (Conv 016).

**Phase 2 (future):** Cross-feed "what's new" page — aggregated recent activity from all feeds in a single view, sourced from D1 index, with full content fetched from Stream on expand.

**Phase 3 (future):** Smart surfacing — relevance-ranked feed items using SQL queries against the D1 index joined with user relationship data (enrollments, certifications, etc.).

---

---

## Active: DEV-WEBHOOKS

**Focus:** Scripted dev environment for Stripe + BBB webhook testing
**Status:** 📋 PENDING
**Session:** 342

**Problem:** Testing webhooks locally requires 3+ terminal windows, manual coordination, and tribal knowledge. Stripe CLI must be listening, dev server must be running, signing secrets must match, and seed data must align with trigger payloads. No documentation or automation exists.

### Current State

| Webhook | Local Dev | Integration Tests | E2E Tests |
|---------|-----------|-------------------|-----------|
| **Stripe** | `npm run stripe:listen` (manual, separate terminal) | Handler called directly in Vitest | None |
| **BBB** | Synthetic POST to `/api/webhooks/bbb` (no auth) | Handler called directly in Vitest (18 tests incl. empty-room detection — Conv 025) | `session-completion-flow.spec.ts` fires synthetic payload |

### DEV-WEBHOOKS.SCRIPTS

*Automate the full webhook dev environment*

- [ ] `scripts/dev-webhooks.sh` — orchestrator script:
  - Preflight checks: Stripe CLI installed + authenticated, port 4321 free, BBB vars in `.dev.vars`, local DB seeded
  - Start dev server in background, wait for health check
  - Start Stripe CLI forwarding, verify signing secret matches `.dev.vars`
  - Print ready message with available trigger commands
  - Cleanup on Ctrl+C (kill background processes)
- [ ] `scripts/trigger-webhook.sh <event>` — trigger common webhook scenarios:
  - `stripe-checkout` — `stripe trigger checkout.session.completed`
  - `stripe-refund` — `stripe trigger charge.refunded`
  - `stripe-dispute` — `stripe trigger charge.dispute.created`
  - `bbb-meeting-ended` — synthetic POST with seed data session ID
  - `bbb-all-left` — two `participant_left` events (teacher then student) to trigger empty-room auto-completion (Conv 025)
  - `bbb-recording-ready` — synthetic POST with `rap-publish-ended`
- [ ] npm scripts: `"dev:webhooks"` and `"trigger"` in package.json

### DEV-WEBHOOKS.DATA-ALIGNMENT

*Ensure Stripe trigger events reference valid local DB records*

- [ ] Stripe fixture overrides: `--override checkout_session:metadata.enrollment_id=<seed-id>` so webhook handler finds matching DB records
- [ ] Document which seed data sessions/enrollments are designated for webhook testing
- [ ] Add comments in `migrations-dev/0001_seed_dev.sql` marking webhook-testable records

### DEV-WEBHOOKS.DOCS

- [ ] Update `docs/reference/CLI-QUICKREF.md` with new `dev:webhooks` and `trigger` commands
- [ ] Update `docs/reference/SCRIPTS.md` with new script files
- [ ] Add webhook testing section to `docs/reference/CLI-TESTING.md`

### Design Notes

**BBB is straightforward** — the webhook endpoint has no auth (BBB calls it directly), so synthetic JSON payloads work perfectly. The existing E2E test (`session-completion-flow.spec.ts`) already demonstrates this pattern.

**Stripe is harder because of signature verification** — every payload must be signed with the webhook secret. Stripe CLI handles this automatically when forwarding, but the signing secret it outputs must match `STRIPE_WEBHOOK_SECRET` in `.dev.vars`. The current `.dev.vars` already has the Stripe CLI's local secret (`whsec_dc1e...`), so forwarding works — the script just needs to verify the match and warn on mismatch.

**Data alignment is the hardest part** — `stripe trigger` creates synthetic Stripe objects with Stripe-generated IDs that won't exist in the local DB. Two approaches:
1. **Stripe fixture overrides** (pragmatic) — pass `--override` flags to reference seed data IDs
2. **Full checkout flow** (realistic) — script that creates a real checkout via the API using Stripe test mode, then lets the webhook fire naturally. Slower but tests the full path.

Option 1 is recommended for the initial implementation. Option 2 belongs in WORKFLOW-TESTS.PAYMENT.

---

## Active: CALENDAR

**Focus:** Custom multi-view calendar component system serving all platform roles
**Status:** 📋 PENDING
**Session:** 342

**Vision:** A single, versatile custom calendar component that powers every time-based view on the platform — student schedules, S-T availability and sessions, admin oversight, and activity history. Supports year, month, week, and day views with role-specific data layers, filtering, and clickable items. Built custom (not wrapping a library) to fully control rendering, interaction, and data integration.

### Current State

The platform has three separate calendar-like UIs, each built independently:

| Component | Views | Limitation |
|---|---|---|
| `AvailabilityCalendar` | Month only | No week/day; cell interaction is availability-specific |
| `SessionBooking` (step 2) | Month only | Date picker only; no time-axis view |
| `AvailabilityQuickView` | Static week dots | Not interactive; summary only |

All other schedule UIs (TeacherUpcomingSessions, SessionHistory, StudentDashboard) are lists or tables with no calendar visualization. `react-big-calendar` is installed but unused.

### CALENDAR.CORE — Base Component Architecture

*The shared calendar engine that all role-specific views build on*

- [ ] `PeerloopCalendar` base component with view modes: Year, Month, Week, Day
- [ ] View switcher UI (toolbar with Year | Month | Week | Day toggle)
- [ ] Navigation controls (prev/next, today button, date range display)
- [ ] Timezone-aware date handling (all views respect user timezone)
- [ ] Slot rendering system — calendar "items" rendered as colored blocks/badges:
  - Items have: title, time range, color/category, click handler, optional icon
  - Week/Day views: time-axis layout (vertical hours, items as positioned blocks)
  - Month view: items as compact badges within day cells
  - Year view: heat-map style (activity density per day)
- [ ] Filter bar — toggle data layers on/off (checkboxes or pills)
- [ ] Click-through — items are clickable, navigate to detail page or open detail modal
- [ ] Responsive: week/day views scroll horizontally on mobile; month/year stack vertically
- [ ] Empty state handling per view mode

**Design principle:** The calendar component knows how to render items in time. It does NOT know what the items are. Each integration passes typed item arrays with colors, labels, and click targets.

### CALENDAR.STUDENT — Student Schedule View

*Replace the flat list on StudentDashboard with a real calendar*

- [ ] Week view (default) showing upcoming sessions across all enrolled courses
- [ ] Day view for detailed single-day schedule
- [ ] Month view for planning ahead
- [ ] Data layers:
  - Booked sessions (color-coded by course)
  - Available booking slots (if enrollment has remaining sessions)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click available slot → navigate to booking flow
- [ ] Integration point: StudentDashboard and/or dedicated `/schedule` page

### CALENDAR.TEACHER — Teacher Schedule View

*Unified Teacher calendar replacing AvailabilityQuickView + TeacherUpcomingSessions*

- [ ] Week view (default) showing sessions + availability on the same time axis
- [ ] Day view for detailed daily schedule
- [ ] Month view (replaces or augments existing AvailabilityCalendar)
- [ ] Data layers (toggleable):
  - Booked sessions (color-coded by course or student)
  - Availability windows (recurring slots as background shading)
  - Availability overrides (blocked time, adjusted hours)
  - Buffer time between sessions (visual gap)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click availability block → edit availability
- [ ] Integration point: TeacherDashboard and/or `/teaching/schedule`

**Note:** The existing AvailabilityCalendar with its multi-select-days-and-set-times interaction may remain as a separate editing UI. The CALENDAR.TEACHER view is for *viewing* the schedule, not editing availability.

### CALENDAR.ADMIN — Admin Oversight Calendar

*Platform-wide activity calendar with extensive filtering*

- [ ] All four views: Year, Month, Week, Day
- [ ] Data layers (toggleable, expect this list to grow):
  - **Sessions:** All platform sessions (booked, completed, cancelled, no-show)
  - **Enrollments:** Enrollment events (new, completed, dropped, refunded)
  - **Community activity:** Townhall feed posts, community feed posts
  - **Course activity:** New courses published, materials updated
  - **User events:** Signups, S-T certifications, creator applications
  - **Payments:** Checkout completions, refunds, disputes, payouts
  - **Notifications:** System notifications sent
- [ ] Filters:
  - By role: Student, S-T, Creator, Admin
  - By course: specific course or all
  - By user: specific user or all
  - By event type: sessions, enrollments, community, payments, etc.
  - By status: active, completed, cancelled, etc.
  - Date range quick-picks: Today, This Week, This Month, This Quarter
- [ ] Click any item → navigate to its detail page (session detail, enrollment detail, user profile, etc.)
- [ ] Year view as activity heat map (GitHub-contribution-style) for spotting trends
- [ ] Export/print view (stretch goal)
- [ ] Integration point: Admin dashboard, possibly `/admin/calendar`

### CALENDAR.MIGRATE — Migrate Existing Calendar UIs

*After core is built, migrate existing custom grids to the new system*

- [ ] Evaluate whether `AvailabilityCalendar` editing interaction can use the new month grid or needs to stay separate
- [ ] Migrate `SessionBooking` date picker step to use new month view
- [ ] Replace `AvailabilityQuickView` with a compact week view from the new system
- [ ] Remove `react-big-calendar` from `package.json` (never used, dead dependency)

### CALENDAR.ICS
*.ics calendar file attachments for session booking emails*

**Current state:** `SessionBookingEmail.tsx` sends booking confirmation with BBB link. No `.ics` (iCalendar) file attached. (Capabilities review Session 359)

- [ ] Generate `.ics` file content for booked sessions (VEVENT with start/end, BBB join URL, attendees)
- [ ] Attach `.ics` to `SessionBookingEmail` and `SessionRescheduledEmail`

### Design Notes

**Data fetching pattern:** Each data layer is an independent API call. The calendar component accepts `items: CalendarItem[]` and the parent page fetches and combines layers based on active filters. This keeps the calendar component pure and testable.

```typescript
// Shared item type all data layers produce
interface CalendarItem {
  id: string;
  title: string;
  start: Date;
  end: Date;
  category: string;       // 'session' | 'enrollment' | 'availability' | 'feed' | ...
  color: string;           // Tailwind color class or hex
  icon?: string;           // Optional icon identifier
  href?: string;           // Click-through URL
  onClick?: () => void;    // Or custom click handler
  metadata?: Record<string, unknown>; // Role-specific extra data
}
```

**Phased delivery:** CORE → STUDENT → TEACHER → ADMIN → MIGRATE. Each phase delivers value independently. The admin calendar (most complex) comes last because it has the most data layers and benefits from patterns established in the simpler views.

**Why custom, not react-big-calendar:** The platform needs cell-level control that libraries don't provide — availability multi-select, heat-map year views, togglable data layers with role-specific filtering, and consistent styling with the existing Tailwind design system. A library would fight us on every customization. Building custom means the calendar grows with the platform.

**Week/Day vs Month are architecturally different:** Month view is a grid of day cells with badges. Week/Day views have a vertical time axis (e.g., 6am-10pm) where items are absolutely positioned blocks based on start/end time. The core component must handle both layout modes.

---

## Active: DOC-SYNC-STRATEGY

**Focus:** Reduce manual documentation maintenance burden by automating drift detection and identifying which docs should be generated vs hand-written
**Status:** 📋 PENDING
**Session:** 383

**Problem:** Session 383 exposed that docs drift silently from the codebase. The COURSE-PAGE-MERGE (Session 379) changed tab count, retired components, and merged pages — but 5 architecture/reference docs still described the old structure 2+ sessions later. The TEST-COVERAGE.md rebuild found 258 of 318 test files undocumented. These aren't one-off oversights; they're systemic.

**Root causes to examine:**
- Manually-written docs describing generated artifacts (routes, components, test files) go stale because nothing enforces sync
- `/r-docs` covers reference docs but not architecture or research docs
- No CI or hook checks for doc freshness
- Some docs duplicate information that could be derived from code (test inventories, route tables, component lists)

**Questions to answer:**
1. Which docs should be **generated** from code (like route-matrix.mjs already does)?
2. Which docs should remain **hand-written** but have **automated staleness checks**?
3. ~~Should `/r-docs` scope expand, or do we need a separate drift-detection tool?~~ **Answered Session 390:** Created `/w-sync-docs` as dedicated drift-detection skill with 7-point test doc audit + API/CLI audits. Separate from `/r-docs` which handles conv-driven updates.
4. Can we use pre-commit hooks or session-start hooks to flag stale docs?
5. What's the right trade-off between doc completeness and maintenance cost?

**Inputs:**
- Session 383 findings: 5 stale architecture docs, 258 undocumented test files, 3 missing API endpoints
- `route-matrix.mjs` as a working example of generated docs (enhanced Session 384: literal slug normalization; Conv 047: balanced-brace JSX extractor for ternary links, structural param resolver — broken targets 3→1)
- `/r-docs` skill as the current manual doc maintenance tool
- `DOCS-GAPS-381.md` audit approach (scan code, diff against docs)
- Session 384: Fixed 5 broken link targets found by route-matrix scanner (wrong slugs, dead links to unbuilt pages, wrong route patterns)
- Conv 022: Fixed sync-gaps.sh (3 bugs, 93% false positive rate → 0%), added 12 route mappings + 15 `me/*` sub-route mappings, documented 15 truly missing API endpoints. All 225 routes now pass gap detection.

---

---

## Deferred: FEEDS

**Focus:** Ranked/algorithmic feeds and mobile performance optimization
**Status:** 📋 PENDING (awaiting client input on paid tier)
**Tech Doc:** `docs/reference/stream.md`

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

### FEEDS.PIN_POSTS
*Creator/admin ability to pin posts in community and course feeds*

**Current state:** `is_pinned` field exists in ranking formula design. Community resources support pinning. Feed post pinning UI and API not yet implemented. (Capabilities review Session 359)

- [ ] Add pin/unpin action to feed post menu (creator/admin only)
- [ ] Pass `is_pinned` field when creating/updating Stream activities
- [ ] Display pinned posts with visual indicator in feed UI

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
- [ ] Wire to `POST /api/admin/users` (requires password per docs/DECISIONS.md)
- [ ] Add tests for admin user creation flow

### ROLES.AUDIT
*Role change tracking (optional, post-MVP)*

- [ ] Log role changes to audit table
- [ ] Show role history in user detail panel

---

## Nearly Complete: SEEDDATA

Database seeding strategy and empty state handling.
**Status:** 🟡 NEARLY COMPLETE (only EMPTY_STATE remaining, deferred to POLISH)

**Completed:** Full seed data overhaul (Session 285) — `migrations-dev/0001_seed_dev.sql` rewritten to cover all 58 schema tables (up from 18). Community/course restructuring: `comm-ai-for-you` (Guy, 3 courses), `comm-automation-majors` (Guy, 1 course), `comm-q-system` (Gabriel, 2 Q-System courses). Fixed data inconsistencies (Stripe Connect IDs, progress_percent, ST ratings). Populated all 40 previously empty tables: sessions, payments, certificates, social, homework, notifications, messaging, moderation, creator applications, onboarding, marketing. Mock-data.ts updated with 2 Gabriel Q-System courses. All 5,283 tests passing. Seeding tooling (`npm run db:setup:local`, `db:seed:local`) already existed. **Conv 007 seed data completeness audit:** Added default avatar SVG for all 10 users, Gabriel's Stripe account + availability, `last_login` for all users, 3 `availability_overrides`, social URLs for 5 users, 2 `session_invites`, 2 `moderator_invites`. Only `availability_overrides`, `session_invites`, and `moderator_invites` tables were previously empty — now all 59 tables have seed data.

### SEEDDATA.TIMESTAMP-FRESHNESS
*Seed data timestamps hardcoded to 2024 — stale for recency-aware features*

- [ ] Convert hardcoded 2024 timestamps in `0001_seed_dev.sql` to relative timestamps (`strftime('now', '-N days')`)
- [ ] Add `feed_activities` records to dev seed (currently zero rows — Smart Feed and vitality calculations find nothing)

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
**Sources:** CD-020 (Payment & Escrow), docs/reference/stripe.md, payment-decisions.md

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
- [ ] Document policy in docs/DECISIONS.md

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
- [ ] MergedPeople.tsx `teacher.handle` fallback to `teacher.id` produces broken `/@[uuid]` URLs — should API guarantee handle is always present? (Conv 047)

### POLISH.SECURITY_HARDENING
*Defense-in-depth improvements identified in Conv 053 IDOR audit*
- [ ] Audit logging for admin actions — who modified what, when (compliance + incident response)
- [ ] Rate limiting on sensitive endpoints — certificate recommendations, login attempts, password resets
- [ ] Explicit role checks where derived permissions are used — clearer intent, easier to audit

### POLISH.DEFERRED_FEATURES
*Small features deferred from completed blocks*
- [ ] Session reminders — needs Cloudflare cron workers (from NOTIFY block)
- [ ] Compatible member matching — Jaccard similarity on shared topic interests (from ONBOARDING block)
- [ ] User → Member rename — platform-wide terminology update (from ONBOARDING block)
- [ ] Community filtering by topic on `/discover/communities` (from ONBOARDING block)
- [ ] Remove MyXXX pages (/courses, /feeds, /communities) + middleware cleanup (PROTECTED_PREFIXES/PROTECTED_EXACT) — pending client agreement (from UNIFIED-DASHBOARD, Conv 054)

---

## Deferred: OAUTH

**Focus:** Register OAuth apps with Google and GitHub, add credentials to Cloudflare
**Status:** 📋 DEFERRED (status and blockers need to be ascertained)
**Tech Doc:** `docs/reference/google-oauth.md` (includes GitHub instructions)

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
- See `docs/reference/google-oauth.md` for full setup walkthrough

---

## Deferred: CRON-CLEANUP

**Focus:** Cloudflare Cron Trigger for automated session cleanup + BBB reconciliation
**Status:** ⏸️ DEFERRED (pre-launch)
**Conv:** 025, 028

Currently `detectNoShows()` + `detectStaleInProgress()` + `reconcileBBBSessions()` run via `POST /api/admin/sessions/cleanup` (manual admin trigger). For production, add a `scheduled()` handler so cleanup runs automatically (e.g., every 15 minutes).

- [ ] Investigate Astro + Cloudflare adapter support for dual exports (`fetch` + `scheduled`)
- [ ] Add `[triggers]` cron config to `wrangler.toml`
- [ ] Implement `scheduled()` handler calling all three detection/reconciliation functions
- [ ] Consider notification batching — individual "missed session" alerts at 3am are noisy; daily digest may be better
- [ ] Local testing: `wrangler dev` + `curl http://localhost/__scheduled`
- [ ] Monitoring: alert if cron hasn't run in 2+ hours (no silent failures)
- [ ] BBB reconciliation: runs `reconcileBBBSessions()` which catches missed `meeting-ended` webhooks (completes sessions where BBB room is inactive) and missed `recording_ready` webhooks (backfills recording_url from `getRecordings()`). Analytics callbacks are NOT recoverable (BBB deletes data after meeting end). Added Conv 028.

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

- [ ] Re-evaluate JWT auth vs Astro Sessions — assess whether any workarounds during development would be better served by session-based auth (see `docs/as-designed/auth-sessions.md`)

### MVP-GOLIVE.STRIPE
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

### MVP-GOLIVE.STREAM
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

### MVP-GOLIVE.RESEND
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

### MVP-GOLIVE.BBB
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

### MVP-GOLIVE.OAUTH
*Social login (Google + GitHub)*
**Tech Doc:** `docs/reference/google-oauth.md`

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
**Tech Doc:** `docs/reference/sentry.md` (implementation plan added Session 233)
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

## Deferred: AUDIT-LOG

**Focus:** Daily-rotating user activity log with per-user isolation and admin query UI
**Status:** 📋 PENDING
**Session:** 359 (Capabilities review)
**Complements:** SENTRY (errors) and POSTHOG (analytics) — AUDIT-LOG covers *who did what, when*

### AUDIT-LOG.CONTEXT

**Current state:** No application logging infrastructure. API endpoints use bare `console.error` for errors (ephemeral on CF Workers). No record of user actions — login history, enrollment events, payment actions, admin operations, etc. are only reconstructible from database state, not from a time-ordered log.

**Why it matters:**
- Admin needs to trace a user's journey when investigating issues or disputes
- Compliance: record of consent, payments, role changes
- Debugging: correlate user-reported problems with actual actions taken
- Security: detect suspicious patterns (failed logins, rapid role changes)

### AUDIT-LOG.SCHEMA

```sql
CREATE TABLE audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  log_date TEXT NOT NULL,           -- 'YYYY-MM-DD' in ET, partition key
  timestamp TEXT NOT NULL,          -- ISO 8601 with timezone (always ET)
  user_id TEXT,                     -- NULL for anonymous/system actions
  user_email TEXT,                  -- Denormalized for readability
  action TEXT NOT NULL,             -- Structured action code (see categories below)
  entity_type TEXT,                 -- 'user' | 'course' | 'enrollment' | 'session' | etc.
  entity_id TEXT,                   -- ID of the affected entity
  detail TEXT,                      -- JSON blob with action-specific context
  ip_address TEXT,                  -- Request IP (for security audit)
  user_agent TEXT,                  -- Browser/client identifier
  request_id TEXT                   -- Correlation ID for multi-step operations
);

-- Indexes for common queries
CREATE INDEX idx_audit_log_date ON audit_log(log_date);
CREATE INDEX idx_audit_log_user ON audit_log(user_id, log_date);
CREATE INDEX idx_audit_log_action ON audit_log(action, log_date);
CREATE INDEX idx_audit_log_entity ON audit_log(entity_type, entity_id);
```

**Daily rotation:** `log_date` is computed as the current date in America/New_York (ET). Each day's entries share the same `log_date` value, with the boundary at midnight ET. Queries filter by `log_date` for efficient day-scoped retrieval. Archival/purge operates on `log_date` ranges.

### AUDIT-LOG.ACTIONS

**Action codes** follow `category.verb` format:

| Category | Actions | Detail Fields |
|----------|---------|---------------|
| **auth** | `auth.login`, `auth.login_failed`, `auth.logout`, `auth.register`, `auth.password_reset`, `auth.oauth_login` | provider, failure_reason |
| **enrollment** | `enrollment.created`, `enrollment.cancelled`, `enrollment.completed`, `enrollment.refunded`, `enrollment.disputed` | course_id, course_name, amount_cents |
| **session** | `session.booked`, `session.cancelled`, `session.joined`, `session.completed`, `session.no_show`, `session.rescheduled` | teacher_id, student_id, scheduled_start |
| **course** | `course.created`, `course.published`, `course.unpublished`, `course.updated`, `course.suspended` | course_name, changed_fields |
| **payment** | `payment.checkout_completed`, `payment.refund_issued`, `payment.dispute_opened`, `payment.dispute_closed`, `payment.payout_requested`, `payment.payout_completed`, `payment.payout_failed` | amount_cents, stripe_id, split_breakdown |
| **certificate** | `cert.recommended`, `cert.approved`, `cert.issued`, `cert.revoked` | course_id, issued_by |
| **profile** | `profile.updated`, `profile.photo_changed`, `profile.handle_changed` | changed_fields |
| **role** | `role.permission_changed`, `role.teacher_certified`, `role.creator_application_submitted`, `role.creator_application_approved`, `role.creator_application_denied` | old_value, new_value, changed_by |
| **message** | `message.sent`, `message.conversation_created` | recipient_id (no message content) |
| **community** | `community.joined`, `community.left`, `community.post_created`, `community.post_flagged` | community_slug |
| **admin** | `admin.user_suspended`, `admin.user_unsuspended`, `admin.course_suspended`, `admin.payout_approved`, `admin.moderation_action` | target_user_id, reason |
| **system** | `system.webhook_received`, `system.email_sent`, `system.error` | webhook_type, email_template, error_message |

### AUDIT-LOG.LIB

```typescript
// src/lib/audit.ts — thin wrapper, called from API endpoints
interface AuditEntry {
  userId?: string;
  userEmail?: string;
  action: string;           // e.g. 'auth.login'
  entityType?: string;      // e.g. 'user'
  entityId?: string;        // e.g. 'usr-abc123'
  detail?: Record<string, unknown>;
  ip?: string;
  userAgent?: string;
  requestId?: string;
}

function logAction(db: D1Database, entry: AuditEntry): Promise<void>
```

**Call pattern:** Non-blocking (fire-and-forget with `ctx.waitUntil()`) so audit logging never slows down API responses. Failed log writes should not break the request.

### AUDIT-LOG.ADMIN_UI

*Admin interface for querying the audit log*

- [ ] `/admin/audit-log` page with filters:
  - Date picker (defaults to today ET)
  - User search (by email, handle, or user ID)
  - Action category filter (dropdown)
  - Entity filter (type + ID)
  - Free-text search on detail JSON
- [ ] Single-user view: "Show all actions for user X" — chronological timeline
- [ ] Export day's log as CSV/JSON
- [ ] Pagination for large result sets

### AUDIT-LOG.RETENTION

- [ ] Configurable retention period (default: 90 days)
- [ ] Scheduled purge of logs older than retention period
- [ ] Option to archive to R2 before purge (compressed JSON per day)
- [ ] Admin UI shows retention policy and storage usage

### AUDIT-LOG.TASKS

- [ ] Create `audit_log` table in `0001_schema.sql`
- [ ] Create `src/lib/audit.ts` with `logAction()` utility
- [ ] Instrument auth endpoints (login, logout, register, password reset, OAuth)
- [ ] Instrument enrollment endpoints (create, cancel, complete, refund)
- [ ] Instrument session endpoints (book, cancel, join, complete, reschedule)
- [ ] Instrument payment/payout endpoints
- [ ] Instrument certificate endpoints
- [ ] Instrument admin action endpoints (suspend, unsuspend, role changes, payout approval)
- [ ] Instrument profile update endpoints
- [ ] Instrument course lifecycle endpoints (create, publish, update, suspend)
- [ ] Build `/admin/audit-log` page with date and user filters
- [ ] Add single-user timeline view
- [ ] Add CSV/JSON export
- [ ] Implement retention purge (scheduled or on-demand)
- [ ] Add R2 archival for expired logs
- [ ] Subsume `ROLES.AUDIT` — role changes logged here instead of separate audit table

### AUDIT-LOG.PACKAGES

*Evaluate before building custom — decision required at implementation time*

**Option A: Custom (D1-backed, current design above)**
- Pros: Zero external dependencies, full control, no vendor lock-in, works offline, no cost beyond D1 storage
- Cons: Must build admin UI, retention, archival ourselves; no tamper-proofing; no SIEM integration out of the box
- Best for: MVP, small scale, full ownership

**Option B: Pangea Secure Audit Log** ([pangea.cloud/services/secure-audit-log](https://pangea.cloud/services/secure-audit-log/))
- Tamper-proof blockchain-verified log entries, search API, compliance-ready
- REST API — compatible with CF Workers (no Node.js runtime dependency)
- Free tier: 2,500 events/month — likely sufficient for Genesis cohort
- Pros: Tamper-proofing, built-in search/export, compliance certifications
- Cons: External dependency, vendor lock-in, latency on every log write, cost at scale

**Option C: WorkOS Audit Logs** ([workos.com](https://workos.com/))
- Enterprise audit log with embeddable UI, SIEM streaming, CSV export
- $5/org/month base; $99/month per million events for retention; $125/month per SIEM connection
- Pros: Embeddable admin UI, SIEM integration, enterprise-grade
- Cons: B2B-focused (org-based model doesn't map well to Peerloop's user model), expensive at scale, overkill for MVP

**Option D: Cloudflare Workers Logs** ([developers.cloudflare.com/workers/observability/logs](https://developers.cloudflare.com/workers/observability/logs/workers-logs/))
- Built-in `console.log()` capture with dashboard query builder (GA April 2025)
- Included in Workers paid plan, OpenTelemetry-compatible tracing
- Pros: Zero setup, already in our stack, queryable in CF dashboard
- Cons: Captures *all* console output (not structured audit events), no per-user isolation, no daily rotation, no long-term retention, no admin UI in our app — better suited as complement to structured audit, not replacement

**Option E: Better Stack (Logtail)** ([betterstack.com](https://betterstack.com/docs/logs/cloudflare-worker/))
- `@logtail/edge` package — edge-runtime compatible, works on CF Workers
- Structured JSON logging with search, alerts, dashboards
- Free tier: 1GB/month
- Pros: Edge-compatible, structured logging, alerting, live tail
- Cons: External service, no built-in audit trail semantics (it's a log aggregator, not an audit system)

**Recommendation:** Start with **Option A (custom D1)** for MVP. The schema is simple, D1 handles the volume, and we own the data. Add **Option D (CF Workers Logs)** as a complement for infrastructure-level observability. Revisit Pangea or Better Stack if compliance requirements emerge or scale demands external tooling.

- [ ] Evaluate packages at implementation time — confirm recommendation or pivot

### AUDIT-LOG.DEPENDENCIES

| Dependency | Status | Why |
|------------|--------|-----|
| D1 database access | ✅ Available | Table lives in D1 |
| `ctx.waitUntil()` | ✅ Available | Non-blocking writes on CF Workers |
| R2 bucket | ✅ Available | Archival storage for expired logs |
| Admin layout | ✅ Available | Admin pages exist |
| ROLES.AUDIT | Deferred | Subsumed — role changes will log here |

---

## Deferred: IMAGE-OPTIMIZE

**Focus:** Image transformation and delivery optimization
**Status:** ⏸️ DEFERRED (post-MVP, when traffic warrants it)
**Tech Doc:** `docs/as-designed/image-handling.md`

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
**Tech Doc:** `docs/reference/cloudflare-kv.md`

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

**Teacher (7 stories):**

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

## Deferred: POSTHOG

**Focus:** Product analytics, session replays, and feature flags via PostHog
**Status:** 📋 PENDING (selected Dec 2025, never integrated)
**Tech Doc:** `docs/reference/posthog.md`

**Context:** PostHog selected over Mixpanel and Plausible. Free tier covers Genesis (1M events/mo). Complements Sentry (errors) — no overlap.

### POSTHOG.TASKS

- [ ] Install `posthog-js` SDK
- [ ] Add PostHog Astro/React integration
- [ ] Add `POSTHOG_API_KEY` to `.dev.vars` and CF Dashboard
- [ ] Implement key event tracking: `course_viewed`, `enrollment_started`, `enrollment_completed`, `session_booked`, `session_completed`, `lesson_completed`, `certificate_earned`, `became_student_teacher`
- [ ] Configure session replays
- [ ] Set up feature flags for A/B experiments (core features use D1, not flags)

### POSTHOG.TRIGGERS

When to implement: Pre-launch or early Genesis, when PMF metrics tracking becomes critical.

---

## Deferred: MOCK-DATA-MIGRATION

**Focus:** Remove mock-data imports from components; wire to real API data
**Status:** 📋 PENDING
**Tech Doc:** `docs/as-designed/data-fetching.md`

**Context:** Multiple components still import from `mock-data.ts` instead of receiving data as props from Astro pages. This blocks real data display on browse/discovery pages.

### MOCK-DATA-MIGRATION.COMPONENTS

*Migrate each component to receive data as props from .astro files:*

- [ ] `CourseBrowse.tsx` -- receive `courses` as prop
- [ ] `CourseDetail.tsx` -- receive `course` as prop
- [ ] `CourseSTList.tsx` -- receive data as prop
- [ ] `CourseCurriculum.tsx` -- receive data as prop
- [ ] `CourseSidebar.tsx` -- receive data as prop
- [ ] `CourseTestimonials.tsx` -- receive data as prop
- [ ] `CoursePrerequisites.tsx` -- receive data as prop
- [ ] `CourseFilterSidebar.tsx` -- receive data as prop
- [ ] `CourseFilterPills.tsx` -- receive data as prop
- [ ] `TestimonialsBrowse.tsx` -- receive data as prop

### MOCK-DATA-MIGRATION.PERSONALIZATION

*New components for authenticated user experience:*

- [ ] `EnrollmentStatus.tsx` -- "You're enrolled" badge on course pages
- [ ] `WelcomeBack.tsx` -- Homepage personalization for returning users
- [ ] `ContinueLearning.tsx` -- Resume course CTA on dashboard/home

---

## Deferred: RATINGS-EXT

**Focus:** Extended ratings features beyond core session/completion reviews
**Status:** 📋 PLANNING
**Tech Doc:** `docs/as-designed/ratings-feedback.md`

**Context:** Core rating system is complete (session assessments + completion reviews). These extensions add richer feedback dimensions and display.

### RATINGS-EXT.EXPECTATIONS

*Capture student goals/expectations at enrollment time*

- [ ] `enrollment_expectations` table (schema in tech-022)
- [ ] POST endpoint to capture expectations post-purchase
- [ ] Optional update after each session
- [ ] Display in completion review context ("did course meet expectations?")

### RATINGS-EXT.MATERIALS

*Separate course content quality rating from teaching quality*

- [ ] `course_reviews` table with optional sub-ratings (clarity, relevance, depth)
- [ ] Add `rating` and `rating_count` columns to `courses` table
- [ ] Two-part completion review modal (teaching + materials)
- [ ] Course page displays materials rating separately from Teacher rating
- [ ] Creator analytics: materials feedback breakdown

### RATINGS-EXT.DISPLAY

*Surface ratings in more places*

- [ ] Show completion reviews on Teacher public profile page
- [ ] Rating trend charts in Teacher/Creator analytics dashboards

---

## Deferred: E2E-LIFECYCLE

**Focus:** Cross-user E2E tests that verify full action-to-UI-feedback loops
**Status:** 📋 PENDING
**Session:** 342

**Context:** Current E2E tests are single-user and read pre-seeded data. These tests verify that an action by User A produces visible results in User B's UI, including badge updates and list changes.

### E2E-LIFECYCLE.NOTIFICATIONS

*Browser-level test: notification creation, display, and badge update across two users*

- [ ] User A triggers an action that generates a notification for User B
- [ ] Verify notification appears in User B's `/notifications` page
- [ ] Verify User B's AppNavbar notification badge shows updated unread count
- [ ] Verify mark-all-read clears badge in the browser

**Integration test equivalent:** `tests/integration/notification-lifecycle.test.ts` (14 tests) — covers the full API-level lifecycle including badge count, batch notifications, and cross-user isolation. The E2E adds browser rendering, hydration, polling, and click-handler verification.

### E2E-LIFECYCLE.MESSAGES

*Browser-level test: message send, receive, conversation list, and badge update across two users*

- [ ] User A sends a message to User B via `/messages`
- [ ] Verify message appears in User B's conversation view
- [ ] Verify User B's AppNavbar messages badge shows updated unread count
- [ ] Verify mark-all-read clears badge in the browser
- [ ] Verify conversation list shows correct unread indicators

**Integration test equivalent:** `tests/integration/message-lifecycle.test.ts` (14 tests) — covers the full API-level lifecycle including multi-conversation sums, cross-user isolation, and sender-exclusion. The E2E adds browser rendering, polling, and conversation UI verification.

### Implementation Notes (shared)

- Requires two Playwright browser contexts (`browser.newContext()`) for cross-user flows
- Badge polls every 60s — tests should `page.reload()` or intercept the poll to avoid waiting
- Identify seed data actions that reliably create notifications/messages in dev state

---

## Deferred: WORKFLOW-TESTS

**Focus:** Integration tests for multi-step platform workflows with branching decision points
**Status:** 📋 PENDING
**Session:** 342

**Context:** Current integration tests cover single-flow lifecycles (message send → count → read, notification create → list → clear). Real user workflows are trees — a shared setup that diverges at decision points where different user actions produce different downstream state. The highest-value tests are branches where the decision **changes downstream state**, not just input content.

### Design Philosophy

**Branching workflow pattern:** Each workflow has a shared expensive setup (create users, courses, enrollments, sessions) and multiple `describe` blocks that branch at a decision point. A shared helper like `setupCompletedSession(db)` gets the test to the decision point cheaply, then each branch tests a different outcome.

```
Shared Setup ──→ Decision Point ──→ Branch A (rate 5 stars → Teacher rating up)
                                 ──→ Branch B (skip rating → reminder banner)
                                 ──→ Branch C (rate 1 star → Teacher rating down)
```

**What makes a branch valuable:** The branch changes downstream state — a different DB record is created, a different status is set, a different error is returned. Branches where the output is trivially predictable (different message text, same flow) are low-value.

**Integration vs E2E split:** Integration tests cover branching logic cheaply (ms per branch). E2E tests (see E2E-LIFECYCLE block) should cover only the 2-3 most critical happy paths through the browser.

### WORKFLOW-TESTS.BOOKING — Booking → Session → Completion

*The core platform flow with the most decision-point variants*

**Shared setup:** Student, Teacher, course, enrollment

| Branch Point | Variants | Downstream Impact |
|---|---|---|
| Book session | Happy path; rebooking on completed enrollment (403); rebooking on cancelled enrollment (403) | Session created or rejected |
| Join session | Both participants join; one no-shows | Session status, potential flags |
| Complete session | Single session; final session of course (triggers completion) | Completion logic, review modal |
| Cancel session | On-time cancel; late cancel without reason (422); late cancel with reason (saves flag) | Cancel flag, policy enforcement |
| Reschedule session | Under limit (success, count increments); at limit (422) | Reschedule count, booking blocked |

**Tests to write:**
- [ ] Single session happy path: book → join → complete → rate
- [ ] Full course completion: book + complete all N sessions → course completion triggers
- [ ] Cancellation variants: on-time vs late vs late-with-reason
- [ ] Reschedule flow: count increments, limit enforced at max
- [ ] Rebooking guards: completed/cancelled enrollment → 403

**Existing partial coverage:** `tests/api/sessions/` has individual endpoint tests for cancel, reschedule, rebooking guards (Session 333). These test the API in isolation — workflow tests chain them together to verify state propagates across endpoints.

### WORKFLOW-TESTS.COMPLETION — Course Completion → Certification → Teacher Activation

*The flywheel: student becomes teacher*

**Shared setup:** Student who has completed all sessions for a course

| Branch Point | Variants | Downstream Impact |
|---|---|---|
| Review modal | Submit review (Teacher rating updates); skip review (dashboard reminder appears) | enrollment_reviews record, Teacher aggregate rating |
| Rating value | 5 stars vs 1 star | Teacher public rating changes differently |
| Recommendation | Teacher recommends student; Teacher declines | Student enters/doesn't enter certification queue |
| Certification | Creator certifies; Creator rejects | Student becomes Teacher (new role) or stays student |
| First booking as Teacher | Student-turned-Teacher books their own student | Validates the full flywheel |

**Tests to write:**
- [ ] Complete course → rate Teacher → Teacher rating aggregate updates
- [ ] Complete course → skip review → verify no enrollment_review record
- [ ] Complete course → review later from dashboard reminder
- [ ] Recommend → certify → new student_teachers record with active status
- [ ] The mega-test: enroll → complete → rate → recommend → certify → book as S-T (full flywheel)

### WORKFLOW-TESTS.PAYMENT — Checkout → Webhook → State Changes

*Payment events that change enrollment and user state*

**Shared setup:** Student, course, initiated checkout

| Branch Point | Variants | Downstream Impact |
|---|---|---|
| Checkout result | Success → enrollment created; abandoned → no enrollment | Enrollment state |
| Post-purchase | Refund → enrollment cancelled; no refund → active | Enrollment status, potential notification |
| Dispute | dispute.created → admin notified; dispute.closed (won/lost) | Admin notification, enrollment state |
| Payout | Success (implicit); payout.failed → creator notified | Creator notification |

**Tests to write:**
- [ ] Checkout success → enrollment created → webhook fires → state correct
- [ ] Refund webhook → enrollment cancelled
- [ ] Dispute opened → admin notification → dispute closed (won) → enrollment restored
- [ ] Dispute closed (lost) → enrollment stays cancelled

**Existing partial coverage:** `tests/api/webhooks/stripe.ts` has 14 tests for individual webhook events (Session 224). Workflow tests chain checkout → webhook → enrollment state → notification.

### WORKFLOW-TESTS.MESSAGING — Conversation Lifecycle with Access Control

*Message flows that interact with relationship gates (Session 341)*

**Shared setup:** Users with various relationship states

| Branch Point | Variants | Downstream Impact |
|---|---|---|
| Start conversation | With enrolled student (allowed); with unrelated user (403) | Conversation created or rejected |
| Send in existing conversation | Relationship active (allowed); relationship ended (403) | Message sent or blocked |
| Enrollment cancelled mid-conversation | Conversation readable; new messages blocked (403) | Graceful degradation |

**Tests to write:**
- [ ] Create conversation → send messages → relationship ends → new message blocked → old messages still readable
- [ ] Admin bypasses all relationship checks (send to anyone)
- [ ] Search returns only messageable contacts → start conversation from search result → verify it works

**Existing partial coverage:** `tests/lib/messaging.test.ts` (20 tests) covers all 11 relationship rules. `tests/integration/message-lifecycle.test.ts` (14 tests) covers send/count/read lifecycle. Workflow tests combine relationship gates with the message lifecycle.

### Priority Order

| Workflow | Value | Reason |
|---|---|---|
| BOOKING | Highest | Most branches, most user-facing, most bug-prone |
| COMPLETION | High | Validates the flywheel — the core product thesis |
| PAYMENT | Medium | Webhook chains are brittle; existing coverage is decent |
| MESSAGING | Medium | Relationship gates are new (Session 341); integration coverage already strong |

---

## Deferred: EMAIL-TZ

**Focus:** Format notification/email times in recipient's local timezone
**Status:** 📋 PENDING
**Conv:** 002

**Context:** Conv 002 completed UTC-TIMES (session timezone normalization). Emails currently show times in UTC with "UTC" label. For polish, format in recipient's timezone — requires adding `timezone` column to users table and querying it during notification formatting.

- [ ] Add `timezone TEXT` column to users table (IANA timezone string, e.g., `America/New_York`)
- [ ] Populate during onboarding or profile settings (detect from browser `Intl.DateTimeFormat().resolvedOptions().timeZone`)
- [ ] Use `formatLocalTime(utcIso, userTimezone)` in session creation, reschedule, and cancellation email formatting
- [ ] Use `formatLocalTime()` in in-app notification text

---

## Deferred: PUBLIC-PAGES

**Focus:** Unified header/footer/nav/currentUser strategy for public-facing pages
**Status:** 📋 PENDING
**Session:** 385

**Context:** Session 385 audit found three layout/header components serving different page types, each with independent auth patterns:

| Layout | Header Component | Auth Pattern | Pages |
|--------|-----------------|--------------|-------|
| `AppLayout` | `AppNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | ~54 authenticated pages |
| `AdminLayout` | `AdminNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | 14 admin pages |
| `LandingLayout` | `Header.tsx` | `fetch('/api/auth/session')` (lightweight) | ~26 public pages |
| `LegacyAppLayout` | `AppHeader.tsx` | `fetch('/api/auth/session')` + notification count | Deprecated, still mounted |

**Problems to solve:**

1. **Header.tsx uses stale role booleans** — `/api/auth/session` returns `is_student`, `is_teacher`, `is_creator` as flat DB flags, not derived from actual course relationships. A user with `can_create_courses=true` but zero created courses shows "Creator Dashboard" link incorrectly.

2. **Header.tsx `getDashboardLink()` duplicates AppNavbar logic** — role-priority routing (admin → creator → teacher → student) is implemented independently in both components with different field names (`is_admin` vs `isAdmin`).

3. **No shared footer** — public and app pages have no consistent footer component. Marketing pages need footer nav (About, Privacy, Terms, etc.), app pages may need a slimmer version.

4. **AppHeader.tsx (legacy) is a dead-end** — has its own mobile sidebar with hardcoded routes that don't match AppNavbar. Should be removed once all pages use AppLayout.

5. **Public pages can't personalize for returning users** — e.g., `/courses` could show "Continue Learning" for enrolled courses, but Header.tsx doesn't initialize currentUser and there's no `getCurrentUserIfCached()` helper.

### PUBLIC-PAGES.HEADER-UNIFY

*Unify Header.tsx auth with currentUser cache*

- [ ] Add `getCurrentUserIfCached()` to `current-user.ts` — reads localStorage only, no fetch, returns `CurrentUser | null`
- [ ] Refactor `Header.tsx` to use `getCurrentUserIfCached()` instead of `/api/auth/session`
- [ ] Fall back to lightweight session fetch only if no cache exists (first-time visitor who never visited an AppLayout page)
- [ ] Replace stale `is_teacher`/`is_creator` booleans with currentUser's `isActiveTeacher()`/`hasCreatedCourses()` for accurate dashboard routing
- [ ] Extract shared `getDashboardLink(user)` utility used by both Header and AppNavbar

### PUBLIC-PAGES.LEGACY-CLEANUP

*Remove AppHeader.tsx and LegacyAppLayout*

- [ ] Audit which pages (if any) still use `LegacyAppLayout.astro`
- [ ] Migrate remaining pages to `AppLayout.astro`
- [ ] Delete `AppHeader.tsx` and `LegacyAppLayout.astro`
- [ ] Remove `AppHeader` from any component exports/barrels

### PUBLIC-PAGES.FOOTER

*Shared footer component for public and app pages*

- [ ] Design footer structure (links, social, copyright)
- [ ] Create `Footer.astro` component (zero JS, build-time)
- [ ] Add to `LandingLayout.astro`
- [ ] Decide whether app pages need a footer variant (likely no — sidebar layout doesn't need one)

### PUBLIC-PAGES.PERSONALIZATION

*Returning-user awareness on public pages (stretch)*

- [ ] `/courses` — show "Continue Learning" badge on enrolled courses via `getCurrentUserIfCached()`
- [ ] `/` (landing) — show "Go to Dashboard" instead of "Get Started" for cached users
- [ ] `EnrollButton` on public course pages — instant "Go to Course" for enrolled users (no fetch needed)

---

## Deferred: CERT-APPROVAL

**Focus:** Full certificate lifecycle — creator approval UI, student certificate page, PDF generation & R2 storage, dead link fixes
**Status:** 📋 PENDING
**Origin:** Session 359 (capabilities review), Conv 007 (seed data review), Session 390 (LearnTab blocker), Conv 042 (CompletedTabContent dead link)

### What Exists

| Piece | Status | Location |
|-------|--------|----------|
| `certificates` table | ✅ Full schema | `migrations/0001_schema.sql:650` — id, user_id, course_id, type (completion/mastery/teaching), status (pending/issued/revoked), certificate_url (always NULL), recommended_by, issued_by |
| Admin list/create | ✅ Built | `GET/POST /api/admin/certificates` — paginated listing with status/type filters + stats |
| Admin approve | ✅ Built | `POST /api/admin/certificates/[id]/approve` — pending→issued, syncs `teacher_certifications` for teaching certs, sends email via Resend (`CertificateIssuedEmail`) + notification |
| Admin reject | ✅ Built | `POST /api/admin/certificates/[id]/reject` — hard-deletes pending cert |
| Admin revoke | ✅ Built | `POST /api/admin/certificates/[id]/revoke` — issued→revoked, deactivates teaching cert if applicable |
| Teacher recommend | ✅ Built | `POST /api/me/certificates/recommend` — teacher recommends enrolled student, creates `pending` cert (validates: active teacher, certified for course, student enrolled, student completed for teaching certs) |
| My certificates | ✅ Built | `GET /api/me/certificates` — user's own certs with course/issuer joins |
| Public verify | ✅ Built | `GET /api/certificates/[id]/verify` — no-auth verification endpoint |
| CompletedTabContent | ⚠️ Dead link | `src/components/discover/detail-tabs/CompletedTabContent.tsx:40` — links to `/course/[slug]/certificate` (doesn't exist), has "coming soon" disclaimer |
| LearnTab | ⚠️ TODO | `src/components/courses/LearnTab.tsx:382` — commented TODO for certificate link |

### What's Missing

**The certificate lifecycle has 5 gaps:**

1. **Creator has no approval UI** — Only admin can approve/reject. The flywheel requires creators to certify their own students. Creator dashboard has no pending-certificates view.
2. **Creator not notified** — When a teacher recommends a student, no notification goes to the course creator. Only admin would see it.
3. **No student certificate page** — `/course/[slug]/certificate` doesn't exist. Two UI elements link to it (CompletedTabContent, LearnTab TODO).
4. **No PDF generation** — No library installed, no template designed, `certificate_url` is always NULL. R2 helpers exist (`src/lib/r2.ts`) but no cert-specific upload code.
5. **No public certificate view** — The verify endpoint returns JSON; there's no shareable HTML page for a certificate.

### CERT-APPROVAL.PHASE-1 — Dead Link Fix + Student Certificate Page

*Minimum viable: show certificate status to students who earned one, fix dead links*

- [ ] Create `/course/[slug]/certificate` page (Astro SSR)
  - Fetch user's certificate for this course via `GET /api/me/certificates` (filter by course)
  - States: not-authenticated → login redirect, no-certificate → "not earned", pending → "awaiting approval", issued → certificate display, revoked → revoked message
  - Issued state: show course name, student name, issue date, certificate ID, issuer name, type badge
  - If `certificate_url` exists: "Download PDF" button (for Phase 3)
  - If `certificate_url` is NULL: "PDF coming soon" note (graceful degradation)
  - Public share link: `/certificates/[id]/verify` (already exists as API, needs HTML page — see Phase 4)
- [ ] Fix CompletedTabContent dead link (`src/components/discover/detail-tabs/CompletedTabContent.tsx:40`)
  - Link should go to `/course/${courseSlug}/certificate` — URL is correct, just needs the page to exist
  - Remove "coming soon" disclaimer once page is live
- [ ] Fix LearnTab TODO (`src/components/courses/LearnTab.tsx:382`)
  - Add "View Certificate" link in completion celebration card
- [ ] Tests: certificate page rendering (all 5 states), auth redirect, data display

### CERT-APPROVAL.PHASE-2 — Creator Approval Flow

*Creator-facing certification management — the flywheel step where creators certify graduates*

- [ ] `GET /api/me/courses/[id]/pending-certificates` — list pending certs for a creator's course
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/approve` — creator approves (reuse approve logic from admin endpoint, verify creator owns course)
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/reject` — creator rejects with reason
- [ ] Creator notification: when teacher recommends a student, notify the course creator (new notification type: `cert.recommendation_received`)
- [ ] Creator dashboard UI: "Pending Certifications" section or tab showing students awaiting approval
  - Student name, course, recommending teacher, recommendation date
  - Approve / Reject buttons with confirmation
- [ ] Student notification on approval/rejection (approval notification already exists via admin flow — verify it fires for creator approval too)
- [ ] Tests: creator approval/rejection, authorization (only course creator can approve), notification delivery

### CERT-APPROVAL.PHASE-3 — PDF Generation & R2 Storage

*Generate certificate PDFs on approval and store to R2*

- [ ] Choose PDF library — candidates: `pdf-lib` (lightweight, no native deps, CF Workers compatible), `@react-pdf/renderer` (React-based templates), or server-side HTML→PDF
  - **Constraint:** Must work in Cloudflare Workers environment (no Puppeteer/Chrome)
- [ ] Design certificate template: course name, student name, date, certificate ID, type badge, creator signature area, verification QR code
- [ ] `generateCertificatePDF(cert)` function in `src/lib/certificates.ts`
- [ ] Hook into approve endpoint: generate PDF → upload to R2 at `certificates/{cert_id}/certificate.pdf` → store URL in `certificates.certificate_url`
- [ ] Update student certificate page: when `certificate_url` exists, show "Download PDF" button
- [ ] Seed data: add sample certificate URLs once generation works
- [ ] Tests: PDF generation, R2 upload, URL storage

### CERT-APPROVAL.PHASE-4 — Public Certificate Page (Optional)

*Shareable HTML certificate view — currently verify endpoint is JSON-only*

- [ ] Create `/certificates/[id]` public page (no auth required)
  - Shows: recipient, course, issuer, date, type, validity status
  - Revoked certs: show revoked status with date
  - QR code linking back to this page for physical certificate verification
- [ ] Update student certificate page: "Share" button with copyable public URL
- [ ] Consider: Open Graph meta tags for social sharing preview

---

## Deferred: FILE-UPLOADS

**Focus:** Dedicated upload API for profile photos, course materials
**Status:** 📋 PENDING
**Session:** 359, Conv 007

**Context:** R2 helpers exist (`src/lib/r2.ts` — `uploadToR2`, `downloadFromR2`, `deleteFromR2`). No POST upload endpoints exist. Dev seed currently uses a static placeholder avatar (`/images/default-avatar.svg`).

### FILE-UPLOADS.AVATAR

*User avatar upload/selection — Conv 007 seed data review*

- [ ] `POST /api/me/avatar` upload endpoint (accept image, validate size/type)
- [ ] Resize/crop to standard dimensions (e.g., 200x200)
- [ ] Upload to R2 at `avatars/{user_id}/{filename}`
- [ ] Update `users.avatar_url` with R2 URL
- [ ] Profile settings UI: upload button, preview, remove option
- [ ] Replace static placeholder with user-selected avatar

### FILE-UPLOADS.COURSE-MATERIALS

- [ ] `POST /api/courses/[slug]/materials` upload endpoint
- [ ] File type validation (PDF, images, video links)
- [ ] Upload to R2 at `courses/{course_id}/materials/{filename}`

---

## Deferred: RECORDING-PERSIST

**Focus:** BBB recording download, R2 persistence, analytics callback activation, admin monitoring
**Completed:** COOKIE-DOWNLOAD (Conv 037), WEBHOOK-CAPTURE (Conv 037), STAGING-INFRA (Conv 037), DOC-MIGRATION (Conv 038)
**Status:** 🟡 Partial — download implemented, staging mostly configured, needs end-to-end verification + admin UI
**Conv:** 007, 037 (CD-038 vendor guidance), 038 (staging setup + doc migration)

**Context:** Blindside Networks (Fred Dixon, 2026-03-26, CD-038) confirmed: recordings are `.m4v` format, require cookie-based two-step download. Analytics callback is already wired (`meta_analytics-callback-url` passed in `createRoom()`, endpoint exists at `bbb-analytics.ts`). Webcam policy: instructor-only (POLICIES.md §6).

### RECORDING-PERSIST.COOKIE-DOWNLOAD ✅ (Conv 037)

*Cookie-based `.m4v` download from Blindside Networks*

- [x] Update `replicateRecordingToR2()` in `r2.ts` for two-step cookie auth (`fetchWithCookieAuth` + `parseBlindsideCaptureUrl`)
- [x] Add `.m4v` extension handling to `generateRecordingKey()` and content-type detection
- [x] Add `recording_size_bytes` column to `sessions` table (schema)
- [x] Store file size in `recording_size_bytes` after successful R2 upload (Content-Length / R2 head fallback)
- [x] No max file size enforced — best-effort download, BBB URL remains as fallback (POLICIES.md §6)

### RECORDING-PERSIST.VERIFY

- [ ] Run a real BBB session and confirm `recording_url` is populated by webhook
- [ ] Verify webhook payload structure matches `handleRecordingReady` expectations
- [ ] Verify cookie-based download produces valid `.m4v` file

### RECORDING-PERSIST.ANALYTICS-ACTIVATION

*Analytics callback infrastructure exists — needs activation and confirmation*

- [x] Analytics endpoint built (`POST /api/webhooks/bbb-analytics`)
- [x] JWT verification (HS512 with BBB_SECRET)
- [x] `meta_analytics-callback-url` passed in `createRoom()` (`join.ts:135`)
- [x] `session_analytics` table stores payload
- [ ] Deploy to production and verify callback URL is reachable
- [ ] Confirm with Blindside Networks that shared secret matches `BBB_SECRET`
- [ ] End-to-end test: session ends → analytics JSON arrives → stored in DB

### RECORDING-PERSIST.ADMIN-MONITORING

*Admin visibility into recording sizes and status*

- [ ] Expose `recording_size_bytes` in admin session detail view
- [ ] Admin API: query recording status across sessions (total storage, failed downloads)
- [ ] Log warnings for download failures (already best-effort, needs structured logging)

### RECORDING-PERSIST.UI

- [ ] Add recording playback/download UI to session detail page

### RECORDING-PERSIST.WEBHOOK-CAPTURE ✅ (Conv 037)

*Fire-and-forget webhook payload capture for debugging and fixture generation*

- [x] `webhook_log` table + indexes added to schema
- [x] Fire-and-forget INSERT in `bbb.ts`, `bbb-analytics.ts`, `stripe.ts` (auth headers redacted)

### RECORDING-PERSIST.STAGING-INFRA ✅ (Conv 037)

*Environment isolation for webhook testing*

- [x] Created `peerloop-storage-staging` R2 bucket (preview env was sharing production R2)
- [x] Updated `wrangler.toml` preview to use staging R2 bucket
- [x] Updated `env-vars-secrets.md` with R2 separation + BBB_SECRET/BBB_URL entries
- [x] Created `docs/guides/STAGING-WEBHOOKS-SETUP.md` checklist

### RECORDING-PERSIST.STAGING-SETUP (User)

- [x] CF Dashboard: set Preview secrets for staging webhooks (Conv 038 — all 10 vars + 3 bindings verified)
- [x] Stripe Dashboard: add staging webhook endpoint (`staging.peerloop.pages.dev`) (Conv 038 — user confirmed)
- [x] Email Blindside Networks: webcam policy + analytics callback confirmation (Conv 038 — draft sent)
- [ ] Verify staging webhook setup end-to-end (blocked on Blindside response + deployed staging build)

### RECORDING-PERSIST.DOC-MIGRATION ✅ (Conv 038)

- [x] REMOTE-API.md PlugNmeet → BBB migration (3 endpoints + VideoProvider 8-method interface)
- [x] DB-GUIDE.md session_analytics table documented (subsection + domain table count 46→47)

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

*Source: [ROUTE-STORIES.md](docs/as-designed/route-stories.md) §10 (On-Hold) and §11 (Gap)*

*Note: Count is 34 including US-P053 and US-P082 which have routes (`/discover/leaderboard`) but are blocked on the goodwill points data they need to display.*

---

*Last Updated: 2026-03-29 Conv 058 (ADMIN-INTEL block completed — Phases 5-6 + all remaining subtasks done. 85 tests across 13 files. Block moved to COMPLETED_PLAN.md.)*
