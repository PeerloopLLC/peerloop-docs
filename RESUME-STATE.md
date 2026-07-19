# State — Conv 396 (2026-07-19 ~13:23)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 396 was a **billing-integrity + client-branch-survey conv** (`Block: (misc)`) — the **code repo was never touched** (HEAD still `2d148da7` from Conv 394). It closed a real hole: the code repo is *shared with the client*, who commits from his own Claude Code instances using our `Conv NNN:` convention with **colliding conv numbers**, and every timecard surface was sweeping his branches. Fixed with a `^jfg-dev` allowlist. The rest of the conv was a read-only survey of `brian-July-7` (53 commits, 66 files) which ended **⏸️ on hold** at the user's direction, pending his conversation with the client.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. New this conv: **[MERGE-BRIAN-JULY7]** (top of Ordered, ⏸️ on hold, `[Opus]`), **[TURNLOG]**, **[EDITSAFE]**. `[MEM-PRUNE]` was converted to a **🔁 recurring watch** (it is NOT completable — see below). `[RSYNC-GATE]` got its second confirmed occurrence.

- **[MERGE-BRIAN-JULY7] is ON HOLD and the hold is deliberate — do not re-open it.** The user will talk to the client first, deliberately *open-minded and without an impact map*, so as not to prime toward skepticism before hearing the upside. He was explicit: "Not now… Then we will do the anaysis." CC argued for running the impact analysis first (gates 1–3 measure impact, which is in the code; only *intent* needs the client) and was overruled on receptiveness grounds — **that argument is settled, don't relitigate it.** Every finding is durable in the task entry and none of it expires.

- **The single biggest integration question is NOT a merge conflict.** Conv 392 `cfcfc8af` [ORPHAN-PURGE] deleted `CourseTabs.tsx` (389 lines) as confirmed-dead; the client forked at Conv 370 — *before* the purge — and built **8+ commits of tab architecture on it** (`[TAB-SCROLL]`, `[TAB-FLOAT]`, `[TAB-COMPACT]`, `[TAB-OWNS-PAGE]`). Both calls were locally correct. No per-hunk resolution answers it: does his tab architecture supersede the Matt `/course/[slug]` page, or does the intent get ported onto the page we kept? **Expect more of this class** — his branch predates the purge, so anything built on the other 15 deleted components has the same shape. That exhaustive survey was offered and NOT run.

- **Reassuring counterweight, worth remembering before the next conv panics:** `git merge-tree` says **49 of 66 files are his-only, 12 of the 17 shared files auto-merge cleanly, and only 5 genuinely conflict**. It is less messy at the file level than the discussion implies.

- **Squash is load-bearing, not stylistic.** The `^jfg-dev` allowlist **stops working** the instant his commits land on a `jfg-dev*` branch with history preserved. Hence: integrate as **squashed commits authored by us**. Caveat to honor — `--squash` records no merge parent, so the client must **abandon `brian-July-7` after handoff** and start from the branch we deliver, or every later squash re-presents old changes as conflicts. `[TC-MERGE-TZ]` still gates any merge.

- **Timecard fix — what to know if it ever misbehaves.** `rTimecardDay.codeBranchAllowPattern` (`^jfg-dev`) in `.claude/config.json`, enforced at `discoverCandidateBranches()` in `timecard-day.js`; `--branches='jfg-dev*'` in `/r-timecard`; HEAD pre-flight in `/w-timecard`. **The DOCS repo is deliberately unfiltered** — it lives on `main` and holds the `Conv NNN start —` heartbeats that anchor every day window; filtering it would silently zero every timecard. Verified: 0 client commits on all 6 of his dates, billable minutes unchanged (765/665/830/845), negative test confirms the gate bites. Historical timecards can be regenerated cleanly — **none have been sent to the client**. Memory: `[[project_code_repo_shared_with_client]]`.

- **⚠️ `[MEM-PRUNE]` is a recurring watch that NEVER becomes DONE.** CC marked it complete this conv and the user corrected it — the row was *deleted*, leaving the trigger unrepresented. It recedes below 80% and resurfaces above. MEMORY.md is now **17979 B (70%)**, 124/200 lines. **Both of this conv's big levers are spent**: label-normalization is a permanent no-op, and the duplicated intro blockquote can only be harvested once — the next firing needs *extraction or consolidation*, not more trimming.

- **CC self-discipline flags from this conv (both now tasks):** `.scratch/conv-turns.md` went unmaintained the whole conv and was reconstructed retroactively at `/r-end` ([TURNLOG]) — the user keeps that file open expecting it live. And three programmatic-edit errors shared one cause: rewriting structured markdown/JSON without a unique anchor ([EDITSAFE]).

- **Docs repo commits this conv:** `ee999af` (start heartbeat), `4e60c5d` (allowlist), + the end-of-conv commit. **Code repo: no Conv 396 commits.**

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
