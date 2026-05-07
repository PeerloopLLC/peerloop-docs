---
name: RESUME-STATE is TodoWrite persistence
description: RESUME-STATE.md is only a serialization layer for TodoWrite — user interacts with TodoWrite, not RESUME-STATE directly
type: feedback
---

RESUME-STATE.md is a persistence mechanism for TodoWrite tasks across conversations, not a user-facing artifact.

**Why:** The user doesn't want to think about RESUME-STATE.md separately. Outstanding items should always surface as TodoWrite tasks — one interface, not two.

**How to apply:**
- `/r-start` Step 7: Read RESUME-STATE.md → create TaskCreate entries → delete the file
- `/r-end` / `/r-save-state`: Serialize current TodoWrite pending items → write RESUME-STATE.md
- Never ask the user to "check RESUME-STATE.md" — they see tasks via TodoWrite only
- Git history preserves the state if historical lookup is needed
