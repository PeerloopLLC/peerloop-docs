---
name: MSI first-sync data-loss window
description: The one data-loss window in [MSI] cross-machine memory sync is /r-start Step 5.7's `rsync --delete` (mirror→live); pre-sync `diff -rq` log + HALT-on-`Only in $LIVE` + auto-backup closes it
type: feedback
originSessionId: 31ca911f-5d4b-49e2-8629-fcb943aa0b59
---
The only data-loss window in [MSI] cross-machine memory sync is `/r-start` Step 5.7's `rsync -a --delete` (mirror → live). Files that exist in live but not in mirror — typically new memories authored on this machine since its last `/r-end` — would be erased silently. Step 5.7 must (a) always log `diff -rq mirror vs live` and live's most-recent mtime to `~/.claude/projects/<slug>/sync-logs/conv-NNN-presync-TS.txt`, and (b) HALT before rsync if any `Only in $LIVE: ...` entries appear, auto-snapshotting live to `sync-logs/conv-NNN-live-backup-TS/`. On halt, present A/B/C: copy live-only files into mirror first / proceed and lose them / inspect log first.

**Why:** Conv 155 ran the first cross-machine /r-start (M4 → M4Pro). The pre-existing Step 5.7 went straight to `rsync --delete` with no audit trail — once it ran, M4Pro's pre-sync live state was unrecoverable. User asked "what was different between mirror and live?" and there was no answer. The fix: log + halt before any destructive action.

**How to apply:**
- The halt fires on `Only in $LIVE: ...` entries only. `Files X and Y differ` entries do NOT halt — those are normal incoming changes from the other machine and rsync overwriting them with mirror content is the whole point.
- The reverse direction (live → mirror in `/r-commit` Step 1.5 and `/r-end` Step 5b) does NOT need the same guard, because `/r-start` always runs first in any conv — so live ⊇ mirror by the time those direction-reversed syncs run.
- Sync logs live under `~/.claude/projects/<slug>/sync-logs/` — local-only (git history is the cross-machine forensic trail; these logs are this machine's local history). Don't commit them.
- A "first /r-start on a machine where mirror exists but local live wasn't last sourced from mirror" is the precise risk window. After one successful /r-end on this machine, mirror reflects this machine's live, so subsequent /r-start halts can only fire if another machine wrote new live-only files (impossible — other machines write to their own live, mirror via /r-end).
