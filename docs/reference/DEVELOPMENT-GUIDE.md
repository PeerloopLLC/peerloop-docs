# Development Guide

Development practices and patterns for the Peerloop project.

---

## Repository Architecture

Peerloop uses a **dual-repo** structure:

| Repo | Purpose | Contents |
|------|---------|----------|
| `peerloop-docs` | Claude Code home + Obsidian vault | `.claude/`, `CLAUDE.md`, `docs/`, `research/`, `RFC/`, planning files |
| `Peerloop` | Application code | `src/`, `tests/`, `scripts/`, `migrations/`, config files |

**Build-time bridge:** The code repo has symlinks (`docs/`, `research/`) pointing to the docs repo. Build scripts follow these transparently.

**Claude Code launch:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Setup:** Run `bash scripts/link-docs.sh` once per machine after cloning. See [CLI-MISC.md](CLI-MISC.md#dual-repo-setup) for details.

---

## Astro Patterns

### React Islands

Peerloop uses Astro with React islands for interactive components:

```astro
---
// Static Astro component
import InteractiveWidget from '@components/InteractiveWidget';
---

<div>
  <h1>Static Content</h1>
  <InteractiveWidget client:load />
</div>
```

**Client directives:**
- `client:load` - Hydrate immediately on page load
- `client:idle` - Hydrate when browser is idle
- `client:visible` - Hydrate when component enters viewport

### Page vs API Routes

| Location | Purpose |
|----------|---------|
| `src/pages/*.astro` | Server-rendered pages |
| `src/pages/api/**/*.ts` | REST API endpoints |

### URL-Aware Tabbed Pages

Some pages use a tabbed interface where each tab has its own bookmarkable URL. The pattern requires:

1. **One `.astro` page per tab** — each passes the same data but a different `initialTab` prop
2. **A React component** that manages tab state synced to the URL via `history.pushState`
3. **A `popstate` listener** to handle browser back/forward navigation

**Example:** Course pages use `CourseTabs` with 5 tabs:

```
/course/[slug]            → About tab    (default, server-rendered)
/course/[slug]/teachers   → Teachers tab (server-rendered data)
/course/[slug]/resources  → Resources tab (client-side fetch)
/course/[slug]/feed       → Feed tab     (server-rendered)
/course/[slug]/curriculum → Curriculum tab (enrolled only)
```

**Data strategy per tab:**
- **Server-side** (props from Astro page): When data is simple DB joins. Used by About, Teachers, Feed, Curriculum.
- **Client-side** (fetch from API): When the API encapsulates complex logic (enrollment gating, R2 URL generation). Used by Resources.

**See:** `src/components/courses/CourseTabs.tsx`, `src/pages/course/[slug]/*.astro`

### Breadcrumbs and Navigation Context

Use the reusable `Breadcrumbs.astro` component for page-level navigation trails. Each page renders its own breadcrumbs inside the content area (above the `<h1>`).

```astro
import Breadcrumbs from "@components/ui/Breadcrumbs.astro";

<Breadcrumbs items={[
  { label: 'Teaching', href: '/teaching' },
  { label: 'My Students' },
]} />
```

**Context-aware breadcrumbs with `?via=`:** When a page can be reached from multiple sources, use `?via=` query params to provide navigation context. The receiving page reads `via` and builds its breadcrumb trail conditionally.

```astro
// Linking page adds ?via= to outbound links
href={`/community/${slug}?via=discover-communities`}

// Receiving page reads via and builds items
const via = Astro.url.searchParams.get('via');
const breadcrumbItems = via === 'discover-communities'
  ? [{ label: 'Discover', href: '/discover' }, { label: 'Communities', href: '/discover/communities' }, { label: name }]
  : [{ label: 'My Communities', href: '/community' }, { label: name }];
```

**Known `via` values:** `discover-communities`, `discover-courses`, `community-courses` (with `cs` and `cn` params for community slug and name).

**See:** `src/components/ui/Breadcrumbs.astro`, `DECISIONS.md` §5 "Breadcrumb System"

### Stretched-Link Pattern for Clickable Cards

When a card component needs the whole surface clickable (primary link) with a secondary link inside (e.g., creator profile), use the stretched-link pattern. **Never nest `<a>` inside `<a>`** — it's invalid HTML and causes React hydration errors.

```tsx
// Outer element is a <div> with position: relative
<div className="group relative ...">
  {/* Primary link — ::after stretches over entire card */}
  <h3>
    <a href="/course/slug" className="after:absolute after:inset-0">
      Course Title
    </a>
  </h3>

  {/* Secondary link — sits above the overlay */}
  <a href="/creator/handle" className="relative z-10">
    Creator Name
  </a>
</div>
```

**Key points:**
- `after:absolute after:inset-0` on the primary `<a>` creates a pseudo-element covering the card
- `relative z-10` on secondary links lifts them above the overlay
- Interactive elements inside (buttons, etc.) also need `relative z-10` and `e.preventDefault()`
- Both links get full native behavior: right-click, middle-click, status bar preview, View Transitions

**See:** `src/components/courses/CourseCard.tsx`, `src/components/notifications/NotificationsList.tsx`, `DECISIONS.md` §5 "Stretched-Link Pattern"

### Navigation Methods

Three methods for navigation, each for a specific context:

| Method | When to Use | Example |
|--------|------------|---------|
| `<a href>` | All navigable UI elements | Links, menu items, clickable cards |
| `navigate()` | Programmatic internal navigation after API calls | Post-booking redirect, post-mutation page refresh |
| `window.location.href` | Auth boundary crossings and external URLs | Logout, Stripe checkout, BBB video room |

```tsx
// navigate() — import from Astro's client-side transitions module
import { navigate } from 'astro:transitions/client';

// After a successful API call, navigate with View Transitions
navigate(`/session/${sessionId}`);

// Soft-refresh the current page after a mutation
navigate(window.location.pathname);
```

**Why `window.location.href` for auth boundaries:** After login/logout, a full page reload intentionally clears all cached React state. View Transitions would preserve stale user data in component trees.

**See:** `DECISIONS.md` §5 "Three-Tier Navigation Strategy"

**Testing `navigate()` in Vitest:** The `astro:transitions/client` virtual module is aliased to `tests/helpers/mock-astro-navigate.ts` in `vitest.config.ts`. Import and assert on the mock in tests:

```tsx
import { navigate } from 'astro:transitions/client';
// ...
expect(navigate).toHaveBeenCalledWith('/session/123');
```

### SSR Data Loaders

For SSR pages that fetch data, use pure loader functions in `src/lib/ssr/loaders/`:

```typescript
// src/lib/ssr/loaders/about.ts
import type { D1Database } from '@cloudflare/workers-types';
import { queryAll } from '@lib/db';
import { SSRDataError } from '../types';

export async function fetchAboutData(db: D1Database): Promise<AboutPageData> {
  try {
    const [team, stats] = await Promise.all([
      queryAll<TeamMember>(db, 'SELECT * FROM team_members WHERE is_active = 1'),
      queryAll<PlatformStat>(db, 'SELECT * FROM platform_stats'),
    ]);
    return { team, stats };
  } catch (error) {
    throw new SSRDataError('Failed to load about page', 'QUERY_FAILED', { cause: error });
  }
}
```

**Usage in .astro page:**
```astro
---
import { fetchAboutData, SSRDataError } from '@lib/ssr';
import ErrorPage from '@components/error/ErrorPage';

const db = Astro.locals.runtime?.env?.DB;
let data = null;
let error = null;

try {
  data = await fetchAboutData(db!);
} catch (e) {
  if (e instanceof SSRDataError) {
    error = e;
  } else {
    throw e;
  }
}
---

{error ? <ErrorPage error={error} /> : <AboutContent data={data} />}
```

**Benefits:**
- Pure functions are trivially testable with `better-sqlite3`
- `SSRDataError` provides typed error codes → HTTP status mapping
- Errors surface to users instead of silent empty content

### Icon System

Peerloop has a dual icon system — one for Astro templates (build-time), one for React islands (runtime):

| System | File | Usage | JS Overhead |
|--------|------|-------|-------------|
| **Astro** | `src/components/ui/Icon.astro` | `.astro` files | Zero (build-time SVG) |
| **React** | `src/components/ui/icons.tsx` | `.tsx` components | Bundled with component |
| **Brand** | `src/components/ui/brand-icons.tsx` | React brand logos | Bundled with component |

**Astro usage** (in `.astro` files):
```astro
---
import Icon from '@components/ui/Icon.astro';
---
<Icon name="profile" class="w-6 h-6 text-purple-600" />
<Icon name={dynamicVar} class="w-5 h-5" />
```

**React usage** (in `.tsx` files):
```tsx
import { ProfileIcon, CheckIcon } from '@components/ui/icons';
<ProfileIcon className="w-6 h-6 text-purple-600" />
```

**Path data registry:** `src/lib/icon-paths.ts` stores raw SVG path strings for the Astro system. Brand icons override fill/stroke defaults.

**Adding a new icon:**
1. Add path entry to `src/lib/icon-paths.ts` (for Astro)
2. Add JSX component to `src/components/ui/icons.tsx` (for React)
3. Both should use the same SVG path data

**No inline SVGs in `.astro` files** — always use `<Icon name="..." />`.

### Self-Healing API Endpoints

When an API endpoint fetches live data from an external service (Stripe, Stream, etc.), it should **sync the database** if the external state has drifted from the stored state. This eliminates hard dependencies on webhooks for status accuracy.

**Pattern:** Read-and-sync on fetch

```typescript
// GET /api/stripe/connect-status
const account = await stripe.accounts.retrieve(user.stripe_account_id);

// Derive correct status from live data
let derivedStatus = 'pending';
if (account.charges_enabled && account.payouts_enabled) {
  derivedStatus = 'active';
} else if (account.requirements?.disabled_reason) {
  derivedStatus = 'restricted';
}

// Sync database if status has drifted
if (derivedStatus !== user.stripe_account_status) {
  await db.prepare(`UPDATE users SET stripe_account_status = ? WHERE id = ?`)
    .bind(derivedStatus, user.id).run();
}

// Return the derived (correct) status, not the DB value
return Response.json({ status: derivedStatus });
```

**When to use:** Any status endpoint that queries an external provider where webhooks might be delayed or missed (Stripe account status, BBB meeting status, etc.)

**See:** `src/pages/api/stripe/connect-status.ts` (implemented Session 223)

### Webhook Best Practices

**Single endpoint per provider.** One webhook URL handles all event types from a given provider. Internal routing via `switch(event.type)`:

```typescript
switch (event.type) {
  case 'checkout.session.completed':
    await handleCheckoutCompleted(db, stripe, session, locals);
    break;
  case 'charge.refunded':
    await handleChargeRefunded(db, stripe, charge, locals);
    break;
  // ...
}
```

**Idempotency is required.** Stripe retries failed webhooks for up to 72 hours. All handlers must be safe to execute multiple times:

- **Database writes:** Check for existing records before INSERT (`SELECT id FROM enrollments WHERE id = ?`)
- **Stripe transfers:** Use `idempotencyKey` parameter to prevent duplicate payouts:
  ```typescript
  stripe.transfers.create({ ... }, {
    idempotencyKey: `transfer_${transferGroup}_${recipientType}_${recipientId}`,
  });
  ```

**Always return 200.** Webhook endpoints must return 2xx even for events they don't process, otherwise the provider retries indefinitely. Log unhandled events for debugging.

**Signature verification first.** Verify webhook signatures before any processing to prevent spoofed events.

**See:** `src/pages/api/webhooks/stripe.ts`, `docs/tech/tech-003-stripe.md` (Webhooks section)

### Stripe CLI for Local Webhook Testing

Run the Stripe webhook listener alongside the dev server:

```bash
# Terminal 1
npm run dev

# Terminal 2
npm run stripe:listen
```

The webhook signing secret must match `STRIPE_WEBHOOK_SECRET` in `.dev.vars`. The secret is stable across sessions on the same machine.

**See:** `docs/tech/tech-003-stripe.md` (Per-Environment Webhook Configuration)

---

## Path Aliases

Path aliases avoid deep relative imports. Defined in `tsconfig.json` and `vitest.config.ts`.

### Application Aliases

| Alias | Resolves To | Example |
|-------|-------------|---------|
| `@/*` | `src/*` | `import { User } from '@/types'` |
| `@components/*` | `src/components/*` | `import Button from '@components/Button'` |
| `@layouts/*` | `src/layouts/*` | `import Layout from '@layouts/AppLayout'` |
| `@lib/*` | `src/lib/*` | `import { queryAll } from '@lib/db'` |
| `@services/*` | `src/services/*` | `import { sendEmail } from '@services/email'` |
| `@data/*` | `src/data/*` | `import config from '@data/config'` |
| `@emails/*` | `src/emails/*` | `import WelcomeEmail from '@emails/Welcome'` |

### Test Aliases

| Alias | Resolves To | Exports |
|-------|-------------|---------|
| `@test-helpers` | `tests/helpers` | `describeWithTestDB`, `getTestDB`, `resetTestDB`, `DB_TEST` |
| `@api-helpers` | `tests/api/helpers` | `createAPIContext`, `createMockRequest`, `uniqueEmail` |

**Example test file:**
```typescript
import { POST } from '@/pages/api/admin/users/[id]/suspend';
import { createAPIContext } from '@api-helpers';
import { describeWithTestDB, getTestDB } from '@test-helpers';
```

---

## Database Access (D1)

### Query Helpers

Located in `src/lib/db/index.ts`:

```typescript
import { queryAll, queryFirst, execute, batch } from '@lib/db';

// Read multiple rows
const users = await queryAll<User>(db, 'SELECT * FROM users WHERE is_creator = ?', [1]);

// Read single row
const user = await queryFirst<User>(db, 'SELECT * FROM users WHERE id = ?', [id]);

// Write operation
await execute(db, 'UPDATE users SET name = ? WHERE id = ?', [name, id]);

// Batch operations (atomic)
await batch(db, [
  { sql: 'INSERT INTO users ...', params: [...] },
  { sql: 'INSERT INTO profiles ...', params: [...] },
]);
```

### Getting the Database

In API routes:
```typescript
const db = locals.runtime?.env?.DB;
if (!db) {
  return Response.json({ error: 'Database not available' }, { status: 500 });
}
```

### ID Generation

Use `generateId()` for UUID primary keys:
```typescript
import { generateId } from '@lib/db';
const userId = generateId(); // Returns UUID v4
```

---

## Authentication

### JWT Session Flow

1. User registers/logs in via `/api/auth/*`
2. Server sets HttpOnly cookies: `auth_token` (JWT) + `session`
3. Subsequent requests: `getSession(cookies, jwtSecret)` validates
4. Logout clears cookies

### Auth Utilities

Located in `src/lib/auth/index.ts`:

```typescript
import {
  hashPassword,
  verifyPassword,
  setAuthCookies,
  clearAuthCookies,
  getSession,
  validateEmail,
  validatePassword,
  validateHandle,
} from '@lib/auth';
```

### Moderation Auth (Two-Tier)

Located in `src/lib/auth/moderation.ts`. Used by all 6 moderation endpoints (`/api/admin/moderation/*`).

```typescript
import {
  requireModerationAccess,
  isFlagInScope,
  canPerformElevatedAction,
  type ModerationScope,
  type ModerationAccess,
} from '@lib/auth';
```

**How it works:**
1. Check JWT roles (fast path) — admin or moderator → `{ type: 'global' }` scope
2. If no JWT role, query `community_moderators` table → `{ type: 'community', communityIds: [...] }` scope
3. If neither → throw 403

**Key pattern:** DB handle must be obtained *before* the auth call (the helper queries the database):

```typescript
// Correct order (DB before auth)
const db = getDB(locals);
const { session, scope } = await requireModerationAccess(cookies, jwtSecret, db);
```

**Scope helpers:**
- `isFlagInScope(scope, flagCommunityId)` — returns true for global scope; for community scope, checks if flag's `community_id` is in the moderator's list. Returns false for null `community_id` with community scope.
- `canPerformElevatedAction(scope)` — returns true only for global scope (used to gate warn/suspend)

### OAuth (Google/GitHub)

Uses [Arctic](https://arctic.js.org/) library with PKCE flow:
1. GET `/api/auth/google` - Redirects to provider
2. GET `/api/auth/google/callback` - Handles callback, creates/links user

---

## User Roles: Capabilities vs Derived State

Peerloop distinguishes between **capabilities** (stored permissions) and **derived state** (computed from data):

### Capabilities (Stored in `users` table)

| Column | Meaning |
|--------|---------|
| `can_take_courses` | User can enroll in courses (default true) |
| `can_teach_courses` | User can be assigned as Student-Teacher |
| `can_create_courses` | User can create and publish courses |
| `can_moderate_courses` | User can moderate community content |
| `is_admin` | User has admin access |

### Derived State (Computed from tables)

| State | How It's Determined |
|-------|---------------------|
| `is_creator` | `EXISTS (SELECT 1 FROM courses WHERE creator_id = user.id)` |
| `is_student_teacher` | `EXISTS (SELECT 1 FROM student_teachers WHERE user_id = user.id AND is_active = 1)` |

### Why This Matters

- **Capabilities** control what a user *can do* (permissions)
- **Derived state** reflects what a user *has done* (actual data)

**Example:** A user with `can_create_courses = true` has permission to create courses, but `is_creator = false` until they actually create one.

### API Response Patterns

- **Auth endpoints** (login, register, session): Return capabilities only
- **Profile/User endpoints**: Return both capabilities and derived state
- **Admin endpoints**: Return nested `capabilities` object + top-level derived state

```typescript
// Auth endpoint response
{
  user: {
    id, email, name, handle,
    can_take_courses: true,
    can_teach_courses: false,
    can_create_courses: true,
    is_admin: false
  }
}

// Profile/Admin endpoint response
{
  user: {
    id, email, name, handle,
    capabilities: { can_take_courses, can_teach_courses, can_create_courses, can_moderate_courses, is_admin },
    is_creator: true,        // Derived: has courses
    is_student_teacher: false // Derived: has active ST records
  }
}
```

### Client-Side Creator Gate (`useCreatorGate`)

All `/creating/*` pages use the `useCreatorGate` hook for client-side access checking before making API calls. This hook reads `CurrentUser` global state and applies the **Pattern C** policy from `POLICIES.md`:

```typescript
import { useCreatorGate } from '@components/auth/useCreatorGate';

export default function CreatorPage() {
  const { status, hasCourses } = useCreatorGate();

  if (status === 'loading') return <Spinner />;
  if (status === 'not-creator') return <AccessDeniedMessage />;
  // status === 'creator' — proceed normally
  // hasCourses — use for empty state decisions (analytics, etc.)
}
```

**Logic:** Permission (`canCreateCourses`) OR State (`hasCreatedCourses()`) = creator access. If neither passes from cache, the hook calls `refreshCurrentUser()` to handle stale data before denying.

**Key points:**
- Server-side API gates remain the security enforcement layer — the client gate is UX only
- `hasCourses` eliminates the need for separate API calls to check course count (e.g., CreatorAnalytics)
- Tests mock the hook with `vi.mock('@components/auth/useCreatorGate')` and override per-test with `vi.mocked(useCreatorGate).mockReturnValue(...)`

**Components using the hook:** `CreatorDashboard`, `CreatorStudio`, `CreatorAnalytics`, `CreatorCommunities`, `CreatorEarningsDetail`

**See:** `POLICIES.md` §1 "Creator Access Control", `src/components/auth/useCreatorGate.ts`

---

## Type Safety

### Zod for Validation

Define schemas with Zod, infer TypeScript types:
```typescript
import { z } from 'zod';

const UserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
});

type User = z.infer<typeof UserSchema>;
```

### Database Types

Located in `src/lib/db/types.ts`:
```typescript
import type { User, Course, Enrollment } from '@lib/db/types';
```

---

## API Endpoint Pattern

Standard pattern for API routes:

```typescript
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request, cookies, locals }) => {
  try {
    // 1. Parse request
    const body = await request.json();

    // 2. Validate input
    if (!body.email) {
      return Response.json({ error: 'Email required' }, { status: 400 });
    }

    // 3. Get database
    const db = locals.runtime?.env?.DB;
    if (!db) {
      return Response.json({ error: 'Database not available' }, { status: 500 });
    }

    // 4. Business logic
    const result = await someOperation(db, body);

    // 5. Return response
    return Response.json({ data: result });
  } catch (error) {
    console.error('Operation failed:', error);
    return Response.json({ error: 'Operation failed' }, { status: 500 });
  }
};
```

---

## Email (Resend)

Two send functions in `src/lib/email.ts` for two distinct use cases:

| Function | Use Case | Checks Preferences? |
|----------|----------|:---:|
| `sendEmail(apiKey, params)` | **Transactional** — receipts, enrollment confirmations, password resets | No (always sends) |
| `sendEmailToUser(db, apiKey, userId, type, params)` | **Notification** — session reminders, course updates, marketing | Yes (user can opt out) |

Templates live in `src/emails/` using `@react-email/components` with shared styles from `src/emails/styles.ts`.

| Template | Trigger | Type |
|----------|---------|------|
| `WelcomeEmail` | Registration | Transactional |
| `EnrollmentConfirmationEmail` | Course enrollment (Stripe webhook) | Transactional |
| `PaymentReceiptEmail` | Payment completed | Transactional |
| `SessionBookingEmail` | Session booked (both parties) | Notification |
| `SessionReminderEmail` | Upcoming session | Notification |
| `CertificateIssuedEmail` | Certificate approved | Notification |
| `PayoutNotificationEmail` | Payout processed | Notification |
| `ModeratorInviteEmail` | Moderator invitation | Transactional |

---

## Styling (Tailwind v4)

### CSS-based Configuration

Tailwind v4 uses CSS for configuration (not `tailwind.config.js`):

```css
/* src/styles/global.css */
@import "tailwindcss";

@theme {
  --color-primary: #3b82f6;
  --font-family-sans: "Inter", sans-serif;
}
```

### Component Patterns

- Use utility classes directly in components
- Extract repeated patterns to CSS `@apply` when needed
- Use `@tailwindcss/forms` for form styling
- Use `@tailwindcss/typography` for prose content

---

## Testing Strategy

### Unit Tests (Vitest)

- Location: `src/**/__tests__/*.test.ts`
- Run: `npm run test`
- Pattern: Test functions in isolation

### E2E Tests (Playwright)

- Location: `tests/*.e2e.ts`
- Run: `npm run test:e2e`
- Pattern: Test complete user flows

### Test Organization

```
src/
├── lib/
│   └── auth/
│       ├── index.ts
│       └── __tests__/
│           └── auth.test.ts
tests/
└── auth.e2e.ts
```

---

## Environment Variables

All env vars (secrets + non-secrets) live in `.dev.vars` (gitignored). A symlink `.env → .dev.vars` lets Astro/Vite read them too. Copy `.dev.vars.example` to get started.

Non-secrets are also in `wrangler.toml [vars]` (required for Cloudflare deployment). Secrets for Cloudflare are listed in `.secrets.cloudflare.production` and `.secrets.cloudflare.preview` (one per CF Dashboard tab).

See [tech-026-env-vars-secrets.md](../tech/tech-026-env-vars-secrets.md) for the complete master reference, including which vars are secrets, per-environment values, and the Cloudflare deployment workflow.

---

## Git Workflow

- `main` - Primary development branch
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Use `/q-commit` for standardized commits

---

## Conventions

### Machine Names

When documenting machine-specific behavior, use these standardized names:

| Machine | Standard Name | Hostname |
|---------|---------------|----------|
| Mac Mini M4 Pro (64GB) | `MacMiniM4-Pro` | `Jamess-Mac-mini.local` |
| Mac Mini M4 (24GB) | `MacMiniM4` | `Livings-Mac-mini.local` |

Both machines have identical, full capabilities.

**Why standardize?** Session files (learnings, dev logs, decisions) are scanned for these names to flag updates needed to `docs/tech/tech-013-devcomputers.md`.

**Full machine details:** See `docs/tech/tech-013-devcomputers.md`

---

## Documentation Maintenance

When making changes:

| Changed | Update |
|---------|--------|
| npm scripts | CLI-QUICKREF.md, CLI-REFERENCE.md |
| API endpoints | CLI-QUICKREF.md, API-REFERENCE.md |
| Tests added/removed | TEST-COVERAGE.md |
| New patterns | DEVELOPMENT-GUIDE.md (this file) |
| Phase progress | PLAN.md |

Run `/q-docs` at end of session to check for stale documentation.

---

## Related Documentation

- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Command reference
- [API-REFERENCE.md](API-REFERENCE.md) - API & database patterns
- [CLI-MISC.md](CLI-MISC.md) - Setup & installation
