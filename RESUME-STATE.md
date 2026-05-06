# State — Conv 150 (2026-05-06 ~13:30)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 150 closed [OPW] (Conv 147 option_phrasing strengthening watch) by discovering it was a memory-delivery failure, not a rule-content failure — the file was missing on MacMiniM4-Pro the entire time. Hand-synced 31 memory files from a desktop folder out of MacMiniM4 plus merged MEMORY.md as a unified topical index. Then audited CLAUDE.md + memory for ambiguities/contradictions/inefficiencies (Tier 1 + Tier 2 + Tier 3 fixes applied), and on user push-back went deeper: full CLAUDE.md restructure under plan-mode → auto-mode (677 → 446 lines, 22 → 19 sections; navigation moved to NEW `docs/INDEX.md`, archaeology to `TIMELINE.md`, run-arc to `SCOPE.md`, dead recovery deleted, schema-mismatch options format aligned with A/B/C rule, Issue Surfacing memory consolidated to stub). New `feedback_conversational_brevity.md` rule captured (match response length to question length).

## Completed

- [x] [OPW] feedback_option_phrasing.md Conv 147 strengthening watch — closed (root cause: missing file on this machine; pointing-question form clarified during close)
- [x] Memory dir M4 sync — 31 files copied from desktop folder, 2 overlaps updated to M4 versions, MEMORY.md merged as topical index with new sections (Security & Secrets, PLATO / Browser Testing, Project Context); 4 stubs created; 2 duplicates deleted
- [x] Tier 1 audit fixes — CLAUDE.md `/q-add-client-note` → `/w-add-client-note` typo; r-end memory merged (Conv list 006/019/026/027)
- [x] Tier 2 audit fixes — output-formatting memories merged (4→3); size ≠ novelty inlined into §Critical Rule; new §Baseline Verification section; both baseline memories reduced to stubs
- [x] Tier 3 audit fixes — Test Suite Workflow ↔ Baseline Verification cross-reference
- [x] CLAUDE.md major restructure (677 → 446 lines, 22 → 19 sections) — navigation to docs/INDEX.md (NEW), archaeology to TIMELINE.md, Block Arc to SCOPE.md, dead D1 reset recovery removed, §Schema Discrepancy Discipline new top-level section
- [x] DOC-DECISIONS.md entry: "CLAUDE.md Restructure: Behavioral Rules vs Navigation/Archaeology" with go-forward rules
- [x] feedback_conversational_brevity.md authored + indexed

## Remaining

- [ ] [PD] Prod cron Worker deploy [Opus] — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up
- [ ] [CMH] Capture meta-rule as feedback memory: test new detection heuristics against canonical motivating case before committing
- [ ] [CMS] Cross-machine memory sync architecture — design durable solution [Opus] — manual desktop-folder copy is the current workaround; needs design choice (bidirectional sync script vs shared-repo convention vs hook reminder vs accept-manual-forever)
- [ ] [ARP] Asymmetric output-formatting rule placement (CLAUDE.md vs memory) — observation; revisit only if cross-referencing cost grows
- [ ] [ILS] MEMORY.md index lines must expose load-bearing parts of rules — could become a new feedback memory; surfaced after I anchored on "Bold questions" index summary and missed the 👉 prefix in the file body
- [ ] [WAS] Watch-task framing should capture assumed delivery/loading state — convention update; surfaced after [OPW] turned out to be a delivery-failure investigation, not a rule-content investigation

## TodoWrite Items

- [ ] #1: [PD] Prod cron Worker deploy [Opus] — blocked until 2026-04-28
- [ ] #3: [CMH] Capture meta-rule as feedback memory: test new detection heuristics against canonical motivating case before committing
- [ ] #4: [CMS] Cross-machine memory sync architecture — design durable solution [Opus]
- [ ] #5: [ARP] Asymmetric output-formatting rule placement (CLAUDE.md vs memory)
- [ ] #6: [ILS] MEMORY.md index lines must expose load-bearing parts of rules
- [ ] #7: [WAS] Watch-task framing should capture assumed delivery/loading state

## Key Context

**Memory dir state at end of Conv 150:** 49 files (48 memory + MEMORY.md). Manual M4 sync needed: copy `/Users/jamesfraser/.claude/projects/-Users-jamesfraser-projects-peerloop-docs/memory/` to M4's equivalent (`/Users/livingroom/...`) AFTER /r-end commits land. The desktop "from M4 - memory" folder is no longer needed (its content is integrated here, with strengthening + new rules added since).

**CLAUDE.md content discipline (NEW, documented in DOC-DECISIONS.md):**
- Behavioral rules → CLAUDE.md
- Navigation indexes ("where do I find X?") → `docs/INDEX.md`
- Dated inflection-point context → `TIMELINE.md`
- Run-scope context → `docs/as-designed/run-XXX/`
- Archaeology not load-bearing → git history or `TIMELINE.md` subsection
- Trigger to consider moving content out: a CLAUDE.md section grows past ~30 lines.

**§Skills: Preserve `!` Backtick Determinism** section name MUST stay verbatim in CLAUDE.md — referenced by `/r-start/SKILL.md:123`. Confirmed at the time of restructure.

**Asymmetric rule placement note:** §Issue Surfacing rule lives in CLAUDE.md (memory = stub); §Pointing Emoji + §Option Phrasing rules live in memory (CLAUDE.md cross-references them in §Schema Discrepancy Discipline). Functionally fine, aesthetically inconsistent. [ARP] tracks revisit trigger.

**Pre-commit snapshot of pending work for next conv:** all of Conv 150's edits will be in this conv's commit. State file is being saved before Step 6 commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
