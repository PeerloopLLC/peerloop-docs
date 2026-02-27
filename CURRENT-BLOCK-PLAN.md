# CURRENT-BLOCK-PLAN.md

## Active Work: E2E-TESTING Block + FEEDS Block Cleanup

**Session:** 299 (2026-02-27)
**Status:** PLAN DRAFTED — awaiting approval to implement

---

## Background

Session 298 completed the original TESTING block with 4 Playwright E2E test files (19 tests) covering homepage, browse→enroll, auth→dashboard, and admin overview. However:

1. The original E2E scope was planned early when fewer features existed. Now with 60+ pages and 23 completed blocks, significant user-facing flows lack E2E coverage.
2. **TESTING.WEBHOOKS was deferred and dropped** — never added to PLAN.md as a tracked item.
3. **FEEDS block is stale** — written at Session 180, but the COMMUNITY block (completed Sessions 54-58) already built the entire feed system.

This plan creates a new **E2E-TESTING** deferred block in PLAN.md and updates the **FEEDS** block to reflect current reality.

---

## Part 1: New E2E-TESTING Block for PLAN.md

### Current E2E Coverage

4 files, 19 tests:
- `e2e/homepage.spec.ts` — 5 tests (sidebar, navigation, Discover menu)
- `e2e/browse-enroll.spec.ts` — 5 tests (course browse, detail, enroll redirect, success page)
- `e2e/auth-dashboard.spec.ts` — 4 tests (login, student dashboard, enrollments, errors)
- `e2e/admin-overview.spec.ts` — 5 tests (admin login, dashboard, users, sidebar)

Reference: `docs/reference/TEST-E2E.md` for patterns, selectors, gotchas.

### External Service Blockers

Four external services were analyzed in detail:

#### Resend (Email) — NOT A BLOCKER
Email is fire-and-forget everywhere. All API endpoints return success BEFORE email sends (using `Promise.allSettled`/`Promise.all` without await). If Resend is missing or fails, user-visible responses are unaffected. No E2E test will ever fail because of email.

**Action:** Ignore completely.

#### Stripe — MINIMAL BLOCKER
Only two operations redirect away from the app:
- "Enroll Now" → Stripe Checkout (hosted page, can't control)
- "Connect with Stripe" → Stripe onboarding (hosted page, can't control)

Everything else works from D1:
- Success page — pure D1 enrollment check, no Stripe API
- Earnings pages (`/teaching/earnings`, `/creating/earnings`) — pure D1 aggregation of `payment_splits`
- Admin payouts display — pure D1 queries, Stripe status badges from D1 flags
- Settings/payments page — has **D1 fallback** when Stripe API fails (mock account IDs `acct_mock_*` trigger this gracefully)

Seed data includes mock Stripe accounts (`acct_mock_guy`, `acct_mock_sarah`, `acct_mock_marcus`) with `stripe_account_status='active'` and `stripe_payouts_enabled=1` in D1. The `connect-status` endpoint catches Stripe API errors for invalid accounts and returns D1 fallback data.

**Action:** Test around redirects (already doing this). Extend to earnings and admin payouts.

#### BBB (Video) — NARROW BLOCKER
Only one click requires BBB: the "Join Session" button (calls `bbb.getJoinUrl()` → external redirect). Everything around it works from D1:
- Session booking (teacher selection, calendar, time slots, confirmation) — pure D1
- Session page states: early/completed/cancelled — rendered from D1 status + time logic
- Session rating/review form — pure D1 insert to `session_assessments`
- Session cancellation/rescheduling — pure D1 updates
- Admin session management display — pure D1 queries

Seeded data:
- Completed session: `ses-david-n8n-1` (2024-12-15, with ratings)
- Scheduled session: `ses-david-n8n-2` (2026-03-05, future, no rating)

Clean `VideoProvider` interface exists — could accept a `MockVideoProvider` in future.

**Action:** Test booking, completed sessions, ratings without BBB. Note mock provider for future.

#### Stream.io — HARDEST BLOCKER
All feed content (posts, reactions, comments) lives exclusively in Stream.io. No D1 fallback. Pages **don't crash** — they show error UI with "Try Again" buttons (CommunityFeed, CourseFeed, HomeFeed all have error boundaries). But feed content won't render.

What works without Stream:
- Community page structure (tabs, members list from D1)
- Course detail tabs (about, curriculum, teachers, resources)
- Community membership queries from D1

What's blocked:
- Feed posts, reactions, comments on `/community/[slug]`, `/course/[slug]/feed`, `/feed`
- Posting, reacting, commenting interactions

Mitigation approaches (in order of effort):
1. **Test page structure only** (Low effort) — Verify tabs render, members load, skip feed assertions
2. **Playwright route interception** (Medium effort) — `page.route('**/api/feeds/**', ...)` returns mock JSON. No code changes, test-only.
3. **Use staging Stream credentials** (Medium effort) — Staging app exists (`tgzt4vdwm9cb`), would need to seed test activities
4. **Add mock mode to API** (High effort) — `STREAM_MOCK=true` env flag, code change

**Action:** Start with page structure testing (Tier 3). Add Playwright route interception for feed content assertions (E2E-TESTING.FEEDS).

---

### E2E-TESTING.TIER1 — Core Dashboards & Pages (No External Deps)

5 test suites, ~20-24 tests. All data from D1 via seeded `migrations-dev/0001_seed_dev.sql`.

#### 1. Creator Dashboard (`e2e/creator-dashboard.spec.ts`)
- **Route:** `/creating`
- **User:** Guy Rymberg (`guy-rymberg@example.com`, 4 courses, earnings, 156 students)
- **Tests (~4-5):**
  - Login as Guy → navigate to `/creating` → dashboard loads
  - Course list displays (4 courses visible)
  - Earnings summary renders (payment_splits data)
  - Navigate to course management
  - Community stats visible

#### 2. Teaching Dashboard (`e2e/teaching-dashboard.spec.ts`)
- **Route:** `/teaching`
- **User:** Sarah Miller (`sarah.miller@example.com`, S-T, 8 students, earnings)
- **Tests (~4-5):**
  - Login as Sarah → navigate to `/teaching` → dashboard loads
  - Student list or count visible
  - Earnings display renders
  - Session schedule/history visible
  - Navigate to teaching sub-pages (students, earnings, analytics)

#### 3. Course Detail Tabs (`e2e/course-detail.spec.ts`)
- **Route:** `/course/[slug]` (multiple tabs)
- **User:** Public (no auth) + David Rodriguez (enrolled)
- **Tests (~4-5):**
  - Public: Course page loads with About tab content
  - Public: Curriculum tab shows module structure
  - Public: Teachers tab lists certified S-Ts
  - Public: Resources tab renders
  - Authenticated (David): Tabs accessible for enrolled course (Intro to n8n)

#### 4. Course Learning (`e2e/course-learning.spec.ts`)
- **Route:** `/course/[slug]/learn`
- **User:** David Rodriguez (35% progress in Intro to n8n)
- **Tests (~3-4):**
  - Login as David → navigate to `/course/intro-to-n8n/learn`
  - Module list renders with progress indicators
  - Progress percentage displayed (~35%)
  - Navigation between modules works

#### 5. Profile Pages (`e2e/profiles.spec.ts`)
- **Routes:** `/@[handle]`, `/creator/[handle]`, `/teacher/[handle]`
- **User:** Public (no auth required)
- **Tests (~4-5):**
  - Creator profile: `/creator/guy-rymberg` → shows courses, stats
  - Teacher profile: `/teacher/sarah-miller` → shows teaching info, ratings
  - User profile: `/@david-rodriguez` or similar → student profile renders
  - Profile page adapts to role (different layout for creator vs student)
  - Handle-based routing works

---

### E2E-TESTING.TIER2 — Settings, Admin CRUD, Discovery, Signup (No External Deps)

4 test suites, ~16-19 tests.

#### 6. Settings Pages (`e2e/settings.spec.ts`)
- **Route:** `/settings/*`
- **User:** David Rodriguez
- **Tests (~4-5):**
  - Navigate to `/settings` → settings hub loads
  - Profile settings page renders with current data
  - Notification settings page renders with toggles
  - Security settings page renders
  - Payments settings page renders (shows "not connected" for David, or D1 fallback for Sarah)

#### 7. Admin CRUD Operations (`e2e/admin-crud.spec.ts`)
- **Route:** `/admin/courses`, `/admin/enrollments`, `/admin/payouts`
- **User:** Brian (`brian@peerloop.com`, admin)
- **Tests (~5-6):**
  - Courses page loads with data table (6 courses)
  - Course search/filter works
  - Enrollments page loads with enrollment data
  - Payouts page displays pending and completed payouts
  - Admin can navigate between all admin sections
  - Student-Teachers page loads

#### 8. Discovery & Filters (`e2e/discovery.spec.ts`)
- **Route:** `/discover/courses`, `/discover/teachers`, `/discover/communities`
- **User:** Public
- **Tests (~3-4):**
  - Discovery hub (`/discover`) loads with category cards
  - Course browse with filter/sort options visible
  - Teacher directory loads with S-T profiles
  - Community discovery loads (3 seeded communities)

#### 9. Signup Flow (`e2e/signup-flow.spec.ts`)
- **Route:** `/signup` → `/onboarding`
- **User:** New registration (careful: may create real DB records)
- **Tests (~3-4):**
  - Signup page renders with form fields
  - Form validation (empty fields, invalid email)
  - Signup modal opens from sidebar "Sign up" link
  - Onboarding page renders for authenticated user (if testing with existing user)
  - **Note:** Full signup may need test isolation strategy (unique emails per run)

---

### E2E-TESTING.TIER3 — Partial Coverage (Stop at External Service Boundary)

3 test suites, ~8-10 tests.

#### 10. Session Booking UI (`e2e/session-booking.spec.ts`)
- **Route:** `/course/[slug]/book`
- **User:** David Rodriguez (enrolled in Intro to n8n)
- **Tests (~3-4):**
  - Login as David → navigate to booking page
  - Teacher selection visible (Marcus Thompson assigned)
  - Calendar renders with available time slots (from D1 availability rules)
  - Time slot selection UI works
  - **Stop before:** Confirming booking (would need BBB for session creation — actually booking itself is D1-only, BBB only needed for join. May be fully testable.)

#### 11. Community Pages (`e2e/community-pages.spec.ts`)
- **Route:** `/community/[slug]`
- **User:** Any authenticated user
- **Tests (~2-3):**
  - Community page loads (AI for You: `/community/ai-for-you`)
  - Tab structure visible (Feed, Courses, Resources, Members)
  - Members tab loads with member list (from D1)
  - Feed tab renders structure (shows error/empty state without Stream — verify graceful degradation)

#### 12. Creator Application (`e2e/creator-application.spec.ts`)
- **Route:** `/creating/apply`
- **User:** Alex Chen (new user, no creator role)
- **Tests (~2-3):**
  - Login as Alex → navigate to `/creating/apply`
  - Application form renders with required fields
  - Form validation works (empty required fields)
  - **Stop before:** Actual submission (triggers email notification)

---

### E2E-TESTING.WEBHOOKS — Post-Webhook State Verification

Test that pages correctly display data produced by webhooks, using pre-seeded D1 data. No external services needed — the seed data represents the end state after webhooks would have fired.

3-4 test suites, ~12-15 tests.

#### 13. Completed Sessions & Ratings (`e2e/session-completed.spec.ts`)
- **Seeded data:** `ses-david-n8n-1` (completed session with ratings)
- **Tests (~4-5):**
  - Load completed session page → shows "Session Complete" state
  - Session assessment/rating data displayed
  - Rating form renders for sessions without ratings
  - Session attendance data visible
  - Navigate from session to course page

#### 14. Earnings & Payments (`e2e/earnings.spec.ts`)
- **Seeded data:** 6 transactions, 8 payment_splits, 3 payouts
- **Tests (~4-5):**
  - Login as Sarah → `/teaching/earnings` → earnings summary renders
  - Payment split breakdown visible
  - Login as Guy → `/creating/earnings` → creator earnings render
  - Payout history visible (completed payout for Guy)
  - Earnings amounts are non-zero (seeded data totals ~$1,494)

#### 15. Admin Payouts & Certificates (`e2e/admin-webhookstate.spec.ts`)
- **Seeded data:** 3 payouts, 9 certificates
- **Tests (~3-5):**
  - Login as Brian → `/admin/payouts` → payout table loads
  - Pending payouts visible (Marcus has pending payout)
  - Completed payouts visible (Guy, Sarah)
  - Navigate to `/admin/certificates` → certificate list loads
  - Mix of completion and teaching certificates visible

---

### E2E-TESTING.FEEDS — Feed Page Testing with Route Interception

Test feed pages using Playwright's `page.route()` to intercept Stream.io API calls and return mock data. No code changes needed.

2-3 test suites, ~8-10 tests.

#### 16. Community Feed (with mocked Stream) (`e2e/community-feed.spec.ts`)
- **Approach:** Intercept `**/api/feeds/community/**` with mock activity JSON
- **Tests (~3-4):**
  - Community page loads with mocked feed activities
  - Feed posts render with author, content, timestamp
  - Reaction counts display
  - Comment section structure renders

#### 17. Course Feed (with mocked Stream) (`e2e/course-feed.spec.ts`)
- **Approach:** Intercept `**/api/feeds/course/**` with mock activity JSON
- **Tests (~2-3):**
  - Course feed tab loads with mocked activities
  - Discussion posts render correctly
  - Empty feed shows appropriate message

#### 18. Home Feed (with mocked Stream) (`e2e/home-feed.spec.ts`)
- **Approach:** Intercept `**/api/feeds/timeline**` with mock activity JSON
- **Tests (~2-3):**
  - Home feed page loads with mocked timeline
  - Feed activity cards render
  - Empty/error states handled gracefully

**Playwright route interception pattern:**
```typescript
// In test setup
await page.route('**/api/feeds/**', async (route) => {
  await route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify({
      results: [
        {
          id: 'mock-activity-1',
          actor: { id: 'usr-guy-rymberg', data: { name: 'Guy Rymberg' } },
          verb: 'post',
          object: 'mock-post-1',
          content: 'Welcome to the community!',
          time: '2026-02-27T10:00:00Z',
          reaction_counts: { like: 3, comment: 1 },
        },
      ],
      next: '',
      duration: '10ms',
    }),
  });
});
```

---

### Summary Table

| Tier | New Files | New Tests | External Deps | Priority |
|------|-----------|-----------|--------------|----------|
| Tier 1: Core Dashboards | 5 | ~20-24 | None | High |
| Tier 2: Settings/Admin/Discovery | 4 | ~16-19 | None | High |
| Tier 3: Boundary Testing | 3 | ~8-10 | Partial (stop at boundary) | Medium |
| Webhooks: Post-State | 3-4 | ~12-15 | None (seeded D1) | Medium |
| Feeds: Route Mocks | 2-3 | ~8-10 | Playwright mocks only | Lower |
| **Total New** | **17-19** | **~64-78** | | |

Combined with existing 4 files / 19 tests → **~21-23 files / ~83-97 tests**.

---

## Part 2: FEEDS Block Cleanup

### What to REMOVE (already implemented by COMMUNITY block, Sessions 54-58)

**FEEDS.ARCHITECTURE** — Entire section. Architecture was decided and built:
- Townhall feed (`townhall:main`) — platform-wide
- Per-community feeds (`community:[slug]`)
- Per-course feeds (`course:[slug]`)
- Timeline feeds (user following)
- This is effectively "Option C" from the original options table

**FEEDS.IMPLEMENTATION** — Entire section. All tasks completed:
- Feed groups exist in Stream Dashboard
- `src/lib/stream.ts` has full REST API client (edge-compatible)
- API endpoints: `/api/feeds/community/[slug]`, `/api/feeds/course/[slug]`, `/api/feeds/timeline`, `/api/feeds/townhall`
- Post creation fans out to community + course feeds
- TownHallFeed, CommunityFeed, CourseFeed, HomeFeed components built
- Reactions and threaded comments implemented

**Most of FEEDS.CONTEXT** — Replace with updated summary of what's built.

**FEEDS.OPEN_QUESTIONS items that are answered:**
- "Per-course feeds needed?" → Yes, implemented
- "Announcements separate?" → Currently tagged in feeds, not separate feed
- "User personalization?" → Not implemented, but timeline follows handle this

### What to KEEP (still genuinely pending)

**FEEDS.RANKING** — Keep as-is. Algorithmic feeds require paid Stream tier and client decision. No work done.

**FEEDS.MOBILE** — Keep but update. Pagination exists in components, but caching strategy, skeleton loading, and 3G testing not done.

**FEEDS.LIMITATIONS** — Keep but note which workarounds were implemented (separate feeds per topic = done via per-community/per-course feeds).

**FEEDS.OPEN_QUESTIONS** — Slim to:
- Paid tier for ranked feeds? (Still awaiting client input)
- Real-time updates? Polling vs WebSocket (Still deferred)

### Updated FEEDS Block Structure

```markdown
## Deferred: FEEDS

**Focus:** Ranked/algorithmic feeds and mobile performance optimization
**Status:** 📋 PENDING (awaiting client input on paid tier)
**Tech Doc:** `docs/tech/tech-002-stream.md`

**Completed:** Stream.io REST client (edge-compatible), feed groups (townhall, community, course, timeline), post/reaction/comment CRUD, TownHallFeed + CommunityFeed + CourseFeed + HomeFeed components, per-community and per-course feeds with fan-out on write, threaded comments via reactions. (COMMUNITY block, Sessions 54-58)

### FEEDS.RANKING
*Configure algorithmic feed ordering (requires paid Stream tier)*
[Keep existing content — ranking formula, activity fields, user preference weights, tasks]

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
```

---

## Part 3: Block Sequence Table Update

Update the DEFERRED table in PLAN.md:

| Priority | Block | Name |
|----------|-------|------|
| 1 | FEEDS | Ranked Feeds & Mobile Performance |
| **2** | **E2E-TESTING** | **Comprehensive E2E Test Coverage** |
| 3 | ROLES | Admin Role Management |
| 4 | SEEDDATA | Database Seeding & Empty State |
| 5 | ESCROW | Payment Hold & Escrow |
| ... | ... | ... |

(FEEDS description updated from "Feed Architecture & Algorithmic Feeds" to "Ranked Feeds & Mobile Performance" since architecture is done.)

---

## Implementation Steps

1. Update FEEDS block in PLAN.md — remove completed sections, update context, slim open questions
2. Add E2E-TESTING block to PLAN.md — full block with all tiers and sub-sections
3. Update Block Sequence table — add E2E-TESTING, renumber, update FEEDS description
4. Update Last Updated footer

No code changes. PLAN.md documentation only.
