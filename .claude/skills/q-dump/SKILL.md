---
name: q-dump
description: Create development session log
argument-hint: "[MONTH FILENAME] - optional: 2025-12 2025-12-29_14-30-00"
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Dump Session Log

**Purpose:** Create a development session log documenting the conversation.

---

## Project Config

!`cat .claude/config.json 2>/dev/null || echo "(no config.json found — using defaults)"`

**Used from config:**
- `paths.sessions` — output directory (default: `docs/sessions/`)

---

## Progress Tracking

**When called from `/q-end-session`:** Update the existing "Create Dev.md" item when complete.

**When called standalone:** Add this item to TodoWrite before starting:
- Create Dev.md session log

Mark `in_progress` when starting, `completed` when done.

---

## Execution Flow

1. **Get current timestamp:**
   - If `$ARGUMENTS` contains two values (MONTH FILENAME), use them directly
   - Otherwise, run these bash commands:
     ```bash
     date '+%Y-%m'              # MONTH (for directory)
     date '+%Y%m%d_%H%M'        # FILENAME (compact, no hyphens)
     ```

2. **Create the file:**
   - Directory: `{paths.sessions}/{MONTH}/`
   - Filename: `{FILENAME} Dev.md`
   - Example: `docs/sessions/2026-03/20260310_1059 Dev.md`

3. **Write the content** (see format below)

4. **Confirm creation** with file path

---

## File Format

```markdown
# Session Log - YYYY-MM-DD

## Development Transcript

[Chronological log of the session]

### [Topic or Task 1]

**User:** [Prompt summary or quote]

**Claude:** [Concise summary of action taken or answer provided]

### [Topic or Task 2]

**User:** [Prompt summary or quote]

**Claude:** [Concise summary of action taken or answer provided]

[Continue for all exchanges...]

---

## Session Prompts

User prompts from this session (for future reference):

- [First user prompt]
- [Second user prompt]
- [Third user prompt]
- ...
```

---

## Writing Guidelines

### Development Transcript Section

- Group related exchanges under topic headings when natural
- Summarize Claude's actions concisely — focus on what was done, not how
- No code blocks — reference the effect of code changes instead
- Capture the flow of decisions and problem-solving

### Session Prompts Section

- List all user prompts in chronological order
- Use the user's actual wording (can abbreviate if very long)
- One bullet per prompt
- Include follow-up questions and confirmations
- Purpose: Quick reference for reusable prompts

---

## Confirmation

Display:
```
Created: docs/sessions/{MONTH}/{FILENAME} Dev.md
  Transcript entries: {count}
  Prompts captured: {count}
```

**IMPORTANT**: Even if a recent Dev log exists, always ask the user if they want to update it before skipping.
