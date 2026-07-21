---
name: Prefix task subjects with mnemonic short codes
description: Every CURRENT-TASKS.md task is keyed by a unique 2-3 letter bracketed mnemonic [CODE] (the ### heading + its 🎯 Now / ⏸️ Parked TOC line), so the user can reference tasks by code in chat
type: feedback
originSessionId: 6be62ff7-482a-4b7c-beb0-5ce7cc347918
modified: 2026-07-21T21:41:20.406Z
---
Every task in `CURRENT-TASKS.md` is keyed by a unique 2-3 letter code in brackets — it's the `### [CODE]` body heading **and** the `## 🎯 Now` / `## ⏸️ Parked` TOC line that links to it. Examples: `[SD] Shadow docs review`, `[PL] Plan update`, `[DW] Drift window extension`.

**Mechanism note (Conv 406):** codes live in the write-through file `CURRENT-TASKS.md`, not in a `TaskCreate` subject — the Task subsystem is server-gated off for this model (see [[feedback_current_tasks_persistence]], [[project_task_tools_child_session_leak]]). Everything below is unchanged; only the home moved from a tool to a file.

**Why:** The user references tasks by code in chat ("do PL", "what's SD?", "close GE2") instead of typing full descriptions. The mnemonic also helps the user visually scan the `🎯 Now` TOC and pattern-match to recent context. Originally a global CC convention preserved in `~/.claude/CLAUDE-SAVED.md`; migrated to project memory on Conv 135.

**How to apply:**
- **Format:** `[XX]` or `[XXX]` — 2 or 3 uppercase letters (digits allowed, e.g. `[A11Y]`), square brackets. It heads the `### [CODE]` body and prefixes its TOC line.
- **Derivation:** Mnemonic, based on task content (not random). A task about "tightening matchers" could be `[DT]` (Drift Tighten) or `[TM]` (Tighten Matchers) — whichever reads most obviously.
- **Uniqueness:** Must be unique across the whole board. Scan `CURRENT-TASKS.md` (or run `.claude/scripts/current-tasks-check.sh`) before choosing a code.
- **Collision rule:** If the mnemonic already exists, append a sequential number: `[GE]` taken → `[GE2]` → `[GE3]`.
- **When to assign:** when you add a new task (a new `### [CODE]` body + a `🎯 Now`/`⏸️ Parked` line). The anchor slug is the code lowercased with brackets stripped (`[A11Y]`→`#a11y`), so the TOC link is `[A11Y](#a11y)`.
- **Referencing:** When the user says "do PL" or "close SD", match against the `[CODE]` and operate on that task's body.
- **Related convention (different scope):** `PLAN.md` and commit summaries use longer hyphenated codes like `[RA-SSR]`, `[BKC-NEXT]` for durable multi-conv block tracking. Those are valid in PLAN.md prose; task codes here stay short (2-3 letters, occasionally longer where already established like `[MERGE-BRIAN-JULY7]`).
