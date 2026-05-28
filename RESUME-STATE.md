# State — Conv 208 (2026-05-28 ~12:51)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 208 closed the smaller half of the STANDIN-MATT arc: 404.astro retrofitted `@stand-in` → `@matt-inspired` (Matt tokens + Button primitive), the 3-marker page-provenance convention codified in matt-provenance.md §11 + CLAUDE.md, and `prov-sweep.ts` extended with a page-level classifier using line-anchored regexes (canonical-case verified per `feedback_heuristic_calibration.md`). A premature /profile retrofit was reverted at user direction — STANDIN-MATT remains open with /profile as the genuine pending item. CLAUDE.md gained a top §Recurring Failures pre-send checklist + the option-phrasing memory file was rewritten to lead with the anti-pattern verbatim (recurring violation Convs 132/147/208). Memory-sync A/B/C wording reframed in r-start/SKILL.md around "whose intent wins."

## Completed

- [x] [STANDIN-404] 404.astro retrofitted @stand-in → @matt-inspired
- [x] [PROV-CODIFY] 3-marker convention codified (matt-provenance.md §11 + CLAUDE.md)
- [x] [PROV-SWEEP-MI] prov-sweep.ts teaches @matt-inspired/@stand-in + line-anchored regex
- [x] r-start/SKILL.md Step 5.7 mirror-sync wording reframed around "whose intent wins"
- [x] CLAUDE.md §Recurring Failures section added (top of file)
- [x] memory/feedback_option_phrasing.md rewritten to lead with anti-pattern; MEMORY.md line updated
- [x] [STANDIN-MATT] /profile retrofit attempted but reverted (premature; task remains pending)

## Remaining

- [ ] [STANDIN-MATT] [Opus] Retrofit /profile — genuine substantive design work (Conv 205-tagged complex); last @stand-in page
- [ ] [DISC-DROP] [Opus] Finish discover-page migration Stages 3+4
- [ ] [DISC-RTB-RECONCILE] [Opus]
- [ ] [AICODING-SEED]
- [ ] [DISC-UNIFY] pointer to DISC-DROP
- [ ] [RTMIG-4] [Opus]
- [ ] [E2E-MIG]
- [ ] [E2E-GATE] [Opus]
- [ ] [PREFLIP-WT]
- [ ] [MATT-EXEC-PG2] [Opus]
- [ ] [MATT-EXEC-EXT] [Opus]
- [ ] [RTB] [Opus]
- [ ] [ADMIN-REDIRECT-BLANK]
- [ ] [MMP-PH5] [Opus]
- [ ] [MATT-EXEC-GRD]
- [ ] [MMP-PH3] [Opus]
- [ ] [SHOWMORE]
- [ ] [CH-VARIANTS]
- [ ] [ICN-NS] [Opus]
- [ ] [HOWTOREG-ICN]
- [ ] [ASSET-SWEEP-GATE]
- [ ] [MFRD-LOOKUP]
- [ ] [ESOT-STRUCTURE]
- [ ] [BROWSER-FALLBACK]
- [ ] [TXTBTN]
- [ ] [DTUNE-WATCH]
- [ ] [SKILL-DISCOVERY-AUDIT]
- [ ] [OPM-REGEN] Regen orig-pages-map.md auto-gen
- [ ] [PROF-SUBNAV-DEAD] Profile SubNav has 3 dead links (NEW Conv 208; defer to [RTMIG-4])

## TodoWrite Items

- [ ] #1: [STANDIN-MATT] [Opus] / #2: [DISC-DROP] [Opus] / #3: [DISC-RTB-RECONCILE] [Opus]
- [ ] #4: [AICODING-SEED] / #5: [DISC-UNIFY]
- [ ] #6: [RTMIG-4] [Opus] / #7: [E2E-MIG] / #8: [E2E-GATE] [Opus] / #9: [PREFLIP-WT]
- [ ] #10: [MATT-EXEC-PG2] [Opus] / #11: [MATT-EXEC-EXT] [Opus] / #12: [RTB] [Opus] / #13: [ADMIN-REDIRECT-BLANK]
- [ ] #14: [MMP-PH5] [Opus] / #15: [MATT-EXEC-GRD] / #16: [MMP-PH3] [Opus] / #17: [SHOWMORE] / #18: [CH-VARIANTS]
- [ ] #19: [ICN-NS] [Opus] / #20: [HOWTOREG-ICN] / #21: [ASSET-SWEEP-GATE] / #22: [MFRD-LOOKUP]
- [ ] #23: [ESOT-STRUCTURE] / #24: [BROWSER-FALLBACK] / #25: [TXTBTN] / #26: [DTUNE-WATCH] / #27: [SKILL-DISCOVERY-AUDIT]
- [ ] #31: [OPM-REGEN] / #32: [PROF-SUBNAV-DEAD]

## Key Context

- **3-marker page-provenance convention** (Conv 207 established, Conv 208 codified): every non-legacy page declares exactly ONE of `@stand-in` / `@matt-source <nodeId>` / `@matt-inspired`. Unmarked = legacy. Full convention in matt-provenance.md §11. CLAUDE.md has table + pointer.
- **prov-sweep.ts page-level classifier** uses LINE-ANCHORED regex (`^[\s/*]*@matker\b`, `m` flag) — bare token-anywhere catches prose mentions of child markers (404.astro mentioned `Button (\`@matt-source 40:482\`) primitive` and mis-classified). Pages have prose-pollution risk that component-side `MARKER_RE` doesn't.
- **CLAUDE.md §Recurring Failures** at top of file: option-phrasing (NEVER `"X, or Y?"`; ALWAYS labels above 👉) + 👉-pause rule. Pre-send checklist. Sets pattern for future escalations.
- **/profile retrofit reverted** — file at HEAD, marker still `@stand-in`. Don't redo as marker-flip + EmptyState/Button swaps; user expects substantive design + real account-page content. Genuine [RTMIG-4]-level work.
- **Memory-sync A/B/C wording** at r-start Step 5.7 reframed: A=save this machine's file first; B=let other machine win incl. deletion; C=inspect.
- **Tailwind changes warrant `npm run build`** as a verify step — `tsc + astro check` don't invoke the Tailwind compiler. Decision-point framing of `/w-codecheck` retained (user-confirmed): not all small changes need /w-codecheck; the trigger is the moment to ask "does this change deserve verification?"
- **All 5 baseline gates last verified Conv 207** end (tsc 0; astro check 1290/0/0/0; lint 0; build clean; test 6452/6452). This conv: tsc + astro check re-run on 404 only (clean); no build/lint/test run.
- **Form primitive surface registered** in PHASE6_EXTRAPOLATION_CANDIDATES from Conv 207: Input, FormField, PasswordInput, Select, SelectableCard, FormBanner, FormSection, SearchInput, SegmentedPills (+ ui/SkeletonCard, ui/ErrorState).
- **Branch:** code `jfg-dev-13-matt`, docs `main`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
