---
name: Confirmations stand unless revoked by name
description: User-confirmed sub-decisions survive later topic-level pivots; don't silently erase a prior "I want X" when a broader statement arrives — treat confirmations as sticky until the user names the item to revoke
type: feedback
originSessionId: 91abea2f-5354-4fd6-983b-807666560f00
---
When the user has explicitly confirmed a specific sub-item earlier in a discussion (e.g., "I want the Opus reassessment step definitely"), and later makes a broader topic-level statement (e.g., "evolve same-named skills independently"), do **NOT** assume the broader statement revokes the earlier specific confirmation. Treat confirmations as persistent until the user names the specific item to revoke.

**Why:** Conv 140 (2026-04-19), during `/w-sync-skills` Opus-reassessment port discussion. User said "I want the Opus reassessment step definitely" early in the session. Later, after HARD-RULES-style discussion concluded with "I am going to evolve the same-named skills independently", I read that as revoking the Opus port too. It didn't — the later statement was about HARD-RULES scope, not the already-confirmed Opus item. User had to follow up to surface the miss. Treating the prior confirmation as sticky would have prevented the silent revoke and the re-open.

**How to apply:** During multi-turn discussions where user makes multiple specific confirmations:
1. Maintain a mental running list of user-confirmed items as the conversation progresses.
2. Before applying a topic-level pivot, replay the list against the pivot: "User confirmed X early — does this pivot name X?"
3. If the pivot does **not name the confirmed item specifically**, the confirmation stands. Keep X in your plan.
4. If genuinely ambiguous (e.g., pivot *could* reasonably subsume X), 👉👉👉 ask before revoking. Prefer asking over silent erasure.

**Default direction:** inclusion of prior confirmations, not silent removal. When in doubt, ask — cheaper than the user having to re-assert something they already said.

**Related memories:**
- `feedback_skill_sync_same_name_divergence.md` — same Conv 140 `/w-sync-skills` session, different lesson (structural divergence between same-named skills).
- `feedback_default_durable_no_ask.md` — quick/durable option pairs resolve without asking; this rule is the converse for items the user *has* already committed to.
