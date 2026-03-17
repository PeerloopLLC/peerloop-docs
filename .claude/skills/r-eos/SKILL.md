---
name: r-eos
description: End-of-conv sequence — runs learn-decide, dump, update-plan, and docs
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Skill
---

# End-of-Conv Sequence

Runs the 4-skill end-of-conv workflow in order. Each skill is invoked via the Skill tool.

**Do NOT skip or reorder steps.** Run each to completion before starting the next.

---

## Shared Timestamp

All conv files created by this run share a single timestamp, pre-computed here:

!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')"`

**Pass these values as arguments** to `/r-learn-decide` and `/r-dump` so all conv files match.

---

## Sequence

### Step 1: `/r-learn-decide`

Capture conv learnings and decisions.

**Run:** Invoke `/r-learn-decide` via the Skill tool with args `{MONTH} {FILENAME}`. Complete it fully.

### Step 2: `/r-dump`

Create the development conv log.

**Run:** Invoke `/r-dump` via the Skill tool with args `{MONTH} {FILENAME}`. Complete it fully.

### Step 3: `/r-update-plan`

Update PLAN.md with current progress.

**Run:** Invoke `/r-update-plan` via the Skill tool and complete it fully.

### Step 4: `/r-docs`

Update all project documentation.

**Run:** Invoke `/r-docs` via the Skill tool and complete it fully.

---

## Rules

- Run skills **sequentially** — each must finish before starting the next
- If a skill asks the user a question, wait for their answer before continuing
- After all 4 complete, display a summary:

```
End-of-Conv Complete
────────────────────
1. Learn/Decide  ✅
2. Conv Dump      ✅
3. Plan Update    ✅
4. Docs Update    ✅
```

- Do NOT automatically commit or push — `/r-end` handles that
