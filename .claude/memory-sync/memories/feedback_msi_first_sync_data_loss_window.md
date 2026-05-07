---
name: MSI sync user-checkpoint rule
description: /r-start Step 5.7 always pauses on any non-empty diff between mirror and live before applying rsync; data-loss (`Only in $LIVE`) is the escalation sub-case with auto-backup + A/B/C; structural rule lives in skill code (Conv 156 generalization of Conv 155 data-loss-only halt)
type: feedback
originSessionId: 31ca911f-5d4b-49e2-8629-fcb943aa0b59
---
The /r-start Step 5.7 mirror → live sync always pauses on any non-empty `diff -rq mirror vs live` and asks the user before applying `rsync -a --delete`. Empty-diff is the only silent path. Two question shapes:

- **`Files X and Y differ` and/or `Only in mirror` entries (incoming changes, no live-only):** simple `yes` / `no`. Yes runs Phase 2 rsync. No skips Phase 2 with a warning that the next /r-end will overwrite mirror with this machine's pre-sync state, rejecting the incoming changes (recoverable only via git history).
- **`Only in $LIVE` entries (data-loss risk):** auto-backup live to `sync-logs/conv-NNN-live-backup-TS/`, then ask A/B/C — copy live-only into mirror / proceed and lose them / inspect log first.

Pre-sync forensics (full `diff -rq`, live's most-recent mtime, breakdown counts) always log to `~/.claude/projects/<slug>/sync-logs/conv-NNN-presync-TS.txt` AND display inline (one-line summary + per-file detail).

**Why:** Conv 155 introduced data-loss-only halt after the first cross-machine /r-start (M4 → M4Pro) ran with no audit trail and the user couldn't see what was different. Conv 156 ran the same skill against incoming Conv 155 changes (M4Pro → M4) and the user noticed the diff was logged but only a count printed to stdout — the inline display gap meant non-data-loss diffs were applied silently with no user checkpoint. The user generalized the rule: "always interrupt on any unexpected diff, not just data-loss." Inline display and always-pause behavior together let the user catch and resolve any unexpected memory state before destructive `rsync --delete` runs.

**How to apply:**
- Rule lives in skill code (`/r-start` Step 5.7), not memory. Two-phase split (Phase 1 forensics + halt, Phase 2 rsync + cap check) is the structural encoding.
- The halt fires on **any** non-empty diff. `Files X and Y differ` entries DO trigger the yes/no halt (this differs from the Conv 155 design where they bypassed the halt).
- The reverse direction (live → mirror in `/r-commit` Step 1.5 and `/r-end` Step 5b) does NOT need the same guard, because `/r-start` always runs first in any conv — so live ⊇ mirror by the time those direction-reversed syncs run.
- Sync logs live under `~/.claude/projects/<slug>/sync-logs/` — local-only (git history is the cross-machine forensic trail; these logs are this machine's local history). Don't commit them.
- The precise data-loss risk window is "first /r-start on a machine where mirror exists but local live wasn't last sourced from mirror." After one successful /r-end on this machine, mirror reflects this machine's live, so subsequent /r-start `Only in $LIVE` halts can only fire if local out-of-band edits happened (per `user_hands_off_pilot_workflow.md`, this should not occur — but the auto-backup + A/B/C is preserved as defense in depth).
