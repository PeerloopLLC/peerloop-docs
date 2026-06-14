# State — Conv 282 (2026-06-14 ~14:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Terminology/doc-drift cleanup conv. Picked `[SYS-RENAME-COSMETIC]` #31 over RTMIG-4 as a warm-up; it grew into a careful three-part job: (1) safe-subset code rename (`townhall`→`systemFeed` branding only, **preserving** the live Stream-group value `SYSTEM_STREAM_GROUP='townhall'`) across 16 `src/` files + 3 migration comments; (2) a full two-repo audit of remaining "The Commons"/"townhall"; (3) factual-drift correction of reference docs that the audit surfaced — including **3 stale auto-join statements** (auto-join was retired by SYS-RENAME) in ROLES/DB-API/google-oauth + a seed-file comment. 18 code files + 13 doc files. `tsc`/`eslint` clean. No PLAN block advanced beyond the [SYS-RENAME-COSMETIC] task close-out.

## Completed

- [x] `/r-start` Conv 281→282 (31 tasks transferred, 0-diff memory sync)
- [x] [SYS-RENAME-COSMETIC] #31 — safe-subset code rename (A+B+D, 16 src files) + 3 migration comments + 13 reference-doc factual/naming corrections; full audit with disposition. Running code now reads "system feed" except the 3 intentional keepers (live Stream group + historical notes).

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production (do not build for MVP)
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (wants old-vs-new dashboard comparison)
- [ ] [RTMIG-4] #3 [Opus] — main unblocked loop: ~89 legacy `/old/*` → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED cluster)
- [ ] [ICN-NS] #9 · [E2E-MIG] #10 · [E2E-GATE] #11 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23 · [NUDGE-TC-V2] #24 · [TW-V4] #25 · [TEST-FILE-COUNT] #26 · [PLAN-RENUM] #27
- [ ] [COMMONS-DATE] #28 · [DISCCARD-DEL] #29 · [TESTDOC-DRIFT] #30
- [ ] **(new, low-value)** route-map.generated.ts `/community/the-commons` — **CONFIRMED survived Step 5c regen this conv**, so the route-map generator (`scripts/route-matrix.mjs` / `route-api-map.mjs`) has a hardcoded `the-commons` literal (likely a `LITERAL_SLUG_ROUTES`-style normalization list). Fix the literal → `system`; fold into [TEST-FILE-COUNT]/[TESTDOC-DRIFT] or a generator fix
- [ ] **(new, low-value)** ~20 test-file cosmetic `townhall` leftovers (var-names/`it()` labels/comments) + `matt-inspired-registry.ts:262` note — deferred branding-only cleanup; could fold into [E2E-MIG] or a test-naming pass

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] (DEFERRED) · #2 [ROLE-STUDIOS] [Opus] (BLOCKED) · #3 [RTMIG-4] [Opus] · #4–#30 (see Remaining for the full code list)

## Key Context

- **The "rename branding, preserve live values" rule** is the governing lesson: `townhall` is simultaneously stale branding AND the live Stream.io feed-group value. Keepers that must NOT be renamed: `src/lib/system-feed.ts:29` `SYSTEM_STREAM_GROUP='townhall'`, `scripts/seed-feeds.mjs` `feedGroup:'townhall'`, `tests/lib/promotion.test.ts:137` `streamGroup:'townhall'`, and `townhall:main` Stream addresses in docs. Stream groups are dashboard-declared, not write-creatable — renaming 500s at runtime.
- **Reference docs are now clean** — every remaining `townhall`/`The Commons` mention in `docs/reference/` + GLOSSARY is intentional (explains the rename / Stream-group nuance / dated changelog / accurate Stream address). Archival docs (sessions/decisions/RFC) correctly frozen.
- **Migration-comment edits are safe** — wrangler tracks D1 migrations by filename (no content hash), no drizzle journal exists; the earlier "risky" framing was wrong (it was low-value churn, not risk).
- **No baseline run claimed beyond tsc+eslint** (cosmetic-only changes; no `.astro`/schema/test behavior touched). Full 5-gate suite NOT run this conv.
- **Next** = [RTMIG-4] #3 is the main unblocked loop; ROLE-STUDIOS still blocked by client.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
