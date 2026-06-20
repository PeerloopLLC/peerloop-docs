# State — Conv 308 (2026-06-20 ~09:32)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Swept **[RG-SESSIONS] #19** (`/session/[id]`, 1/1 route) under RTMIG-4. Headline = a Tier-2 extraction: built **`ui/StarRating.tsx`** (interactive integer + hover-preview + `onHoverChange`; `readOnly` fractional half-star fill + `showValue`; sizes sm/md/lg), unifying 3 divergent star colourings (`text-[#f5b800]` / `text-amber-400` / `text-star`) onto the `--star` token. Adopted in SessionCompletedView (main+sub), CourseReviewModal (removed local `StarRow`, preserved hover-label via `onHoverChange`), and SessionBooking `/book` readonly averages (a user-driven decision to render `★★★★½ 4.5` for teacher-selection-by-comparison; backward-pointer re-glanced). Conformance: `bg-gray-100`→`neutral-100` ×7, star gold→`text-star` (stale "no token exists" comment retired), `Textarea` adopt ×3, composer `gap-10`/`pl-10` (40px off-scale)→`gap-12`/`pl-12`. Browser+screenshot verified incl. the early/prepare composer (reached via a temp future-dated session, restored). Then brought **prov:sweep to GREEN** (was 7 issues): enrolled 5 long-unregistered matt-inspired primitives + reclassified `FeedPost` as a non-stampable pass-through adapter. All conv work committed + pushed per-route (code `672b5e43`, `9f812138`; docs `1f3c2e3`, `6394f4c`); this r-end adds the bookkeeping commit.

## Completed

- [x] [RG-SESSIONS] #19 — `/session/[id]` swept, ☑ Swept, browser+screenshot verified (incl. early/prepare composer), committed (code 672b5e43, docs 1f3c2e3).
- [x] Composer verification gap closed (DOM-truth `gap-12`/`pl-12` = 12px; docs caveats updated; docs 6394f4c).
- [x] prov:sweep → GREEN (5 primitives enrolled + FeedPost reclassified; code 9f812138).

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conf OUT) · [RG-AUTH] #4 · [RG-COMMS] #9 · [RG-DISCOVER] #10 · [RG-MOD] #20 · [RG-PUBLIC] #21 (conf OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Conformance foundations:**
- [ ] [PALETTE-FDN] #26 · [SPACING-4PX-SWEEP] #28 · [SWEEP-SPACING-GREP] #29 · [LAYOUT-SG] #18

**Tier-2 cross-cutting:**
- [ ] [SEGPILL] #31 — converge 3 inline All/Unread filter rows (SmartFeed + messages + notifications) onto SegmentedPills/RoleTabBar; RoT met; touches 2 swept routes (backward-pointer re-glance).
- [ ] [XCUT-BACKREF] #30 — re-glance already-swept routes after cross-cutting extractions.

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #23 · [COURSES-FIXES] #24 · [PROV-STAMP-GAPS] #22 · [STALE-TESTS] #27 · [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #11 · [E2E-GATE] #12 · [ICN-NS] #13 · [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [V217-WATCH] #16 · [MEM-PRUNE] #17 · [M4-ZGUARD] #25

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (blocked by #5) · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-COMMS] · #10 [RG-DISCOVER] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [ICN-NS] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [V217-WATCH] · #17 [MEM-PRUNE] · #18 [LAYOUT-SG] · #20 [RG-MOD] · #21 [RG-PUBLIC] · #22 [PROV-STAMP-GAPS] · #23 [HOME-FIXES] · #24 [COURSES-FIXES] · #25 [M4-ZGUARD] · #26 [PALETTE-FDN] · #27 [STALE-TESTS] · #28 [SPACING-4PX-SWEEP] · #29 [SWEEP-SPACING-GREP] · #30 [XCUT-BACKREF] · #31 [SEGPILL]

## Key Context

- **RG-SESSIONS Swept** — RTMIG-4 group tally: RG-HOME ✅, RG-COURSES ✅, RG-PROFILE ✅, RG-MESSAGES ✅, RG-NOTIFS ✅, **RG-SESSIONS ✅ (new)**. Remaining in-scope single/small groups: RG-COMMS (2), RG-DISCOVER (3; /feed+/feeds likely retire), RG-MOD (1), RG-AUTH (7). Blocked: RG-PUBPROF (#5), RG-WORKSPACES (client). Out-of-scope structural-only: RG-ADMIN, RG-PUBLIC.
- **`StarRating` is now the canonical rating primitive** (`ui/StarRating.tsx`, registered). Interactive (integer value + internal hover-preview, `onHoverChange` for an external label) + `readOnly` fractional-fill (half-star via width-clipped overlay) + `showValue`; sizes sm(14px)/md(20px)/lg(30px); on=`text-star`, off=`text-border-default`. Future rating widgets → adopt it. Admin star displays (SessionsAdmin/SessionDetailContent) are conformance-OUT but could adopt the readOnly mode when those are swept.
- **prov:sweep is GREEN for the first time in several convs.** The bidirectional contract: a file that stamps `data-prov-name` must be registered, AND a registered file must stamp. Pure pass-through adapters (return another component directly, no own DOM root — e.g. FeedPost→SocialPost) must NOT be registered; resolve their `Provenance: UNMARKED` drift by reclassifying the note (drop the keyword). See `feedback`/Learnings.md.
- **getComputedStyle lies on `color` under a live `transition`** — for painted star/colour verification use a screenshot; for geometry use DOM. (DOM-truth-over-screenshots is geometry-only.)
- **[SEGPILL] #31 still RIPE** — the All/Unread filter row is hand-rolled identically on SmartFeed (Home), ConversationList (/messages), NotificationCenter (/notifications). Adopt-existing onto `form/SegmentedPills.tsx` / `RoleTabBar.tsx`, then re-glance the 2 swept consumers ([XCUT-BACKREF]).
- **MEMORY.md at ~90% of the SessionStart cap** → [MEM-PRUNE] #17 still open (the 🔴 alert fired again at this conv's r-start; not addressed).
- **Conv-308 commits (all pushed):** code `672b5e43` (RG-SESSIONS sweep) + `9f812138` (prov:sweep green); docs `1f3c2e3` (RG-SESSIONS Swept) + `6394f4c` (composer verified). Plus this r-end bookkeeping commit + counter-start `65829a5`. Code on `jfg-dev-14`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
