---
name: resume-state-is-todowrite-persistence
description: RESUME-STATE.md serializes TodoWrite across convs; .scratch/conv-tasks.md is the disk-resident crash-restore source when a conv dies before /r-end
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4dffd878-c206-4f26-a72c-7a748285e4e0
---

RESUME-STATE.md is a persistence mechanism for TodoWrite tasks across conversations, not a user-facing artifact.

**Why:** The user doesn't want to think about RESUME-STATE.md separately. Outstanding items should always surface as TodoWrite tasks — one interface, not two.

**How to apply:**
- `/r-start` Step 7: Read RESUME-STATE.md → create TaskCreate entries → delete the file
- `/r-end` / `/r-save-state`: Serialize current TodoWrite pending items → write RESUME-STATE.md
- Never ask the user to "check RESUME-STATE.md" — they see tasks via TodoWrite only
- Git history preserves the state if historical lookup is needed

## Crash recovery — `.scratch/conv-tasks.md` is the restore source (Conv 219)

Because `/r-start` Step 7 **deletes** RESUME-STATE.md after transferring it into TodoWrite, and an in-memory TodoWrite does NOT survive a process restart, a conv that dies between Step 7 and `/r-end` (e.g. the recurring terminal-render garble) leaves the backlog **stranded**: TodoWrite empty, RESUME-STATE.md gone.

`.scratch/conv-tasks.md` (the `/r-start` Step 7.5 plain-language companion) is **never deleted mid-conv**, so it survives the crash on disk and is the **primary restore source**.

**Protocol on a resumed crashed conv:**
- **If resuming WITHOUT `/r-start`** (staying on the same conv, no counter bump): immediately rehydrate TodoWrite from `.scratch/conv-tasks.md` — do this FIRST, before any work. (Conv 219 failed to: the list sat empty until the user noticed 20+ tasks gone ~15 turns later.)
- **If `/r-start` IS run:** Step 7 now has a **crash-survivor branch** (RESUME-STATE absent + conv-tasks.md populated + TodoWrite empty → restore from conv-tasks.md), and Step 7.5 has a **no-shrink backstop** (never overwrite a populated conv-tasks.md with fewer/zero tasks). Hardened Conv 219.
- RESUME-STATE.md may ALSO be recoverable via `git show HEAD:RESUME-STATE.md` — but only if its delete was uncommitted. conv-tasks.md is the more reliable source.

See [[feedback_todowrite_mnemonic_codes]] — codes survive in conv-tasks.md, so restore preserves the user's shortcodes.
