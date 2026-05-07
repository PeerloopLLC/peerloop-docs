# State — Conv 154 (2026-05-06 ~20:02)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 154 designed and landed [MSI] — cross-machine memory sync via skill-based mirror at `peerloop-docs/.claude/memory-sync/memories/`. Replaces the prior [CMS] symlink/manifest sketch and the [ADR] additive-drift constraint (both subsumed by full-mirror design + `rsync -a --delete`). All three boundary skills (`/r-start`, `/r-commit`, `/r-end`) now sync at their existing touchpoints — no Claude Code event hooks involved. Path derivation uses `$HOME` + `${CLAUDE_PROJECT_DIR//\//-}` so the same skill bytes work on both machines. Bootstrap is automatic: this conv's `/r-end` is the first live exercise — Step 5b creates the mirror dir and seeds it from the live 51-file memory dir; the docs commit picks it up via `git add .`. `/r-start` adds an explicit `Read(MEMORY.md)` after its mirror→live rsync to mitigate the documented SessionStart auto-load lag (verified against `code.claude.com/docs/en/memory.md`). Three new tasks surfaced via /r-end: [HOP] save the user's "hands-off pilot" workflow memory, [MMC] add MEMORY.md auto-load cap monitoring, [SPT] save sibling-project skill awareness.

## Completed

- [x] [MSI] Memory-sync skill integration — design + implementation landed
- [x] [MSI-RE] /r-end Step 5b added (live → mirror rsync)
- [x] [MSI-RC] /r-commit Step 1.5 added (live → mirror rsync)
- [x] [MSI-RS] /r-start Step 5.7 added (mirror → live rsync + Read MEMORY.md)
- [x] [CMS] dropped — replaced by [MSI]
- [x] [ADR] dropped — full-mirror design subsumes additive drift

## Remaining

- [ ] [PD] Prod cron Worker deploy [Opus] — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. Carried Conv 150→151→152→153→154.
- [ ] [BIV] Bilateral verification reminder — forward AND reverse direction. Scope tightened Conv 153: `diff -rq tree-A tree-B` is inherently bidirectional; bilateral concern only applies to scripted forward-only file-list walks. Reference / reminder, not actionable fix.
- [ ] [MSI-VERIFY] First end-to-end sync verification — happens NEXT conv on M4Pro: `/r-start` will see new `memory-sync/memories/` dir from Conv 154's push, run Step 5.7, rsync mirror → live. Validate live dirs match byte-for-byte across machines.
- [ ] [HOP] Save `user_hands_off_pilot_workflow.md` memory entry — user-type memory recording the discipline ("user mediates ALL project-file changes through CC") and its architectural implication (designs that trust a single mediated point of authorship are substantially simpler than designs defending against arbitrary edits — made [MSI] "trust mirror at SessionStart" safe by construction).
- [ ] [MMC] Add MEMORY.md auto-load cap monitoring — documented cap is 200 lines / 25KB per `code.claude.com/docs/en/memory.md`. Currently 108 lines / 12.7 KB (~50% headroom). Surface a warning at 80% of either cap so we have time to prune before SessionStart truncation hits.
- [ ] [SPT] Save `reference_spt_dual_repo.md` memory entry — reference-type memory recording that spt/spt-docs is a sibling dual-repo where r-end-soft, r-end-meta, r-start-soft, r-start-meta exist; these are NOT in peerloop-docs (Conv 154 nearly searched for them in peerloop-docs context before user clarified).

## TodoWrite Items

- [ ] #1: [PD] Prod cron Worker deploy [Opus] — block date 2026-04-28 has passed; verify whether prerequisites still hold
- [ ] #4: [BIV] Bilateral verification reminder — forward AND reverse direction
- [ ] #9: [MSI-VERIFY] First end-to-end sync verification — next conv on M4Pro
- [ ] #10: [HOP] Save user_hands_off_pilot_workflow.md memory entry
- [ ] #11: [MMC] Add MEMORY.md cap monitoring
- [ ] #12: [SPT] Save reference_spt_dual_repo.md memory entry

## Key Context

**[MSI] design at end of Conv 154 (final shape):**
- **Storage:** `peerloop-docs/.claude/memory-sync/memories/` — committed, canonical bytes. No separate index file. No manifest. No `.gitignore` additions.
- **Path derivation in skill bash blocks:**
  ```bash
  SLUG="${CLAUDE_PROJECT_DIR//\//-}"
  LIVE="$HOME/.claude/projects/$SLUG/memory"
  MIRROR="$CLAUDE_PROJECT_DIR/.claude/memory-sync/memories"
  ```
- **Sync points (skill-based, no hooks):**
  - `/r-start` Step 5.7 — after pull, mirror → live (`if [ -d "$MIRROR" ]; then mkdir -p "$LIVE"; rsync -a --delete "$MIRROR/" "$LIVE/"; fi`); then explicit `Read` of MEMORY.md to surface fresh content as tool result.
  - `/r-commit` Step 1.5 — before stage, live → mirror (`mkdir -p "$MIRROR"; rsync -a --delete "$LIVE/" "$MIRROR/"`).
  - `/r-end` Step 5b — between SAVE STATE and COMMIT, same as /r-commit.
- **Mirror lags live during conv** (no continuous sync — sync only at skill touchpoints).
- **Bootstrap:** none — first /r-end or /r-commit auto-creates the mirror dir.
- **Concurrent edits:** rely on git's native merge-conflict UX on the in-repo mirror at pull time; /r-start halts on diverged pull (existing behavior).

**[MSI-VERIFY] expected outcome on M4Pro next conv:**
- M4Pro `/r-start` pulls (gets Conv 154's push including the new mirror dir).
- Step 5.7 sees `$MIRROR` exists, runs `rsync -a --delete "$MIRROR/" "$LIVE/"`.
- Since M4 and M4Pro live dirs are byte-identical per Conv 153 [MPS], rsync should be a no-op (no files transferred, no deletions).
- `Read(MEMORY.md)` returns identical content to what M4Pro's auto-load saw at SessionStart.
- VERIFY: run `diff -rq` between M4Pro's live dir and the in-repo mirror — should report no differences.

**MEMORY.md auto-load behavior (verified Conv 154):**
- Per `code.claude.com/docs/en/memory.md`: "the first 200 lines or 25KB load at the start of every conversation" — explicit doc.
- No mid-session auto-refresh (inferred from session-boundary framing in docs, not explicitly promised).
- Current size: 108 lines / 12.7 KB (~50% of either cap). [MMC] task tracks adding monitoring before truncation becomes a real risk.

**Sibling project awareness:**
- Skills `r-end-soft`, `r-end-meta`, `r-start-soft`, `r-start-meta` exist in spt/spt-docs, NOT peerloop-docs. [SPT] task records this so future convs don't search in peerloop-docs context.

**No code repo changes this conv** — code repo clean, jfg-dev-12 unchanged. Block field for the docs commit is `(misc)` (memory-sync infra doesn't advance any current PLAN block).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
