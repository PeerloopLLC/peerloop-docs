# State — Conv 232 (2026-06-01 ~12:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built the **precheckout page** (MATT-DESIGN-PUSH Phase 5 / [MATT-EXEC-PG2] Enroll family). Resolved the Conv-231-parked route-shape decision: **addressable, reversing Conv 187**, then refined by the user to a **hybrid — one `PrecheckoutContent` component hosted at two routes**: standalone `/course/[slug]/precheckout` (Matt 1:1) + a `/course/[slug]/benefits` SubNav tab. Both CTAs → Stripe. Reused `EnrollButton` via an opt-in `variant="matt"`. All five gates green, route-map regenerated (both repos), DOM + visually verified. Two follow-ups + one borderline doc note tracked.

## Completed

- [x] /r-start (Conv 232; 33 tasks transferred; conv-tasks.md regenerated; memory synced)
- [x] Completed Figma MCP OAuth on M4Pro; probed `558:15067` + `723:14935` live
- [x] Addressability audit — resolved [PRECHECKOUT-REDIRECT-AUDIT] + [PRECHECKOUT-LEGACY-TRACE] (all 3 deep-link candidates No; decision flipped on the already-coded CTA href + standalone frame + addressable siblings)
- [x] Precheckout BUILT: `PrecheckoutContent.astro` (`@matt-source 558:15067`) + standalone `precheckout.astro` + `/benefits` tab + `EnrollButton variant="matt"` + `CourseHeader` CTA repoint `/checkout`→`/precheckout`
- [x] Gates: tsc 0 · astro 0 · lint 0 · build ✓ · EnrollButton 17/17 · route-map regenerated (both repos)
- [x] DOM + visual verification of both routes (screenshots)
- [x] Docs: MFRD addressability table reversed; phase-5-pg2 Conv 232 section; url-routing.md updated (docs agent)

## Remaining

(Phase 5 [MATT-EXEC-PG2] umbrella stays open — Session family + 5 other routes pending. New follow-ups below.)

- [ ] [PRECHECKOUT-EARN] (#34) — wire a real per-course earnings aggregate to replace the static "$7,438" demo figure
- [ ] [PRECHECKOUT-MATT-CONFIRM] (#35) — run the additive `/benefits` SubNav tab past Matt (his frame says "not a SubNav tab")
- [ ] [PREPLAN-CHECKOUT-NOTE] (#36) — optional: annotate matt-pre-plan.md `/checkout` placeholder as resolved (or close as won't-fix; historical doc)

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus]
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier (matt-provenance.md §12)
- [ ] #3: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #4: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #5: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell [Opus]
- [ ] #6: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #7: [E2E-GATE] Structural-change tier + goto-target resolver [Opus]
- [ ] #8: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #9: [MATT-EXEC-PG2] Phase 5 remaining pages — **precheckout ✅ Conv 232**; Session family + 5 routes pending [Opus]
- [ ] #10: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #11: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* returns blank 15-byte 200 instead of redirect [Opus]
- [ ] #12: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #13: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #14: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #15: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants
- [ ] #16: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #17: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #18: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #19: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #20: [TXTBTN] Extract TextButton primitive on Rule-of-Three
- [ ] #21: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #22: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #23: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #24: [MW-COMMUNITY-STALE] Stale /community protected-prefix in middleware:45 (no root route yet)
- [ ] #25: [API-USERS-DRIFT] Reconcile /api/members doc block in API-USERS.md
- [ ] #26: [DOM-FIRST] Reinforce dom-truth-first on first visual-bug report
- [ ] #27: [SELECT-AUDIT] Spot-check all Select instances render single caret post-forms-fix
- [ ] #28: [BAK-ARTIFACT] Track down what creates stray .bak files in code repo
- [ ] #29: [DOCS-ROUTES-STALE] Fix stale `npm run docs:routes` reference
- [ ] #30: [GARBLE-WATCH] Re-test TERM-GARBLE when upstream fixes parallel tool-result delivery
- [ ] #31: [HOME-FEEDSHUB-VIS] Visitor/public variant of FeedsHub on `/`
- [ ] #32: [REND-DEDUP-GUARD] r-end Step 2 must dedup scratch notes vs un-compacted history
- [ ] #33: [MEM-CAP] Prune MEMORY.md — at 81% of SessionStart auto-load cap
- [ ] #34: [PRECHECKOUT-EARN] Wire real per-course earnings aggregate (replace static $7,438)
- [ ] #35: [PRECHECKOUT-MATT-CONFIRM] Run /benefits SubNav-tab addition past Matt
- [ ] #36: [PREPLAN-CHECKOUT-NOTE] Optionally annotate matt-pre-plan.md /checkout placeholder as resolved

## Key Context

- **Precheckout shipped (`jfg-dev-13-matt`, pre-commit this conv):** `src/components/course/PrecheckoutContent.astro` (`@matt-source 558:15067`, single source of truth, `showHero` prop); `src/pages/course/[slug]/precheckout.astro` (standalone); `/benefits` tab via `_course-tabs.ts` + `[...tab].astro` (`VALID_TABS`/`TAB_LABELS`/render branch, `showHero={false}`); `EnrollButton.tsx` `variant="matt"` (green `Button variant="course"` pill, opt-in, legacy default unchanged, 17/17 tests); `CourseHeader.tsx:134` CTA → `/precheckout`.
- **Decision record:** addressable, reversed Conv 187 — see `docs/reference/matt-frames-ready-for-dev.md` § Route Addressability + `plan/matt/phase-5-pg2.md` Conv 232 section. Important decision routed to `docs/decisions/11-new-routing.md`.
- **`/benefits` tab is a Peerloop addition** diverging from Matt's "NOT a SubNav tab" annotation → **#35 run past Matt** before treating as final.
- **"$7,438 earned" is static demo copy** (no schema source; Conv-189 CREATOR_STATIC precedent) → **#34** to wire a real aggregate.
- **Both CTAs → Stripe** (decision A); `/precheckout` and `/benefits` are parallel chromes, not a two-step funnel.
- **MEMORY.md at 81% of the 25 KB auto-load cap** (#33 [MEM-CAP]) — run `/r-prune-memory` soon.
- Dev server: a fresh one was started then the extra (:4322) killed in cleanup; a server may still hold :4321 from earlier. Restart as needed (`cd ../Peerloop && npm run dev`).
- Changes committed in Step 6 of this conv's r-end (this Key Context is the pre-commit snapshot).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
