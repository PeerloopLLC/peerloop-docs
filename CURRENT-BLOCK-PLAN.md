# CURRENT-BLOCK-PLAN.md — TERMINOLOGY Block

**Block:** TERMINOLOGY (Platform Terminology Standardization)
**Created:** 2026-03-05 Session 346
**Last Updated:** 2026-03-06 Session 351
**Status:** Phase 3C COMPLETE — Phase 3D next

> Delete this file when the full TERMINOLOGY block is complete and update PLAN.md status.

---

## Progress

| Phase | Sub-block | Done | Remaining |
|-------|-----------|------|-----------|
| 1 | GLOSSARY | 7/7 | COMPLETE (Session 346 draft + Session 348 review/finalize/doc-refs) |
| 2 | TABLES | 1/1 | COMPLETE (Session 349 — 246 files, 70+ renamed, table+components+routes+identifiers) |
| 3A | SCHEMA.FK-AMBIGUOUS | 1/1 | COMPLETE (Session 351 — 3 FK renames + Stripe metadata cleanup, 89 files, 269 replacements, 0 regressions) |
| 3B | SCHEMA.FK-BY-CONVENTION | 1/1 | COMPLETE (Session 351 — 16 columns, 186 files, 537 replacements, 0 regressions) |
| 3C | SCHEMA.ENUM-VALUES | 1/1 | COMPLETE (Session 352 — 67 files, 166 replacements, 0 regressions. 1 pre-existing DST timing failure in sessions/index.test.ts) |
| 3D | SCHEMA.MINOR | 0/1 | `community_members.role` → `member_role` (~15 occurrences) |
| 3E | SCHEMA.SQL-SWEEP + TS-TYPES | 0/1 | Audit all SQL statements for latent bugs + create TypeScript status unions (16 tables) |
| 4A | SURFACES.UI-TEXT | 0/1 | "Student-Teacher" → "Teacher" in all UI strings |
| 4B | SURFACES.DOCS | 0/1 | Update ~15 living documentation files |

**Total estimated occurrences:** ~1,300+

---

## Phase 1: GLOSSARY

### What Was Done (Session 346)

- Created `GLOSSARY.md` at docs repo root
- Covers: identity hierarchy (Visitor → Member → Student → Teacher → Creator → Moderator → Admin), core domain terms, user story code mapping, DB table naming targets, component naming conventions, URL route targets, ambiguous terms to avoid
- Added to `DECISIONS.md` (4 entries) and `PLAYBOOK.md`

### What Was Done (Session 348 — Review)

- 17-item review with user, all resolved
- Added: §1a Moderator Tiers (Tier 1 platform-wide, Tier 2 community-scoped)
- Added: Curriculum definition (separate from Module), course feed per course
- Added: Notifications section (in-app vs email, distinct from messages and posts)
- Added: Refund term, Availability Override term
- Added: Payment Split recipient type breakdown with current → target enum values
- Expanded §7 from 6 entries to 14, organized by severity (Critical/High/Medium)
- Each §7 entry now includes code variable conventions (not just documentation rules)
- Fixed: Community starts empty (no mandatory progression), enrollment created post-payment
- Fixed: "or guest" removed (contradicted deprecated terms), session disambiguation strengthened
- Confirmed: Teacher, Member/User split (Option A), Visitor, Sponsor, `teacher_certifications`
- Discovered 4 new PLAN items: INTRO-SESSIONS (ON-HOLD), SESSION-CREDITS, COURSE-FOLLOWS, AVAIL-OVERRIDES (DEFERRED)
- **Bug found and fixed:** `revenue.ts:158` used `'st'` instead of `'student_teacher'` — teacher earnings showed $0 in admin analytics

### Key Decisions in GLOSSARY.md

1. **"Teacher" replaces "Student-Teacher"** — the "student" prefix is redundant since all teachers were students
2. **"Member" in UI, "user" in code** — `users` table stays, `user`/`userId` in code stays, but UI text says "member"
3. **"Visitor" for unauthenticated** — not "guest" or "user"
4. **User story IDs are frozen** — `US-T###` stays as `T` (not renamed), story IDs embedded in 370+ stories
5. **`teacher_certifications`** is the target table name (not `teaching_certifications`) — matches "Teacher" terminology
6. **"Sponsor" replaces "Employer/Funder"** — clearer term, not in MVP
7. **Roles are capabilities, not categories** — a person can be Student + Teacher + Creator simultaneously
8. **Two moderator tiers** — Tier 1 (platform-wide, admin-appointed), Tier 2 (community-scoped, creator-appointed)
9. **Payment split recipient_type renames** — `'creator'` → `'creator_as_instructor'`, `'creator_royalty'` → `'creator_as_author'`, `'student_teacher'` → `'teacher'`
10. **Always qualify ambiguous terms** — 14 terms must always be prefixed in code variables, comments, and docs (§7)

### Remaining Phase 1 Work

- [x] User final review of GLOSSARY.md — 5 additional items resolved (Session 348)
- [x] Add to `DEVELOPMENT-GUIDE.md` (link to GLOSSARY.md) — Session 348
- [x] Reference in `CLAUDE.md` Research Reference section — Session 348

---

## Phase 2: TABLES — COMPLETE (Session 349)

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

### Additional Renames (discovered during execution)

| Current | Target |
|---------|--------|
| `STAvailabilityCard` | `TeacherAvailabilityCard` |
| `STProfileHeader` | `TeacherProfileHeader` |
| `STPerformanceTable` | `TeacherPerformanceTable` |
| `STAnalytics` | `TeacherAnalytics` |
| `STSection` | `TeacherSection` |
| `ForStudentTeachersSection` (×2) | `ForTeachersSection` |
| `is_student_teacher` (derived prop) | `is_teacher` |
| `[stId]` (route param) | `[teacherId]` |
| `/api/admin/enrollments/[id]/reassign-st` | `reassign-teacher` |
| `/api/me/creator-analytics/st-performance` | `teacher-performance` |

### Actual Blast Radius

- 246 files changed, 1618 insertions(+), 1618 deletions(-)
- 70+ files renamed via `git mv`
- No new test failures (42 pre-existing failures unchanged)

### Lessons Learned

- **Run full test suite BEFORE starting** a large rename to establish baseline
- **Short substrings in sed are dangerous:** `stId` → `teacherId` mangled `getByTestId`, `requesterId`, `interestId`, `firstId`. Use word-boundary-aware patterns.
- **Stop dev server before DB reset:** Wrangler holds SQLite files open

---

## Phase 3: SCHEMA

### 3A: High-Ambiguity FK Renames — COMPLETE (Session 351)

| Table | Current | Target | Status |
|-------|---------|--------|--------|
| `enrollments` | `student_teacher_id` | `assigned_teacher_id` | DONE (217 occ, 77 files) |
| `intro_sessions` | `student_teacher_id` | `teacher_id` | DONE (5 occ, 4 files) |
| `homework_submissions` | `student_id` | `student_user_id` | DONE (22 occ, 15 files) |

**Additional cleanup:** Stripe metadata keys renamed for clarity:
- `student_teacher_id` (metadata) → `teacher_certification_id` (cert record, st-xxx)
- `student_teacher_user_id` (metadata) → `assigned_teacher_id` (user ID, usr-xxx)
- Checkout API body param: `student_teacher_id` → `teacher_certification_id`

**Approach that worked:** Do the smaller divergent rename first (A2: intro_sessions, 5 occ), which made the larger rename (A1: enrollments, 217 occ) safe for global replace. A3 (homework_submissions.student_id) required surgical file-by-file editing due to shared column name with other tables.

**Stats:** 89 files changed, 269 insertions/deletions, 0 test regressions

### 3B: `_by` → `_by_user_id` Convention — COMPLETE (Session 351)

16 unique column names across 13 tables (some columns like `reviewed_by` shared across tables).

**Approach:** Piloted 3 columns first (granted_by 4 occ, cancelled_by 33 occ, reviewed_by 69 occ) to confirm no substring collisions and safe for plain `sed`. Then batched remaining 13 columns in one pass.

**Key finding:** macOS `sed` doesn't support `\b` word boundaries, but plain replacement was safe because no `_by` column had suffixed variants (e.g., no `created_by_admin`).

**Stats:** 186 files changed, 537 insertions/deletions, 0 test regressions

**Note:** This is the most debatable phase. ~510 occurrences across ~186 files for consistency. Can be dropped if it feels like too much noise during implementation.

**Approach:** Do a small subset first (3-4 columns) to determine patterns, then decide whether to batch the rest or do them individually. Key question: are any column names shared across tables (like `reviewed_by` appears in 3+ tables) — if so, global replace is safe since the target is always `reviewed_by_user_id`.

### 3C: Enum Value Renames

| Table | Column | Current Value | Target Value | Why |
|-------|--------|--------------|-------------|-----|
| `payment_splits` | `recipient_type` | `'creator'` | `'creator_as_instructor'` | Clarifies: creator is teaching (85% share) |
| `payment_splits` | `recipient_type` | `'creator_royalty'` | `'creator_as_author'` | Clarifies: creator authored course, teacher teaches (15% royalty) |
| `payment_splits` | `recipient_type` | `'student_teacher'` | `'teacher'` | Matches terminology rename |
| `payouts` | `recipient_type` | `'student_teacher'` | `'teacher'` | Matches terminology rename |
| `payouts` | `recipient_type` | `'creator'` | `'creator'` | Stays — payouts don't distinguish instructor vs author |

Includes: CHECK constraints in schema, all code string literals, TypeScript union types.

**Bug fixed during review (Session 348):** `revenue.ts:158` used `recipient_type = 'st'` (nonexistent value) — teacher earnings showed $0 in admin analytics. Fixed to `'student_teacher'` (will become `'teacher'` in Phase 3C).

**Completed (Session 351–352):**
- Global sed for `'student_teacher'` → `'teacher'` and `'creator_royalty'` → `'creator_as_author'`
- Surgical `'creator'` → `'creator_as_instructor'` in payment_splits contexts only (payouts `'creator'` stays)
- `creator-earnings.ts` queries changed to `IN ('creator_as_instructor', 'creator_as_author')` (except payouts query line 295)
- UI label maps, feature flags, community_members CHECK, seed data all updated
- 5 test files fixed for new enum values and labels
- **Stats:** 67 files changed, 166 insertions/deletions, 0 regressions

### 3D: Minor Column Renames

| Table | Current | Target | Why |
|-------|---------|--------|-----|
| `community_members` | `role` | `member_role` | Avoids confusion with user-level roles |

### 3E: SQL Sweep + TypeScript Status Types

After all renames, systematically review every SQL statement for latent bugs.

**For each query, verify:**
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

**TypeScript status types:** Create typed string unions for each table's `status` column (16 tables) to catch wrong-enum bugs at compile time. Example:
```typescript
type EnrollmentStatus = 'enrolled' | 'in_progress' | 'completed' | 'cancelled' | 'disputed';
type TransactionStatus = 'pending' | 'completed' | 'refunded' | 'partially_refunded' | 'failed' | 'disputed' | 'dispute_lost';
```

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
