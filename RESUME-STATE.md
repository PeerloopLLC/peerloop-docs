# State — Conv 239 (2026-06-04 ~13:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Session-family conv. **Graduated `/session/[id]` `@stand-in` → `@matt-inspired` via a MERGE** (new Matt phase-out posture): the full legacy join/rate/cancel state machine is preserved + re-skinned to Matt tokens, with Matt's "Session Prepare" surface (checklist · notes · chat) adopted as **static** via new `SessionPrepare.tsx`; `SessionJoinableView` folded in + deleted. 5 gates green (suite 6447); browser-verified as David (early state) and **caught + fixed an SSR/client TZ hydration bug** (`toLocaleTimeString` → `timeZone:'UTC'`). Locked two decisions: **Matt phase-out** (pages default `@matt-inspired`, page-by-page, function-first, never lose `/old` function) and the **two-tier course Journey** (one-time gates bracketing a recurring Sessions progress-cluster), spawning [JOURNEY-LOOP] #44 + [BOOK-WIZARD-MATT]/[CALENDAR2] #45.

## Completed

- [x] [SESS-GRAD] `/session/[id]` graduated `@stand-in` → `@matt-inspired` — MERGE: full legacy state machine + Matt tokens + static Prepare surface (`SessionPrepare.tsx`); `SessionJoinableView` deleted; page widened `max-w-5xl`; 5 gates green (6447); browser-verified; TZ hydration bug fixed
- [x] Matt phase-out strategic decision recorded (decision-log 2026-06-04 + memory `project_matt_phaseout_inspired_default.md`)
- [x] Two-tier course Journey designed + decided + recorded (decision-log + `plan/enroll-nav/README.md § EVOLVED`); scoped into [JOURNEY-LOOP] (#44, 7 steps) + [CALENDAR2] (#45). Supersedes ENROLL-NAV #5 + Conv-235 Sessions-in-Explore.

## Remaining

New this conv:
- [ ] [JOURNEY-LOOP] Two-tier course Journey — gates + Sessions progress-cluster [Opus]; scope in `plan/enroll-nav/README.md § EVOLVED`; reuses `moduleInfo`, no schema; SubNav progress-sub-group is the novel render; overlap-dedup open
- [ ] [CALENDAR2] Matt restyle of the booking wizard ([BOOK-WIZARD-MATT], PLAN DEFERRED #27); `/book` stays `@stand-in`

Carried-forward backlog:
- [ ] [COMM-TAG-FILTER] Build real Commons tag filtering [Opus] · [CT-RESTYLE] · [COMM-LEAVE] · [MOD-TOGGLE]
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages (Session family `/book` deferred to CALENDAR2; ~4 other routes) · [MATT-EXEC-EXT] · [MMP-PH5] · [MATT-EXEC-GRD] · [CH-VARIANTS] · [SUCCESS-COMMUNITY] · [MFRD-LOOKUP] · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM]
- [ ] [RTMIG-TIER] · [RTMIG-4]
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]
- [ ] [PROV-SWEEP-DEBT] · [DASH-COURSES-LINK]

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] [Opus] · #2: [CT-RESTYLE] · #3: [COMM-LEAVE] · #4: [MOD-TOGGLE]
- [ ] #5: [MATT-EXEC-PG2] · #6: [MATT-EXEC-EXT] · #7: [MMP-PH5] · #8: [MATT-EXEC-GRD] · #9: [CH-VARIANTS] · #10: [SUCCESS-COMMUNITY] · #11: [MFRD-LOOKUP] · #12: [PRECHECKOUT-MATT-CONFIRM] · #13: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #14: [RTMIG-TIER] · #15: [RTMIG-4]
- [ ] #16: [PRIM-MATCH-INDEX] · #17: [PRIM-DOC] · #18: [PRIM-ORPHAN-ACK] · #19: [TXTBTN] · #20: [PROFILE-PRIM-SWEEP] · #21: [PRIM-COURSES-DISMISS]
- [ ] #22: [ICN-NS] · #23: [HOWTOREG-ICN] · #24: [ASSET-SWEEP-GATE]
- [ ] #25: [E2E-MIG] · #26: [E2E-GATE]
- [ ] #27: [SHOWMORE] · #28: [SELECT-AUDIT]
- [ ] #29: [ADMIN-REDIRECT-BLANK] [Opus] · #30: [SETTINGS-WATCHER] · #31: [BAK-ARTIFACT]
- [ ] #32: [PREFLIP-WT] · #33: [REND-DEDUP-GUARD] · #34: [MEM-CAP] · #35: [GARBLE-WATCH]
- [ ] #36: [API-USERS-DRIFT] · #37: [DOCS-ROUTES-STALE] · #38: [PREPLAN-CHECKOUT-NOTE]
- [ ] #39: [HOME-FEEDSHUB-VIS] · #40: [DOM-FIRST]
- [ ] #41: [PROV-SWEEP-DEBT] · #42: [DASH-COURSES-LINK]
- [ ] #44: [JOURNEY-LOOP] [Opus] · #45: [CALENDAR2]

## Key Context

- **Matt phase-out is now standing posture:** pages default `@matt-inspired`, decided page-by-page, function-first, never lose `/old/*` function; Matt-redesign-omits-behavior → MERGE + static-fill no-schema surfaces. Memory `project_matt_phaseout_inspired_default.md`; decision-log 2026-06-04.
- **`/session/[id]` is `@matt-inspired`** (`622:17884`). The Prepare surface (checklist/notes/chat in `SessionPrepare.tsx`) is **STATIC** — no schema; composers decorative. `/book` stays `@stand-in` → [CALENDAR2].
- **Next build [JOURNEY-LOOP] #44 [Opus]:** two-tier Journey — one-time gates (Enroll/Payment/Certificate) bracketing a recurring **Sessions progress-cluster** ("X of N"); move My Sessions Explore→Journey; Cert gates on completed==total. Reuses `moduleInfo`/`getBookingEligibility` — **no schema**. Novel piece = teaching `SubNav.astro` a progress-bearing sub-group. **Open:** overlap dedup (wizard's "Book Next/all-booked" vs Journey cluster). 7-step scope in `plan/enroll-nav/README.md § EVOLVED`.
- **New pattern:** UTC-anchored time in client islands (`timeZone:'UTC'`) to avoid SSR/client hydration mismatch — extends `formatDateUTC`.
- **Mnemonic:** the booking-wizard restyle is `[CALENDAR2]`/`[BOOK-WIZARD-MATT]` (NOT `[CALENDAR]`, which is the existing platform-wide calendar block `plan/calendar/`).
- prov:sweep still RED ([PROV-SWEEP-DEBT] #41, not in 5-gate baseline); MEMORY.md near auto-load cap ([MEM-CAP] #34 — a new memory was added this conv).
- **Branch state (pre-commit):** code + docs changes will be committed in Step 6; code on `jfg-dev-13-matt`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
