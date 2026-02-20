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
| Stage | **Block** (CODE format, e.g., VIDEO, ADMIN) |
| Step | **Section** (BLOCK.SECTION format, e.g., VIDEO.BOOKING) |

### Block Naming Convention

**Completed blocks** use numeric IDs for historical continuity:
- `Block 0`, `Block 1`, `Block 1.8`, `Block 2`, `Block 3`, `Block 3.5`
- These link to COMPLETED_PLAN.md which also uses numeric IDs

**Active/Pending blocks** use descriptive ALL-CAPS codes:
- `VIDEO`, `COMMUNITY`, `CERTS`, `TEACHING`, `ADMIN`, `NOTIFY`
- Candidate blocks: `ZOD`, `ROLES`
- Ongoing: `BACKLOG`

### Section Naming Convention

Sections within blocks use `BLOCK.SECTION` format:
- `VIDEO.PROVIDER`, `VIDEO.BOOKING`, `VIDEO.ROOM`
- `ADMIN.SESSIONS`, `ADMIN.MODERATION`, `ADMIN.CONTEXTACTIONS`
- `TEACHING.DASHBOARD`, `TEACHING.AVAILABILITY`, `TEACHING.EARNINGS`

### Current Block Codes

| Code | Name | Status |
|------|------|--------|
| VIDEO | Video Sessions | ⏳ Pending |
| COMMUNITY | Community Feed | ⏳ Pending |
| CERTS | Certifications | ⏳ Pending |
| TEACHING | S-T Management | 🔄 Partial |
| ADMIN | Admin Tools | 🔄 Partial |
| NOTIFY | Notifications & PMF | ⏳ Pending |
| ZOD | Zod Validation | 📋 Candidate |
| ROLES | Role-Based Access | 📋 Candidate |
| BACKLOG | Page Backlog | 📋 Ongoing |

---

## Peerloop PLAN.md Structure

```markdown
# PLAN.md

## Quick Status
| Block | Status | Next Action |
|-------|--------|-------------|
| TEACHING | 🔄 Partial | Availability, Earnings |
| ADMIN | 🔄 Partial | Sessions (needs VIDEO) |

**Latest (YYYY-MM-DD Time):**
- What was implemented
- Page count: X Complete, Y Spec Only

---

## Execution Sequence
| Priority | Block | Name | Status | Dependencies |
|----------|-------|------|--------|--------------|
| ✅ | *Numeric* | Foundation through Homework | Complete | ... |
| 1 | VIDEO | Video Sessions | ⏳ Pending | - |
| 2 | TEACHING | S-T Management | 🔄 Partial | - |
...

---

## Project Summary
(Flywheel + Success Metrics only)
(Link to CLAUDE.md for tech stack, roles)

## Block Overview
| Block | Name | Est. Hours | Status |
(Completed use *Block N* italic, Active use CODE)

---

## Completed Blocks
*Completed blocks use numeric IDs for historical continuity.*

### Block 0: Foundation ✓
See [COMPLETED_PLAN.md](COMPLETED_PLAN.md#block-0-foundation-)
(2-line summary only)

---

## In Progress

### TEACHING: S-T Management
**Status:** 🔄 PARTIAL

#### TEACHING.DASHBOARD ✓
- [x] Completed items

#### TEACHING.AVAILABILITY
- [ ] Pending items

---

## Next Steps
1. **VIDEO** - Required for ADMIN.SESSIONS
2. **Complete ADMIN** - After VIDEO
...

---

## Pending

### VIDEO: Video Sessions
**Status:** ⏳ PENDING

#### VIDEO.PROVIDER
- [ ] Pending items

---

## Technical Debt
## Post-MVP Phases
## Infrastructure Summary
## Decisions to Investigate (historical)
```

---

## What Lives Where

| Content | Location | Notes |
|---------|----------|-------|
| **Progress tracking** | `PLAN.md` | Quick Status, In Progress, session notes |
| **Completed block details** | `COMPLETED_PLAN.md` | Full archive of finished work |
| **Tech Stack** | `CLAUDE.md` | Single source of truth |
| **User Roles** | `CLAUDE.md` | Single source of truth |
| **Reference Documents** | `CLAUDE.md` | Research Reference section |
| **Testing Commands** | `CLAUDE.md` | Development Commands section |
| **Page status & routes** | `PAGES-MAP.md` | Single source of truth for pages |

**Do NOT duplicate in PLAN.md:**
- Tech Stack table (use CLAUDE.md)
- User Roles section (use CLAUDE.md)
- Reference Documents section (use CLAUDE.md)
- Testing Approach section (use CLAUDE.md)

---

## Quick Status Section

The first thing visible in PLAN.md. Update on every session:

```markdown
## Quick Status
| Block | Status | Next Action |
|-------|--------|-------------|
| 7 & 8 | IN PROGRESS | Sessions Admin (ASES) |

**Latest (2026-01-08 Night-3):**
- For Creators page (FCRE) implemented
- Become a Teacher page (BTAT) implemented
- Page count: 29 Complete, 28 Spec Only
```

---

## Session Notes Format

Use this pattern for session entries:

| Time Suffix | Meaning |
|-------------|---------|
| AM | Morning session |
| PM | Afternoon session |
| Evening | Early evening |
| Night | Late evening |
| Night-2, Night-3 | Multiple late sessions same day |

**Example:** `**Latest (2026-01-08 Night-3):**`

### When Adding Session Notes

1. Move current "Latest" to "Previous"
2. Add new "Latest" with current date/time
3. Include:
   - What was implemented (page codes like TDSH, APAY)
   - Key files/components created
   - Migrations applied
   - Bug fixes
   - Page count update

---

## Block Completion Rules

### Blocks Are Atomic

**Key principle:** A block stays entirely in PLAN.md until ALL its sections are complete. Only then does the entire block move to COMPLETED_PLAN.md.

**Why:** Splitting a block between PLAN and COMPLETED_PLAN creates confusion about what's done and what's pending. Keep blocks whole.

### Completed Sections Stay in PLAN

When a section completes but other sections in the same block are pending:
- Mark the section with `✓` in the header: `#### ADMIN.USERS ✓`
- Change checkboxes from `- [ ]` to `- [x]`
- **Keep completed items as one-liners** (no multi-line details)
- Do NOT move to COMPLETED_PLAN.md yet

**Why one-liners:** Keeps PLAN.md scannable. Full details aren't needed once work is done - just enough to know what was completed.

**Example - ADMIN block with partial completion:**
```markdown
### ADMIN: Admin Tools
**Status:** 🔄 PARTIAL (7 of 12 sections complete)

#### ADMIN.DASHBOARD ✓
- [x] Platform overview metrics
- [x] Quick action cards

#### ADMIN.SESSIONS
*Depends on VIDEO block*
- [ ] Session listing with filters and search
  - Query params: status, date range, teacher
  - Pagination with 20 per page
- [ ] Access recordings via R2 signed URLs
```

**Note:** Pending items can have multi-line details; completed items stay brief.

### When to Archive to COMPLETED_PLAN

Only when ALL sections in a block are complete:
1. Every section has `✓`
2. All checkboxes are `[x]`
3. No pending work remains

Then follow the Block Promotion Workflow below.

---

## Block Promotion Workflow

When a Block **fully** completes:

1. **Archive to COMPLETED_PLAN.md:**
   - Add anchor tag: `<a id="block-code"></a>` (lowercase code, e.g., `block-video`)
   - Move full block details to COMPLETED_PLAN.md
   - Transform format:
     | From (PLAN.md) | To (COMPLETED_PLAN.md) |
     |----------------|------------------------|
     | `### CODE: Name` | `### CODE: Name ✓` |
     | `**Status:** ⏳ PENDING` | `**Status:** ✅ COMPLETE` |
     | `#### CODE.SECTION` | `#### CODE.SECTION ✓` |
     | `- [ ] Item` | `- [x] Item` |
     | `**Reference:** path` | `**Archived:** YYYY-MM-DD` |
   - Keep deferred items as `- [ ]` with note
   - Add `**Archived:** YYYY-MM-DD` footer

2. **Update PLAN.md:**
   - Move block to "Completed Blocks" section
   - Replace full details with 2-line summary + link:
     ```markdown
     ### CODE: Name ✓
     See [COMPLETED_PLAN.md](COMPLETED_PLAN.md#block-code)
     - Brief 1-line summary of deliverables
     ```
   - Update Block Overview table status to ✅ Complete

3. **Update Execution Sequence:**
   - Mark completed block as ✅
   - Adjust priorities if needed

4. **Promote next pending block:**
   - Move next "Pending" block to "In Progress"
   - Update Quick Status table
   - Update Next Steps section

---

## Page Tracking

### Page Verification Table

Update when pages are verified (in the "In Progress" section):

```markdown
**Page Verification Status:**
| Page | Status | Notes |
|------|--------|-------|
| HOME | ✅ Verified | 2026-01-06 |
| CBRO | ✅ Verified | 2026-01-07 |
```

### Page Count

Update the page count in session notes:

```markdown
- Page count: 29 Complete, 28 Spec Only
```

Calculate from:
- **Complete:** Pages with real React components (not PageSpecView)
- **Spec Only:** Pages using PageSpecView placeholder

---

## Admin/Feature Status Checklists

Use this format for implementation status:

```markdown
**Admin Implementation Status:**
- ✓ Admin Dashboard (ADMN) - Description
- ✓ Users Admin (AUSR) - Description
- → Sessions Admin (ASES) - Current focus (depends on Block 4)
- ○ Moderation (MODQ) - Not started
```

| Symbol | Meaning |
|--------|---------|
| ✓ | Complete |
| → | Current/In Progress |
| ○ | Not started |

---

## Confirmation Message

After updates, confirm with Peerloop-specific format:

```
PLAN.md Updated

Changes:
- [What was updated]

Current Status:
- Block: [Current block, e.g., "Block 7 & 8"]
- Focus: [Current implementation focus]
- Pages: [X Complete, Y Spec Only]

Session: [Date Time] - [Brief summary]

Next: [Immediate next action]
```

---

## Quick Reference

**Files to update:**
- `PLAN.md` - Main progress tracking
- `COMPLETED_PLAN.md` - Archive for completed blocks
- `PAGES-MAP.md` - Page status (separate from PLAN.md)

**Don't forget:**
- [ ] Quick Status section updated
- [ ] Session notes with date/time
- [ ] Page verification table (if pages verified)
- [ ] Page count in session summary
- [ ] Admin status checklist (if admin pages touched)
- [ ] "Last Updated" footer timestamp
