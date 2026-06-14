# State — Conv 283 (2026-06-14 ~16:59)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Feed-rewrite demo-data conv. Assessed whether enough seed data existed to demo the FEED-U3 feed rewrite; found two D1-only features with **zero** seed (platform announcements, post_promotions). Built both: 3 announcements appended to `migrations-dev/0001_seed_dev.sql`, 5 post_promotions added to `scripts/seed-feeds.mjs` via reorder-proof inline `promoteTo`. Verified end-to-end (data counts + APIs + browser render of home announcements, admin Announcements, admin Moderation→System Promotions). Reseeded local dev + remote staging in sync (full `db:setup:staging:feeds` chain), then deployed staging. Both repos committed (code 9075b3a2, docs c9a3638).

## Completed

- [x] [FEED-SEED] #33 — Added 3 announcements + 5 post_promotions to the dev seed; verified data/API/render; reseeded dev+staging in sync; deployed staging (peerloop-staging.brian-1dc.workers.dev, HTTP 200)

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production (do not build for MVP)
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (wants old-vs-new dashboard comparison)
- [ ] [RTMIG-4] #3 [Opus] — main unblocked loop: ~89 legacy `/old/*` → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED cluster)
- [ ] [ICN-NS] #9 · [E2E-MIG] #10 · [E2E-GATE] #11 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23 · [NUDGE-TC-V2] #24 · [TW-V4] #25 · [TEST-FILE-COUNT] #26 · [PLAN-RENUM] #27
- [ ] [COMMONS-DATE] #28 · [DISCCARD-DEL] #29 · [TESTDOC-DRIFT] #30 · [ROUTEMAP-LIT] #31 · [TOWNHALL-TEST] #32
- [ ] **(new, Conv 283)** [FEED-LANE-RENDER] #34 — community feed *page* promoted-lane render unconfirmed (non-member view + stale "hi" Stream post masked it; API serves it). Verify membership-gating vs UI placement; confirm it paints for an eligible member.
- [ ] **(new, Conv 283)** [STREAM-PURGE] #35 — `seed-feeds.mjs --clean` purges only D1, not Stream activities (Stream accumulates stale test posts; foreign_id-keyed so seed posts don't dup, but leftovers persist). Add an optional Stream-side purge for clean demos.

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] (DEFERRED) · #2 [ROLE-STUDIOS] [Opus] (BLOCKED) · #3 [RTMIG-4] [Opus] · #4–#32 (see Remaining) · #34 [FEED-LANE-RENDER] · #35 [STREAM-PURGE]

## Key Context

- **Feed seed architecture (the conv's core lesson):** the feed rewrite is hybrid Stream/D1. Post *content* → Stream.io (seeded at runtime by `seed-feeds.mjs`, gated on Stream creds). Supporting substrate → D1: `feed_activities` (badge index, runtime-seeded by seed-feeds.mjs), `announcements` (FEED-U3c④, now seeded in 0001_seed_dev.sql), `post_promotions` (FEED-U3a, now seeded in seed-feeds.mjs). The two D1-only features were invisible-empty before this conv.
- **Seed placement rule:** announcements → 0001_seed_dev.sql (FK users; only file the default `db:setup:local:dev` chain applies). post_promotions → seed-feeds.mjs after Step 4 (FK `feed_activities.id`=`fa-seed-NNN`, runtime-written); inline `promoteTo` tag on source posts derives the FK from `activity.index` (reorder-proof). 3→system (admin moderation surface), 2→community (per-feed promoted lane).
- **`/api/feeds/promoted` rejects `system`** — system promotions flow via announcements + the admin moderation queue (`/admin/moderation` → System Promotions tab, scoped `to_feed_type='system'`). Community/course promotions render in the per-feed lane.
- **wrangler D1 verification gotcha:** `SELECT COUNT(*) AS n` + `--json` + parse the `"n":` field. `grep [0-9]+ | tail -1` grabs `meta.duration`, NOT the count (caused a false "dirty DB" reading this conv).
- **0001_seed_dev.sql is NOT idempotent** (67 plain INSERTs) — reseeding requires a full reset (`db:setup:*` chains always reset+migrate first).
- Staging reseeded via full `db:setup:staging:feeds` (reset+migrate+dev+stripe+booking+feeds), keeping Stripe/booking integration data. Staging D1 == dev on feed tables (announcements 3, post_promotions 5, feed_activities 21).
- **Local dev server** may still be running on `localhost:4322` (bg). Stale tabs from a prior browser session exist on ports 4321/4323.
- Baseline: NO 5-gate suite run this conv (seed-data only; no app code changed). Build passed implicitly via the staging deploy.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
