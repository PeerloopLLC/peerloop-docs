---
name: r-start
description: Start a new conversation — check repos clean, pull both, increment conv, push, rule any carried findings + report hopper leftovers, then resume
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Start Conversation

**Purpose:** Verify both repos are clean, sync from remote, increment the conversation counter, push the new counter, then present resumption context. This is the **only** entry point for all conversations — both cold starts and warm restarts after `/r-end` → `/clear`.

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current CONV-COUNTER value (before increment):**
!`~/projects/peerloop-docs/.claude/scripts/conv-read-counter.sh`

**Existing .conv-current:**
!`test -f .conv-current && echo "WARNING: .conv-current already exists (value: $(cat .conv-current)) — a previous session may not have ended cleanly" || echo "(none — clean state)"`

**Concurrent session check:**
!`~/projects/peerloop-docs/.claude/scripts/conv-session-lock.sh check`

**Repo status:**
!`~/projects/peerloop-docs/.claude/scripts/dual-repo-status.sh`

**Dependency sync check (code repo):**
!`bash -c 'LOCK=~/projects/Peerloop/package-lock.json; HASH_FILE=~/projects/Peerloop/node_modules/.package-lock-hash; if [ ! -d ~/projects/Peerloop/node_modules ]; then echo "DRIFT: node_modules missing"; elif [ ! -f "$HASH_FILE" ]; then echo "DRIFT: hash file missing"; elif [ "$(shasum -a 256 "$LOCK" 2>/dev/null | cut -d" " -f1)" != "$(cat "$HASH_FILE" 2>/dev/null)" ]; then echo "DRIFT: package-lock.json changed"; else echo "OK"; fi'`

**Code-branch check (code repo vs RESUME-STATE):**
!`~/projects/peerloop-docs/.claude/scripts/conv-branch-check.sh`

**Leftover quiet-mode log:**
!`test -f ~/projects/peerloop-docs/.scratch/quiet-mode-log.md && echo "PRESENT — unclean exit during quiet mode (see Step 5.8)" || echo "(none)"`

---

## Paths

- Docs repo: `git -C ~/projects/peerloop-docs ...`
- Code repo: `git -C ~/projects/Peerloop ...`

---

## Execution Flow

### Step 0: Concurrent-session guard

Use the pre-computed **Concurrent session check** line above. It reports the state of the machine-local session lock (`~/.claude/projects/<slug>/active-session.lock`), distinguishing an *active concurrent session* from a *stale crashed one* by testing whether the lock's `claude` PID is still alive and is **not** this session's own process. This is the structural fix for the Conv 293 incident: running `/r-start` in a second terminal while another session is live double-increments the counter, races the push, and clobbers the memory sync.

Branch on the verdict:

- **`CLEAR`** (or `CLEAR|own-session` / `CLEAR|own-process` — the lock is ours, e.g. a re-run after `/r-end` → `/clear`) → no other session is active. **Acquire the lock, then continue to Step 1:**

  ```bash
  ~/projects/peerloop-docs/.claude/scripts/conv-session-lock.sh acquire $(printf "%03d" $(( $(cat ~/projects/peerloop-docs/CONV-COUNTER) + 1 )))
  ```

- **`ACTIVE|sid=…|pid=…|conv=…|machine=…|started=…`** → another `/r-start` session is already live on this machine. **HALT immediately — do NOT acquire, pull, increment, push, or sync.** Display and stop:

  ```
  ⛔ Another Peerloop session is already active on this machine.
       Conv {conv} · pid {pid} · started {started}

     Running /r-start here would trample it (double counter-increment,
     competing pushes — the Conv 293 failure).

     → Switch to that terminal, or close it / let it finish /r-end, then
       run /r-start here again. If that session truly crashed, the next
       run will read STALE and offer to reclaim the lock.
  ```

  This HALT is the entire purpose of the guard — never proceed past it.

- **`STALE|sid=…|pid=…|conv=…|machine=…|started=…`** → a prior session left a lock but its `claude` process is gone (crash or kill without `/r-end`). Surface and ask before reclaiming:

  ```
  ⚠️  Stale session lock: Conv {conv} · pid {pid} (dead) · started {started}.
  ```
  ```
  👉👉👉 **Reclaim it and proceed? (yes / no)**
  ```

  - On **yes** → acquire (overwrites the stale lock), then continue to Step 1:
    ```bash
    ~/projects/peerloop-docs/.claude/scripts/conv-session-lock.sh acquire $(printf "%03d" $(( $(cat ~/projects/peerloop-docs/CONV-COUNTER) + 1 )))
    ```
  - On **no** → **HALT** (leave the lock in place for the user to resolve).

**HALT for the answer on `STALE`; HALT unconditionally on `ACTIVE`.** Only a `CLEAR` (or reclaimed `STALE`) acquires the lock and proceeds to Step 1. The lock is released by `/r-end` (and self-heals on the next start if a session ever dies without releasing).

### Step 1: Check both repos for uncommitted changes

Use the pre-computed repo status above. If **either** repo shows DIRTY:

```
⚠️  Uncommitted changes detected — cannot start cleanly.

Docs repo:
[status output]

Code repo:
[status output]

Options:
1. Commit changes first (run /r-commit)
2. Stash changes and proceed
3. Discard changes (destructive!)
```

**HALT** and wait for user decision. Do not proceed with dirty repos.

### Step 2: Pull both repos

```bash
git -C ~/projects/peerloop-docs pull --ff-only
git -C ~/projects/Peerloop pull --ff-only
```

If either pull fails (diverged branches, network error), **HALT** and tell the user. Do not proceed — the conv counter will be out of sync.

### Step 2.5: Detect self-update of this skill

The SKILL.md body Claude is executing was rendered **at invocation time** — a pre-pull snapshot. Step 2's pull can bring in a **newer version of this very skill** (skills self-update across machines), so the rendered body may be missing or have changed steps. Check whether the pull touched this file:

```bash
SKILL=.claude/skills/r-start/SKILL.md
if git -C ~/projects/peerloop-docs diff --name-only 'HEAD@{1}' HEAD -- "$SKILL" 2>/dev/null | grep -q .; then
  echo "⚠️  r-start SKILL.md changed in the Step 2 pull — the in-context body is STALE."
else
  echo "✅ r-start SKILL.md unchanged by pull — in-context body is current."
fi
```

**If it prints the `⚠️` line, STOP and `Read` `.claude/skills/r-start/SKILL.md` in full before executing Steps 3+.** Execute from the freshly-read on-disk version, not the invocation-time echo — otherwise newly-added steps (e.g. Step 7.5 was added Conv 215 and silently skipped in Conv 218 for exactly this reason) get dropped. (`HEAD@{1}` = the pre-pull position after Step 2's ff-only pull; harmless no-op if the pull changed nothing else.) See `docs/reference/memory-archive/feedback_skill_body_stale_after_self_pull.md`.

### Step 3: Read and increment the counter

Read `CONV-COUNTER`. It contains a single integer (e.g. `3`).

Compute the next value: current + 1.

Format as zero-padded 3-digit string (e.g. `004`).

### Step 4: Write the new counter and lock it

Write the new integer (unpadded) to `CONV-COUNTER`:

```bash
echo {NEW_VALUE} > CONV-COUNTER
```

Write the zero-padded value to `.conv-current`:

```bash
echo {PADDED_VALUE} > .conv-current
```

**Also record the code branch** for the commit-time guard ([CBG], Conv 395). `.conv-branch` is an ephemeral, gitignored, conv-scoped sibling of `.conv-current` — written here, verified by `/r-commit` + `/r-end`, removed by `/r-end` Step 8:

```bash
git -C ~/projects/Peerloop branch --show-current > ~/projects/peerloop-docs/.conv-branch
```

Write it **now** (pre-Step-5.6) so the file exists even if the branch gate later finds a mismatch; Step 5.6 **rewrites** it if you accept a checkout, so it always holds the branch this conv actually settled on. (Detached HEAD writes an empty file — the guard reads that as `NO-CONV-BRANCH` and stays advisory, which is correct: there's no branch to protect.)

### Step 5: Commit and push the counter

```bash
git -C ~/projects/peerloop-docs add CONV-COUNTER
git -C ~/projects/peerloop-docs commit -m "Conv {PADDED_VALUE} start — {MACHINE}"
git -C ~/projects/peerloop-docs push
```

If the push fails, **HALT** and tell the user. The counter increment is not synced until pushed.

### Step 5.5: Sync dependencies (code repo)

Check the pre-computed **Dependency sync check** line above.

- If it reports `OK` → skip silently.
- If it reports `DRIFT: ...` → **prompt the user** before running anything:

  ```
  📦 Dependency drift detected in ../Peerloop: {reason}
     Proposed: cd ../Peerloop && npm ci

  👉👉👉 Run `npm ci` now? (yes / skip)
  ```

  - On **yes**: run `cd ~/projects/Peerloop && npm ci` and show a compact summary (last ~10 lines of output).
  - On **skip**: note it and continue; user is responsible for running it later.

**Why `npm ci` (not `npm install`):** /r-start is always the *consumer* side of a dependency change — Step 2 just pulled someone else's committed lockfile. `npm ci` reproduces `node_modules` exactly from `package-lock.json`, **never rewrites the lockfile** (so it can't churn a spurious diff back to the other machine), and errors loudly if `package.json` and the lock disagree. The project's `postinstall` hook (`shasum … > node_modules/.package-lock-hash`) runs after `ci` too, regenerating the drift sentinel so the next /r-start reads `OK`. Everything `ci` touches — `node_modules/` and the hash file — is gitignored, so there is nothing to commit. (Reserve `npm install <pkg>@ver` for *authoring* a dependency change, which /r-start never does.)

**Do NOT auto-run without approval** — visible, approved actions are preferred over silent side effects (see CLAUDE.md §Skills: Preserve `!` Backtick Determinism).

### Step 5.6: Code-branch match gate ([RSTART-DIFFGATE])

Check the pre-computed **Code-branch check** line above. It compares the code repo's checked-out branch against the `**Branch:** code:` line in the previous conv's RESUME-STATE.md and classifies whether a checkout to the recorded branch would be safe. This closes the cross-machine **stale-checkout hazard** discovered in Conv 297: MacMiniM4 sat on `jfg-dev-13-matt` (Conv 291 tip) while `jfg-dev-14` carried PALETTE-FDN and all of Conv 292/295/296. The branch name *was* printed by the SessionStart hook, but nothing cross-checked it against RESUME-STATE — so the first symptom was a colour-token lookup silently failing mid-sweep. The verdict logic + safety classifier live in `.claude/scripts/conv-branch-check.sh` (calibration cases, including this canonical incident, are in that script's header).

Branch on the verdict:

- **`MATCH (...)`** → code repo is on the expected branch. Skip silently.
- **`NO-RESUME-STATE ...`** / **`NO-BRANCH-LINE ...`** → no recorded branch to compare against (cold start, or an older RESUME-STATE format). Skip silently.
- **`DETACHED ...`** → detached HEAD. Surface a one-line warning (`⚠️ Code repo is in detached HEAD; expected branch \`{want}\`.`) and continue — do not auto-fix.
- **`MISMATCH-NOREF live={L} want={W}`** → on the wrong branch AND `{W}` exists neither locally nor on origin. Warn and continue; the user must fetch/create it before code work:
  ```
  ⚠️  Code repo is on `{L}`, but RESUME-STATE expected `{W}` — and `{W}` was not
      found locally or on origin. Resolve manually (fetch / create the branch)
      before doing code work.
  ```
- **`MISMATCH ... SAFE`** → wrong branch, but a checkout is zero-risk (clean tree, current branch **0 commits ahead** of the target — every local commit is already contained in it). Surface the gap and **offer the checkout** via `AskUserQuestion` (prose above the picker: ``Code repo is on `{L}` but the previous conv worked on `{W}` ({behind} behind, 0 ahead, clean — nothing at risk). Recommend checking out `{W}` before any code work.``; options **Checkout `{W}` (Recommended)** / **Stay on `{L}`**).
  - On checkout → run `git -C ~/projects/Peerloop checkout {W}`, confirm the new HEAD, then **re-record `.conv-branch`** so the [CBG] commit-time guard protects the branch you just moved to, not the stale one:
    ```bash
    git -C ~/projects/Peerloop branch --show-current > ~/projects/peerloop-docs/.conv-branch
    ```
    The stale branch is **kept** (checkout never deletes it — see `docs/reference/memory-archive/project_jfg_dev_branches_are_snapshots.md`).
  - On stay → note it and continue; downstream code work uses the current branch at the user's risk.
- **`MISMATCH ... UNSAFE-DIRTY`** / **`UNSAFE-AHEAD(n)`** → wrong branch, but an auto-checkout could lose work (uncommitted changes, or `n` commits unique to the current branch). **Do NOT offer auto-checkout.** Surface and let the user resolve:
  ```
  ⚠️  Code repo is on `{L}`, RESUME-STATE expected `{W}` — but a checkout is NOT
      safe ({uncommitted changes / {n} commits ahead of {W}}). Commit, stash, or
      reconcile manually before switching. Not auto-fixing.
  ```

This gate is **informational/corrective** — it never blocks the counter increment (already done in Step 5; branch-independent) nor the rest of /r-start. Its job is to get the code repo onto the right branch **before Step 8's Recommended Action** points at code work.

### Step 5.8: Leftover quiet-mode log

Check the **Leftover quiet-mode log** pre-computed line. If it reports `(none)`, skip silently.

If it reports `PRESENT`, a prior conv exited uncleanly while `/r-quiet-mode` was ON (a crash or raw `/clear` before `/r-quiet-mode off`). The log at `~/projects/peerloop-docs/.scratch/quiet-mode-log.md` holds deferred work and observations that were never processed. **Do not delete it silently** — surface and ask (mirrors how this skill treats stale `RESUME-STATE`/`.conv-current`):

1. `Read` the log file fully.
2. Display its origin (conv + start timestamp from the header) and a digest of each non-empty section.
3. Ask:
   ```
   ⚠️  Leftover quiet-mode log from Conv {N} (unclean exit). It has unprocessed deferred work.

   A) Process it now — run the same off-processing (raise issues, run deferred processes,
      log followups into CURRENT-TASKS.md), then delete the log
   B) Discard it — delete without processing (its contents are lost)
   C) Keep it for now — leave the log in place and decide later

   👉👉👉 **Which — A, B, or C?**
   ```
4. On **A**: perform the `/r-quiet-mode off` Turn-OFF processing (digest → execute deferred → `rm` the log). On **B**: `rm` the log. On **C**: leave it (note that `/r-end` will stay blocked until it is resolved).

**HALT for the answer** before continuing to Step 6 — but only when `PRESENT`. This is the one quiet-mode checkpoint in `/r-start`.

### Step 6: Display conversation header

```
╔═══════════════════════════════════╗
║  Conv {PADDED_VALUE}  ·  {MACHINE}  ║
╚═══════════════════════════════════╝
```

### Step 7: The task board is the write-through file (no Task-tool overlay — [TASK-TOOLS-DETACH], Conv 406)

**Write-through, no tools ([CURTASKS] Conv 351; Task-tool detach Conv 406).** `CURRENT-TASKS.md` (root of `peerloop-docs`, git-tracked) **is** the task state — there is no `TodoWrite`/`TaskList` overlay to hydrate. The Task subsystem is server-gated OFF for this model (see `[TASK-TOOLS-VERIFY]`), so CC **edits `CURRENT-TASKS.md` directly** as tasks change. `/r-start` does not touch the board here beyond the Step 7.5 reset — it just reads it for the Step 8 resume display.

**How tasks change during the conv (write-through):**
- **Start a task:** flip its body's `- **State:**` bullet to `🔄 active`; if it wasn't already near the top of `## 🎯 Now`, move its TOC line up. The `### [CODE]` body itself never moves (it lives alphabetically under `## Tasks`).
- **Discover a new task:** add a `### [CODE]` body under `## Tasks` (alphabetical position) **and** a line in `## 🎯 Now` (or `## ⏸️ Parked` if gated). Use a unique bracketed `[CODE]` (`docs/reference/memory-archive/feedback_todowrite_mnemonic_codes.md`).
- **Park / gate:** move its line from `## 🎯 Now` to `## ⏸️ Parked` and set `State: ⏸️ parked · gate: …`.
- **Complete:** delete the body from `## Tasks`, remove its `## 🎯 Now` line, add a one-liner to `## ✅ Done this conv`.

Edit safely per `[EDITSAFE]` — unique anchors, no serializer round-trips, no ambiguous markers on this file.

Display:

```
📋 Task board: CURRENT-TASKS.md — {A} active · {Q} queued · {W} watch · {P} parked ({N} total).
   Write-through: edit the file directly as tasks change (Task tools are server-gated off).
```

(`{N}` = `### [CODE]` body count; `{A}/{Q}/{W}/{P}` from the pre-computed consistency probe / a quick scan of the `State:` bullets. If the numbers aren't cheaply to hand, just show `{N} total`.)

**Crash recovery is trivial.** `CURRENT-TASKS.md` is git-tracked and re-tidied at every `/r-commit` + `/r-end`; a crash loses nothing beyond uncommitted edits. Re-reading the file IS the recovery.

**Pre-cutover fallback** (transitional): if `CURRENT-TASKS.md` does **not** exist but `RESUME-STATE.md` has a legacy `## Remaining` section with unchecked `- [ ]` items, bootstrap the board from them — create a `### [CODE]` body + `## 🎯 Now` line for each (reuse an existing `[CODE]` or assign one mnemonically). Normal post-cutover convs skip this silently.

### Step 7.5: Reset `## ✅ Done this conv` in CURRENT-TASKS.md

`CURRENT-TASKS.md`'s `## ✅ Done this conv` block is filled during a conv (and at `/r-commit` / `/r-end`) with **that** conv's completions. At the start of a fresh conv it therefore still lists the **previous** conv's items under a header claiming "this conv" — a perennial mislabel. The prior conv's completions are already preserved elsewhere (`docs/sessions/` + git history), so clearing the block here loses nothing and makes the header truthful: empty at fresh-conv start, refilled as tasks close.

Reset it to the empty placeholder (Done is the final section of the file, so print through its header then stop):

```bash
CT=~/projects/peerloop-docs/CURRENT-TASKS.md
if test -f "$CT" && grep -q '^## ✅ Done this conv' "$CT"; then
  awk '
    /^## ✅ Done this conv/ { print; print ""; print "_(none yet — cleared at each /r-start)_"; exit }
    { print }
  ' "$CT" > "$CT.tmp" && mv "$CT.tmp" "$CT"
  echo "🧹 Reset CURRENT-TASKS.md ✅ Done-this-conv block (cleared last conv's completions)."
fi
```

Idempotent — re-running on an already-reset block reproduces the placeholder. If `CURRENT-TASKS.md` has no `## ✅ Done this conv` section (or doesn't exist — pre-cutover), the file is unchanged and no message prints. This is a working-tree edit committed at the next `/r-commit` or `/r-end` — **not** part of the Step 5 conv-start commit.

**Retired here:** the `.scratch/conv-tasks.md` companion + its no-shrink reconciliation guard. The persistent, git-tracked `CURRENT-TASKS.md` (surfaced in the Step 8 pre-computed block and rendered in the resume display) is the single readable task surface. The conv-turns log seeded in Step 7.7 is a separate file and is unaffected.

### Step 7.6: Keep RESUME-STATE.md (do NOT delete — Conv 457)

🔴 **`RESUME-STATE.md` is KEPT, not deleted.** (Changed Conv 457 with the hopper/carried-findings port — before that, `/r-start` deleted it here.) Reading it at Step 8 consumes its *summary*, not its detail — the file stays on disk and readable for the whole conv, because the thing you need from it is usually noticed hours after the resume display, and Step 8's two-or-three sentences are deliberately not a substitute. **Only `/r-end` Step 5 overwrites it**, at the close.

It holds Summary / Key Context / **Branch** (no task data — task state lives in `CURRENT-TASKS.md`) **plus a `## 🔬 Carried findings` section** — findings the previous `/r-end` surfaced during its own close and could not act on. Those are ruled at **Step 7.8** below. Do not delete or edit the file here beyond that ruling's in-place annotation.

(This is spt's rule, learned the expensive way: deleting-the-file-on-read for ~300 convs also pinned a stale-conv check permanently false, because the condition was evaluated downstream of the step that guaranteed its answer.)

### Step 7.7: Seed the conversation turn log

Seed a **fresh** `.scratch/conv-turns.md` for this conv — the re-orientation companion the user keeps open in VS Code (CLAUDE.md § "Conversation Turn Log"). It is **conv-scoped**, so it starts clean each conv and is **overwritten** here (the prior conv's turns are preserved in that conv's chat/Extract, not carried forward).

Write the header + a first entry for this `/r-start` run (newest-first ordering — the latest turn goes at the top as the conv grows):

```markdown
# Conversation Turns — re-orientation log

> **CC-maintained, live-sync.** Stable filename — keep this tab open in VS Code.
> One entry per turn, **newest first** (latest at the top). Each entry: your question **in full** (verbatim) + my **terse** reply.
> **A:** `▸ chose "X"` = you selected an `AskUserQuestion` option; otherwise an extremely terse summary of my answer. Only the answer is terse — the question is kept whole.
> Trivial confirmations (bare yes/no) are folded into the decision they answered rather than given their own entry.

**Conv {PADDED_VALUE} · {MACHINE}**

---

## Turn 1
**Q:** /r-start
**A:** {one-line terse summary of this /r-start run — counter increment + push, CURRENT-TASKS.md task board surfaced, any carried findings ruled / hopper leftovers reported, and the recommended-action question asked at the end}
```

Thereafter, **at the end of every turn**, prepend a new `## Turn N` entry per the CLAUDE.md rule (question in full, reply terse). Note it in one line:

```
🌀 Seeded .scratch/conv-turns.md — turn-by-turn Q/A re-orientation log (keep open in VS Code).
```

### Step 7.8: Rule carried findings + report hopper leftovers (Conv 457 — interior stop, only if present)

Two independent inputs, both from *unclean or deferred* prior state. Handle whichever is present; if **both** are empty, say so in one line and go to Step 8. When either is present, this is an **interior stop** — rule/report it, then proceed to Step 8's recommended action (a separate turn is fine).

**A) Carried findings** — read `RESUME-STATE.md`'s `## 🔬 Carried findings` section. These arose *during the previous `/r-end`* and were deliberately not acted on then. **This is where they are meant to be ruled.**

- For **each** unruled `- [ ]` bullet, one at a time (§User-Facing Questions — show the finding + what a ruling would decide, then A/B/C): **A) promote** to a `CURRENT-TASKS.md` row · **B) do it now** · **C) drop it**. Same criterion as the hopper: *a new task has to earn its place — significant work, or multi-conv.* 🔴 **Never rule alone.**
- ⚠️ **Re-verify before ruling a `(re-carried from Conv NNN)` finding** — re-carrying preserved the question, not its premises.
- 🔴 **Annotate each bullet in place as it is ruled** — prefix it `✔ **ruled:** <disposition>` (`promoted to [CODE]` · `done now` · `dropped`). This is the only write `/r-start` makes to that file; the bullet text stays, so the file stays readable all conv. **The marker is load-bearing:** `/r-end` Step 5 re-carries every bullet that *lacks* it — skip the annotation and a ruled finding gets re-carried as noise.
- Section says `_None._` or is absent → say so in one line.

**B) Hopper leftovers** — read `HOPPER.md`'s `## Open`. Do **not** hydrate it from the board; it is for spin-offs found *during* a conv, and `/r-end`'s Step 0.8 gate blocks any close that leaves open items.

- 🔴 **So open items here mean the previous conv did not close cleanly** — a session died, or `/r-end` was never run. They are not this conv's findings and were never ruled. **Report them; do not absorb them silently.** Ask whether to deal with them now (`/r-hopper`) or leave them for this conv's `/r-end` (which will then bounce until they are ruled). Under a per-session hopper this state was unreachable — the file made it visible.
- No open items → say so in one line.

### Step 8: Resume work context (inline)

Present the current work position and recommended next action. This step uses pre-computed context and PLAN.md analysis — no external skill call.

#### Pre-computed Resume Context

**PLAN.md exists:**
!`test -f PLAN.md && echo "yes" || echo "NO — PLAN.md not found, cannot resume"`

**Current status header:**
!`~/projects/peerloop-docs/.claude/scripts/plan-status-header.sh`

**Active/WIP blocks:**
!`~/projects/peerloop-docs/.claude/scripts/plan-wip-markers.sh`

**Migrated block READMEs (plan/*/README.md):**
!`for readme in ~/projects/peerloop-docs/plan/*/README.md; do test -f "$readme" || continue; echo "=== $(basename $(dirname "$readme"))/README.md ==="; head -40 "$readme"; echo; done`

**Open questions:**
!`~/projects/peerloop-docs/.claude/scripts/plan-open-questions.sh`

**Active conv (.conv-current):**
!`test -f .conv-current && echo "$(cat .conv-current)" || echo "(none)"`

**Hopper open items (Step 7.8-B input — non-empty means the prior conv didn't close cleanly):**
!`awk '/^## /{o=($0=="## Open")} o&&/^- \[ \]/' ~/projects/peerloop-docs/HOPPER.md 2>/dev/null | grep . || echo "(clear)"`

**Carried findings in RESUME-STATE.md (Step 7.8-A input — unruled `- [ ]` bullets to rule):**
!`awk '/^## /{c=($0=="## 🔬 Carried findings")} c&&/^- \[ \]/' ~/projects/peerloop-docs/RESUME-STATE.md 2>/dev/null | grep . || echo "(none)"`

**RESUME-STATE.md (narrative handoff — Summary / Key Context / Branch):**
!`cat RESUME-STATE.md 2>/dev/null || echo "(no resume state file)"`

**CURRENT-TASKS.md (persistent task state — Ordered sequence + backlog + Parked):**
!`cat ~/projects/peerloop-docs/CURRENT-TASKS.md 2>/dev/null || echo "(no CURRENT-TASKS.md — pre-cutover or missing)"`

#### Conv State Checks

Before presenting the resume context, evaluate these conditions and display warnings if triggered:

**No active conv:** If `.conv-current` is `(none)`, display:

```
⚠️  No active conv — run /r-start for tracked work, or continue untracked.
```

This is a soft warning — do not block.

**Stale context (raw /clear detected):** Since Conv 457 `RESUME-STATE.md` is **kept** across the conv (Step 7.6), so its presence — reflecting the *previous* conv — is normal, not a signal. The anomaly is now the opposite: `RESUME-STATE.md` **missing** while `.conv-current` exists. The prior `/r-end` Step 5 always writes it and `/r-start` no longer deletes it, so an absent file means the previous conv never closed via `/r-end` (a raw `/clear` or a crash). Fire only on that: `.conv-current` exists **and** `RESUME-STATE.md` is absent.

First, check if this is a fresh start. Look at the most recent git commit message in the docs repo:

```bash
git log -1 --format=%s
```

If the message matches `Conv {NNN} start —` (where `{NNN}` matches `.conv-current`), this is a **fresh conv** just created by Step 5 (or the very first cold start, before any `/r-end` has written a handoff) — suppress the warning silently.

Otherwise, display:

```
⚠️  Active conv {NNN} but RESUME-STATE.md is missing.
    A raw /clear may have been run without /r-end.
    Work from the previous conv may not have been captured.
```

This is a soft warning — do not block.

#### Multi-Block / All-Done handling — RETIRED (Conv 457)

> Two legacy procedures lived here: a **Multi-Block Consolidation** (merging multiple `# State — Conv` blocks in one RESUME-STATE) and an **All-Done Cleanup** (deleting a RESUME-STATE whose `## Remaining` items were all checked). **Both are dead under the Conv-457 model** and were removed: `/r-end` writes a single narrative block, `/r-start` **keeps** RESUME-STATE (never deletes it — Step 7.6), and task state lives in `CURRENT-TASKS.md` (RESUME-STATE has no `## Remaining` checklist), so neither can trigger. If a pre-cutover RESUME-STATE with multiple blocks or a `## Remaining` list ever surfaces, treat it as history — read the newest narrative and do **not** delete the file.

#### Present Context

Read PLAN.md fully if the pre-computed context above is insufficient to identify:
- Current WIP block (🔥 or IN PROGRESS marker)
- Latest completed block
- Next planned block
- Subtask checklist status

**Hybrid plan-file mode:** Some blocks have their detail migrated to `plan/<block-slug>/`. The ACTIVE-table row in PLAN.md ends with `→ [plan/<slug>/README.md](plan/<slug>/README.md)` for those blocks. For any ACTIVE block that has a `→ [plan/...]` link AND is the identified WIP, read the linked file (or its specific phase file) for current focus + subtask checklist. Non-migrated blocks read inline from PLAN.md as today.

**Task sequence comes from `CURRENT-TASKS.md` ([CURTASKS] Conv 351; Task-tool detach Conv 406).** The pre-computed `CURRENT-TASKS.md` surface is the authoritative forward-looking task state: the **`## 🎯 Now`** TOC is the execution sequence (**top = next**), the **`## ⏸️ Parked`** TOC is out of rotation (each with its gate), and the `### [CODE]` bodies under `## Tasks` hold the detail. Drive the **🎯 Recommended Action** from the **top `## 🎯 Now` entry whose body `State:` is not blocked** (or the PLAN.md WIP block if a block is mid-flight). `RESUME-STATE.md`'s narrative (Summary / Key Context) supplies the *why* + any blockers — fold it into **💡 Quick Context**. The `📍 Current Position` block reads its WIP / last / next **block** framing from PLAN.md (block-level WHAT); the per-task **⏭️ Remaining** list reflects `CURRENT-TASKS.md § 🎯 Now`. `[TASK-CODE]` in the final question is that top actionable `## 🎯 Now` entry's `[CODE]`.

Present in this format:

```
📍 Current Position
─────────────────

🔥 WIP: BLOCKNAME - [Block Name]
   Progress: [X] of [Y] subtasks complete ([Z]%)

   ✅ Completed:
   - [List completed subtasks]

   ⏭️  Remaining:
   - [Next immediate task with details]
   - [Subsequent tasks]

🏁 Last Completed: BLOCKNAME - [Block Name]

📋 Next Planned: BLOCKNAME - [Block Name]

🗃️  Hopper: {clear · or N open — prior conv didn't close cleanly, see Step 7.8}   Carried findings: {none · or N to rule}

─────────────────
💡 Quick Context

[1-2 sentence summary of what this block accomplishes and why it matters]

─────────────────
🎯 Recommended Action

[Specific, actionable next step based on current WIP.
 Include file paths and commands when relevant.]

**Start [TASK-CODE] now? (yes / no)**
```

**Resume rules:**
- Focus on the **next actionable step**, not high-level strategy
- Include **specific file paths** and commands when relevant
- Highlight **blockers** that need resolution before continuing
- Keep context brief but sufficient to resume without reading entire PLAN.md
- The forward-looking **task sequence** comes from `CURRENT-TASKS.md § 🎯 Now` (top = next); `RESUME-STATE.md` supplies **narrative context only** (post-cutover it no longer holds task data)
- Incorporate `RESUME-STATE.md`'s narrative context (Summary / Key Context). (Multi-block consolidation was retired Conv 457 — `/r-end` writes a single block; a stray pre-cutover multi-block file is just read as history.)
- **Recommended Action MUST be the last section** — it ends with a bold Yes/No question (`**Start [TASK-CODE] now? (yes / no)**`) on its own line so the user knows Claude is waiting for input. HALT after asking. Do not begin work until the user answers.

---

## Rules

- **HALT on ACTIVE session lock (Step 0)** — never acquire, pull, increment, push, or sync while another live `claude` session holds the lock. This is the structural guard against the Conv 293 double-session trample.
- **HALT on dirty repos** — never proceed with uncommitted changes
- **HALT on pull failure** — never increment without a successful pull of both repos
- **HALT on push failure** — the counter must be pushed before any work begins
- If `.conv-current` already exists, warn the user (prior session didn't run `/r-end`) but proceed — the counter in `CONV-COUNTER` (post-pull) is the source of truth
- The `CONV-COUNTER` file stores an unpadded integer; `.conv-current` stores a zero-padded 3-digit string
- Do NOT begin any project work until Steps 1–8 are complete
