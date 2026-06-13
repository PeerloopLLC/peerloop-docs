# State — Conv 277 (2026-06-12 ~21:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Shipped **FEED-U3c④** — platform announcements — completing **U3c**. Decided the fan-out architecture with the user (CLAUDE.md §Critical Rule): **A+B** (every announcement renders pinned atop the home smart feed at read time, mirroring promotion delivery model ①; an optional "also notify" fans out a per-user 'system' notification for urgent ones), **D1-only** storage (no Stream activity), and an optional admin-set **`active_until`** (NULL → dial fallback — the one stored-expiry divergence, justified by maintenance windows). Built end-to-end, 5-gate green (test **6686**), browser-verified. Only **U3d** (PromoteNudge island) remains in FEED-U3, deferred to a future conv.

## Completed

- [x] /r-start (Conv 276→277); 37 tasks transferred; memory mirror→live applied (Conv-273 option-phrasing AskUserQuestion rewrite)
- [x] U3c④ fan-out architecture decided: A+B / D1-only / optional active_until
- [x] Schema: `announcements` + `announcement_dismissals` tables + 2 lifecycle dials (0001/0002)
- [x] Lib `src/lib/announcements/` (config, create+notify fan-out, query, dismiss, retention) + `getAllActiveUserIds`
- [x] Smart-feed orchestrator pins announcements (first-page-only, not in cursor) + `AnnouncementCard.tsx`
- [x] Admin `/admin/announcements` page + `AnnouncementsAdmin.tsx` island + AdminNavbar entry
- [x] Endpoints: admin list/create, admin remove, member dismiss
- [x] Cron `purgeExpiredAnnouncements` wired
- [x] 15 tests; 5 gates green (tsc / astro 0-0-1hint / lint / test **6686** / build); browser-verified (Chrome bridge, admin=brian)
- [x] Reassembly plan marks **U3c COMPLETE**; 3 decisions routed to `docs/decisions/`; 4 reference docs updated (API-ADMIN, API-COMMUNITY, TEST-COVERAGE, DB-GUIDE)

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; U3c ✅ COMPLETE → U3d next):**
- [ ] [FEED-U3] #1 [Opus] — **U3d next:** PromoteNudge self-gating island on `/creating`+`/teaching` (mirror `ProgressionNudge`) + mount the already-built `EntityPromoComposer.tsx`. Decide engagement threshold at start. Built LAST. (U3c fully done.)
- [ ] [SYS-NAMING] #2 · [PROMOTE-IDEMP] #3 · [API-DISC-DOC] #4 · [SYS-GET-GATE] #5 — independent feed-group cleanups
- [ ] [COMM-TAG-FILTER] #6 · [SUCCESS-COMMUNITY-VERIFY] #7 — PARKED (needs-spec)
- [ ] [DISC-RAILS-DOC] #8 — document `GET /api/discovery/rails` in API-COMMUNITY.md (driftCheck; pre-existing Conv 261 gap)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #9 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #10 [Opus] · [SSR-LOADER-DEAD] #11 · [CT-RESTYLE] #12 · [PRIM-MATCH-INDEX] #13 · [TXTBTN] #14 · [PROFILE-PRIM-SWEEP] #15 (PAUSED)
- [ ] [ICN-NS] #16 · [E2E-MIG] #17 · [E2E-GATE] #18 · [SHOWMORE] #19 · [PREFLIP-WT] #20 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #21 [Opus] · [MEM-CAP] #22 (MEMORY.md 89% → /r-prune-memory) · [DOCGEN-SPEC] #23 · [OLD-PORTED-CLEANUP] #24
- [ ] [LEARN-ISLAND-RESTYLE] #25 · [CREATE-ISLAND-RESTYLE] #26 · [TEACH-ISLAND-RESTYLE] #27 · [TRIAGE-RESTYLE] #28
- [ ] [V217-WATCH] #29 · [COURSEDETAIL-DEAD] #30 · [NUDGE-CACHE-FLASH] #31 · [NUDGE-TC-V2] #32 · [TW-V4] #33 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #34 · [PLAN-RENUM] #35
- [ ] [COMMONS-DATE] #36 · [DISCCARD-DEL] #37

## TodoWrite Items

- [ ] #1 [FEED-U3] [Opus] (U3d next; U3c done) · #2 [SYS-NAMING] · #3 [PROMOTE-IDEMP] · #4 [API-DISC-DOC] · #5 [SYS-GET-GATE] · #6 #7 PARKED · #8 [DISC-RAILS-DOC]
- [ ] #9 [ROLE-STUDIOS] [Opus] (BLOCKED) · #10 [RTMIG-4] [Opus] · #11–#20 · #21 [TZ-AUDIT] [Opus] · #22–#37

## Key Context

- **FEED-U3 status:** U3a/U3b/U3c ✅ COMPLETE. Only U3d remains. SoT = `plan/home-feed-merge/REASSEMBLY-CONV271.md` (updated this conv with the U3c④ done marker + "U3c COMPLETE" + build-order line).
- **New code (committed Step 6):** `src/lib/announcements/{config,create,query,dismiss,retention}.ts`; `getAllActiveUserIds` in `src/lib/auth/session.ts`; orchestrator + `FeedItem` union changes in `src/lib/smart-feed/index.ts`; `SmartFeed.tsx` render kind; `AnnouncementCard.tsx`; `AnnouncementsAdmin.tsx`; `/admin/announcements.astro`; endpoints under `/api/admin/announcements/*` + `/api/announcements/dismiss`; AdminNavbar entry; cron purge; schema + seed (0001/0002). Tests: `announcements.test.ts` (+15), orchestrator-test union-narrowing fix.
- **Announcement model:** D1-only (`announcements` table holds title/body/cta/active_until; no Stream). Active = NOW before COALESCE(active_until, created_at + `announcement_active_duration_days` dial); all comparisons string-vs-string on ISO strftime (SQLite Datetime Rule), dial path inverted to avoid re-parsing created_at. Pinned atop the feed first-page-only, never in the cursor. Per-user dismissal = `announcement_dismissals` (read-time fan-out has no per-user row). Notify (A+B) fans out 'system' notifications to `getAllActiveUserIds` (non-deleted, non-suspended), chunked at 100.
- **Decisions routed** (Conv 277): `docs/decisions/01-architecture.md` (A+B fan-out) + `02-database.md` (D1-only + active_until), decision-log + INDEX; 1 TIMELINE entry (U3c COMPLETE milestone).
- **Local D1 (dev):** one leftover dev announcement ("Genesis Cohort", dismissed by brian but still active) — `db:setup:local:dev` re-seed clears it. The dev server I started (:4323) was killed.
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-1hint / lint / test **6686** / build).
- **MEMORY.md ~89%** of the SessionStart byte cap → [MEM-CAP] #22 (`/r-prune-memory`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next FEED-U3 work = U3d** — decide the PromoteNudge engagement threshold first, then build the self-gating island on `/creating`+`/teaching` and mount `EntityPromoComposer.tsx`.
