---
name: r-start
description: Start a new conversation — check repos clean, pull both, increment conv, push, resume
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TaskCreate
---

# Start Conversation

**Purpose:** Verify both repos are clean, sync from remote, increment the conversation counter, push the new counter, then present resumption context. This is the **only** entry point for all conversations — both cold starts and warm restarts after `/r-end` → `/clear`.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current CONV-COUNTER value (before increment):**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-counter.sh`

**Existing .conv-current:**
!`test -f .conv-current && echo "WARNING: .conv-current already exists (value: $(cat .conv-current)) — a previous session may not have ended cleanly" || echo "(none — clean state)"`

**Repo status:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/dual-repo-status.sh`

**Dependency sync check (code repo):**
!`bash -c 'LOCK="$CLAUDE_PROJECT_DIR/../Peerloop/package-lock.json"; HASH_FILE="$CLAUDE_PROJECT_DIR/../Peerloop/node_modules/.package-lock-hash"; if [ ! -d "$CLAUDE_PROJECT_DIR/../Peerloop/node_modules" ]; then echo "DRIFT: node_modules missing"; elif [ ! -f "$HASH_FILE" ]; then echo "DRIFT: hash file missing"; elif [ "$(shasum -a 256 "$LOCK" 2>/dev/null | cut -d" " -f1)" != "$(cat "$HASH_FILE" 2>/dev/null)" ]; then echo "DRIFT: package-lock.json changed"; else echo "OK"; fi'`

---

## Paths

- Docs repo: `git -C $CLAUDE_PROJECT_DIR ...`
- Code repo: `git -C $CLAUDE_PROJECT_DIR/../Peerloop ...`

---

## Execution Flow

### Step 1: Check both repos for uncommitted changes

Use the pre-computed repo status above. If **either** repo shows DIRTY:

```
⚠️  Uncommitted changes detected — cannot start cleanly.

Docs repo:
[status output]

Code repo:
[status output]

Options:
1. Commit changes first (run /r-commit)
2. Stash changes and proceed
3. Discard changes (destructive!)
```

**HALT** and wait for user decision. Do not proceed with dirty repos.

### Step 2: Pull both repos

```bash
git -C $CLAUDE_PROJECT_DIR pull --ff-only
git -C $CLAUDE_PROJECT_DIR/../Peerloop pull --ff-only
```

If either pull fails (diverged branches, network error), **HALT** and tell the user. Do not proceed — the conv counter will be out of sync.

### Step 3: Read and increment the counter

Read `CONV-COUNTER`. It contains a single integer (e.g. `3`).

Compute the next value: current + 1.

Format as zero-padded 3-digit string (e.g. `004`).

### Step 4: Write the new counter and lock it

Write the new integer (unpadded) to `CONV-COUNTER`:

```bash
echo {NEW_VALUE} > CONV-COUNTER
```

Write the zero-padded value to `.conv-current`:

```bash
echo {PADDED_VALUE} > .conv-current
```

### Step 5: Commit and push the counter

```bash
git -C $CLAUDE_PROJECT_DIR add CONV-COUNTER
git -C $CLAUDE_PROJECT_DIR commit -m "Conv {PADDED_VALUE} start — {MACHINE}"
git -C $CLAUDE_PROJECT_DIR push
```

If the push fails, **HALT** and tell the user. The counter increment is not synced until pushed.

### Step 5.5: Sync dependencies (code repo)

Check the pre-computed **Dependency sync check** line above.

- If it reports `OK` → skip silently.
- If it reports `DRIFT: ...` → **prompt the user** before running anything:

  ```
  📦 Dependency drift detected in ../Peerloop: {reason}
     Proposed: cd ../Peerloop && npm install

  👉👉👉 Run `npm install` now? (yes / skip)
  ```

  - On **yes**: run `cd $CLAUDE_PROJECT_DIR/../Peerloop && npm install` and show a compact summary (last ~10 lines of output).
  - On **skip**: note it and continue; user is responsible for running it later.

**Why this runs AFTER Step 5:** the conv counter is already pushed, so any file changes `npm install` causes (e.g., an updated `package-lock.json` or generated lockfile artifacts) are tracked under this conv number and will appear in `/r-commit` or `/r-end`.

**Do NOT auto-run without approval** — visible, approved actions are preferred over silent side effects (see CLAUDE.md §Skills: Preserve `!` Backtick Determinism).

### Step 5.7: Sync memory mirror → live

Apply any incoming memory changes from the other machine. The in-repo mirror at `$CLAUDE_PROJECT_DIR/.claude/memory-sync/memories/` was just refreshed by the pull in Step 2; this step propagates it to the live memory directory.

**Two-phase design.** Step 5.7 runs in two phases:

- **Phase 1** (always) — capture `diff -rq` between mirror and live, log full forensics, display one-line summary + per-file detail to stdout. If diff is empty, no decision needed. If diff is non-empty, halt for user approval.
- **Phase 2** (immediately on empty diff, or after approval on non-empty diff) — apply `rsync -a --delete` mirror→live, then run MEMORY.md auto-load cap check on the post-sync state.

The phase split exists so that **every non-empty diff** gets a user checkpoint before the destructive `rsync --delete` runs. This catches not just data-loss-risk cases (`Only in $LIVE`) but also unexpected incoming changes — the user can inspect what's coming in before applying. Empty-diff (mirror == live) skips the prompt because there's no decision to make.

**Phase 1 bash** — forensics + display, no rsync:

```bash
SLUG="${CLAUDE_PROJECT_DIR//\//-}"
LIVE="$HOME/.claude/projects/$SLUG/memory"
MIRROR="$CLAUDE_PROJECT_DIR/.claude/memory-sync/memories"

if [ -d "$MIRROR" ]; then
  mkdir -p "$LIVE"

  CONV=$(cat "$CLAUDE_PROJECT_DIR/.conv-current" 2>/dev/null || echo "unknown")
  TS=$(date +%Y%m%d-%H%M%S)
  LOG_DIR="$HOME/.claude/projects/$SLUG/sync-logs"
  mkdir -p "$LOG_DIR"
  LOG="$LOG_DIR/conv-${CONV}-presync-${TS}.txt"

  DIFF_OUT=$(diff -rq "$MIRROR" "$LIVE" 2>&1 || true)
  DIFF_LINES=$(echo -n "$DIFF_OUT" | grep -c '^' | tr -d ' ')
  MODIFIED_COUNT=$(echo "$DIFF_OUT" | grep -c "^Files " | tr -d ' ')
  ONLY_IN_MIRROR_COUNT=$(echo "$DIFF_OUT" | grep -c "^Only in $MIRROR" | tr -d ' ')
  ONLY_IN_LIVE=$(echo "$DIFF_OUT" | grep "^Only in $LIVE" || true)
  ONLY_IN_LIVE_COUNT=$(echo -n "$ONLY_IN_LIVE" | grep -c '^' | tr -d ' ')
  LIVE_LATEST=$(find "$LIVE" -type f -exec stat -f '%Sm  %N' -t '%Y-%m-%d %H:%M:%S' {} \; 2>/dev/null | sort -r | head -1)

  {
    echo "=== Pre-sync forensics: Conv ${CONV} on $(hostname -s) at $(date) ==="
    echo "Mirror: $MIRROR"
    echo "Live:   $LIVE"
    echo
    echo "Live last-updated file:"
    echo "  $LIVE_LATEST"
    echo
    echo "diff -rq mirror vs live (BEFORE rsync):"
    echo "$DIFF_OUT" | sed 's/^/  /'
  } > "$LOG"

  if [ "$DIFF_LINES" -eq 0 ]; then
    echo "📋 Pre-sync: 0 changes — mirror and live already match."
    echo "    Log: $LOG"
    echo "    Proceeding to Phase 2 (no-op rsync + cap check)."
  else
    echo "📋 Pre-sync diff: ${MODIFIED_COUNT} modified, ${ONLY_IN_MIRROR_COUNT} new in mirror, ${ONLY_IN_LIVE_COUNT} only in live"
    echo "    Live last-updated: $LIVE_LATEST"
    echo "    Log: $LOG"
    echo
    echo "Detail (diff -rq):"
    echo "$DIFF_OUT" | sed 's/^/  /'
    if [ "$ONLY_IN_LIVE_COUNT" -gt 0 ]; then
      BACKUP="$LOG_DIR/conv-${CONV}-live-backup-${TS}"
      cp -R "$LIVE" "$BACKUP"
      echo
      echo "⚠️  DATA-LOSS RISK — ${ONLY_IN_LIVE_COUNT} live-only file(s) would be erased by rsync --delete."
      echo "    Auto-backup created: $BACKUP"
      echo "    Sync did NOT run — awaiting decision."
    else
      echo
      echo "    Sync did NOT run — awaiting approval."
    fi
  fi
fi
```

**Halt-and-ask behavior.** Branch on Phase 1's stdout:

- **`📋 Pre-sync: 0 changes`** → run Phase 2 immediately. No prompt (mirror == live, nothing to decide).

- **`Sync did NOT run — awaiting approval.`** (changes incoming, no live-only files) → ask:

  ```
  👉👉👉 **Apply mirror→live now? (yes / no)**
  ```

  - On `yes` → run Phase 2.
  - On `no` → print this warning and proceed to Step 6 **without** running Phase 2:

    ```
    ⚠️  Sync skipped. Live retains pre-sync state — incoming changes are NOT applied.
        The next /r-end's live→mirror push will overwrite mirror with this state,
        effectively rejecting the incoming changes (recoverable only via git history).
        Resolve the diff manually before /r-end if you want a different outcome.
    ```

- **`⚠️  DATA-LOSS RISK`** (one or more `Only in $LIVE` files) → present the three-option question (auto-backup is already in place from Phase 1):

  ```
  A) Copy the live-only files into the mirror (preserves new memories), then re-run sync
  B) Proceed with rsync --delete anyway (live-only files will be lost — the live backup
     under sync-logs/ is the only recovery path)
  C) Inspect the pre-sync log first

  👉👉👉 **Which — A, B, or C?**
  ```

  - On `A` → bash to copy live-only files into mirror, then re-run Phase 1 (the diff should now be cleaner).
  - On `B` → run Phase 2.
  - On `C` → `Read` the pre-sync log file, then re-ask.

**Phase 2 bash** — apply rsync, run cap check (runs in both empty-diff and post-approval paths):

```bash
SLUG="${CLAUDE_PROJECT_DIR//\//-}"
LIVE="$HOME/.claude/projects/$SLUG/memory"
MIRROR="$CLAUDE_PROJECT_DIR/.claude/memory-sync/memories"

if [ -d "$MIRROR" ]; then
  rsync -a --delete "$MIRROR/" "$LIVE/"
  echo "✅ Sync applied: mirror → live."
fi

# MEMORY.md auto-load cap check — first 200 lines / 25 KB load at every SessionStart
# (per code.claude.com/docs/en/memory.md). Silent when healthy, 🔴 alert at ≥80%.
MEM="$LIVE/MEMORY.md"
if [ -f "$MEM" ]; then
  MEM_LINES=$(wc -l < "$MEM" | tr -d ' ')
  MEM_BYTES=$(wc -c < "$MEM" | tr -d ' ')
  LINE_PCT=$(awk -v l=$MEM_LINES 'BEGIN { printf "%.0f", l/200*100 }')
  BYTE_PCT=$(awk -v b=$MEM_BYTES 'BEGIN { printf "%.0f", b/25600*100 }')
  if [ "$LINE_PCT" -ge 80 ] || [ "$BYTE_PCT" -ge 80 ]; then
    echo "🔴🔴🔴 MEMORY.md nearing auto-load cap: ${MEM_LINES}/200 lines (${LINE_PCT}%), ${MEM_BYTES}/25600 bytes (${BYTE_PCT}%)"
    echo "    → Prune via /r-prune-claude OR move bulky entries to dedicated sub-files. First 200 lines / 25 KB load at every SessionStart."
  fi
fi
```

**MEMORY.md cap monitoring.** Phase 2 checks the live MEMORY.md against the SessionStart auto-load cap (200 lines / 25 KB per `code.claude.com/docs/en/memory.md`). Silent when ≤79%; emits a `🔴🔴🔴` alert at ≥80% of either dimension so we have time to prune before truncation hides recent entries. Pruning options: `/r-prune-claude`, or move bulky inline content to dedicated sub-files referenced by short index lines.

**Pre-bootstrap.** If `$MIRROR` does not yet exist, this is pre-bootstrap — silently skip. The next `/r-end` or `/r-commit` will seed it.

**Sync logs are local-only.** They live under `~/.claude/projects/<slug>/sync-logs/` (outside the repo) — git history is the cross-machine forensic trail; these logs cover this machine's local sync history.

**Then `Read` MEMORY.md** (`$HOME/.claude/projects/$SLUG/memory/MEMORY.md`) so the freshly-synced index lands in the conversation as a tool result. Claude's auto-loaded MEMORY.md (from SessionStart, per `code.claude.com/docs/en/memory.md`: "the first 200 lines or 25KB load at the start of every conversation") is a *pre-sync* snapshot — the explicit Read ensures Claude sees current content for the rest of this conv. Sub-files don't need this treatment; they're read on-demand by Claude as needed, and on-demand reads naturally see freshly-synced content.

### Step 6: Display conversation header

```
╔═══════════════════════════════════╗
║  Conv {PADDED_VALUE}  ·  {MACHINE}  ║
╚═══════════════════════════════════╝
```

### Step 7: Transfer outstanding tasks to TodoWrite

**Dedup guard:** Before transferring, call `TaskList`. If tasks already exist (e.g., from a prior `/r-start` in the same session without `/clear`), skip the transfer and note: `⏭️ TodoWrite already has {N} tasks — skipping RESUME-STATE.md transfer (dedup guard)`. Delete RESUME-STATE.md as usual.

If `RESUME-STATE.md` exists and has a `## Remaining` section with unchecked items (`- [ ]`):

1. Extract each unchecked item from the Remaining section
2. **Assign a unique 2-3 letter bracketed mnemonic code** to each item (per `memory/feedback_todowrite_mnemonic_codes.md`). The code is derived mnemonically from the item's content (e.g., "Tighten drift matchers" → `[DT]`, "Validate hook reliability" → `[DV]`). Track assigned codes across the batch to enforce uniqueness; on collision, append a sequential number (`[GE]` taken → `[GE2]` → `[GE3]`). If the item's original text already begins with a `[XX]` or `[XXX]` bracketed code (e.g., carried-over from a prior conv), reuse it verbatim unless it collides with a code already assigned in this batch.
3. Create a TodoWrite (TaskCreate) entry for each one, using:
   - **subject:** `[CODE] ` + the item text (trimmed, without the checkbox prefix). Always prefix with the code assigned in step 2.
   - **description:** Include any sub-heading context (e.g., "Bug Fix (carried from Conv 010)") and the source: "From RESUME-STATE.md"
4. Display a brief summary (showing each item's assigned code):

```
📋 Transferred {N} outstanding tasks from RESUME-STATE.md to TodoWrite:
- [DT] Tighten drift matchers
- [DV] Validate hook reliability
...
```

5. After successful transfer, delete `RESUME-STATE.md` — the items now live in TodoWrite for this conversation, and the historical state is preserved in git history.

```
🗑️  Deleted RESUME-STATE.md (tasks transferred to TodoWrite)
```

If RESUME-STATE.md doesn't exist or has no unchecked items, skip silently. If it exists but all items are already checked (`[x]`), delete it with a note that all items are done.

### Step 8: Resume work context (inline)

Present the current work position and recommended next action. This step uses pre-computed context and PLAN.md analysis — no external skill call.

#### Pre-computed Resume Context

**PLAN.md exists:**
!`test -f PLAN.md && echo "yes" || echo "NO — PLAN.md not found, cannot resume"`

**Current status header:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/plan-status-header.sh`

**Active/WIP blocks:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/plan-wip-markers.sh`

**Open questions:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/plan-open-questions.sh`

**Active conv (.conv-current):**
!`test -f .conv-current && echo "$(cat .conv-current)" || echo "(none)"`

**RESUME-STATE.md:**
!`cat RESUME-STATE.md 2>/dev/null || echo "(no resume state file)"`

#### Conv State Checks

Before presenting the resume context, evaluate these conditions and display warnings if triggered:

**No active conv:** If `.conv-current` is `(none)`, display:

```
⚠️  No active conv — run /r-start for tracked work, or continue untracked.
```

This is a soft warning — do not block.

**Stale context (raw /clear detected):** If `.conv-current` exists **and** `RESUME-STATE.md` either doesn't exist or its `Conv:` line references an older conv number than `.conv-current`:

First, check if this is a fresh start. Look at the most recent git commit message in the docs repo:

```bash
git log -1 --format=%s
```

If the message matches `Conv {NNN} start —` (where `{NNN}` matches `.conv-current`), this is a **fresh conv** just created by Step 5 — suppress the warning silently.

Otherwise, display:

```
⚠️  Active conv {NNN} but RESUME-STATE.md is stale/missing.
    A raw /clear may have been run without /r-end.
    Work from the previous conv may not have been captured.
```

This is a soft warning — do not block.

#### Multi-Block Consolidation

If `RESUME-STATE.md` contains multiple state blocks (detected by more than one `# State — Conv` heading), consolidate **before** presenting the resume context:

**Step A: Walk blocks oldest → newest**

Read each block's **Remaining** section. For each item in an earlier block:

1. **Check if done** — use `Grep`, `Glob`, `Read`, or `git log --oneline` (via Bash) to determine if the work was completed. Look for the files/changes the item describes.
2. **Check for interactions** — does a later block's Remaining or Completed reference the same files, features, or decisions? Flag overlaps or conflicts.

**Step B: Explain what you intend to do and why**

For each item across both blocks, explain your reasoning:

```
🔄 Consolidating RESUME-STATE.md (2 blocks)
─────────────────────────────────────────────

Block 1: Conv NNN (date) — [1-line summary]
Block 2: Conv MMM (date) — [1-line summary]

✅ Marking as done:
- [item] — done because [evidence: file exists, git log shows commit, etc.]
- [item] — done because [evidence]

⚠️  Interactions between blocks:
- [item from block 1] and [item from block 2] touch the same [file/feature/decision] — [explain the relationship and how you propose to handle it]

⏭️  Carrying forward (still pending):
- [item] — not done because [evidence: file not found, no commits touching this, etc.]
- [item] — not done because [evidence]

🗑️  Dropping:
- [item] — [reason: superseded by block 2 item X / no longer relevant because Y]
```

**Explain every classification.** Wait for user approval before rewriting.

**Step C: Rewrite as single block**

Rewrite `RESUME-STATE.md` as a single `# State — Conv MMM (date)` block (using the latest conv) that merges:
- **Completed**: items from both blocks that are done
- **Remaining**: items from both blocks that are still pending, deduplicated
- **Key Context**: merged from both blocks, dropping stale entries
- **TodoWrite Items**: carried from the latest block only (earlier ones are stale)

#### All-Done Cleanup

After consolidation (Step C) or when reading a single-block file, check whether **all** items in the Remaining section are checked (`[x]`). If so:

1. Display:
```
✅ All remaining items are done — RESUME-STATE.md has no pending work.
   Deleting file (state is preserved in git history and PLAN.md).
```

2. Delete `RESUME-STATE.md`.

3. Continue to present the resume context using PLAN.md only.

#### Present Context

Read PLAN.md fully if the pre-computed context above is insufficient to identify:
- Current WIP block (🔥 or IN PROGRESS marker)
- Latest completed block
- Next planned block
- Subtask checklist status

Present in this format:

```
📍 Current Position
─────────────────

🔥 WIP: BLOCKNAME - [Block Name]
   Progress: [X] of [Y] subtasks complete ([Z]%)

   ✅ Completed:
   - [List completed subtasks]

   ⏭️  Remaining:
   - [Next immediate task with details]
   - [Subsequent tasks]

🏁 Last Completed: BLOCKNAME - [Block Name]

📋 Next Planned: BLOCKNAME - [Block Name]

─────────────────
💡 Quick Context

[1-2 sentence summary of what this block accomplishes and why it matters]

─────────────────
🎯 Recommended Action

[Specific, actionable next step based on current WIP.
 Include file paths and commands when relevant.]

**Start [TASK-CODE] now? (yes / no)**
```

**Resume rules:**
- Focus on the **next actionable step**, not high-level strategy
- Include **specific file paths** and commands when relevant
- Highlight **blockers** that need resolution before continuing
- Keep context brief but sufficient to resume without reading entire PLAN.md
- If RESUME-STATE.md exists with a single block, incorporate its context
- If RESUME-STATE.md has multiple blocks, run **Multi-Block Consolidation** before presenting
- **Recommended Action MUST be the last section** — it ends with a bold Yes/No question (`**Start [TASK-CODE] now? (yes / no)**`) on its own line so the user knows Claude is waiting for input. HALT after asking. Do not begin work until the user answers.

---

## Rules

- **HALT on dirty repos** — never proceed with uncommitted changes
- **HALT on pull failure** — never increment without a successful pull of both repos
- **HALT on push failure** — the counter must be pushed before any work begins
- If `.conv-current` already exists, warn the user (prior session didn't run `/r-end`) but proceed — the counter in `CONV-COUNTER` (post-pull) is the source of truth
- The `CONV-COUNTER` file stores an unpadded integer; `.conv-current` stores a zero-padded 3-digit string
- Do NOT begin any project work until Steps 1–8 are complete
