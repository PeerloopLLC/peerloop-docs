# Implementation Plan: Role Flag Removal (is_creator, is_student_teacher)

**Session:** 162
**Date:** 2026-02-02
**Status:** Planning (not yet implemented)

## Overview

Remove deprecated `is_creator` and `is_student_teacher` flags from codebase, replacing with:
- **Permission checks** → `can_create_courses` / `can_teach_courses`
- **State checks** → Derived from `courses` / `student_teachers` tables

---

## Phase 1: Core Types & Mock Data

### `src/lib/db/types.ts`
- [ ] Remove `is_creator` from User interface (line ~39)
- [ ] Remove `is_student_teacher` from User interface (line ~38)
- [ ] Update `getUserRoles()` function to derive from capabilities
- [ ] Update `hasRole()` function

### `src/lib/mock-data.ts`
- [ ] Remove `is_creator` from User type definition
- [ ] Remove `is_student_teacher` from User type definition
- [ ] Remove these fields from all mock user objects (9 users)
- [ ] Update helper functions that filter by these flags

### `src/lib/current-user.ts`
- [ ] Verify `isCreatorFor(courseId)` already checks courses table
- [ ] Verify `isStudentTeacherFor(courseId)` already checks student_teachers
- [ ] Add `hasCreatedCourses()` method (any course, not specific)
- [ ] Add `isActiveStudentTeacher()` method (any course, not specific)

---

## Phase 2: Auth Endpoints (Critical Path)

### `src/pages/api/auth/register.ts`
- [ ] Remove `is_creator` from INSERT statement
- [ ] Remove `is_student_teacher` from INSERT statement
- [ ] Remove these from response object
- [ ] Add `canCreateCourses: false` to response (capability)

### `src/pages/api/auth/login.ts`
- [ ] Remove `is_creator` from response
- [ ] Remove `is_student_teacher` from response
- [ ] Derive `isCreator` from courses table for response
- [ ] Derive `isStudentTeacher` from student_teachers table

### `src/pages/api/auth/session.ts`
- [ ] Same changes as login.ts

### `src/pages/api/auth/github/callback.ts`
- [ ] Remove from INSERT statement
- [ ] Remove from user creation defaults

### `src/pages/api/auth/google/callback.ts`
- [ ] Remove from INSERT statement
- [ ] Remove from user creation defaults

---

## Phase 3: Creator Endpoints

### `src/pages/api/creators/index.ts` (Browse Creators)
**Current:** `WHERE u.is_creator = 1`
**New:** Derive from courses table
```sql
WHERE EXISTS (SELECT 1 FROM courses c WHERE c.creator_id = u.id AND c.deleted_at IS NULL)
```

### `src/pages/api/creators/[handle].ts` (Creator Profile)
**Current:** `WHERE handle = ? AND is_creator = 1`
**New:**
```sql
WHERE handle = ?
  AND EXISTS (SELECT 1 FROM courses c WHERE c.creator_id = u.id AND c.deleted_at IS NULL)
```
- [ ] Remove `is_creator` from response, add derived flag

### `src/pages/api/creators/[id]/courses.ts`
**Current:** `WHERE (id = ? OR handle = ?) AND is_creator = 1`
**New:** Same pattern as above

---

## Phase 4: /me/* Endpoints (User's Own Data)

### `src/pages/api/me/creator-dashboard.ts`
**Current:** `SELECT is_creator FROM users` + check `is_creator`
**New:** Check `can_create_courses = 1 OR has_courses`
```sql
SELECT can_create_courses,
       EXISTS (SELECT 1 FROM courses WHERE creator_id = ?) as has_courses
FROM users WHERE id = ?
```
- [ ] Allow access if either is true

### `src/pages/api/me/creator-analytics.ts` (and sub-endpoints)
- [ ] Same pattern as creator-dashboard
- [ ] Files: sessions.ts, enrollments.ts, st-performance.ts, courses.ts, progress.ts, funnel.ts

### `src/pages/api/me/courses/index.ts`
**Creating course (POST):** Check `can_create_courses = 1` only
**Listing courses (GET):** Check `can_create_courses = 1 OR has_courses`

### `src/pages/api/me/instructor-feed.ts`
- [ ] Check `can_create_courses = 1` for enabling feed
- [ ] Or: derive from has_courses (creators with courses can have feeds)

### `src/pages/api/me/settings.ts`
- [ ] Remove `is_creator` and `is_student_teacher` from SELECT
- [ ] Remove from response
- [ ] Add derived flags or capability flags as needed

### `src/pages/api/me/availability.ts`
**Current:** `if (!user.is_student_teacher && !user.is_creator)`
**New:** Check if user is active ST OR has created courses
```sql
WHERE can_create_courses = 1
   OR EXISTS (SELECT 1 FROM courses WHERE creator_id = ?)
   OR EXISTS (SELECT 1 FROM student_teachers WHERE user_id = ? AND is_active = 1)
```

### `src/pages/api/me/payouts/request.ts`
- [ ] Similar pattern - must be ST or Creator to request payouts

---

## Phase 5: User/Admin Endpoints

### `src/pages/api/users/index.ts`
- [ ] Update role filter: `case 'creator'` to use derived check
- [ ] Remove `is_creator` from SELECT
- [ ] Derive in response transformation

### `src/pages/api/users/[handle].ts`
- [ ] Remove from response, derive instead

### `src/pages/api/admin/users/index.ts`
- [ ] Update role filter
- [ ] Remove from INSERT statement
- [ ] Remove from response

### `src/pages/api/admin/users/[id].ts`
- [ ] Remove from allowed update fields
- [ ] Derive for response

### `src/pages/api/admin/analytics/users.ts`
- [ ] Update creator count queries to use courses table
- [ ] Update student-teacher counts to use student_teachers table

### `src/pages/api/admin/analytics/courses.ts`
- [ ] Update creator queries

### `src/pages/api/admin/courses/index.ts`
**Current:** Check `is_creator` before creating course for user
**New:** Check `can_create_courses = 1`

---

## Phase 6: Other Endpoints

### `src/pages/api/leaderboard.ts`
- [ ] Remove from SELECT and response
- [ ] Derive `is_creator` and `is_student_teacher` with subqueries

### `src/pages/api/stripe/connect.ts`
**Current:** `if (!user.is_creator && !user.is_student_teacher)`
**New:** Derive from tables - must have courses OR be active ST

### `src/pages/api/student-teachers/[id]/availability.ts`
- [ ] Update teacher validation

### `src/pages/api/feeds/instructor/[handle].ts`
- [ ] Update instructor lookup to use derived state

### `src/pages/api/homework/[id]/submissions/index.ts`
### `src/pages/api/homework/[id]/submissions/[subId].ts`
- [ ] Update permission checks

---

## Phase 7: SSR Loaders

### `src/lib/ssr/loaders/creators.ts`
- [ ] Update `WHERE is_creator = 1` to derived check
- [ ] Update response transformation

### `src/lib/ssr/loaders/home.ts`
- [ ] Update featured creators query

### `src/lib/ssr/loaders/teachers.ts`
- [ ] Already uses `student_teachers` table (good!)
- [ ] Verify no `is_student_teacher` references remain

---

## Phase 8: Components

### Layout Components
- `src/components/layout/Header.tsx`
- `src/components/layout/AppHeader.tsx`
- [ ] Update User interface
- [ ] Update dashboard link logic to use capabilities

### Profile Components
- `src/components/profile/UserProfile.tsx`
- `src/components/profile/UserProfileHeader.tsx`
- `src/components/profile/UserProfileQuickLinks.tsx`
- [ ] Update ProfileData interface
- [ ] Update role badge derivation

### Admin Components
- `src/components/admin/UserDetailContent.tsx`
- `src/components/admin/UsersAdmin.tsx`
- [ ] Update role display

### Other Components
- `src/components/leaderboard/Leaderboard.tsx`
- `src/components/context-actions/registry.ts`
- `src/components/context-actions/types.ts`
- `src/components/context-actions/ContextActionsPanel.tsx`
- `src/components/auth/LoginForm.tsx`
- `src/components/settings/NotificationSettings.tsx`

---

## Phase 9: Tests (Last)

~40 test files reference these flags. Update after source code is stable.

---

## SQL Helper Patterns

### Check if user has created courses
```sql
EXISTS (SELECT 1 FROM courses WHERE creator_id = ? AND deleted_at IS NULL)
```

### Check if user is active ST
```sql
EXISTS (SELECT 1 FROM student_teachers WHERE user_id = ? AND is_active = 1)
```

### Derived flag in SELECT
```sql
SELECT
  u.*,
  (SELECT COUNT(*) > 0 FROM courses c WHERE c.creator_id = u.id AND c.deleted_at IS NULL) as is_creator,
  (SELECT COUNT(*) > 0 FROM student_teachers st WHERE st.user_id = u.id AND st.is_active = 1) as is_student_teacher
FROM users u
```

### Combined access check (dashboard)
```sql
WHERE u.can_create_courses = 1
   OR EXISTS (SELECT 1 FROM courses WHERE creator_id = u.id AND deleted_at IS NULL)
```

---

## Notes

1. **Performance:** Subqueries are efficient for single-user lookups. For listings, may need JOINs with DISTINCT.

2. **Response Compatibility:** Components expect `is_creator` in responses. During migration, derive it so responses don't break.

3. **Order of Operations:**
   - Core types first (breaks compile)
   - Auth endpoints (critical path)
   - /me/* endpoints (user-facing)
   - Admin endpoints
   - Components
   - Tests last

4. **Commit Strategy:** Consider committing in phases to keep PRs reviewable.
