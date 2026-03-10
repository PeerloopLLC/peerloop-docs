---
name: q-update-plan
description: Update PLAN.md with current progress
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Update PLAN.md

**Purpose:** Keep PLAN.md synchronized with current progress. Run this frequently during development to ensure documentation stays current.

---

## Project Config

!`cat .claude/config.json 2>/dev/null || echo "(no config.json found — using defaults)"`

**Used from config:**
- `terminology.stage` → **Block** (CODE format, e.g., ESCROW, RATINGS)
- `terminology.subStage` → **Section** (BLOCK.SECTION format, e.g., ESCROW.SCHEMA)

---

## Peerloop Terminology

| Generic Term | Peerloop Term |
|-------------|---------------|
| Stage | **Block** (ALL-CAPS code: `TESTING`, `ESCROW`, `RATINGS`) |
| Step | **Section** (`BLOCK.SECTION` format: `ESCROW.SCHEMA`) |

---

## PLAN.md Structure

```markdown
# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE
| Block | Name | Status |
|-------|------|--------|

### ON-HOLD
(None currently)

### DEFERRED
| Priority | Block | Name |
|----------|-------|------|

---

## In Progress: BLOCKNAME
(Remaining work only)

---

## Deferred: BLOCKNAME
(Full detail for future blocks)

---

## Post-MVP Phases
(Brief footer)
```

**Notes:**
- **Quick Status** is optional but recommended for quick scanning
- Status can use **tables** OR **checkbox lists** — both are valid
- **Next Steps** can appear after In Progress (for visibility) or at bottom

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

6. **Confirm completion** with brief message (see below)

---

## What Lives Where

| Content | Location | Notes |
|---------|----------|-------|
| **Remaining work** | `PLAN.md` | Active and deferred blocks |
| **Completed block archive** | `COMPLETED_PLAN.md` | Terse: name + 1-line summary + session range |
| **Session details** | `docs/sessions/` | Full session logs |
| **Tech Stack** | `CLAUDE.md` | Single source of truth |
| **User Roles** | `CLAUDE.md` | Single source of truth |
| **Reference Documents** | `CLAUDE.md` | Research Reference section |
| **Page status & routes** | `docs/architecture/url-routing.md` | Source of truth for routes |
| **Decisions** | `docs/DECISIONS.md` | Project decisions |

**Do NOT put in PLAN.md:**
- Completed work details (use COMPLETED_PLAN.md)
- Session notes or timestamps (use docs/sessions/)
- Tech stack or roles (use CLAUDE.md)
- Decision records (use docs/DECISIONS.md)
- Page counts or verification tables

---

## Block Completion Rules

### While a Block is Active

**Only show remaining work.** When a section completes:
- Strip it from PLAN.md
- Add it to the block's "Completed:" one-liner summary at the top
- Keep the detail for remaining sections only

**Example — CURRENTUSER with some sections done:**
```markdown
## In Progress: CURRENTUSER

**Focus:** Global user state management with course-aware role checking
**Status:** 🔄 IN PROGRESS

**Completed:** TypeScript types, /api/me/full endpoint, AppNavbar integration, localStorage caching, two-global architecture.

### CURRENTUSER.REVIEW ← NEXT
(remaining work details...)

### CURRENTUSER.APP
(remaining work details...)
```

### When a Block Fully Completes

1. **Add terse entry to COMPLETED_PLAN.md:**
   ```markdown
   ### BLOCKNAME: Block Name ✓
   Brief 1-line summary of deliverables. Sessions: NNN-NNN (YYYY-MM-DD)
   ```

2. **Remove entire block from PLAN.md** — no stub, no link

3. **Fold deferred items** from the completing block into other relevant blocks

4. **Update Block Sequence table** — remove from ACTIVE

### Block Sequence Transitions

| Transition | Action |
|-----------|--------|
| ACTIVE → Completed | Follow completion rules above; optionally promote a DEFERRED block |
| DEFERRED → ACTIVE | Move to ACTIVE table, change `## Deferred:` to `## In Progress:` |
| Any → ON-HOLD | Move to ON-HOLD table with reason; detail stays in PLAN.md |

### Blocks Are Forward-Looking Only

PLAN.md contains only work that remains to be done. Completed work lives exclusively in COMPLETED_PLAN.md. There is no "Completed Blocks" section in PLAN.md.

---

## Example Update

Before:
```
| 7.2 E2E Tests | PENDING |

#### 7.2 E2E Tests - PENDING
- [ ] Set up Playwright
- [ ] Write checkout flow tests
```

After:
```
| 7.2 E2E Tests | COMPLETE |

#### 7.2 E2E Tests - COMPLETE
- [x] Set up Playwright
- [x] Write checkout flow tests
```

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

---

## Quick Reference

**Files to update:**
- `PLAN.md` — Remaining work (active + deferred blocks)
- `COMPLETED_PLAN.md` — Terse archive of completed blocks

**On every update:**
- [ ] Block Sequence table reflects current state
- [ ] Active blocks show only remaining work
- [ ] "Last Updated" footer timestamp updated
