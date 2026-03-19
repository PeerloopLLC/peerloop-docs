---
name: r-resume
description: Resume work by analyzing PLAN.md and current progress
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Resume Work Session

**Purpose:** Analyze PLAN.md to understand current progress and present a concise resumption context.

---

## Pre-computed Context

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

---

## Conv State Checks

Before presenting the resume context, evaluate these conditions and display warnings if triggered:

### No active conv

If `.conv-current` is `(none)`, display:

```
⚠️  No active conv — run /r-start for tracked work, or continue untracked.
```

This is a soft warning — do not block.

### Stale context (raw /clear detected)

If `.conv-current` exists **and** `RESUME-STATE.md` either doesn't exist or its `Conv:` line references an older conv number than `.conv-current`:

**First, check if this is a fresh start.** Look at the most recent git commit message in the docs repo:

```bash
git log -1 --format=%s
```

If the message matches `Conv {NNN} start —` (where `{NNN}` matches `.conv-current`), this is a **fresh conv** just created by `/r-start` — suppress the warning silently.

Otherwise, display:

```
⚠️  Active conv {NNN} but RESUME-STATE.md is stale/missing.
    A raw /clear may have been run without /r-end.
    Consider running /r-save-state to capture current work before continuing.
```

This is a soft warning — do not block.

---

## Multi-Block Consolidation

If `RESUME-STATE.md` contains multiple state blocks (detected by more than one `# State — Conv` heading), consolidate **before** presenting the resume context:

### Step A: Walk blocks oldest → newest

Read each block's **Remaining** section. For each item in an earlier block:

1. **Check if done** — use `Grep`, `Glob`, `Read`, or `git log --oneline` (via Bash) to determine if the work was completed. Look for the files/changes the item describes.
2. **Check for interactions** — does a later block's Remaining or Completed reference the same files, features, or decisions? Flag overlaps or conflicts.

### Step B: Explain what you intend to do and why

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

### Step C: Rewrite as single block

Rewrite `RESUME-STATE.md` as a single `# State — Conv MMM (date)` block (using the latest conv) that merges:
- **Completed**: items from both blocks that are done
- **Remaining**: items from both blocks that are still pending, deduplicated
- **Key Context**: merged from both blocks, dropping stale entries
- **TodoWrite Items**: carried from the latest block only (earlier ones are stale)

---

## All-Done Cleanup

After consolidation (Step C) or when reading a single-block file, check whether **all** items in the Remaining section are checked (`[x]`). If so:

1. Display:
```
✅ All remaining items are done — RESUME-STATE.md has no pending work.
   Deleting file (state is preserved in git history and PLAN.md).
```

2. Delete `RESUME-STATE.md`.

3. Continue to present the resume context using PLAN.md only.

---

## Actions

1. **Read PLAN.md** fully if the pre-computed context above is insufficient to identify:
   - Current WIP block (🔥 or IN PROGRESS marker)
   - Latest completed block
   - Next planned block
   - Subtask checklist status

2. **Present Context** in this format:

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
🎯 Recommended Action

[Specific, actionable next step based on current WIP.
 Include file paths and commands when relevant.]

─────────────────
💡 Quick Context

[1-2 sentence summary of what this block accomplishes and why it matters]
```

---

## Rules

- Focus on the **next actionable step**, not high-level strategy
- Include **specific file paths** and commands when relevant
- Highlight **blockers** that need resolution before continuing
- Keep context brief but sufficient to resume without reading entire PLAN.md
- If RESUME-STATE.md exists with a single block, incorporate its context
- If RESUME-STATE.md has multiple blocks, run **Multi-Block Consolidation** before presenting
