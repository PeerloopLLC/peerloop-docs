# State — Conv 158 (2026-05-07 ~20:13)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 158 evaluated sub-agent dispatch for /r-timecard-day skill to test whether Sonnet and Haiku models could improve timecard synthesis quality and speed. The experiment revealed sub-agent cold-start overhead (4-20× wall-clock penalty) and permission hallucination issues in weaker models. Decision: leave the skill unchanged and test smaller models via foreground session with model override, avoiding sub-agent dispatch entirely. Timecard generated for May 6, 2026 with LLM-synthesized Block Progress bullets.

## Completed

- [x] Ran /r-timecard-day on May 6, 2026 date (output written to vault after synthesis)
- [x] Verified permission boundaries for sub-agent dispatch
- [x] Created `.timecards/` project-internal folder as workaround for vault-write permission issues

## Remaining

- [ ] [PD] Prod cron Worker deploy — block date 2026-04-28 has passed; verify prerequisites still hold when next picked up. (Opus-level: irreversible infrastructure work)
- [ ] [RSC] Pair -c with -v if MSI rsync ever gains -v for diagnostics — watch-task, fires only on a specific edit to production rsync invocations
- [ ] [TC-SONNET-FG] Foreground test of r-timecard-day with Sonnet 4.6 — run `claude --model claude-sonnet-4-6 --add-dir ../Peerloop` in fresh terminal
- [ ] [TC-HAIKU-FG] Foreground test of r-timecard-day with Haiku 4.5 — run `claude --model claude-haiku-4-5-20251001 --add-dir ../Peerloop` in fresh terminal
- [ ] [TC-PARAM-OUTPATH] Design timecard script output-path parameter — enable caller-controlled routing for sub-agent output targets
- [ ] [TC-GLIDE-DOC] Document Block-summary adoption status in /r-timecard-day SKILL.md — help future readers understand the LLM synthesis glide path

## Key Context

**Sub-Agent Dispatch Findings:**
- Wall-clock penalty: Opus 15s (main context) → Sonnet 60-345s (sub-agent) → Haiku 3× failures
- Root cause: sub-agents re-read large skill context (100+ KB) from filesystem, lose prompt-cache benefit
- Permission boundaries: sub-agents can write project-internal paths reliably; vault writes trigger denial-roulette
- Weaker model issue: Haiku fabricated permission asks rather than returning real errors, preventing graceful fallback

**Architectural Constraint:**
/r-timecard-day is designed for main-context execution. The LLM synthesis step (Step 4) only fires when commits lack `Block-summary:` lines — as blocks mature and adopt Block-summary, the LLM step will disappear, making sub-agent dispatch unnecessary. No skill modification warranted at this time.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
