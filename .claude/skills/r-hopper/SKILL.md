---
name: r-hopper
description: Deal with the hopper — walk each open item in HOPPER.md, rule it with the user (promote to a CURRENT-TASKS.md row / do it now / drop), and clear it immediately. This is the conversational ruling step; it never closes a conv, never commits, never pushes.
argument-hint: ""
allowed-tools: Bash, Read, Edit, Write
---

# Deal with the hopper

Walk the hopper in `HOPPER.md`: **rule** each open (`- [ ]`) item with the user and **clear it the moment it is dealt with** (dealing with an item and disposing of it are one act), and **dispose** of any completed (`- [x]`) rows that reached the hopper from outside this skill. This is the ruling step that `/r-end`'s Step 0.8 gate hands back to: `/r-end` refuses to close over open hopper items — it never rules them itself (ported from fps, Conv 457).

🔴 **Never rule alone** (CLAUDE.md §Investigative Framings / §User-Facing Questions). Every disposition is the user's call. Present the item and its options; do not pick one to keep the skill moving — that is the exact failure this exists to prevent.

🔴 **This is not a close.** It never touches `RESUME-STATE.md`, the Extract, or the commit/push machinery. Committing is `/r-commit`'s job; closing is `/r-end`'s.

**Formats:** capture format lives in `HOPPER.md`; the board is `CURRENT-TASKS.md` (`### [CODE]` body + `## 🎯 Now` line; unique bracketed `[CODE]` per §Task Persistence).

## Pre-computed context

**Hopper items** (scoped to the `## Open` section — a bare grep also matches the capture-format template in the code fence, so it is not used; `- [ ]` = open to rule, `- [x]` = completed to dispose):
!`awk '/^## /{o=($0=="## Open")} o&&/^- \[[ x]\]/' ~/projects/peerloop-docs/HOPPER.md | grep . || echo "(none)"`

**Conv number** (for `promoted Conv NNN` annotations):
!`cat ~/projects/peerloop-docs/.conv-current 2>/dev/null | grep . || cat ~/projects/peerloop-docs/CONV-COUNTER 2>/dev/null | grep . || echo "(none)"`

---

## Step 1 — Read the hopper

Read **`HOPPER.md`**. Under `## Open`, two kinds of line can be present:

- **open items** — `- [ ]` lines, to be **ruled** (Step 3), and
- **completed rows** — `- [x]` lines, finished *outside* this skill (ticked by hand, done mid-conv by habit), to be **disposed** (Step 2).

**Neither present** → say so in one line and stop. An empty hopper is a real state, not a skipped step.

## Step 2 — Dispose of completed rows (`- [x]`) — batch-confirm, then remove

A `- [x]` row is finished work that reached the hopper from **outside** `/r-hopper`, so there is nothing to *rule* — only to dispose of. Present **all** `- [x]` rows as **one batch**: a one-line summary each, a single confirmation, then delete the lot.

🔴 **Confirming disposal of finished work is not ruling.** The confirm exists only to catch a **mis-tick** — an item checked off before it was really done — before its line is gone. `HOPPER.md` is git-tracked, so a slip is recoverable, but a glance is cheap.

- **None present** → say so in one line and move to Step 3.
- The durable record of what was completed is the conv Extract + the board, never a line left in the hopper.

## Step 3 — Rule each open item (`- [ ]`), one at a time

🔴 **One item, one question, in order** (CLAUDE.md §User-Facing Questions — show the item, ask one at a time). For each open `- [ ]` item, present:

- **what it is** and **why it was captured** — the line, plus any indented sub-bullet detail, and
- **what a ruling would decide.**

Then get the user's call, in the **A/B/C** labelled-line format (each option on its own line, `👉👉👉 **Which — A, B, or C?**` last):

- **Promote** → the item earns a `CURRENT-TASKS.md` row. 🔴 *A new task has to earn its place — significant work, or multi-conv.* Most items do not; promoting is the exception, not the default.
- **Do it now** → do the work in this session.
- **Drop** → it was noise, superseded, or no longer worth doing.

🔴 **The user will often want a fuller look before ruling.** Do that investigation first, then re-present. Do not press for a ruling to keep moving.

## Step 4 — Clear the ruled item immediately

**Dealing with an item and disposing of it are one act.** As each open item is ruled, clear it **before moving to the next** — do not tick it to `- [x]`, and do not defer disposal to `/r-end`:

- **Promote** → write the `CURRENT-TASKS.md` row (a `### [CODE]` body under `## Tasks` + a `## 🎯 Now` line, `promoted Conv NNN`), **then delete the hopper line.**
- **Do it now** → do the work, **then delete the hopper line.**
- **Drop** → **delete the hopper line.**

🔴 **Write the row before deleting the line, in that order.** A promotion that deletes the line without first writing the row loses the item. `HOPPER.md` is git-tracked, so a slip is recoverable from the last commit — but do not rely on it. Edit safely per `[EDITSAFE]` — unique anchors, no serializer round-trips.

## Step 5 — Report

One line: `Hopper dealt with — X promoted (handles), Y done, Z dropped, W disposed.` If the hopper was empty, `Hopper already clear.`

After a full pass the hopper holds only genuinely-open items — which is none — so `/r-end`'s Step 0.8 gate closes over it with no bounce.

---

## Notes

- **Run it whenever.** Hopper items are dealt with *during* the conv, as they come up or at a natural break — this skill is how. It is also what the `/r-end` Step 0.8 hopper gate hands back to: deal with the open items here, then re-issue `/r-end`.
- **`- [x]` is tolerated, never created.** `/r-hopper` never leaves a tick when *it* deals with an item — it deletes the line — but a completed row arriving from outside the flow is disposed of at Step 2. The durable record is the conv Extract and the board, not a line left in the hopper.
- **Nothing is optional-by-omission.** An empty hopper is stated in one line, not skipped silently.
