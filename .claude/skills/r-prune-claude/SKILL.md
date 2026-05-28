---
name: r-prune-claude
description: Optimize CLAUDE.md by moving content to offload file
argument-hint: ""
allowed-tools: Read, Edit, Bash, Glob, Grep
---

# Prune CLAUDE.md

Keep CLAUDE.md lean by moving less-critical reference material to an offload file. Since CLAUDE.md is always loaded into context, keeping it focused improves performance.

---

## Pre-computed Context

!`cat ~/projects/peerloop-docs/.claude/config.json 2>/dev/null || echo "(no config)"`

**CLAUDE.md line count:**
!`wc -l < ~/projects/peerloop-docs/CLAUDE.md 2>/dev/null || echo "(unknown)"`

**CLAUDE.md section headers:**
!`grep '^## ' ~/projects/peerloop-docs/CLAUDE.md 2>/dev/null || echo "(none)"`

**Offload file exists:**
!`test -f ~/projects/peerloop-docs/docs/reference/CLAUDE-OFFLOAD.md && echo "yes ($(wc -l < ~/projects/peerloop-docs/docs/reference/CLAUDE-OFFLOAD.md) lines)" || echo "no"`

---

## Thresholds & Paths

Use values from config.json `thresholds.claudeMd`. If config missing, defaults: low=150, high=250, floor=100. Offload path: config.json `paths.claudeOffload` (default: `docs/reference/CLAUDE-OFFLOAD.md`).

---

## Step 0: Quick Check

Use the pre-computed line count:

- **Below low threshold** → Report "CLAUDE.md is lean ([X] lines, threshold [Y]). No pruning needed." and stop.
- **Below floor** → Report "CLAUDE.md is at or below floor ([X] lines). Cannot prune further." and stop.
- **Otherwise** → Proceed to Step 1.

---

## Step 1: Dry Run (ALWAYS DO THIS FIRST)

### 1a. Classify Each Section

Use the pre-computed section headers (actual `## ` headings from CLAUDE.md). For each, determine keep or move:

**Keep criteria — section is needed in most sessions:**
- Core project context (overview, stack, roles)
- Commands and workflows used constantly
- Navigation references (research, specs, block sequence)
- Active development infrastructure (hooks, RFC system)

**Move criteria — section is reference material consulted occasionally:**
- Detailed examples beyond quick reference
- Full specifications (schemas, variable lists, color palettes)
- Historical context or completed block details
- Detailed procedures (deployment, migration steps)
- Extended code samples

When in doubt, keep. Moving too aggressively fragments useful context.

### 1b. Check Floor Constraint

Compute: current lines − total moveable lines = projected lines. If projected < floor threshold, reduce the move list until projected ≥ floor.

### 1c. Present Dry Run Results

```
CLAUDE.md Optimization Proposal
──────────────────────────────────

Current: [X] lines | Threshold: low=[L] high=[H] floor=[F]
Status: [lean / review / candidate]

Sections to Move:
   1. "## [Exact Header]" (~X lines, lines Y-Z)
      Reason: [Why it matches move criteria]
   ...

Sections to Keep:
   - "## [Exact Header]" — [why essential]
   ...

Projected: ~[X] lines (down from [Y], [Z]% reduction)
Floor check: [OK / would violate — reduced move list]

──────────────────────────────────
```

---

## Step 2: Assess Impact (REQUIRED before proceeding)

1. **Is the reduction significant?** If <25%, convenience loss likely outweighs token savings.
2. **What's lost by moving each section?** Will Claude need to read the offload file for basic project behavior?
3. **Is CLAUDE.md already well-optimized?** Already has offload pointers? Sections already concise?

### Recommendation:

```
RECOMMENDATION: Proceed with pruning
- Reduction is significant ([X]%)
- Moved content is truly reference material

Proceed? (Y/n)
```

OR

```
RECOMMENDATION: Do not prune
- [Reason]
```

**Do NOT proceed to Step 3 unless recommendation is positive AND user confirms.**

---

## Step 3: Execute Changes

After user confirms:

1. **Update offload file** (path from config):
   - **Preserve existing content** — do not overwrite
   - If exists: append or merge into existing categories
   - If creating: add header `# CLAUDE-OFFLOAD.md - Extended Documentation`

2. **Update CLAUDE.md:**
   - Add/verify pointer to offload file near top
   - Replace moved sections with one-line summary + "See [offload path]"
   - Keep section headers for scannability — just reduce the body

3. **Verify:** pointers use correct path, moved content present in offload

---

## Step 4: Scoped Reference Validation (Post-Execute)

Prune is the most likely cause of dangling MEMORY.md → CLAUDE.md `§X` references — when a section is moved to the offload, its `## X` header in CLAUDE.md *should* survive (the skill keeps headers for scannability), but if the prune ever evolves to rename or delete headers, memory pointers will rot silently.

Run **scoped** reference validation immediately after Step 3 — limited to the sections this prune touched:

1. **For each section moved or modified in this prune,** check whether any MEMORY.md line or any memory `feedback_*.md` body contains a reference to `CLAUDE.md §<that-header>` (or standalone `§<that-header>`).
2. **Resolve each reference** against the post-prune CLAUDE.md headers (re-grep `^## ` after the Step 3 write).
3. **For each dangling reference,** emit a 🔴 alert:
   ```
   🔴 Reference rot: {memory file or MEMORY.md line N} references §{X} which no longer exists in CLAUDE.md.
       → Update the memory line/file, or restore §{X} as a stub-pointer header in CLAUDE.md.
   ```

This is the **edit-coupled** half of the coherence story — same reference-validation logic as `/r-coherence-check`'s Check 1c, but scoped to the prune's own deltas (cheaper, runs every prune).

After scoped validation, **always emit this pointer** in the final report (regardless of finding count):

```
ℹ️  For the broader cross-file sweep (overlap detection, stub-pointer integrity,
   orphaned rules), run /r-coherence-check.
```

---

## Step 5: Report

```
CLAUDE.md Pruned

Moved to [offload file]:
- [List of moved sections with line counts]

Before: ~[X] lines → After: ~[Y] lines ([Z]% reduction)
Cross-references verified (this prune's deltas only).
[🔴 alerts if any from Step 4]

ℹ️  For broader coherence (overlap, stub-pointer integrity, orphan rules),
   run /r-coherence-check.
```

---

## Rules

- **ALWAYS complete dry run and assess impact before changes**
- **If reduction <25%, recommend against pruning**
- **Check floor constraint during dry run, not just execution**
- Wait for explicit user confirmation before executing
- **Never reduce CLAUDE.md below floor threshold**
- **Always preserve existing offload file content**
- **Step 4 scoped reference validation runs after every prune execution** — broader sweep is `/r-coherence-check`'s job
- **Section headers are preserved by default** — if a future prune variant renames or deletes headers, Step 4 will catch dangling memory pointers
