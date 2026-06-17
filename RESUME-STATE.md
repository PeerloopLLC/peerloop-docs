# State — Conv 295 (2026-06-17 ~14:16)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Route-sweep conv (RTMIG-4 / RG-COURSES). Swept route 2 `/course/[slug]/[...tab]` (assess-only — established the **hard-hex classification precedent**: a 4-swap attempt was reverted after the hexes proved to be Matt primitive-signature / convention values, not strays). Assessed route 3 `/book` but left it **blocked** on a newly-scoped colour foundation. The recurring "Tailwind-default colour with no Matt token" problem was investigated against the style guide and turned into **[PALETTE-FDN] #31**: derive Matt-anchored colour scales + add warning/error hues + write a sweep policy. Also promoted `vernacular.md` → git-tracked `VERNACULAR.md`. No code changes (route work was assess-only / reverted — code tree clean).

## Completed

- [x] `/course/[slug]/[...tab]` (RG-COURSES route 2/5) — ☑ Swept (assess-only; precedent set; EnrollButton dropped — already Matt here)
- [x] `/course/[slug]/book` (route 3) — ASSESSED (blocked on PALETTE-FDN)
- [x] Promoted `vernacular.md` → git-tracked `VERNACULAR.md` (+ CLAUDE.md / DOC-DECISIONS.md pointers)
- [x] Colour-foundation decision + [PALETTE-FDN] #31 created (and Opus-tagged)
- [x] Ledger: AnalyticCount adopt/extend + TagPill candidates; #f6f6f6 + no-image-color + (route-3) bg-gray-100/status-colour cross-cutting rows

## Remaining

**Next focused conv:**
- [ ] [PALETTE-FDN] (#31) [Opus] Derive Matt-anchored gray/green/blue ramps from his anchor values + add warning(amber)/error(red, seed carmine-red) hues; wire tokens + @theme; rewrite style-guide §05 with a Tailwind-default sweep policy (map-or-flag, never piecemeal); amend the Conv-181 only-Matt-variables rule per Conv-289; then migrate 60–115 files. **Gates RG-COURSES routes 3–5.**

**Route sweep (RTMIG-4) — RG-COURSES tail gated on PALETTE-FDN:**
- [ ] [RG-COURSES] (#10, in_progress) 2/5 swept. Routes 3–5: `/book` (assessed, blocked), `/precheckout`, `/success` — all likely hit PALETTE-FDN.
- [ ] [RTMIG-4] umbrella · [RG-ADMIN] · [RG-PUBPROF] [Opus] (blocked by ROLE-SEMANTICS) · [RG-AUTH] · [ROLE-SEMANTICS] [Opus] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER] · [RG-WORKSPACES] [Opus] ⛔client · [RG-MESSAGES]/[RG-NOTIFS]/[RG-SESSIONS]/[RG-MOD]/[RG-PUBLIC] (deferred)
- [ ] [OLD-PORTED-CLEANUP] (incl. EnrollButton legacy-path strip after /old deletion) · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [PROV-STAMP-GAPS] · [HOME-FIXES] · [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW]) · [M4-ZGUARD] · [RSTART-DIFFGATE]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #9 [RG-PROFILE] · #10 [RG-COURSES] (in_progress, 2/5) · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES] · #29 [M4-ZGUARD] · #30 [RSTART-DIFFGATE] · #31 [PALETTE-FDN] [Opus]

## Key Context

- **Hard-hex classification precedent (Conv 295, route 2):** before swapping a hard-hex during a sweep, classify it — **primitive-signature** (e.g. `#f6f6f6`+`rgba(88,77,244,.14)` = `AnalyticCount` Default) → adopt the primitive; **convention/recurring** (e.g. `#1f2937` = shared no-thumbnail fallback) → tokenize app-wide once; only **true strays** get a per-route swap. Run the remaining-site grep + registry read DURING assessment, not after. Recorded in `plan/route-migration/tier2-primitive-ledger.md` + README route-2 note.
- **[PALETTE-FDN] is the colour foundation** that unblocks every stateful route. Matt's palette = anchor points (3 grays, 3 greens, blues), NO status hues; Conv-289 CC-ownership supersedes the Conv-181 "only-Matt-variables" rule for the blank categories (status, neutrals). Approach approved: Matt-anchored derived scales + warning/error.
- **`VERNACULAR.md`** now git-tracked at docs root (was `.scratch/vernacular.md`). CLAUDE.md §Vernacular Glossary updated.
- **Code repo `jfg-dev-14`, clean** — no code changes this conv.
- **MEMORY.md ~84%** of SessionStart cap → **[MEM-PRUNE] #19** still live (run `/r-prune-memory`).
- **Commits this conv:** docs only (Extract/Learnings/Decisions, ledger, README, PLAN PALETTE-FDN row, VERNACULAR.md, CLAUDE.md, DOC-DECISIONS.md). Code repo nothing to commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
