---
name: feedback-mirror-term-annotation
description: "When CC says \"mirror\" (memory-sync mirror), append \"(from last r-end)\" — the bare term is hard for the user to rationalize"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6b4a6368-f4c2-4625-afd1-68e21318d030
---

When referring to the in-repo memory **mirror** (`.claude/memory-sync/memories/`, refreshed by the `/r-start` pull and synced mirror↔live), always append **"(from last r-end)"** the first time it appears in a turn — e.g. "the mirror (from last r-end) differs from live". The user finds the bare word "mirror" hard to rationalize on its own.

**Why:** "mirror" is ambiguous about direction and freshness. The annotation makes concrete that the mirror's contents are whatever the *previous conversation's `/r-end`* pushed (live→mirror), so it's a point-in-time snapshot, not a live view.

**How to apply:** Any `/r-start` Step 5.7 sync narration, or any prose mentioning the memory-sync mirror. Live→mirror happens at `/r-end`; mirror→live happens at `/r-start`. Related: [[feedback_msi_sync_user_checkpoint]].
