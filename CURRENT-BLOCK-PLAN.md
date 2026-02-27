# CURRENT-BLOCK-PLAN.md

## Active Work: E2E-TESTING Block Implementation

**Block:** E2E-TESTING (PLAN.md priority 2 under DEFERRED)
**Status:** IN PROGRESS — Sessions A-D complete, E-F remaining
**Reference:** `docs/reference/TEST-E2E.md`, PLAN.md lines 174-253

### Progress (Session 302)
- **Completed:** Steps 0-12 (Sessions A-D) — 13 new files, 52 new tests
- **Current totals:** 17 E2E files, 71 tests (was 4 files / 19 tests)
- **All 71 tests passing** (zero regressions)
- **Remaining:** Steps 13-19 (Sessions E-F) — 7 files, ~25-35 tests

---

## Goal

Expand E2E coverage from 4 files / 19 tests to ~21-23 files / ~83-97 tests. All new tests use seeded D1 data — no external services required except Playwright route interception for feed content (TIER FEEDS).

---

## Implementation Approach

### Shared Login Helper (Step 0)

All 4 existing tests inline login logic. With 17+ new files needing auth, extract a shared helper first.

**Create:** `e2e/helpers.ts`

```typescript
import { Page, expect } from '@playwright/test';

/**
 * Login via the modal UI.
 * Navigates to /login, waits for modal hydration, fills credentials, waits for close.
 */
export async function login(page: Page, email: string, password = 'dev123') {
  await page.goto('/login');
  const emailInput = page.getByLabel('Email address');
  await expect(emailInput).toBeVisible({ timeout: 15000 });
  await emailInput.fill(email);
  await page.getByLabel('Password').fill(password);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await expect(emailInput).not.toBeVisible({ timeout: 15000 });
}
```

**Convention:** New tests import `login` from helpers. Existing 4 tests are NOT refactored (avoid churn).

### Test User Quick Reference

| User | Email | Use For |
|------|-------|---------|
| David Rodriguez | `david.r@example.com` | Student flows (in-progress enrollment, booking, learning) |
| Jennifer Kim | `jennifer.kim@example.com` | Completed enrollment flows |
| Brian | `brian@peerloop.com` | Admin flows |
| Guy Rymberg | `guy-rymberg@example.com` | Creator flows (4 courses, earnings, communities) |
| Sarah Miller | `sarah.miller@example.com` | S-T flows (teaching, earnings, students) |
| Alex Chen | `newuser@example.com` | New user flows (no enrollments, creator application) |

Password for all: `dev123`

### Timing Conventions

- **15s** — Initial page load (hydration + API fetch)
- **10s** — Secondary data load (tab switch, navigation)
- **5s** — Interaction responses (button click, form submit)

### Selector Conventions

- Sidebar: `page.locator('aside').getByRole('link', { name: '...' })`
- Page titles: `page.getByRole('heading', { name: '...' })`
- Disambiguate: use `.first()`, `exact: true`, or `a[href="..."]`
- Admin sidebar: `page.getByRole('link', { name: '...' })` (AdminLayout, no `<aside>` prefix needed)

---

## TIER 1: Core Dashboards & Pages (5 files, ~20-24 tests)

No external dependencies. All data from D1 via seeded `migrations-dev/0001_seed_dev.sql`.

### 1. `e2e/creator-dashboard.spec.ts`

**Route:** `/creating`
**User:** Guy Rymberg (creator, 4 courses)
**Pattern:** `beforeEach` login as Guy

**Seeded data for assertions:**
- 4 courses: AI Tools Overview, Intro to Claude Code, Vibe Coding 101, Intro to n8n
- Communities: AI for You (5 members), Automation Majors (3 members)
- Earnings: payment_splits with Guy as creator (15% royalty share)
- 156 total students across courses (enrollment counts in seed)

**Tests (~4-5):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load creator dashboard | `/creating` | Page heading visible, main content renders |
| 2 | should display creator courses | `/creating` | At least 2 course titles visible (e.g., "AI Tools Overview", "Intro to n8n") |
| 3 | should show earnings summary | `/creating` or `/creating/earnings` | Earnings section/heading renders, amounts non-zero |
| 4 | should navigate to communities | `/creating/communities` | Community list renders (AI for You, Automation Majors) |
| 5 | should navigate to studio | `/creating/studio` | Studio page loads |

**Notes:**
- Creator dashboard is a React island (`client:load`), needs 15s timeout for initial data
- Guy has `stripe_account_id: 'acct_mock_guy'` with `stripe_payouts_enabled=1` — payments page should show connected state via D1 fallback

### 2. `e2e/teaching-dashboard.spec.ts`

**Route:** `/teaching`
**User:** Sarah Miller (S-T, certified for Intro to Claude Code)
**Pattern:** `beforeEach` login as Sarah

**Seeded data for assertions:**
- S-T certification for Intro to Claude Code (Sarah teaches Jennifer)
- 1 completed enrollment as student (AI Tools Overview under Guy)
- Teaching earnings from payment_splits (70% S-T share)
- `stripe_account_id: 'acct_mock_sarah'`

**Tests (~4-5):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load teaching dashboard | `/teaching` | Page heading visible |
| 2 | should show students | `/teaching` or `/teaching/students` | Student list renders (Jennifer Kim visible) |
| 3 | should show earnings | `/teaching/earnings` | Earnings heading renders, amounts present |
| 4 | should show sessions | `/teaching/sessions` | Sessions list/heading renders |
| 5 | should navigate to analytics | `/teaching/analytics` | Analytics page loads |

**Notes:**
- Sarah's S-T certification: `st-sarah-claude-code` for `crs-intro-to-claude-code`
- Jennifer is Sarah's only student in seed data
- Sarah has completed sessions with Jennifer (2 sessions, both completed)

### 3. `e2e/course-detail.spec.ts`

**Route:** `/course/[slug]` (tabbed layout)
**Users:** Public (no auth) + David Rodriguez (enrolled)
**Pattern:** No `beforeEach` — some tests public, one authenticated

**Seeded data for assertions:**
- AI Tools Overview: slug `ai-tools-overview`, 3 modules, 67 enrollments, 4.9 rating, 34 reviews
- Intro to n8n: slug `intro-to-n8n`, 2 modules, 38 enrollments, 4.7 rating, David enrolled
- Course tabs: About, Curriculum, Teachers, Resources, Feed
- S-Ts listed on Teachers tab

**Tests (~4-5):**

| # | Test Name | Auth | Navigate To | Assert |
|---|-----------|------|------------|--------|
| 1 | should load course with About tab | No | `/course/ai-tools-overview` | Course title heading, description/about content visible |
| 2 | should show curriculum tab | No | `/course/ai-tools-overview` → click Curriculum | Module list renders (3 modules) |
| 3 | should show teachers tab | No | `/course/ai-tools-overview` → click Teachers | S-T names visible |
| 4 | should show Enroll Now for unenrolled | No | `/course/ai-tools-overview` | "Enroll Now" or price button visible |
| 5 | should show Continue for enrolled user | David | `/course/intro-to-n8n` | Different CTA for enrolled user (e.g., "Continue Learning") |

**Notes:**
- Tab navigation is URL-based: `/course/[slug]` (about), and may use tab component clicks
- SSR renders course data from D1, tabs are client-side
- Public view shows "Enroll Now" with price; enrolled view shows progress/continue CTA
- Course reviews are seeded — ratings may show on About tab

### 4. `e2e/course-learning.spec.ts`

**Route:** `/course/[slug]/learn`
**User:** David Rodriguez (35% progress in Intro to n8n)
**Pattern:** `beforeEach` login as David

**Seeded data for assertions:**
- David's enrollment: `enr-david-n8n`, status `in_progress`, progress_percent 35
- Course: Intro to n8n, 2 modules
- Module 1 completed by David, Module 2 in progress
- Module progress records in `module_progress` table

**Tests (~3-4):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load learning page | `/course/intro-to-n8n/learn` | Page renders without error, course title visible |
| 2 | should show module list | `/course/intro-to-n8n/learn` | Module headings/names visible (at least 2) |
| 3 | should show progress indicator | `/course/intro-to-n8n/learn` | Progress percentage or bar visible (~35%) |
| 4 | should handle unenrolled redirect | `/course/ai-tools-overview/learn` (David NOT enrolled) | Redirects to course detail or shows error |

**Notes:**
- `/course/[slug]/learn` is auth-gated — unenrolled users redirect to `/course/[slug]?error=not-enrolled`
- Progress rendering depends on the learning page component (`client:load`)
- David has `module_progress` records linking to his enrollment

### 5. `e2e/profiles.spec.ts`

**Routes:** `/@[handle]`, `/creator/[handle]`, `/teacher/[handle]`
**Users:** Public (no auth required for profile viewing)
**Pattern:** No login needed

**Seeded data for assertions:**
- Guy Rymberg: handle `guy-rymberg`, creator, 4 courses
- Sarah Miller: handle `sarah-miller`, S-T
- David Rodriguez: handle `david-rodriguez`, student
- Handles stored in `users.handle` column

**Tests (~4-5):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load creator profile | `/creator/guy-rymberg` | Guy's name visible, course list or count |
| 2 | should load teacher profile | `/teacher/sarah-miller` | Sarah's name visible, teaching info |
| 3 | should load universal profile | `/@guy-rymberg` | Profile page renders with name |
| 4 | should show courses on creator profile | `/creator/guy-rymberg` | At least one course title visible |
| 5 | should handle non-existent profile | `/creator/nobody-here` | 404 or redirect to discovery |

**Notes:**
- Profile pages are SSR with D1 queries — should load without client-side fetch delays
- `/@[handle]` is a role-adaptive unified profile
- `/creator/[handle]` and `/teacher/[handle]` are role-specific views
- Check whether handle routing uses `users.handle` or `users.slug` — verify in seed data

---

## TIER 2: Settings, Admin CRUD, Discovery, Signup (4 files, ~16-19 tests)

No external dependencies. Extends admin coverage beyond overview.

### 6. `e2e/settings.spec.ts`

**Route:** `/settings/*`
**User:** David Rodriguez (has profile, no Stripe connected)
**Pattern:** `beforeEach` login as David

**Tests (~4-5):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load settings hub | `/settings` | Settings heading, links to sub-pages |
| 2 | should show profile settings | `/settings/profile` | Profile form with David's current data (name, handle) |
| 3 | should show notification settings | `/settings/notifications` | Notification toggles/checkboxes render |
| 4 | should show security settings | `/settings/security` | Password change form renders |
| 5 | should show payments settings | `/settings/payments` | Payments page renders — David has no Stripe account, should show "not connected" state |

**Bonus test (Sarah):** Login as Sarah → `/settings/payments` → should show connected state (D1 fallback: `acct_mock_sarah`, `stripe_payouts_enabled=1`)

### 7. `e2e/admin-crud.spec.ts`

**Route:** `/admin/*` (beyond overview)
**User:** Brian (admin)
**Pattern:** `beforeEach` login as Brian

**Seeded data for assertions:**
- 6 courses, 6 enrollments, 6+ users, 3 payouts, 9 certificates
- Admin pages render data tables with search/filter

**Tests (~5-6):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load courses page | `/admin/courses` | Course table renders, at least 4 courses visible |
| 2 | should search courses | `/admin/courses` → type in search | Filter reduces results (e.g., search "n8n") |
| 3 | should load enrollments page | `/admin/enrollments` | Enrollment table renders with data |
| 4 | should load payouts page | `/admin/payouts` | Payout table renders (3 seeded payouts) |
| 5 | should load student-teachers page | `/admin/student-teachers` | S-T table renders (Sarah, Marcus, Amanda) |
| 6 | should load certificates page | `/admin/certificates` | Certificate table renders (9 certificates seeded) |

**Notes:**
- Admin pages use AdminLayout with dark sidebar (already tested in admin-overview)
- Data tables are React islands — use 15s timeout for initial render
- Search/filter is client-side within the React component

### 8. `e2e/discovery.spec.ts`

**Route:** `/discover/*`
**User:** Public (no auth needed)
**Pattern:** No login

**Seeded data for assertions:**
- 6 courses across 2 creators
- S-Ts: Sarah Miller, Marcus Thompson, Amanda Lee
- Communities: The Commons (system), AI for You, Automation Majors, Q-System

**Tests (~3-4):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load discovery hub | `/discover` | Discovery page renders with category links |
| 2 | should browse courses | `/discover/courses` | Course cards render (at least 4 courses) |
| 3 | should browse teachers | `/discover/teachers` | S-T profiles render |
| 4 | should browse communities | `/discover/communities` | Community cards render (AI for You, Automation Majors visible) |

**Notes:**
- `/discover` is a hub page with links to sub-pages
- `/discover/courses` already partially tested in browse-enroll.spec.ts — this adds standalone coverage
- Community and teacher directories are newer features

### 9. `e2e/signup-flow.spec.ts`

**Route:** `/signup` → form validation
**User:** Unauthenticated
**Pattern:** No login (testing the signup form itself)

**Tests (~3-4):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should render signup form | `/signup` | Signup modal auto-opens (like login), form fields visible |
| 2 | should validate empty fields | `/signup` → click submit | Validation errors appear |
| 3 | should validate email format | `/signup` → enter invalid email | Email validation error |
| 4 | should open from sidebar | `/` → click "Sign up" in sidebar | Signup modal opens |

**Notes:**
- Signup uses the same modal pattern as login (two-island hydration)
- Do NOT actually complete signup (creates real DB records, no cleanup strategy)
- Test validation and form rendering only
- If signup creates a user, need unique email per run — defer actual submission to manual testing

---

## TIER 3: Partial Coverage — Stop at External Service Boundary (3 files, ~8-10 tests)

### 10. `e2e/session-booking.spec.ts`

**Route:** `/course/[slug]/book`
**User:** David Rodriguez (enrolled in Intro to n8n)
**Pattern:** `beforeEach` login as David

**Seeded data:**
- David enrolled in Intro to n8n, assigned S-T: Marcus Thompson
- Marcus has availability rules in `teacher_availability` table
- Booking itself is D1-only (BBB only needed for "Join Session")

**Tests (~3-4):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load booking page | `/course/intro-to-n8n/book` | Page renders, teacher info visible |
| 2 | should show teacher selection | `/course/intro-to-n8n/book` | Marcus Thompson visible as assigned S-T |
| 3 | should show calendar | `/course/intro-to-n8n/book` | Calendar/date picker renders |
| 4 | should show time slots | `/course/intro-to-n8n/book` → select date | Time slots appear based on availability |

**Notes:**
- Booking confirmation writes to D1 only — may be fully testable
- BBB is only needed when clicking "Join Session" on the session page
- If booking creates a session record, consider test isolation (cleanup or unique data)

### 11. `e2e/community-pages.spec.ts`

**Route:** `/community/[slug]`
**User:** David Rodriguez (member of Automation Majors)
**Pattern:** `beforeEach` login as David

**Seeded data:**
- David is member of Automation Majors (`comm-automation-majors`, Guy's community)
- Community has 3 members: Guy, Marcus, David
- Linked course: Intro to n8n

**Tests (~2-3):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load community page | `/community/automation-majors` | Community name heading visible |
| 2 | should show members tab | `/community/automation-majors/members` | Member list renders (Guy, Marcus, David) |
| 3 | should handle feed gracefully without Stream | `/community/automation-majors` | Feed tab renders structure — shows error/empty state, no crash |

**Notes:**
- Community page default tab is Feed (requires Stream.io)
- Without Stream credentials, feed shows error UI with "Try Again" button
- Members tab is pure D1 — should always work
- Test graceful degradation: page doesn't crash, error boundary catches Stream failure

### 12. `e2e/creator-application.spec.ts`

**Route:** `/creating/apply`
**User:** Alex Chen (new user, no creator role)
**Pattern:** `beforeEach` login as Alex

**Tests (~2-3):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should load application form | `/creating/apply` | Form renders with required fields |
| 2 | should validate required fields | `/creating/apply` → submit empty | Validation errors shown |
| 3 | should show form fields | `/creating/apply` | Key fields visible (name, experience, course idea, etc.) |

**Notes:**
- Do NOT submit the form — triggers email notification via Resend
- Alex has no creator role, so the apply page should be accessible
- If Guy navigates to `/creating/apply`, may redirect to `/creating` (already a creator)

---

## TIER WEBHOOKS: Post-Webhook State Verification (3 files, ~12-15 tests)

These test pages that display data produced by webhooks (Stripe checkout, BBB callbacks). The seed data represents the end-state after webhooks would have fired. No external services needed.

### 13. `e2e/session-completed.spec.ts`

**Route:** `/session/[id]` for completed sessions
**Users:** David Rodriguez, Sarah Miller

**Seeded data:**
- `ses-david-n8n-1`: completed session (2024-12-15), David with Marcus
- Session has attendance records and bidirectional assessments
- `ses-david-n8n-2`: scheduled future session (2026-03-05)
- Sarah had 2 completed sessions with Jennifer

**Tests (~4-5):**

| # | Test Name | User | Navigate To | Assert |
|---|-----------|------|------------|--------|
| 1 | should show completed session state | David | `/session/ses-david-n8n-1` | "Session Complete" or completed status indicator |
| 2 | should display session rating | David | `/session/ses-david-n8n-1` | Rating/assessment data visible |
| 3 | should show upcoming session state | David | `/session/ses-david-n8n-2` | Future session state (scheduled, join button, countdown) |
| 4 | should show cancelled session | David | Session with cancelled status | Cancelled state displayed |
| 5 | should restrict access to non-participants | Alex | `/session/ses-david-n8n-1` | Access denied or redirect |

**Notes:**
- Session pages are participant-only — test access control
- Completed sessions show assessment data, not join button
- Future sessions show countdown/join button (BBB join URL fails without BBB, but page structure should render)

### 14. `e2e/earnings.spec.ts`

**Route:** `/teaching/earnings`, `/creating/earnings`
**Users:** Sarah Miller (S-T), Guy Rymberg (Creator)

**Seeded data:**
- 6 transactions totaling ~$1,494
- 8 payment_splits (70% S-T / 15% creator / 15% platform)
- 3 payouts: Guy (completed), Sarah (completed), Marcus (pending)
- Earnings are pure D1 aggregation — no Stripe API calls

**Tests (~4-5):**

| # | Test Name | User | Navigate To | Assert |
|---|-----------|------|------------|--------|
| 1 | should show teaching earnings | Sarah | `/teaching/earnings` | Earnings heading, amount visible |
| 2 | should show payment breakdown | Sarah | `/teaching/earnings` | Split amounts or transaction list rendered |
| 3 | should show creator earnings | Guy | `/creating/earnings` | Creator earnings heading, amounts visible |
| 4 | should show payout history | Guy | `/creating/earnings` | Completed payout visible |
| 5 | should show non-zero amounts | Sarah | `/teaching/earnings` | Dollar amounts are present (not $0.00) |

**Notes:**
- Earnings pages aggregate `payment_splits` from D1
- Guy's 15% creator royalty on all courses
- Sarah's 70% S-T commission on Intro to Claude Code enrollments
- Mock Stripe account IDs in D1 mean the pages use D1 fallback for connect status

### 15. `e2e/admin-webhookstate.spec.ts`

**Route:** `/admin/payouts`, `/admin/certificates`
**User:** Brian (admin)

**Seeded data:**
- 3 payouts: Guy (completed, $200), Sarah (completed, $150), Marcus (pending, $100)
- 9 certificates: mix of completion and teaching certificates

**Tests (~3-5):**

| # | Test Name | Navigate To | Assert |
|---|-----------|------------|--------|
| 1 | should display payout table | `/admin/payouts` | Payout table renders with data rows |
| 2 | should show pending payouts | `/admin/payouts` | Marcus's pending payout visible |
| 3 | should show completed payouts | `/admin/payouts` | Guy or Sarah's completed payout visible |
| 4 | should display certificate table | `/admin/certificates` | Certificate table renders with rows |
| 5 | should show certificate types | `/admin/certificates` | Both completion and teaching certificates present |

---

## TIER FEEDS: Route Interception for Stream.io (2-3 files, ~8-10 tests)

Uses Playwright `page.route()` to intercept Stream.io API calls and return mock JSON. No code changes, no Stream credentials needed.

### Mock Data Pattern

**Create:** `e2e/fixtures/mock-feed-data.ts`

```typescript
export const mockFeedResponse = {
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
    {
      id: 'mock-activity-2',
      actor: { id: 'usr-sarah-miller', data: { name: 'Sarah Miller' } },
      verb: 'post',
      object: 'mock-post-2',
      content: 'Just completed my first teaching session!',
      time: '2026-02-27T09:00:00Z',
      reaction_counts: { like: 5, comment: 2 },
    },
  ],
  next: '',
  duration: '10ms',
};

export const emptyFeedResponse = {
  results: [],
  next: '',
  duration: '5ms',
};
```

### Route Interception Helper

Add to `e2e/helpers.ts`:

```typescript
export async function mockFeedApi(page: Page, responseData: unknown) {
  await page.route('**/api/feeds/**', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(responseData),
    });
  });
}
```

**Important:** Call `mockFeedApi()` BEFORE `page.goto()` — route interception must be registered before the page makes API calls.

### 16. `e2e/community-feed.spec.ts`

**Route:** `/community/[slug]` (Feed tab, default)
**User:** David Rodriguez (member of Automation Majors)
**Pattern:** `beforeEach` — login + register mock route

**Tests (~3-4):**

| # | Test | Assert |
|---|------|--------|
| 1 | should render feed with mocked activities | Feed posts visible with author names and content |
| 2 | should show reaction counts | Like/comment counts visible on posts |
| 3 | should show post timestamps | Time indicators on feed items |
| 4 | should handle empty feed | Empty state message when no activities |

### 17. `e2e/course-feed.spec.ts`

**Route:** `/course/[slug]/feed`
**User:** David Rodriguez (enrolled in Intro to n8n)
**Pattern:** Login + mock route interception

**Tests (~2-3):**

| # | Test | Assert |
|---|------|--------|
| 1 | should render course feed with mocked posts | Discussion posts visible |
| 2 | should show empty feed state | Empty feed message when no activities |
| 3 | should show feed within course tab layout | Feed tab active, course navigation present |

### 18. `e2e/home-feed.spec.ts`

**Route:** `/feed`
**User:** David Rodriguez
**Pattern:** Login + mock route interception (intercept `**/api/feeds/timeline**`)

**Tests (~2-3):**

| # | Test | Assert |
|---|------|--------|
| 1 | should render home feed with mocked timeline | Feed activity cards visible |
| 2 | should show empty feed state | Appropriate empty message |
| 3 | should show feed page structure | Page heading, layout correct |

---

## Implementation Order

Work through tiers sequentially. Within each tier, implement in the numbered order (simpler → complex).

| Step | File | Tests | Status |
|------|------|-------|--------|
| **0** | `e2e/helpers.ts` | — | ✅ Done (Session A) |
| **1** | `e2e/profiles.spec.ts` | 5 | ✅ Done (Session A) |
| **2** | `e2e/course-detail.spec.ts` | 5 | ✅ Done (Session A) |
| **3** | `e2e/creator-dashboard.spec.ts` | 5 | ✅ Done (Session B) |
| **4** | `e2e/teaching-dashboard.spec.ts` | 5 | ✅ Done (Session B) |
| **5** | `e2e/course-learning.spec.ts` | 4 | ✅ Done (Session B) |
| **6** | `e2e/discovery.spec.ts` | 4 | ✅ Done (Session C) |
| **7** | `e2e/settings.spec.ts` | 5 | ✅ Done (Session C) |
| **8** | `e2e/admin-crud.spec.ts` | 6 | ✅ Done (Session C) |
| **9** | `e2e/signup-flow.spec.ts` | 4 | ✅ Done (Session C) |
| **10** | `e2e/session-booking.spec.ts` | 3 | ✅ Done (Session D) |
| **11** | `e2e/community-pages.spec.ts` | 3 | ✅ Done (Session D) |
| **12** | `e2e/creator-application.spec.ts` | 3 | ✅ Done (Session D) |
| **13** | `e2e/session-completed.spec.ts` | ~4-5 | ⬜ Pending (Session E) |
| **14** | `e2e/earnings.spec.ts` | ~4-5 | ⬜ Pending (Session E) |
| **15** | `e2e/admin-webhookstate.spec.ts` | ~3-5 | ⬜ Pending (Session E) |
| **16** | `e2e/fixtures/mock-feed-data.ts` | — | ⬜ Pending (Session F) |
| **17** | `e2e/community-feed.spec.ts` | ~3-4 | ⬜ Pending (Session F) |
| **18** | `e2e/course-feed.spec.ts` | ~2-3 | ⬜ Pending (Session F) |
| **19** | `e2e/home-feed.spec.ts` | ~2-3 | ⬜ Pending (Session F) |

### Work Sessions

Each session should implement 2-4 test files, run them, fix failures, and commit.

| Session | Files | Target | Status |
|---------|-------|--------|--------|
| A | Step 0-2 | helpers + profiles + course-detail | ✅ 10 tests |
| B | Step 3-5 | creator-dashboard + teaching-dashboard + course-learning | ✅ 14 tests |
| C | Step 6-9 | discovery + settings + admin-crud + signup | ✅ 19 tests |
| D | Step 10-12 | session-booking + community-pages + creator-application | ✅ 9 tests |
| E | Step 13-15 | session-completed + earnings + admin-webhookstate | ⬜ Next |
| F | Step 16-19 | mock fixtures + all feed tests | ⬜ Pending |

---

## Per-File Workflow

For each test file:

1. **Create the file** with describe block, beforeEach (if needed), and test stubs
2. **Run headed** (`npm run test:e2e -- e2e/FILE.spec.ts --headed`) to see the actual page
3. **Inspect selectors** — check what headings, text, and elements actually render
4. **Write assertions** based on what's visible, using correct selectors
5. **Run headless** — verify all tests pass
6. **Commit** — one commit per file or per logical group

---

## PLAN.md Checklist Tracking

As files are completed, check them off in PLAN.md under the corresponding tier section. The checkbox format is already there:

```
- [x] `e2e/profiles.spec.ts` (~4-5 tests) — Creator/teacher/user profiles via handle-based routing
```

---

## External Service Reminder

| Service | Impact | Action |
|---------|--------|--------|
| **Resend** | None | Ignore completely — fire-and-forget |
| **Stripe** | Only Checkout/Connect redirects | Test around redirects; earnings/payouts pure D1 |
| **BBB** | Only "Join Session" button | Test booking/ratings/schedule from D1 |
| **Stream.io** | Feed content exclusive to Stream | Playwright route interception (TIER FEEDS) |
