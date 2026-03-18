---
name: r-update-plan
description: Update PLAN.md with current progress
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Update PLAN.md

**Purpose:** Keep PLAN.md synchronized with current progress. Run this frequently to ensure documentation stays current.

---

## Pre-computed Context

**Current PLAN.md status:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/plan-status-header.sh`

**Open questions:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/plan-open-questions.sh`

---

## Peerloop Terminology

| Generic Term | Peerloop Term |
|-------------|---------------|
| Stage | **Block** (ALL-CAPS code: `TESTING`, `ESCROW`, `RATINGS`) |
| Step | **Section** (`BLOCK.SECTION` format: `ESCROW.SCHEMA`) |

---

## Actions

1. **Update "In Progress" section:**
   - Update status table (COMPLETE/PENDING for each step)
   - Check off completed subtasks with [x]
   - Add new subtasks discovered during work
   - Document any blockers or issues

2. **If a section completes:**
   - Strip it from PLAN.md
   - Add it to the block's "Completed:" one-liner summary at the top
   - Keep detail for remaining sections only

3. **If a block fully completes:**
   - Add terse entry to `COMPLETED_PLAN.md` (name + 1-line summary + session range)
   - Remove entire block from PLAN.md — no stub, no link, no "see COMPLETED_PLAN.md"
   - Fold deferred items from the completing block into other relevant blocks
   - Update Block Sequence table — remove from ACTIVE
   - If a deferred block is ready, move it to ACTIVE

4. **Update "Next Steps" section** at bottom with current priorities

5. **Update "Last Updated" footer timestamp**

6. **Confirm completion** with brief message

---

## What Lives Where

| Content | Location | Notes |
|---------|----------|-------|
| **Remaining work** | `PLAN.md` | Active and deferred blocks |
| **Completed block archive** | `COMPLETED_PLAN.md` | Terse: name + 1-line summary + session range |
| **Conv details** | `docs/sessions/` | Full conv logs |
| **Tech Stack** | `CLAUDE.md` | Single source of truth |
| **Decisions** | `docs/DECISIONS.md` | Project decisions |

**Do NOT put in PLAN.md:**
- Completed work details (use COMPLETED_PLAN.md)
- Conv notes or timestamps (use docs/sessions/)
- Decision records (use docs/DECISIONS.md)

---

## Block Completion Rules

### While a Block is Active

**Only show remaining work.** When a section completes:
- Strip it from PLAN.md
- Add it to the block's "Completed:" one-liner summary at the top
- Keep the detail for remaining sections only

### When a Block Fully Completes

1. **Add terse entry to COMPLETED_PLAN.md:**
   ```markdown
   ### BLOCKNAME: Block Name ✓
   Brief 1-line summary of deliverables. Convs: NNN-NNN (YYYY-MM-DD)
   ```

2. **Remove entire block from PLAN.md** — no stub, no link

3. **Fold deferred items** from the completing block into other relevant blocks

4. **Update Block Sequence table** — remove from ACTIVE

### Blocks Are Forward-Looking Only

PLAN.md contains only work that remains to be done. Completed work lives exclusively in COMPLETED_PLAN.md.

---

## Confirmation

```
PLAN.md Updated

Changes:
- [What was updated]

Current Status:
- Active: [Current active blocks]
- Completed: [Block that just completed, if any]

Next: [Immediate next action]
```
