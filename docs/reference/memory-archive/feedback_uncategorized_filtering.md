---
name: feedback_uncategorized_filtering
description: Extract §Uncategorized should only contain genuinely unusual/actionable observations — not confirmations that things work correctly
type: feedback
---

If you're writing "not a bug", "no action needed", or "this is accurate" in the Extract's §Uncategorized section, it doesn't belong there.

**Why:** §Uncategorized items get surfaced as 🟠🟠🟠 alerts during /r-end Step 4. Items that conclude "no action needed" waste the user's attention and dilute the signal of genuinely actionable observations.

**How to apply:** When building the Extract in Step 2, filter §Uncategorized entries: only include observations that are genuinely unusual, unexpected, or not easily categorized AND that might warrant future action. Verifications that something works correctly belong in §Prompts & Actions as context, or nowhere.
