---
name: Surface and track all discovered issues
description: Never silently skip issues found during work — TodoWrite everything, even pre-existing problems
type: feedback
---

Never silently skip issues discovered during work. If you find something broken, stale, or wrong — even if it's pre-existing and not part of the current task — create a TodoWrite item for it immediately.

**Why:** Session 386 established this after Claude skipped pre-existing test failures during a codecheck run. Session 390 violated it again by finding 4 stale TEST sub-docs and calling it "a large task" without creating a tracking item. The user had to catch it both times.

**How to apply:**
- When you discover any issue during work, create a TodoWrite item before moving on
- "Large task" or "out of scope" is not an excuse to skip tracking — the TodoWrite IS the tracking
- **Self-monitoring for output text:** When you write text the user will see that describes a problem you're NOT immediately fixing, that's a TodoWrite trigger. Watch for these words in your own output: "stale", "out of date", "incomplete", "ambiguous", "inconsistent", "phantom", "missing", "needs updating", "later", "would need", "large task", "out of scope", "could also", "should also", "pre-existing", "unrelated to our changes"
- The rule: if you say it to the user but don't fix it before returning control, TodoWrite it
- **Diagnosis without action:** A subtler trigger — if you're *explaining why something is wrong* (attributing causes, describing how a problem happened), you've identified an issue. The trigger isn't always an adjective like "stale"; it's the act of diagnosing a problem and then continuing past it. Session 390 example: "got mixed in, probably from a copy-paste error" about CALENDAR content inside DOC-SYNC-STRATEGY — diagnosis stated, no fix, no TodoWrite.
- `/w-codecheck fix` means fix ALL issues, not just regressions
- Scan user messages for implied action items: "should", "might", "could", "need to", "do later", "soon"
