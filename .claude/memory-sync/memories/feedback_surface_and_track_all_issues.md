---
name: surface-and-track-all-discovered-issues
description: "Never silently skip issues found during work — write everything into CURRENT-TASKS.md; and every surfaced 🔴/🟠 alert needs an explicit disposition + owner, not a vague future promise"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cdd106f7-aa2e-48e8-8d2f-b6f557bbf760
  modified: 2026-07-21T21:41:01.998Z
---

Never silently skip issues discovered during work. If you find something broken, stale, or wrong — even if it's pre-existing and not part of the current task — **record it in `CURRENT-TASKS.md`** (a `### [CODE]` body + a `## 🎯 Now` line) immediately.

**Tracking mechanism (Conv 406):** the Task subsystem (`TodoWrite`/`TaskCreate`) is **server-gated off** for this model, so tracking = **editing `CURRENT-TASKS.md` directly** (write-through — see [[feedback_current_tasks_persistence]]). A file edit is exactly as verifiable as the old tool call, so the discipline is unchanged; only the mechanism moved from a tool to a file edit.

**Why:** Session 386 established this after Claude skipped pre-existing test failures during a codecheck run. Session 390 violated it again by finding 4 stale TEST sub-docs and calling it "a large task" without creating a tracking item. The user had to catch it both times.

**How to apply:**
- When you discover any issue during work, add it to `CURRENT-TASKS.md` before moving on.
- "Large task" or "out of scope" is not an excuse to skip tracking — the CURRENT-TASKS.md entry IS the tracking.
- **Self-monitoring for output text:** When you write text the user will see that describes a problem you're NOT immediately fixing, that's a track-it trigger. Watch for these words in your own output: "stale", "out of date", "incomplete", "ambiguous", "inconsistent", "phantom", "missing", "needs updating", "later", "would need", "large task", "out of scope", "could also", "should also", "pre-existing", "unrelated to our changes".
- The rule: if you say it to the user but don't fix it before returning control, add it to `CURRENT-TASKS.md`.
- **Diagnosis without action:** A subtler trigger — if you're *explaining why something is wrong* (attributing causes, describing how a problem happened), you've identified an issue. The trigger isn't always an adjective like "stale"; it's the act of diagnosing a problem and then continuing past it. Session 390 example: "got mixed in, probably from a copy-paste error" about CALENDAR content inside DOC-SYNC-STRATEGY — diagnosis stated, no fix, no tracking.
- `/w-codecheck fix` means fix ALL issues, not just regressions.
- Scan user messages for implied action items: "should", "might", "could", "need to", "do later", "soon".

**Every surfaced alert needs an explicit disposition + owner (Conv 340).** The companion to the rule above: when you *do* surface an issue (🔴/🟠) but it is NOT fixed before you return control, the alert is **incomplete** until it names which disposition it is — **(a) resolved this turn**, **(b) now tracked as task `[CODE]`**, **(c) needs the USER's decision on X**, or **(d) FYI-only, no action (+ why)**. A vague future promise ("I'll log it at /r-end", "noted for later") is the failure mode: it reads as an unowned loose end. The visual anchor (🔴/🟠) says *where to look*; the disposition says *what it means for the user*. If it's becoming a task → write it into CURRENT-TASKS.md and cite its `[CODE]`; if genuinely no-action → say "FYI-only" outright; never leave it implied.

**"I'll handle it at /r-end" is especially misleading** — `/r-end` *reads* already-persisted files (`CURRENT-TASKS.md`, RESUME-STATE), it does **not** recover an in-chat promise. So the persistence must ALREADY exist on disk at the moment you say it. If you haven't written it into `CURRENT-TASKS.md`, "I'll record it at /r-end" is a no-op promise. **Why:** Conv 340 — after a 20-task review-and-close pass, CC flagged two subagent-overturns + a garbled dropped task as 🟠 but phrased them as "lesson logged for /r-end" with no actual persistence. Fix = bake the findings into the live task board and state each item's disposition+owner. (This is *also* why Conv 406 chose write-through over a batched refresh: the old `/r-end` "CRITICAL: call TaskCreate" rule went unenforceable the instant the tools vanished; a direct file edit can't silently no-op.)

**Codecheck / test findings specifically** (absorbed from former `feedback_codecheck_todos`, Conv 309): when running `/w-codecheck`, `tsc --noEmit`, `npm run lint`, `astro check`, or the full test suite, ALWAYS record any TS error / ESLint warning / Astro hint / test failure in `CURRENT-TASKS.md` — even if it looks pre-existing or unrelated. Never use "pre-existing", "not related to our changes", or "not from this session" to justify skipping. In fix mode, fix them; in default mode, track them.
