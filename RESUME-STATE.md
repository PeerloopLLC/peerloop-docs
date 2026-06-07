# State — Conv 246 (2026-06-07 ~09:16)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Infra/tooling conv. Built **[DOCGEN]** — gave the existing-but-toothless `generated` doc category an executable regen binding + a deterministic r-end **Step 5c gate** (`regen-generated-docs.mjs`), so projection docs (route maps) auto-regenerate on route-source change instead of lingering as the recurring #22 task. 5 phases, all verified; full baseline green (suite 6458). Also hardened **/r-start** (deferred RESUME-STATE deletion to Step 7.6 + ledger-based no-shrink reconciliation) after the backstop false-halted on a legitimate Conv-244 triage shrink. Closed #25 (scanner @lib-fetch fix), #22 (mechanized), #27 (API-USERS param doc).

## Completed

- [x] [DOCGEN] #28 — `generated` category given executable `regen` binding (config.json) + deterministic r-end Step 5c gate (`regen-generated-docs.mjs`); reclassified 5 route docs; removed Agent 3 manual regen. All 5 phases verified end-to-end.
- [x] [APIMAP-LIB-BLIND] #25 — `route-api-map.mjs` now traces `@lib/` fetch with `AMBIENT_LIB=['current-user']` suppress (by resolved basename); `useCanMessage`→`/api/me/can-message` surfaced, ambient `/api/me/full` no longer sprayed.
- [x] [DOCS-ROUTES-STALE] #22 — route docs regenerated AND mechanized (resolved by DOCGEN; can't recur).
- [x] [APIUSERS-PARAMS] #27 — added `courseId` + `sort` rows to GET /api/users in API-USERS.md.
- [x] /r-start hardening — Step 7 deletion deferred to Step 7.6; Step 7.5 = ledger-based no-shrink reconciliation (halt only on unexplained loss). Memory updated.
- [x] Baseline verified green THIS conv: tsc 0 · astro 0/0/0 (1329) · lint · tailwind · build · suite **6458/6458** (371 files) · codecheck greps 5–9 pass.

## Remaining

**NEXT CONV (explicit Conv-244 directive, in order):**
- [ ] [NOTIF-PORT] #1 — port `/notifications` to root Tier-1 `@matt-inspired` (rebuild NotificationsList w/ MattIcon + Matt tokens; keep filter tabs/mark-read/mark-all/delete/load-more/empty-states). Sidebar href present (404s today). FIRST.
- [ ] [MSG-PORT] #2 — port `/messages` to root Tier-1 `@matt-inspired` (rebuild 4 islands; 10s polling, ?to=/?conversation= deep-links, new-convo modal+user-search, unread, mobile list/thread split) AND add Messages NavItem to Matt Sidebar. NOT Stream.io. SECOND.

**Carried backlog:**
- [ ] [COMM-TAG-FILTER] #3 [Opus] · [CT-RESTYLE] #4 (Tier-2 token sweep)
- [ ] [MATT-EXEC-PG2] #5 [Opus] (3 routes: /teacher/[handle], …/schedule, /certification/[id]) · [MATT-EXEC-EXT] #6 · [MATT-EXEC-GRD] #7
- [ ] [RTMIG-TIER] #8 [Opus] · [RTMIG-4] #9 [Opus]
- [ ] [PRIM-MATCH-INDEX] #10 · [TXTBTN] #11 (watch, <3) · [PROFILE-PRIM-SWEEP] #12 (PAUSED)
- [ ] [ICN-NS] #13 [Opus] · [E2E-MIG] #14 · [E2E-GATE] #15
- [ ] [SHOWMORE] #16 · [SELECT-AUDIT] #17
- [ ] [ADMIN-REDIRECT-BLANK] #18 [Opus] · [SETTINGS-WATCHER] #19 · [BAK-ARTIFACT] #20 (~no-op)
- [ ] [PREFLIP-WT] #21 (KEEP until RTMIG-4 done) · [STG-SEED] #23 (watch)
- [ ] [TZ-AUDIT] #24 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #26 (browser-verify) · [DOCGEN-SPEC] #29 (document regen binding in doc-sync-strategy.md, low priority)

## TodoWrite Items

- [ ] #1 [NOTIF-PORT] · #2 [MSG-PORT] · #3 [COMM-TAG-FILTER] [Opus] · #4 [CT-RESTYLE] · #5 [MATT-EXEC-PG2] [Opus]
- [ ] #6 [MATT-EXEC-EXT] · #7 [MATT-EXEC-GRD] · #8 [RTMIG-TIER] [Opus] · #9 [RTMIG-4] [Opus] · #10 [PRIM-MATCH-INDEX]
- [ ] #11 [TXTBTN] · #12 [PROFILE-PRIM-SWEEP] · #13 [ICN-NS] [Opus] · #14 [E2E-MIG] · #15 [E2E-GATE]
- [ ] #16 [SHOWMORE] · #17 [SELECT-AUDIT] · #18 [ADMIN-REDIRECT-BLANK] [Opus] · #19 [SETTINGS-WATCHER] · #20 [BAK-ARTIFACT]
- [ ] #21 [PREFLIP-WT] · #23 [STG-SEED] · #24 [TZ-AUDIT] [Opus] · #26 [SUCCESS-COMMUNITY-VERIFY] · #29 [DOCGEN-SPEC]

## Key Context

- **[DOCGEN] mechanism (durable):** `generated` docs auto-regen at r-end **Step 5c** via `.claude/scripts/regen-generated-docs.mjs`, inputs-gated on `src/pages|components|lib` vs `.drift-baseline-sha`. Bindings in `config.json` docsRegistry group `route-docs-generated` (`regen:{cwd,commands,inputs,alsoWrites}`). NEVER TaskCreate "regen stale route docs" again. `route-stories.md` is hand-written (driftCheck), NOT generated. Memory: `reference_generated_doc_regen.md`. Follow-up #29 [DOCGEN-SPEC].
- **/r-start no-shrink:** now reconciles against RESUME-STATE Completed/Dropped ledger (deletion deferred to Step 7.6); halts only on unexplained loss. `*DONE*`-count heuristic demoted (breaks on stale companion).
- **Next-conv ports unchanged:** rebuild new Matt components, leave /old untouched. `/messages` NOT Stream.io. Matt Sidebar links `/notifications` (404) but has NO Messages entry — MSG-PORT must add it.
- This conv touched NO route source (only `scripts/route-api-map.mjs`), so the Step 5c gate correctly skips its own regen at this r-end; route docs were regenerated manually this conv (the @lib fix + Convs 233–245 catch-up).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
