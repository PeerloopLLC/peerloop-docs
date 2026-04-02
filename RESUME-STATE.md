# State — Conv 077 (2026-04-02 ~17:50)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 077 completed the STUMBLE-AUDIT course creation walkthrough (6 browser walks, 25 screenshots), discovering and fixing 7 bugs (missing sidebar nav items, tags save failure, no save feedback, browser confirm() dialogs, duplicate headers, pluralization). Also formalized the STUMBLE fix-and-verify workflow (Pre/Post segment split with DB snapshots) in `docs/as-designed/stumble-workflow.md` and established the screenshot convention for browser walks.

## Completed

- [x] STUMBLE-AUDIT.WALKTHROUGH: Course creation (6 walks — admin approve, creator hub, community, course create, editor tabs, publishing checklist)
- [x] Fix: Missing "Creating" and "Teaching" sidebar nav items (AppNavbar.tsx)
- [x] Fix: Tags save failure — API resolves names/slugs to IDs (api/me/courses/[id])
- [x] Fix: Save feedback — DOM-based showToast() replaces React state banners (CourseEditor.tsx)
- [x] Fix: Creator Apps approve — replaced browser confirm() with inline modal
- [x] Fix: Duplicate headers on /creating/studio and /creating/communities
- [x] Fix: "1 members" pluralization on community management page
- [x] Doc: stumble-workflow.md — Pre/Post segment fix-and-verify process
- [x] Doc: Screenshot convention saved to memory

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Drift
- [ ] TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30 (pre-existing)

### New
- [ ] Audit codebase for remaining alert()/confirm() calls in admin components

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)
- [ ] #3: TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30
- [ ] #11: Audit codebase for remaining alert()/confirm() calls in admin components

## Key Context

- **Sidebar nav**: "Creating" and "Teaching" items now appear for users with `canCreateCourses`/`canTeachCourses` capabilities. "Become a Creator" correctly hides when user has creator role.
- **Tags**: Course editor Tags field accepts comma-separated tag names. API resolves to IDs via `COLLATE NOCASE` lookup on tags table. Unknown tags silently skipped.
- **Toast pattern**: `showToast()` DOM-based function in CourseEditor.tsx. React state approach failed due to Astro island remount. Default 5s duration.
- **STUMBLE-AUDIT.WALKTHROUGH remaining**: Enrollment+payment, Booking+session, Certification, Community+feed walkthroughs still pending.
- **Fix-and-verify workflow**: Documented in `docs/as-designed/stumble-workflow.md`. Use Pre/Post segment split when re-testing fixes found during browser walks.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
