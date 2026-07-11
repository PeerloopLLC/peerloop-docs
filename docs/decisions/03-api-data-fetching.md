> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 3. API & Data Fetching (Medium-High Impact)

### Role-Aware Multi-Scope Endpoints Accept Caller-Declared `?scope=...` Query Param
**Date:** 2026-05-20 (Conv 165)

When a single endpoint serves multiple scopes that map to different UI surfaces (e.g., `GET /api/courses/[id]/sessions` serving student / teacher / admin perspectives), the *caller* declares intent via `?scope=student|teacher|all`. Server returns 403 if the caller lacks the role required for the requested scope. Omitted scope keeps a "highest-privilege precedence" default for backwards-compat.

**Rationale:** Server-side precedence alone breaks for dual-role users (e.g., a teacher who is also enrolled in the same course): the standard student tab and a new teacher tab would both hit the same endpoint and return the same (highest-privilege) data, defeating the point. Caller-declared intent disambiguates at the API boundary instead of letting the bug propagate into UI components. Adding the param early (before call sites multiply) keeps the precedence default contained to "backwards-compat" semantics rather than "the only behavior."

**Consequences:** New role-aware endpoints in [CRT-4] (creator/admin/moderator scopes) and [CRT-5] (resources/learn/feed tabs) inherit the same shape. Existing callers without explicit scope still work via default. New UI tabs MUST pass the scope they represent; legacy student-tab fetch will need explicit `scope=student` in [CRT-4]/[CRT-5] when dual-role users surface.

**See:** `src/pages/api/courses/[id]/sessions.ts` (reference impl), `tests/api/courses/[id]/sessions.test.ts` (10 scope-branch + dual-role + invalid-scope tests)

### Enrollment Self-Healing: Two-Surface Fallback for Missed Webhooks
**Date:** 2026-03-04 (Session 324)

Enrollment creation logic extracted from the Stripe webhook into shared `src/lib/enrollment.ts`. Self-healing triggers on two surfaces: (1) `/course/[slug]/success.astro` calls `createEnrollmentFromCheckout` directly in SSR when enrollment not found but `session_id` exists, (2) `/courses` dashboard checks localStorage for pending Stripe sessions on mount and calls `POST /api/stripe/verify-checkout`. Follows the same self-healing pattern as `GET /api/stripe/connect-status` (Session 223).

**Rationale:** Webhooks are unreliable when `stripe listen` isn't running (staging, client dev). The success page covers 99% of cases; localStorage bridge covers the edge case where the user skips the success page.

**See:** `src/lib/enrollment.ts`, `src/pages/api/stripe/verify-checkout.ts`, `src/pages/course/[slug]/success.astro`

---

### 4-Layer Data Fetching Architecture
**Date:** 2025-12-29

1. **Layer 1:** SSR + 5min cache for public pages (fast, SEO-optimized)
2. **Layer 2:** CSR overlay for personalization (non-blocking)
3. **Layer 3:** SSR + auth for user-specific pages (dashboards)
4. **Layer 4:** Hybrid admin (dedicated routes + Context Actions)

**Documented in:** `docs/as-designed/data-fetching.md`

### SSR Pattern for Data Fetching
**Date:** 2025-12-29

Fetch in Astro frontmatter; pass to React components as props. Components are "dumb" - just render data, no client-side fetching.

**Rationale:** Better SEO, faster initial load, simpler components.

### No Mock-Data Fallback in APIs
**Date:** 2025-12-29

APIs return 503 when D1 unavailable. No silent fallback to mock data.

**Rationale:** Fallback hides real configuration problems; false confidence in tests; fail fast is better.

### D1 Health Check Endpoint
**Date:** 2025-12-29

`/api/health/db` endpoint testing D1 connectivity, latency, table count.

**Rationale:** Explicit connectivity check useful for CI/CD and debugging.

### Server-Side Feed Operations (Proxy Pattern)
**Date:** 2026-01-19

Proxy all Stream.io feed operations through server API endpoints (`/api/feeds/townhall`) using the API secret, rather than client-side SDK with user tokens.

**Rationale:** Feed policies UI not available in Stream v2 dashboard; server-side is more secure (API secret never exposed); allows enforcing our own auth and business logic; simplifies client code (just fetch from our API); pattern scales well to other feeds.

**See:** `src/pages/api/feeds/townhall.ts`, `src/pages/api/feeds/townhall/reactions.ts`

### Stream REST API Path-Based Endpoints
**Date:** 2026-01-20

Use path-based endpoints for Stream.io reaction filtering, NOT query parameters:
- By activity: `/reaction/activity_id/{activity_id}/{kind}/`
- By reaction: `/reaction/reaction_id/{reaction_id}/{kind}/`
- By user: `/reaction/user_id/{user_id}/{kind}/`

**Rationale:** Query parameter filtering (`/reaction/?activity_id=xxx`) silently fails and returns ALL reactions. Path-based endpoints are the correct REST API format.

**See:** `src/lib/stream.ts` `StreamReactions.filter()` method

### Auth/Validation Before External Service Checks
**Date:** 2026-01-28

Endpoints should check authentication and validation (resource exists, user enrolled, etc.) BEFORE checking if external services (R2, Stripe) are available.

**Correct order:**
1. Auth check → 401 Unauthorized
2. Resource validation → 403 Forbidden, 404 Not Found
3. External service check → 503 Service Unavailable
4. Perform operation

**Rationale:**
- More efficient: don't check R2 for requests that will fail auth anyway
- Better UX: users get meaningful errors (401, 403, 404) before infrastructure errors (503)
- Easier to test: tests don't need R2/Stripe mocks for auth/validation tests

**See:** `src/pages/api/resources/[id]/download.ts`, Session 135 Decisions

### Transactional vs Notification Email Pattern
**Date:** 2026-02-21 (Session 237)

Two distinct email paths in `src/lib/email.ts`:
- **`sendEmail()`** — Transactional: always sends (receipts, enrollment confirmations, password resets). User took an explicit action and expects confirmation.
- **`sendEmailToUser()`** — Notification: checks user's preference columns before sending (session reminders, course updates, marketing). User can opt out.

**Rationale:** Transactional emails are legally and experientially expected — suppressing them breaks trust. Notification emails are optional by nature. The two-function API makes the distinction explicit at the call site.

**See:** `src/lib/email.ts`, `src/pages/api/webhooks/stripe.ts` (enrollment confirmation)

### Recommendation Scoring: 80/20 Category-to-Tag Weighting
**Date:** 2026-02-22 (Session 259)

Course recommendations use a two-signal scoring algorithm: category match = 80 points (from `user_topic_interests` → `topics.category_id` → `courses.category_id`), tag overlap = `MIN(match_count, 5) * 4` points (max 20, from `user_interests.tag` ↔ `course_tags.tag`). Courses with zero score are excluded. Backfill with popular courses when personalized results < limit.

**Rationale:** Category selection during onboarding is an explicit intent signal; tags are a weaker, granular signal. The 80/20 split ensures a course in the user's interested category always outranks one matched by tags alone. The cap at 5 matching tags prevents courses with many tags from gaming the score.

> **Insight:** The two-signal approach with a dominant primary signal is a common pattern in recommendation systems (e.g., YouTube's candidate generation vs ranking stages). It avoids the cold-start problem that pure collaborative filtering faces — we always have the onboarding signal, even for new users with no interaction history. (Session 259)

**See:** `src/pages/api/recommendations/courses.ts`

### Creator Content APIs Under `/api/me/communities`
**Date:** 2026-02-23 (Session 270)

Creator community and progression CRUD endpoints live under `/api/me/communities`, matching the existing `/api/me/courses` pattern. Public read endpoints remain at `/api/communities/`. Progression endpoints nest at `/api/me/communities/[slug]/progressions/`.

**Rationale:** `/api/me/` already means "resources owned by the authenticated user." Keeps creator writes separate from public reads without new conventions.

**See:** `src/pages/api/me/communities/`

### Community Creation Auto-Creates Default Progression
**Date:** 2026-02-23 (Session 270)

`POST /api/me/communities` atomically creates three rows in a single `batch()`: the community, a "General" progression (`badge='standalone'`, `display_order=0`), and the creator membership (`role='creator'`).

**Rationale:** A community with no progressions is useless — courses require a progression. Auto-creating "General" makes the community immediately usable. Atomic batch prevents partial state.

**See:** `src/pages/api/me/communities/index.ts`

### Course Creation Requires `progression_id` (API-Level)
**Date:** 2026-02-23 (Session 270)

`POST /api/me/courses` now requires `progression_id` in the request body (returns 400 if missing). The schema column remains nullable for backward compatibility with existing seed data. The API also auto-increments progression `course_count` and auto-updates badge from `standalone` → `learning_path` when count reaches 2+.

**Rationale:** Enforces the community → progression → course hierarchy at the API level without a breaking schema migration. Existing NULL-progression courses continue to work.

**See:** `src/pages/api/me/courses/index.ts`

### Creator Self-Certification as Teacher via Existing Endpoint
**Date:** 2026-02-25 (Session 282)

Creator self-certification uses the existing `POST /api/me/courses/[id]/teachers` endpoint with a conditional branch: when `body.user_id === creatorId`, skip the enrollment-completion check. After creating the teacher certification record, auto-set `can_teach_courses = 1` on the user so the Teaching nav item appears immediately.

**Rationale:** 10-line branch in existing endpoint vs duplicated logic in a new endpoint. The course ownership check already gates this to the actual creator.

**See:** `src/pages/api/me/courses/[id]/teachers.ts`

### Creator-as-Teacher Payment Split: 85/15 (Not 70/15/15)
**Date:** 2026-02-25 (Session 282)

When the selected teacher is also the course creator (`teacher.user_id === course.creator_id`), keep `instructorType = 'creator_as_instructor'` for the 85/15 split. This avoids a confusing double-split where both `creator_as_author` and `teacher` shares go to the same person.

**Rationale:** Clean single payment record. Creator Dashboard already queries `recipient_type IN ('creator_as_instructor', 'creator_as_author')`, so earnings display correctly without special-case aggregation.

**See:** `src/pages/api/checkout/create-session.ts`

### Feed Activity Avatar Enrichment on Read
**Date:** 2026-03-20 (Conv 023)

All feed GET endpoints (townhall, community, course) enrich Stream.io activities with fresh user avatars from D1 via `enrichActivitiesWithAvatars()`. Single batch query for all unique actors per page, failure swallowed so feeds never break.

**Rationale:** Stream stores activity metadata at write time — older posts have stale/missing `userImage`. Enrichment on read ensures fresh avatars regardless of when the post was created, and handles avatar changes instantly. No Stream API modifications needed.

**See:** `src/lib/feed-activity.ts`, `src/pages/api/feeds/townhall.ts`

### Client-Side Role Annotation via CurrentUser
**Date:** 2026-03-27 (Conv 039)

For features needing per-course role detection (e.g., role badges, role-filtered views), annotate courses on the client using CurrentUser's O(1) Map lookups rather than creating new API endpoints. The `/api/me/full` response already includes enrollments, teacher certifications, created courses, and moderated course IDs — all accessible via `isStudentFor(id)`, `isTeacherFor(id)`, `isCreatorFor(id)`, `canModerateFor(id)`.

**Rationale:** Adding a server-side role-annotated endpoint would duplicate data already in CurrentUser and add a round-trip. SSR fetches the public catalog; client overlays role data from the singleton.

**See:** `src/components/discover/role-utils.ts`, `src/lib/current-user.ts`

### UserFeedLink Carries Primitives, Not UI Types
**Date:** 2026-03-28 (Conv 043)

When extending `UserFeedLink` with role data for the explore feeds layer, use simple primitives (`parentId: string`, `roles: string[]`) rather than `RoleBadgeConfig[]`. The explore layer converts to UI badge types via `feed-role-utils.ts`.

**Rationale:** Avoids circular dependency between core `current-user.ts` and UI `explore/types.ts`. Keeps the CurrentUser data model presentation-agnostic — all consumers get role data without importing UI types. Backward-compatible since existing FeedsHub/MyFeeds ignore the new fields.

**See:** `src/lib/current-user.ts` (`UserFeedLink`, `getFeeds()`), `src/components/discover/feed-role-utils.ts`

### parseBody Utility for Consistent JSON Error Handling
**Date:** 2026-04-06 Conv 087

Created `src/lib/request.ts` with `parseBody<T>()` that wraps `request.json()` in try/catch and throws `Response(400)` on parse failure. Applied across ~34 POST/PUT/PATCH/DELETE handlers. Outer catch blocks use `if (error instanceof Response) return error;` to propagate typed error responses. Exception: `reset-password.ts` intentionally avoids it (security: always returns 200 to prevent email enumeration).

**Rationale:** Audit found ~35 unguarded `request.json()` calls returning 500 on malformed JSON. A shared utility eliminates the repetitive try/catch pattern while the `instanceof Response` check integrates cleanly with existing error handling.

> **Insight:** The `instanceof Response` pattern for propagating typed HTTP errors through catch blocks lets utilities throw the exact response the client should receive, while generic error handlers still produce 500s. This avoids the "error code enum" anti-pattern.

**See:** `src/lib/request.ts`

### Dashboard Error Suppression: Log Don't Fail
**Date:** 2026-04-06 Conv 087

Dashboard endpoints use `.catch(() => [])` for resilience — if one of 12 parallel queries fails, the dashboard renders with partial data rather than returning 500. Added `console.error` to all 16 catch handlers across teacher-dashboard, creator-dashboard, and teacher-sessions so failures are visible in logs without breaking the resilience pattern.

**Rationale:** Showing partial data is better UX than a 500 error page. But silent failures hide bugs — logging makes them discoverable.

### SSR Loader Naming: fetchCourseTabData vs fetchCourseDetailData
**Date:** 2026-04-18 Conv 130 (superseded Conv 131)

When adding a new SSR loader to `src/lib/ssr/loaders/courses.ts`, the name `fetchCourseTabData` was chosen over `fetchCourseDetailData` because the latter already existed with a different return type (mock-data `Course` object with no enrollment context). Using a distinct name prevents call-site confusion and silent type mismatches.

**Conv 131 update:** The older `fetchCourseDetailData()` (200 lines, mock-data return type) was found to be fully orphaned after the Conv 130 migration and was deleted along with its 8-test CDET describe block. Naming collision no longer exists; the original lesson about grepping for existing function names before adding new loaders still applies.

**Rationale:** Always grep for existing function names before adding new loaders to shared files. Where a similarly-named function exists with a different shape, prefer a distinctive name that makes the distinction explicit at call sites.

---

### Server-Side Availability Validation on Booking
**Date:** 2026-04-06 Conv 088

`POST /api/sessions` now validates that the requested booking time falls within the teacher's availability window. New `isSlotWithinAvailability()` utility in `src/lib/availability.ts` checks recurring rules, day-of-week, timezone conversion, and overrides. Returns 400 with descriptive reason when booking is outside availability.

**Rationale:** Server-side validation prevents impossible bookings. The utility is reusable and mirrors the existing `countAvailableSlots()` algorithm.

---

### "Available Soon" Course Filter Uses an Exact-Lazy Batch-Boolean Endpoint; Window Reuses `availability_window_days` → 14 (CAF, Conv 387)
**Date:** 2026-07-11 (Conv 387)

The `/courses` browse filter "courses with a teacher available within N days" is computed **exact and lazy** via a new public `POST /api/courses/availability-batch {ids} → {windowDays, availability}` (cap 50, short-circuits per course at the first teacher with `totalSlots>0` via `countAvailableSlots`), returning a **boolean map** `{courseId: hasAvailability}` rather than a pre-filtered list — so availability composes with the existing in-memory level/topic/search filters. SSR is untouched; `CoursesCatalog.tsx` fetches on toggle and caches the map (v1 has **no KV cache**). Chosen over a cheap-but-approximate proxy JOIN (over-counts fully-booked teachers) and a denormalized precompute (new table + cron, multi-conv). The admin-configurable window **reuses the existing `platform_stats.availability_window_days` key** (default changed 30/28 → **14**) via a new `lib/availability-config.ts` loader (mirrors `lib/promotion/config.ts`), shared with the course-detail `availability-summary.ts` preview; admin edits go through `GET/POST /api/admin/availability-config` + a new `/admin/availability-settings` page.

**Rationale:** The user accepting latency ("won't mind waiting for an answer") removes the exact-lazy option's only downside and reframes the alternatives — accuracy is the thing worth waiting for (kills the proxy), and the precompute exists only to avoid a wait the user accepts (de-justified); it also respects the codebase's deliberate "defer availability to lazy fetches" decision (no SSR hot-path regression) and lets v1 drop the cache. Reusing the window key means "what you filter by = what you see on the detail page" — one availability-window concept. Consequence: the detail preview also moves 30→14, and the seed change only affects fresh DBs (existing staging keeps 30 until an admin sets it via the new UI, no SQL needed).

---

