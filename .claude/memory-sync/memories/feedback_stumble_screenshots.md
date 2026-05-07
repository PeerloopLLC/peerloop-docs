---
name: STUMBLE walkthrough screenshot convention
description: When user says "with screenshots", capture PNGs at each BrowserIntent checkpoint during browser walks using macOS screencapture
type: feedback
---

When the user says "with screenshots" before a browser walk, take a screenshot at each BrowserIntent checkpoint and save to disk.

**Why:** User wants to review walkthrough evidence after completion without scrolling through conversation output.

**How to apply:**
1. `mkdir -p /tmp/stumble-screenshots/{instance-name}` at walk start
2. `screencapture -x /tmp/stumble-screenshots/{instance-name}/{NN}-{intent-slug}.png` at each checkpoint
3. `open /tmp/stumble-screenshots/{instance-name}` at walk end
4. Default is **no screenshots** — only capture when user says "with screenshots"
5. Use zero-padded NN (01, 02, ...) for sort order, kebab-case slug from intent name
