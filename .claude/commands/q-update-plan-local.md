---
description: Project-specific PLAN.md conventions (extends /q-update-plan)
argument-hint: ""
---

# Peerloop PLAN.md Conventions

**Extends:** `/q-update-plan` (run that first for standard actions)

This skill adds Peerloop-specific conventions to the standard PLAN.md update process.

---

## Terminology Mapping

| Generic (`/q-update-plan`) | Peerloop |
|-----------------------|----------|
| Stage | **Block** (CODE format, e.g., ESCROW, RATINGS) |
| Step | **Section** (BLOCK.SECTION format, e.g., ESCROW.SCHEMA) |

### Block Naming Convention

All blocks use descriptive ALL-CAPS codes:
- Active: `TESTING`, `CURRENTUSER`, `CREATOR-SETUP`
- Deferred: `BBB`, `S-T-CALENDAR`, `RATINGS`, `FEEDS`, `MODERATION`, `ROLES`, `SEEDDATA`, `ESCROW`, `POLISH`, `OAUTH`, `MVP-GOLIVE`, `SENTRY`, `IMAGE-OPTIMIZE`, `KV-CONSISTENCY`, `PAGES-DEFERRED`

Completed blocks (in COMPLETED_PLAN.md) use either numeric IDs (historical: Block 0-3.5) or ALL-CAPS codes (VIDEO, ADMIN, etc.).

### Section Naming Convention

Sections within blocks use `BLOCK.SECTION` format:
- `ESCROW.SCHEMA`, `ESCROW.TRANSFER_LOGIC`, `ESCROW.ADMIN_RELEASE`
- `CURRENTUSER.REVIEW`, `CURRENTUSER.APP`, `CURRENTUSER.ADMIN`

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

**Only show remaining work.** When a sub-block (section) completes:
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
   - Add row to Completion Sequence table
   - Add block summary in Completed Blocks section
   - Format: block name, 1-line summary, session range

   ```markdown
   ### BLOCKNAME: Block Name ✓
   Brief 1-line summary of deliverables. Sessions: NNN-NNN (YYYY-MM-DD)
   ```

2. **Remove entire block from PLAN.md** — no stub, no link, no "see COMPLETED_PLAN.md"

3. **Fold deferred items** from the completing block into other relevant blocks in PLAN.md before removing

4. **Update Block Sequence table** — remove the block from ACTIVE

### Blocks Are Forward-Looking Only

PLAN.md contains only work that remains to be done. Completed work lives exclusively in COMPLETED_PLAN.md. There is no "Completed Blocks" section in PLAN.md.

---

## Block Sequence Management

### ACTIVE → Completed

When the last section of an active block completes:
1. Follow "When a Block Fully Completes" above
2. If a deferred block is ready to start, move it to ACTIVE

### DEFERRED → ACTIVE

When starting work on a deferred block:
1. Move it from DEFERRED table to ACTIVE table
2. Change its header from `## Deferred:` to `## In Progress:`

### Any → ON-HOLD

When a block is blocked by an external dependency:
1. Move it to ON-HOLD table with reason
2. Block detail stays in PLAN.md unchanged

---

## Confirmation Message

After updates, confirm with:

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
