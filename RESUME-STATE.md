# State — Conv 134 (2026-04-19 ~08:45)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 134 closed out DOC-SYNC-STRATEGY Phase 3 by implementing Option D — a CC SessionStart hook at `.claude/hooks/tech-doc-drift.sh` that wraps `tech-doc-sweep.sh` with a silent-on-clean design. Option A (CI drift-check) was evaluated and deferred with explicit reactivation triggers. Phase 3 docs (PLAN.md + `docs/as-designed/doc-sync-strategy.md`) were rewritten to reflect the chosen scope and to correct an inverted runtime claim from Phase 2's notes. No code-repo changes this conv.

## Completed

- Phase 3 evaluation across 4 options with runtime measurements on MacMiniM4 (tech-doc-sweep 1.3s, sync-gaps 4.5s)
- `.claude/hooks/tech-doc-drift.sh` authored, chmod +x, smoke-tested both branches (drift + silent)
- Hook wired into `.claude/settings.json` SessionStart (4th entry, after `check-env.sh`)
- PLAN.md DOC-SYNC-STRATEGY block updated (row status line + Phase 3 rewrite + Phase 3 Follow-ups section)
- `docs/as-designed/doc-sync-strategy.md` §4 Phase 3 rewritten; metadata header updated
- Runtime-assumption inversion from Phase 2 corrected in both PLAN.md and the strategy doc
- Decisions/Learnings routed — Decision 1 (Option D chosen) routed to DOC-DECISIONS.md; 1 TIMELINE entry

## Remaining

- [ ] Add `persist-project-dir.sh` to CLAUDE.md §Startup Hooks project-hooks bullet list (pre-existing gap flagged by docs agent — list currently omits the 1st SessionStart hook entry)
- [ ] Review 9 tech-doc-sweep flagged docs for drift — these are pre-existing (HEAD~5 window predates this conv). They will ALSO surface via the new `tech-doc-drift.sh` hook at next `/r-start`, so they will be highly visible. Docs: `docs/reference/stream.md`, `docs/as-designed/feeds.md`, `docs/as-designed/ratings-feedback.md`, `docs/reference/API-COMMUNITY.md`, `docs/reference/resend.md`, `docs/as-designed/session-booking.md`, `docs/as-designed/availability-calendar.md`, `docs/reference/react-big-calendar.md`, `docs/reference/astrojs.md`. For each: real gap → fix; false positive → add to known-noise entry in DOC-DECISIONS.md (see PLAN.md DOC-SYNC-STRATEGY Phase 2 Follow-ups)
- [ ] Validate SessionStart drift hook reliability over 10+ convs — watch for false-positive fatigue and for drift introduced >5 commits ago that escapes the hook's HEAD~5 window
- [ ] CI drift-check (deferred Option A) — reactivate when a non-CC commit path emerges or 10+ convs show SessionStart gaps

## TodoWrite Items

- [ ] #5: Add persist-project-dir.sh to CLAUDE.md §Startup Hooks list
- [ ] #6: Review 9 tech-doc-sweep flagged docs for drift

## Key Context

- **Hook path:** `.claude/hooks/tech-doc-drift.sh` (39 lines). Silent-on-clean: exits 0 with no output when the wrapped `tech-doc-sweep.sh` reports "No reference/as-designed docs flagged" or "No recent code changes detected". Otherwise prints a `=== TECH-DOC DRIFT ===` block.
- **Wired at:** `.claude/settings.json` → `hooks.SessionStart[0].hooks[3]`. Order is: `persist-project-dir.sh` → `dual-repo-info.sh` → `check-env.sh` → `tech-doc-drift.sh`. Infrastructure-health hooks deliberately run before drift reporting.
- **Smoke test for silent branch:** `CLAUDE_PROJECT_DIR=/Users/livingroom/projects/peerloop-docs CODE_CHANGES_OVERRIDE=README.md bash .claude/hooks/tech-doc-drift.sh` should exit 0 with no output. (`CODE_CHANGES_OVERRIDE` is the test hook inside `tech-doc-sweep.sh`.)
- **Runtime numbers (MacMiniM4):** `sync-gaps.sh` 4.5s whole-repo; `tech-doc-sweep.sh` 1.3s `git diff HEAD~5`-based. Phase 2's framing had these inverted — now corrected in both the strategy doc and PLAN.md.
- **Why Option D over B/C:** B (git pre-commit hook) requires per-clone `git config core.hooksPath .githooks`; warn-only hooks get ignored; 2-machine setup doesn't justify the install step. C (both) is overkill given D covers the CC loop.
- **CI deferred (not rejected):** Reactivation triggers are explicit — non-CC commit path emerging OR 10+ convs showing SessionStart drift gaps. See PLAN.md §Phase 3 Follow-ups.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
