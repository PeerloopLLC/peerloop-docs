# State — Conv 220 (2026-05-30 ~18:22)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Resumed after a deliberate `/quit` from prior-conv [TERM-GARBLE] (garbled CC session I/O). Did NOT run `/r-start` (counter already at 220). Completed PROFILE-TIER1's Tier-1 primitive-swap surface across the last 3 of 5 profile-tab islands — TopicPicker, SecuritySettings, ProfileSettings — verifying every worklist primitive guess against real component APIs (4 guesses were semantic mismatches → deferred to Tier-2). Full baseline verified this conv: 8 `/w-codecheck` gates + 6456/6456 tests + production build, all green.

## Completed

- PROFILE-TIER1 (#3) — Tier-1 swaps complete across ALL 5 islands (Notification + Stripe prior convs; TopicPicker + Security + Profile this conv)
- TopicPicker: native level `<select>` → Matt `Select` (w-[150px] wrapper)
- SecuritySettings: email `<input>`→Matt `Input`; Change-Password `<a>`→`Button` primary; Sign Out `<button>`→`Button` outlined
- ProfileSettings: local `Input` recomposed onto `FormField`+Matt `Input` (depth-B, chosen by user); Save button → Matt `Button`
- Full baseline verified THIS conv: tsc, astro check, lint, 6456 tests, build — all green

## Remaining

- [ ] [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (#26) [Opus] — blocked on: Matt `Button` has no danger variant; `form/` has no `Textarea`/`Switch`/`Checkbox`/`Card` primitive. Deferred items inventory: TopicPicker topic-card(accordion≠SelectableCard)/checkbox/count-badge; Security Cancel+Delete modal pair + Delete Account + Retry; Profile local TextArea + Toggle + Retry. Convert form wrappers together for coherence.
- [ ] [TXTBTN] Extract TextButton primitive on Rule-of-Three (#24) — TopicPicker "Select All" text-link is one instance.
- [ ] (note) Stale worklist candidate: SecuritySettings `:236` "device row" is actually the loading skeleton — Active Sessions is a Coming-Soon placeholder, no rows exist.
- [ ] All other pending blocks below (RTMIG, DISC, MATT-EXEC, ICN, etc.) — unchanged this conv.

## TodoWrite Items

- [ ] #1: [PRIM-MATCH-INDEX] Deterministic per-primitive match index [Opus] — replace agent-narrated matching in /w-prim-candidates with deterministic index
- [ ] #2: [PRIM-DOC] Document primitive-definition + pre-primitive tier — matt-provenance.md §12 (ErrorRetryCard precedent)
- [ ] #4: [RTMIG-TIER] Adopt Tier-1/Tier-2 page-conversion strategy across RTMIG-4
- [ ] #5: [PRIM-ORPHAN-ACK] @prov-orphan suppression marker for prim-treewalk sensor
- [ ] #6: [DISC-DROP] Finish Stages 3+4 of discover-page migration [Opus]
- [ ] #7: [DISC-RTB-RECONCILE] Reconcile discover role-tabs vs Matt Role-Tab-Bar [Opus]
- [ ] #8: [RTMIG-4] Port ~89 legacy /old/* pages to root in Matt shell + fix middleware PROTECTED_PREFIXES + /profile→/@me [Opus]
- [ ] #9: [E2E-MIG] Re-point Playwright e2e onto new root routes
- [ ] #10: [E2E-GATE] Structural-change tier + goto-target resolver (prototype .scratch/e2e-route-map.mjs) [Opus]
- [ ] #11: [PREFLIP-WT] Tear down Peerloop-preflip reference worktree + peerloop-ref alias
- [ ] #12: [MATT-EXEC-PG2] Phase 5 remaining pages (Enroll + Session families + 5 routes) [Opus]
- [ ] #13: [MATT-EXEC-EXT] Phase 6 lazy extrapolation primitives [Opus]
- [ ] #14: [RTB] Author Role Tab Bar design-spec doc (feeds DISC-RTB-RECONCILE) [Opus]
- [ ] #15: [ADMIN-REDIRECT-BLANK] Non-admin /admin/* blank 15-byte 200 instead of redirect; AdminLayout L37 mechanism unexplained [Opus]
- [ ] #16: [MMP-PH5] Phase 5 graduation — roll forward ~11 pages via Figma MCP (M4-pinned) [Opus]
- [ ] #17: [MATT-EXEC-GRD] Phase 7 graduate design-system docs at block close
- [ ] #18: [SHOWMORE] Show-More affordance on Teachers + Reviews tabs
- [ ] #19: [CH-VARIANTS] CourseHeader Enrolled + Scheduled variants (Figma 597:6504 / 685:13240)
- [ ] #20: [ICN-NS] Converge ~204 legacy icon usages onto MattIcon registry
- [ ] #21: [HOWTOREG-ICN] How-to-register-an-icon doc for MattIcon registry
- [ ] #22: [ASSET-SWEEP-GATE] Figma-URL grep guard as /w-codecheck Check 9
- [ ] #23: [MFRD-LOOKUP] Maintain Matt frames-ready-for-dev lookup
- [ ] #24: [TXTBTN] Watch: extract TextButton primitive on Rule-of-Three (TopicPicker Select-All = instance 1)
- [ ] #25: [SETTINGS-WATCHER] Find process rewriting settings.local.json on M4Pro
- [ ] #26: [PROFILE-PRIM-SWEEP] Tier-2 remainder of profile sweep (PAUSED) [Opus]
- [ ] #27: [PRIM-COURSES-DISMISS] Vet/primitivize /courses Dismiss button
- [ ] #28: [TERM-GARBLE] Mitigate recurring CC terminal-render garble (persisted mildly post-restart this conv; user testing `claude update` each restart)

## Key Context

- **PROFILE-TIER1 complete; Tier-2 lives in #26.** Will be committed in Step 6 (3 code files: TopicPicker, ProfileSettings, SecuritySettings). Code HEAD before this conv's end-commit: `354f3e64`.
- **Primitive inventory facts (verified this conv):** `form/` has Input, PasswordInput, SearchInput, SegmentedPills, Select, SelectableCard, FormField, FormBanner, FormSection. NO Textarea/Switch/Checkbox. `ui/` Button has variants primary/outlined/course/student/creator/default × property1 Default/Hover/Large/Small/SmallHover — **NO danger variant**. No generic Card primitive. These gaps block #26.
- **Method that worked:** read primitive .tsx API → verify worklist guess → surface disposition → 👉 → swap; never force a mismatched primitive. Worklist primitive *names* are unverified until [PRIM-MATCH-INDEX] (#1).
- **Git is authority over Edit "success"** under [TERM-GARBLE]; verify every edit via `git diff`.
- **Aliased-import pattern:** `import MattInput from '@components/form/Input'` lets a Matt primitive compose inside a same-named local wrapper with zero call-site edits (used in ProfileSettings).
- Worklist file: `.scratch/prim-candidates-pages-profile-tab.md`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
