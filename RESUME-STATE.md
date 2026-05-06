# State — Conv 152 (2026-05-06 ~17:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 152 was a meta/process conv on **MacMiniM4** addressing cross-machine memory drift. User chose to start `[CMS]` per Conv 151's explicit machine designation, but elected to **stay manual** for the durable solution. During the manual sync (rsync from a Desktop snapshot of M4Pro's memory dir) we discovered that memory files contained hardcoded `/Users/jamesfraser/...` and `/Users/livingroom/...` absolute paths — which produce *wrong content* on the destination machine regardless of which sync mechanism is used. This surfaced a new design constraint: **content portability is independent of sync transport**. Spawned and completed `[MPP]` to rewrite paths using `~/projects/...` (style A) and added frontmatter to `e2e-testing-patterns.md`. Built and embedded a 4-layer verification ladder (L1-L4) into the `[MPS]` task that M4Pro must run to demonstrate convergence. M4 is now ahead of M4Pro on memory dir; only sync M4 → M4Pro until [MPS] lands.

## Completed

- [x] [MPP] Memory path portability — rewrote 3 hardcoded-username paths to `~/projects/...` form; added frontmatter to `e2e-testing-patterns.md`. Verified end-to-end: `git -C ~/projects/peerloop-docs status` works, all 50 non-index memory files have `---` frontmatter, runtime tilde expansion confirmed.
- [x] M4 ↔ M4Pro memory dir convergence achieved on M4 side: 51 files, byte-verified against M4Pro snapshot.
- [x] Created `from-M4-memory-conv152-after-MPP.tar.gz` (43KB) on M4 Desktop as the [MPS] transfer artifact.
- [x] Spawned `[MPS]` (M4Pro sync), `[ADR]` (additive-drift constraint), `[BIV]` (bilateral-verification reminder).

## Remaining

- [ ] [PD] Prod cron Worker deploy [Opus] — Block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. Carried from Conv 150→151→152.
- [ ] [CMS] Cross-machine memory sync architecture — design durable solution [Opus] — User chose **manual interim** Conv 152. Durable design still pending. **NEW design constraint recorded this conv:** any sync mechanism propagates bytes verbatim and won't rewrite usernames; content layer must be portable independent of transport. [MPP] satisfied that constraint for current memory files; future memory authors should follow the placeholder pattern. The `[ADR]` task adds a second constraint about additive drift.
- [ ] [MPS] M4Pro memory sync — apply Conv 152 [MPP] + frontmatter fix to converge with M4 — **must run on MacMiniM4-Pro** (not this machine). Tarball at `~/Desktop/from-M4-memory-conv152-after-MPP.tar.gz` on M4 needs to be transferred to M4Pro Desktop first. Self-contained execution + verification procedure embedded in task description (precondition check, backup-first, rsync-apply, L1-L4 re-verification, post-sync invariant). Until this lands: only sync M4 → M4Pro, never reverse.
- [ ] [ADR] Additive-drift constraint for [CMS] design — when [CMS] is picked up, candidate sync mechanisms must demonstrably propagate (a) new files, (b) new sections within existing files, (c) deletions. Manual rsync handles all three; some cloud-sync mechanisms (Dropbox file-level) handle only some cleanly. Surfaced from Conv 152 §Uncategorized.
- [ ] [BIV] Bilateral verification reminder — forward AND reverse direction — reference / reminder, explicitly framed as **not an actionable fix**. Future verification scripts: bilateral checks catch each direction's bugs. Conv 152 example: L2 forward-loop bash bug produced false-positive "all 50 missing" output that was caught only by the reverse orphan check. Surfaced from Conv 152 §Uncategorized.

## TodoWrite Items

- [ ] #1: [PD] Prod cron Worker deploy [Opus] — Block date 2026-04-28 has passed
- [ ] #2: [CMS] Cross-machine memory sync architecture — design durable solution [Opus] — manual interim Conv 152; new design constraint
- [ ] #4: [MPS] M4Pro memory sync — apply Conv 152 [MPP] + frontmatter fix to converge with M4 — must run on M4Pro
- [ ] #5: [ADR] Additive-drift constraint for [CMS] design — sync mechanisms must handle "section absent" not just "section stale"
- [ ] #6: [BIV] Bilateral verification reminder — forward AND reverse direction — reference / reminder, not an actionable fix

## Key Context

**Cross-machine memory dir state at end of Conv 152:**
- **MacMiniM4 (this machine):** 51 memory files, all 50 non-index files have `---` frontmatter, all path references use portable `~/projects/...` or `<user>` placeholder syntax. 4 files differ from the M4Pro Conv 151 snapshot: `MEMORY.md`, `feedback_git_dash_c_enforcement.md`, `feedback_check_memory_before_directive_save.md`, `e2e-testing-patterns.md`. Backup of pre-sync state at `~/Desktop/m4-memory-backup-conv152-before-sync.tar.gz`. Transfer artifact at `~/Desktop/from-M4-memory-conv152-after-MPP.tar.gz`.
- **MacMiniM4-Pro:** still has the Conv 151 snapshot state (`/Users/jamesfraser/...` hardcoded paths in 2 files; `/Users/livingroom/...` historical narrative in 1 file; `e2e-testing-patterns.md` missing frontmatter). Will be brought current by [MPS].

**Sync direction restriction (active until [MPS] runs):** Only sync **M4 → M4Pro**. Reverse direction (M4Pro → M4) would re-introduce the hardcoded-username paths and undo [MPP].

**Conv 152 §Uncategorized findings (now persisted as tasks):**
1. Cross-machine drift includes "additive" cases (new files, new sections), not just "edit" cases. Codified as [ADR].
2. Verification scripts can have their own bugs; bilateral (forward + reverse) checks catch each direction's failures. Codified as [BIV].

**The [MPP] pattern is now established for any future memory-file path references:** use `~/projects/...` for project paths, `~/.claude/projects/-Users-<user>-...` for memory-dir paths with explanatory note about `<user>` substitution. Hardcoded `/Users/<name>/...` paths are not portable and should not be added.

**No code work this conv** — code repo's `package-lock.json` modification is from `/r-start` Step 5.5 `npm install` (dependency-drift housekeeping), not deliberate. Block field for the commit is `(misc)`.

**Memory dir is NOT git-tracked** — lives at `~/.claude/projects/-Users-<user>-projects-peerloop-docs/memory/`. This is the structural problem [CMS] eventually addresses. Until then, memory edits propagate only via the manual Desktop-tarball workflow established Conv 151-152.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
