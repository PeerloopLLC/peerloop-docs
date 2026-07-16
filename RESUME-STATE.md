# State — Conv 395 (2026-07-16 ~14:05)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 395 was an **infra/tooling conv** (`Block: (misc)`) — no product work, code repo CLEAN throughout. It shipped **[CHATSEP]** (the user's standing complaint: "I never look at the tooling output and have to sift through them looking for the text meant for me") and **[CBG]** (the commit-time branch guard), plus captured **[MOUSE-GUARD]** and fixed the inert `Write(...)` permission rules that opened the conv. Both deliverables landed somewhere other than where the plan pointed: [CHATSEP]'s headline lever `/focus` was **rejected on testing**, and [CBG]'s obvious implementation was **verified to be a permanent no-op** before it got built.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. New this conv: **[RSYNC-GATE]** and **[SCRATCH-DEBRIS]**; **[RSFD]** tagged `[Opus]`.

- **[CHATSEP] — the answer is `verbose: false`, and `/focus` is permanently off the table.** `/focus` works well (a whole turn's tools → one line) but **requires the fullscreen renderer, whose alternate screen buffer destroys native terminal scrollback by design**. The user declared that a **deal-breaker**, so `tui` stays `"default"`. The winner was a one-line change that sat untested most of the conv (masked because fullscreen was adopted immediately after it was set): `verbose: false` collapses tool output to `ctrl+o to expand` stubs, live without a restart, scrollback intact. It lives in **project** `.claude/settings.json` (git-tracked → reaches MacMiniM4); **global `~/.claude/settings.json` was restored byte-identical** to `~/.claude/settings.json.bak-conv395-20260716-120152`. Full detail + the rejected paths: `memory/feedback_chat_vs_tooling_output_separation.md`. **Do not re-propose `/focus`, fullscreen, or a two-pane tailer.**

- **`.claude/scripts/chat-replay.sh` is new** — renders conversation-only (`▸ YOU`/`▸ CLAUDE`) from the session JSONL; the user runs `chat-replay.sh -f` in their own VS Code terminal. It depends on an **internal, undocumented** JSONL format, so it carries a **loud schema guard**: on a CC upgrade it reports drift + prints diagnostic `jq` rather than silently rendering nothing. Gotcha for anyone repairing it: **user messages are plain STRINGS, not text blocks** (`.message.content|type=="string"`); skill `!` backtick context is `isMeta==true`; subagents are `isSidechain==true`.

- **[CBG] is live and already ran for real** — this conv's own `/r-end` Step 0.7 returned `MATCH (jfg-dev-14)`. `/r-start` Step 4 writes `.conv-branch` (ephemeral, gitignored, sibling of `.conv-current`); `/r-commit` Step 0.5 + `/r-end` Step 0.7 **HALT + ask** on mismatch; `/r-end` Step 8 removes it. **Critical to know:** `conv-branch-check.sh` ([RSTART-DIFFGATE]) **cannot** be reused at commit time — it reads `RESUME-STATE.md`, which `/r-start` Step 7.6 deletes, so mid-conv it returns `NO-RESUME-STATE` and would green-light every commit. That trap is documented in `conv-branch-guard.sh`'s header.

- **[RSYNC-GATE] will bite again.** `/r-start` Step 5.7 Phase 2's `rsync --delete` (mirror→live) is structurally shaped to trip the auto-mode classifier and **will be denied every conv**. Conv 395 was safe (0-change diff → provable no-op → verified out-of-band and skipped). On a conv where the mirror genuinely differs, **handle it deliberately** — don't force it, don't skip it blindly. The live→mirror direction (`/r-commit` 1.5, `/r-end` 5b) is not affected.

- **🟠 [MEM-PRUNE] priority changed.** This conv's two new memories took MEMORY.md 77% → **79%** of the 25 KB SessionStart auto-load cap. One line from tripping the 80% `/r-start` alert — the next memory anyone writes trips it. Was hygiene; now effectively live.

- **Deferred by the user, deliberately:** (1) the `!` backtick trim — `/r-start` renders ~126 KB, **44%** of transcript bytes, mostly every `plan/*/README.md`; rated *secondary* ("r-start could be trimmed, but after it finishes is where I need the tool output removed"). Note it does **not** violate CLAUDE.md §Skills-Preserve-Determinism: *printing less* ≠ *replacing backticks with tool calls*. (2) **CC's own prose length** — with tool noise gone it is now the dominant on-screen content (median ~450 B, spikes 2–3 KB). A byte-ceiling rule is the same class as the **retired QLINT Stop-hook** — prefer structural prevention.

- **[RSFD] is blocked on an architectural decision, not effort:** does Peerloop want an **event-log capture system**? `/r-start-from-dirty` doesn't port (3 missing deps; `event.js`/`.conv-events.jsonl` don't exist here at all), and its Step 6 retro-fire — which its own Rules call "the whole point" — depends entirely on one. Without that decision a port just increments a counter over a dirty tree.

- **Docs repo committed this conv:** `1261009` (start heartbeat), `773eccb` ([CHATSEP]), `8aaf040` ([CBG]), + this end-of-conv commit. **Code repo: no Conv 395 commits** — untouched, on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
