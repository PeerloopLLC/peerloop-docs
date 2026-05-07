---
name: /r-end must TaskCreate every surfaced alert
description: Red (🔴) and orange (🟠) alerts in /r-end Step 4 must call TaskCreate, not just display text — otherwise items vanish when conv ends
type: feedback
---

Every 🔴🔴🔴 and 🟠🟠🟠 alert surfaced in /r-end Step 4 MUST be followed by a TaskCreate call. Displaying the alert without writing to TodoWrite is a known failure mode — the item looks surfaced but doesn't persist to RESUME-STATE.md.

**Why:** Conv 062 surfaced a `maybeUpdateActorSession` design flaw as an orange alert but never called TaskCreate. The item vanished when the conv ended. The user caught it.

**How to apply:** In /r-end Step 4, after displaying each red or orange alert, immediately call TaskCreate with the issue as the subject. The SKILL.md was updated in Conv 062 to make this explicit.
