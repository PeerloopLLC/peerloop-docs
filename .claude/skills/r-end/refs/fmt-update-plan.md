# Format Rules: PLAN.md Updates

Shared reference for the update-plan agent. Defines terminology, update actions, and block completion rules.

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

2. **If a section/sub-block completes:**
   - **Inline blocks** (no `plan/<slug>/` migration): strip the section from PLAN.md, add it to the block's "Completed:" one-liner summary at the top, keep detail for remaining sections only
   - **Migrated blocks** (`plan/<slug>/README.md` exists): strip the section from the README, add it to the README's "Completed:" summary or Conv-N entry, keep detail for remaining sections only

3. **If a block fully completes:**
   - Add terse entry to `plan/COMPLETED.md` (name + 1-line summary + conv range)
   - **Inline blocks:** remove the entire block from PLAN.md — no stub, no link, no "see plan/COMPLETED.md"
   - **Migrated blocks:** `git rm -r plan/<slug>/` (or the relevant per-phase/sibling files for a family), then remove the table-row from PLAN.md's Block Sequence table
   - Fold deferred items from the completing block into other relevant blocks
   - Update Block Sequence table — remove from ACTIVE
   - If a deferred block is ready, move it to ACTIVE

4. **Confirm completion** with brief message

**Do NOT invent footer sections at the bottom of PLAN.md.** PLAN.md has no "Next Steps", no "Last Updated", no narrative trail. The canonical per-conv narrative lives in `docs/sessions/<YYYY-MM>/<timestamp> Extract.md`; "what's next" lives in `CURRENT-TASKS.md` (task board) + `RESUME-STATE.md` (narrative). Both the "Last Updated" trail and "Next Steps" footer were dropped Conv 211.

---

## What Lives Where

| Content | Location | Notes |
|---------|----------|-------|
| **Remaining work (thin index)** | `PLAN.md` | Block Sequence tables; inline blocks for un-migrated content |
| **Block detail (migrated, single block)** | `plan/<slug>/README.md` | Per-block canonical content; PLAN.md keeps a thin table-row summary linking here |
| **Block detail (MATT family)** | `plan/matt/<phase\|sibling>.md` | Per-phase and per-sibling-block files; `plan/matt/README.md` is the family index |
| **Completed block archive** | `plan/COMPLETED.md` | Terse: name + 1-line summary + conv range |
| **Conv details** | `docs/sessions/` | Full conv logs (Extract, Decisions, Learnings) |
| **Tech Stack** | `CLAUDE.md` | Single source of truth |
| **Decisions** | `docs/decisions/` | Project decisions (topic chunks + decision-log.md + INDEX.md; `docs/DECISIONS.md` is a pointer) |

**Do NOT put in PLAN.md:**
- Completed work details (use plan/COMPLETED.md)
- Conv notes, narrative trails, or timestamps (use docs/sessions/ — the per-conv Extract is canonical)
- Decision records (use docs/decisions/ chunks — see INDEX.md)

---

## Block Completion Rules

### While a Block is Active

**Only show remaining work.** When a section completes:
- Strip it from PLAN.md
- Add it to the block's "Completed:" one-liner summary at the top
- Keep the detail for remaining sections only

### When a Block Fully Completes

1. **Add terse entry to plan/COMPLETED.md:**
   ```markdown
   ### BLOCKNAME: Block Name ✓
   Brief 1-line summary of deliverables. Convs: NNN-NNN (YYYY-MM-DD)
   ```

2. **Remove entire block from PLAN.md** — no stub, no link

3. **Fold deferred items** from the completing block into other relevant blocks

4. **Update Block Sequence table** — remove from ACTIVE

### Blocks Are Forward-Looking Only

PLAN.md contains only work that remains to be done. Completed work lives exclusively in plan/COMPLETED.md.
