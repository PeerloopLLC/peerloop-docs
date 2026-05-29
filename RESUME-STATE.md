# State — Conv 212 (2026-05-28 ~21:38)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 212 spanned several threads: (earlier) the `npm install → npm ci` switch in `/r-start`, the [SETTINGS-GUARD] ask-tier + `guard-dangerous-bash.sh` PreToolUse hook, removal of the stale pre-dual-repo `.claude/` memory from the code repo, and an npm-upgrade question (resolved: no upgrade). The main thread retrofitted the **last `@stand-in` page, `/profile`**, into a Matt account hub mirroring the `/course/[slug]` tab-family pattern (decision A+1: account hub with the `/settings` 5-page hub flattened into sibling tabs; scaffold reusing existing settings React islands). STANDIN-MATT block is now COMPLETE — 0 `@stand-in` pages remain. Browser-verified all 6 tabs + islands. Stopped at /r-end with everything ready to commit.

## Completed

- [STANDIN-MATT] `/profile` account-hub scaffold (#1) — block closed; 0 @stand-in pages remain
- [PROF-SUBNAV-DEAD] dead SubNav (3 links) replaced by 6 real tabs (#29)
- npm-ci skill switch confirmed + npm-upgrade question resolved (keep 10.9.3, no standalone upgrade)

## Remaining

- [ ] [PROF-TAB-REDESIGN] Faithful Matt redesign of each /profile tab body (Edit/Interests/Payments/Notifications/Security + Account polish) [Opus]
- [ ] [TW-V4-FLAGS] Pre-existing Tailwind v3→v4 flags in 7 components (bg-gradient-to-* genuine; outline-none likely intentional)
- [ ] [LOCKFILE-CI-CHECK] Confirm `npm ci` yields clean tree on M4 next conv (committed lockfile normalization)
- [ ] [GUARD-VERIFY] Confirm Conv 212 ask-tier + guard hook live after restart
- [ ] [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] [SETTINGS-REND-WATCH] Watch /r-end run for unexpected permission prompts under tightened settings
- [ ] (+ the standing block backlog below — DISC-DROP, RTMIG-4, MATT-EXEC-*, MMP-*, E2E-*, etc.)

## TodoWrite Items

- [ ] #2: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #3: [DISC-RTB-RECONCILE] [Opus]
- [ ] #4: [AICODING-SEED]
- [ ] #5: [DISC-UNIFY] pointer to DISC-DROP
- [ ] #6: [RTMIG-4] [Opus]
- [ ] #7: [E2E-MIG]
- [ ] #8: [E2E-GATE] [Opus]
- [ ] #9: [PREFLIP-WT]
- [ ] #10: [MATT-EXEC-PG2] [Opus]
- [ ] #11: [MATT-EXEC-EXT] [Opus]
- [ ] #12: [RTB]
- [ ] #13: [ADMIN-REDIRECT-BLANK] [Opus]
- [ ] #14: [MMP-PH5] [Opus]
- [ ] #15: [MATT-EXEC-GRD]
- [ ] #16: [MMP-PH3] [Opus]
- [ ] #17: [SHOWMORE]
- [ ] #18: [CH-VARIANTS]
- [ ] #19: [ICN-NS] [Opus]
- [ ] #20: [HOWTOREG-ICN]
- [ ] #21: [ASSET-SWEEP-GATE]
- [ ] #22: [MFRD-LOOKUP]
- [ ] #23: [ESOT-STRUCTURE]
- [ ] #24: [BROWSER-FALLBACK]
- [ ] #25: [TXTBTN]
- [ ] #26: [DTUNE-WATCH]
- [ ] #27: [SKILL-DISCOVERY-AUDIT]
- [ ] #28: [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] #30: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] #31: [SETTINGS-REND-WATCH] Watch /r-end run for unexpected permission prompts under tightened Conv 209 settings
- [ ] #32: [GUARD-VERIFY] Confirm Conv 212 ask-tier + guard hook are live after restart
- [ ] #33: [PROF-TAB-REDESIGN] Faithful Matt redesign of each /profile tab body [Opus]
- [ ] #34: [TW-V4-FLAGS] Pre-existing Tailwind v3→v4 flags in 7 components
- [ ] #35: [LOCKFILE-CI-CHECK] Confirm npm ci yields clean tree on M4 next conv

## Key Context

- **`/profile` is now a catch-all** `src/pages/profile/[...tab].astro` (`@matt-inspired`) + `_profile-tabs.ts` (6 tabs: Account/Edit Profile/Interests/Payments/Notifications/Security). Old `profile.astro` deleted. Each settings tab embeds its existing island (`@components/settings/*`). Account tab = identity card + dark-mode + Help + Sign-out.
- **Middleware:** `/profile` is now in `PROTECTED_PREFIXES` (was `PROTECTED_EXACT`) so all sub-tabs are guarded; `tests/middleware.test.ts` has the sub-route assertions.
- **`lock.svg`** harvested into `src/components/icons/svg/` (MattIcon registry 53→54). The MattIcon registry path is `src/components/icons/MattIcon.tsx` (NOT `matt/icons/` — MEMORY.md corrected this conv).
- **#33 redesign** will rebuild each tab's body in Matt primitives (currently reusing legacy islands). `@matt-inspired`, no Matt source frame.
- **Account-tab links** `/@{handle}` + `/help` are intentional honest-404s (decision A) until RTMIG-4 migrates those root routes; commented in-file.
- **Gates were green this conv:** tsc 0 / astro check 1291 / lint 0 / build clean / test 6455/6455 / prov-sweep 0 stand-in.
- **Dev server** left running on :4321; Chrome bridge tab 545380843. Both can be killed/ignored.
- **Route docs regenerated** by the docs agent (page-connections, route-api-map, 3 TSVs + code-repo `tests/plato/route-map.generated.ts`) — all committed this conv.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
