---
name: feedback_no_tool_call_spam_loops
description: "Every tool result is authoritative on first return; NEVER re-issue an identical call to \"flush\" a perceived buffer — there is no flush mechanism, re-issuing just re-runs and duplicates output into context"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d7bf206d-09fe-425d-a0da-5b9513a60976
---

**RECURRING-FAILURE CLASS.** If a tool call returns empty or seems delayed, do NOT infer "output is buffering and a flush arrives after N calls." **There is no buffer and no flush mechanism — that pattern is invented.** Re-issuing the identical call does not "flush" anything; it *re-executes* and appends another full copy of the output into context.

**Why:** Conv 218 — a couple of early Bash calls returned empty, I wrongly modeled it as buffering, then re-issued identical `Read`/`Bash`/`TaskList` calls **15–25× each** to "trigger the flush." Every repeat ran and returned the full file (`RESUME-STATE.md` 68 lines ×25, a `SKILL.md` region 169 lines ×20, `TaskList` ×30, large greps ×12). A near-empty interaction burned **~420K tokens and ~10 minutes**. The user caught it.

**How to apply:**
- **First result is authoritative.** Empty means empty — accept it and proceed, or retry **at most once** and only with a concrete reason the first genuinely failed.
- **NEVER issue more than one identical call.** No "give it a moment," no flush loops, no "the batch will arrive after a few more reads."
- If a tool genuinely appears broken after a single retry, **STOP and tell the user** — do not keep trying.
- Batch *distinct* independent calls in one message (good); never batch *repeats* of the same call (catastrophic).
- Watch the spend: if interaction is light but token use is climbing fast, suspect a duplication loop and halt. Related discipline: [[feedback_external_source_of_truth_first]], [[feedback_skill_body_stale_after_self_pull]].

**Carve-out — the [TERM-GARBLE] delivery-failure case (Conv 227).** The "no flush exists" framing above is about the *anti-spam* lesson, and it stands. But there IS a real failure mode where **empty-in-UI ≠ truly-empty**: the upstream parallel-tool cascade-cancel bug ([[reference_term_garble_upstream_bug]], #22264/#63966) delivers sibling results late and out-of-order, so a call can show empty *this turn* while its payload lands later in the JSONL. This does NOT license re-spamming — re-issuing the identical call ×N is still catastrophic (the Conv 218 repeats returned full output anyway = pure waste). The reconciliation, safe for **both** modes:
- When an empty result is **suspicious** (you just wrote a file; the command had known side effects), do NOT trust the empty AND do NOT re-issue the same call — verify **out-of-band** with a cheap, *different* probe (`wc -c`, `git status`, `ls`, `git show`). One distinct probe, not a repeat loop.
- **Never narrate tool output you did not actually receive**, and never attribute an instruction/quote to the user without a real user message (the #63538 confabulation guardrail).
