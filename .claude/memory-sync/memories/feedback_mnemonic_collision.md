---
name: Mnemonic code collision rule
description: TodoWrite mnemonic short codes must be unique — append sequential numbers on collision
type: feedback
---

When assigning mnemonic short codes to TodoWrite tasks, append a sequential number if the code already exists in the current list (e.g., `[GE]` → `[GE2]` → `[GE3]`).

**Why:** User observed duplicate codes appearing across tasks, making the "do GE" shorthand ambiguous.

**How to apply:** Always check the current task list before assigning a code. If the mnemonic derived from content collides, add the next available number suffix.
