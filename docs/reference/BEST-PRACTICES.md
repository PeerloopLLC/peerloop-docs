# BEST-PRACTICES.md

This document contains proven patterns, conventions, and best practices for the Peerloop project. Follow these guidelines to maintain consistency and avoid known pitfalls.

**Last Updated:** 2026-03-12

---

## Table of Contents

1. [Astro Framework](#1-astro-framework)
2. [React Components](#2-react-components)
3. [Tailwind CSS](#3-tailwind-css)
4. [TypeScript](#4-typescript)
5. [Database (D1)](#5-database-d1)
6. [API Development](#6-api-development)
7. [Authentication](#7-authentication)
8. [Testing](#8-testing)
9. [File Organization](#9-file-organization)
10. [Documentation](#10-documentation)
11. [Git & Deployment](#11-git--deployment)
12. [External Services & Webhooks](#12-external-services--webhooks)

---

## 1. Astro Framework

### Data Fetching Pattern

Fetch data in Astro frontmatter, pass to React components as props:

```astro
---
// src/pages/courses/index.astro
const response = await fetch(`${Astro.url.origin}/api/courses`);
const { courses } = await response.json();
---

<CourseBrowse client:load courses={courses} />
```

**Why:** Better SEO, faster initial load, simpler components.

### Layout Selection

| Layout | Use For | Features |
|--------|---------|----------|
| `LandingLayout` | Public/marketing pages | Optional sidepanel, PublicHeader/Footer |
| `AppLayout` | Authenticated user pages | Sidebar nav, breadcrumbs |
| `AdminLayout` | Admin area | Dark sidebar, SPA pattern |

### Sidepanel Pattern

```astro
---
import LandingLayout from '../layouts/LandingLayout.astro';
---

<LandingLayout showSidepanel={true}>
  <main>Page content</main>
  <Fragment slot="sidepanel">
    <nav>Sidepanel navigation</nav>
  </Fragment>
</LandingLayout>
```

### Client Directives

- Use `client:load` for interactive components that need immediate hydration
- Use `client:visible` for below-fold interactive components
- Avoid `client:*` for components that don't need JavaScript

### Images

**Do NOT use** Astro's `<Image>` component or `getImage()`. The image service is set to `no-op`.

Use plain `<img>` tags with R2 URLs or external URLs:

```tsx
// With fallback
<img
  src={avatar_url || `https://placehold.co/100x100/0ea5e9/white?text=${name.charAt(0)}`}
  alt={name}
  className="h-6 w-6 rounded-full object-cover"
/>
```

- **Storage:** Cloudflare R2 (uploaded via `/api/me/courses/[id]/thumbnail`)
- **Optimization:** None for MVP. Cloudinary or CF Image Resizing deferred to post-MVP.
- **Tech doc:** `docs/architecture/image-handling.md`

---

## 2. React Components

### Component Architecture

```tsx
// Props interface first
interface CourseCardProps {
  course: CourseListItem;
  showCreator?: boolean;
}

// Destructure props with defaults
export function CourseCard({ course, showCreator = true }: CourseCardProps) {
  // Component logic
}
```

### Image Fallback Pattern

```tsx
{thumbnail_url ? (
  <img src={thumbnail_url} alt={title} className="w-full h-48 object-cover" />
) : (
  <div className="w-full h-48 bg-primary-200 flex items-center justify-center">
    <span className="text-2xl font-semibold text-primary-700">{title}</span>
  </div>
)}
```

### Admin Component Library

Use shared admin components from `src/components/admin/`:

| Component | Purpose |
|-----------|---------|
| `AdminDataTable` | Sortable, paginated table |
| `AdminFilterBar` | Search + filter controls |
| `AdminPagination` | Page navigation |
| `AdminDetailPanel` | Slide-in detail/edit panel |
| `AdminActionMenu` | Row actions dropdown |

### State Management

- Use `useState` for local component state
- Use `useMemo` for expensive calculations (filtering, sorting)
- Use debounced search inputs for performance

```tsx
const [search, setSearch] = useState('');
const debouncedSearch = useDebounce(search, 300);

const filtered = useMemo(() =>
  items.filter(item => item.name.toLowerCase().includes(debouncedSearch.toLowerCase())),
  [items, debouncedSearch]
);
```

### CurrentUser Global (Read-Only Cache)

`getCurrentUser()` returns a cached snapshot of the authenticated user's identity, capabilities, course relationships, and external service keys. It is a **convenience cache for UI decisions, not a source of truth**. See `docs/architecture/state-management.md` for full architecture.

**Do:**
```tsx
// Imperative (one-time read)
const user = getCurrentUser();
if (user?.hasStripeConnected()) { /* show dashboard link */ }
if (user?.isCreatorFor(courseId)) { /* show edit button */ }

// Reactive hook (auto-updates on background refresh)
const user = useCurrentUser();
```

**Don't:**
- Send CurrentUser data to API endpoints as authoritative (endpoints derive identity from session)
- Assume CurrentUser is always in sync with the server (it uses stale-while-revalidate)
- Mutate CurrentUser directly (all properties are `readonly`)
- Fetch `/api/auth/session` in components on AppLayout pages — use `getCurrentUser()` instead (it's already initialized by AppNavbar)

**After mutations that affect user state** (e.g., returning from Stripe onboarding, admin granting capabilities), call `refreshCurrentUser()` to re-fetch from `/api/me/full`. Components using `useCurrentUser()` will auto-update via the listener system.

---

## 3. Tailwind CSS

### Version 4 Class Names

Tailwind v4 renamed several classes. Use the new names:

| Old (v3) | New (v4) |
|----------|----------|
| `shadow-sm` | `shadow-xs` |
| `backdrop-blur-sm` | `backdrop-blur-xs` |
| `flex-shrink-0` | `shrink-0` |
| `flex-grow-0` | `grow-0` |
| `focus:outline-none` | `focus:outline-hidden` |
| `bg-opacity-50` | `bg-black/50` (slash notation) |
| `bg-gradient-to-r` | `bg-linear-to-r` |

### Validation

Run the Tailwind v4 checker before committing:

```bash
npm run check:tailwind
```

### Configuration

Tailwind v4 uses CSS-based configuration:

```css
/* src/styles/global.css */
@import "tailwindcss";
@plugin "@tailwindcss/forms";
@plugin "@tailwindcss/typography";

@theme {
  --color-primary-500: #3b82f6;
}
```

---

## 4. TypeScript

### Strict Mode

TypeScript is configured in strict mode. Always:

- Define explicit types for function parameters
- Use interfaces for object shapes
- Handle nullable values explicitly

### Nullable Field Handling

```tsx
// Numbers in calculations
const rating = course.rating ?? 0;

// Strings in filters
const match = name?.toLowerCase() || '';

// Conditional rendering
{bio && <p>{bio}</p>}
```

### API Response Typing

```tsx
const response = await fetch('/api/courses');
const data = await response.json() as { courses: Course[] };
```

### Type Aliases for Migration

```tsx
// Allow gradual migration from Creator to User
export type Creator = User;
export const creators = users;
```

---

## 5. Database (D1)

### Migration Structure

```
migrations/
├── 0001_schema.sql    # Tables and indexes only
└── 0002_seed.sql      # Data only
```

### Idempotent Seed Data

```sql
-- Use INSERT OR IGNORE for idempotent migrations
INSERT OR IGNORE INTO categories (id, name, slug) VALUES
  ('cat-001', 'AI & Product Management', 'ai-product-management'),
  ('cat-002', 'Machine Learning', 'machine-learning');
```

### Soft Delete Pattern

```sql
-- Add soft delete fields
ALTER TABLE users ADD COLUMN deleted_at TEXT;
ALTER TABLE users ADD COLUMN suspended_at TEXT;
ALTER TABLE users ADD COLUMN suspended_reason TEXT;

-- Query excluding soft-deleted records
SELECT * FROM users WHERE deleted_at IS NULL;
```

### Machine-Specific Commands

```bash
# Both Mac Minis (local D1)
npm run db:migrate:local
npm run db:studio:local

# Remote D1 (staging/production)
npm run db:migrate:staging
npm run db:migrate:remote
```

### Database Reset (Full Wipe)

When you need to reset a database and re-apply migrations fresh (e.g., after schema consolidation):

```bash
# Local D1 - deletes SQLite files directly
npm run db:reset:local && npm run db:migrate:local

# Staging D1 - drops tables in FK dependency order
npm run db:reset:staging && npm run db:migrate:staging

# Production D1 - 5-second safety delay, then drops tables
npm run db:reset:remote && npm run db:migrate:remote
```

**Why:** D1 tracks migrations by filename. If you modify `0001_schema.sql`, wrangler won't re-apply it unless you reset the database first.

**How it works:**
- Local: Deletes `.wrangler/state/v3/d1/miniflare-D1DatabaseObject/*.sqlite*` files
- Remote: Parses `0001_schema.sql` to build FK dependency graph, drops tables in correct order (children before parents)

**Caveat:** D1 enforces `foreign_keys=ON` at platform level. `PRAGMA foreign_keys=OFF` doesn't work. Must drop in dependency order.

### D1 Access Pattern

```tsx
// src/lib/db/index.ts
export function getDB(locals: App.Locals): D1Database {
  if (!locals.runtime?.env?.DB) {
    throw new Error('D1 database not available');
  }
  return locals.runtime.env.DB;
}

// Usage in API route
export const GET: APIRoute = async ({ locals }) => {
  const db = getDB(locals);
  const users = await queryAll<User>(db, 'SELECT * FROM users');
  return new Response(JSON.stringify({ users }));
};
```

### Cloudflare KV

KV is available via the `SESSION` binding. Use it for **read-heavy, eventually consistent** data only.

| Use For | Don't Use For |
|---------|---------------|
| Feature flags | User permissions (use D1) |
| API response caching | Payment/enrollment state (use D1) |
| Rate limiting | Anything needing strong consistency |
| Short-lived tokens (with TTL) | Counters that must be exact |

**Critical caveat:** KV is **eventually consistent** — writes take up to 60 seconds to propagate globally. Never use KV as the source of truth for data that must be immediately consistent.

```tsx
// Access KV in an API endpoint
const kv = locals.runtime?.env?.SESSION as KVNamespace;
const value = await kv.get('my-key');
await kv.put('my-key', 'value', { expirationTtl: 3600 }); // auto-expires in 1h
```

**Tech doc:** `docs/vendors/cloudflare-kv.md`

---

## 6. API Development

### Endpoint Structure

```
src/pages/api/
├── auth/
│   ├── login.ts
│   ├── logout.ts
│   ├── register.ts
│   └── session.ts
├── admin/
│   └── users/
│       ├── index.ts         # GET list, POST create
│       ├── [id].ts          # GET detail, PATCH update, DELETE
│       └── [id]/suspend.ts  # POST suspend
├── courses/
│   ├── index.ts
│   └── [slug].ts
└── health/
    └── db.ts
```

### Response Patterns

```tsx
// Success with data
return new Response(JSON.stringify({ users, total }), {
  status: 200,
  headers: { 'Content-Type': 'application/json' }
});

// Error responses
return new Response(JSON.stringify({ error: 'Not found' }), { status: 404 });
return new Response(JSON.stringify({ error: 'Bad request' }), { status: 400 });
return new Response(JSON.stringify({ error: 'Database unavailable' }), { status: 503 });
```

### Pagination Pattern

```tsx
import { parsePagination, createPaginatedResult, paginationOffset } from '@lib/db';

export const GET: APIRoute = async ({ request, locals }) => {
  const url = new URL(request.url);
  const { page, limit } = parsePagination(url.searchParams);
  const offset = paginationOffset(page, limit);

  const db = getDB(locals);
  const items = await queryAll<Item>(db,
    'SELECT * FROM items LIMIT ? OFFSET ?',
    [limit, offset]
  );
  const [{ total }] = await queryAll<{ total: number }>(db,
    'SELECT COUNT(*) as total FROM items'
  );

  return new Response(JSON.stringify(
    createPaginatedResult(items, total, page, limit)
  ));
};
```

### No Mock Fallback

APIs should fail explicitly when D1 is unavailable:

```tsx
// GOOD: Fail fast
if (!locals.runtime?.env?.DB) {
  return new Response(JSON.stringify({ error: 'Database unavailable' }), {
    status: 503
  });
}

// BAD: Silent fallback hides problems
if (!locals.runtime?.env?.DB) {
  return new Response(JSON.stringify({ users: mockUsers }));
}
```

---

## 7. Authentication

### Auth API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/auth/register` | POST | Create user + set cookies |
| `/api/auth/login` | POST | Verify password + set cookies |
| `/api/auth/logout` | POST | Clear cookies |
| `/api/auth/session` | GET | Return current user from cookie |
| `/api/auth/google` | GET | OAuth redirect |
| `/api/auth/google/callback` | GET | OAuth callback |

### Role Checking

```tsx
import { requireRole } from '@lib/auth/session';

export const GET: APIRoute = async ({ cookies, locals }) => {
  const jwtSecret = locals.runtime?.env?.JWT_SECRET;

  // Returns user or throws redirect
  const user = await requireRole(cookies, jwtSecret, ['admin']);

  // Proceed with admin-only logic
};
```

### JWT vs Astro Sessions

**Decision:** Use custom JWT auth (stateless). Astro Sessions (server-side KV) evaluated and deferred.

| Aspect | Our Approach (JWT) | Alternative (Astro Sessions) |
|--------|-------------------|------------------------------|
| Lookup | None — signature verify only | KV read every request |
| Revocation | Wait for TTL (≤15 min) | Immediate (delete KV entry) |
| Infrastructure | None | Cloudflare KV namespace |
| Portability | Framework-agnostic | Astro-specific |

**Stale-role gap:** JWT claims can be stale for up to 15 minutes after admin changes. Mitigated by:
- Short access token TTL (15 min)
- Critical endpoints (admin, payments) re-query D1 for fresh user data

**Tech doc:** `docs/architecture/auth-sessions.md`

### Dev Login (Development Only)

```tsx
import { getDevAccounts, DEV_PASSWORD } from '@lib/mock-data';

// All dev accounts use password: 'dev123'
const accounts = getDevAccounts();
// Returns: [{ email, name, roles }, ...]
```

---

## 8. Testing

### Unit Tests (Vitest)

```tsx
// Component test
import { render, screen } from '@testing-library/react';
import { CourseCard } from './CourseCard';

describe('CourseCard', () => {
  it('renders course title', () => {
    render(<CourseCard course={mockCourse} />);
    expect(screen.getByText(mockCourse.title)).toBeInTheDocument();
  });
});
```

### Test File Hygiene

**Import cleanup:** After writing a test file, do a quick pass to remove unused imports and variables before moving on. It's fine to draft with a full "starter kit" of imports (`describe`, `afterAll`, `waitFor`, `within`, etc.) for speed, but leaving unused ones creates persistent TypeScript/Astro hints that accumulate and obscure real issues.

Common culprits:
- `afterAll`, `beforeAll` imported but only `beforeEach`/`afterEach` used
- `within` from Testing Library imported but only `screen` used
- `const { container } = render(...)` when only `screen` queries are used
- `closeTestDB` imported but the test uses `describeWithTestDB` (which handles cleanup)

**Fixture completeness:** When creating mock data fixtures, check the source interface for all required fields. Missing fields (e.g., omitting `title` from a `Creator` fixture) cause TypeScript errors that are easy to miss until the next `npm run typecheck`.

---

### E2E Tests (Playwright)

```tsx
// Scope selectors to avoid ambiguity
test('homepage loads', async ({ page }) => {
  await page.goto('/');

  // GOOD: Scoped selector
  await expect(page.locator('header').getByRole('link', { name: 'Courses' }))
    .toBeVisible();

  // BAD: Ambiguous selector
  await expect(page.getByText('Courses')).toBeVisible();
});
```

### CI Pipeline

```yaml
# .github/workflows/ci.yml
- name: Setup D1 for E2E
  run: npm run db:migrate:local

- name: Run E2E tests
  run: npm run test:e2e
```

### Multi-User Manual Testing

To test interactions between two users simultaneously (e.g., student enrolls → teacher sees booking, both join BBB session), use **two different browser vendors** — one user in Chrome, another in Safari.

Each browser has fully independent cookies and localStorage, so both sessions are real and isolated. No special code or dev-mode flags needed.

| Browser | Logged In As | Example Use |
|---------|-------------|-------------|
| Chrome | AlexChen (student) | Enroll, book session, join BBB |
| Safari | Sarah Miles (teacher) | View booking, join same BBB session |

**Why not tabs in the same browser?** Auth uses HTTP-only cookies shared across all tabs — logging in as a second user in a new tab would overwrite the first session.

**Why not code-level tab isolation?** Evaluated and rejected (Session 380). Would add dev-only infrastructure to the production codebase with no user-facing benefit.

### Timezone Safety in Tests (Conv 003)

**Problem:** Tests that use `setHours()`, `new Date(year, month, day)`, or `getDate()` silently depend on the machine's local timezone. They pass on your dev machine (e.g., US Eastern) but fail on CI (GitHub Actions runs in UTC) because date boundaries shift.

**Rules:**

1. **Use UTC explicitly.** Replace `setHours()` with `setUTCHours()`, `getDate()` with `getUTCDate()`, etc.
2. **Avoid the multi-arg Date constructor.** `new Date(2026, 2, 15)` interprets as local time. Use `new Date(Date.UTC(2026, 2, 15))` or the `utcDate()` helper.
3. **Avoid boundary values.** If a guard triggers at 24h, seed test data at +2 days, not +1 day. Milliseconds of execution time can cross boundaries.
4. **Use `getNow()` from `@lib/clock` in production code** for time-sensitive decisions (join windows, late-cancel checks, expiry). Tests can mock it to freeze time.

**Test helpers** (import from `@test-helpers`):

| Helper | Purpose | Example |
|--------|---------|---------|
| `utcDate(y, m, d, h?, min?)` | Explicit UTC date (1-based month) | `utcDate(2026, 3, 20, 15)` |
| `futureUTC(days, utcHour?)` | Future date relative to now | `futureUTC(2, 15)` |
| `pastUTC(days, utcHour?)` | Past date relative to now | `pastUTC(1)` |
| `nextDayOfWeekUTC(dow, utcHour)` | Next occurrence of a weekday | `nextDayOfWeekUTC(1, 15)` (Mon 15:00 UTC) |
| `toDateStringUTC(date)` | Format as YYYY-MM-DD using UTC | `toDateStringUTC(d)` |

**CI lint check:** `npm run lint:tz` flags `setHours()`, `new Date(y,m,d)` in test files. Runs via `scripts/lint-timezone.sh`.

---

### Block Completion Checklist

Before marking a block complete:

```bash
npm run typecheck    # TypeScript validation
npm run lint         # ESLint
npm run build        # Production build
npm run test         # Unit tests
npm run test:e2e     # E2E tests (if applicable)
```

---

## 9. File Organization

### Directory Structure

```
src/
├── components/
│   ├── admin/           # Admin-specific components
│   ├── courses/         # Course-related components
│   ├── home/            # Homepage components
│   └── shared/          # Shared/common components
├── layouts/
│   ├── AdminLayout.astro
│   ├── AppLayout.astro
│   └── LandingLayout.astro
├── lib/
│   ├── auth/            # Authentication utilities
│   ├── db/              # Database utilities
│   └── mock-data.ts     # Development mock data
├── pages/
│   ├── api/             # API endpoints
│   ├── admin/           # Admin pages
│   ├── courses/         # Course pages
│   └── dashboard/       # User dashboard pages
└── styles/
    └── global.css       # Global styles + Tailwind

docs/
├── pagespecs/           # Page design specifications (MD)
│   ├── settings/        # /settings/* page specs
│   └── admin/           # /admin/* page specs
├── reference/           # CLI, API, testing docs
├── sessions/            # Development session logs
└── tech/                # Technology decision docs
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `CourseCard.tsx` |
| Pages | kebab-case | `how-it-works.astro` |
| Utilities | camelCase | `parseDate.ts` |
| Types | PascalCase | `CourseListItem` |
| API routes | kebab-case | `teachers/` |

---

## 10. Documentation

### Tech Docs Location

Technology decisions go in `docs/vendors/` and `docs/architecture/`:

- Include: why chosen, alternatives considered, integration patterns, caveats
- Reference from code with comments linking to docs

### Page Spec Pattern

**DELETED** (Sessions 307+311) — Page specifications are in git history. Page design is now defined by the implemented Astro pages themselves. Route information is in `docs/architecture/url-routing.md` and `docs/architecture/route-stories.md`.

### Session Documentation

Use `/q-end-session` to create:
- Learnings (best practices discovered)
- Decisions (choices made with rationale)
- Dev log (what was accomplished)
- Prompts (notable prompts used)

---

## 11. Git & Deployment

### Branch Strategy

- `main` - Production branch, auto-deploys to CF Pages
- `jfg-dev-*` - Development branches for features

### Commit Messages

```
<type>: <description>

- Detail 1
- Detail 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

### Pre-Commit Checklist

```bash
npm run typecheck
npm run lint
npm run check:tailwind
npm run build
npm run test
```

### Environment Detection

```tsx
// src/lib/version.ts
export const environment =
  import.meta.env.DEV ? 'DEV' :
  import.meta.env.CF_PAGES_BRANCH !== 'main' ? 'STG' : 'PROD';
```

### Cloudflare Pages Notes

- "Retry deployment" re-deploys same commit
- To deploy new code, push a new commit (even empty works)
- Preview branches: `https://<branch>.peerloop.pages.dev`
- Production: `https://peerloop.pages.dev`

---

## Quick Reference

### Common Commands

```bash
# Development
npm run dev              # Start dev server
npm run build            # Production build
npm run preview          # Preview build

# Database
npm run db:migrate:local # Apply migrations locally
npm run db:studio:local  # Open D1 Studio

# Testing
npm run test             # Unit tests
npm run test:e2e         # E2E tests
npm run typecheck        # TypeScript check
npm run lint             # ESLint

# Validation
npm run check:tailwind   # Tailwind v4 class check
```

### Environment Variables

Required in `.dev.vars`:

```env
JWT_SECRET=your-secret-key
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
GITHUB_CLIENT_ID=...
GITHUB_CLIENT_SECRET=...
```

---

## 12. External Services & Webhooks

### One Webhook Endpoint Per Provider

Each external service (Stripe, BBB) gets a **single webhook endpoint** that handles all event types. Internal routing via `switch(event.type)`:

```
Stripe Cloud → POST /api/webhooks/stripe → switch(event.type) → handler functions
BBB Server   → POST /api/webhooks/bbb    → switch(event.type) → handler functions
```

**Why one endpoint?** Simpler to manage — one URL to register, one secret to configure, one handler to test. Stripe allows multiple endpoints, but a single one keeps the architecture straightforward.

**Always return 200** for webhook endpoints, even for events you don't handle. Otherwise the provider retries for up to 72 hours.

### Webhook Idempotency

External providers retry failed webhooks. All handlers must be safe to execute multiple times:

**Database writes — check before INSERT:**
```typescript
const existing = await queryFirst(db, `SELECT id FROM enrollments WHERE id = ?`, [id]);
if (existing) return; // Already processed, skip
```

**Stripe transfers — use idempotency keys:**
```typescript
stripe.transfers.create({ amount, destination, ... }, {
  idempotencyKey: `transfer_${transferGroup}_${recipientType}_${recipientId}`,
});
```

Without idempotency keys, a webhook retry can create **duplicate payouts** — real money sent twice.

### Webhook Signature Verification

Always verify signatures **before** any processing. This prevents spoofed events:

```typescript
const signature = request.headers.get('stripe-signature');
if (!signature) return Response.json({ error: 'Missing signature' }, { status: 400 });

const event = stripe.webhooks.constructEvent(payload, signature, webhookSecret);
```

### Self-Healing Status Endpoints

When an API endpoint fetches live data from an external service, it should **sync the database** if the external state has drifted from the stored value. This eliminates hard dependencies on webhooks for status accuracy.

```typescript
// Fetch live state from provider
const account = await stripe.accounts.retrieve(user.stripe_account_id);

// Derive correct status from live data
let derivedStatus = 'pending';
if (account.charges_enabled && account.payouts_enabled) derivedStatus = 'active';

// Sync DB if drifted (webhook may have been missed)
if (derivedStatus !== user.stripe_account_status) {
  await db.prepare(`UPDATE users SET stripe_account_status = ? WHERE id = ?`)
    .bind(derivedStatus, user.id).run();
}

// Return derived status, not stale DB value
return Response.json({ status: derivedStatus });
```

**When to use:** Any status endpoint that reads from an external provider (Stripe account status, BBB meeting status). The webhook provides real-time updates; the self-healing endpoint provides correctness on next page load.

**See:** `src/pages/api/stripe/connect-status.ts`

### Local Webhook Testing with Stripe CLI

Stripe webhooks can't reach `localhost` directly. The Stripe CLI bridges this gap:

```bash
# Terminal 1: Dev server
npm run dev

# Terminal 2: Webhook forwarding
npm run stripe:listen
# (alias for: stripe listen --forward-to localhost:4321/api/webhooks/stripe)
```

**How it works:** The CLI maintains a WebSocket to Stripe Cloud, receives events in real-time, and re-POSTs them to your local server. The signing secret must match `STRIPE_WEBHOOK_SECRET` in `.dev.vars`.

**The secret is stable** across sessions on the same machine — it only changes if you re-authenticate (`stripe login`).

### Per-Environment Webhook Configuration

| Environment | How Webhooks Arrive | Configuration |
|-------------|--------------------|--------------|
| **Local dev** | Stripe CLI forwards via WebSocket | `npm run stripe:listen` in separate terminal |
| **Preview/staging** | Not configured (dynamic URLs) | Payments tested locally only |
| **Production** | Stripe POSTs directly to public URL | Register endpoint in Stripe Dashboard at go-live |

**Why no Preview webhooks?** Cloudflare Pages generates a different URL per deployment (`https://<hash>.peerloop.pages.dev`). Stripe requires a fixed URL. Full payment testing is done locally; Preview validates everything except webhooks.

### Test Mode vs Live Mode

Stripe uses **entirely separate key sets** per mode. The prefix tells you instantly:

| Prefix | Mode | Real Money? |
|--------|------|:-----------:|
| `pk_test_` / `sk_test_` | Test | No |
| `pk_live_` / `sk_live_` | Live | **Yes** |

Test-mode keys cannot create real charges. Live-mode keys are **intentionally withheld** from Cloudflare until go-live to prevent accidental real charges during development.

**Stripe Express onboarding in test mode** provides helper shortcuts (auto-fill test data, bypass SMS verification) that don't appear in live mode. Document these for internal testing but note they won't appear in production.

**See:** `docs/vendors/stripe.md`, `docs/guides/stripe-onboarding-guide.md`

---

## Changelog

- **2026-03-12:** Added Multi-User Manual Testing to §8 (Session 380)
- **2026-02-18:** Added Section 12: External Services & Webhooks (Session 223)
- **2025-01-05:** Initial consolidation from 25 learnings files
