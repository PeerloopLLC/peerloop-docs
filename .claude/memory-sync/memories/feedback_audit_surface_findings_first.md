---
name: audit-surface-findings-first
description: "When user framing is investigative (audit / review / investigate / examine / classify / analyze / explore / scan / survey), surface per-item findings and ask 👉👉👉 before executing — overrides §Solution Quality's default-proceed because the user can't anticipate findings"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: db3243e9-c9f9-46d8-8cb4-0bcbc2a42fc2
---

**Rule.** When the user's request is framed as investigation, audit, exploration, classification, or "look at X" work — verbs like *audit, review, investigate, examine, scan, classify, judge, assess, evaluate, analyze, compare, survey, explore* — present findings as a per-item disposition list, then ask 👉👉👉 for confirmation **before** executing any writes.

This OVERRIDES CLAUDE.md §Solution Quality's "state which option and proceed" + §Critical Rule's "size-≠-novelty / proceed without check-in" carve-outs. Those rules were designed for "which approach to a known task" decisions; they fail when the user has commissioned an investigation whose outputs they cannot scope in advance.

**Why.** Conv 206 [MEM-AUDIT]: user asked what could be done about a near-cap MEMORY.md. CC presented options A/B/C; user picked **C** (full audit pass — re-read every line, judge stub/trim/retire/keep). CC executed the full rewrite end-to-end, then reported the result. The §Solution Quality + §Critical Rule directives technically permitted it (stub-pointer is an established MEMORY.md pattern; size ≠ novelty). The user pushed back, articulating the structural failure:

> *"I have to know that you will act when you are only asked. I think that is likely to fail as I do not have the advantage of a MEMORY.md file in my head that will cause me to add 'Do not act on the audit' or 'Do not act on what you find' each time. Because I cannot know what you will find."*

The asymmetry is load-bearing: when CC investigates, CC sees the findings during the investigation and would have to *additionally* surface them. When the user picks an audit option, they cannot preemptively constrain the action — the findings don't exist yet from their perspective. So the default must be conservative for investigative framings, even when the action would otherwise be "established pattern, proceed."

**How to apply.**

1. **Trigger verbs (request side).** When the user's wording is investigative — *audit, review, investigate, examine, scan, classify, judge, assess, evaluate, analyze, compare, survey, explore, look at, what could be done about, what's wrong with* — engage the surfacing discipline.

2. **Picking an option WITHIN an investigative framing authorizes the approach, not the execution.** If CC presents `A) quick audit / B) medium audit / C) full audit` and the user picks C, that authorizes *depth and scope* — not the eventual writes. Investigate → surface dispositions → 👉👉👉 → wait → execute.

3. **Surface format = per-item disposition list.** Show each item's proposed disposition ("stub / trim / retire / keep" or equivalent) with a one-line rationale. Group by action when many items. End with `👉👉👉 **OK to apply these N changes? (yes / let me adjust)**` — single confirmation gate for the batch, not per-item.

4. **§Solution Quality + §Critical Rule carve-outs do NOT override this.** Even if every individual change follows an established pattern, the bundled audit needs surfacing as a unit.

5. **Cost calibration.** One round-trip (the surface + the answer) costs seconds; an unscoped audit pass that touches the wrong things costs git archaeology + reapply. The asymmetry strongly favors surfacing.

**Edge cases that don't trigger this rule.**

- **Read-only exploration** (grep, file inspection, web fetch, MCP probes with no writes). The rule is about *acting on findings*; pure reads aren't subject to it.
- **Single-decision audits.** If the investigation produces exactly one decision (e.g. "is X stale, yes or no?"), the surface IS the answer — no separate confirmation step.
- **Mechanical follow-through after explicit batch approval.** Once the user has seen and approved the disposition list, batch through subsequent similar items in the same surface without re-asking. The rule isn't "ask per item"; it's "ask once before the batch."
- **Imperative directives** ("rewrite X to use Y", "delete Z", "rename foo to bar"). These are instructions, not investigations. §Solution Quality applies — proceed.

**The verb test.** If the user's request can be paraphrased as *"tell me what's true / what's there / what's wrong"* — surface first. If it can be paraphrased as *"make this change / build this thing / fix this bug"* — proceed per §Solution Quality.

Related: [[feedback_default_durable_no_ask.md]] (the rule this overrides), [[feedback_pause_on_pointing_questions.md]] (👉👉👉 must be last visible content), [[feedback_conversational_brevity.md]] ([MCFRAME]: when user steers with specifics, execute — that rule still applies for *steers*, not investigations).
