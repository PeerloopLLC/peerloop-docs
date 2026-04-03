# E2E Testing Guide

End-to-end tests using Playwright that validate critical user flows against the running application.

**Last Updated:** 2026-03-16 (Session 390 — verified 25 files, 105 tests)

---

## Why E2E Tests Matter

E2E tests are the only tests that verify the full stack working together: SSR rendering, React island hydration, API calls, database queries, and browser behavior. They catch issues that unit tests cannot:

- Astro island hydration failures (components never mount)
- Cross-island state synchronization (e.g., login modal depends on two islands)
- SSR → client handoff bugs
- Navigation and routing behavior
- Auth flow end-to-end (cookie setting, redirects, session state)

---

## Prerequisites

### 1. Seeded Local Database

E2E tests run against the live dev server with real D1 data. The database must be seeded:

```bash
npm run db:setup:local:dev
```

This applies `migrations/0001_schema.sql`, `migrations/0002_seed_core.sql`, and `migrations-dev/0001_seed_dev.sql`.

### 2. Playwright Browsers

Chromium must be installed locally:

```bash
npx playwright install chromium
```

### 3. Dev Server

Playwright auto-starts the dev server via `playwright.config.ts`, but you can also start it manually for faster iteration:

```bash
npm run dev
```

If already running on port 4321, Playwright reuses it (`reuseExistingServer: !process.env.CI`).

---

## Running Tests

```bash
# Run all E2E tests
npm run test:e2e

# Run a specific test file
npm run test:e2e -- e2e/auth-dashboard.spec.ts

# Run tests matching a name pattern
npm run test:e2e -- -g "should login"

# Run in headed mode (see the browser)
npm run test:e2e -- --headed

# Debug mode (step through with inspector)
npm run test:e2e -- --debug

# View last test report
npx playwright show-report
```

---

## Configuration

**File:** `playwright.config.ts`

| Setting | Value | Notes |
|---------|-------|-------|
| Test directory | `./e2e` | All test files live here |
| Base URL | `http://localhost:4321` | Astro dev server |
| Browser | Chromium only | Desktop Chrome profile |
| Parallel | Yes (`fullyParallel: true`) | Tests run concurrently |
| Retries | 0 (dev), 2 (CI) | CI retries on flakes |
| Workers | auto (dev), 1 (CI) | CI runs single-threaded |
| Trace | on-first-retry | Captures trace for debugging failures |
| Web server | `npm run dev` | Auto-starts if not running |
| Server timeout | 120s | Dev server startup can be slow |

---

## Test Users

All test users come from `migrations-dev/0001_seed_dev.sql`. Password for all: **`Password1`**

| User | Email | ID | Role | Key Data |
|------|-------|----|------|----------|
| David Rodriguez | `david.r@example.com` | `usr-david-rodriguez` | Student | In-progress enrollment in "Intro to n8n" |
| Jennifer Kim | `jennifer.kim@example.com` | `usr-jennifer-kim` | Student | Completed enrollment in "Intro to Claude Code" |
| Brian | `brian@peerloop.com` | `usr-brian-admin` | Admin | Full admin access, `is_admin=1` |
| Alex Chen | `newuser@example.com` | `usr-new-user` | New user | No enrollments (clean slate) |
| Guy Rymberg | `guy_rymberg@example.com` | `usr-guy_rymberg` | Creator | 4 courses, Stripe Connect account |
| Marcus Thompson | `marcus.t@example.com` | `usr-marcus-thompson` | Teacher | Teacher for n8n + AI Tools, Tue/Thu 10-18 CT |
| Sarah Miller | `sarah.miller@example.com` | `usr-sarah-miller` | Teacher | Can teach, completed enrollment |

---

## Test Flows

### 1. Homepage (`e2e/homepage.spec.ts` — 5 tests)

Validates the homepage with AppLayout sidebar navigation.

| Test | What It Verifies |
|------|-----------------|
| Page load | Title contains "Peerloop" |
| Sidebar brand | "Peerloop" link visible in `<aside>` |
| Discover menu | "Discover" item present in sidebar |
| Discover → Courses | Click Discover → slide panel → click Courses → navigates to `/discover/courses` |
| Login option | Visitors see "Log in" in sidebar |

### 2. Browse → Enroll (`e2e/browse-enroll.spec.ts` — 5 tests)

Validates the course discovery and enrollment flow. Stripe checkout is external, so the flow is split:
- **Part A:** Browse → select → view detail → enroll redirect (unauthenticated)
- **Part B:** Success page verification (with pre-seeded enrolled user)

| Test | What It Verifies |
|------|-----------------|
| Course browse page | `/discover/courses` loads, courses render from D1 |
| Navigate to detail | Click course card → `/course/[slug]` |
| Course detail + enroll | Course title, "Enroll Now" button visible |
| Enroll redirect | Unauthenticated click → redirects to `/login` |
| Success page | Login as Jennifer → `/course/intro-to-claude-code/success` → "You're Enrolled!" |

**Why split:** Stripe Checkout is an external page we can't control in tests. API tests already cover the checkout session creation and webhook processing.

### 3. Auth → Dashboard (`e2e/auth-dashboard.spec.ts` — 4 tests)

Validates the authentication and student dashboard experience.

| Test | What It Verifies |
|------|-----------------|
| Login + dashboard | Login as David → navigate to `/learning` → "My Learning" heading |
| Enrollment display | Dashboard shows David's "Intro to n8n" enrollment |
| Invalid credentials | Wrong password → error alert displayed |
| Unauthenticated access | `/learning` without login → handles gracefully |

### 4. Admin Overview (`e2e/admin-overview.spec.ts` — 5 tests)

Validates admin login and navigation. Uses `beforeEach` to login as Brian (admin).

| Test | What It Verifies |
|------|-----------------|
| Admin dashboard | `/admin` loads, Dashboard link visible |
| Navigate to users | Click "Users" in sidebar → `/admin/users` |
| User list | Users page shows seed data (e.g., "Guy Rymberg") |
| Sidebar sections | All sidebar links present (Dashboard, Users, Courses, Enrollments, Payouts) |
| Back to App | "Back to App" link visible in sidebar |

### 5. Profiles (`e2e/profiles.spec.ts` — 5 tests)

Public profile pages — no auth required.

| Test | What It Verifies |
|------|-----------------|
| Creator profile | `/creator/guy_rymberg` loads, name + About heading visible |
| Creator courses | "Courses by" heading with course titles |
| Teacher profile | `/teacher/sarah-miller` loads, name visible |
| Universal profile | `/@guy_rymberg` renders PublicProfile |
| Non-existent profile | `/creator/nobody-here-at-all` shows "not found" |

### 6. Course Detail (`e2e/course-detail.spec.ts` — 5 tests)

Course page tabs and enrollment CTA.

| Test | What It Verifies |
|------|-----------------|
| About tab | `/course/ai-tools-overview` loads with "What You'll Learn" |
| Teachers tab | Click Teachers tab → "View Profile" links appear |
| Resources tab | Click Resources tab renders |
| Enroll Now (unauthenticated) | "Enroll Now" button visible for visitors |
| Enrolled user CTA | David on `/course/intro-to-n8n` sees "Curriculum" tab |

### 7. Creator Dashboard (`e2e/creator-dashboard.spec.ts` — 5 tests)

Login as Guy Rymberg → `/creating`.

| Test | What It Verifies |
|------|-----------------|
| Dashboard load | "Creator Dashboard" heading + "Welcome back, Guy" |
| Creator courses | "Your Courses" section with course titles |
| Earnings overview | "Earnings Overview" heading renders |
| Studio navigation | `/creating/studio` loads "Creator Studio" |
| Communities | `/creating/communities` loads |

### 8. Teaching Dashboard (`e2e/teaching-dashboard.spec.ts` — 5 tests)

Login as Sarah Miller → `/teaching`.

| Test | What It Verifies |
|------|-----------------|
| Dashboard load | "Teaching Dashboard" heading visible |
| Personalized welcome | "Welcome, Teacher Sarah" greeting |
| Students page | `/teaching/students` shows "My Students" |
| Sessions page | `/teaching/sessions` shows "Session History" |
| Earnings page | `/teaching/earnings` shows "Teaching Earnings" |

### 9. Course Learning (`e2e/course-learning.spec.ts` — 4 tests)

Login as David → `/course/intro-to-n8n/learn`.

| Test | What It Verifies |
|------|-----------------|
| Learning page load | Course title visible |
| Module list | "Module" text in sidebar |
| Progress indicator | "Your Progress" or "% complete" visible |
| Unenrolled redirect | `/course/ai-tools-overview/learn` redirects (David not enrolled) |

### 10. Discovery (`e2e/discovery.spec.ts` — 4 tests)

Public discovery pages — no auth.

| Test | What It Verifies |
|------|-----------------|
| Discovery hub | `/discover` heading + sub-page links in main |
| Browse courses | `/discover/courses` shows 4+ course cards |
| Browse teachers | `/discover/teachers` shows Sarah Miller |
| Browse communities | `/discover/communities` heading renders |

### 11. Settings (`e2e/settings.spec.ts` — 5 tests)

Login as David → `/settings/*`.

| Test | What It Verifies |
|------|-----------------|
| Settings hub | Links to profile and security pages |
| Profile settings | "Profile Settings" + Display Name label |
| Notification settings | Toggle switches render |
| Security settings | "Sign Out" button visible |
| Payments settings | "Payment" heading renders |

### 11b. Notifications (`e2e/notifications.spec.ts` — 9 tests)

Login as David → `/notifications`.

| Test | What It Verifies |
|------|-----------------|
| Load page with items | "Session Tomorrow" and "New Resource Available" render |
| Count summary | "2 notifications (2 unread)" text |
| Filter tabs | All and Unread tab buttons present |
| Switch to unread filter | Unread tab fetches filtered results |
| Navbar link | Notifications link in left sidebar |
| Delete buttons | Delete button per notification |
| Mark all as read button | Button visible when unread exist |
| Delete notification (mutation) | Deleting reduces count |
| Mark all as read (mutation) | All marked read, button hides |

### 12. Admin CRUD (`e2e/admin-crud.spec.ts` — 6 tests)

Login as Brian → `/admin/*` data pages.

| Test | What It Verifies |
|------|-----------------|
| Courses page | Course data renders (AI Tools Overview) |
| Course search | Filter reduces results (search "n8n") |
| Enrollments page | Student/course names visible |
| Payouts page | Recipient names visible |
| Teachers | Teacher names (Sarah/Marcus) visible |
| Certificates page | Certificate data renders |

### 13. Signup Flow (`e2e/signup-flow.spec.ts` — 4 tests)

Signup form rendering — no actual submission.

| Test | What It Verifies |
|------|-----------------|
| Form fields | Full name, email, password, confirm fields visible |
| Create account button | Submit button in dialog |
| Sidebar trigger | Click "Create account" in sidebar opens modal |
| Legal links | Terms and Privacy links in dialog |

### 14. Session Booking (`e2e/session-booking.spec.ts` — 3 tests)

Login as David → `/course/intro-to-n8n/book`.

| Test | What It Verifies |
|------|-----------------|
| Booking page load | "Book a Session" heading |
| Teacher selection | "Select a Teacher" with Marcus Thompson |
| Course context | "Intro to n8n" visible in breadcrumbs |

### 14b. Session Booking Flow (`e2e/session-booking-flow.spec.ts` — 1 test)

Full booking wizard end-to-end + dual-perspective verification. Login as David, complete the 4-step wizard, then verify both student and teacher see the new session.

| Step | What It Does |
|------|-------------|
| Mock availability | `page.route()` intercepts `/api/teachers/*/availability*` for predictable calendar |
| Teacher selection | Click Marcus Thompson button |
| Date selection | Click March 11 on calendar |
| Time selection | Click 14:00-15:00 slot |
| Confirm booking | Verify summary `<dd>` elements, click "Confirm Booking" |
| Student verification | Capture POST response (201), verify session via `GET /api/sessions?role=student` |
| Teacher verification | Logout → login as Marcus → verify on `/teaching` dashboard + `GET /api/sessions?role=teacher` |

**Patterns demonstrated:**
- Availability API mocking with `page.route()` for date-independent tests
- `waitForLoadState('networkidle')` for React hydration safety (see Gotcha #6)
- `waitForResponse()` to capture POST response and extract session ID
- `getByRole('definition')` to target `<dd>` elements in confirmation summary (avoids strict mode violations from breadcrumbs/back links)
- Dual-perspective: logout → login as different user → verify same data

### 14c. Session Completion Flow (`e2e/session-completion-flow.spec.ts` — 1 test)

BBB webhook-triggered session completion + dual-perspective verification. Fires a synthetic webhook, then verifies both student and teacher see the completed state.

| Step | What It Does |
|------|-------------|
| Fire webhook | `request.post('/api/webhooks/bbb')` with `meeting-ended` payload for `ses-david-n8n-3` |
| Verify webhook | Response status 200, `status: 'processed'`, `event_type: 'room_ended'` |
| Student verification | Login as David → `/session/ses-david-n8n-3` → completed state visible |
| API verification | `GET /api/sessions/ses-david-n8n-3` → `status: 'completed'` |
| Teacher verification | Logout → login as Marcus → verify on `/teaching` dashboard + `GET /api/sessions?role=teacher` |

**Patterns demonstrated:**
- Direct API call via Playwright `request` fixture (no browser context needed for webhook)
- BBB webhook is unauthenticated — no cookies required
- Requires placeholder `BBB_URL`/`BBB_SECRET` in `.dev.vars` (webhook handler checks for them before parsing)
- `ses-david-n8n-3` is seeded as `scheduled` with a past date (simulates "BBB webhook never fired")

### 15. Community Pages (`e2e/community-pages.spec.ts` — 3 tests)

Login as David → `/community/automation-majors`.

| Test | What It Verifies |
|------|-----------------|
| Community page | "Automation Majors" name visible |
| Members tab | `/community/automation-majors/members` shows Guy Rymberg |
| Feed graceful degradation | Default Feed tab doesn't crash without Stream |

### 16. Creator Application (`e2e/creator-application.spec.ts` — 3 tests)

Login as Alex Chen → `/creating/apply`.

| Test | What It Verifies |
|------|-----------------|
| Application form | "Become a Creator" heading |
| Form fields | Expertise, Teaching Experience, Course Ideas labels |
| Submit button | "Submit Application" button visible (not clicked) |

### 17. Session Completed (`e2e/session-completed.spec.ts` — 4 tests)

Session page states using seeded D1 data. Tests completed, upcoming, and cancelled sessions.

| Test | What It Verifies |
|------|-----------------|
| Completed session | David → `ses-david-n8n-1` shows completed state |
| Upcoming session | David → `ses-david-n8n-2` shows scheduled state |
| Cancelled session | David → `ses-cancelled-1` shows cancelled state |
| Access restriction | Alex (non-participant) denied access to David's session |

### 18. Earnings (`e2e/earnings.spec.ts` — 5 tests)

Teaching and creator earnings from D1-aggregated payment data.

| Test | What It Verifies |
|------|-----------------|
| Teaching earnings heading | Sarah → `/teaching/earnings` loads |
| Teaching earnings summary | Balance/earnings/payout text visible |
| Creator earnings heading | Guy → `/creating/earnings` loads |
| Creator earnings summary | Royalty/earnings content visible |
| Creator payout history | Payout/history/completed text visible |

### 19. Admin Webhook State (`e2e/admin-webhookstate.spec.ts` — 5 tests)

Admin pages displaying data from webhook end-states. Login as Brian.

| Test | What It Verifies |
|------|-----------------|
| Payout table with data | Recipient names visible |
| Pending payout | Marcus's pending payout indicator |
| Completed payout | Guy/Sarah's completed payout indicator |
| Certificate table | Certificate data renders |
| Certificate types | Certificate holder names visible |

### 20. Community Feed (`e2e/community-feed.spec.ts` — 3 tests)

Community feed tab with Playwright route interception for Stream.io.

| Test | What It Verifies |
|------|-----------------|
| Mocked activities | Feed posts render with author names |
| Reaction counts | Numeric counts visible on posts |
| Empty feed | Page doesn't crash with empty response |

### 21. Course Feed (`e2e/course-feed.spec.ts` — 3 tests)

Course feed tab with mocked Stream.io data.

| Test | What It Verifies |
|------|-----------------|
| Mocked posts | Discussion posts render |
| Empty feed | Course context still visible with empty feed |
| Tab layout | Course navigation tabs present alongside feed |

### 22. Home Feed (`e2e/home-feed.spec.ts` — 3 tests)

Home timeline feed with mocked data.

| Test | What It Verifies |
|------|-----------------|
| Mocked timeline | Feed activities render with author names |
| Empty feed | "Home Feed" heading still visible |
| Page structure | Heading + subtitle text present |

---

## Shared Login Helper

**File:** `e2e/helpers.ts`

New tests use the shared `login()` helper instead of inlining login logic:

```typescript
import { login } from './helpers';

test.beforeEach(async ({ page }) => {
  await login(page, 'david.r@example.com');
});
```

The existing 4 original tests are NOT refactored — they keep their inline login to avoid churn.

### Feed API Mocking

**File:** `e2e/helpers.ts` — `mockFeedApi()` function
**Fixtures:** `e2e/fixtures/mock-feed-data.ts`

Feed tests use Playwright route interception to mock Stream.io API responses:

```typescript
import { mockFeedApi } from './helpers';
import { mockFeedResponse } from './fixtures/mock-feed-data';

// MUST register mock BEFORE page.goto()
await mockFeedApi(page, mockFeedResponse);
await page.goto('/community/automation-majors');
```

Mock data uses the **enriched format** matching what Peerloop API endpoints return:
- `activities` array (not Stream's raw `results`)
- `actor` as string `"user:ID"` (not nested object)
- `userName` and `text` fields (what `FeedActivityCard` renders)

---

## Writing New E2E Tests

### Login Pattern

The login flow uses a modal (not a dedicated page). The modal auto-opens on `/login` via two coordinated Astro islands. Use the shared helper:

```typescript
import { login } from './helpers';

// In beforeEach or individual test:
await login(page, 'user@example.com');
```

Or inline (legacy pattern):
```typescript
await page.goto('/login');
const emailInput = page.getByLabel('Email address');
await expect(emailInput).toBeVisible({ timeout: 15000 });
await emailInput.fill('user@example.com');
await page.getByLabel('Password').fill('Password1');
await page.getByRole('button', { name: 'Sign in' }).click();
await expect(emailInput).not.toBeVisible({ timeout: 15000 });
```

**Why 15s timeout:** The login modal requires two Astro islands to hydrate:
1. `AppNavbar` (renders `AuthModalRenderer`)
2. `AutoOpenAuthModal` (calls `openLoginModal()`)

Both must hydrate and synchronize via `window.__peerloop` global state before the modal appears.

### Selector Patterns

Peerloop uses a sidebar layout (`<aside>`) not a top nav (`<nav>`). This affects how you target navigation elements.

**Do:**
```typescript
// Target sidebar elements
page.locator('aside').getByRole('link', { name: 'Peerloop' })
page.locator('aside').getByText('Discover')

// Use heading role for page titles (avoids breadcrumb/card duplicates)
page.getByRole('heading', { name: 'AI Tools Overview' })

// Use exact match when text appears in multiple elements
page.getByRole('heading', { name: 'Courses', exact: true })

// Use .first() when multiple matches are acceptable
page.getByText('Intro to Claude Code').first()

// Use href for link disambiguation
page.locator('a[href="/discover/courses"]').filter({ hasText: 'Courses' })
```

**Don't:**
```typescript
// These will fail — sidebar uses <aside>, not top-level <nav>
page.getByRole('navigation').getByRole('link', { name: 'Peerloop' })

// These will fail — strict mode rejects multiple matches
page.getByText('AI Tools Overview')  // matches breadcrumb + heading + price card
page.getByRole('heading', { name: 'Courses', level: 1 })  // matches page h1 + component h1
```

### Waiting for Data

Pages use `client:load` islands that fetch data after hydration. Always use timeouts for data-dependent assertions:

| Timeout | Use Case | Examples |
|---------|----------|----------|
| **15s** | Initial page load (hydration + API fetch) | First assertion after `page.goto()` |
| **10s** | Secondary data load (tab switch, navigation) | Click tab → wait for new content |
| **5s** | Interaction responses (button click, form submit) | Filter results, modal open |

```typescript
// BAD: no timeout, fails if data hasn't loaded
await expect(page.getByText('Intro to n8n')).toBeVisible();

// GOOD: waits up to 15s for React hydration + API fetch
await expect(page.getByText('Intro to n8n')).toBeVisible({ timeout: 15000 });
```

### Admin Tests

Use `beforeEach` for repeated login:

```typescript
test.describe('Admin Feature', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
    const emailInput = page.getByLabel('Email address');
    await expect(emailInput).toBeVisible({ timeout: 15000 });
    await emailInput.fill('brian@peerloop.com');
    await page.getByLabel('Password').fill('Password1');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(emailInput).not.toBeVisible({ timeout: 15000 });
  });

  test('admin test here', async ({ page }) => {
    await page.goto('/admin/...');
    // ...
  });
});
```

---

## Known Gotchas

### 1. `window.__peerloop` Race Condition (Fixed)

`auth-modal.ts` can initialize `window.__peerloop = {}` before `current-user.ts`, leaving `networkState` undefined. Fixed in Session 298 by adding a defensive check in `ensureGlobal()`. If login modal silently fails to render, check console for `Cannot read properties of undefined (reading 'authError')`.

### 2. Strict Mode Violations

Playwright's strict mode (default) fails if a locator resolves to multiple elements. This is common with:
- Course titles (appear in breadcrumbs, headings, and price cards)
- Headings like "Courses" (page h1 + component h1)
- Navigation links (sidebar + slide panels + page content)

Fix with more specific selectors (see Selector Patterns above). Common cases:
- "Teachers" h1 — use `{ exact: true }`
- Sidebar "Create account" vs modal "Create account" — scope to `page.getByRole('dialog')`
- Duplicate h1 from Astro template + React island — use `.first()` or scope to `main`
- Discovery pages with sidebar panel headings — scope to `page.locator('main')`

### 3. Layout Changes Break Tests

E2E tests are tightly coupled to page structure. The homepage tests broke when the layout changed from top-nav to sidebar. Run E2E tests after any layout or navigation changes.

### 4. Hydration Timing

Some components take several seconds to hydrate, especially:
- `AppNavbar` (fetches `/api/me/full`, renders auth state)
- `StudentDashboard` (fetches enrollments, sessions)
- `CourseBrowse` (renders from SSR props, but filters are client-side)

Use 15s timeouts for initial page loads. Use 5s for subsequent interactions.

### 5. External Services

E2E tests cannot interact with:
- **Stripe Checkout** — redirects to external Stripe page
- **OAuth providers** — require real Google/GitHub accounts
- **BBB video** — requires running BigBlueButton server (but webhooks CAN be tested — see below)
- **Stream.io** — feed operations need API credentials

Test up to the redirect point, then verify the success/callback pages separately.

**BBB webhook testing:** The `/api/webhooks/bbb` endpoint is unauthenticated (BBB calls it directly). You can fire synthetic webhook payloads from tests using Playwright's `request` fixture. The endpoint requires `BBB_URL` and `BBB_SECRET` in `.dev.vars` (even for webhook parsing), but these can be placeholder values — no actual BBB server is called during webhook processing.

### 6. React Hydration Under Parallel Load

**Critical for `client:load` islands with interactive elements.** Astro SSR-renders the component HTML before React hydrates the JavaScript click handlers. Under parallel load (5+ workers), hydration can be delayed — buttons are _visible_ but not _interactive_.

**Symptom:** Test sees the button text, clicks it, but nothing happens (step doesn't advance). Passes with `--workers=1` but fails in parallel.

**Fix:** Add `waitForLoadState('networkidle')` after `page.goto()` for pages where you'll interact with React island buttons:

```typescript
await page.goto('/course/intro-to-n8n/book');
await page.waitForLoadState('networkidle'); // Ensures React island has hydrated
```

This is different from the 15s timeout pattern (Gotcha #4) — timeouts wait for _text to appear_, but `networkidle` ensures _JavaScript has finished executing_ so click handlers are attached.

### 7. Cross-Test DB Contamination

E2E tests share a single database. Tests that **write data** (create sessions, complete sessions, submit forms) leave state that affects other tests. This can cause:
- Booking tests failing because all module slots are consumed
- Duplicate record conflicts (409 errors)
- State assertions failing because another test changed the data

**Mitigations:**
1. **Add headroom in seed data** — If a test books 1 of N slots, ensure N > 1 so other tests still have room. The n8n course has 6 modules with only 3 sessions seeded, leaving 3 bookable slots.
2. **Use unique identifiers** — Completion tests use `ses-david-n8n-3` (dedicated seed data), not shared sessions.
3. **Reset DB before full runs** — Run `npm run db:setup:local:dev` before `npm run test:e2e`. The DB is NOT automatically reset between tests.
4. **Don't use `--repeat-each`** for write tests — The second run will conflict with the first run's data.

### 8. Hidden `<option>` Elements in Filter Dropdowns

Pages with filter dropdowns (e.g., `/teaching/sessions`) render student/teacher names inside hidden `<option>` elements. `page.getByText('David Rodriguez').first()` resolves to the hidden option, not the visible session row.

**Fix:** Use API verification instead of page text matching for filtered data pages:

```typescript
// BAD: matches hidden <option> before visible session row
await expect(page.getByText('David Rodriguez').first()).toBeVisible();

// GOOD: verify via API
const res = await page.request.get('/api/sessions?role=teacher');
const data = await res.json();
expect(data.sessions.find(s => s.id === sessionId)).toBeTruthy();
```

---

## Debugging Failures

### View Trace

After a failed run:
```bash
npx playwright show-report
```
Click the failed test → view trace with screenshots, network requests, and console logs.

### Screenshot on Failure

Add to a test for debugging:
```typescript
await page.screenshot({ path: '/tmp/debug.png', fullPage: true });
```

### Console Errors

Capture JS errors during a test:
```typescript
const errors: string[] = [];
page.on('pageerror', err => errors.push(err.message));
// ... run test ...
console.log('Errors:', errors);
```

### Check Hydration

Verify React islands are hydrating:
```typescript
await page.goto('/login');
await page.waitForTimeout(5000);  // wait for hydration
const dialogCount = await page.getByRole('dialog').count();
console.log('Dialog count:', dialogCount);  // should be 1 for login
```

---

## Not Planned

| Flow | Reason |
|------|--------|
| Stripe Checkout (full) | External page — API tests cover checkout session + webhooks |
| OAuth Login | Requires real OAuth credentials |

---

## File Reference

| File | Tests | Purpose |
|------|:-----:|---------|
| `e2e/helpers.ts` | — | Shared `login()` + `mockFeedApi()` helpers |
| `e2e/fixtures/mock-feed-data.ts` | — | Mock Stream.io feed responses |
| `e2e/homepage.spec.ts` | 5 | Homepage + sidebar tests |
| `e2e/browse-enroll.spec.ts` | 5 | Course discovery + enrollment flow |
| `e2e/auth-dashboard.spec.ts` | 4 | Login + student dashboard |
| `e2e/admin-overview.spec.ts` | 5 | Admin login + navigation |
| `e2e/profiles.spec.ts` | 5 | Creator/teacher/universal profiles |
| `e2e/course-detail.spec.ts` | 5 | Course page tabs + enrollment CTA |
| `e2e/creator-dashboard.spec.ts` | 5 | Creator dashboard + sub-pages |
| `e2e/teaching-dashboard.spec.ts` | 5 | Teaching dashboard + sub-pages |
| `e2e/course-learning.spec.ts` | 4 | Learning page, modules, progress |
| `e2e/discovery.spec.ts` | 4 | Discovery hub + browse pages |
| `e2e/settings.spec.ts` | 5 | Settings hub + sub-pages |
| `e2e/notifications.spec.ts` | 9 | Notification list, filters, mark read, delete |
| `e2e/admin-crud.spec.ts` | 6 | Admin data tables + search |
| `e2e/signup-flow.spec.ts` | 4 | Signup form rendering + modal |
| `e2e/session-booking.spec.ts` | 3 | Booking page + teacher selection |
| `e2e/session-booking-flow.spec.ts` | 1 | Full booking wizard + dual-perspective |
| `e2e/session-completion-flow.spec.ts` | 1 | BBB webhook completion + dual-perspective |
| `e2e/community-pages.spec.ts` | 3 | Community page + members tab |
| `e2e/creator-application.spec.ts` | 3 | Creator application form |
| `e2e/session-completed.spec.ts` | 4 | Session states + access control |
| `e2e/earnings.spec.ts` | 5 | Teaching + creator earnings |
| `e2e/admin-webhookstate.spec.ts` | 5 | Admin payouts + certificates |
| `e2e/community-feed.spec.ts` | 3 | Community feed (mocked) |
| `e2e/course-feed.spec.ts` | 3 | Course feed (mocked) |
| `e2e/home-feed.spec.ts` | 3 | Home timeline (mocked) |
| `playwright.config.ts` | — | Playwright configuration |
| `migrations-dev/0001_seed_dev.sql` | — | Test user credentials and seed data |
| **Total** | **105** | |

---

*See also: [TEST-COVERAGE.md](TEST-COVERAGE.md) for full test inventory, [CLI-TESTING.md](CLI-TESTING.md) for test commands.*
