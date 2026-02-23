# Session Decisions - 2026-02-23

## 1. Creator Content API Namespace: `/api/me/communities`
**Type:** Implementation
**Topics:** astro, d1

**Trigger:** CREATOR-SETUP planning required choosing endpoint namespace for creator community/progression management.

**Options Considered:**
1. `/api/me/communities` (matches existing `/api/me/courses`) ← Chosen
2. `/api/communities` with auth (extend existing public endpoints)
3. `/api/creator/communities` (new namespace)

**Decision:** Use `/api/me/communities` namespace, consistent with the established `/api/me/courses` pattern.

**Rationale:** The `/api/me/` prefix already means "resources owned by the authenticated user." Public read endpoints stay at `/api/communities/`. This keeps creator write operations separate from public reads without inventing a new convention.

**Consequences:** 4 new endpoint files under `src/pages/api/me/communities/`. Progression endpoints nest at `[slug]/progressions/`.

---

## 2. Community Creation Auto-Creates Default "General" Progression
**Type:** Implementation
**Topics:** d1, astro

**Trigger:** Should community creation leave the community empty, or bootstrap it with a usable structure?

**Options Considered:**
1. Create community only — require separate progression creation before courses
2. Auto-create a "General" progression with `badge='standalone'` ← Chosen
3. Auto-create progression + prompt for first course in same request

**Decision:** `POST /api/me/communities` atomically creates the community, a "General" progression (standalone badge, display_order 0), and the creator membership in a single `batch()` call.

**Rationale:** A community with no progressions is useless — courses can't be created without a progression. Auto-creating "General" makes the community immediately usable. The creator can rename or add more progressions later. The atomic batch ensures no partial state.

**Consequences:** Three rows inserted per community creation. The default progression uses slug `{community-slug}-general`.

---

## 3. Course Creation Requires `progression_id` (Going Forward)
**Type:** Strategic
**Topics:** d1, astro

**Trigger:** The `progression_id` column on courses is nullable in the schema (for migration flexibility), but the plan specified making it required for new courses.

**Options Considered:**
1. Keep `progression_id` optional — auto-create standalone progression if missing
2. Require `progression_id` on `POST /api/me/courses` ← Chosen
3. Change schema column to NOT NULL (breaking change)

**Decision:** `POST /api/me/courses` now returns 400 if `progression_id` is missing. The schema column stays nullable (existing NULL courses are grandfathered), but the API enforces it going forward.

**Rationale:** Requiring progression_id at the API level enforces the community → progression → course hierarchy without a schema migration. Existing seed data courses with NULL progression_id continue to work. The API validation is the enforcement point, not the schema constraint.

**Consequences:** All existing POST tests updated to include `progression_id` in request body. New validation tests added. Course creation also auto-increments progression `course_count` and auto-updates badge to `learning_path` when count reaches 2+.

---

## 4. Progression Badge Auto-Update on Course Creation
**Type:** Implementation
**Topics:** d1

**Trigger:** Progressions have a `badge` field (`'standalone'` or `'learning_path'`). When should it transition?

**Options Considered:**
1. Manual badge management by creator
2. Auto-update: set to `learning_path` when `course_count >= 2` ← Chosen
3. Always `standalone`, ignore badge semantics

**Decision:** When a course is created via `POST /api/me/courses`, after incrementing the progression's `course_count`, if the new count is >= 2 and the badge is still `'standalone'`, auto-update it to `'learning_path'`.

**Rationale:** A progression with 2+ courses is by definition a learning path, not standalone. Auto-updating removes a manual step creators would likely forget. The badge is also settable via `PATCH .../progressions/[id]` for manual override.

**Consequences:** Badge transitions are one-way automatic (standalone → learning_path on count increase). Removing courses does NOT auto-revert to standalone — that would require explicit management.

---

## 5. Community Archive Guards: System + Active Enrollments
**Type:** Implementation
**Topics:** d1

**Trigger:** What should prevent a community from being archived?

**Options Considered:**
1. No guards — allow archiving anything
2. Guard: system communities only
3. Guard: system communities + active enrollments ← Chosen
4. Guard: system + active enrollments + non-empty courses

**Decision:** `DELETE /api/me/communities/[slug]` checks two guards: (1) cannot archive system communities (`is_system = 1`), (2) cannot archive communities whose courses have active enrollments (`status IN ('enrolled', 'in_progress')`).

**Rationale:** Archiving a community with students actively enrolled in its courses would break their learning experience. System communities (The Commons) must never be archived. Courses without active students can be archived freely — completed/cancelled enrollments don't block it.

**Consequences:** The enrollment check joins through `progressions` to `courses` to `enrollments`, looking for `status IN ('enrolled', 'in_progress')`.
