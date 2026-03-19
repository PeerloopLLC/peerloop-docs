# State — Conv 010 (2026-03-18 ~20:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-8`, docs: `main`

## Summary

Conv 010 focused on Teaching/Creating dashboard improvements. Fixed seed data, added role-specific earnings labels, tabbed Current/Past lists for students and teachers, and established the DATE-FORMAT decision for canonical UTC ISO 8601 timestamps. All work committed and pushed. One TypeScript error discovered during work remains unfixed.

## Completed

- Seed data: fixed `assigned_teacher_id` on Guy's 4 enrollments
- EarningsOverview: added `title` prop ("Teaching Earnings" / "Creator Earnings")
- TeacherStudentList: rewritten with Current/Past Students tabs
- CreatorTeacherList: new component with Active/Past Teachers tabs
- DATE-FORMAT decision: canonical UTC ISO 8601 with Z, standardized formatters in `src/lib/timezone.ts`
- `/r-resume` skill: fixed false-positive stale context warning
- `/r-pre-clear` eliminated: state save incorporated into `/r-end` Step 3
- Global `~/.claude/CLAUDE.md` created for cross-session question formatting directive
- 240 dashboard tests passing, 34 new component tests

## Remaining

### Bug Fix
- [ ] Fix TypeScript error in `src/components/courses/EnrollButton.tsx` line 106 — `'data' is of type 'unknown'`. Needs type assertion or proper typing on catch/response data. Found during `npx tsc --noEmit`.

## TodoWrite Items

- [ ] Fix TypeScript error in EnrollButton.tsx line 106 — `error TS18046: 'data' is of type 'unknown'`. Discovered during tsc check in Conv 010. Needs a type assertion or proper typing on the catch/response data.

## Key Context

- The EnrollButton error is pre-existing (not introduced by Conv 010 changes) but was surfaced during routine `tsc --noEmit` and must be tracked per the feedback directive in `feedback_surface_and_track_all_issues.md`.
- DATE-FORMAT migration (68 files) is tracked in PLAN.md block DATE-FORMAT — infrastructure is done, file-by-file migration is pending.
- The `~/.claude/CLAUDE.md` global directive (question formatting with bold + 3 pointing emojis) needs to be manually created on MacMiniM4-Pro — see Conv 010 Dev.md for the terminal command.

## Resume Command

To continue: run `/r-resume`, which will consolidate state and present a unified view.
