---
name: Course Page Merge Decision
description: Decision to merge /learn into course detail page as accordion Learn tab — context for COURSE-PAGE-MERGE block
type: project
---

## Course Page Merge (Session 377)

**Decision:** Merge the standalone `/course/{slug}/learn` page into the course detail page (`/course/{slug}`) as an enrolled-only "Learn" tab.

**Problem:** Students had two overlapping pages per course — the marketing/info detail page and the learning workspace. Both showed curriculum, resources, progress, and sessions. Navigation between them was confusing. The `/courses` (My Courses) page had no direct path to sessions.

**Solution chain built in Session 377:**
1. Sessions tab added to course detail page (enrolled-only)
2. MyCourses cards now show "Next: date with teacher" banners linking to `/course/{slug}/sessions`
3. API `/api/courses/{id}/sessions` extended with `status=all`
4. Next step: COURSE-PAGE-MERGE block absorbs /learn into the detail page

**Design choice:** Accordion modules (Option C over Option B strip). Reasons: descriptive module titles make collapsed cards informative, new students see the full journey they paid for, completed modules show progress timeline.

**Key rule:** Content is NEVER locked. Students can browse all module content freely. Only session completion ORDER is gated (can't complete module 3's session before module 2's).

**Client context:** Client is pushing to reduce AppNavbar items, so adding a "Sessions" nav link was ruled out. Instead, sessions are surfaced through My Courses cards and the course page Sessions tab.

Full mockups and implementation plan in PLAN.md under COURSE-PAGE-MERGE.
