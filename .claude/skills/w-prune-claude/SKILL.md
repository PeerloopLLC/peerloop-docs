---
name: w-prune-claude
description: Optimize CLAUDE.md by moving content to offload file
argument-hint: ""
allowed-tools: Read, Edit, Bash, Glob, Grep
---

# Prune CLAUDE.md

Keep CLAUDE.md lean by moving less-critical reference material to an offload file. Since CLAUDE.md is always loaded into context, keeping it focused improves performance.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**CLAUDE.md line count:**
!`wc -l < CLAUDE.md 2>/dev/null || echo "(unknown)"`

**CLAUDE.md section headers:**
!`grep '^## ' CLAUDE.md 2>/dev/null || echo "(none)"`

**Offload file exists:**
!`test -f docs/reference/CLAUDE-OFFLOAD.md && echo "yes ($(wc -l < docs/reference/CLAUDE-OFFLOAD.md) lines)" || echo "no"`

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

4. **Report:**

```
CLAUDE.md Pruned

Moved to [offload file]:
- [List of moved sections with line counts]

Before: ~[X] lines → After: ~[Y] lines ([Z]% reduction)
Cross-references verified.
```

---

## Rules

- **ALWAYS complete dry run and assess impact before changes**
- **If reduction <25%, recommend against pruning**
- **Check floor constraint during dry run, not just execution**
- Wait for explicit user confirmation before executing
- **Never reduce CLAUDE.md below floor threshold**
- **Always preserve existing offload file content**
