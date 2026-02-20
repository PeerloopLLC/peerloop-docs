---
description: Project-specific force-end checks (extends /q-force-end)
argument-hint: ""
---

# Peerloop Force End Checks

**Extends:** `/q-force-end` (that skill calls this one at Step 4)

**Configuration** comes from `.claude/config.json`.

Minimal project-specific checks for fast session end.

---

## Check 1: Block Progress Note

**Read PLAN.md** and note current block for commit message context:

```
Block: [BLOCK_CODE] - [Block Name]
```

---

## Check 2: Open RFCs (Silent Note)

**Scan `RFC/INDEX.md`** - if open RFCs exist, add to commit message:

```
Open RFCs: [count] (review next session)
```

---

## Notes

- All checks are silent - no user prompts
- Information is for commit message context only
- Skip machine detection (not actionable at session end)
- Skip page status (too verbose for force-end)
