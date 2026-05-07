---
name: Plan Mode as verification tool
description: Use CC Plan Mode to stress-test designs AFTER discussion, not just for proposing approaches before coding
type: feedback
---

Plan Mode has two uses — don't skip the second one:

1. **Proposal:** Propose an implementation approach before coding (the obvious use)
2. **Verification:** Stress-test a design that already feels complete — check for gaps, edge cases, performance concerns, missed dependencies

**Why:** Twice in a week (approx Conv 015-017), the user and I scoped out a plan through discussion, then entered Plan Mode anyway to verify our thinking. Both times it caught things. A design that feels done after discussion may still have blind spots that structured Plan Mode scrutiny reveals.

**How to apply:** After a design discussion that produces a spec (written into PLAN.md / architecture docs), consider entering Plan Mode to pressure-test it before building. Don't skip this step just because "we already planned it in conversation." The conversation shapes the design; Plan Mode verifies it.
