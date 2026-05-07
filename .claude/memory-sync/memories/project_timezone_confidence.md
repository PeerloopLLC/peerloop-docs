---
name: Timezone handling — partially gated
description: lint-timezone.sh enforced as Claude Code PreToolUse hook (Conv 091); human commits still ungated
type: project
---

Recurring `new Date()` regressions despite multiple sweeps prompted promotion of `lint-timezone.sh` to a Claude Code PreToolUse hook (Conv 091). Claude commits to the Peerloop code repo are now blocked if timezone-unsafe patterns are found.

**Why:** `new Date()` is the natural JS idiom — every new endpoint or copy-paste starts with it. The sweep-and-fix pattern was not durable. The hook prevents regressions at commit time.

**How to apply:** When writing ANY new server-side code (API routes, lib functions), always use `getNow()` from `@lib/clock` — never bare `new Date()`. The hook will block if you forget, but catching it earlier saves time. Human commits are NOT gated — see `docs/as-designed/lint-timezone.md` for the fragility analysis. When a second developer joins or CI is configured, add a git pre-commit hook and CI gate.
