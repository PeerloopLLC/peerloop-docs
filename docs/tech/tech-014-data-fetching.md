# tech-014-data-fetching.md

**Topic:** Data Fetching Architecture
**Status:** CONFIRMED
**Decision Date:** 2025-12-29

---

## Overview

PeerLoop uses a layered data fetching architecture optimized for:
- **Fast public pages** with SEO optimization
- **Personalization** for logged-in users without blocking initial render
- **Real-time data** for user-specific and admin pages

---

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                 LAYER 1: PUBLIC PAGES (SSR + Cache)          │
│  Course browse, Course detail, Creators, Homepage            │
│  → Fetch from API server-side in .astro files                │
│  → Cache at edge (Cloudflare) for 5 min                      │
│  → SEO optimized, fast TTFB                                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│           LAYER 2: PERSONALIZATION (CSR overlay)             │
│  Small React components that hydrate after page load         │
│  → Check auth via /api/auth/session                          │
│  → Show: "You're enrolled", "Welcome back", progress bars    │
│  → Doesn't block initial render                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│            LAYER 3: USER PAGES (SSR + Auth required)         │
│  Dashboard, My Enrollments, Settings, Booking                │
│  → Check auth server-side, redirect if not logged in         │
│  → No caching (user-specific)                                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              LAYER 4: ADMIN (Hybrid approach)                │
│  Dedicated /admin/* routes + inline edit buttons             │
│  → /admin dashboard for users, payouts, moderation           │
│  → Inline "Edit" on course/creator pages (admin only)        │
│  → Real-time data, no caching                                │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Access Matrix

| Data Type | Public | Logged In | Admin | Caching |
|-----------|--------|-----------|-------|---------|
| Course listings | ✅ | ✅ | ✅ (+ inactive) | 5 min |
| Course details | ✅ | ✅ | ✅ (+ edit) | 5 min |
| Creator profiles | ✅ | ✅ | ✅ (+ edit) | 5 min |
| Homepage content | ✅ | ✅ | ✅ | 5 min |
| User's enrollments | ❌ | ✅ (own) | ✅ (all) | None |
| User's progress | ❌ | ✅ (own) | ✅ (all) | None |
| User's dashboard | ❌ | ✅ | N/A | None |
| Session bookings | ❌ | ✅ (own) | ✅ (all) | None |
| All users | ❌ | ❌ | ✅ | None |
| Payouts/earnings | ❌ | ✅ (own) | ✅ (all) | None |

---

## Implementation Patterns

### Layer 1: Public Pages (SSR)

Fetch data in `.astro` files, pass as props to React components:

```astro
---
// src/pages/courses/index.astro
const response = await fetch(`${Astro.url.origin}/api/courses`);
const { items: courses } = await response.json();
---

<Layout>
  <CourseBrowse courses={courses} client:load />
</Layout>
```

**Caching:** Set cache headers in API responses or use Cloudflare Page Rules.

### Layer 2: Personalization (CSR Overlay)

Small components that check auth after hydration:

```tsx
// src/components/courses/EnrollmentStatus.tsx
export function EnrollmentStatus({ courseId }: { courseId: string }) {
  const [status, setStatus] = useState<'loading' | 'enrolled' | 'not-enrolled'>('loading');

  useEffect(() => {
    fetch('/api/auth/session')
      .then(res => res.json())
      .then(data => {
        if (!data.authenticated) {
          setStatus('not-enrolled');
          return;
        }
        // Check enrollment
        return fetch(`/api/enrollments/check?courseId=${courseId}`);
      })
      .then(res => res?.json())
      .then(data => setStatus(data?.enrolled ? 'enrolled' : 'not-enrolled'));
  }, [courseId]);

  if (status === 'loading') return null; // Don't block render
  if (status === 'enrolled') return <Badge>You're enrolled</Badge>;
  return null;
}
```

**Key principle:** Return `null` during loading to avoid layout shift.

### Layer 3: User Pages (SSR + Auth)

Check auth server-side in `.astro` files:

```astro
---
// src/pages/dashboard/index.astro
import { getSession } from '@lib/auth';

const session = await getSession(Astro.cookies, Astro.locals.runtime?.env?.JWT_SECRET);

if (!session) {
  return Astro.redirect('/login?redirect=/dashboard');
}

const enrollments = await fetch(`${Astro.url.origin}/api/enrollments`, {
  headers: { Cookie: Astro.request.headers.get('cookie') || '' }
}).then(r => r.json());
---

<AppLayout user={session.user}>
  <Dashboard enrollments={enrollments} client:load />
</AppLayout>
```

### Layer 4: Admin (Hybrid)

**Dedicated routes** for admin-specific views:
- `/admin` - Dashboard with KPIs
- `/admin/users` - User management
- `/admin/payouts` - Payout processing
- `/admin/moderation` - Content moderation queue

**Inline controls** on public pages (admin only):
```tsx
// In CourseDetail.tsx
{isAdmin && (
  <Button href={`/admin/courses/${course.id}/edit`}>
    Edit Course
  </Button>
)}
```

---

## API Endpoint Auth Patterns

| Endpoint Pattern | Auth Required | Notes |
|------------------|---------------|-------|
| `GET /api/courses` | No | Public listing |
| `GET /api/courses/:slug` | No | Public detail |
| `GET /api/enrollments` | Yes | User's own enrollments |
| `GET /api/admin/*` | Yes (admin) | Admin-only data |
| `POST /api/*` | Yes | All mutations require auth |

---

## Component Migration Plan

Current components importing from `mock-data.ts`:

| Component | Migration |
|-----------|-----------|
| `CourseBrowse.tsx` | Receive `courses` as prop from .astro |
| `CourseDetail.tsx` | Receive `course` as prop from .astro |
| `CreatorBrowse.tsx` | Receive `creators` as prop from .astro |
| `CreatorProfile.tsx` | Receive `creator` as prop from .astro |
| `FeaturedCourses.tsx` | Receive `courses` as prop from .astro |
| `FeaturedCreators.tsx` | Receive `creators` as prop from .astro |
| `HeroSection.tsx` | Receive `stats` as prop from .astro |
| `Testimonials.tsx` | Receive `testimonials` as prop from .astro |

**New personalization components to create:**
- `EnrollmentStatus.tsx` - "You're enrolled" badge
- `WelcomeBack.tsx` - Homepage personalization
- `ContinueLearning.tsx` - Resume course CTA

---

## Context Actions Component

A single component that provides role-aware, page-aware actions for privileged users.

### Design Decisions

| Decision | Choice |
|----------|--------|
| Trigger | Icon only (for now) |
| Quick actions | Allowed, page refresh if data changes |
| AI actions | Post-MVP, shown as "Planned" |
| Multiple roles | Multiple sections in dropdown |

### Visual Design

```
┌─────────────────────────────────────────────────────────────┐
│  COURSE DETAIL PAGE                                    [⚙️] │
└─────────────────────────────────────────────────────────────┘
                                                           │
                                                           ▼
                               ┌─────────────────────────────────────┐
                               │  AS ADMIN                           │
                               │  ───────────────────────────────    │
                               │  ✏️  Edit Course              →     │
                               │  📊  View All Stats           →     │
                               │  ⭐  Feature Course           ⟳     │ ← quick action
                               │  🚫  Deactivate               →     │
                               │                                     │
                               │  AS CREATOR                         │
                               │  ───────────────────────────────    │
                               │  💰  View Earnings            →     │
                               │  📢  Send Announcement        →     │
                               │                                     │
                               │  AI ACTIONS (Planned)               │
                               │  ───────────────────────────────    │
                               │  🤖  Improve description      🔒    │
                               │  🤖  Generate FAQ             🔒    │
                               └─────────────────────────────────────┘

Legend:
  →  = Navigate to page
  ⟳  = Quick action (API call + refresh)
  🔒 = Planned (coming soon)
```

### Action Types

| Type | Behavior | Example |
|------|----------|---------|
| `navigate` | Go to URL | Edit Course → `/admin/courses/{id}/edit` |
| `quick` | API call + page refresh | Feature Course → `POST /api/admin/courses/{id}/feature` |
| `planned` | Disabled, shows "Coming soon" | AI actions |

### Component API

```tsx
<ContextActions
  context={{
    type: 'course',           // page type
    id: course.id,            // entity id
    creatorId: course.creator_id,  // for ownership check
  }}
  user={session.user}
/>
```

### Role-Action Matrix

| Page Type | Admin | Creator (owner) | S-T (assigned) |
|-----------|-------|-----------------|----------------|
| **Course** | Edit, Stats, Feature, Deactivate | Edit, Earnings, Announce | My Students, Schedule |
| **Creator Profile** | Edit, Suspend | Edit | - |
| **Student Profile** | Edit, History | - | View Progress |
| **Enrollment** | Refund, Reassign S-T | View | View |

### Ownership Logic

```tsx
function getAvailableActions(context, user) {
  const actions = [];

  // Admin actions (always available for admins)
  if (user.is_admin) {
    actions.push({ section: 'As Admin', items: ADMIN_ACTIONS[context.type] });
  }

  // Creator actions (only if they own this entity)
  if (user.is_creator && context.creatorId === user.id) {
    actions.push({ section: 'As Creator', items: CREATOR_ACTIONS[context.type] });
  }

  // S-T actions (only if assigned to this course)
  if (user.is_student_teacher && isAssignedToContext(user.id, context)) {
    actions.push({ section: 'As Student-Teacher', items: ST_ACTIONS[context.type] });
  }

  // AI actions (always shown if any other actions, but disabled)
  if (actions.length > 0) {
    actions.push({ section: 'AI Actions (Planned)', items: AI_ACTIONS, disabled: true });
  }

  return actions;
}
```

### Security Model

1. **Server-side rendering** - Component only rendered if user has at least one action
2. **Not in bundle** - Non-privileged users don't receive the component JS
3. **API validation** - Quick actions validate permissions server-side

---

## References

- Astro Data Fetching: https://docs.astro.build/en/guides/data-fetching/
- Cloudflare Cache: https://developers.cloudflare.com/cache/
