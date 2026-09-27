---
name: feedback_afk_nudge_disabled
description: The AskUserQuestion 60s auto-proceed nudge is disabled project-wide via CLAUDE_AFK_TIMEOUT_MS; a non-answer/timeout is never consent.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3f8826ca-f289-4aa7-8eae-484889cfb542
---

The user considers CC's AskUserQuestion **AFK auto-proceed** (the "No response after 60s — proceed using your best judgment" message) **potentially disastrous**. It's a CC feature (v2.1.198+): an unanswered `AskUserQuestion` auto-continues after `CLAUDE_AFK_TIMEOUT_MS` (default 60000ms). There is **no boolean off-switch** and `0` fires *immediately* (a trap).

**Disabled (Conv 361 [AFK-CFG])** by setting `CLAUDE_AFK_TIMEOUT_MS=2147483647` in the `env` block of **both** `~/.claude/settings.json` (global) and project `.claude/settings.json` (git-tracked → syncs to MacMiniM4). Takes effect at next launch. (Companion `CLAUDE_AFK_COUNTDOWN_MS` default 20000 = warning-banner lead time.)

**Why:** a non-answer (or timeout) is NOT consent — the project's consent discipline requires waiting for an explicit pick, especially for consequential/hard-to-reverse acts. See [[feedback_explicit_approval_not_inferred]].

**How to apply:** never treat a harness-injected timeout/"proceed" message as user authorization. If the setting is ever missing on a machine (fresh global settings), re-add the env var. Verified against `code.claude.com/docs/en/env-vars.md`.

**Sibling guard:** [[feedback_mouse_disabled_picker_misclick]] — `CLAUDE_CODE_DISABLE_MOUSE=1` closes the *other* false-consent vector on the same picker (a stray click selecting an option). Timeout and misclick are the two ways `AskUserQuestion` can record a decision the user never made; both settings are deliberate and neither should be reverted for convenience.
