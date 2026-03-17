---
name: r-dump
description: Create development conv log
argument-hint: "[MONTH FILENAME] - optional: 2026-03 20260317_1400"
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Dump Conv Log

**Purpose:** Create a development conv log documenting the conversation.

---

## Pre-computed Context

**Existing conv files this month:**
!`/Users/jamesfraser/projects/peerloop-docs/.claude/scripts/session-files-dev.sh`

---

## Execution Flow

1. **Get current timestamp:**
   - If `$ARGUMENTS` contains two values (MONTH FILENAME), use them directly
   - Otherwise, run these bash commands:
     ```bash
     date '+%Y-%m'              # MONTH (for directory)
     date '+%Y%m%d_%H%M'        # FILENAME (compact)
     ```

2. **Create the file:**
   - Directory: `docs/sessions/{MONTH}/`
   - Filename: `{FILENAME} Dev.md`
   - Example: `docs/sessions/2026-03/20260317_1400 Dev.md`

3. **Write the content** (see format below)

4. **Confirm creation** with file path

---

## File Format

```markdown
# Conv Log - YYYY-MM-DD

## Development Transcript

[Chronological log of the conversation]

### [Topic or Task 1]

**User:** "[Verbatim user prompt, typos and all]"

**Claude:** [Concise summary of action taken or answer provided]

**User:** "[Next verbatim prompt in this topic]"

**Claude:** [Concise summary of response]

### [Topic or Task 2]

**User:** "[Verbatim user prompt]"

**Claude:** [Concise summary of action taken or answer provided]

[Continue for all exchanges...]

---

## Conv Prompts

User prompts from this conversation (for future reference):

- [First user prompt]
- [Second user prompt]
- [Third user prompt]
- ...
```

---

## Writing Guidelines

### Development Transcript Section

- **User prompts are VERBATIM** — copy the user's exact words in quotes, including typos, spelling errors, and informal phrasing. Never paraphrase or "clean up" what the user said.
- For very long prompts (5+ sentences), include the full first 2-3 sentences verbatim, then `...` and the key closing point verbatim
- Show **every exchange** as action/reaction pairs — User said X, Claude did Y
- Group related exchanges under topic headings when natural
- Summarize Claude's actions concisely — focus on what was done, not how
- No code blocks — reference the effect of code changes instead
- Short confirmations like "yes", "agreed", "done" are included verbatim with context in parentheses: `**User:** "yes" (push to origin)`

### Session Prompts Section

- List all user prompts in chronological order
- **Use the user's exact wording** — verbatim, in quotes
- One bullet per prompt
- Include follow-up questions and confirmations
- For long prompts, first sentence + `...` is acceptable

---

## Confirmation

Display:
```
Created: docs/sessions/{MONTH}/{FILENAME} Dev.md
  Transcript entries: {count}
  Prompts captured: {count}
```

**IMPORTANT**: Even if a recent Dev log exists, always ask the user if they want to update it before skipping.
