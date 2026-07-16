---
name: feedback_mouse_disabled_picker_misclick
description: CLAUDE_CODE_DISABLE_MOUSE=1 is a deliberate false-consent guard — a stray click once selected an AskUserQuestion option; never propose re-enabling the mouse.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 412c4696-4efc-4bf3-a60a-20ee13d573fe
---

`CLAUDE_CODE_DISABLE_MOUSE=1` in the `env` block of `~/.claude/settings.json` (global) is **intentional and load-bearing** — not stale config, not clutter to tidy.

**Why:** the `AskUserQuestion` picker (numbered options + "Type something") responds to mouse clicks. The user clicked intending to bring VS Code to the foreground — it was **already** foregrounded, so the click landed on the picker and **selected an answer they never intended to give**. Disabling the mouse removes that vector entirely. This is the click-analogue of [[feedback_afk_nudge_disabled]]: same failure (AskUserQuestion recording consent the user did not give), different trigger (stray click vs timeout). Both serve [[feedback_explicit_approval_not_inferred]].

**How to apply:**
- **Never propose re-enabling the mouse** as a fix, workaround, or "cleanup" — and don't treat it as an obstacle to route around. Conv 395 nearly did exactly this: while evaluating fullscreen/`/focus`, CC flagged `DISABLE_MOUSE` as a *problem* (fullscreen's click-to-expand for collapsed tool results needs it) before learning the rationale. The correct trade is the reverse: **accept losing click-to-expand, keep the guard**, use `Ctrl+O` (transcript viewer) for keyboard-driven inspection.
- If a feature genuinely requires the mouse, surface the conflict and let the user decide — do not flip the setting.
- Corollary: if a picker selection ever looks accidental or contradicts what the user just said, **do not act on it** — re-ask. A click is not more authoritative than the conversation around it.

**Related config (Conv 395 snapshot, global `~/.claude/settings.json`):** `tui: "default"` (classic renderer — `/focus` refuses to run without fullscreen), `verbose: true`, `effortLevel: "xhigh"`, `alwaysThinkingEnabled: true`, `autoCompactEnabled: false`. Backups written as `~/.claude/settings.json.bak-conv<N>-<ts>` before edits. See [[feedback_chat_vs_tooling_output_separation]].
