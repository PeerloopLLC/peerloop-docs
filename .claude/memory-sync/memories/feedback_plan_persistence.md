---
name: Plan files are ephemeral — persist to committed files
description: CC Plan Mode files (.claude/plans/) vanish after /clear. Must write durable plans to committed locations.
type: feedback
---

CC Plan Mode "saves" to `.claude/plans/` which is gitignored and ephemeral — plans do NOT survive `/clear` or session end. The word "save" is misleading.

**Why:** Conv 055 created a detailed ADMIN-INTEL implementation plan in Plan Mode. User was told it was "saved." After `/r-end` → `/clear` → `/r-start`, the plan file was gone. User had to re-plan from scratch in Conv 056.

**How to apply:**
1. NEVER tell the user a plan is "saved" without clarifying it's session-only
2. When a plan will be needed after `/clear` or in a future conversation, write it to a **committed file** (e.g., `docs/as-designed/plan-BLOCKNAME.md` or expand the block in PLAN.md)
3. Before `/r-end`, check if any plan files exist in `.claude/plans/` and offer to persist them to a durable location
4. If the user says "save the plan" — they mean persist it permanently, not Plan Mode's ephemeral save
