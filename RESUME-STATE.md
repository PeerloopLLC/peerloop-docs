# State — Conv 247 (2026-06-07 ~15:00)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Verification-focused conv. Browser-verified the Conv-245 `/notifications` + `/messages` Matt ports on :4321 ([NOTIFMSG-VERIFY]) — every control passed, 0 console errors — then ran a parallel-agent field-by-field legacy↔new **source parity diff** of both surfaces: **zero functional drops** (all actions, 18 notif types, deep-links, polling, modal flow preserved; messages modal even gained Esc-close/focus-trap via reused primitives). Also closed three small tasks: [DONEGREP] (verified the no-shrink `*DONE*`-marker handling + hardened SKILL.md:368), [BAK-ARTIFACT] (no-op, no artifacts), [SELECT-AUDIT] (Select primitive correctly adopted on Matt surfaces; 24 raw-select files are legacy backlog riding RTMIG-4). No code-repo changes.

## Completed

- [x] [NOTIFMSG-VERIFY] #1 — live browser verify + source parity diff; both ports faithful, 0 drops
- [x] [DONEGREP] #24 — verified `*DONE*`-safe against live fixture; pinned safe grep patterns into SKILL.md:368
- [x] [BAK-ARTIFACT] #19 — verified no-op (no .bak/.orig/backup artifacts anywhere)
- [x] [SELECT-AUDIT] #16 — primitive adoption healthy on Matt surfaces; raw selects are legacy backlog (one flag → TOWNHALL-SELECT)

## Remaining

**New this conv:**
- [ ] [TOWNHALL-SELECT] #25 — community/TownHallFeed (root Matt page) uses raw `<select>` ×2 instead of Select primitive; fold into community-port verification
- [ ] [SEED-DIRTY] #26 — local D1 dev data mutated this conv (deleted 2 notifs + 1 test msg); `npm run db:setup:local:dev` reseeds if a future browser-verify needs the original seed
- [ ] [MEM-CAP] #27 — MEMORY.md at 80% of SessionStart byte cap (20451/25600); run `/r-prune-memory` before it crosses

**Carried backlog:**
- [ ] [COMM-TAG-FILTER] #2 [Opus] · [CT-RESTYLE] #3 (Tier-2 token sweep)
- [ ] [MATT-EXEC-PG2] #4 [Opus] (3 routes: /teacher/[handle], …/schedule, /certification/[id]) · [MATT-EXEC-EXT] #5 · [MATT-EXEC-GRD] #6
- [ ] [RTMIG-TIER] #7 [Opus] · [RTMIG-4] #8 [Opus] (~89 legacy /old/* pages)
- [ ] [PRIM-MATCH-INDEX] #9 · [TXTBTN] #10 (watch, <3) · [PROFILE-PRIM-SWEEP] #11 (PAUSED)
- [ ] [ICN-NS] #12 [Opus] · [E2E-MIG] #13 · [E2E-GATE] #14
- [ ] [SHOWMORE] #15 · [SELECT-AUDIT follow-up: see TOWNHALL-SELECT]
- [ ] [ADMIN-REDIRECT-BLANK] #17 [Opus] · [SETTINGS-WATCHER] #18
- [ ] [PREFLIP-WT] #20 (KEEP until RTMIG-4 done) · [STG-SEED] #21 (watch) · [TZ-AUDIT] #22 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #23 (browser-verify)

## TodoWrite Items

- [ ] #2 [COMM-TAG-FILTER] [Opus] · #3 [CT-RESTYLE] · #4 [MATT-EXEC-PG2] [Opus] · #5 [MATT-EXEC-EXT] · #6 [MATT-EXEC-GRD]
- [ ] #7 [RTMIG-TIER] [Opus] · #8 [RTMIG-4] [Opus] · #9 [PRIM-MATCH-INDEX] · #10 [TXTBTN] · #11 [PROFILE-PRIM-SWEEP]
- [ ] #12 [ICN-NS] [Opus] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [SHOWMORE] · #17 [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #18 [SETTINGS-WATCHER] · #20 [PREFLIP-WT] · #21 [STG-SEED] · #22 [TZ-AUDIT] [Opus] · #23 [SUCCESS-COMMUNITY-VERIFY]
- [ ] #25 [TOWNHALL-SELECT] · #26 [SEED-DIRTY] · #27 [MEM-CAP]

## Key Context

- **Both ports verified faithful (Conv 247):** /notifications + /messages passed live browser verification AND a 2-agent source parity diff with zero functional drops. NOTIF-PORT/MSG-PORT (Conv 245) are done + verified; do NOT re-port.
- **[DONEGREP] resolved + hardened:** /r-start Step 7.5 no-shrink reconciliation is prose-driven; the `*DONE*` live-sync marker (single-asterisk) never collides with `**CODE**` (double) and never shifts the `| N |` row key. Safe grep patterns now pinned in SKILL.md:368.
- **[SELECT-AUDIT] disposition:** `form/Select.tsx` (@matt-inspired) is correctly adopted by the 5 NEW root Matt surfaces. The 24 raw-`<select>` files (50 sites) are predominantly legacy /old-mounted — leave until RTMIG-4 ports their page (no standalone sweep). Only #25 TOWNHALL-SELECT is a genuine root-surface inconsistency.
- **Dev data dirty:** local D1 notifications/messages seed was mutated this conv (user left it). Reseed with `npm run db:setup:local:dev` if needed.
- **No code-repo changes this conv** — only docs-repo SKILL.md edit (DONEGREP hardening) + RESUME-STATE/PLAN bookkeeping. Will be committed in Step 6.
- **conv number:** closed as 247; CONV-COUNTER=247 → next /r-start = 248.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
