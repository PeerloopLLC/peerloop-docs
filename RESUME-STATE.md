# State — Conv 237 (2026-06-03 ~12:24)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built the `/community/[slug]` detail-route family (approach C — full decompose of the legacy 628-line `CommunityTabs` island) — the 3rd `[...tab].astro` + `_*-tabs.ts` + `SubNav` family after /course and /profile. Empty segment = a NEW About overview (decision B), backed by real data via a new `bio` loader join. The Commons is now pinned on /communities (cover image + link), fulfilling previously-404 home/feed targets. All 5 gates green + 8 browser checks. (Earlier in the conv: staging code-only deploy + staging password fix + enrollment recon — see checkpoint note.)

## Completed

- [x] [COMM-DETAIL] /community/[slug] family built + browser-verified (5 gates: tsc/astro check/lint/build/suite 6460)
- [x] `bio` join added to `fetchCommunityDetailData` (About "Meet the host")
- [x] The Commons pinned card on /communities (cover image + link)
- [x] Stale "404-honest until ported" comments corrected (communities.astro, CommunityCatalogCard, FeedDirectoryCard)
- [x] Route docs regenerated (both repos) + url-routing.md driftCheck fix (docs agent)
- [x] Phase 1: staging deploy `c8945613` + staging password fix + enrollment recon

## Remaining

- [ ] [COMM-TAG-FILTER] Wire real Commons tag filtering — legacy chips were decorative (TownHallFeed never consumed `tag`); add tag support to TownHallFeed + Commons query, render chips inside the Feed tab body (NOT the SubNav)
- [ ] [FEED-DETAIL] [Opus] Port /old/feed/* → root /feed/[slug] (next conv) — mirror the COMM-DETAIL playbook; the 4th [...tab].astro family. Watch the 3-surface distinction: /feed (singular, personal/aggregated — NO route yet, 404) vs /feeds (plural directory, built) vs /community/the-commons/feed (townhall)
- [ ] Tier-2 Matt-token restyle of CommunityMembersTab + CommunityResourcesTab (carry legacy secondary-/primary- tokens forward for now)
- [ ] Wire the community "Leave" button (dead/no-handler in legacy — rendered faithfully)
- [ ] Click-test the moderator toggle with a creator/admin session (render-verified only)

## TodoWrite Items

- [ ] #2: [COMM-TAG-FILTER] Wire real Commons tag filtering (was decorative)
- [ ] #3: [FEED-DETAIL] Port /old/feed/* → root /feed/[slug] (mirror COMM-DETAIL) [Opus]

## Key Context

- **The triad pattern** (now 3 families): `pages/X/[slug]/_X-tabs.ts` (build`XTabs(slug, opts)` returning `{label, href, icon}[]`) + `[...tab].astro` (empty segment = overview default, `VALID_TABS` guard → redirect unknown to bare, per-tab data load, `SubNav slot="sub-nav"`). /profile is the `@matt-inspired`-no-Figma precedent; FEED-DETAIL will be #4.
- **The Commons ≡ TownHall:** system community `comm-the-commons` (is_system=1, all auto-join, creator NULL); `/api/feeds/townhall` hardwired to `the-commons`. On /community/the-commons: no Courses tab, About shows only 2 blocks (host + learning-paths hidden).
- **SubNav holds destinations only** — actions (Manage/Leave) → header CTAs; filters (`?tag=`) → tab body; back-nav → breadcrumb.
- **New files:** `src/pages/community/[slug]/{_community-tabs.ts,[...tab].astro}`, `src/components/community/{CommunityMembersTab,CommunityResourcesTab}.tsx`. `/old/community/*` left LIVE (no-delete-until-vetted).
- **Branch state (pre-commit):** code + docs changes will be committed in Step 6; code on `jfg-dev-13-matt`.
- **Decision routed** to `docs/decisions/11-new-routing.md` (COMM-DETAIL routing decisions).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
