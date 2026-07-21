---
name: r-checkpoint
description: Lightweight mid-conv checkpoint — capture what changed + why into a compaction-proof conv-scoped scratch note, then clear the slate with /compact (no agents, no commit, no push)
argument-hint: "[optional short label for this checkpoint]"
allowed-tools: Bash, Read, Write, Edit, Glob
---

# Checkpoint — capture work + why, then /compact

**Purpose:** A cheap "I'm done with this slice of work, clear the slate for real work" skill. It records **what changed this conv and why** into a conv-scoped scratch note (`.scratch/conv-<NNN>-checkpoint.md`) — the compaction-proof channel that `/r-end` Step 2 auto-globs — so you can then run `/compact` and keep working **in the same conv** without paying for a full `/r-end` (3 agents + commit + push) or a new `/r-start` (counter increment + memory sync + task transfer + companion regen).

**Why this exists:** Housekeeping and small captures shouldn't cost a full end-of-conv cycle. `/compact` keeps the session alive — the conv number and `.conv-current` persist, and `CURRENT-TASKS.md` is on disk regardless — so you continue as the same conv. This skill makes sure the *decisions, rationale, and process learnings* (the things that live only in chat and would be summarized away by `/compact`) are written to disk first.

**Relationship to siblings:**
- `/r-commit` — commits both repos and keeps working (heavier; writes git history). Use when you want a commit.
- `/r-end` — full close: agents → Learnings/Decisions → commit → push. Use at real conv end. It reads the notes this skill writes.
- `/r-checkpoint` (this) — captures to scratch only; **no commit, no push, no agents**. Pairs with `/compact`.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Conv (padded):**
!`~/projects/peerloop-docs/.claude/scripts/conv-read-current.sh`

**Timestamp:**
!`date '+%Y-%m-%d %H:%M'`

**Docs repo changes (peerloop-docs):**
!`git -C ~/projects/peerloop-docs status --short 2>/dev/null || echo "(unavailable)"`
!`git -C ~/projects/peerloop-docs diff --stat 2>/dev/null | tail -1`

**Code repo changes (Peerloop):**
!`git -C ~/projects/Peerloop status --short 2>/dev/null || echo "(unavailable)"`
!`git -C ~/projects/Peerloop diff --stat 2>/dev/null | tail -1`

**Existing checkpoint note for this conv:**
!`ls ~/projects/peerloop-docs/.scratch/conv-$(cat ~/projects/peerloop-docs/.conv-current 2>/dev/null)-checkpoint.md 2>/dev/null && echo "(exists — will append)" || echo "(none — will create)"`

---

## Paths

**CRITICAL:** Always use absolute paths or `-C` flags. Shell cwd drifts after `cd ../Peerloop && npm ...`.

- Docs repo: `git -C ~/projects/peerloop-docs ...`
- Code repo: `git -C ~/projects/Peerloop ...`
- Checkpoint note: `~/projects/peerloop-docs/.scratch/conv-<NNN>-checkpoint.md`

---

## Workflow

### Step 1: Validate conv

Read the **Conv (padded)** pre-computed value. If it is empty or `MISSING`, **HALT** — there is no active conv to checkpoint (tell the user to run `/r-start` first, or that this is an untracked session). The padded number is `<NNN>` throughout.

### Step 2: Gather what changed + why

Assemble the checkpoint content from two sources:

1. **What changed** — the `git status --short` + `diff --stat` from the pre-computed context (both repos). If more granularity is needed, run `git -C <repo> diff --stat`. List the meaningful files and one-line what/why for each. (Uncommitted is expected — this skill never commits.)
2. **Why** — scan **this conv's** conversation for: decisions made (with the option chosen and rationale), learnings, and any **process learnings** (corrections, gotchas, things that would be lost to `/compact`). This is the highest-value part — the diff already captures *what*; only chat captures *why*.

If the user passed a label argument, use it to title this checkpoint section.

### Step 3: Write (or append to) the conv-scoped note

The note lives at `~/projects/peerloop-docs/.scratch/conv-<NNN>-checkpoint.md` (one file per conv, appended to on repeat invocations). Naming MUST be `conv-<NNN>-checkpoint.md` (padded number) so `/r-end` Step 2's `conv-<NNN>-*.md` glob picks it up.

**If the file does not exist**, create it with this header, then the first checkpoint section:

```markdown
# Conv <NNN> — checkpoint notes

> Compaction-proof carrier for /r-end Step 2 (COLLECT). The git diff is the WHAT;
> these sections carry the WHY (decisions, rationale, process learnings) that live
> only in chat and would be lost to /compact. Appended to by /r-checkpoint; read
> (not deleted) by /r-end.
```

**Then append a timestamped section** (every invocation adds one — never overwrite prior sections):

```markdown
## Checkpoint <HH:MM>{ — <label> if provided}

### Changed (uncommitted)
- `path/file` — what + why
- ...

### Decisions
- {decision, option chosen, rationale} — or "None"

### Learnings / process notes
- {learning or correction that would otherwise be lost to /compact} — or "None"
```

Use `Read` then `Edit` to append if the file exists; use `Write` only to create it.

### Step 4: Confirm + hand off to /compact

Display a compact confirmation:

```
🗂️  Checkpoint saved → .scratch/conv-<NNN>-checkpoint.md ({N} sections total)
    Captured: {X decisions, Y learnings, Z changed files}

Slate is ready. CURRENT-TASKS.md (on disk) + conv number persist through /compact.

Next:
  • type /compact to clear the slate and keep working in this conv
  • (or /r-end when you're truly done — it will fold this note into the record)
```

**This is the end of the flow — display and stop.** The `Next:` lines are for the user to type; `/compact` cannot be invoked by a skill. Do NOT commit, push, run agents, write RESUME-STATE.md, or touch memory.

---

## Rules

- **HALT if no active conv** — `.conv-current` must exist (else nothing to checkpoint).
- **Never commit / push / dispatch agents** — this is the lightweight path; `/r-end` does the heavy lifting later and reads this note.
- **Append, never overwrite** — repeat invocations add timestamped sections to the same `conv-<NNN>-checkpoint.md`.
- **Filename is load-bearing** — must be `conv-<NNN>-checkpoint.md` (padded) so `/r-end` Step 2's glob ingests it. See `.scratch/README.md` § Conv-scoped notes.
- **Capture the WHY, not just the WHAT** — the git diff already holds the what; the note's job is decisions/rationale/process learnings that `/compact` would erase.
- **End by instructing `/compact`** — do not attempt to invoke it; it is a user-only command.
