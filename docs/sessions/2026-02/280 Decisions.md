# Session Decisions - 2026-02-24

## 1. Create /q-eos as Global Convenience Skill
**Type:** Strategic
**Topics:** cc-workflow

**Trigger:** User wanted to run 4 end-of-session skills (/q-learn-decide, /q-dump, /q-update-plan, /q-docs) as a single command rather than invoking each separately.

**Options Considered:**
1. Run each skill manually every session
2. Create a project-local convenience skill ← Not chosen (all 4 skills are global)
3. Create a global convenience skill at ~/.claude/commands/q-eos.md ← Chosen

**Decision:** Created `/q-eos` (end-of-session) as a global skill that sequentially invokes the 4 skills. It lives in `~/.claude/commands/` so it works across all projects.

**Rationale:** All 4 constituent skills are global, so the orchestrator should be global too. Sequential execution ensures each skill completes before the next starts. The skill does not auto-commit — `/q-commit` remains separate.

**Consequences:** End-of-session workflow reduced from 4 manual invocations to 1. The existing `/q-end-session` skill (which includes additional checks) remains available for more thorough sessions.
