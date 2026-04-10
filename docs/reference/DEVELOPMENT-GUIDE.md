# Development Guide

Development practices and patterns for the Peerloop project.

---

## Terminology

All platform terminology is defined in [`GLOSSARY.md`](../GLOSSARY.md) at the docs repo root. This is the **source of truth** for naming conventions across code, schema, UI text, and documentation.

Key rules:
- **"Teacher"** (not "Student-Teacher") in all new code and docs
- **"User" in code, "Member" in UI** — `users` table and `userId` in code; "member" in UI-facing text
- **"Visitor"** for unauthenticated users (not "guest")
- **Always qualify ambiguous terms** — see GLOSSARY.md §7 for the full list (session, rating, review, status, etc.)

---

## Repository Architecture

Peerloop uses a **dual-repo** structure:

| Repo | Purpose | Contents |
|------|---------|----------|
| `peerloop-docs` | Claude Code home + Obsidian vault | `.claude/`, `CLAUDE.md`, `docs/`, planning files |
| `Peerloop` | Application code | `src/`, `tests/`, `scripts/`, `migrations/`, config files |

**Build-time bridge:** The code repo has a symlink (`docs/`) pointing to the docs repo. Build scripts follow it transparently.

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

**Example:** Course pages use `CourseTabs` with 7 tabs:

```
/course/[slug]            → About tab    (default for visitors; enrolled → Learn)
/course/[slug]/teachers   → Teachers tab (public view; enrolled can book assigned teacher)
/course/[slug]/resources  → Resources tab (public preview; enrolled see all)
/course/[slug]/feed       → Feed tab     (enrolled only)
/course/[slug]/sessions   → Sessions tab (enrolled only — student's sessions for this course)
/course/[slug]/learn      → Learn tab    (enrolled only — accordion modules + progress)
/course/[slug]/curriculum → Curriculum tab (enrolled only — being retired, absorbed into Learn)
```

**Data strategy per tab:**
- **Server-side** (props from Astro page): When data is simple DB joins. Used by About, Teachers, Feed, Sessions, Learn.
- **Client-side** (fetch from API): When the API encapsulates complex logic (enrollment gating, R2 URL generation). Used by Resources.

**Architecture (Conv 040 decomposition):** `CourseTabs.tsx` was refactored from a 1392-line monolith into a ~195-line shell that delegates to per-tab sub-components in `src/components/courses/course-tabs/`:

| File | Lines | Responsibility |
|------|:-----:|----------------|
| `CourseTabs.tsx` | ~195 | Tab bar, URL sync, `extraTabs`/`basePath` props |
| `course-tabs/types.ts` | — | Shared types using `Pick<DBType, fields>` |
| `course-tabs/AboutTabContent.tsx` | ~294 | About tab with `onNavigateToTab` callback |
| `course-tabs/TeachersTabContent.tsx` | ~165 | Teachers tab with `bookedSessionCount` prop |
| `course-tabs/ResourcesTabContent.tsx` | ~218 | Resources tab (owns its data fetching) |
| `course-tabs/SessionsTabContent.tsx` | ~338 | Sessions tab (receives sessions from parent) |

**`extraTabs` pattern:** CourseTabs and CommunityTabs both accept additional tabs via `ExtraTabConfig[]` — each entry has `id`, `label`, `icon`, `roleColor`, `groupLabel`, and `content`. This lets callers (e.g., `ExploreCourseTabs`, `ExploreCommunityTabs`) inject role-specific tabs without modifying the base component internals. Section labels render above their tab group (stacked layout) to save horizontal space. This is Open/Closed Principle in practice — any future entity detail page can use the same extension mechanism.

**Key components:** `CourseTabs.tsx` (tab shell + URL sync), `LearnTab.tsx` (module list + progress), `ModuleAccordion.tsx` (individual module card with expand/collapse + session info).

**Catch-all alternative (Conv 042):** The discover detail page uses a single `[...tab].astro` catch-all instead of one file per tab. A `VALID_TABS` Set validates the tab segment; invalid values redirect to the base page. This reduces 8+ duplicate files to 2 (index + catch-all), at the cost of SSR code duplication between index.astro and `[...tab].astro`. New tabs only require adding to the Set.

```
/discover/course/[slug]              → index.astro (default tab)
/discover/course/[slug]/teachers     → [...tab].astro (validated, renders with initialTab)
/discover/course/[slug]/invalid      → [...tab].astro (redirects to base)
```

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/`, `src/pages/course/[slug]/*.astro`, `src/pages/discover/course/[slug]/[...tab].astro`

### SSR Elements with Client-Side Data Updates

When an SSR-rendered element (in `.astro`) needs data that's only available client-side (e.g., `CurrentUser` role info), use `document.getElementById` from the React island to update the DOM after hydration.

```astro
---
// courses.astro — SSR renders visitor-friendly default
---
<p id="page-subtitle" class="text-gray-500">
  Discover courses from expert creators
</p>
<ExploreCourses client:load />
```

```tsx
// ExploreCourses.tsx — React updates subtitle based on role data
useEffect(() => {
  const el = document.getElementById('page-subtitle');
  if (el && currentUser) {
    el.textContent = getRoleAwareSubtitle(currentUser);
  }
}, [currentUser]);
```

**Why this pattern:** Avoids layout shift since the element already exists with a sensible default. No need to wrap the Astro content in a React island just for one dynamic string.

**See:** `src/pages/discover/courses.astro`, `src/components/discover/ExploreCourses.tsx` (Conv 041–042)

### Shared Toast Notifications

Use the shared `showToast()` function for all transient user feedback. It creates a DOM-based toast that survives React re-renders and Astro island remounts (React state-based banners are lost on remount).

```tsx
import { showToast } from '@lib/toast';

// Success (default)
showToast('Course saved successfully');

// Error
showToast('Failed to save course', 'error');

// Custom duration (default 5000ms)
showToast('Copied to clipboard', 'success', 3000);
```

**Key behavior:** Uses a fixed `id="app-toast"` on the DOM element, so only one toast displays at a time (previous is removed before new one appears). Fades out after the duration.

**When to use:** Any save/action/error feedback. Replaces all `alert()` calls across the codebase (Conv 079).

**In tests:** Assert via `document.getElementById('app-toast')?.textContent`.

**See:** `src/lib/toast.ts` (Conv 079)

### Shared Confirm Modal (Callback-in-State Pattern)

Use `ConfirmModal` for all destructive or confirmation actions. It replaces all `confirm()` calls with a proper modal dialog.

```tsx
import { useState } from 'react';
import { ConfirmModal, type ConfirmState } from '@components/ui/ConfirmModal';

function MyComponent() {
  const [confirmState, setConfirmState] = useState<ConfirmState | null>(null);

  const handleDelete = () => {
    setConfirmState({
      title: 'Delete Course',
      message: 'This action cannot be undone.',
      confirmLabel: 'Delete',
      variant: 'danger',
      onConfirm: async () => {
        await fetch(`/api/courses/${id}`, { method: 'DELETE' });
        // Auto-closes on success
      },
    });
  };

  return (
    <>
      <button onClick={handleDelete}>Delete</button>
      <ConfirmModal state={confirmState} onClose={() => setConfirmState(null)} />
    </>
  );
}
```

**Key behavior:** A single `useState<ConfirmState | null>` handles unlimited confirm dialogs per component — the action-specific context lives in the `onConfirm` closure. The modal manages its own loading/error state and auto-closes on success. Variants: `'danger'` (red) and `'default'` (blue).

**When to use:** Any destructive or confirmation action. Replaces all `confirm()` calls across the codebase (Conv 079).

**In tests:** Click the trigger button, find the modal by its title text, click the confirm button by role/name, await the async action.

**See:** `src/components/ui/ConfirmModal.tsx` (Conv 079)

### Shared Form Modal (Multi-Field Callback-in-State Pattern)

Use `FormModal` for actions that require user input — text, selections, numbers, or multi-field forms. It replaces all `prompt()` calls with a proper form modal. Uses the same callback-in-state pattern as `ConfirmModal`.

```tsx
import { useState } from 'react';
import { FormModal, type FormModalState } from '@components/ui/FormModal';

function MyComponent() {
  const [formState, setFormState] = useState<FormModalState | null>(null);

  const handleSuspend = () => {
    setFormState({
      title: 'Suspend User',
      description: 'This will restrict the user from accessing the platform.',
      fields: [
        { name: 'duration', label: 'Duration', type: 'select', required: true,
          options: [{ value: '1d', label: '1 day' }, { value: '7d', label: '7 days' }] },
        { name: 'reason', label: 'Reason', type: 'textarea', required: true },
        { name: 'notes', label: 'Internal notes', type: 'textarea' },
      ],
      submitLabel: 'Suspend',
      variant: 'danger',
      onSubmit: async (values) => {
        await fetch(`/api/admin/users/${id}/suspend`, {
          method: 'POST',
          body: JSON.stringify(values),
        });
      },
    });
  };

  return (
    <>
      <button onClick={handleSuspend}>Suspend</button>
      <FormModal state={formState} onClose={() => setFormState(null)} />
    </>
  );
}
```

**Key behavior:** Supports `text`, `textarea`, `select`, `number`, and `email` field types. Required fields are validated before submission. Auto-focuses the first input on open. Manages its own loading/error state and auto-closes on success. Constrained choices (e.g., duration, resolution type) use `select` with `options` array, making invalid input structurally impossible. Multi-prompt sequences (e.g., 3 sequential `prompt()` calls) collapse into a single form.

**When to use:** Any action requiring user input. Replaces all `prompt()` calls across the codebase (Conv 080). For pure yes/no confirmations without input fields, use `ConfirmModal` instead.

**In tests:** Click the trigger button, find form fields by placeholder text or scoped queries within the modal (avoid `getByRole` for common roles like `textbox`/`combobox` on complex pages with search/filter elements), fill values, click submit.

**See:** `src/components/ui/FormModal.tsx` (Conv 080)

### Shared Component Feature Flags

When a shared component needs different behavior in different contexts, add opt-out boolean props with backward-compatible defaults rather than forking the component.

```tsx
// CreatorCourseCard — used by Dashboard (needs toggle) and Explore (doesn't)
interface Props {
  showDiscussionToggle?: boolean; // default true for backward compat
}
```

**See:** `src/components/dashboard/CreatorCourseCard.tsx` (`showDiscussionToggle`), `src/components/recommendations/RecommendedCourses.tsx` (`compact`) (Conv 041)

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

**Known `via` values:** `discover-communities`, `discover-courses`, `community-courses` (with `cs` and `cn` params for community slug and name), `recommendations`, `discover`.

**See:** `src/components/ui/Breadcrumbs.astro`, `docs/DECISIONS.md` §5 "Breadcrumb System"

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

**See:** `src/components/courses/CourseCard.tsx`, `src/components/notifications/NotificationsList.tsx`, `docs/DECISIONS.md` §5 "Stretched-Link Pattern"

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

**See:** `docs/DECISIONS.md` §5 "Three-Tier Navigation Strategy"

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

### Avatar & Image Fallbacks

All user avatars use the `UserAvatar` component (`src/components/users/UserAvatar.tsx`). It shows the user's image or a gradient circle with their initial.

**Sizes:**

| Size | Class | Dimensions |
|------|-------|------------|
| `xs` | `h-6 w-6` | 24px |
| `sm` | `h-8 w-8` | 32px |
| `md` | `h-12 w-12` | 48px |
| `lg` | `h-16 w-16` | 64px (default) |
| `xl` | `h-24 w-24` | 96px |

**Usage:**
```tsx
import UserAvatar from '@components/users/UserAvatar';
<UserAvatar name={user.name} avatarUrl={user.avatar_url} size="md" />
```

**Fallback pattern:** When `avatarUrl` is null, renders a `bg-linear-to-br from-primary-400 to-primary-600` gradient circle with the user's first initial in white. No external dependencies (no `placehold.co`).

**Custom sizes:** For one-off sizes outside the component, use inline gradient divs with the same styling:
```tsx
<div className="h-10 w-10 rounded-full bg-linear-to-br from-primary-400 to-primary-600 flex items-center justify-center text-white font-bold text-sm">
  {name.charAt(0).toUpperCase()}
</div>
```

**Community cover images:** Use `cover_image_url` in the same layout position as the icon/emoji square. Fallback chain: cover image → emoji icon → gradient. Use rectangular styling (`rounded-lg object-cover`), not circular.

**See also:** `docs/DECISIONS.md` — "Unified Gradient+Initial Avatar Fallback" and "Community Cover Image Display" (Conv 023).

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

**Pattern variant: Create-on-verify** — for webhook-dependent record creation (not just status sync), extract the creation logic into a shared module and call it from both the webhook and a verify endpoint. The verify endpoint retrieves the external session and runs the same idempotent creation logic.

**See:** `src/lib/enrollment.ts` (shared), `src/pages/api/stripe/verify-checkout.ts` (verify endpoint), `src/pages/course/[slug]/success.astro` (SSR self-heal). Implemented Session 324.

**Pattern variant: Extract-and-share for manual healing** — for webhook-dependent state transitions where the user has direct knowledge (e.g., a teacher knows a session happened), extract the transition logic into a shared function and expose a manual endpoint. The function is idempotent and called by: webhook handler, manual endpoint (teacher/creator), and admin endpoint.

**See:** `src/lib/booking.ts` (`completeSession`), `src/pages/api/sessions/[id]/complete.ts` (manual), `src/pages/api/webhooks/bbb.ts` (webhook), `src/pages/api/admin/sessions/[id].ts` (admin). Implemented Session 334.

### D1 Fallback for External Service Enrichment (Conv 059)

When enriching data from an external service (Stream, Stripe, etc.), always include a D1 fallback for entity resolution. If the external service doesn't return data for a given ID, query D1 for names and metadata instead of showing raw IDs.

**Pattern:** Batch D1 queries for unresolved entities

```typescript
// In enrichment pipeline — after Stream returns partial data
const unresolvedUserIds = candidates
  .filter(c => !c.actorName)
  .map(c => c.actorId);

if (unresolvedUserIds.length > 0) {
  const names = await fetchUserNames(db, unresolvedUserIds);
  // Merge names back into candidates
}
```

**When to use:** Any pipeline that enriches database records with external service data. The fallback costs nothing when the external service works (empty unresolved set), but prevents broken UI when it doesn't.

**See:** `src/lib/smart-feed/enrichment.ts` — `fetchUserNames()`, `fetchCommunityNames()`, `fetchCourseNames()` (Conv 059)

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

**Read body once.** `Request.body` is a stream — calling `request.json()` or `request.text()` consumes it. If you need to try multiple parse strategies, read as text first, then parse: `const text = await request.text(); const data = JSON.parse(text);`. Never call `request.json()` then `request.text()` in a fallback — the second read returns empty. (Bug fixed Conv 087 in `bbb.ts`.)

**Payload capture via `webhook_log`.** All webhook handlers INSERT a fire-and-forget log row at the top of processing (before business logic). This captures the raw payload, source provider, endpoint path, and HTTP method. Auth headers are redacted. Useful for debugging delivery issues and generating test fixtures from real payloads. Added Conv 037.

**See:** `src/pages/api/webhooks/stripe.ts`, `src/pages/api/webhooks/bbb.ts`, `src/pages/api/webhooks/bbb-analytics.ts`, `docs/reference/stripe.md` (Webhooks section)

### Stripe CLI for Local Webhook Testing

Run the Stripe webhook listener alongside the dev server:

```bash
# Terminal 1
npm run dev

# Terminal 2
npm run stripe:listen
```

The webhook signing secret must match `STRIPE_WEBHOOK_SECRET` in `.dev.vars`. The secret is stable across sessions on the same machine.

**Full webhook dev environment (Conv 091):** Use `npm run dev:webhooks` to orchestrate the entire setup in one command — preflight checks, dev server startup with health-check polling, Stripe CLI forwarding, and cleanup trap. Then trigger events with `npm run trigger -- <event>`:

```bash
# Terminal 1: full environment
npm run dev:webhooks

# Terminal 2: trigger individual events
npm run trigger -- checkout        # Stripe checkout.session.completed
npm run trigger -- bbb-meeting-ended  # BBB meeting-ended
npm run trigger -- refund          # Stripe charge.refunded (synthetic)
```

**Stripe fixture alignment:** The `checkout` trigger injects 7 metadata overrides (`user_id`, `course_id`, etc.) matching seed data records. Refund/dispute triggers are synthetic and don't match DB records (Stripe-generated charge IDs).

**BBB HMAC:** `trigger-webhook.sh` generates signatures with `openssl dgst -sha256 -hmac`, which produces identical output to Web Crypto `HMAC-SHA256`.

**See:** `docs/reference/stripe.md` (Per-Environment Webhook Configuration), `docs/reference/SCRIPTS.md` (dev-webhooks.sh, trigger-webhook.sh)

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
| `@test-helpers` | `tests/helpers` | `describeWithTestDB`, `getTestDB`, `getRawTestDB`, `resetTestDB`, `DB_TEST` |
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

**Use `batch()` for multi-step writes (Conv 087).** Any endpoint that performs sequential delete-then-insert or multi-table writes MUST use `batch()` for atomicity. If the second operation fails without batching, the first operation leaves partial data. Converted in Conv 087: `me/availability.ts`, `me/onboarding-profile.ts`, `me/account.ts`.

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

### Datetime Convention (Conv 002, migrated Conv 011)

All datetimes are stored as **UTC ISO 8601 with Z suffix** (e.g., `2026-03-20T18:00:00.000Z`). Never use bare datetime strings — they're ambiguous (Workers parse as UTC, browsers parse as local time).

**Writing timestamps:**
```typescript
import { toUTCISOString } from '@lib/timezone';

// In application code — parameterize, don't embed in SQL
db.prepare('UPDATE users SET updated_at = ? WHERE id = ?')
  .bind(toUTCISOString(), userId).run();

// ❌ Don't use: datetime('now') in SQL — produces wrong format
// ❌ Don't use: now() from @lib/db — deprecated, use toUTCISOString()
```

**Displaying dates:**
```typescript
import { formatDateUTC, formatDateTimeUTC, formatLocalTime } from '@lib/timezone';

formatDateUTC(str, 'medium')   // → 'Mar 18, 2026'    (date-only)
formatDateTimeUTC(str)          // → 'Mar 18, 2026, 11:41 PM' (timestamps)
formatLocalTime(utc, tz)        // → { date, time }    (timezone-sensitive sessions)

// ❌ Don't use: new Date(x).toLocaleDateString() — not UTC-safe
```

**Converting local → UTC:**
```typescript
import { localToUTC } from '@lib/timezone';
const utc = localToUTC('2026-03-20', '09:00', 'America/New_York');
// → '2026-03-20T13:00:00.000Z' (EDT, UTC-4)
```

**Schema defaults:** `DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))` — produces `.000Z` matching JS exactly.

### Clock Injection for Server-Side Time (Conv 003, swept Conv 089+090)

Server-side code that makes **time-sensitive decisions** (booking guards, expiry checks, availability windows, analytics period ranges) must use `getNow()` from `@lib/clock` instead of `new Date()`. This provides a clean mock point for tests.

```typescript
import { getNow } from '@lib/clock';

// ✅ CORRECT — testable, mockable
const now = getNow();
if (new Date(session.scheduled_start) < now) { ... }

// ❌ WRONG — untestable, bypasses clock abstraction
const now = new Date();
```

**Scope:** All files under `src/pages/api/` and `src/lib/` that perform time comparisons. As of Conv 090, 47+ files use `getNow()` (Conv 089 converted 22 files, Conv 090 completed the sweep with 25 more).

**Exempt uses:** ~12 files retain bare `new Date()` or `Date.now()` with `// getNow-exempt` inline comments for legitimate uses: `clock.ts` (defines getNow itself), health check endpoints, debug endpoint, DB timestamp utility, R2 metadata, replication metadata, response metadata, utility function fallbacks, performance timing, JWT expiry checks.

**Lint enforcement:** `npm run lint:tz` scans source files for bare `new Date()` and `Date.now()`. Lines with `// getNow-exempt` are excluded. The source file section is clean as of Conv 090 (zero flags).

**Test file exemptions:** Phase 1 of `lint:tz` also scans test files for timezone-unsafe patterns (`setHours()`, `new Date(year, month, day)`). Lines with `// tz-exempt` are excluded from test-file FAILs for intentional local-time constructs (e.g., testing `toISO` format output which uses local time by design). Added Conv 091. See `docs/as-designed/lint-timezone.md` for full fragility analysis.

**Testing:** Mock `getNow()` via `vi.mock('@lib/clock')` to freeze time in tests. See existing test files for examples.

### EXISTS Subquery for Taxonomy Filtering (Conv 049)

When filtering courses by topic, use an `EXISTS` subquery instead of JOINs. JOINs through `course_tags -> tags -> topics` produce duplicate rows when a course has multiple tags under one topic.

```sql
-- ✅ CORRECT — no duplicates, SQLite optimizes as semi-join
WHERE EXISTS (
  SELECT 1 FROM course_tags ct
  JOIN tags tg ON ct.tag_id = tg.id
  JOIN topics tp ON tg.topic_id = tp.id
  WHERE ct.course_id = c.id AND tp.slug = ?
)

-- ✅ Related courses via shared tags (self-join pattern)
WHERE EXISTS (
  SELECT 1 FROM course_tags ct1
  JOIN course_tags ct2 ON ct1.tag_id = ct2.tag_id
  WHERE ct1.course_id = c.id AND ct2.course_id = ?
)
```

This pattern is used consistently across 5+ endpoints for topic-based course filtering.

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
  isValidHandleFormat,  // boolean shorthand for call sites that don't need error details
} from '@lib/auth';
```

**Handle validation** (Conv 068): Single source of truth in `auth/index.ts`. Rules: `^[a-zA-Z][a-zA-Z0-9_]{2,19}$` — must start with a letter, letters/numbers/underscores only, 3-20 chars. `validateHandle()` returns `{ isValid, error? }` with specific error messages; `isValidHandleFormat()` returns a boolean for call sites that only need pass/fail.

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

**Onboarding redirect:** Two paths redirect fresh users to `/onboarding`: (1) OAuth callbacks redirect users with no `onboarding_completed_at`; (2) `handleAuthSuccess()` in `auth-modal.ts` redirects after email/password signup when no pending action (e.g., `returnUrl`) exists (Conv 067). Login is not affected. Onboarding is not gated in middleware.

### Middleware Auth Guard (Conv 053)

`src/middleware.ts` centralizes authentication for SSR pages. It uses JWT-only verification (no DB queries).

**Route classification — two-set approach:**

| Set | Match Logic | Examples |
|-----|-------------|---------|
| `PROTECTED_PREFIXES` | pathname === prefix OR starts with prefix + `/` | `/admin`, `/creating`, `/dashboard`, `/learning`, `/session`, `/settings`, `/teaching` |
| `PROTECTED_EXACT` | pathname === exact path (sub-paths pass through) | `/community`, `/courses`, `/feed`, `/feeds`, `/messages`, `/notifications`, `/onboarding`, `/profile` |

**Why two sets:** URL convention uses the same base for member-only and public pages (e.g., `/community` = "My Communities" is member-only, `/community/[slug]` is public-browsable). Prefix matching would incorrectly block the public sub-paths.

**Security model:** Middleware handles **authentication** ("are you logged in?"). Individual pages and API endpoints handle **authorization** ("are you allowed?" — role checks, enrollment verification).

**Unauthenticated redirect:** Protected routes redirect to `/login?redirect=<original-path>` so the user returns to the intended page after login.

**See:** `src/middleware.ts`, `tests/middleware.test.ts` (86 tests)

---

## User Roles: Capabilities vs Derived State

Peerloop distinguishes between **capabilities** (stored permissions) and **derived state** (computed from data):

### Capabilities (Stored in `users` table)

| Column | Meaning |
|--------|---------|
| `can_take_courses` | User can enroll in courses (default true) |
| `can_teach_courses` | User can be assigned as Teacher |
| `can_create_courses` | User can create and publish courses |
| `can_moderate_courses` | User can moderate community content |
| `is_admin` | User has admin access |

### Derived State (Computed from tables)

| State | How It's Determined |
|-------|---------------------|
| `is_creator` | `EXISTS (SELECT 1 FROM courses WHERE creator_id = user.id)` |
| `is_teacher` | `EXISTS (SELECT 1 FROM teacher_certifications WHERE user_id = user.id AND is_active = 1)` |

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
    is_teacher: false // Derived: has active teacher certifications
  }
}
```

### Client-Side Creator Gate (`useCreatorGate`)

All `/creating/*` pages use the `useCreatorGate` hook for client-side access checking before making API calls. This hook reads `CurrentUser` global state and applies the **Pattern C** policy from `docs/POLICIES.md`:

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

**See:** `docs/POLICIES.md` §1 "Creator Access Control", `src/components/auth/useCreatorGate.ts`

### Dashboard Data Flow Pattern

All dashboard components follow the same data flow (standardized in Conv 033):

| Data Type | Source | Examples |
|-----------|--------|----------|
| **Identity** (cacheable) | `useCurrentUser()` | name, handle, capabilities, role flags |
| **Transactional** (must be fresh) | Dedicated API call | earnings, stats, pending counts, rosters |
| **Operational state** | Dedicated API call | `is_available` (teacher toggle) |

```typescript
// Standard dashboard pattern
const { currentUser } = useCurrentUser();
const [data, setData] = useState<DashboardData | null>(null);

useEffect(() => {
  fetch('/api/me/teacher-dashboard')
    .then(r => r.json())
    .then(setData);
}, []);

// Identity comes from CurrentUser, not the API response
<Header name={currentUser.name} stats={data?.stats} />
```

**Key rule:** Dashboard APIs do NOT return identity fields (name, handle). The client already has them from `CurrentUser`, which is cached at boot. This avoids redundant data transfer and keeps a single source of truth for identity.

**Components following this pattern:** `StudentDashboard`, `TeacherDashboard`, `CreatorDashboard`, `UnifiedDashboard`

**Server-side resilience (Conv 087):** Dashboard API endpoints (teacher-dashboard, creator-dashboard, teacher-sessions) use `.catch(() => default)` to return partial data when individual queries fail — a 500 on one of 12 queries should not blank the entire dashboard. All catch handlers MUST include `console.error` so failures are visible in logs. Silent suppression is not allowed.

**Testing note:** When mocking `useCurrentUser()` in dashboard tests, the mock must satisfy ALL consumers in the component tree — not just the component under test. Child components (e.g., `MyFeeds`) may independently call `useCurrentUser().getFeeds()`. Include method stubs and catch-all fetch mocks for child component API calls.

### Inline Role Detection with `getCurrentUser()` (Conv 046)

For public-facing pages that need lightweight role-conditional UI (e.g., showing an "Edit Profile" button when viewing your own profile), use `getCurrentUser()` — the synchronous client-side accessor that reads from `window.__peerloop` (pre-populated by AppNavbar before hydration).

**Pattern — own-profile detection:**
```typescript
const [isOwnProfile, setIsOwnProfile] = useState(false);

useEffect(() => {
  const user = getCurrentUser();
  if (user?.handle === handle) setIsOwnProfile(true);
}, [handle]);
```

**Pattern — content-relationship detection:**
```typescript
const [isTeacher, setIsTeacher] = useState(false);
const [isCreator, setIsCreator] = useState(false);

useEffect(() => {
  const user = getCurrentUser();
  if (user?.isTeacherFor(courseId)) setIsTeacher(true);
  if (user?.isCreatorFor(courseId)) setIsCreator(true);
}, [courseId]);
```

**Why this works without flash:** `getCurrentUser()` is synchronous. The `useState(false) → useEffect` pattern means non-owner viewers (the majority case) see the default UI immediately with no layout shift. Owner-specific buttons appear after hydration — near-instant on any device.

**Components using this pattern:** `CourseHero`, `CreatorProfileHeader`, `TeacherProfileHeader`, `PublicProfile`

**When to use:** Visibility-only decisions on public pages (showing/hiding buttons). For access control gates that block page content, use `useCreatorGate` or server-side guards instead.

### Hydration-Safe Hooks: `useCurrentUser()` and `useAuthStatus()` (Conv 054)

Both hooks are **hydration-safe by default**. They initialize with SSR-compatible values (`null` / `'loading'`), then populate from the localStorage cache in `useEffect`. This ensures the first client render matches server HTML in Astro `client:load` islands.

**Why this matters:** React hooks used in Astro islands must produce the same output on server and client for the first render. If `useCurrentUser()` returned a cached user immediately, SSR (which has no localStorage) would render `null` while the client would render user-specific UI — causing a hydration mismatch.

**How it works:**
```typescript
// Inside useCurrentUser():
const [currentUser, setCurrentUser] = useState<CurrentUser | null>(null); // SSR-safe
useEffect(() => {
  setCurrentUser(getCurrentUser()); // populate from cache after mount
}, []);

// Inside useAuthStatus():
const [status, setStatus] = useState<AuthStatus>('loading'); // SSR-safe
useEffect(() => {
  setStatus(deriveStatus()); // populate after mount
}, []);
```

**Flash impact:** Discover pages show a brief additive flash (role tabs/badges appearing after mount). Dashboard and teaching pages use skeleton loaders, so no visible flash. This is acceptable — the alternative (`client:only`) loses SSR/SEO.

**Key rule:** Never use `useState(() => getFromCache())` or `useState(getFromCache())` in hooks consumed by Astro islands. Always use `useState(null)` + `useEffect` for browser-only APIs.

### Auth-Aware Skeleton Guards with `useAuthStatus()` (Conv 052)

Components that show skeleton loaders while `currentUser` is null must distinguish "still loading" from "not authenticated." Without this, expired sessions cause infinite skeleton loops (SSR rendered authenticated HTML, but React islands can't load user data).

**Pattern:**
```typescript
import { useCurrentUser } from '@lib/current-user';
import { useAuthStatus } from '@lib/current-user';

const { currentUser } = useCurrentUser();
const authStatus = useAuthStatus();

// Skeleton only while genuinely loading
if (!currentUser && authStatus === 'loading') {
  return <SkeletonUI />;
}

// Not authenticated (visitor, expired session, error) — render nothing or redirect
if (!currentUser) {
  return null;
}
```

**`authStatus` values:** `'loading'` | `'authenticated'` | `'visitor'` | `'session_expired'` | `'error'`

**Key rule:** Never use `!currentUser` alone as a loading signal. Always pair with `authStatus === 'loading'` to avoid infinite skeletons on expired sessions.

**Components using this pattern:** `StudentDashboard`, `UnifiedDashboard`, `ExploreFeeds`, `FeedsHub`

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
import { parseBody } from '@lib/request';

export const POST: APIRoute = async ({ request, cookies, locals }) => {
  try {
    // 1. Parse request (safe — returns 400 on malformed JSON)
    const body = await parseBody<{ email: string }>(request);

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
    if (error instanceof Response) return error;
    console.error('Operation failed:', error);
    return Response.json({ error: 'Operation failed' }, { status: 500 });
  }
};
```

### `parseBody<T>()` — Safe JSON Body Parsing (Conv 087)

**File:** `src/lib/request.ts`

All POST/PUT/PATCH/DELETE endpoints use `parseBody<T>(request)` instead of raw `request.json()`. This utility wraps the JSON parse in a try/catch and throws a `Response(400, { error: 'Invalid JSON' })` on malformed input, preventing unhandled 500 errors from bad request bodies.

```typescript
import { parseBody } from '@lib/request';

const body = await parseBody<{ name: string; email: string }>(request);
```

**Catch block pattern:** Because `parseBody` throws a `Response` object, outer catch blocks must propagate it:

```typescript
} catch (error) {
  if (error instanceof Response) return error;  // ← required
  console.error('Operation failed:', error);
  return Response.json({ error: 'Operation failed' }, { status: 500 });
}
```

**Security exception:** `reset-password.ts` intentionally does NOT use `parseBody`. It returns 200 on all inputs (including malformed JSON) to prevent email enumeration attacks.

---

## Admin Intel Pattern (Conv 057)

The `src/components/admin-intel/` module provides admin-only intelligence overlays on member-facing pages. It follows a **barrel export** pattern where types, hooks, helpers, and components live in one directory with an `index.ts` re-export.

### Two-Layer Admin Protection

Admin-only pages use two complementary protection layers:

| Layer | Mechanism | Purpose |
|-------|-----------|---------|
| SSR | `getSession()` → `roles.includes('admin')` → redirect | Prevents page render |
| API | `requireRole(cookies, jwtSecret, ['admin'])` | Prevents data access |

Client-side React components (e.g., `DiscoverSlidePanel`) use `useCurrentUser()?.isAdmin` to conditionally show admin entries — this is UX polish, not a security boundary.

### Admin Tab Injection

Admin tabs are injected into role-based tab systems (e.g., `ExploreCourseTabs`) via the `extraTabs` prop (type `ExtraTabConfig[]`). The key pattern change: the original `if (roleTabs.length === 0) return []` early return was removed so admin tabs appear even when the admin has no course role.

### Key Files

| File | Purpose |
|------|---------|
| `src/components/admin-intel/types.ts` | CourseIntel, CommunityIntel, UserIntel, CourseIntelBadge, CommunityIntelBadge, DashboardIntel |
| `src/components/admin-intel/useAdminIntel.ts` | Generic fetch hook with admin short-circuit |
| `src/components/admin-intel/admin-links.ts` | `adminUrlFor()` / `memberUrlFor()` URL helpers |
| `src/components/admin-intel/AdminBadge.tsx` | Round red badge (matches RoleBadge compact sizing) |
| `src/components/admin-intel/AdminCourseTab.tsx` | Full/compact course intel panel |
| `src/components/admin-intel/AdminCommunityTab.tsx` | Full/compact community intel panel |
| `src/components/admin-intel/AdminDashboardCard.tsx` | Platform health summary for admin dashboard (5 intel items + zero-state) |
| `src/components/admin-intel/AdminMemberSummary.tsx` | Full/compact user intel panel |
| `src/components/admin-intel/index.ts` | Barrel export |

---

## Enrollment Guards (Conv 008)

Shared validation module at `src/lib/enrollment-guards.ts` that prevents invalid enrollments. Used by both the student checkout (`POST /api/checkout/create-session`) and admin enrollment (`POST /api/admin/enrollments`) endpoints.

### Guard Sequence

`checkEnrollmentGuards(db, studentId, courseId, creatorId)` runs 5 checks in order:

| # | Guard | Result | Strategy |
|---|-------|--------|----------|
| 1 | Creator self-enrollment | `creator_own_course` | Hard block |
| 2 | Active teacher (`is_active=1 AND teaching_active=1`) | `active_teacher` | Hard block |
| 3 | Duplicate active enrollment (`enrolled`/`in_progress`) | `already_enrolled` | Hard block |
| 4 | Completed enrollment lookup | Informational | Not a block — returns data for retake dialog |
| 5 | Zero active teachers | `no_teachers` | Hard block + notifies creator & admins |

Returns a typed `EnrollmentGuardResult`:

```typescript
interface EnrollmentGuardResult {
  allowed: boolean;
  reason?: 'creator_own_course' | 'active_teacher' | 'no_teachers' | 'already_enrolled';
  completedEnrollment: { id: string; completedAt: string } | null;
  teacherCount: number;
}
```

### Availability Window

`platform_stats.availability_window_days` (default 30) controls how far ahead the availability preview looks. Admin-configurable; no UI yet (deferred to ADMIN-SETTINGS-UI block). Used by `GET /api/courses/:id/availability-summary` and referenced in enrollment guard messaging.

### Availability Validation (Conv 088)

`isSlotWithinAvailability()` in `src/lib/availability.ts` validates that a requested booking time falls within a teacher's availability. Checks:
1. **Recurring rules** — matches day-of-week and time window from `availability` table
2. **Timezone conversion** — converts slot times to the teacher's configured timezone for day/time comparison
3. **Overrides** — respects `availability_overrides` (blocked dates take precedence over recurring rules)

Returns `{ available: boolean; reason?: string }`. Used by `POST /api/sessions` after teacher certification check. Mirrors the existing `countAvailableSlots()` algorithm.

**Testing pattern:** Seed all-day/all-week UTC availability (`day_of_week` 0-6, `00:00`-`23:59`, `UTC`, `is_recurring=1`) in test `beforeAll` for any test that books sessions. This avoids calendar-dependent flakiness.

### `teaching_active` Field

User-controlled toggle on `teacher_certifications`. Allows a certified teacher to pause accepting new students without losing certification. Distinct from `is_active` (admin-controlled). Added to `/api/me/full` response and used by `CurrentUser.isActivelyTeachingFor()`.

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

### PLATO Flow Tests

- Location: `tests/plato/`
- Run: `npm run test:plato`
- Pattern: API-level user journey tests using Model B (sequential DB-accumulation). Each step models a page visit with button presses triggering API calls. Steps execute in fixed order; the DB is the only state that persists between steps.
- **Scenarios:** Independent, goal-driven step sequences with persona sets and DB verifications
- **Instances:** Parameterized scenario execution — same scenario, different persona data. Instance files support `when` guards for conditional steps and `WalkthroughCheckpoint` for STUMBLE-AUDIT browser pairing.
- Uses `seedCoreTestDB()` for production-like starting state (core seed only)
- Actor resolution via `fromDB` — queries users table by persona email
- Intra-step data flow uses `$context` (what the page showed the user); no cross-step carry state
- Design doc: `docs/as-designed/plato.md`
- Practical guide: `docs/reference/PLATO-GUIDE.md`

### E2E Tests (Playwright)

- Location: `tests/*.e2e.ts`
- Run: `npm run test:e2e`
- Pattern: Test complete user flows

### Dual Alias Mocking

When mocking modules that have multiple path aliases (e.g., `@/lib/auth` and `@lib/auth`), use `vi.hoisted()` to create shared mock functions:

```typescript
const mockAuth = vi.hoisted(() => ({
  getCurrentUser: vi.fn(),
  requireRole: vi.fn(),
}));
vi.mock('@/lib/auth', () => mockAuth);
vi.mock('@lib/auth', () => mockAuth);
```

This ensures both import paths resolve to the same mock instances. Without this, tests may pass for one import path but fail for another.

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

See [env-vars-secrets.md](../architecture/env-vars-secrets.md) for the complete master reference, including which vars are secrets, per-environment values, and the Cloudflare deployment workflow.

### Centralized Env Access (Conv 100)

**Directive:** Application code MUST access Cloudflare bindings and secrets through helper functions. Direct reads of `locals.runtime?.env?.*` are limited to the helper implementations themselves.

**Helpers:**

| Helper | File | Use For |
|--------|------|---------|
| `requireEnv(locals, 'KEY')` | `src/lib/env.ts` | Required env vars — throws if missing |
| `getEnv(locals, 'KEY')` | `src/lib/env.ts` | Optional env vars — returns `undefined` |
| `getDB(locals)` | `src/lib/db/index.ts` | D1 database binding |
| `getR2(locals)` | `src/lib/r2.ts` | R2 bucket binding — throws if missing |
| `getR2Optional(locals)` | `src/lib/r2.ts` | R2 bucket binding — returns `undefined` |
| `getStripe(locals)` / `getStripeFromLocals(locals)` | `src/lib/stripe.ts` | Stripe client |
| `getStreamApiKey(locals)` / `getStreamAppId(locals)` | `src/lib/stream.ts` | Stream.io credentials |

**Rationale:**
- `env.ts` centralizes the `locals.runtime?.env?.X || process.env.X` dev-fallback pattern (previously duplicated across ~75 sites).
- Single choke-point for future binding changes (e.g., the Stripe SDK v22 upgrade requires an apiVersion change — touching one file, not 95).
- Enables lint/grep enforcement. Verification: `grep -rn "locals\.runtime\?\.env" src/` should return only helper files.

**Example (OAuth endpoint):**

```ts
// ❌ WRONG — direct access with inline fallback
const clientId = locals.runtime?.env?.GITHUB_CLIENT_ID || process.env.GITHUB_CLIENT_ID;
const clientSecret = locals.runtime?.env?.GITHUB_CLIENT_SECRET || process.env.GITHUB_CLIENT_SECRET;
if (!clientId || !clientSecret) {
  return Response.json({ error: 'OAuth not configured' }, { status: 500 });
}

// ✅ CORRECT — helper with unified error handling
import { requireEnv } from '@lib/env';

let clientId: string;
let clientSecret: string;
try {
  clientId = requireEnv(locals, 'GITHUB_CLIENT_ID');
  clientSecret = requireEnv(locals, 'GITHUB_CLIENT_SECRET');
} catch {
  return Response.json({ error: 'OAuth not configured' }, { status: 500 });
}
```

**Test mock rule:** When refactoring a file that is mocked in tests, grep for `vi.mock('@/lib/<mocked>')` and extend the mock surface to include any newly imported helpers. Partial mocks break silently.

---

## Git Workflow

- `main` - Primary development branch
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Use `/r-commit` for standardized commits

---

## Conventions

### Machine Names

When documenting machine-specific behavior, use these standardized names:

| Machine | Standard Name | Hostname |
|---------|---------------|----------|
| Mac Mini M4 Pro (64GB) | `MacMiniM4-Pro` | `Jamess-Mac-mini.local` |
| Mac Mini M4 (24GB) | `MacMiniM4` | `Livings-Mac-mini.local` |

Both machines have identical, full capabilities.

**Why standardize?** Session files (learnings, dev logs, decisions) are scanned for these names to flag updates needed to `docs/as-designed/devcomputers.md`.

**Full machine details:** See `docs/as-designed/devcomputers.md`

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

Run `/r-docs` at end of conv to check for stale documentation.

---

## Related Documentation

- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Command reference
- [API-REFERENCE.md](API-REFERENCE.md) - API & database patterns
- [CLI-MISC.md](CLI-MISC.md) - Setup & installation
