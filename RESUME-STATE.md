# State — Conv 214 (2026-05-29 ~09:22)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Short (misc) infrastructure conv. Ran [GUARD-VERIFY] — confirmed the SETTINGS-GUARD system is live after restart (ask-tier, deny-tier, and both PreToolUse Bash hooks registered). Exercising the guard hook surfaced **two real defects**, both from the same blind spot: adjacency-based git rules (`\bgit\s+<sub>\b`) and the `deny` prefix `git push --force:*` silently miss the project's MANDATED `git -C <dir>` form. Fixed both in `guard-dangerous-bash.sh` via a shared `GITOPTS` regex fragment — the Conv 213 commit-message strip now runs on `git -C … commit`, and `git -C … push --force` now escalates to ask (previously ran unconfirmed). 17/17 test matrix green. No code-repo changes; no feature block advanced.

## Completed

- [x] [GUARD-VERIFY] — verified ask/deny/hook tiers live after restart; found + fixed 2 git-`-C`-form defects in guard-dangerous-bash.sh; 17/17 matrix green

## Remaining

- [ ] (standing block backlog — RTMIG-4, MATT-EXEC-*, MMP-*, DISC-*, E2E-*, etc.; see TodoWrite Items below)

## TodoWrite Items

- [ ] #1: [DISC-DROP] Finish discover-page migration Stages 3+4 [Opus]
- [ ] #2: [DISC-RTB-RECONCILE] Reconcile discover real-task-board [Opus]
- [ ] #3: [AICODING-SEED] AI-coding seed
- [ ] #4: [DISC-UNIFY] Discover unify (pointer to DISC-DROP)
- [ ] #5: [RTMIG-4] Per-page /old→root conversion via Matt-shell loop [Opus]
- [ ] #6: [E2E-MIG] Re-point e2e to new routes incrementally
- [ ] #7: [E2E-GATE] Structural-change tier + goto-target resolver check [Opus]
- [ ] #8: [PREFLIP-WT] Remove pre-flip reference worktree when RTMIG-4 inspection done
- [ ] #9: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll/Session families + 5 routes) [Opus]
- [ ] #10: [MATT-EXEC-EXT] Phase 6 extrapolation primitives (build lazily per page) [Opus]
- [ ] #11: [RTB] Real task board item
- [ ] #12: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* yields blank 200 instead of redirect [Opus]
- [ ] #13: [MMP-PH5] Matt component import phase 5 [Opus]
- [ ] #14: [MATT-EXEC-GRD] Phase 7 doc graduation
- [ ] #15: [MMP-PH3] Matt component import phase 3 [Opus]
- [ ] #16: [SHOWMORE] Show-more behavior
- [ ] #17: [CH-VARIANTS] Component/card variants
- [ ] #18: [ICN-NS] Icon namespace [Opus]
- [ ] #19: [HOWTOREG-ICN] How-to-register icon doc
- [ ] #20: [ASSET-SWEEP-GATE] Asset sweep gate
- [ ] #21: [MFRD-LOOKUP] Matt frames-ready-for-dev lookup
- [ ] #22: [ESOT-STRUCTURE] External source-of-truth structure
- [ ] #23: [BROWSER-FALLBACK] Browser fallback
- [ ] #24: [TXTBTN] Text button primitive
- [ ] #25: [DTUNE-WATCH] Dependency-tune watch
- [ ] #26: [SKILL-DISCOVERY-AUDIT] Skill discovery audit
- [ ] #27: [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] #28: [SETTINGS-WATCHER] Investigate external rewriter of .claude/settings.local.json on M4Pro
- [ ] #30: [PROF-TAB-REDESIGN] Faithful Matt redesign of each /profile tab body [Opus]
- [ ] #31: [TW-V4-FLAGS] Pre-existing Tailwind v3→v4 flags in 7 components
- [ ] #32: [LOCKFILE-CI-CHECK] Confirm npm ci yields clean tree on M4 next conv

## Key Context

- **[GUARD-VERIFY] is DONE** — the original carried-over question ("is the guard live after restart?") is answered yes, AND the verification uncovered + fixed two defects. The guard hook change is live immediately (bash re-reads the script per invocation), so the next `git -C … push --force` is already covered (escalates to ask).
- **The `git -C` blind spot is the durable lesson:** the project mandates `git -C <dir>` for every git verb, so any future git-related guard regex OR deny prefix must tolerate global options between `git` and the verb. Recorded in `memory/feedback_git_dash_c_enforcement.md` (new corollary). The fix uses a shared `GITOPTS` ERE fragment in `guard-dangerous-bash.sh`.
- **Bare-form `deny` entries left intact** — defense-in-depth for `git push --force` without `-C`; the `-C` form is structurally un-coverable by prefix-deny (path varies), so the hook is the right layer.
- This /r-end commits docs repo only (code repo clean). The guard hook edit + memory mirror sync land in this commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
