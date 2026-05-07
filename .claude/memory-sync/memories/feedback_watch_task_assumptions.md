---
name: Watch-tasks must state the assumed delivery/loading state in their framing
description: A "watch" task observes whether a rule, fix, or behavior change holds — but the watch implicitly assumes the rule/fix is actually delivered, loaded, and reaching the relevant machine. State the assumption explicitly so the watch-end audit starts by falsifying it, not by debating rule content.
type: feedback
originSessionId: a41e95eb-15c4-4545-89cf-53b90e891f0f
---
When framing a watch-task — a TodoWrite/RESUME-STATE item that says "monitor whether X behavior holds" or "verify whether X rule is sufficient" over some span of convs — explicitly state the assumed delivery/loading precondition alongside the watched outcome. The framing must read **"watching X assuming Y is loaded/delivered/reached the machine"** so that the audit at watch-end has a falsifiable starting hypothesis.

**Why (Conv 149 [OPW] / Conv 150 close):** `[OPW]` was framed as "Watch `feedback_option_phrasing.md` Conv 147 strengthening over next ~5 convs" — implicitly assuming the strengthened rule was loaded into context on the watching machine. A subsequent Conv 148 violation looked like a content failure ("the strengthened rule isn't strong enough"). Conv 150 investigation found the actual root cause: the file had been authored on MacMiniM4 to a `/Users/livingroom/...` path, never reached MacMiniM4-Pro, and was never in context on the violating-conv machine *at all*. The rule wasn't insufficient; it was absent. The watch-task framing didn't surface "is this rule even loaded here?" as the first thing to check, so it took an entire conv plus an Explore agent to falsify the delivery assumption. With a stated assumption — "watching strengthening, **assuming** `feedback_option_phrasing.md` is loaded on MacMiniM4-Pro at session start" — the watch-end audit would have hit "check assumption first → file does not exist on this machine → STOP, fix delivery before continuing the watch."

**How to apply:**

1. **Every watch-task gets two parts:** the watched outcome, and the assumed precondition. If you cannot name a precondition, the task is not well-defined yet — derive one from "what has to be true for this watch to make sense?"
2. **The assumption belongs in the task subject (or first line of description),** not buried in a separate file. The TodoWrite/RESUME-STATE entry is what gets reloaded each conv; if the assumption is not there, future-Claude will not think to check it.
3. **At watch-end, falsify the assumption first.** Before discussing whether the rule strengthened enough or the fix held, verify the precondition was actually true throughout the watch window. If it was not, the watch is uninformative and the real issue is the precondition's failure.
4. **Common implicit assumptions worth surfacing:**
   - **Memory file presence on the relevant machine(s)** — cross-machine sync gap is real, tracked as `[CMS]`.
   - **Rule indexed in MEMORY.md so it loads** — a memory file that exists on disk but is not indexed is functionally invisible.
   - **Fix-commit deployed** to the environment under observation (staging/prod/local).
   - **Cache/CDN invalidated** so the watcher sees the post-fix state.
   - **Session-start hooks ran successfully** so context is initialized correctly.
   - **The behavior path actually exercises the rule** — a watch-task on a rule that fires only in scenario X is meaningless if scenario X did not occur during the window.

**Format examples:**

Too soft (what to avoid):
- `[OPW] Watch feedback_option_phrasing.md Conv 147 strengthening over next ~5 convs`
- `[XYZ] Watch whether the staging-cache fix holds for 2 weeks`
- `[ABC] Watch for regression in [feature]`

Load-bearing (what to write):
- `[OPW] Watch feedback_option_phrasing.md Conv 147 strengthening over next ~5 convs — assumes file present at memory/ on MacMiniM4-Pro AND indexed in MEMORY.md`
- `[XYZ] Watch staging-cache fix holds for 2 weeks — assumes commit abc123 deployed to staging Worker AND CF cache purged after deploy`
- `[ABC] Watch for [feature] regression over next ~3 convs — assumes test-suite includes coverage for the regression scenario AND tests run on every conv`

The assumption clause is what future-Claude checks first. Without it, the watch is just a vibe-check that produces a confident answer to the wrong question.
