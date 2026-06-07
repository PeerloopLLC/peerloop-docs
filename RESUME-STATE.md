# State — Conv 245 (2026-06-07 ~13:47)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Ported **`/notifications`** + **`/messages`** to root Tier-1 `@matt-inspired` (NOTIF-PORT + MSG-PORT) — new Matt components, legacy `/old/*` islands left untouched; added a Messages NavItem to the Sidebar. Also did APIUSERS-PARAMS (duplicate of M4's). Mid-conv discovered M4 had concurrently run **Conv 246** ([DOCGEN]) on top of our 245-start; reconciled cleanly (ff pull to 246, memory mirror→live re-sync to avoid clobber, all 6 gates re-verified post-merge) and closed as Conv 245 (counter stays 246 → next /r-start = 247). **Note: ran on Opus 4.8 (1M context).**

## Completed

- [x] [APIUSERS-PARAMS] #27 — documented `courseId` + `sort` on GET /api/users (M4's wording kept after merge)
- [x] [NOTIF-PORT] #1 — root `/notifications` `@matt-inspired`: new `NotificationCenter.tsx` + `notifications.astro` (full behavior parity)
- [x] [MSG-PORT] #2 — root `/messages` `@matt-inspired`: 5 islands under `src/components/messages/matt/` + `messages.astro` + Sidebar Messages NavItem (reuses UserIcon/Modal/SearchInput)
- [x] [APIMAP-LIB-BLIND] #25 — done by **M4 Conv 246** [DOCGEN]
- [x] [DOCS-ROUTES-STALE] #22 — retired by **M4 Conv 246** [DOCGEN] (route docs auto-regen at r-end Step 5c; never task it again)

## Remaining

**NEXT (browser-verify the new ports):**
- [ ] [NOTIFMSG-VERIFY] #28 — browser-verify `/notifications` + `/messages` vs `:4331` reference (filter/mark-read/all/clear/delete/load-more/action-links; two-pane + mobile split, 10s polling, new-convo modal+search, ?to=/?conversation= deep-links, send-on-Enter, Sidebar NavItem)

**Carried backlog:**
- [ ] [COMM-TAG-FILTER] #3 [Opus] · [CT-RESTYLE] #4 (Tier-2 token sweep)
- [ ] [MATT-EXEC-PG2] #5 [Opus] (3 routes: /teacher/[handle], …/schedule, /certification/[id]) · [MATT-EXEC-EXT] #6 · [MATT-EXEC-GRD] #7
- [ ] [RTMIG-TIER] #8 [Opus] · [RTMIG-4] #9 [Opus] (~89 legacy /old/* pages)
- [ ] [PRIM-MATCH-INDEX] #10 · [TXTBTN] #11 (watch, <3) · [PROFILE-PRIM-SWEEP] #12 (PAUSED)
- [ ] [ICN-NS] #13 [Opus] · [E2E-MIG] #14 · [E2E-GATE] #15
- [ ] [SHOWMORE] #16 · [SELECT-AUDIT] #17
- [ ] [ADMIN-REDIRECT-BLANK] #18 [Opus] · [SETTINGS-WATCHER] #19 · [BAK-ARTIFACT] #20 (~no-op)
- [ ] [PREFLIP-WT] #21 (KEEP until RTMIG-4 done)
- [ ] [STG-SEED] #23 (watch) · [TZ-AUDIT] #24 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #26 (browser-verify) · [DONEGREP] #29 (verify /r-start no-shrink grep matches *DONE* marker; low priority)

## TodoWrite Items

- [ ] #3 [COMM-TAG-FILTER] [Opus] · #4 [CT-RESTYLE] · #5 [MATT-EXEC-PG2] [Opus] · #6 [MATT-EXEC-EXT] · #7 [MATT-EXEC-GRD]
- [ ] #8 [RTMIG-TIER] [Opus] · #9 [RTMIG-4] [Opus] · #10 [PRIM-MATCH-INDEX] · #11 [TXTBTN] · #12 [PROFILE-PRIM-SWEEP]
- [ ] #13 [ICN-NS] [Opus] · #14 [E2E-MIG] · #15 [E2E-GATE] · #16 [SHOWMORE] · #17 [SELECT-AUDIT]
- [ ] #18 [ADMIN-REDIRECT-BLANK] [Opus] · #19 [SETTINGS-WATCHER] · #20 [BAK-ARTIFACT] · #21 [PREFLIP-WT]
- [ ] #23 [STG-SEED] · #24 [TZ-AUDIT] [Opus] · #26 [SUCCESS-COMMUNITY-VERIFY] · #28 [NOTIFMSG-VERIFY] · #29 [DONEGREP]

## Key Context

- **Concurrent-conv reconciliation (this conv):** M4 ran Conv 246 on top of our 245-start → origin was ahead (not diverged). The trap was the **memory mirror clobber** — our live memory was synced at 245-start (pre-246), so /r-end's live→mirror would have deleted M4's new memories; fixed by re-syncing mirror→live AFTER the ff pull. Always `git fetch` + inspect `HEAD..origin` before /r-end when a cross-machine conv may have landed. (See Conv 245 Learnings 1+2.)
- **[DOCGEN] (M4 Conv 246):** route docs are now `generated` category and auto-regen at **/r-end Step 5c** (regen-generated-docs.mjs, inputs-gated on src/pages|components|lib). NEVER TaskCreate "regen stale route docs" again. Memory `reference_generated_doc_regen.md`.
- **Port pattern (reaffirmed):** rebuild new Matt components, leave `/old` untouched; new messages islands live in `src/components/messages/matt/` (subdir avoids clobbering legacy at the canonical path). Reuse canonical primitives (UserIcon/Modal/SearchInput) + shared `../types`.
- **Baseline (verified THIS conv, post-merge):** tsc 0 · astro check 0/0/0 (1337) · lint · suite **6458/6458** (371) · build · prov:sweep consistent. Will be committed in Step 6.
- **conv number:** closed as 245 on top of 246; CONV-COUNTER=246 → next /r-start = 247.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
