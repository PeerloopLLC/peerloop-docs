# State — Conv 128 (2026-04-18 ~16:03)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 128 was a documentation and housekeeping conv. Worked through 8 of the 17 Sonnet-class tasks from the backlog: 4 doc updates (CLAUDE.md known-issue, CLI-REFERENCE.md astro-check note, DEVELOPMENT-GUIDE.md hook-mock pattern, API-COMMUNITY.md Conv 118 review), 2 config/tooling items (routineStrip phrase, gh CLI install), and 2 code fixes (isUserAdmin helper in communities.ts, AppNavbar mobile spacer → AppLayout pt-14). Local DB was also re-seeded with dev data (db:setup:local:dev) during CSS verification.

## Completed

- [x] [CLM-RS] CLAUDE.md §Known issue → "now handled automatically"
- [x] [ASTRO-CT] astro-check content.d.ts note added to CLI-REFERENCE.md
- [x] [HMP] Canonical useCurrentUser() mock pattern section in DEVELOPMENT-GUIDE.md
- [x] [ACR] API-COMMUNITY.md updated for Conv 118 (modal, SQL gotcha)
- [x] [TC-STRIP] "Extract/Learnings/Decisions for Conv" added to routineStrip.phrases
- [x] [IN] gh CLI v2.90.0 installed on MacMiniM4-Pro
- [x] [RA-SSR-LOADER] isUserAdmin replaces raw SELECT in communities.ts:471-476
- [x] [CSS] /discover/members bottom-row clipping fixed (AppNavbar spacer → AppLayout pt-14)

## Remaining

### Substantial blocks (need prioritization)
- [ ] #1 [EM] Email notification for session invites
- [ ] #2 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #3 [DP] DEPLOYMENT.PROD
- [ ] #4 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #5 [PFC] PLATO-FLYWHEEL-CREATOR-GAP — creator-lifecycle audit (Opus)
- [ ] #6 [CCS] CODECHECK-SQL — schema-aware SQL column-name lint
- [ ] #7 [ACR2] API-COMM-REVIEW (already done this conv — marked complete in PLAN)
- [ ] #8 [DSA] DBAPI-SUBCOM-AUDIT — §Communities + §Authentication audit (Opus)
- [ ] #9 [RA-SSR] Collapse course/[slug]/*.astro SSR queries into fetchCourseDetailData loader (~3-4 hr)
- [ ] #10 [MPT] Multipart file-upload happy-path tests — R2 mocking required

### Medium
- [ ] #11 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #12 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #13 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (product call)

### Opus-class (need Opus model)
- [ ] #21 [TDS-AUTH] audit 4 stale auth docs vs current src/lib/auth/*
- [ ] #22 [DEVCOMP-REVIEW] periodic review of 59 session files for machine-specific notes

## TodoWrite Items

- [ ] #6: [CCS] CODECHECK-SQL schema-aware SQL column-name lint
- [ ] #21: [TDS-AUTH] audit 4 stale auth docs vs current src/lib/auth/*
- [ ] #10: [MPT] Multipart file-upload happy-path tests — R2 mocking required
- [ ] #1: [EM] Email notification for session invites
- [ ] #11: [BKN] BKC-NEXT SessionBooking next-month upper bound
- [ ] #2: [DGH] DEPLOYMENT.GHACTIONS
- [ ] #12: [BKF] BKC-FETCH SessionBooking 4-week fetch horizon
- [ ] #13: [CRE] COURSE-RES-AUTH-EDGE disputed + soft-deleted enrollment gate
- [ ] #3: [DP] DEPLOYMENT.PROD
- [ ] #8: [DSA] DBAPI-SUBCOM-AUDIT — §Communities + §Authentication audit
- [ ] #22: [DEVCOMP-REVIEW] periodic review of 59 session files for machine-specific notes
- [ ] #4: [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #5: [PFC] PLATO-FLYWHEEL-CREATOR-GAP creator-lifecycle audit
- [ ] #9: [RA-SSR] Collapse course/[slug]/*.astro SSR queries into fetchCourseDetailData loader

## Key Context

### Local DB state
- Re-seeded with `db:setup:local:dev` during Conv 128 (11 users including realistic dev data with privacy_public=1)
- Old Alex Rivera / Mara Chen UI-created accounts are gone; use dev seed credentials (e.g., guy-rymberg@example.com, password from seed hash)

### CSS fix details
- `src/components/layout/AppNavbar.tsx` — removed `<div className="h-14 lg:hidden" />` spacer
- `src/layouts/AppLayout.astro` — content div is now `p-4 pt-14 lg:p-6 lg:pt-6`
- Verified in browser: desktop clean, mobile `pt-14` applies correctly

### Docs agent additions (Conv 128)
- `docs/as-designed/devcomputers.md` — MacMiniM4-Pro gh CLI column updated to v2.90.0
- `docs/reference/DEVELOPMENT-GUIDE.md` — "Mobile Header Spacing — AppLayout, not AppNavbar (Conv 128)" section added under Styling › Component Patterns

### Next recommended tasks
- **[DGH] DEPLOYMENT.GHACTIONS** — next concrete step in the active DEPLOYMENT block
- **[EM] Email notification for session invites** — feature work
- Any Opus-class audit tasks if switching to Opus model

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
