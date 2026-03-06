# CURRENT-BLOCK-PLAN.md — TERMINOLOGY Block

**Block:** TERMINOLOGY (Platform Terminology Standardization)
**Created:** 2026-03-05 Session 346
**Status:** Phase 1 IN PROGRESS (GLOSSARY.md drafted, awaiting review)

> Delete this file when the full TERMINOLOGY block is complete and update PLAN.md status.

---

## Progress

| Phase | Sub-block | Done | Remaining |
|-------|-----------|------|-----------|
| 1 | GLOSSARY | 3/6 | Draft complete. DECISIONS.md + PLAYBOOK.md updated. Review + finalize + DEVELOPMENT-GUIDE + CLAUDE.md remaining |
| 2 | TABLES | 0/1 | `student_teachers` → `teacher_certifications` + component/route renames (~309 occurrences) |
| 3A | SCHEMA.FK-AMBIGUOUS | 0/1 | 3 high-ambiguity FK renames (~142 occurrences) |
| 3B | SCHEMA.FK-BY-CONVENTION | 0/1 | 22 `_by` → `_by_user_id` columns (~460 occurrences) |
| 3C | SCHEMA.MINOR | 0/1 | `community_members.role` → `member_role` (~15 occurrences) |
| 3D | SCHEMA.SQL-SWEEP | 0/1 | Audit all SQL statements for latent bugs |
| 4A | SURFACES.UI-TEXT | 0/1 | "Student-Teacher" → "Teacher" in all UI strings |
| 4B | SURFACES.DOCS | 0/1 | Update ~15 living documentation files |

**Total estimated occurrences:** ~1,300+

---

## Phase 1: GLOSSARY

### What Was Done (Session 346)

- Created `GLOSSARY.md` at docs repo root
- Covers: identity hierarchy (Visitor → Member → Student → Teacher → Creator → Moderator → Admin), core domain terms, user story code mapping, DB table naming targets, component naming conventions, URL route targets, ambiguous terms to avoid

### Key Decisions in GLOSSARY.md

1. **"Teacher" replaces "Student-Teacher"** — the "student" prefix is redundant since all teachers were students
2. **"Member" in UI, "user" in code** — `users` table stays, `user`/`userId` in code stays, but UI text says "member"
3. **"Visitor" for unauthenticated** — not "guest" or "user"
4. **User story IDs are frozen** — `US-T###` stays as `T` (not renamed), story IDs embedded in 370+ stories
5. **`teacher_certifications`** is the target table name (not `teaching_certifications`) — matches "Teacher" terminology
6. **"Sponsor" replaces "Employer/Funder"** — clearer term, not in MVP
7. **Roles are capabilities, not categories** — a person can be Student + Teacher + Creator simultaneously

### Remaining Phase 1 Work

- [ ] Review GLOSSARY.md with user — confirm all terms
- [ ] Finalize after review
- [ ] Add to `DECISIONS.md` as Important Decision
- [ ] Add to `DEVELOPMENT-GUIDE.md` (link to GLOSSARY.md)
- [ ] Reference in `CLAUDE.md` Research Reference section

---

## Phase 2: TABLES

### Table Rename

| Current | Target | Why |
|---------|--------|-----|
| `student_teachers` | `teacher_certifications` | Rows are per-course certifications, not people |

### Component/Directory Renames (bundled with table rename)

| Current | Target |
|---------|--------|
| `src/components/student-teachers/` | `src/components/teachers/` |
| `STCard` | `TeacherCard` |
| `STDirectory` | `TeacherDirectory` |
| `STProfile` | `TeacherProfile` |
| `STListItem` | `TeacherListItem` |
| `CourseSTList` | `CourseTeacherList` |
| `STDetailContent` | `TeacherDetailContent` |
| `StudentTeachersAdmin` | `TeachersAdmin` |

### API Route Renames

| Current | Target |
|---------|--------|
| `/api/student-teachers/*` | `/api/teachers/*` |
| `/api/me/st-sessions` | `/api/me/teacher-sessions` |
| `/api/me/st-earnings` | `/api/me/teacher-earnings` |
| `/api/me/st-students` | `/api/me/teacher-students` |
| `/api/me/st-analytics/*` | `/api/me/teacher-analytics/*` |
| `/api/admin/student-teachers/*` | `/api/admin/teachers/*` |
| `/api/me/student-teacher/[courseId]/toggle` | `/api/me/teacher/[courseId]/toggle` |

### Blast Radius

- ~176 occurrences in 76 src files
- ~133 occurrences in 55 test files
- ~309 total

---

## Phase 3: SCHEMA

### 3A: High-Ambiguity FK Renames

| Table | Current | Target | Why |
|-------|---------|--------|-----|
| `enrollments` | `student_teacher_id` | `assigned_teacher_id` | References `users.id`, not `teacher_certifications.id` |
| `intro_sessions` | `student_teacher_id` | `teacher_id` | Same |
| `homework_submissions` | `student_id` | `student_user_id` | Clarifies it references `users.id` |

### 3B: `_by` → `_by_user_id` Convention

22 columns across 13 tables. Full list:

| Table | Current | Target |
|-------|---------|--------|
| `session_resources` | `created_by` | `created_by_user_id` |
| `homework_assignments` | `created_by` | `created_by_user_id` |
| `homework_submissions` | `reviewed_by` | `reviewed_by_user_id` |
| `sessions` | `cancelled_by` | `cancelled_by_user_id` |
| `sessions` | `dispute_reported_by` | `dispute_reported_by_user_id` |
| `sessions` | `resolved_by` | `resolved_by_user_id` |
| `content_flags` | `flagged_by` | `flagged_by_user_id` |
| `content_flags` | `reviewed_by` | `reviewed_by_user_id` |
| `moderation_actions` | `performed_by` | `performed_by_user_id` |
| `user_warnings` | `issued_by` | `issued_by_user_id` |
| `moderator_invites` | `invited_by` | `invited_by_user_id` |
| `moderator_invites` | `accepted_by` | `accepted_by_user_id` |
| `community_moderators` | `appointed_by` | `appointed_by_user_id` |
| `community_moderators` | `revoked_by` | `revoked_by_user_id` |
| `creator_applications` | `reviewed_by` | `reviewed_by_user_id` |
| `payouts` | `approved_by` | `approved_by_user_id` |
| `certificates` | `issued_by` | `issued_by_user_id` |
| `certificates` | `recommended_by` | `recommended_by_user_id` |
| `contact_submissions` | `responded_by` | `responded_by_user_id` |
| `session_credits` | `granted_by` | `granted_by_user_id` |

**Note:** This is the most debatable phase. 460 occurrences of churn for consistency. Can be dropped if it feels like too much noise during implementation.

### 3C: Minor Column Renames

| Table | Current | Target | Why |
|-------|---------|--------|-----|
| `community_members` | `role` | `member_role` | Avoids confusion with user-level roles |

### 3D: SQL Sweep

After all renames, systematically review every SQL statement for latent bugs.

**Verify for each query:**
- Column references match renamed schema
- JOIN conditions reference correct table/column
- GROUP BY present when aggregating across join tables
- SELECT uses correct alias when tables have similar columns
- EXISTS subqueries reference intended table
- FK values in INSERT/UPDATE are the correct ID type

**Watch for:**
- `tc.id` used where `tc.user_id` was intended
- JOINs on `assigned_teacher_id` assuming it was `teacher_certifications.id` vs `users.id`
- Queries that work with dev data but break with realistic data (multiple certifications per teacher)
- Missing DISTINCT/GROUP BY through one-to-many joins

---

## Phase 4: SURFACES

### 4A: UI Text

- Replace "Student-Teacher" → "Teacher" in all `.astro` and `.tsx` strings
- Replace "S-T" abbreviations in UI text
- Verify "Member" used (not "User") for authenticated users in labels
- Verify "Visitor" used (not "Guest") for unauthenticated context

### 4B: Living Documentation

~15 files to update (see PLAN.md for full list). Historical docs (session logs, COMPLETED_PLAN.md) are exempt.

---

## Schema Column Naming Convention

Adopted for all schema columns (documented in GLOSSARY.md):

| Category | Convention | Example |
|----------|-----------|---------|
| Entity table PKs | Keep `id` | `users.id`, `courses.id` |
| Join table PKs | Keep `id`, alias in SQL | `teacher_certifications.id` aliased as `certification_id` |
| FKs referencing users | `{role}_id` | `teacher_id`, `reviewer_id` |
| FKs referencing entities | `{entity}_id` | `course_id`, `enrollment_id` |
| Actor columns | `{action}_by_user_id` | `reviewed_by_user_id` |
| Boolean flags | `is_` or `has_` prefix | `is_active`, `has_certificate` |
| Scoped roles | Prefix with domain | `member_role` not `role` |

---

## Design Notes

- **Pre-production = cheap renames.** Post-launch requires ALTER TABLE + data migration + API versioning.
- **Each phase/sub-phase = separate commit** for bisectability.
- **Full test suite after each phase.**
- **GLOSSARY.md is the source of truth.** All renames derive from it.
- **Historical docs are exempt.** Session logs reflect terminology at time of writing.
