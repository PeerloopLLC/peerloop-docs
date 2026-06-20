# State — Conv 307 (2026-06-19 ~21:32)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Swept **two single-route RG groups** to ☑ Swept under RTMIG-4: **[RG-MESSAGES] #19** (`/messages`, 5 island components) and **[RG-NOTIFS] #20** (`/notifications`, NotificationCenter). Both were light visual-conformance sweeps with an identical shape — the apparent `primary-*` "legacy" findings resolved to valid **americana-blue role tokens** (verify-before-counting avoided ~12 phantom findings each), so real work was just `--gray-100`→`neutral-100` swaps + font-weight→typography-token bundling + adopting the existing `<Button>` primitive (colour-neutral — Button `primary` = americana-blue). Browser-verified both (member + visitor, DOM-truth); gates green (tsc 0 / lint 0). Surfaced one cross-cutting follow-up: SegmentedPills hit Rule-of-Three (3 inline filter rows) → **[SEGPILL] #33**. All four conv commits are pushed (per-route during the conv); this r-end adds the bookkeeping commit.

## Completed

- [x] [RG-MESSAGES] #19 — `/messages` swept (MessagesCenter + ConversationList + MessageThread + NewConversationModal + Avatar), ☑ Swept, browser-verified, committed (code da42ac7b, docs 2dd6f01).
- [x] [RG-NOTIFS] #20 — `/notifications` swept (NotificationCenter), ☑ Swept, browser-verified, committed (code 383fe860, docs 99fb6fc).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-SESSIONS] #21 · [RG-MOD] #22 · [RG-PUBLIC] #23 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #28 · [SPACING-4PX-SWEEP] #30 · [SWEEP-SPACING-GREP] #31 · [LAYOUT-SG] #18

**Tier-2 cross-cutting:**
- [ ] [SEGPILL] #33 — converge 3 inline All/Unread filter rows (SmartFeed + messages + notifications) onto SegmentedPills/RoleTabBar; RoT met; touches 2 swept routes (backward-pointer re-glance).

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #25 · [COURSES-FIXES] #26 · [PROV-STAMP-GAPS] #24 · [XCUT-BACKREF] #32 · [STALE-TESTS] #29 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [MEM-PRUNE] #17 · [M4-ZGUARD] #27

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [MEM-PRUNE] · #18 [LAYOUT-SG] · #21 [RG-SESSIONS] · #22 [RG-MOD] · #23 [RG-PUBLIC] · #24 [PROV-STAMP-GAPS] · #25 [HOME-FIXES] · #26 [COURSES-FIXES] · #27 [M4-ZGUARD] · #28 [PALETTE-FDN] · #29 [STALE-TESTS] · #30 [SPACING-4PX-SWEEP] · #31 [SWEEP-SPACING-GREP] · #32 [XCUT-BACKREF] · #33 [SEGPILL]

## Key Context

- **2 routes Swept this conv** (messages + notifications). RTMIG-4 group summary: RG-HOME ✅, RG-COURSES ✅, RG-PROFILE ✅, **RG-MESSAGES ✅ (new)**, **RG-NOTIFS ✅ (new)**. Remaining in-scope single/small groups: RG-COMMS (2), RG-DISCOVER (3, /feed+/feeds likely retire), RG-SESSIONS (1), RG-MOD (1), RG-AUTH (7). Blocked: RG-PUBPROF (#5), RG-WORKSPACES (client). Out-of-scope (structural only): RG-ADMIN, RG-PUBLIC.
- **The conformance pattern these two routes establish** (likely repeats on RG-COMMS/DISCOVER/SESSIONS/MOD): (1) `primary-default`/`primary-light`/`alert-*`/`border-border-default`/`text-text-primary` are **valid Matt role tokens** — resolve through `tokens-semantic.css` before flagging (americana-blue `#0777B6` = `--Primary-Default`). (2) `bg-[var(--gray-100)]`→`bg-neutral-100` (exact #F1F1F1, zero-change). (3) font-weight `font-medium/semibold` on body tokens → bundled `text-body-{small,default,large}-{medium,bold}` / `text-h3-bold` (20/600). (4) hand-rolled primary text buttons → `<Button variant="primary">` (colour-neutral — primary variant = americana-blue, r39px pill, DOM-confirmed). (5) icon-only buttons → IconButton (no primitive yet, un-ripe); neutral-outlined buttons (e.g. Load-more) → no matching Button variant, keep hand-rolled.
- **honest-orphan C-keeps** (don't touch): notification per-type icon tints (`text-blue-500 bg-blue-50` ×18 — Matt has no notification-type colour scale, documented in NotificationCenter file comment); `text-[10px]` unread count badges (sub-12 glyph, MySessionsTab `text-[7px]` precedent); `text-white` on coloured surfaces.
- **[SEGPILL] #33 is now RIPE** — the All/Unread filter row (`PILL_BASE`/`PILL_ON`/`PILL_OFF` grammar) is hand-rolled identically on SmartFeed (Home, 4-option), ConversationList (/messages), NotificationCenter (/notifications). RoT met. Existing primitive (`form/SegmentedPills.tsx` / `RoleTabBar.tsx`) — converge the 3 inline sites, then re-glance the 2 already-swept consumers (Home, messages). SoT: tier2-primitive-ledger.md FilterTabs/SegmentedControl row.
- **MEMORY.md at ~90% of the SessionStart cap** → [MEM-PRUNE] #17 still open (not addressed this conv; the 🔴 alert fired again at r-start).
- **Conv-307 commits (pushed during conv):** code `da42ac7b` (messages) + `383fe860` (notifications); docs `2dd6f01` (messages) + `99fb6fc` (notifications). Plus this r-end bookkeeping commit (Step 6) + counter-start `8b03e87`. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
