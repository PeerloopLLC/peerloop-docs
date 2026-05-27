---
name: r-quiet-mode
description: Toggle quiet mode — direct hands-on work with deferred-work logged to .scratch, processed on exit
argument-hint: "on | off"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TaskCreate, TaskUpdate, TaskList, TaskGet
---

# Quiet Mode

**Purpose:** A focused, direct working mode for short periods. You direct, Claude does, control returns to you — without Claude's normal proactive "wisdom" (option-framing, durable-vs-quick write-ups, tangential surfacing, auto-running deferred processes). That suppressed wisdom is **not discarded** — it is written to a single log file in `.scratch/` and replayed when quiet mode is turned off.

**The log file IS the state.** Quiet mode is ON if and only if `~/projects/peerloop-docs/.scratch/quiet-mode-log.md` exists. There is only ever **0 or 1** log (turning off deletes it; `/r-end` is blocked while it exists; so a normal flow never leaves a leftover). A leftover can only appear after an unclean exit during quiet mode — `/r-start` detects and surfaces it.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current conv:**
!`cat ~/projects/peerloop-docs/.conv-current 2>/dev/null || echo "(none)"`

**Timestamp:**
!`date '+%Y-%m-%d %H:%M:%S'`

**Quiet-mode state:**
!`test -f ~/projects/peerloop-docs/.scratch/quiet-mode-log.md && echo "ON — quiet-mode-log.md present" || echo "off — no log"`

**Argument given:**
!`echo "$ARGUMENTS"`

---

## Paths

- Log file (fixed, single): `~/projects/peerloop-docs/.scratch/quiet-mode-log.md`

---

## Execution Flow

Branch on the **Argument given** (`$ARGUMENTS`), trimmed and lowercased:

- `on` → run **Turn ON**
- `off` → run **Turn OFF**
- anything else (empty, unknown) → print usage and HALT:
  ```
  Usage: /r-quiet-mode on   — enter quiet mode
         /r-quiet-mode off  — exit, process the log, resume normal mode
  Current state: {Quiet-mode state from pre-computed}
  ```

---

### Turn ON

1. **Already on?** If the pre-computed state is `ON`, do not clobber the log. Print:
   ```
   🔇 Quiet mode is already ON (log: .scratch/quiet-mode-log.md). Continuing.
   ```
   and stop here (stay in quiet mode).

2. **Create the log** at `~/projects/peerloop-docs/.scratch/quiet-mode-log.md` with this exact skeleton (fill the header from pre-computed):

   ```markdown
   # Quiet Mode Log — Conv {CONV}

   **Started:** {TIMESTAMP}
   **Machine:** {MACHINE}

   > Quiet mode is ON. Claude works directly: does what is asked, terse output, hands
   > control back. Suppressed "normal wisdom" is logged below, not lost. Blocking /
   > directly-important issues are still surfaced inline (and mirrored here). This file
   > is processed and DELETED by `/r-quiet-mode off`.

   ---

   ## Deferred processes
   <!-- things normally run now but held: gates (tsc/check/lint/test/build), prov:sweep,
        route-doc regen, doc-drift checks, memory-save candidates, TodoWrite churn -->

   ## Tangential observations
   <!-- noticed-but-not-asked: code-quality nits off the path, stale docs, naming,
        adjacent bugs, refactor opportunities -->

   ## Deferred tasks / followups / cleanup
   <!-- would-be TaskCreate items, cleanup steps, scaffolding to remove later -->

   ## Issues surfaced inline (mirror)
   <!-- blocking/important issues raised to the user in the moment, copied here so the
        off-processing has the full picture -->
   ```

3. **Confirm tersely and engage:**
   ```
   🔇 Quiet mode ON — Conv {CONV}. Deferred work → .scratch/quiet-mode-log.md.
   Direct me.
   ```

4. **Operate in QUIET MODE from now until `/r-quiet-mode off`.** This is a standing instruction for the rest of the conversation:

   **Do:**
   - Do exactly what the user directs. Keep output terse — what was done, in a line or two.
   - Return control promptly. No "next steps", no A/B/C option menus, no durable-vs-quick analyses unless the user asks.
   - **Append to the log** (via Edit, into the right section) every item you would normally surface or run: deferred gates/sweeps/regens, tangential observations, would-be tasks, cleanup/followups, memory-save candidates. Append; never rewrite existing log content.

   **Still surface inline (but terse), and mirror into the log's "Issues surfaced inline" section:**
   - Anything that **blocks** the directed task or makes the directed action wrong/unsafe.
   - Anything the user must decide before you can proceed correctly.
   - Security, data-loss, destructive, or irreversible-action concerns (these ALWAYS surface — quiet mode never suppresses a safety stop).

   **Do not** run the suppressed processes during quiet mode — only log them. They run during Turn OFF.

---

### Turn OFF

1. **Not on?** If the pre-computed state is `off`, print and HALT:
   ```
   Quiet mode is not on — nothing to process.
   ```

2. **Read** `~/projects/peerloop-docs/.scratch/quiet-mode-log.md` fully. Normal "wisdom" is now re-engaged.

3. **Run the deferred processes first** (independent work, done before the pause per `memory/feedback_pause_on_pointing_questions.md`): gates (tsc / astro check / lint / test / build as relevant), `prov:sweep`, route-doc regen, doc-drift checks — whatever the log's "Deferred processes" lists. Report results compactly; surface any `🔴`/`🟠` findings.

4. **RAISE THE ISSUES — mandatory checkpoint, then HALT.** This is the step quiet mode exists for: every issue held back during the quiet period must now be put to the user for consideration, not silently filed. Compile the issue set = the log's "Issues surfaced inline" section + any blocking / directly-important / open-question items anywhere in the log. For **each** issue, present:

   - **The issue** — one line, concrete.
   - **My read** — EITHER it needs a user decision (state the options + a recommendation), OR an explanation of **why it is not actually an issue** (so the user can still veto). Never just list it; always take a position.

   Format as a numbered list, then end with a single `👉👉👉` pause and **WAIT for the user**. Do NOT `TaskCreate` the issues, action dispositions, or delete the log yet — the user may dismiss some, redirect others, or ask to discuss. If there are genuinely zero issues in the log, say so explicitly ("No open issues in the log") and skip straight to step 5 (no pause needed).

   ```
   🔔 Quiet mode OFF — processing log from Conv {CONV} (started {TIMESTAMP}).
   Gates: {one-line result}. Deferred tasks/cleanup/tangentials: {count} (filed after issues are settled).

   Issues for your consideration:
   1. {issue} — {decision needed + recommendation, OR why it's not actually an issue}
   2. ...

   👉👉👉 **How do you want to handle these — which to act on, which to drop?**
   ```

5. **After the user responds — execute and finalize:**
   - Action each issue per the user's disposition: `TaskCreate` the ones to track (unique bracketed mnemonic code each per `feedback_todowrite_mnemonic_codes.md`), apply fixes they ask for now, drop the ones they dismiss.
   - `TaskCreate` the remaining deferred tasks / followups / cleanup items.
   - Save any genuine memory-save candidates (check the memory dir first per `feedback_check_memory_before_directive_save.md`).
   - Address tangential observations you judge worth doing now; leave the rest as raised.

6. **Delete the log:**
   ```bash
   rm ~/projects/peerloop-docs/.scratch/quiet-mode-log.md
   ```
   Confirm:
   ```
   🗑️  quiet-mode-log.md processed and deleted. Normal mode resumed.
   ```

---

## Rules

- **The log is the single source of truth for quiet-mode state.** Never track state elsewhere.
- **Never suppress a safety stop.** Destructive/irreversible/security/data-loss concerns surface inline even in quiet mode.
- **Append, don't rewrite** the log during quiet mode — it is an accumulating record.
- **`/r-end` is blocked while the log exists** (guard lives in the `r-end` skill). Turn quiet mode off first.
- **`/r-start` surfaces a leftover log** (detection lives in the `r-start` skill) — the only way one persists is an unclean exit during quiet mode.
- Only ever 0 or 1 log → fixed filename, no conv suffix; the conv number lives in the log header.
