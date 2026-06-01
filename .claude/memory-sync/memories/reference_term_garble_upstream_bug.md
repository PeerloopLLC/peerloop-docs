---
name: reference_term_garble_upstream_bug
description: "The Conv-226 tool-output 'garble' is a known OPEN upstream Claude Code bug cluster — parallel-tool cascade-cancel (Opus 4.8) causing empty/late/out-of-order tool results, plus model confabulation of un-received output; not a Peerloop bug; mitigations + version watch"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 9ecfccce-f95a-4e88-ae77-f0bac13eb189
---

**[TERM-GARBLE] root cause (Conv 227 research).** The intermittent blank/partial tool-output renders + the one fabricated-failure narration in Conv 226 are a **known, OPEN, upstream Claude Code bug cluster** — NOT a Peerloop bug, not our config, not a Bash/MCP failure on our side. Two stacked bugs:

1. **Harness delivery failure** — [#22264](https://github.com/anthropics/claude-code/issues/22264) (root: parallel tool calls cascade-fail when one sibling fails) → [#63966](https://github.com/anthropics/claude-code/issues/63966) / [#63859](https://github.com/anthropics/claude-code/issues/63859) / [#63797](https://github.com/anthropics/claude-code/issues/63797): sibling results show **empty in the live UI**, then **flush late and out-of-order**. The payload is NOT lost — the JSONL transcript eventually contains the full `tool_result` — it just doesn't reach the model *that turn*. = the "blank/partial render that cleared next turn."
2. **Model confabulation** — [#63538](https://github.com/anthropics/claude-code/issues/63538): faced with an empty/cancelled-looking batch, the model **fabricates** the missing output, and in the worst observed case **invented a verbatim user instruction** and attributed it to the user. = "narrated a garble that didn't happen." This is the dangerous half (a dropped payload is recoverable; a fabricated user instruction is not self-evidently wrong from the inside).

**Trigger conditions (ALL present in our environment):**
- macOS (cluster confirmed cross-platform: macOS #63966, Linux #63797, Windows comments — so OS is not the lever).
- **`claude-opus-4-8`** — comments repeatedly cite "much worse since the Opus 4.8 update"; this is the strongest correlate.
- **Parallel tool batches** (Bash/Read/MCP). Heavier batches → higher risk.
- **Any ONE sibling failing** cascade-cancels the rest. Confirmed trigger classes: a runtime error, a chained command whose tail legitimately exits non-zero, a flaky/Unauthorized MCP call, **AND a PreToolUse hook that BLOCKS one call** (commenter repro). We run `guard-dangerous-bash.sh` ([[project_settings_tier_local_control]] [SETTINGS-GUARD]) as a PreToolUse hook → it is a live amplifier.

**Version exposure:** Conv 226 ran on **2.1.158**; Conv 227 on **2.1.159** (user said "2.1.58→2.1.59" — a dropped digit; `claude --version` = 2.1.159). Changelog 2.1.155–2.1.159 has NO tool-delivery fix (2.1.159 = "internal infrastructure improvements, no user-facing changes"). All 5 core issues remain **OPEN**. **Assume still exposed** until a changelog explicitly fixes parallel tool-result delivery. Tracked as `[GARBLE-WATCH]`.

**Frequency in OUR environment (user report, Conv 227):** NOT isolated to Conv 226 — garble/transient-failure symptoms have recurred **several times over the last ~10 convs**. So this is a sustained exposure pattern, not a one-off. This base rate is the comparison anchor for `[GARBLE-WATCH]`: a genuine upstream fix should drop it to ~zero across a comparable span. **Conv 227 itself ran CLEAN** on 2.1.159 across many wide parallel batches (10–13-call TaskCreate/TaskUpdate batches, 4-file parallel Read, WebFetch+WebSearch+gh batches) with no observed empty/late/out-of-order result and no fabrication — a *weak positive* signal (n=1, intermittent bug → NOT evidence of a fix; do not close the watch on it). Caveat: CC cannot fully self-certify absence of garble from the inside (#63538 confabulation feels indistinguishable) — Conv 227's "clean" rests partly on the out-of-band verify discipline being run throughout.

**Mitigations (what to actually do):**
- **Prefer narrower parallel batches** when a hook-guarded Bash command (anything that could trip `guard-dangerous-bash.sh`) or a flaky MCP call is in the mix — one casualty cancels the batch. Serialize the risky call out of the batch.
- **On a suspicious-empty result** (just wrote a file; command had known side effects), verify **out-of-band** with a cheap *different* probe (`wc -c`, `git status`, `ls`, `git show`) — do NOT trust the empty, and do NOT re-spam the identical call. See the reconciliation in [[feedback_no_tool_call_spam_loops]].
- **NEVER narrate tool output not actually received.** Empty/cancelled = re-run the *specific* call or verify out-of-band; never reconstruct/infer. Never attribute an instruction or quote to the user without a real user message.
- Conv 226's own discovered mitigation (re-verify every write via clean `git status`/grep) is correct and aligns with the upstream-documented workaround (`cmd > /tmp/x 2>&1` then Read + verify).
