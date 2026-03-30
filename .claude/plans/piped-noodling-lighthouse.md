# ADMIN-INTEL Implementation Plan

## Context

The ADMIN-INTEL block adds contextual admin intelligence to member-facing pages. Admins get "X-ray vision" — pending actions, flags, stats appear right where issues arise, eliminating context-switches to `/admin`. Designed in Conv 055; plan file was ephemeral and lost. Reconstructed in Conv 056 from PLAN.md, DECISIONS.md §10, session files, codebase exploration, and design re-discussion with user.

**⚠️ PERSISTENCE NOTE:** This plan file is ephemeral (`.claude/plans/` is gitignored). Before `/r-end`, persist to `docs/as-designed/admin-intel-plan.md` and commit.

---

## Design Philosophy

**Two complementary admin perspectives:**
- **`/admin` pages (situation-centric):** "I have a situation" → find the people/courses/feeds involved. Tables, filters, queues, bulk actions.
- **Member-side admin content (entity-centric):** "I'm looking at THIS entity" → what needs attention here? What decisions can be made? What actions follow?

The admin content on any member page is **context-driven, not pre-specified.** Each page asks: "What admin knowledge or actions would help an admin who is looking at THIS entity right now?" The answer emerges during implementation per-page.

**Admins are encouraged to use the member side as students/teachers/creators.** The admin overlay gives them X-ray vision while browsing — without leaving the member experience.

## Design Principles (DECISIONS.md §10)

1. **Admin bypasses CourseRole** — don't add `'admin'` to `CourseRole`. Check `currentUser.isAdmin` directly.
2. **Comprehensive API, render what's needed** — Intel endpoints return everything known about an entity from an admin perspective. Components pick what to display. "Leaner" is an optimization task for later.
3. **Single API, variable rendering** — One API call per entity type. Components render compact or full based on the surface. Each admin tab/section shows its full content for its context — no overlap avoidance with other role tabs.
4. **Compact/Full variants** — Same data, different rendering density. Full for detail page tabs and profile sections. Compact for cards, list items, dashboard summaries. The variant is a display prop, not a data distinction.
5. **Admin color: `bg-red-400`** — adjusted if contrast is poor for text. Distinct from student (blue), teacher (green), creator (purple), moderator (amber).
6. **Conditional rendering** — `{isAdmin && <AdminPanel />}` — not rendered at all for non-admins.
7. **Bidirectional navigation** — admin pages link INTO member-side context. Member-side admin panels link INTO admin pages.
8. **AdminBadge** — Round badge like role badges (same size/shape), red, with count. Count provides urgency guidance. A simple "something needs admin attention" indicator — click to find out details from the Admin tab/section.

---

## Critical Architecture Notes

**Tab injection uses `ExtraTabConfig` (string-typed), NOT `DetailTabId` (union-typed):**
- `ExtraTabConfig.id` is `string` — no need to extend `DetailTabId` union
- `ExtraTabConfig.roleColor` is `string` — can pass `'red'` directly, no type hack
- `ExtraTabConfig.content` is `ReactNode` — component renders inline
- Admin tab is injected in `ExploreCourseTabs.tsx` (line 33-51), NOT in `computeRoleTabs()`

**Wiring approach:** Add admin tab directly in `ExploreCourseTabs` after `computeRoleTabs()`, checking `currentUser.isAdmin`. This avoids touching the `CourseRole` type system entirely.

**CONTEXT-ACTIONS-FAB (deferred #37) is deprecated** — superseded by ADMIN-INTEL.

---

## Phase Dependencies

```
Phase 1 (Foundation) ─┬─→ Phase 2 (Course/Community Tabs)
                      ├─→ Phase 3 (Profile Admin Section)
                      ├─→ Phase 5 (Dashboard Admin Section)
                      └─→ Phase 6 (Bidirectional Links)
Phase 3 ──→ Phase 4 (/discover/members uses AdminMemberSummary)
```

Phases 2, 3, 5 can run in parallel after Phase 1. Recommended order: 1→2→3→4→5→6.

---

## PHASE 1: Foundation

### 1A. Admin Color Constants

**Modify:** `src/components/discover/role-utils.ts`

Add after `ROLE_COLORS`:

```ts
/** Admin color palette (not a CourseRole — see DECISIONS.md §10) */
export const ADMIN_COLORS = {
  bg: 'bg-red-400',
  text: 'text-white',
  bgLight: 'bg-red-50',
  textLight: 'text-red-700',
  dot: 'bg-red-400',
  border: 'border-red-300',
} as const;
```

Also add `admin: 'red'` to `roleToColor` maps in:
- `src/components/discover/ExploreCourseTabs.tsx` (line 20-25)
- `src/components/discover/ExploreCommunityTabs.tsx` (equivalent location)

### 1B. Admin Intel Types

**Create:** `src/components/admin-intel/types.ts`

```ts
/** Intel for a course (from GET /api/admin/intel/course/:id) */
export interface CourseIntel {
  courseId: string;
  pendingCertRequests: number;
  flaggedContent: number;
  enrollmentIssues: number;        // disputed status
  cancelledRecent: number;         // cancelled in last 30 days
  totalRevenueCents: number;
  activeStudents: number;          // enrolled + in_progress
  recentFlags: { id: string; reason: string; createdAt: string }[];  // last 5
}

/** Intel for a community (from GET /api/admin/intel/community/:id) */
export interface CommunityIntel {
  communityId: string;
  flaggedPosts: number;
  memberCount: number;
  pendingModeratorInvites: number;
  recentFlags: { id: string; reason: string; createdAt: string }[];  // last 5
}

/** Intel for a user (from GET /api/admin/intel/user/:id) */
export interface UserIntel {
  userId: string;
  accountStatus: 'active' | 'suspended' | 'unverified';
  suspendedAt: string | null;
  roles: {
    isAdmin: boolean;
    isCreator: boolean;
    isTeacher: boolean;
    canModerate: boolean;
  };
  enrollmentCount: number;
  coursesCreated: number;
  studentsTaught: number;
  pendingFlags: number;
  totalEarningsCents: number;
  createdAt: string;
}

/** Lightweight badge data for batch course intel */
export interface CourseIntelBadge {
  courseId: string;
  pendingCount: number;
}

/** Intel for dashboard summary (from GET /api/admin/intel/dashboard) */
export interface DashboardIntel {
  pendingFlags: number;
  pendingCreatorApps: number;
  suspendedUsers: number;
  disputedEnrollments: number;
  inactiveTeacherCerts: number;
}

export type AdminIntelVariant = 'compact' | 'full';
```

### 1C. Admin Intel API Endpoints

All follow the existing admin API pattern: `requireRole(['admin'])` → `getDB()` → `Promise.all` queries → `Response.json()`. Endpoints return comprehensive data; components pick what to display.

**5 endpoint files** (4 from Conv 055 Decision #4 + dashboard):

**Create:** `src/pages/api/admin/intel/course/[id].ts`

```
GET /api/admin/intel/course/:id → { intel: CourseIntel }
```

SQL queries (via Promise.all):
1. `SELECT COUNT(*) as cnt FROM teacher_certifications WHERE course_id = ? AND is_active = 0` → pendingCertRequests
2. `SELECT COUNT(*) FROM content_flags WHERE status = 'pending' AND community_id IN (SELECT p.community_id FROM progressions p JOIN courses c ON c.progression_id = p.id WHERE c.id = ?)` → flaggedContent (courses link to communities via progressions: courses.progression_id → progressions.community_id)
3. `SELECT COUNT(CASE WHEN status = 'disputed' THEN 1 END) as disputed, COUNT(CASE WHEN status = 'cancelled' AND cancelled_at >= strftime('%Y-%m-%dT%H:%M:%fZ', 'now', '-30 days') THEN 1 END) as cancelled FROM enrollments WHERE course_id = ? AND deleted_at IS NULL` → enrollmentIssues + cancelledRecent
4. `SELECT COALESCE(SUM(t.amount_cents), 0) as revenue, COUNT(CASE WHEN e.status IN ('enrolled','in_progress') THEN 1 END) as active FROM enrollments e LEFT JOIN transactions t ON t.enrollment_id = e.id WHERE e.course_id = ? AND e.deleted_at IS NULL` → totalRevenueCents + activeStudents
5. `SELECT id, reason, created_at FROM content_flags WHERE status = 'pending' AND community_id IN (SELECT p.community_id FROM progressions p JOIN courses c ON c.progression_id = p.id WHERE c.id = ?) ORDER BY created_at DESC LIMIT 5` → recentFlags

**Create:** `src/pages/api/admin/intel/community/[id].ts`

```
GET /api/admin/intel/community/:id → { intel: CommunityIntel }
```

SQL queries:
1. `SELECT COUNT(*) FROM content_flags WHERE status = 'pending' AND community_id = ?` → flaggedPosts
2. `SELECT COUNT(*) FROM community_members WHERE community_id = ?` → memberCount
3. `SELECT COUNT(*) FROM moderator_invites WHERE community_id = ? AND status = 'pending'` → pendingModeratorInvites
4. `SELECT id, reason, created_at FROM content_flags WHERE status = 'pending' AND community_id = ? ORDER BY created_at DESC LIMIT 5` → recentFlags

**Create:** `src/pages/api/admin/intel/user/[id].ts`

```
GET /api/admin/intel/user/:id → { intel: UserIntel }
```

SQL queries:
1. User base data + subquery counts:
```sql
SELECT u.id, u.is_admin, u.can_create_courses, u.can_teach_courses, u.can_moderate_courses,
  u.email_verified, u.suspended_at, u.created_at,
  (SELECT COUNT(*) FROM enrollments WHERE student_id = u.id AND deleted_at IS NULL) as enrollment_count,
  (SELECT COUNT(*) FROM courses WHERE creator_id = u.id AND deleted_at IS NULL) as courses_created,
  (SELECT COALESCE(SUM(students_taught), 0) FROM teacher_certifications WHERE user_id = u.id AND is_active = 1) as students_taught
FROM users u WHERE u.id = ? AND u.deleted_at IS NULL
```
2. `SELECT COUNT(*) FROM content_flags WHERE target_user_id = ? AND status = 'pending'` → pendingFlags
3. Earnings: `SELECT COALESCE(SUM(p.amount_cents), 0) FROM payouts p WHERE p.recipient_id = ? AND p.status = 'completed'` → totalEarningsCents

**Create:** `src/pages/api/admin/intel/courses.ts` (BATCH — for list badge overlay)

```
GET /api/admin/intel/courses?ids=id1,id2,id3 → { intel: Record<string, CourseIntelBadge> }
```

Returns badge data (pending count) for multiple courses at once. Used by `/discover/courses` list view to overlay AdminBadge on each card without N individual fetches.

SQL: Single query with `WHERE course_id IN (?, ?, ...)` grouping counts per course.

**Create:** `src/pages/api/admin/intel/dashboard.ts`

```
GET /api/admin/intel/dashboard → { intel: DashboardIntel }
```

SQL queries (all via Promise.all):
1. `SELECT COUNT(*) FROM content_flags WHERE status = 'pending'` → pendingFlags
2. `SELECT COUNT(*) FROM creator_applications WHERE status = 'pending'` → pendingCreatorApps
3. `SELECT COUNT(*) FROM users WHERE suspended_at IS NOT NULL AND deleted_at IS NULL` → suspendedUsers
4. `SELECT COUNT(*) FROM enrollments WHERE status = 'disputed' AND deleted_at IS NULL` → disputedEnrollments
5. `SELECT COUNT(*) FROM teacher_certifications WHERE is_active = 0` → inactiveTeacherCerts

### 1D. AdminBadge Component

**Create:** `src/components/admin-intel/AdminBadge.tsx`

```ts
interface AdminBadgeProps {
  count: number;         // 0 = no badge, >0 = red badge with count
  label?: string;        // tooltip
  size?: 'sm' | 'md';   // sm for cards, md for detail
}
```

Round badge matching the size/shape of existing role badges (see `RoleBadge.tsx`). Uses `ADMIN_COLORS` (`bg-red-400`). Returns `null` when `count === 0`. Count is displayed for urgency guidance — can be upgraded later.

### 1E. AdminLink Helpers

**Create:** `src/components/admin-intel/admin-links.ts`

```ts
type EntityType = 'course' | 'community' | 'user' | 'enrollment' | 'flag' | 'teacher-cert';

export function adminUrlFor(type: EntityType, id: string): string {
  // Maps to admin page URLs with highlight params
}

export function memberUrlFor(type: 'course' | 'community' | 'user', slugOrHandle: string): string {
  // Maps to member-facing URLs
}
```

URL mappings:
- `adminUrlFor('course', id)` → `/admin/courses?highlight=${id}`
- `adminUrlFor('community', id)` → `/admin/moderation?community=${id}`
- `adminUrlFor('user', id)` → `/admin/users?highlight=${id}`
- `adminUrlFor('enrollment', id)` → `/admin/enrollments?highlight=${id}`
- `adminUrlFor('flag', id)` → `/admin/moderation?highlight=${id}`
- `adminUrlFor('teacher-cert', id)` → `/admin/teachers?highlight=${id}`
- `memberUrlFor('course', slug)` → `/discover/course/${slug}`
- `memberUrlFor('community', slug)` → `/discover/community/${slug}`
- `memberUrlFor('user', handle)` → `/@${handle}`

### 1F. useAdminIntel Hook

**Create:** `src/components/admin-intel/useAdminIntel.ts`

```ts
export function useAdminIntel<T>(
  endpoint: string,
  enabled: boolean = true,
): { data: T | null; loading: boolean; error: string | null; refetch: () => void }
```

Short-circuits if `!enabled`. Fetches via `fetch()` in `useEffect`. Same pattern as dashboard data loading in `UnifiedDashboard.tsx`.

### 1G. Barrel Export

**Create:** `src/components/admin-intel/index.ts`

Exports: `AdminBadge`, `useAdminIntel`, `adminUrlFor`, `memberUrlFor`, `ADMIN_COLORS`, and all types.

### 1H. Phase 1 Tests

**Create:** `tests/api/admin/intel/course.test.ts`
- Auth: rejects non-admin (403), allows admin
- Returns correct counts for course with pending certs, flags, disputed enrollments
- Returns zeroes for clean course
- 404 for non-existent course

**Create:** `tests/api/admin/intel/community.test.ts`
- Same pattern: auth, correct counts, zeroes, 404

**Create:** `tests/api/admin/intel/user.test.ts`
- Same pattern: auth, correct role flags, counts, 404

**Create:** `tests/api/admin/intel/courses-batch.test.ts`
- Auth, returns counts for multiple courses, handles empty ids list

**Create:** `tests/api/admin/intel/dashboard-intel.test.ts`
- Same pattern: auth, correct aggregation counts

**Create:** `tests/unit/admin-intel/admin-links.test.ts`
- Pure unit tests: all URL mappings produce expected paths

**Create:** `tests/unit/admin-intel/admin-badge.test.tsx`
- Component renders with count > 0, returns null with count 0, matches role badge sizing

**Test patterns (follow existing):**
- Framework: Vitest
- API tests: `describeWithTestDB()`, `createAPIContext()`, mock auth via `vi.mock('@lib/auth')`
- Component tests: vitest + jsdom, render with React Testing Library
- Seed data: insert users, courses, enrollments, content_flags, teacher_certifications with known states

---

## PHASE 2: Course & Community Admin Tabs

**Design approach:** Content is context-driven. Each tab assesses: "What admin information/actions help in the isolated context of this course/community?" The API returns comprehensive data; the component decides what to show.

### 2A. Admin Course Component

**Create:** `src/components/admin-intel/AdminCourseTab.tsx` (or name TBD during implementation)

```ts
interface AdminCourseTabProps {
  courseId: string;
  courseSlug: string;
  variant: AdminIntelVariant;  // 'full' for detail tab, 'compact' for dashboard/cards
}
```

- Full variant: renders as a tab panel inside ExploreCourseTabs. Shows admin-relevant information about this course in context — what's decided per-page during implementation.
- Compact variant: summary view for use on dashboard or other surfaces.
- Both call the same API: `useAdminIntel<CourseIntel>('/api/admin/intel/course/${courseId}')`.
- Links to admin pages via `adminUrlFor()`.

### 2B. Admin Community Component

**Create:** `src/components/admin-intel/AdminCommunityTab.tsx` (or name TBD)

Same pattern as AdminCourseTab, using `CommunityIntel`.

### 2C. Wire Admin Tab into ExploreCourseTabs

**Modify:** `src/components/discover/ExploreCourseTabs.tsx`

In the `extraTabs` useMemo (line 33-51), after mapping `roleTabs`, append admin tab:

```ts
// Admin tab (DECISIONS.md §10: bypasses CourseRole, uses ExtraTabConfig directly)
if (currentUser?.isAdmin) {
  mapped.push({
    id: 'admin-intel',
    label: 'Admin',
    icon: 'shield-alert',
    roleColor: 'red',
    groupLabel: 'Admin',
    content: <AdminCourseTab courseId={courseId} courseSlug={slug} variant="full" />,
  });
}
```

### 2D. Wire Admin Tab into ExploreCommunityTabs

**Modify:** `src/components/discover/ExploreCommunityTabs.tsx`

Same pattern: append admin tab after community role tabs when `currentUser?.isAdmin`.

### 2E. AdminBadge on List Cards

**Modify:** `src/components/discover/ExploreCard.tsx`

Add optional `adminBadgeCount?: number` prop. Render AdminBadge in card corner when count > 0.

**Modify:** `src/components/discover/ExploreCommunityCard.tsx` — same pattern.

Parent listing pages use batch endpoint (`/api/admin/intel/courses?ids=...`) to fetch badge counts when `currentUser.isAdmin`.

### 2F. Phase 2 Tests

**Create:** `tests/unit/admin-intel/admin-course-tab.test.tsx` — component with mocked fetch
**Create:** `tests/unit/admin-intel/admin-community-tab.test.tsx`

---

## PHASE 3: Profile Admin Section

### 3A. AdminMemberSummary

**Create:** `src/components/admin-intel/AdminMemberSummary.tsx`

```ts
interface AdminMemberSummaryProps {
  userId: string;
  userHandle: string;
  variant: AdminIntelVariant;  // 'full' for profile pages, 'compact' for member cards
}
```

- Full variant: admin section on profile pages. Content is context-driven — what admin information helps when looking at this member.
- Compact variant: summary for member cards in `/discover/members` and elsewhere.
- Uses `useAdminIntel<UserIntel>('/api/admin/intel/user/${userId}')`.

### 3B. Mount on Profile Pages

**Modify:** `src/components/profile/PublicProfile.tsx`

```tsx
{currentUser?.isAdmin && profileData && (
  <AdminMemberSummary userId={profileData.id} userHandle={profileData.handle} variant="full" />
)}
```

**Modify:** `src/components/creators/profiles/CreatorProfile.tsx` — same pattern
**Modify:** `src/components/teachers/profiles/TeacherProfile.tsx` — same pattern

### 3C. Phase 3 Tests

**Create:** `tests/unit/admin-intel/admin-member-summary.test.tsx`

---

## PHASE 4: /discover/members (Admin-Only)

### 4A. Astro Page

**Create:** `src/pages/discover/members.astro`

SSR-level admin check: read session from cookies, query `users.is_admin`, redirect to `/discover` if not admin.

### 4B. DiscoverMembers Component

**Create:** `src/components/discover/DiscoverMembers.tsx`

A listing page resolving to member cards:
- **All members shown by default** (no role pre-filter)
- **Role filter:** Checkboxes for each role (Student, Teacher, Creator, Moderator, Admin) — multi-select
- **Search:** By name (client directive: no member-to-member search, but admin has no such restriction)
- **Member cards:** Display name, handle, avatar, role badges, `AdminMemberSummary` in compact mode
- **Click card →** navigate to `/@[handle]` where full AdminMemberSummary renders
- Fetches from existing `GET /api/admin/users` with search/filter/pagination

### 4C. Add "Find Members" to Discover Slide Panel

**Modify:** `src/components/layout/DiscoverSlidePanel.tsx`

This component currently has no `useCurrentUser()` — it renders a static array. Must:
1. Import `useCurrentUser` from `@/lib/current-user`
2. Call `const currentUser = useCurrentUser()` inside the component
3. Conditionally push "Find Members" entry to `discoverOptions` when `currentUser?.isAdmin`:

```ts
if (currentUser?.isAdmin) {
  discoverOptions.push({
    id: 'members',
    label: 'Members',
    description: 'Browse and manage all platform members',
    href: '/discover/members',
    icon: <ShieldIcon className="h-6 w-6" />,
  });
}
```

This is the first role-gated entry in the slide panel. The admin entry should use `bg-red-400` accent color to be visually distinct from the blue/primary entries. Admin label text uses `bg-red-400` (or adjusted for contrast).

### 4D. Add to Discover Hub Page (Admin-Only Card)

**Modify:** `src/pages/discover/index.astro`

The hub page is SSR-only (no React island). Use SSR admin check: read session from cookies, query `users.is_admin`, conditionally render a "Members" card with red accent in the grid. Consistent with Astro SSR-first pattern.

### 4E. Update url-routing.md

**Modify:** `docs/as-designed/url-routing.md` — add `/discover/members` route (admin-only)

### 4F. Phase 4 Tests

**Create:** `tests/unit/admin-intel/discover-members.test.tsx`

---

## PHASE 5: Dashboard Admin Section

### 5A. Admin Section on /dashboard

**Create:** `src/components/admin-intel/AdminDashboardCard.tsx`

Renders as another role-section on `/dashboard` alongside Learning/Teaching/Creating. Platform health summary for admins — aggregated pending items across all entity types with quick links to act.

Uses `GET /api/admin/intel/dashboard` via `useAdminIntel<DashboardIntel>()`.

Displays:
- Pending flags → link to `/admin/moderation`
- Pending creator apps → link to `/admin/creator-applications`
- Suspended users → link to `/admin/users?status=suspended`
- Disputed enrollments → link to `/admin/enrollments?status=disputed`
- Inactive teacher certs → link to `/admin/teachers?status=pending`

Zero-state: "All clear — no pending items."

### 5B. Mount on Dashboard

**Modify:** `src/components/dashboard/unified/UnifiedDashboard.tsx`

Add as an admin-only section (alongside existing role sections):
```tsx
{currentUser?.isAdmin && <AdminDashboardCard />}
```

### 5C. Phase 5 Tests

**Create:** `tests/unit/admin-intel/admin-dashboard-card.test.tsx`

---

## PHASE 6: Bidirectional Links

### 6A. "View as member →" on Admin Detail Panels

**Modify:** Admin detail components (identify exact files during implementation — likely in `src/components/admin/`)

Add small link using `memberUrlFor()` with admin red color:
```tsx
<a href={memberUrlFor('course', slug)} className="text-sm text-red-600 hover:text-red-700 flex items-center gap-1">
  View as member →
</a>
```

### 6B. "Manage in Admin →" Already Handled

Phases 2-5 components already include admin links via `adminUrlFor()`.

### 6C. Phase 6 Tests

**Create:** `tests/unit/admin-intel/bidirectional-links.test.ts`

---

## Open Questions (to resolve during implementation)

1. **Should `/course/[slug]` also get admin tab, or only `/discover/course/[slug]`?** The discover version has the role-tab system; the non-discover version may not. Single-source component makes this a mount-point decision.
2. **Search in list views:** Admin needs search wherever lists are shown. Filters are useful but search + tags will be more important as content grows. May need a separate SEARCH block.
3. **Component architecture per-phase:** Whether to use one component per entity type with variants, or dedicated components per surface that share the same API — decided during implementation based on what works best.

---

## Deprecated

- **CONTEXT-ACTIONS-FAB (deferred #37):** Superseded entirely by ADMIN-INTEL. Mark as deprecated in PLAN.md.

---

## File Inventory

### New Files (Phase 1): 14 source + 7 test = 21 files
| File | Purpose |
|------|---------|
| `src/components/admin-intel/types.ts` | Type definitions |
| `src/components/admin-intel/AdminBadge.tsx` | Attention indicator (round badge with count) |
| `src/components/admin-intel/admin-links.ts` | URL helpers |
| `src/components/admin-intel/useAdminIntel.ts` | Data fetch hook |
| `src/components/admin-intel/index.ts` | Barrel export |
| `src/pages/api/admin/intel/course/[id].ts` | Course intel endpoint |
| `src/pages/api/admin/intel/community/[id].ts` | Community intel endpoint |
| `src/pages/api/admin/intel/user/[id].ts` | User intel endpoint |
| `src/pages/api/admin/intel/courses.ts` | Batch course intel endpoint |
| `src/pages/api/admin/intel/dashboard.ts` | Dashboard intel endpoint |
| `tests/api/admin/intel/course.test.ts` | Course intel API tests |
| `tests/api/admin/intel/community.test.ts` | Community intel API tests |
| `tests/api/admin/intel/user.test.ts` | User intel API tests |
| `tests/api/admin/intel/courses-batch.test.ts` | Batch course intel tests |
| `tests/api/admin/intel/dashboard-intel.test.ts` | Dashboard intel API tests |
| `tests/unit/admin-intel/admin-links.test.ts` | URL helper unit tests |
| `tests/unit/admin-intel/admin-badge.test.tsx` | Badge component tests |

### Modified Files (Phase 1): 1 file
| File | Change |
|------|--------|
| `src/components/discover/role-utils.ts` | Add `ADMIN_COLORS` constant |

### New Files (Phases 2-6): 6 source + 5 test = 11 files
| File | Phase |
|------|-------|
| `src/components/admin-intel/AdminCourseTab.tsx` | 2 |
| `src/components/admin-intel/AdminCommunityTab.tsx` | 2 |
| `src/components/admin-intel/AdminMemberSummary.tsx` | 3 |
| `src/pages/discover/members.astro` | 4 |
| `src/components/discover/DiscoverMembers.tsx` | 4 |
| `src/components/admin-intel/AdminDashboardCard.tsx` | 5 |

### Modified Files (Phases 2-6): ~12 files
| File | Phase | Change |
|------|-------|--------|
| `src/components/discover/ExploreCourseTabs.tsx` | 2 | Add admin tab + `'red'` to roleToColor |
| `src/components/discover/ExploreCommunityTabs.tsx` | 2 | Add admin tab + `'red'` to roleToColor |
| `src/components/discover/ExploreCard.tsx` | 2 | Add adminBadgeCount prop |
| `src/components/discover/ExploreCommunityCard.tsx` | 2 | Add adminBadgeCount prop |
| `src/components/profile/PublicProfile.tsx` | 3 | Mount AdminMemberSummary |
| `src/components/creators/profiles/CreatorProfile.tsx` | 3 | Mount AdminMemberSummary |
| `src/components/teachers/profiles/TeacherProfile.tsx` | 3 | Mount AdminMemberSummary |
| `src/components/layout/DiscoverSlidePanel.tsx` | 4 | Add `useCurrentUser()`, admin-only "Find Members" entry with red accent |
| `src/pages/discover/index.astro` | 4 | SSR admin check + admin-only "Members" card |
| `src/components/dashboard/unified/UnifiedDashboard.tsx` | 5 | Mount AdminDashboardCard as admin role-section |
| `docs/as-designed/url-routing.md` | 4 | Add /discover/members route |
| Admin detail components (TBD) | 6 | Add "View as member" links |
| `PLAN.md` | — | Mark CONTEXT-ACTIONS-FAB (#37) as deprecated/superseded |

**Totals: ~21 new files, ~13 modified files across all 6 phases.**

---

## Verification Plan

After each phase:
1. Run `cd ../Peerloop && npx tsc --noEmit` — type checking
2. Run phase-specific tests: `npm test -- --testPathPattern="admin-intel"`
3. Run full test suite: `npm test` (capture to `/tmp/test-output.txt`)
4. Manual: start dev server, log in as admin, verify tabs/badges/panels appear
5. Manual: log in as non-admin, verify nothing admin-related renders
