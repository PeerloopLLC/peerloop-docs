# RFC: CD-041 - Course-Level Content Moderation (Course-Moderator Role)

**Status:** Open — proposal, awaiting Pre-Implementation decisions
**Created:** 2026-08-24
**Updated:** 2026-08-24
**Items:** 18
**Completed:** 0

> ⚠️ **Do not start implementation until the Pre-Implementation questions are
> answered.** The stage checklists below assume Option A (extend community-mod
> scope) unless the decision selects Option B; items marked _(B only)_ apply only
> to the dedicated `course_moderators` table.

---

## Pre-Implementation (Unanswered — decide first)

- [ ] Which course content is moderatable? (reviews / discussion posts / homework / Q&A)
- [ ] **Option A** (extend community-mod scope to course content) **or Option B** (dedicated `course_moderators` table)?
- [ ] _(B only)_ Who appoints course moderators — course creator, admin, or both?
- [ ] Does a course moderator get the "Moderator" role label + `/mod` Sidebar item?
- [ ] Rename the misnamed `can_moderate_courses` flag, or keep-and-document?

---

## Stage 1 — Schema (shared by A and B)

- [ ] Extend `content_flags.content_type` CHECK to add the chosen course content type(s)
- [ ] Add nullable `course_id TEXT REFERENCES courses(id) ON DELETE SET NULL` to `content_flags`
- [ ] Index `content_flags(course_id)` for the moderation-queue scope query
- [ ] _(B only)_ Create `course_moderators` table (mirror `community_moderators`: `id, course_id, user_id, appointed_by_user_id, appointed_at, is_active, created_at`)
- [ ] Seed: at least one course-scoped flag + (B) a course-moderator row (dev seed only)

## Stage 2 — Scope logic (`src/lib/auth/moderation.ts`)

- [ ] **Option A:** in `isFlagInScope`, treat a flag's `course_id` as in-scope for a community moderator when that course's community is in their `communityIds` (join course → progression → community)
- [ ] _(B only)_ Add `{ type: 'course'; courseIds: string[] }` to `ModerationScope`
- [ ] _(B only)_ In `requireModerationAccess`, check `course_moderators` after `community_moderators`
- [ ] Confirm `canPerformElevatedAction` stays global-only (course/community mods cannot warn/suspend)

## Stage 3 — Role label + navigation

- [ ] Decide + implement whether course-mod grants the "Moderator" label (`roles.ts userRoles`)
- [ ] If yes: add `is_course_moderator` (or fold into `isModerator`) on `SidebarUser` + `AppLayout` so `/mod` shows for course moderators (gate is already `isModerator || isAdmin` after Conv 441)

## Stage 4 — Moderation console + API

- [ ] `/api/admin/moderation*` queue query includes course-scoped flags for in-scope moderators
- [ ] `/mod` console (`ModerationAdmin` / `ModeratorQueue`) renders course-scoped flags with course context
- [ ] _(B only)_ Appointment endpoints (appoint / revoke course moderator), mirroring `/api/admin/moderators/*`

## Stage 5 — Naming cleanup (optional, if decided)

- [ ] Rename `can_moderate_courses` → chosen name across schema, `auth/session.ts`, `roles.ts`, seed, admin UI, tests
- [ ] Update `roles.ts` doc-comments (the "global vs course" distinction) accordingly

## Stage 6 — Tests

- [ ] Scope tests: course moderator sees only in-scope course flags; cannot warn/suspend
- [ ] `isFlagInScope` unit tests for the course branch (A) or course scope (B)
- [ ] Regression: existing community/global moderation unaffected

---

## Notes

- The Sidebar admin-hide for `/mod` was already removed in Conv 441 (gate
  `isModerator || isAdmin`), so admins see the moderation console link. This RFC
  does not depend on that but benefits from it.
- Current model reference: `src/lib/auth/moderation.ts` (two-tier scope),
  `content_flags` / `moderation_actions` / `community_moderators` in
  `migrations/0001_schema.sql`, role derivation in `src/lib/roles.ts`.
