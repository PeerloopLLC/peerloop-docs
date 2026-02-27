# E2E Testing Guide

End-to-end tests using Playwright that validate critical user flows against the running application.

**Last Updated:** 2026-02-27 (Session 298)

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
npm run db:setup:local
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

All test users come from `migrations-dev/0001_seed_dev.sql`. Password for all: **`dev123`**

| User | Email | ID | Role | Key Data |
|------|-------|----|------|----------|
| David Rodriguez | `david.r@example.com` | `usr-david-rodriguez` | Student | In-progress enrollment in "Intro to n8n" |
| Jennifer Kim | `jennifer.kim@example.com` | `usr-jennifer-kim` | Student | Completed enrollment in "Intro to Claude Code" |
| Brian | `brian@peerloop.com` | `usr-brian-admin` | Admin | Full admin access, `is_admin=1` |
| Alex Chen | `newuser@example.com` | `usr-new-user` | New user | No enrollments (clean slate) |
| Guy Rymberg | `guy-rymberg@example.com` | `usr-guy-rymberg` | Creator | 4 courses, Stripe Connect account |
| Sarah Miller | `sarah.miller@example.com` | `usr-sarah-miller` | Student-Teacher | Can teach, completed enrollment |

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

---

## Writing New E2E Tests

### Login Pattern

The login flow uses a modal (not a dedicated page). The modal auto-opens on `/login` via two coordinated Astro islands:

```typescript
// Navigate to login page
await page.goto('/login');

// Wait for modal to open (React hydration of two islands)
const emailInput = page.getByLabel('Email address');
await expect(emailInput).toBeVisible({ timeout: 15000 });

// Fill and submit
await emailInput.fill('user@example.com');
await page.getByLabel('Password').fill('dev123');
await page.getByRole('button', { name: 'Sign in' }).click();

// Wait for modal to close (login complete)
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
    await page.getByLabel('Password').fill('dev123');
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

Fix with more specific selectors (see Selector Patterns above).

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
- **BBB video** — requires running BigBlueButton server
- **Stream.io** — feed operations need API credentials

Test up to the redirect point, then verify the success/callback pages separately.

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

## Future E2E Tests

Potential additions when features warrant:

| Flow | Route | Blocked By |
|------|-------|------------|
| Creator Studio | `/creating` → manage courses | Needs creator test user with courses |
| S-T Booking | `/course/[slug]` → book session | Needs BBB or mock video provider |
| Community Feed | `/community/[slug]` → post → react | Needs Stream.io test credentials |
| Stripe Checkout (full) | Checkout → payment → webhook | Requires Stripe test mode interaction |
| OAuth Login | `/login` → Google/GitHub | Requires real OAuth credentials |

### TESTING.WEBHOOKS (Deferred)

Stripe webhook and BBB callback E2E tests are deferred until manual integration testing is complete. Current coverage:
- Stripe webhooks: 7 handlers tested via API tests (mock payloads)
- BBB callbacks: tested via API tests (mock webhook data)

---

## File Reference

| File | Purpose |
|------|---------|
| `playwright.config.ts` | Playwright configuration |
| `e2e/homepage.spec.ts` | Homepage + sidebar tests |
| `e2e/browse-enroll.spec.ts` | Course discovery + enrollment flow |
| `e2e/auth-dashboard.spec.ts` | Login + student dashboard |
| `e2e/admin-overview.spec.ts` | Admin login + navigation |
| `migrations-dev/0001_seed_dev.sql` | Test user credentials and seed data |

---

*See also: [TEST-COVERAGE.md](TEST-COVERAGE.md) for full test inventory, [CLI-TESTING.md](CLI-TESTING.md) for test commands.*
