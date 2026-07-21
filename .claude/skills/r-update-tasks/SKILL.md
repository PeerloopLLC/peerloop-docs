---
name: r-update-tasks
description: Validate + tidy CURRENT-TASKS.md — the write-through task board. Checks that every 🎯 Now / ⏸️ Parked TOC line has a matching task body and vice versa, moves finished tasks to ✅ Done this conv, and reports. No Task-tool overlay (the subsystem is server-gated off — see [TASK-TOOLS-VERIFY]); the file IS the state.
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash
---

# Validate + tidy CURRENT-TASKS.md

**Purpose:** `CURRENT-TASKS.md` (root of `peerloop-docs`) is a **write-through task board** — CC edits it directly the moment a task changes (there is no Task-tool overlay; the subsystem is server-gated off, see `[TASK-TOOLS-VERIFY]` and CLAUDE.md §Task Persistence). So this skill is **not** a regenerate step — it's a lightweight **validate + tidy** pass the user can run whenever they want the board double-checked. Re-invoke after a burst of edits, before a commit, or any time a fresh consistency check is wanted.

`CURRENT-TASKS.md` is:
- Tracked in git; persists across convs and machines via `/r-commit` push/pull.
- Read by `/r-start` to present the resume sequence (Step 8).
- Validated + tidied by this skill, `/r-commit` Step 0, and `/r-end` Step 5.
- **NOT deleted at conv end** — only `RESUME-STATE.md` is the per-conv narrative handoff.

## The format (what this skill validates against)

Four load-bearing `## ` H2 anchors, in this order:

- **`## 🎯 Now`** — ordered execution TOC. Numbered list; each line `N. [CODE](#code-slug) — short title`. Top = next.
- **`## ⏸️ Parked`** — gated TOC. Bulleted; each line `- [CODE](#code-slug) — gate: …`.
- **`## Tasks`** — one `### [CODE]` body per task, **alphabetical by code**, each opening with a `- **State:** …` bullet then terse bullets. **Bodies never move** as state changes.
- **`## ✅ Done this conv`** — one-liners for tasks finished this conv (`/r-start` clears it each conv).

`[CODE]` (unique, bracketed) is the sole key. The anchor slug is the code lowercased with brackets stripped (`[A11Y]` → `#a11y`, `[MERGE-BRIAN-JULY7]` → `#merge-brian-july7`).

---

## Pre-computed Context

**Active conv:**
!`test -f ~/projects/peerloop-docs/.conv-current && cat ~/projects/peerloop-docs/.conv-current || echo "(none)"`

**File path:**
`~/projects/peerloop-docs/CURRENT-TASKS.md`

**File exists:**
!`test -f ~/projects/peerloop-docs/CURRENT-TASKS.md && echo "yes" || echo "no — must be initialized by /r-start"`

**Anchor / TOC consistency probe** (codes in each TOC vs codes with a body):
!`~/projects/peerloop-docs/.claude/scripts/current-tasks-check.sh 2>/dev/null || echo "(checker script absent — validate by hand in Step 4)"`

---

## Execution Flow

### Step 1: Verify active conv

If `.conv-current` is `(none)`, warn and skip:

```
⚠️  No active conv — CURRENT-TASKS.md tidy only makes sense within a conv. Run /r-start first.
```

### Step 2: Verify file exists

If `CURRENT-TASKS.md` doesn't exist:

```
⚠️  CURRENT-TASKS.md doesn't exist. To bootstrap, create it with the four H2 anchors
    (## 🎯 Now, ## ⏸️ Parked, ## Tasks, ## ✅ Done this conv), or run /r-start in a fresh conv.
```

### Step 3: Read the file

`Read` `CURRENT-TASKS.md` in full. **It is the source of truth** — this skill never regenerates task content from anywhere else, and never invents ordering. The `## 🎯 Now` order is the user's curated priority; preserve it exactly unless the user asked to reorder.

### Step 4: Validate consistency

Using the pre-computed probe (or by hand if the script is absent), check:

1. **Every `## 🎯 Now` and `## ⏸️ Parked` TOC line has a matching `### [CODE]` body** under `## Tasks`. A TOC line with no body is a **dangling link** — surface it.
2. **Every `### [CODE]` body appears in exactly one TOC** (Now *or* Parked, not both, not neither). A body in no TOC is an **orphan** — surface it (it's invisible to the resume display).
3. **A body's `State:` bullet agrees with which TOC it's in** — a `⏸️ parked` State should be in `## ⏸️ Parked`; a `🔄 active`/`📋 queued`/`👀 watch` State should be in `## 🎯 Now`.
4. **Anchor slugs resolve** — each TOC link's `#slug` matches its body heading's computed slug.

**Do not auto-fix silently.** For each inconsistency, surface it (`🔴`/`🟠` per CLAUDE.md §Issue Surfacing) with the specific fix, and either apply the obvious one-line correction (add a missing TOC line, fix a slug) with a note, or ask if the fix is ambiguous (a dangling link could mean "add the body" or "remove the stale TOC line" — the user decides).

### Step 5: Move finished tasks to Done

Any body whose `State:` bullet reads done/✅ (a completion that wasn't fully processed via write-through) → **move it out of `## Tasks`**: delete the body, remove its `## 🎯 Now` line, and add a one-liner to `## ✅ Done this conv` (`- [CODE] — one-line what-shipped`). Cap `## ✅ Done this conv` at the last ~10.

Use targeted `Edit`s with unique anchors (per `[EDITSAFE]` — never a serializer round-trip or an ambiguous marker on this file). If several edits are needed, prefer a single full-file `Write` of the validated content over many fragile `Edit`s.

### Step 6: Report

```
✅ CURRENT-TASKS.md checked — {A} active, {Q} queued, {W} watch, {P} parked; {D} moved to Done this conv
```

If any inconsistencies were found:

```
🔴 {N} consistency issue(s): {dangling links / orphans / slug mismatches — with the fix applied or asked}
```

If clean, say so — `no drift` is a meaningful result for a write-through file.

---

## Rules

- **The file is the source of truth.** Never regenerate task content from elsewhere; never reorder `## 🎯 Now` by your own judgment unless the user asks.
- **Bodies never move on state change** — only the TOC line + the `State:` bullet change. The one exception is completion (Step 5), which removes the body entirely.
- **`[CODE]` is the only key.** No numeric IDs.
- **Edit safely** ([EDITSAFE]) — unique anchors, no serializer round-trips, no ambiguous markers on `CURRENT-TASKS.md`.
- **Never delete a task body** except a genuinely-completed one (Step 5). A parked/queued body with no recent activity is normal, not stale.
