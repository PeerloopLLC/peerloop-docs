# State — Conv 244 (2026-06-06 ~16:56)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Triage + quick-win + planning conv. Closed **[PROV-SWEEP-DEBT]** (prov:sweep 4→0), then ran a full backlog **triage sweep** (6 parallel agents) that took the task list **45 → 24 active** (16 completed, 5 dropped) and shipped **9 S-effort quick wins**. Investigation of the Matt `Sidebar` revealed `/notifications` (404s) and `/messages` are both untouched legacy with no root route — set up as the explicit **next-conv block**: port both to root Tier-1 `@matt-inspired` ([NOTIF-PORT] #46 FIRST, [MSG-PORT] #47 SECOND). Full baseline verified green this conv.

## Completed

- [x] [PROV-SWEEP-DEBT] #39 — prov:sweep 4→0 (av-timer/verified icon-provenance; MySessionsTab registry; dropped SubNavItemDisabled stamp)
- [x] [COMM-LEAVE] #3 — Leave button wired → DELETE /api/communities/[slug]/join (inline script)
- [x] [DASH-COURSES-LINK] #40 — Courses ActionCard on home
- [x] [OUTLINE-V4] #42 — outline-none→outline-hidden ×4 (SESS-GRAD booking files)
- [x] [PRIM-COURSES-DISMISS] #19 — not-a-primitive ack comment on /courses dismiss button
- [x] [API-USERS-DRIFT] #34 — rewrote API-USERS.md GET /api/users response (camelCase + isPrivate + private variant + search param)
- [x] [PRIM-DOC] #15 — matt-provenance §12e pre-primitive (no-stamp) state
- [x] [HOWTOREG-ICN] #21 — "Adding an icon" how-to in icon _INDEX.md
- [x] [ASSET-SWEEP-GATE] #22 — Figma-URL grep as /w-codecheck Check 9
- [x] [MEM-CAP] #32 — /r-prune-memory, MEMORY.md 83%→77%
- [x] Closed-as-already-done: [MOD-TOGGLE] #4, [MFRD-LOOKUP] #9, [PRECHECKOUT-MATT-CONFIRM] #10, [ENROLL-NAV-MATT-CONFIRM] #11, [REND-DEDUP-GUARD] #31, [HOME-FEEDSHUB-VIS] #37
- [x] Dropped: [MMP-PH5] (phantom), [PREPLAN-CHECKOUT-NOTE] (no intent), [GARBLE-WATCH] + [DOM-FIRST] (standing disciplines), [PRIM-ORPHAN-ACK] (rule-of-three watch)

## Remaining

**NEXT CONV (in order):**
- [ ] [NOTIF-PORT] #46 — port `/notifications` to root Tier-1 `@matt-inspired` (rebuild NotificationsList w/ MattIcon + Matt tokens; keep filter tabs/mark-read/mark-all/delete/load-more/empty-states). Sidebar href already present (currently 404s). FIRST.
- [ ] [MSG-PORT] #47 — port `/messages` to root Tier-1 `@matt-inspired` (rebuild 4 islands; 10s polling, ?to=/?conversation= deep-links, new-convo modal+user-search, unread, mobile list/thread split) AND add a Messages NavItem to the Matt Sidebar (absent today). NOT Stream.io. SECOND.

**Carried backlog:**
- [ ] [COMM-TAG-FILTER] #1 [Opus] · [CT-RESTYLE] #2 (Tier-2 token sweep)
- [ ] [MATT-EXEC-PG2] #5 [Opus] (scope = 3 routes: /teacher/[handle], …/schedule, /certification/[id]) · [MATT-EXEC-EXT] #6 · [MATT-EXEC-GRD] #8
- [ ] [RTMIG-TIER] #12 [Opus] · [RTMIG-4] #13 [Opus]
- [ ] [PRIM-MATCH-INDEX] #14 · [TXTBTN] #17 (watch, <3) · [PROFILE-PRIM-SWEEP] #18 (PAUSED)
- [ ] [ICN-NS] #20 [Opus] · [E2E-MIG] #23 · [E2E-GATE] #24
- [ ] [SHOWMORE] #25 · [SELECT-AUDIT] #26
- [ ] [ADMIN-REDIRECT-BLANK] #27 [Opus] · [SETTINGS-WATCHER] #28 · [BAK-ARTIFACT] #29 (no Peerloop artifacts — ~no-op)
- [ ] [PREFLIP-WT] #30 (KEEP until RTMIG-4 done) · [DOCS-ROUTES-STALE] #35 (hold for #44)
- [ ] [STG-SEED] #41 (watch) · [TZ-AUDIT] #43 [Opus]
- [ ] [APIMAP-LIB-BLIND] #44 (scanner blind to @lib/ fetch; blocks #35) · [SUCCESS-COMMUNITY-VERIFY] #45 (browser-verify) · [APIUSERS-PARAMS] #48 (doc sort/courseId params)

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] [Opus] · #2 [CT-RESTYLE] · #5 [MATT-EXEC-PG2] [Opus] · #6 [MATT-EXEC-EXT] · #8 [MATT-EXEC-GRD]
- [ ] #12 [RTMIG-TIER] [Opus] · #13 [RTMIG-4] [Opus] · #14 [PRIM-MATCH-INDEX] · #17 [TXTBTN] · #18 [PROFILE-PRIM-SWEEP]
- [ ] #20 [ICN-NS] [Opus] · #23 [E2E-MIG] · #24 [E2E-GATE] · #25 [SHOWMORE] · #26 [SELECT-AUDIT]
- [ ] #27 [ADMIN-REDIRECT-BLANK] [Opus] · #28 [SETTINGS-WATCHER] · #29 [BAK-ARTIFACT] · #30 [PREFLIP-WT]
- [ ] #35 [DOCS-ROUTES-STALE] · #41 [STG-SEED] · #43 [TZ-AUDIT] [Opus]
- [ ] #44 [APIMAP-LIB-BLIND] · #45 [SUCCESS-COMMUNITY-VERIFY] · #46 [NOTIF-PORT] · #47 [MSG-PORT] · #48 [APIUSERS-PARAMS]

## Key Context

- **Next-conv work is locked + PLAN-tracked:** ROUTE-MIGRATION row has a Conv-244 note + NEXT-CONV directive. Pattern = **rebuild new Matt components, leave /old untouched** (per registry history + project_old_pages_no_delete_until_vetted). `/messages` is NOT Stream.io (plain 10s REST polling). The Matt `Sidebar` links `/notifications` (404) but has NO Messages entry — MSG-PORT must add it (bottom cluster + COLLAPSED_NAV).
- **Baseline (verified THIS conv):** tsc 0 · astro check 0/0/0 · lint · suite **6458/6458** (371 files) · build clean · prov:sweep **0**. Will be committed in Step 6.
- **MEMORY.md** at 77% bytes after /r-prune-memory (8 pointers re-flattened; cleared the 80% warn).
- **Scope corrections captured:** MATT-EXEC-PG2 = 3 routes not 5 (/login + home already ported); PREFLIP-WT keep until RTMIG-4; DOCS-ROUTES-STALE blocked on APIMAP-LIB-BLIND.
- **[APIMAP-LIB-BLIND] #44:** route-api-map.mjs:215 skips @lib/ imports when tracing fetch — durable fix is a scanner enhancement; route docs under-report until then.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
