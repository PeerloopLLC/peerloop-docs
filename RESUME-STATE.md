# State — Conv 300 (2026-06-18 ~16:12)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Ran **[HOME-VERIFY]** end-to-end: browser-verified Home (member + visitor, DOM-truth) and brought **RG-HOME style-guide conformance to COMPLETE (8/8)**. Along the way: decided the **@matt-source hybrid-conformance policy** (tokenize where exactly equivalent, keep token-less specs as recorded exceptions) that now governs the rest of the route sweep; tokenized 3 shared `@matt-source` primitives (SocialPost/EntityPill/IconLabelChip); minted 2 new dense-bold type tokens (`text-body-small-bold`/`text-body-default-bold`) to close the AnalyticCount gap + realize the phantom `text-body-default-bold`; confirmed AppNavbar doesn't leak onto Matt routes; phantom-token grep clean. Also fixed Obsidian visibility for the scratch workspace (real `_scratch/` + `.scratch` compat symlink). 6 commits (4 + the 2 agent/r-end commits land in Step 6). All five HOME-VERIFY follow-ups (#33–#37) closed.

## Completed

- [x] [HOME-VERIFY] #33 — RG-HOME conformance verified + flipped 8/8 (DOM-truth, member Sarah/Amanda + visitor)
- [x] [STICKYBAR-CONF] #36 — StickySignupBar (`marketing/StickySignupBar.astro`) confirmed conformant, no edits
- [x] [NAVBAR-LEAK] #37 — confirmed legacy AppNavbar does NOT render on Matt routes (DOM: AppNavbar=0, Sidebar=1)
- [x] [TYPO-CTA-TOKEN] #35 — minted body-small-bold (12/600) + body-default-bold (14/600); migrated AnalyticCount + ReviewsTab; documented §9.2a
- [x] [TYPO-PHANTOM] #34 — grep clean, zero phantom text-body-* tokens
- [x] Obsidian scratch visibility — `_scratch/` real dir + `.scratch` compat symlink (machine-local; re-flip per machine)

## Remaining

**[TYPO-FDN] #31 (IN PROGRESS — conformance rides the RTMIG-4 sweep):**
- [ ] [TYPO-FDN] /courses conformance backfill — the ~11 /courses ledger components (SectionTitle, CoursesFilters, RecommendedCourses, 5 course-cards, CoursesRoleTabs, CoursesCatalog). RG-HOME is now the template.
- [ ] [SPACING-4PX-SWEEP] #32 — legacy `h-4 w-4`/`p-4` 4px-collapse sweep
- [ ] [PALETTE-FDN] #29 — Colour axis of the conformance gate

**Route sweep (RTMIG-4 umbrella — RG groups, mostly mechanical now the policy is set):**
- [ ] [RTMIG-4] #1 · [RG-ADMIN] #2 (conformance OUT) · [RG-AUTH] #4 · [RG-PROFILE] #9 · [RG-COMMS] #10 · [RG-DISCOVER] #11 · [RG-MESSAGES] #20 · [RG-NOTIFS] #21 · [RG-SESSIONS] #22 · [RG-MOD] #23 · [RG-PUBLIC] #24 (conformance OUT)
- [ ] [RG-PUBPROF] #3 [Opus] (blocked by #5) · [ROLE-SEMANTICS] #5 [Opus] · [RG-WORKSPACES] #8 [Opus] ⛔client

**Follow-ups / debt:**
- [ ] [HOME-FIXES] #26 · [COURSES-FIXES] #27 (now also carries ReviewsTab raw hex colours `#584df4`/`#f6f6f6`/rgba — /courses Colour backfill) · [PROV-STAMP-GAPS] #25 · [STALE-TESTS] #30
- [ ] [OLD-PORTED-CLEANUP] #6 · [PREFLIP-WT] #7 · [E2E-MIG] #12 · [E2E-GATE] #13 · [ICN-NS] #14 · [TZ-AUDIT] #15 [Opus] · [DOCGEN-SPEC] #16 · [V217-WATCH] #17 · [MEM-PRUNE] #18 · [LAYOUT-SG] #19 · [M4-ZGUARD] #28

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] · #10 [RG-COMMS] · #11 [RG-DISCOVER] · #12 [E2E-MIG] · #13 [E2E-GATE] · #14 [ICN-NS] · #15 [TZ-AUDIT] [Opus] · #16 [DOCGEN-SPEC] · #17 [V217-WATCH] · #18 [MEM-PRUNE] · #19 [LAYOUT-SG] · #20 [RG-MESSAGES] · #21 [RG-NOTIFS] · #22 [RG-SESSIONS] · #23 [RG-MOD] · #24 [RG-PUBLIC] · #25 [PROV-STAMP-GAPS] · #26 [HOME-FIXES] · #27 [COURSES-FIXES] · #28 [M4-ZGUARD] · #29 [PALETTE-FDN] · #30 [STALE-TESTS] · #31 [TYPO-FDN] (in_progress) · #32 [SPACING-4PX-SWEEP]

## Key Context

- **@matt-source conformance policy (DECIDED Conv 300)** governs the rest of the sweep: tokenize `@matt-source` primitives where a role token is **exactly equivalent** (zero visual change); keep genuinely token-less values as **recorded exceptions**; small line-height *corrections* toward §09 count as conformance. SoT: `plan/typo-fdn/migration-ledger.md` § @matt-source policy + `docs/decisions/05-ui-ux-components.md`.
- **3 recorded exceptions (do NOT flag as violations):** SocialPost author `text-black` (#000, no role token — don't map, would lighten app-wide); CommunityAnchor 🧠 emoji `text-[20px]`; (CTA `font-semibold` now RESOLVED via the new -bold tokens).
- **New tokens:** `text-body-small-bold` (12/600/lh-1) + `text-body-default-bold` (14/600/lh-1), CC-minted, §9.2a. The `-bold`=600 pattern is now complete across the dense regime.
- **RG-HOME conformance COMPLETE 8/8** — the template for the remaining in-scope RG sweeps. `/courses` backfill (3/23 → ~11 left) is the next conformance work.
- **Obsidian scratch:** `_scratch/` is the REAL dir, `.scratch` is a symlink → it. Both gitignored, machine-local. Do NOT delete the `.scratch` symlink or flip back. Re-flip on M4: `mv .scratch _scratch && ln -s _scratch .scratch`. See `memory/project_scratch_obsidian_symlink`.
- **Tailwind v4 gotcha:** `space-y-*` = margin-**bottom**; verify rhythm via rendered gaps, not computed marginTop.
- **`09-typography.md` is docs-repo-owned** via symlink (code-repo path is a symlink) — design-system doc edits land in the docs commit.
- Code on `jfg-dev-14`. Conv-300 commits (pre-r-end): docs `23234a1`/`7247507`/`40f8f4b`; code `e8a1167b`/`ea9cce83`. The r-end commit (agent outputs: Learnings/Decisions/PLAN/decisions-routing/TIMELINE) lands in Step 6.
- MEMORY.md still ~85%+ of SessionStart cap (2 entries added this conv) → [MEM-PRUNE] #18 live.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
