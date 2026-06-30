---
name: r-update-tasks
description: Mid-conv refresh of CURRENT-TASKS.md from the active TodoWrite task list. Preserves the Ordered list, the Parked divider, and every Why line; overlays live statuses by [CODE]. Use whenever you want a fresh view of task state.
argument-hint: ""
allowed-tools: Read, Write, Bash, TaskList
---

# Update CURRENT-TASKS.md

**Purpose:** Refresh `CURRENT-TASKS.md` (root of `peerloop-docs`) so the user can keep it open in their editor as a live working reference. Re-invoke whenever a fresh view is wanted (after marking work done, completing a block, reordering by hand, etc.).

`CURRENT-TASKS.md` is the **persistent home for Peerloop task state** ([CURTASKS], Conv 350–351). It is:
- Tracked in git, persists across convs and machines (no more machine-local `.scratch/conv-tasks.md` staleness)
- Read by `/r-start` to present the resume sequence (it does **not** hydrate TodoWrite — active-only model, DEC-350-2)
- Refreshed by `/r-update-tasks` (this skill — preserves the Ordered list + Parked divider + every *Why* line, overlays statuses)
- Refreshed by `/r-commit` Step 0 and `/r-end` (boundary refreshes — committed state reflects truth)
- **NOT deleted at conv end** — only `RESUME-STATE.md` is the per-conv narrative handoff

The user CAN hand-edit the file mid-conv to reorder tasks, add notes, or rewrite *Why* lines. This skill **preserves their edits** — it is preserve-then-overlay, never regenerate-from-scratch.

---

## Pre-computed Context

**Active conv:**
!`test -f ~/projects/peerloop-docs/.conv-current && cat ~/projects/peerloop-docs/.conv-current || echo "(none)"`

**File path:**
`~/projects/peerloop-docs/CURRENT-TASKS.md`

**File exists:**
!`test -f ~/projects/peerloop-docs/CURRENT-TASKS.md && echo "yes" || echo "no — must be initialized by /r-start"`

---

## Execution Flow

### Step 1: Verify active conv

If `.conv-current` is `(none)`, warn and skip:

```
⚠️  No active conv — CURRENT-TASKS.md refresh only makes sense within a conv. Run /r-start first.
```

### Step 2: Verify file exists

If `CURRENT-TASKS.md` doesn't exist (invoked outside the standard `/r-start → conv work → /r-end` flow), tell the user and skip — do **not** silently invent ordering:

```
⚠️  CURRENT-TASKS.md doesn't exist. To bootstrap, create it by hand with at least an empty
    `## 🔥 Ordered (next-conv execution sequence)` section, or run /r-start in a fresh conv.
```

### Step 3: Read existing CURRENT-TASKS.md

`Read` the file in full. **The existing Ordered list (with its *Why* lines), the `> ## ⏸️ PARKED` divider, and the Parked entries below it are the authoritative source for ordering — preserve them verbatim.**

### Step 4: List current task state

Call `TaskList`. Build a map keyed by the `[CODE]` parsed out of each task's subject: `{CODE: {subject, status}}`. (`[CODE]` is the sole stable key — peerloop TaskCreate subjects always start with a bracketed code per CLAUDE.md §Work Tracking.)

### Step 5: Parse the existing sections

Extract H3 (`### `) blocks under `## 🔥 Ordered` and under `## 📋 Unordered backlog`. Both are H3 blocks; Ordered carries a `· status ·` segment in its header + a Status/Next/Why/Refs bullet set, backlog omits the status segment and is freer-form (a lead line + adaptive sub-bullets):

```
### [CODE] · {status — Ordered only} · [model]

{one-line lead summary}

- {sub-bullets — Ordered: Status / Next / Why / Refs; backlog breaks the body at logical points}
```

Build `{code, why, oldStatus, header, body}` records for each row. **Match by `[CODE]` only** — there are NO numeric `#N` IDs; never introduce one.

**Preserve-rule (the load-bearing correctness invariant — spt's Conv-147 [TWAO] rule):** Do **NOT** drop a file row merely because no `TaskList` entry exists for its `[CODE]`. Under the **active-only** TodoWrite model (DEC-350-2), `TaskList` holds only what is in flight or just-completed *this* conv; backlog and Parked rows routinely have no `TaskList` counterpart and MUST be preserved verbatim. Regenerate-from-TaskList would erase the entire backlog — this skill never does that.

### Step 6: Determine each section's content

- **🔥 Ordered** — the parsed Ordered list, **in file order**. For each entry, code-match against `TaskList`:
  - matched & `in_progress` → force the header segment to `· 🔄 Active ·` (this is the one status TodoWrite knows authoritatively);
  - matched & `pending` → **preserve the existing header symbol verbatim** (★ Next / 📋 Planned / ⏸️ On hold are *hand-set priorities* the user curates; `TaskList`'s flat `pending` carries no priority granularity, so never downgrade a hand-set symbol to a generic one);
  - unmatched → **preserve the header status verbatim**;
  - matched & `completed` → move the entry to the Completed section and remove it from Ordered.
- **📋 Unordered backlog** — preserve **all** existing backlog entries verbatim, in order, **including the `> ## ⏸️ PARKED` blockquote divider and every Parked entry below it**. A code-matched `completed` backlog task moves to Completed; otherwise the entry stays as-is. **Append** any `TaskList` entries with status `pending` or `in_progress` whose `[CODE]` is in neither Ordered nor Unordered — these are newly created this conv. **Insertion point: immediately ABOVE the `> ## ⏸️ PARKED` divider** (so new active backlog never lands below the parked items); if there is no Parked divider, append at the end of the backlog. Do NOT reorder or rewrite existing entries.
- **✅ Completed this conv** — `TaskList` entries with status `completed` (plus any moved out of Ordered/backlog above). Cap at the last 10.

**Peerloop 3-anchor note (differs from spt):** there is **no** `## 🔴 In progress` section — the locked design (PLAN § CURTASKS, DEC) enumerates exactly three load-bearing H2 anchors. In-progress status is surfaced via the Ordered header segment (`· 🔄 Active ·`). An `in_progress` task that lives in the backlog (a started backlog item) keeps its place; its in-flight state lives in TodoWrite for the conv and resolves at `/r-end` (→ Completed, or stays backlog). Do not auto-promote it into Ordered — never reorder unless the user asks.

### Step 7: Render and write

Template (preserve the three `## ` H2 anchors **exactly** — the `/r-start` + `/r-end` parsers key on them):

```markdown
# Current Tasks — between convs

> Last refreshed {YYYY-MM-DD} (Conv {NNN}). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
>
> **Persistent home for Peerloop task state.** Tracked in git so both machines see the same state
> via `/r-commit` push/pull. Edit by hand to reorder; the refresh (`/r-update-tasks`, plus `/r-commit`
> + `/r-end`) preserves your edits and overlays statuses from TodoWrite for code-matched rows.
>
> **Format:** Tasks are keyed by `[CODE]` (the sole stable identifier — no numeric IDs). Every task is
> an H3 (`### [CODE] · status · [model]`; the status segment appears in Ordered only) with a lead line
> then sub-bullets (Ordered uses Status / Next / Why / Refs; backlog is a lead line + adaptive
> sub-bullets). **Lanes** fold related micro-tasks into one H3's sub-bullets. **Parked** items sit under
> the blockquoted `> ## ⏸️ PARKED` divider near the end of the backlog. Only the three real `## ` H2
> anchors (🔥 Ordered / 📋 Unordered backlog / ✅ Completed this conv) are load-bearing.

---

## 🔥 Ordered (next-conv execution sequence)

{one H3 block per entry, in file order — status lives in the header, Why preserved verbatim:

### [CODE] · {🔄 Active / ★ Next / ⏸️ On hold / 📋 Planned} · [model if any]

{one-line lead summary}

- **Status:** {fresh status from TodoWrite overlay, else preserved}
- **Next:** {next action — preserved/updated}
- **Why:** {preserved verbatim from file}
- **Refs:** {preserved — files / decisions / plans}
}

If empty after dropping completed entries: "(no ordered tasks remain — everything queued is now done or moved)"

---

## 📋 Unordered backlog

{one H3 block per entry — no status segment; a lead line + adaptive sub-bullets, full text preserved.
New pending/in-progress tasks appended here, immediately above the Parked divider:

### [CODE] · [model/doc if any]

{one-line lead}

- {sub-bullets breaking the body at logical points}
}

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

{Parked H3 entries — preserved verbatim, in order}

---

## ✅ Completed this conv

{bullets — most recent N=10 first if many; "(none …)" placeholder if empty}
```

`Write` the file (full overwrite — **never** `Edit` for this file, never delete a row, never reorder unless the user asked).

### Step 8: Output a one-line summary

```
✅ Wrote CURRENT-TASKS.md — {O} ordered, {P} backlog, {D} done this conv
```

If any Ordered entries moved to Completed, add:

```
✅ Moved from Ordered to Completed: [CODE1], [CODE2]
```

If any new tasks were appended to the backlog:

```
➕ Appended to backlog (new this conv): [CODE3]
```

---

## Rules

- **Never invent ordering.** The Ordered list comes from the existing file (or, at the very first cutover, from `/r-start`'s seed). Never reorder by your own judgment unless the user asks.
- **Preserve *Why* lines + the Parked block verbatim.** They may hold hand-edits, rationale, or details that don't exist in TodoWrite.
- **Never delete a backlog/Parked row** merely because it's not in `TaskList` — active-only TodoWrite means unmatched rows are the normal case (the [TWAO] hard guard).
- **Drop completed entries from Ordered** — once done, a task leaves the execution sequence and moves to Completed.
- **Always overwrite with `Write`**, never `Edit`. The file IS the source of truth; this skill regenerates a faithful snapshot of it + live statuses.
- **`[CODE]` is the only key.** No numeric IDs, no reliance on TaskGet metadata.
