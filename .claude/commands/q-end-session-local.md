---
description: Project-specific end-of-session checks (extends /q-end-session)
argument-hint: ""
---

# Peerloop End-of-Session Checks

**Extends:** `/q-end-session` (that skill calls this one at Step 4.5)

**Configuration** comes from `.claude/config.json`.

This skill runs project-specific checks before the final commit prompt.

---

## Progress Tracking with TodoWrite

**When called from `/q-end-session`:** The parent skill manages the master checklist. Update the existing "Run /q-end-session-local" item when complete.

**When called standalone:** Add these items to TodoWrite before starting:
- Check open RFCs
- Check machine-specific workarounds
- Extract block progress
- Check page implementation status

Mark each `in_progress` when starting, `completed` when done.

---

## Check 1: Open RFCs

**Scan `RFC/INDEX.md`** for any RFCs with status other than "Complete".

**If open RFCs found**, display:

```
Open RFCs Detected
──────────────────
[List RFC codes and titles with Open/In Progress status]

Consider:
- Were any RFC items completed this session? Update RFC/CD-XXX/RFC.md
- Should RFC/INDEX.md status be updated?
```

**If no open RFCs or INDEX.md doesn't exist:** Skip silently.

---

## Check 2: Machine-Specific Workarounds

**Scan session files created this session** for mentions of:
- `MacMiniM4-Pro`
- `MacMiniM4`
- D1 or R2 local emulation issues

**If matches found**, display:

```
Machine-Specific Content Detected
─────────────────────────────────
Found references to: [MacMiniM4-Pro/MacMiniM4/etc.]

Consider updating: docs/tech/tech-013-devcomputers.md
- New capability noted?
- D1/R2 behavior documented?
```

**If no matches:** Skip silently.

---

## Check 3: Block Progress

**Read PLAN.md** and extract current block information.

**Display in summary format:**

```
Block Progress
──────────────
Current: [BLOCK_CODE] - [Block Name]
Section: [Current section, e.g., ADMIN.SESSIONS]
Progress: [X of Y sections complete]
```

This information is used by the global skill for the final summary display.

---

## Check 4: Page Implementation Status

**If pages were modified this session**, check `PAGES-MAP.md` for:
- Any pages changed from 📋 (spec only) to ✅ (implemented)
- Any new feature checkboxes completed

**If page status changed**, remind:

```
Page Status Update
──────────────────
Pages modified: [list]

Verify PAGES-MAP.md is updated with:
- Implementation status (📋 → ✅)
- Feature checkboxes
- Route confirmation
```

**If no page changes:** Skip silently.

---

## Notes

- All checks are advisory - they don't block the session end
- Checks that find nothing skip silently to avoid noise
- The global skill handles the actual commit prompt
