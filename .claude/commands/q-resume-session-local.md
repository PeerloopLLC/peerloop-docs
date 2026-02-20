---
description: Project-specific resume context (extends /q-resume)
argument-hint: ""
---

# Peerloop Resume Context

**Extends:** `/q-resume-session` (that skill calls this one at Step 4)

**Configuration** comes from `.claude/config.json`.

This skill gathers Peerloop-specific context to display when resuming work.

---

## Check 1: Machine Detection

**Check session context** for machine detection hook output.

Display machine name for reference. Both machines (MacMiniM4-Pro and MacMiniM4) have full capabilities.

---

## Check 2: Open RFCs

**Scan `RFC/INDEX.md`** for any RFCs with status "Open" or "In Progress".

**If open RFCs found**, add to context:

```
Open RFCs
─────────
[RFC-ID]: [Title] - [X] of [Y] items done
```

**If no open RFCs or INDEX.md doesn't exist:** Skip silently.

---

## Check 3: Block Progress

**Read PLAN.md** and extract:
- Current block code (e.g., ADMIN, VIDEO, TEACH)
- Current section (e.g., ADMIN.SESSIONS)
- Section progress (X of Y complete)

**Format for display:**

```
Block Progress
──────────────
Current: [BLOCK_CODE] - [Block Name]
Section: [BLOCK.SECTION] - [Section Name]
Progress: [X] of [Y] sections complete in this block
```

---

## Check 4: Page Implementation Status

**Scan `PAGES-MAP.md`** for implementation counts.

**Display:**

```
Page Status
───────────
Implemented: [X] pages (✅)
Spec Only:   [Y] pages (📋)
Total:       [Z] pages
```

---

## Output

Return all gathered context to the global `/q-resume` skill for inclusion in the final display.

The global skill will incorporate this into the "Current Position" output shown to the user.

---

## Notes

- All checks are informational - they help orient the developer
- Checks that find nothing skip silently to avoid noise
