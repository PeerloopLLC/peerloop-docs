# State — Conv 250 (2026-06-08 ~13:05)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Started [RTMIG-TIER] and tiered the **admin cluster** (1 of 8). Key outcome: a **policy reversal** — ports now MOVE `/old/X` → `/X` as `@stand-in` (not copy); `/old` is no longer kept live (reference = preflip worktree + git history). Executed the admin rehost ([RTMIG-ADMIN-REHOST]): 14 `/old/admin/*` → `/admin/*` as `@stand-in`, restoring a console that was stranded/broken (everything already deep-linked to `/admin/*`). Fixed [ADMIN-REDIRECT-BLANK] (admin-role gate moved from the broken `AdminLayout` redirect into `middleware.ts`). Then a batch of Matt-Sidebar UX: re-implemented the admin-gated nav item, made selection a fixed-height white pill with no layout shift, added 6px pill padding + tightened gaps 24→18, removed "Feeds" per client request (route+page kept), and fixed a View-Transition gap-revert on `/profile` by inlining the island-unique gap. 3 commits, 5 gates green throughout (test 6459).

## Completed

- [x] [RTMIG-ADMIN-REHOST] #20 — 14 `/old/admin/*` → `/admin/*` as `@stand-in` (git mv + markers); console restored; route map regenerated
- [x] [ADMIN-REDIRECT-BLANK] #12 — admin-role gate moved AdminLayout → middleware.ts (blank 200 → clean 302); unit-tested
- [x] MOVE-not-copy `/old` policy recorded (memory + plan/route-migration/README.md); [PREFLIP-WT] re-scoped to "keep until client-vet"
- [x] Admin cluster (cluster 1 of 8) tiered
- [x] Sidebar: admin nav item; fixed-height selection pill (no shift); pill 6px padding + gap 24→18; Feeds removed; VT gap inline fix

## Remaining

- [ ] [RTMIG-TIER] #1 [Opus] — clusters 2–8 still to tier (admin done). Next likely: Creator Studio (`creating/`, 7). Resolve cluster-6 redirect-vs-port (`/teachers`,`/creators`→`/members`); confirm cluster-8 marketing (15) stays out of the RTMIG-4 count. SoT `plan/route-migration/README.md`.
- [ ] [RTMIG-4] #4 [Opus] — execution; MOVE-not-copy policy now in effect (git mv → `@stand-in` → port in place)
- [ ] [OLD-PORTED-CLEANUP] #21 — delete the 44 already-ported `/old/*` copies (stale under new policy); low priority, confirm per-route
- [ ] [COMM-TAG-FILTER] #2 [Opus] · [CT-RESTYLE] #3 (Tier-2 community restyle)
- [ ] [PRIM-MATCH-INDEX] #5 · [TXTBTN] #6 (watch, <3) · [PROFILE-PRIM-SWEEP] #7 (PAUSED)
- [ ] [ICN-NS] #8 [Opus] · [E2E-MIG] #9 · [E2E-GATE] #10
- [ ] [SHOWMORE] #11 · [SETTINGS-WATCHER] #13
- [ ] [PREFLIP-WT] #14 (KEEP until client-vet) · [STG-SEED] #15 (watch) · [TZ-AUDIT] #16 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #17 (browser-verify) · [MEM-CAP] #18 (prune MEMORY.md, ~80% byte cap) · [DOCGEN-SPEC] #19

## TodoWrite Items

- [ ] #1 [RTMIG-TIER] [Opus] · #2 [COMM-TAG-FILTER] [Opus] · #3 [CT-RESTYLE] · #4 [RTMIG-4] [Opus] · #5 [PRIM-MATCH-INDEX]
- [ ] #6 [TXTBTN] · #7 [PROFILE-PRIM-SWEEP] · #8 [ICN-NS] [Opus] · #9 [E2E-MIG] · #10 [E2E-GATE]
- [ ] #11 [SHOWMORE] · #13 [SETTINGS-WATCHER] · #14 [PREFLIP-WT] · #15 [STG-SEED] · #16 [TZ-AUDIT] [Opus]
- [ ] #17 [SUCCESS-COMMUNITY-VERIFY] · #18 [MEM-CAP] · #19 [DOCGEN-SPEC] · #21 [OLD-PORTED-CLEANUP]

## Key Context

- **MOVE-not-copy `/old` policy (Conv 250, reverses Conv 221):** ports `git mv` `/old/X` → `/X` + `@stand-in` marker + commit (the legacy baseline); `/old` NOT retained. Reference/rollback = preflip worktree (`peerloop-ref`) + git history (`git revert`). Detail: `memory/project_old_pages_no_delete_until_vetted.md`; `plan/route-migration/README.md § Migration policy`.
- **`@stand-in` port topology:** the moved file at the target IS the legacy body — port in place, diff against the move-commit baseline. Admin pages are thin `.astro` wrappers mounting an island (e.g. `AdminAnalytics`); the Matt port is island/body-only (shell `AdminLayout` already Matt). Admin Matt-port is deferred (late).
- **[ADMIN-REDIRECT-BLANK] root cause (learning):** a `return Astro.redirect()` from a *layout* component is a nested-component return → blank 200, not a 302. Route-level role authz must live in `middleware.ts` (now does, for `/admin/*`).
- **VT arbitrary-utility drop (learning, confirmed):** island-unique arbitrary Tailwind utilities on a `transition:persist` component get dropped after a View Transition (gap-[18px] on /profile). Fix = inline the value. Don't convert the sidebar gap inline-styles back to classes.
- **3 commits this conv:** code `b9b1bb7c` (admin rehost + redirect fix) + `376eeadc` (sidebar batch); docs `8603686` (policy + tiering + route-doc regen). Pre-push at Step 5; pushed in Step 7.
- **Empty `src/pages/old/admin/` dir removed** (untracked).
- **[MEM-CAP] #18 still open** — user declined to prune across Convs 248–250.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
