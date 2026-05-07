---
name: Prefix TodoWrite subjects with mnemonic short codes
description: Every TaskCreate subject must start with a unique 2-3 letter bracketed mnemonic code, so the user can reference tasks by code in chat
type: feedback
originSessionId: 6be62ff7-482a-4b7c-beb0-5ce7cc347918
---
Every TaskCreate subject must start with a unique 2-3 letter code in brackets. Examples: `[SD] Shadow docs review`, `[PL] Plan update`, `[DW] Drift window extension`.

**Why:** The user references tasks by code in chat ("do PL", "what's SD?", "close GE2") instead of typing full descriptions. The mnemonic also helps the user visually scan a pending list and pattern-match to recent context. Originally a global CC convention preserved in `~/.claude/CLAUDE-SAVED.md`; migrated to project memory on Conv 135 after confirming it was not transferred when the global CLAUDE.md was cleared.

**How to apply:**
- **Format:** `[XX]` or `[XXX]` — 2 or 3 uppercase letters, square brackets, followed by a space then the subject.
- **Derivation:** Mnemonic, based on task content (not random). A task about "tightening matchers" could be `[DT]` (Drift Tighten) or `[TM]` (Tighten Matchers) — pick whichever reads most obviously from the subject.
- **Uniqueness:** Must be unique within the *current* pending + in-progress task list. Always call `TaskList` before choosing a code.
- **Collision rule:** If the mnemonic already exists, append a sequential number: `[GE]` taken → `[GE2]` → `[GE3]`.
- **When to assign:**
  - At `TaskCreate` time.
  - During `/r-start` RESUME-STATE.md → TodoWrite transfers (assign codes as each item is lifted into the new list).
- **Referencing:** When the user says "do PL" or "close SD", match against the code prefix and operate on that task.
- **Related convention (different scope):** `PLAN.md` and commit summaries use longer hyphenated codes like `[RA-SSR]`, `[BKC-NEXT]`, `[CODECHECK-SQL]` for durable multi-conv block tracking. Those are valid in PLAN.md prose but this directive is stricter for TodoWrite: stick to 2-3 uppercase letters.
