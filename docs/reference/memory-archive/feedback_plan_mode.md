---
name: cc-plan-mode-verification-use-ephemerality
description: "Use Plan Mode to stress-test designs AFTER discussion (not just to propose); and Plan Mode files are ephemeral (gitignored, vanish on /clear) so persist durable plans to committed files"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cdd106f7-aa2e-48e8-8d2f-b6f557bbf760
---

Two lessons about CC Plan Mode.

## Plan Mode as a verification tool (not just a proposal tool)

Plan Mode has two uses — don't skip the second:
1. **Proposal:** propose an implementation approach before coding (the obvious use).
2. **Verification:** stress-test a design that already feels complete — check for gaps, edge cases, performance, missed dependencies.

**Why:** twice in a week (~Conv 015-017) we scoped a plan through discussion, then entered Plan Mode anyway to verify — both times it caught things. A design that feels done after discussion may still have blind spots.

**How to apply:** after a design discussion produces a spec (written into PLAN.md / architecture docs), consider entering Plan Mode to pressure-test it before building. The conversation shapes the design; Plan Mode verifies it.

## Plan files are ephemeral — persist to committed files

CC Plan Mode "saves" to `.claude/plans/` which is gitignored and ephemeral — plans do NOT survive `/clear` or session end. The word "save" is misleading.

**Why:** Conv 055 created a detailed ADMIN-INTEL plan in Plan Mode; the user was told it was "saved." After `/r-end` → `/clear` → `/r-start` it was gone, and the user had to re-plan from scratch in Conv 056.

**How to apply:**
1. NEVER tell the user a plan is "saved" without clarifying it's session-only.
2. When a plan will be needed after `/clear` or in a future conv, write it to a **committed file** (e.g. `docs/as-designed/plan-BLOCKNAME.md` or expand the block in PLAN.md).
3. Before `/r-end`, check `.claude/plans/` for plan files and offer to persist them.
4. If the user says "save the plan" — they mean persist it permanently, not Plan Mode's ephemeral save.
