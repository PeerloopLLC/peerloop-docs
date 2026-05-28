# State — Conv 209 (2026-05-28 ~13:50)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 209 was a full audit + restructure of the CC settings system across all three layers: settings.local.json was cleaned (133 → 83 lines, then tightened with Tier 1 path-scoping and a 15-entry git deny block); settings.json (project-committed) was cleaned (13 → 10, then grown to 80 allow + 15 deny via promotion); global ~/.claude/settings.json was reduced to client-flags-only (46 → 22 lines, backup at `~/.claude/settings.json.bak-conv209`). New three-tier model established: global = CC client UX; project committed = repeatable tool envelope + deny rails; project local = destructive grants + per-machine paths. No code repo changes. No PLAN block advanced (Block: misc).

## Completed

- [x] settings.local.json full cleanup (133 → 83; collapse one-offs, drop ghost-skills/dead-shots/orphan-loops/redundancies, normalize wildcards, remove `bash:*`, add 15 utilities)
- [x] Tier 1 path-scoping (`node`/`python3`/`npx tsx` confined to known dirs; `xargs:*` dropped)
- [x] Tier 3-git deny block added (15 entries: force-push, hard reset, dangerous clean, branch -D, checkout discard)
- [x] settings.json (project) cleanup (13 → 10; drop vestigial /RFC and /research; drop env.TEST_ENV_VAR; add Write/docs)
- [x] Global ~/.claude/settings.json reduced to client-flags-only (46 → 22; backup created)
- [x] Added cat/sed/tr to local (and survived a linter rewrite)
- [x] Promoted ~67 entries from local → project (settings.json now 80 allow + 15 deny)

## Remaining

- [ ] [STANDIN-MATT] [Opus] Retrofit /profile — substantive design work
- [ ] [DISC-DROP] [Opus] Finish discover-page migration Stages 3+4
- [ ] [DISC-RTB-RECONCILE] [Opus]
- [ ] [AICODING-SEED]
- [ ] [DISC-UNIFY] pointer to DISC-DROP
- [ ] [RTMIG-4] [Opus]
- [ ] [E2E-MIG]
- [ ] [E2E-GATE] [Opus]
- [ ] [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus]
- [ ] [MATT-EXEC-EXT] [Opus]
- [ ] [RTB] [Opus]
- [ ] [ADMIN-REDIRECT-BLANK]
- [ ] [MMP-PH5] [Opus]
- [ ] [MATT-EXEC-GRD]
- [ ] [MMP-PH3] [Opus]
- [ ] [SHOWMORE]
- [ ] [CH-VARIANTS]
- [ ] [ICN-NS] [Opus]
- [ ] [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE]
- [ ] [MFRD-LOOKUP]
- [ ] [ESOT-STRUCTURE]
- [ ] [BROWSER-FALLBACK]
- [ ] [TXTBTN]
- [ ] [DTUNE-WATCH]
- [ ] [SKILL-DISCOVERY-AUDIT]
- [ ] [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] [PROF-SUBNAV-DEAD] Profile SubNav has 3 dead links
- [ ] [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro (NEW Conv 209)

## TodoWrite Items

- [ ] #1: [STANDIN-MATT] [Opus] Retrofit /profile — substantive design work
- [ ] #2: [DISC-DROP] [Opus] Finish discover-page migration Stages 3+4
- [ ] #3: [DISC-RTB-RECONCILE] [Opus]
- [ ] #4: [AICODING-SEED]
- [ ] #5: [DISC-UNIFY] pointer to DISC-DROP
- [ ] #6: [RTMIG-4] [Opus]
- [ ] #7: [E2E-MIG]
- [ ] #8: [E2E-GATE] [Opus]
- [ ] #9: [PREFLIP-WT]
- [ ] #10: [MATT-EXEC-PG2] [Opus]
- [ ] #11: [MATT-EXEC-EXT] [Opus]
- [ ] #12: [RTB] [Opus]
- [ ] #13: [ADMIN-REDIRECT-BLANK]
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
- [ ] #29: [PROF-SUBNAV-DEAD] Profile SubNav has 3 dead links
- [ ] #30: [SETTINGS-WATCHER] Investigate external rewriter

## Key Context

- **Three-tier settings model established this conv:**
  - **Global** (`~/.claude/settings.json`, 22 lines): CC client UX only — `statusLine`, `alwaysThinkingEnabled`, `verbose`, `autoCompactEnabled: false`, `agentPushNotifEnabled`, SessionStart hook (detect-machine.sh). No permissions.
  - **Project committed** (`peerloop-docs/.claude/settings.json`, 80 allow + 15 deny): Peerloop's official CC tool envelope. Universal shell utilities, npm/npx/wrangler/node-scoped/tsx-scoped/python3-scoped, git/gh, Skills, tech-stack WebFetch domains. Full deny block (force-push, hard reset, dangerous clean, branch -D, checkout discard).
  - **Project local** (`peerloop-docs/.claude/settings.local.json`, 11 allow, gitignored): destructive + per-machine + editor — `rm:*`, `rsync:*`, `pkill:*`, `curl:*`, `python3 *` (broad escape), `brew install`/`brew list`, `open:*`, `code:*`, `lsof -ti:4321`, `vscodethemes.com` WebFetch.

- **Tier 1 (arbitrary code exec) is path-scoped, not banned.** `Bash(node .claude/scripts/*)`, `Bash(node ../Peerloop/scripts/*)`, `Bash(node scripts/*)`, `Bash(node /tmp/*)`; parallel for `npx tsx` and `python3`. Preserves legitimate use, denies `-e '<arbitrary>'` escape.

- **Tier 3-git deny block known limitations:**
  1. `git -C <path> push --force` form NOT covered — CC matcher is prefix-based; deny patterns only match the bare `git push --force*` form. The system-prompt's "confirm before destructive git" guidance remains the guardrail for `git -C` invocations.
  2. `npm run` subprocess invocations bypass CC's permission layer entirely — if a script defined in package.json invokes `git push --force`, the deny won't intercept.

- **Backup of pre-conv global settings:** `~/.claude/settings.json.bak-conv209` — restore via `cp` if anything breaks.

- **Side effects of global stripping:** `grep:*`, `sed:*`, `cat ~/.claude/.machine-name*`, `cursor /tmp/*` were globally allowed and now prompt in any project without its own grants. peerloop-docs covers all of these via its own settings.

- **Second machine (M4) setup:** after next pull, settings.json provides 80 entries for free. M4 needs its own settings.local.json populated with destructive/Mac/editor grants — or sync .claude/settings.local.json manually if you want identical local grants.

- **Empirical caveat — /r-end this conv had not been re-run with the new tightened settings.** First test of unattended execution under the new permissions happens NEXT conv. Three utilities (`cat`, `sed`, `tr`) explicitly added to settings.json allow; `bash <path>/script.sh` form for r-end's `advance-drift-baseline.sh` was NOT added (per user's earlier C choice to surface gaps empirically).

- **External watcher on M4Pro rewrites settings.local.json** between CC's edits — flattens blank-line section breaks, also added `Bash(python3 *)` at file end during this conv. Tracked as #30 [SETTINGS-WATCHER]. CC should consider re-reading settings files before each Write to avoid stomping watcher additions.

- **Branch:** code `jfg-dev-13-matt`, docs `main`. Code repo CLEAN end of conv. Docs repo has settings.json modified + RESUME-STATE.md deleted (transferred) — both will be in this conv's commit.

- **No baseline gates run this conv** (settings-only work; no code changes). Last green: Conv 207 (tsc 0; astro check 1290/0/0/0; lint 0; build clean; tests 6452/6452).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
