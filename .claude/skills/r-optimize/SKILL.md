---
name: r-optimize
description: Deep review of CLAUDE.md and MEMORY.md for confusion, ambiguity, contradictions, and friction — produces a prioritized fix list and applies approved changes
argument-hint: ""
model: claude-opus-4-7
effort: max
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

# Optimize Claude Guidance Files

Deep-review `CLAUDE.md` and the full memory system for issues that degrade collaboration: rules that cause unnecessary check-ins, contradictions between files, ambiguous instructions, stale content, and gaps that force guessing.

---

## Pre-computed Context

**CLAUDE.md:**
!`cat CLAUDE.md`

**MEMORY.md index:**
!`cat ~/.claude/projects/-Users-livingroom-projects-peerloop-docs/memory/MEMORY.md 2>/dev/null || echo "(not found)"`

**All memory files:**
!`for f in ~/.claude/projects/-Users-livingroom-projects-peerloop-docs/memory/*.md; do echo "=== $(basename $f) ==="; cat "$f"; echo; done`

**CLAUDE.md stats:**
!`wc -l < CLAUDE.md` lines, !`grep -c '^## ' CLAUDE.md` top-level sections

---

## Analysis Framework

Read every line of CLAUDE.md and every memory file. For each finding, classify it into one of the categories below and assign a severity.

### Categories

**[CONTRADICTION]** — Two rules that directly conflict. Following one violates the other.
- Example: CLAUDE.md says "ask before deciding" but also "default to durable and proceed"
- Example: A memory says "always X" while CLAUDE.md says "never X"

**[AMBIGUITY]** — A rule whose scope or trigger condition is unclear, requiring judgment that often lands wrong.
- Example: "When in doubt, ask" — but "doubt" is undefined
- Example: A threshold that isn't quantified ("significant change", "novel decision")

**[FRICTION]** — An instruction that generates unnecessary check-ins, confirmation loops, or halts for decisions the user clearly wants automated.
- Example: requiring confirmation for every commit when the user has never rejected one
- Example: a step that asks "proceed?" for an obviously-required action

**[STALE]** — Content that refers to old states, completed work, or superseded patterns.
- Example: references to sessions instead of convs
- Example: a memory about a decision that has since been reversed
- Example: a PLAN block marked done but still referenced as active

**[REDUNDANCY]** — The same information stated in two or more places. Pick the authoritative location; remove the rest.
- Example: a rule in both CLAUDE.md and a memory file saying the same thing
- Example: a memory that duplicates a CLAUDE.md section exactly

**[GAP]** — A missing rule that consistently causes wrong default behavior, forcing the user to re-explain the same thing.
- Example: no guidance on how to handle X, so Claude always asks
- Example: a pattern established in memory but never surfaced as a rule in CLAUDE.md

**[SCOPE-CREEP]** — A rule whose wording is too broad, causing it to trigger in situations it wasn't meant for.
- Example: "always ask before deciding" applied to trivial naming choices
- Example: a memory feedback rule that's so general it suppresses useful behavior

---

## Step 1: Deep Analysis

For each file, read every rule, instruction, and memory entry. Identify all issues across both files and across file boundaries (CLAUDE.md vs memory).

For each issue found, write an entry in this format:

```
[CATEGORY] Severity: HIGH / MEDIUM / LOW
Location: CLAUDE.md §Section / memory/filename.md
Issue: One sentence description of the problem
Quote: "Exact text that is problematic"
Impact: How this causes confusion, extra interactions, or wrong behavior
Fix: Specific proposed change (rewrite, delete, move, clarify)
```

Group findings by severity: HIGH first, then MEDIUM, then LOW.

---

## Step 2: Present Findings

After analysis, present a structured report:

```
╔══════════════════════════════════════════════════╗
║  /r-optimize — Guidance File Audit               ║
╚══════════════════════════════════════════════════╝

Files reviewed:
  CLAUDE.md          [X] lines, [Y] sections
  Memory files       [N] files, [M] entries

Findings: [total] issues
  HIGH    [n]  — address before next session
  MEDIUM  [n]  — address soon
  LOW     [n]  — housekeeping

────────────────────────────────────────────────────
HIGH PRIORITY
────────────────────────────────────────────────────

[formatted findings]

────────────────────────────────────────────────────
MEDIUM PRIORITY
────────────────────────────────────────────────────

[formatted findings]

────────────────────────────────────────────────────
LOW PRIORITY
────────────────────────────────────────────────────

[formatted findings]

════════════════════════════════════════════════════
RECOMMENDED ACTIONS
════════════════════════════════════════════════════

[Numbered list of the highest-leverage fixes, ordered by impact]
```

---

## Step 3: Fix Protocol

After presenting findings, ask:

```
👉👉👉 Which fixes would you like applied?
  - "all high" — apply all HIGH severity fixes
  - "all" — apply all findings
  - "1, 3, 5" — apply specific numbered items
  - "none" — report only, no changes
```

**Wait for user response. Do not apply any changes without explicit approval.**

For each approved fix:
1. Read the current file content
2. Apply the minimal change that addresses the issue
3. Verify the surrounding context wasn't disrupted
4. Report: `✅ Fixed [#N]: [brief description]`

After all fixes applied, run a final consistency check across the modified files to confirm no new contradictions were introduced.

---

## Rules

- **Read every line** — do not skim. Partial reads produce incomplete findings.
- **Quote exactly** — always include the verbatim problematic text, not a paraphrase
- **Cross-file analysis is required** — CLAUDE.md and memory files must be analyzed together, not in isolation
- **Do NOT apply changes without user approval** — the Step 2 report is always presented first
- **HIGH severity = causes real collaboration failures** — reserve for genuine blockers, not style preferences
- **For contradictions: propose which source wins** — don't just flag the conflict; recommend a resolution
