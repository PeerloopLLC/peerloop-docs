# State — Conv 309 (2026-06-20 ~12:43)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Three tasks landed. **[SEGPILL]:** parameterized `ui/form/SegmentedPills.tsx` with a `variant: 'pills'|'segmented'|'tabs'` enum (active fill fixed to americana-blue) + a `className` prop, then converged 5 hand-rolled All/Unread filter rows onto it — NotificationCenter (pills), `messages/matt/ConversationList` (segmented track, `mx-12 mt-12` via className), SmartFeed/Home (tabs). The ledger's "3 sites identical" was wrong: token indirection (`--Text-Primary` = `--Primary-Default` = blue; `--Text-Default` = gray-base) had hidden that the primitive's old black active matched none of the 4 live blue-active consumers. All 3 RoT sites DOM-truth + visually verified (`#0777B6` blue); gates+prov green; CoursesCatalog shifts black→blue (accepted). Found Home's `rounded-8` is a no-op (0px) → logged to [HOME-FIXES]. **[MEM-PRUNE]:** 44 index-hook re-flattens took MEMORY.md 90%→80.6%, then the lever was declared exhausted — the index is **entry-bound** (≈79–83 distinct rules at content floor), not hook-bound. **[MEM-CONSOLIDATE]:** /r-coherence-check DEEP merged 5 redundant/orphan entries (84→79 sub-files, index 124→120 lines, integrity clean) but barely moved bytes — confirming the cap can't be cleared by trim or merge. New follow-up **[MEM-CAP-ARCH] [Opus]** captures the architectural decision (tiered index / raise-the-bar / routine prune).

## Completed

- [x] [SEGPILL] #30 — parameterized SegmentedPills + 5 rows → 1; browser+DOM verified (`#0777B6`); gates+prov green; ledger 🟢 Converged (code b61f6d7f, docs 1d2972a).
- [x] [MEM-PRUNE] #17 — 44 index-hook re-flattens 90%→80.6%; lever exhausted (entry-bound); integrity clean (docs 02e60ce).
- [x] [MEM-CONSOLIDATE] #31 — 5 merges/orphan-index, 84→79 sub-files, 124→120 lines, integrity clean (docs 4474dc3).
- [x] [XCUT-BACKREF] satisfied for SEGPILL's 2 swept consumers (/messages, /notifications re-glanced in-browser this conv).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-MOD] #19 · [RG-PUBLIC] #20 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #25 · [SPACING-4PX-SWEEP] #27 · [SWEEP-SPACING-GREP] #28 · [LAYOUT-SG] #18

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #29 — re-glance already-swept routes after future cross-cutting extractions (SEGPILL's 2 consumers already done).

**Memory system:**
- [ ] [MEM-CAP-ARCH] #32 [Opus] — decide MEMORY.md auto-load cap architecture (index entry-bound at ~80%; both prune levers exhausted). Options: tiered/2-file index · raise inclusion bar · routine prune.

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #22 (now incl. `rounded-8` no-op) · [COURSES-FIXES] #23 · [PROV-STAMP-GAPS] #21 · [STALE-TESTS] #26 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [M4-ZGUARD] #24

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #18 [LAYOUT-SG] · #19 [RG-MOD] · #20 [RG-PUBLIC] · #21 [PROV-STAMP-GAPS] · #22 [HOME-FIXES] · #23 [COURSES-FIXES] · #24 [M4-ZGUARD] · #25 [PALETTE-FDN] · #26 [STALE-TESTS] · #27 [SPACING-4PX-SWEEP] · #28 [SWEEP-SPACING-GREP] · #29 [XCUT-BACKREF] · #32 [MEM-CAP-ARCH] [Opus]

## Key Context

- **`SegmentedPills` is now the canonical filter-pill primitive** (`src/components/form/SegmentedPills.tsx`): `variant: 'pills'|'segmented'|'tabs'` (each bundles layout/shape/inactive), active fill fixed blue (`bg-primary-default`), optional `className`. Future filter rows → adopt it. **MembersFilters is a latent 4th adopter** (`pills`, identical look) — convert when /members is swept.
- **Token gotcha (reusable):** `--Text-Primary` resolves to `--Primary-Default` (= americana-blue), NOT a distinct colour; `--Text-Default` = gray-base. A class-string/marker scan can't see this — read resolved tokens when assessing colour conformance.
- **`rounded-8` is a no-op in this Tailwind v4 setup** (computes 0px; only `rounded-full` resolves). Home filter tabs render sharp corners despite the class name. Captured in [HOME-FIXES] #22; may exist elsewhere (grep alongside [SWEEP-SPACING-GREP]).
- **MEMORY.md is at its structural floor (~80.0%).** Hook-trim (/r-prune-memory) AND entry-merge (/r-coherence-check) are both exhausted; the 🔴 cap alert will fire again at next /r-start. The durable fix is architectural — [MEM-CAP-ARCH] #32. Do NOT just re-prune.
- **getComputedStyle is reliable for `border-radius`/geometry post-settle** (used to catch the rounded-8 no-op) but still lies on `color` under a live transition — screenshot for painted colour, DOM for geometry.
- **Conv-309 commits (all pushed at this r-end):** code `b61f6d7f` (SEGPILL); docs `1d2972a` (SEGPILL ledger), `02e60ce` (MEM-PRUNE), `4474dc3` (MEM-CONSOLIDATE), + counter-start `a25b4f7` + this end-of-conv bookkeeping commit. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
