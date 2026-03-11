---
name: w-eos
description: End-of-session sequence — runs learn-decide, dump, update-plan, and docs
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# End-of-Session Sequence

Runs the 4-skill end-of-session workflow in order. Each skill is invoked via the Skill tool.

**Do NOT skip or reorder steps.** Run each to completion before starting the next.

---

## Shared Timestamp

All session files created by this run share a single timestamp, pre-computed here:

!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')"`

**Pass these values as arguments** to `/w-learn-decide` and `/w-dump` so all session files match.

---

## Sequence

### Step 1: `/w-learn-decide`

Capture session learnings and decisions.

**Run:** Invoke `/w-learn-decide` via the Skill tool with args `{MONTH} {FILENAME}`. Complete it fully.

### Step 2: `/w-dump`

Create the development session log.

**Run:** Invoke `/w-dump` via the Skill tool with args `{MONTH} {FILENAME}`. Complete it fully.

### Step 3: `/w-update-plan`

Update PLAN.md with current progress.

**Run:** Invoke `/w-update-plan` via the Skill tool and complete it fully.

### Step 4: `/w-docs`

Update all project documentation.

**Run:** Invoke `/w-docs` via the Skill tool and complete it fully.

---

## Rules

- Run skills **sequentially** — each must finish before starting the next
- If a skill asks the user a question, wait for their answer before continuing
- After all 4 complete, display a summary:

```
End-of-Session Complete
───────────────────────
1. Learn/Decide  ✅
2. Session Dump   ✅
3. Plan Update    ✅
4. Docs Update    ✅
```

- Do NOT automatically commit or push — the user will run `/w-commit` separately if needed
