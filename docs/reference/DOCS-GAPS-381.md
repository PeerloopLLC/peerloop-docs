# Documentation Gaps — Session 381 Audit

Generated: 2026-03-12 from `/w-docs` sweep (dry run — no docs updated)

---

## 1. TEST-COVERAGE.md — 254 of 314 test files undocumented

This is the largest gap. TEST-COVERAGE.md has fallen far behind — it documents only 60 of the 314 test files that exist today.

**New file from this session (not yet in TEST-COVERAGE.md):**
- `tests/components/courses/LearnTab.test.tsx` (18 tests)

**Full list of 254 undocumented test files:** see `/w-docs` output (too long to reproduce here). Categories:

| Category | Undocumented | Examples |
|----------|:----------:|---------|
| Admin API | ~40 | analytics, categories, certificates, courses, enrollments, moderation, payouts, sessions, teachers, users |
| Auth API | ~7 | github/callback, google/callback, login, logout, register, reset-password, session |
| Course API | ~6 | curriculum, homework, resources, reviews, sessions, discussion-feed |
| Me/Enrollments API | ~45 | availability, certificates, communities, courses, homework, notifications, profile, settings, teacher-* |
| Sessions/Teachers API | ~6 | attendance, join, rating, recording |
| Other API | ~30 | checkout, communities, contact, conversations, db-test, faq, feeds, flags, health, leaderboard, moderator-invites, recommendations, reviews, stats, stories, stream, stripe, team, testimonials, users, webhooks |
| Admin components | ~20 | AdminDashboard, CategoriesAdmin, CertificatesAdmin, CoursesAdmin, etc. |
| Analytics components | ~10 | AdminAnalytics, CreatorAnalytics, MetricsRow, FunnelAnalysis, etc. |
| Booking components | 5 | SessionBooking, SessionCompletedView, SessionJoinableView, SessionParticipantCard, SessionRoom |
| Other components | ~25 | community, creator, dashboard, invite, leaderboard, marketing, messages, mod, notifications, onboarding, recommendations, settings, stories, teaching, testimonials |
| Integration tests | 4 | bbb-connectivity, database, notification-lifecycle, session-lifecycle |
| Lib tests | 4 | auth-modal, booking, notifications, video/bbb |
| Page tests | ~15 | auth forms, courses, creators, dashboard, onboarding, profile, teachers |
| SSR tests | 3 | about, courses, static |
| Unit tests | 2 | example, ratings |

**Recommendation:** Bulk-regenerate TEST-COVERAGE.md from scratch rather than incrementally adding 254 entries.

---

## 2. API Routes — 64 potentially undocumented endpoints

The sync-gaps script found 64 API route files whose endpoint name doesn't appear in the corresponding API-*.md doc. Many of these are `index.ts` files which may be documented under a different name (e.g., the list endpoint). Some are genuinely missing.

**Likely false positives** (documented under different names):
- Most `index.ts` files (list endpoints documented as "GET /api/foo")

**Likely genuinely missing:**
- `src/pages/api/contact.ts`
- `src/pages/api/db-test.ts`
- `src/pages/api/debug/db-env.ts`
- `src/pages/api/faq.ts`
- `src/pages/api/flags.ts`
- `src/pages/api/team.ts`
- `src/pages/api/stream/token.ts`
- `src/pages/api/me/messages/read-all.ts`
- `src/pages/api/me/onboarding-profile.ts`
- `src/pages/api/me/teacher-sessions.ts`
- `src/pages/api/me/teacher/[courseId]/toggle.ts`

**Recommendation:** Run a smarter diff that checks for route paths (not just filenames) in the API docs before flagging. Then document the genuinely missing ones.

---

## 3. npm Scripts — 1 undocumented

- `npm run postinstall` — not in CLI-QUICKREF.md

**Recommendation:** Low priority. `postinstall` is a lifecycle hook, not a user-invoked command. Add a one-liner if desired.

---

## 4. Tech Docs — No gaps flagged

The tech doc sweep found no stale vendor or architecture docs.

---

## 5. Priority Order for Addressing

| Priority | Gap | Effort | Impact |
|:--------:|-----|:------:|:------:|
| 1 | TEST-COVERAGE.md rebuild | High (bulk regen) | High — currently useless at 19% coverage |
| 2 | API docs — genuinely missing endpoints | Medium (~11 endpoints) | Medium — devs can't find docs for these routes |
| 3 | API docs — index.ts false positives | Low (improve script) | Low — cosmetic |
| 4 | postinstall script | Trivial | Negligible |
