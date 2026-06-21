# State — Conv 313 (2026-06-20 ~20:31)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the route sweep (RTMIG-4) and **completed [RG-MOD] — `/mod` ☑ Swept**: Tranche B conformed `ModeratorQueue`'s own chrome (action buttons adopt the `Button` primitive, minting CC-owned `warning` + `suspend` variants; hybrid category-badge colour policy; stat cards + detail-panel body + skeleton), then whole-route browser-verify (DOM-truth, admin `brian` on Chrome bridge :4324). Then the user redirected to **fixing errors** — `/w-codecheck` was fully green, and the only red (8 pre-existing test failures) turned out to be **all stale assertions** lagging shipped design changes (Conv 299/289/292); fixed test-only → **full suite 6741/6741**, `[STALE-TESTS]` closed. All committed (code `4fbec4ca`+`dfab30ee`, docs `d1ba8ec`), pushed at this r-end.

## Completed

- [x] [RG-MOD] Tranche B — `ModeratorQueue` chrome conformed: 5 action buttons → `Button` primitive (new CC-owned `warning` amber + `suspend` honest-orphan-orange variants in `Button.tsx`); hybrid badges (priority→status tokens; reason/content-type orphan hues kept); stat cards (`text-2xl font-bold`→`text-h2-bold`, bridge `p-4`→`p-16`), detail-panel body + skeleton (`h-4`→`h-16`), gray→neutral/text + yellow/green→warning/success; avatar-initial orange kept honest-orphan. 5 gates green.
- [x] [RG-MOD] whole-route browser-verify (DOM-truth, admin brian on bridge :4324) → `/mod` ☑ Swept. Residual: Warn/Suspend buttons not seen in-situ (seed pending-flag lacks `target_user`; variants probe- + test-verified).
- [x] [STALE-TESTS] 8 pre-existing stale test failures fixed test-only (FeedActivityCard ×3 indigo/purple→brand; ListingShell ×1 lg:order-2→order-1; dismiss ×4 mock `@lib/ephemeral-dismiss`) → full suite **6741/6741**.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-DISCOVER] #9 (feed components pre-conformant from Conv 311 — **lightest next sweep**) · [RG-PUBLIC] #18 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #23 · [SPACING-4PX-SWEEP] #25 · [SWEEP-SPACING-GREP] #26 (rounded-N done Conv 311; spacing-grep sub-part remains) · [LAYOUT-SG] #16

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #27 — re-glance already-swept routes after cross-cutting extractions.

**Memory system:**
- [ ] [MEM-CAP-ARCH] #28 [Opus] — decide MEMORY.md auto-load cap architecture (both prune levers exhausted; do NOT just re-prune). **This conv's r-start cap check fired again at 80% bytes (20481/25600).**

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #29 — fold an explicit full `npm test` (or scope-out note) into the route-sweep tranche-close checklist (Conv 312's "5 gates green" omitted the suite; 8 stale tests were already red).
- [ ] [PROV-STAMP-GAPS] #19 (incl. the 4 `Admin*` primitives' missing `data-prov`) · [HOME-FIXES] #20 · [COURSES-FIXES] #21 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #10 · [E2E-GATE] #11 · [ICN-NS] #12 · [TZ-AUDIT] #13 [Opus] · [DOCGEN-SPEC] #14 · [V217-WATCH] #15 · [M4-ZGUARD] #22
- [ ] (optional, trivial) Simplify the dead ternary at `FeedActivityCard.tsx:307-311` (both instructor/creator branches return `ring-brand-100` after Conv-299 conformance).

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-DISCOVER] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [ICN-NS] · #13 [TZ-AUDIT] [Opus] · #14 [DOCGEN-SPEC] · #15 [V217-WATCH] · #16 [LAYOUT-SG] · #18 [RG-PUBLIC] · #19 [PROV-STAMP-GAPS] · #20 [HOME-FIXES] · #21 [COURSES-FIXES] · #22 [M4-ZGUARD] · #23 [PALETTE-FDN] · #25 [SPACING-4PX-SWEEP] · #26 [SWEEP-SPACING-GREP] · #27 [XCUT-BACKREF] · #28 [MEM-CAP-ARCH] [Opus] · #29 [SWEEP-FULLSUITE]

## Key Context

- **RG-MOD is DONE (☑ Swept Conv 313).** SoT: `plan/route-migration/README.md` (RG-MOD row ☑) + `plan/typo-fdn/migration-ledger.md` (`/mod` section ☑). Next sweep candidate = **RG-DISCOVER #9** (feed components pre-conformant from Conv 311 → lightest) or RG-AUTH #4.
- **`Button.tsx` now carries CC-owned `warning` + `suspend` variants** (beside Conv-306 `danger`) — reusable severity ladder (neutral→warning→suspend→danger). `warning` = amber/warning ramp; `suspend` = documented honest-orphan orange (`bg-orange-500 hover:bg-orange-600`, no Matt role scale). Routed to `docs/decisions/05-ui-ux-components.md`.
- **Conv-312 baseline-claim gap:** Conv 312's "5 gates green" never ran the full suite — 8 stale tests were already red (proven via stash-verify vs `c53608a1`). Tracked as #29 [SWEEP-FULLSUITE]. Lesson = a "gates green" claim that omits full `npm test` is not a real baseline (CLAUDE.md §Baseline Verification Rule 2).
- **The 8 stale tests are now fixed (test-only):** FeedActivityCard ×3 (Conv-299 indigo/purple→brand), ListingShell ×1 (Conv-289 Q2 utility-left lg:order-2→order-1), dismiss ×4 (Conv-292 ephemeral-dismiss — mock `readDismissed` to honor localStorage; `dismissalPersists()` returns false on DEV/localhost by design).
- **Conv-313 commits (pushed at r-end):** code `4fbec4ca` (Button variants + ModeratorQueue chrome) + `dfab30ee` (5 test files); docs `d1ba8ec` (ledger + README RG-MOD swept) + `67c53e0` (USER-WIP auto-save) + `a346352` (counter) + this end-of-conv bookkeeping commit. Code on `jfg-dev-14`.
- **MEMORY.md cap at 80% bytes** — #28 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
