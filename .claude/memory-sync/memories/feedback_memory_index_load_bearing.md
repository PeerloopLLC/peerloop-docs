---
name: MEMORY.md index lines must expose load-bearing parts of rules
description: Each MEMORY.md one-liner must include the visually-distinctive markers, trigger conditions, and anti-patterns of its rule — not just a topic label. The index is always-loaded context; the file body isn't. Soft summaries cause Claude to miss the active ingredient.
type: feedback
originSessionId: a41e95eb-15c4-4545-89cf-53b90e891f0f
---
When writing or updating a one-liner in MEMORY.md, the line must surface the **load-bearing** components of the underlying rule — not just a topic summary. MEMORY.md is loaded into every conversation's context; the file body is not. If the index line describes only the topic, future-Claude will see the topic but skip past the active ingredient that makes the rule actionable.

**Why:** Conv 150 hand-merged a memory directory and used "Bold questions" as the MEMORY.md one-liner for the pointing-question rule. In Conv 151 the index summary anchored Claude on "bold the question" and silently dropped the 👉 prefix — the body of the file had it, but the body wasn't loaded. The rule's distinctive marker was in the file, invisible from the always-loaded index. The fix wasn't to change the rule; it was to change the index line so the marker was always in scope.

**How to apply:**

Each MEMORY.md line should expose at least the relevant subset of:

1. **Visually-distinctive markers** — the exact tokens that make a rule recognizable (`👉👉👉`, `A) B) C)`, `🔴🔴🔴`, `git -C <abs-path>`, `npm test 2>&1 | tee /tmp/...`, etc.). If the rule prescribes a specific format, that format must appear in the line.
2. **Trigger condition** — when the rule kicks in. "Non-yes/no questions" beats "option questions"; "After `cd ../Peerloop && npm ...`" beats "in dual-repo work."
3. **Anti-pattern or counter-rule** — when the rule is mostly "don't do X," X must appear in the line. "never or-tail 'X, Y, or Z?' prose" beats "non-yes/no question format."

A summary that elides all three is too soft. Two-of-three is usually enough; one-of-three is borderline; zero-of-three is a topic label, not a rule.

**Examples:**

Too soft (what to avoid):
- `"Bold questions"` → omits 👉👉👉 (the more distinctive marker)
- `"Question format"` → omits both marker and trigger
- `"Test capture discipline"` → omits the actual `tee /tmp/...` invocation

Load-bearing (what to write):
- `"Prefix user-facing questions with **👉👉👉 + bold** — combined emoji+bold is the visual anchor (bold alone isn't enough)"`
- `"Non-yes/no questions: use A) B) C) labels (one per line); never or-tail 'X, Y, or Z?' prose"`
- `"Full test suite: always `tee /tmp/lastFullTestRun.log`; run strategically (~3min cost)"`

**Stub-file index lines (CLAUDE.md is the canonical home):** When the rule itself lives in CLAUDE.md and the memory file is a grep-anchor stub, the MEMORY.md line should say `"Stub pointer: [rule] lives in CLAUDE.md §[Section]."` Don't re-summarize the rule there — the rule is already always-loaded via CLAUDE.md, and the stub line's job is just to confirm where it now lives.

**When updating an existing line:** if you find yourself shortening it to fit a length budget, check whether the part you're cutting is load-bearing (a marker, trigger, or anti-pattern). If it is, cut prose elsewhere or keep the line longer — soft-summary cuts cause silent rule loss.

**Index-vs-body drift discipline:** Whenever you **edit a memory file** (add a rule, remove a rule, change the marker, rename a section), re-read its MEMORY.md index line in the same edit and reconcile. The index line is independent text — it does not auto-update when the file body changes, so it can silently drift away from what the file actually says.

The check is short: read the file body's headings/markers, then read the index line, then ask "does the line still describe what's in the file? Are there markers in the body the line should now surface? Are there markers in the line the body no longer has?"

**Motivating drift case (Conv 151 [ILS-AUDIT]):** `e2e-testing-patterns.md` body had only two rules — React-hydration `waitForLoadState('networkidle')` and cross-test DB contamination — but its MEMORY.md line claimed *three* sub-topics including "BBB webhook HMAC token" and "filter-dropdown caveats" that did not exist in the file. The body had been edited at some point and the line was never reconciled. By the time of the audit, no archaeology trail remained for whether those rules were ever there or were always hallucinated. The cost of the drift: any future Claude grepping MEMORY.md for "HMAC" or "filter-dropdown" would see a hit, click through, and find nothing.

**How to apply:**
- After every Edit/Write to a file in `memory/`, immediately Read MEMORY.md and check its index line for the file.
- If the file's load-bearing tokens have changed, update the line to surface the new tokens and drop the obsolete ones.
- If you are deleting an entire rule from the file, also delete the corresponding fragment from the line.
- If you cannot tell whether the index line still matches without re-reading the body, that's the signal to re-verify — the line should be terse enough to evaluate at a glance.
