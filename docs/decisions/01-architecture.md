> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 1. Architecture & Design (Highest Impact)

### HOME-FEED-MERGE Phase 6: Server-Built Auth-Branched CTA URLs; Destination-Level Signup Intent
**Date:** 2026-06-11 (Conv 268)

Home-feed discovery CTAs (sample-post `DiscoveryCard` + `SuggestionCard`, both prop-less dumb renderers fed by the prop-less `SmartFeed` island) branch on viewer auth **server-side**: a new shared helper `buildDiscoveryCtaUrl(feedType, feedId, via, viewerAuthenticated)` (`src/lib/smart-feed/cta.ts`) returns a direct entity link for authed viewers and `/signup?redirect=<encoded entity>` (`?via=` preserved inside) for visitors. `getSmartFeed` computes `viewerAuthenticated = Boolean(userId)` and threads it into `cardToItem` + `enrichCandidates`/`toEnrichedCandidate` (default `false` = visitor, fail-safe). The signup behavior is **destination-level** — visitors land on the entity page post-signup with the now-authed action button — **not** action-level (`&action=join|enroll` auto-perform was rejected).

**Rationale:** Branching in the server payload (not threading `isAuthenticated` into the island or reading the `localStorage` user-cache client-side) keeps the cards dumb, keeps visitor `ctaUrl` identical across all visitors so caching stays valid, and sidesteps the [NUDGE-CACHE-FLASH] first-paint-staleness class entirely — the orchestrator already holds `userId: string | null`. Destination-level matches the design's "return them to X" phrasing AND the established `EnrollButton` `?redirect=` pattern (not novel per §Critical Rule); action-level is hostile because course enroll routes through Stripe checkout and auto-redirecting a fresh signup to a payment page is wrong. The intent-preserving `?redirect=` round-trip already existed end-to-end (`signup.astro` → `AutoOpenAuthModal` → `handleAuthSuccess`); the deliverable was just making the feed CTAs use it.

**Consequences:** One shared helper for both ctaUrl sites (anti-drift); no client component edit, no auth prop into the island. CTA label unchanged for visitors (intent expressed; honesty from the "from X · not joined" badge). Authed "one-click join/enroll from discovery" noted as a deferred future enhancement. Completes the HOME-FEED-MERGE build (all 7 phases). `src/lib/smart-feed/cta.ts` (NEW), `index.ts`, `enrichment.ts`; `tests/lib/smart-feed-cta.test.ts`.

### Deployment Target: Cloudflare Workers (not Pages)
**Date:** 2026-04-13 (Conv 114)

Peerloop deploys to Cloudflare Workers with Static Assets, not Cloudflare Pages. The entire app — SSR pages, API routes, and static bundles — ships as a single Worker at `peerloop-staging.<account>.workers.dev` (staging) and `peerloop` (production).

**Rationale:** `@astrojs/cloudflare@13` (required by Astro 6, adopted in Conv 104 PACKAGE-UPDATES block) dropped Pages support — the adapter now emits a Workers-format entrypoint (`dist/server/entry.mjs`) plus static assets (`dist/client/`). Conv 113 attempted a postbuild patching workaround to keep deploying to Pages; the build passed but CF Pages silently skipped the Worker entrypoint (`"No functions dir at /functions found. Skipping."`), so every SSR route 404'd. The postbuild patch was removed in Conv 114 and the deployment target moved to Workers. Astro maintainer confirmed: *"Astro 6 doesn't support Pages, because the Cloudflare Vite plugin does not."* ([Issue #16107](https://github.com/withastro/astro/issues/16107)).

**Consequences:**
- Root `wrangler.toml` no longer carries `main`/`[assets]` — those are emitted by the adapter at build time into `dist/server/wrangler.json`
- Environments are selected **at build time** via `CLOUDFLARE_ENV`, not at deploy time via `--env` — deploy scripts prefix both `CLOUDFLARE_ENV` and `ENVIRONMENT`
- No more Git-push auto-deploy (CF Pages feature); deploys are manual via `wrangler deploy` until the follow-up GitHub Actions workflow ships (DEPLOYMENT block)
- Preview/staging URL is now `peerloop-staging.<account>.workers.dev` instead of `staging.peerloop.pages.dev` — hard-coded references updated in `src/lib/version.ts` (replaced `CF_PAGES_BRANCH` detection with build-time `__ENVIRONMENT__` constant) and `tests/helpers/machine.ts` (dropped `isCloudflarePages` helper)

### `/feeds` is the Discover Destination; `FeedsHub` Composite Reserved for `/` Landing
**Date:** 2026-05-31 (Conv 224)

The Matt `/feeds` route is the Discover "Feeds" destination — a discovery grid plus a role-aware Your-Feeds directory, built as ONE self-contained client island (role-tab bar is a controlled child), mirroring the `/communities` and `/members` siblings. The pre-existing unmounted `FeedsHub` composite is deliberately kept OFF `/feeds` and reserved for the `/` landing page (visitor + personalized-logged-in) per Matt. `/feeds` was removed from middleware `PROTECTED_EXACT` and is now public; "Your Feeds" stays server-gated inside the page; legacy `/old/feeds` still self-guards.

**Rationale:** Matt wants FeedsHub as the `/` landing first-visitor surface, and `/` will accrete more client content over time. Keeping `/feeds` composite-free makes it a clean Discover sibling and avoids an orphaned discovery grid. Feeds data is fully client-side (`useCurrentUser().getFeeds()` + `/api/feeds/discover`, no SSR), so `/feeds` needs no cross-island event bus like `/communities`' three-island shell. **Conv 230 ([HOME-FEEDSHUB], #28): the logged-in `/` landing mount shipped** — see `FeedsHub Mounted on "/" via a Standalone Panel, SSR Auth-Gated` below; the visitor variant is deferred (#32).

### FeedsHub Mounted on "/" via a Standalone Panel, SSR Auth-Gated
**Date:** 2026-06-01 (Conv 230)

The `/` landing FeedsHub surface is mounted as a **standalone** `src/components/feed/FeedsHubPanel.tsx` (`@matt-inspired`), which mirrors `FeedsDirectory`'s `AllTabContent` (a Matt-styled FeedsHub minus role tabs) rather than extracting a view shared with the shipped `/feeds` page or reusing `FeedsDirectory` as-is. Auth gating is **SSR** (`getSession` → `isAuthenticated` in `index.astro`, mirroring `feeds.astro`), not the client-side reveal `index.astro` uses for the Messages card: logged-in → "Your Feeds" (`FeedsHubPanel`, `client:only`) replacing the Recent-Activity empty state; visitor keeps current behaviour (deferred to #32). The new component is registered in `scripts/matt-inspired-registry.ts` (prov:sweep flags UNTRACKED otherwise).

**Rationale:** Duplicating ~150 lines into a standalone panel gives **zero blast radius on the shipped `/feeds` surface** — extracting a shared view would touch `FeedsDirectory`, and reusing it as-is would drag role tabs onto Home (off-spec). A whole-section swap (feed ⇄ Recent Activity) wants SSR branching to avoid hydration flash / layout shift; `client:only` then defers only the feed *data* fetch. This insertion was treated under full RTMIG/Tier-1 port discipline (field-by-field legacy→new parity) despite being a section-level insertion, not a new route.

### SSR Pages Call Typed Loader Functions Directly; No SSR Self-Fetch
**Date:** 2026-04-14 (Conv 116)

Astro SSR pages MUST load data via typed loader functions in `src/lib/ssr/loaders/*.ts`, not via `await fetch(new URL('/api/...', Astro.url.origin))`. API endpoints that serve the same data are thin wrappers (~30-50 lines) that call the same loaders and map `SSRDataError → e.httpStatus`. One implementation, two call sites.

**Rationale:** On CF Workers + Static Assets, SSR self-fetch hits the Assets layer and 404s without falling through to the Worker — `run_worker_first` only affects external edge routing, not Worker-internal subrequests. Beyond the regression: self-fetch costs ~2× SSR latency, forces manual cookie forwarding, breaks end-to-end type safety, and creates silent failure modes. The loaders pattern already existed for about/courses/creators/home/static/teachers/verify — Conv 116 closed the gap by adding `communities.ts` and refactoring 8 community/discover pages + 3 API handlers.

**Consequences:**
- New `src/lib/ssr/loaders/communities.ts` (~570 lines, 3 loaders)
- API handlers reduced ~750 LOC net (161/283/206 → ~50 lines each)
- `SSRDataError` codes extended from 4 to 6 (added `UNAUTHORIZED`, `FORBIDDEN`) with `httpStatus` mapping to 401/403
- Page pattern: catch `SSRDataError`, map `NOT_FOUND`/`INVALID_PARAMS` → `/404`, `FORBIDDEN` → `/discover/communities`, others → fetchError banner
- API pattern: catch `SSRDataError`, return `e.httpStatus` with JSON body
- `CommunityCreator` split into `CommunityCreatorSummary` (list shape, no avatar) + `CommunityCreator extends Summary` (detail shape, with avatar)

### API Handlers Call `getSession` Directly to Preserve Test Mocks
**Date:** 2026-04-14 (Conv 116)

API endpoints authenticate by calling `getSession(cookies, jwtSecret)` directly — NOT via the higher-level `getCurrentUserId` wrapper. SSR pages (which have no test-mock contract) may use either.

**Rationale:** Tests mock `@/lib/auth` with `{ ...actual, getSession: vi.fn() }`. `vi.mock` replaces exports for IMPORTERS but not for module-internal callers — if `getCurrentUserId` in `@/lib/auth` calls `getSession` via its own module scope, the mock never fires and auth tests break. Changing the established test-mock convention across the codebase would broaden the blast radius of a refactor that should be invisible to tests.

**Consequences:** API handlers lose ~3 lines of brevity but 6392/6392 tests pass. Applies anywhere a function is called from tests whose mocks target a lower-level primitive — prefer calling the mocked primitive directly.

### Worker `preview_urls`: `false` for Production, `true` for Staging
**Date:** 2026-04-13 (Conv 114)

Production Worker sets `preview_urls = false`; staging Worker sets `preview_urls = true`. Explicit on both — no implicit defaults.

**Rationale:** Per-version preview URLs are guessable and carry full bindings. On a prod Worker with live D1/R2/Stripe live-mode, that's an unacceptable security liability. On staging (test data only), they're a useful affordance for validating deploys before they become primary. Explicit `true` on staging also silences the wrangler warning about implicit behavior.

### Manual `wrangler deploy` Now, GitHub Actions Later
**Date:** 2026-04-13 (Conv 114)

After the Workers migration, deploys use manual `npm run deploy:staging` / `deploy:prod` scripts. GitHub Actions auto-deploy is tracked as a follow-up in the DEPLOYMENT.GHACTIONS sub-block, not a migration blocker.

**Rationale:** CF Pages' Git-push auto-deploy is gone with the platform change. Shipping GH Actions alongside the Workers migration would couple two concerns (secrets management, workflow YAML, branch-protection rules) that are better sequenced. Manual deploys unblock the migration fastest; CI is additive.

**Consequences:** Every deploy currently requires a developer at a terminal with wrangler auth. DEPLOYMENT.GHACTIONS, DEPLOYMENT.PROD, DEPLOYMENT.STAGING-DOMAIN, and DEPLOYMENT.PAGES-DISCONNECT sub-blocks added to PLAN.md.

### Cron Handlers Ship as a Separate Standalone Worker (not augmented onto Astro's Worker)
**Date:** 2026-04-21 (Conv 141)

Scheduled (cron) handlers deploy as a standalone Worker at `workers/cron/` (`peerloop-cron` / `peerloop-cron-staging`) with its own `wrangler.toml`, rather than being added to the Astro-built main Worker. Shared bindings (D1, R2) are wired via binding IDs in both configs; shared logic is imported from `src/lib/*.ts` modules. Cron cadence: `*/15 * * * *` staging, `*/30 * * * *` production.

**Rationale:** `@astrojs/cloudflare@^13.1.8`'s public `Options` type does NOT expose `workerEntryPoint` (confirmed in `dist/index.d.ts`); attempting a dual `fetch` + `scheduled` entry on the adapter-built Worker would fight adapter internals. Alternatives weighed: (a) adapter `auxiliaryWorkers` — CF-native but couples to adapter internals; (b) GitHub Actions cron hitting an admin endpoint — couples to GHA reliability + an auth-token secret path; (c) post-build esbuild wrapper — fragile against adapter updates. Standalone Worker gives cleanest separation, most portable pattern (reusable for future Stripe polling cron), and is cheapest to test/deploy independently — at the cost of one additional deploy step.

**Consequences:** Created `workers/cron/` (wrangler.toml, src/index.ts, tsconfig.json). Added `deploy:cron:staging`, `deploy:cron:prod` (gated by `confirm-prod.js`), `cf:tail:cron:staging`, `cf:tail:cron:prod` npm scripts. Shared orchestration extracted to `src/lib/cleanup.ts` (`runSessionCleanup(db, bbb)`); `src/pages/api/admin/sessions/cleanup.ts` refactored from 127→53 lines to delegate to the shared module. Cron Worker's `tsconfig.json` must `include` `../../src/env.d.ts` so `App.Locals` + `Cloudflare.Env` augmentations resolve. `peerloop-cron-staging` deployed 2026-04-21; first scheduled firing at 09:30:35Z recovered 1 real missed `recording_ready` webhook on its first run.

### Platform-Stats Env Marker: Stub Row + Chained UPDATE in Migrate Scripts
**Date:** 2026-04-15 (Conv 121)

`migrations/0002_seed_core.sql` seeds a stub row `('stat-007', 'environment', 'unknown', ...)` into `platform_stats`. Each of `db:migrate:{local,staging,prod}` in `package.json` chains a `wrangler d1 execute … UPDATE platform_stats SET value='<env>' WHERE key='environment'` after the migration command, stamping the per-environment marker.

**Rationale:** The seed file runs uniformly across all environments, so it cannot encode a per-env discriminator — but `/api/debug/db-env` needs one. Alternatives considered: per-environment SQL files (creates 3 parallel seed tracks to maintain); out-of-repo wrangler CLI in each deploy pipeline (splits deploy logic across repo + CI config). The chained-UPDATE approach is idempotent, keeps the marker-row definition in one place, and co-locates the stamping with the migrate commands it depends on.

**Consequences:** `npm run db:setup:local` (or `:staging` / `db:migrate:*` directly) now self-stamps the env marker. Production inherits via `db:migrate:prod` with the existing `confirm-prod.js` gate.

### `__testEnv` as the Test-Only Injection Slot on `App.Locals`
**Date:** 2026-04-10 (Conv 101)

After the `@astrojs/cloudflare@13` upgrade removed `locals.runtime.env`, tests still need per-context env/binding injection. Helpers (`getEnv`, `getDB`, `getR2`) check `locals?.__testEnv?.[key]` first, then fall through to `import { env } from 'cloudflare:workers'`, then `process.env`. `__testEnv?: Record<string, unknown>` is declared on `App.Locals` as a dedicated test-only slot.

**Rationale:** Preserves `createAPIContext({ db, env })` ergonomics for 39+ existing tests without a mechanical sweep. Zero production cost — `__testEnv` is always undefined outside tests. A future ESLint rule should forbid application code from setting it.

### Cloudflare Env Type Augmentation Targets `Cloudflare.Env`, Not Bare `Env`
**Date:** 2026-04-10 (Conv 101)

Project env fields are declared via `declare namespace Cloudflare { interface Env { DB: D1Database; ... } }` in `src/env.d.ts`, declaration-merged with `@cloudflare/workers-types`. A top-level `interface Env extends Cloudflare.Env {}` alias is kept for backward-compat with code referencing the bare name.

**Rationale:** `@cloudflare/workers-types` declares `declare module 'cloudflare:workers' { export const env: Cloudflare.Env }`, so `import { env } from 'cloudflare:workers'` is typed against `Cloudflare.Env`, not any local bare `interface Env`. The namespace-augmentation pattern is the canonical project-extension point documented in workers-types itself.

### Vitest Alias for `cloudflare:workers` Virtual Module
**Date:** 2026-04-10 (Conv 101)

`vitest.config.ts` adds `'cloudflare:workers': tests/helpers/mock-cloudflare-workers.ts` (a Proxy over `process.env`) alongside existing aliases for `astro:transitions/client` and `astro:middleware`. This is how tests resolve the `cloudflare:workers` virtual module that `@cloudflare/vite-plugin` provides in production but vitest does not load.

**Rationale:** Matches the existing virtual-module alias pattern in the project — least-surprising, no `vi.mock` hoisting quirks, no async helper init. Single explicit resolution point.

### Adapter 13 Config: `platformProxy` Split into `remoteBindings` + `CLOUDFLARE_ENV`
**Date:** 2026-04-10 (Conv 101)

`@astrojs/cloudflare@13` removes the `platformProxy: { environment, remoteBindings }` option. Replacement: `remoteBindings: process.env.USE_STAGING_DB ? true : undefined` at the adapter's top level, and `CLOUDFLARE_ENV=preview` set in the `dev:staging` npm script (read by `@cloudflare/vite-plugin` to select the wrangler.toml `[env.preview]` section).

**Rationale:** Adapter 13's `Options` interface no longer exposes `platformProxy` or `environment`. The two concerns are now orthogonal: binding mode (local vs remote) via `remoteBindings`, wrangler environment selection via the `CLOUDFLARE_ENV` env var.

### Centralize Cloudflare Env Access Through Helpers
**Date:** 2026-04-10 (Conv 100)

Application code MUST access Cloudflare bindings and secrets through helpers (`getEnv`/`requireEnv`, `getDB`, `getR2`/`getR2Optional`, `getStripeFromLocals`, `getStreamClient`). Direct `locals.runtime?.env?.X` reads are limited to helper implementations (`src/lib/env.ts`, `src/lib/db/index.ts`, `src/lib/r2.ts`). `getEnv`/`requireEnv` include a `process.env` dev fallback as the single source of truth.

**Rationale:** Preparatory refactor for `@astrojs/cloudflare` v13, which removes the `locals.runtime.env.*` namespace entirely. Centralizing now (on Astro 5) decouples pattern change from version bump: the adapter upgrade becomes a small change to helper internals instead of a ~100-file sweep. Also eliminates ~75 duplicated inline `process.env` fallbacks. Grep verification: `grep -rn "locals\.runtime\?\.env" src/` should return only helper files.

### Split PACKAGE-UPDATES Phase 2: Astro 6/adapter 13/react 5 now; TypeScript 6 deferred
**Date:** 2026-04-10 (Conv 100)

Phase 2 split into 2a (Astro 6 + `@astrojs/cloudflare@13` + `@astrojs/react@5`, proceeding) and 2b (TypeScript 5 → 6, deferred). Revisit criterion: `npm ls typescript` shows no "invalid peer" markers for `@astrojs/check`, `@typescript-eslint/*`, and Astro-vendored `tsconfck`.

**Rationale:** TS 6.0.2 published early April 2026; the TS 6 release blog itself calls it a "bridge release" toward TS 7's native rewrite. Framework-level peer conflicts (Astro vendors `tsconfck` pinned to `^5.0.0`) are hard blockers, not warnings to suppress. Force-fitting TS 6 would mean silencing warnings and hoping runtime compatibility holds — anti-durable.

### [AAP] Astro Absolute-Path Leak Deferred — WAITING on Upstream Fix Post-6.3.6
**Date:** 2026-05-20 (Conv 163)

Astro dev emits `<script src="/Users/<user>/projects/Peerloop/node_modules/...">` (absolute filesystem path) into HTML for `ClientRouter.astro` and similar islands. Root cause: `node_modules/astro/dist/vite-plugin-astro/compile.js:50` emits `import "${compileProps.filename}?astro&type=script&index=${i}&lang.ts"` where `compileProps.filename` is the absolute path. Latest stable Astro 6.3.6 has the byte-identical buggy line (verified via `npm pack` diff). Options considered: A — defer + verify on each Astro upgrade (chosen); B — dev middleware HTML rewrite; C — `patch-package` monkey-patch.

**Rationale:** Functionally a no-op (Vite serves 200 either way regardless of how the path is formed). Both workarounds (B/C) add maintenance burden for a purely cosmetic dev-only issue. Cross-machine portability is the only real concern (the path is hardcoded to whoever's machine generated the dev HTML), but the path is regenerated on every dev start so it's never actually shared.

**Verification probe (run after each Astro upgrade):** `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` — if path is relative, upstream is fixed; if still absolute, the deferral stands. Tracked as task [AAP].

### Docs-Primary Claude Code Architecture (Implemented)
**Date:** 2026-02-20 (Session 229 planned, Session 232 implemented)

All documentation (~899 files, ~19 MB) migrated from code repo to `peerloop-docs` companion repo (https://github.com/PeerloopLLC/peerloop-docs). Claude Code launches from docs repo with `--add-dir ../Peerloop`. Code repo reduced from 27.6 MB to 8.6 MB (69% reduction).

**Architecture:** `peerloop-docs/` is CC home (.claude/, CLAUDE.md, docs/, planning files). `Peerloop/` is clean code repo with symlink (`docs → ../peerloop-docs/docs`) for build-time dependencies.

**Launch:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Setup:** Run `scripts/link-docs.sh` once per machine to create symlinks.

**Rationale:** Keeps shipping codebase clean. Docs repo doubles as Obsidian vault. Symlinks transparent to Node.js/Vite/Astro (build + all 4891 tests pass). `--add-dir` provides full tool access to code repo.

**See:** Session 232 Decisions.md for full option analysis.

### Three Separate Navigation Sets
**Date:** 2025-12-26

Maintain three architecturally separate header/footer component sets:
- **Public:** `PublicHeader`, `PublicFooter` (LandingLayout)
- **Gated:** `GatedHeader`, `GatedFooter` (AppLayout)
- **Admin:** `AdminSidebar` (AdminLayout - SPA pattern)

**Rationale:** Gives designer flexibility; Admin uses completely different pattern (SPA with left sidebar); cleaner separation of concerns.

### NAV-RETROFIT Narrowed to AdminNavbar Only
**Date:** 2026-05-25 (Conv 193)

Of the three nav siblings, only AdminNavbar is retrofitted onto Matt styling. AppHeader is excluded (speculative, never client-reviewed, public-facing visitor→member surface most likely to be redesigned by the designer). MoreSlidePanel coupling deferred → tracked as [MSP-COUPLING].

**Rationale:** Don't invest in surfaces likely to be thrown away by the designer; concentrate retrofit on the logged-in admin chrome.

### NAV-ICON-SWAP: Match from Matt43 ∪ Material; Harvest Material into MattIcon Registry
**Date:** 2026-05-25 (Conv 193)

Both AppNavbar and AdminNavbar icons are matched against Matt's 43-icon set first, then Material Design icons for the gaps (Matt's set is product-oriented and lacks nav-chrome/admin-tooling glyphs). 10 Material-outlined icons (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add) are harvested into the MattIcon registry (43→53), fills normalized to `currentColor`. The dashed-border unmatched fallback ended up unused (Material covered every gap). Admin rail aligned to Matt's 220px.

**Rationale:** Harvesting into the registry follows existing precedent (Matt's registry already holds harvested Material icons); a single renderer (MattIcon) wired up, so mixing Matt-designed + Material-harvested icons there is the lowest-friction path. Provenance of non-Matt icons documented in MEMORY.md.

### Role Switching via User Dropdown
**Date:** 2025-12-26

Keep role navigation in user avatar dropdown submenu, not top-level headers.

**Rationale:** Top-level role menus have real estate issues; crowded on mobile; simpler for MVP.

### Discover Panel Routes via `/discover/*`
**Date:** 2026-02-03 (Session 173), updated 2026-03-28 (Conv 042)

The DiscoverSlidePanel links to `/discover/*` routes for browsing public content within the app shell:

- `/discover/courses` - Course browse (role-aware: visitors see public view, members see role-specific tabs)
- `/discover/course/[slug]` - Course detail (role-aware, with bookmarkable tab sub-routes via `[...tab].astro`)
- `/discover/creators` - Creator listing (CRLS)
- `/discover/teachers` - Teacher directory (STDR)
- `/discover/students` - Student directory (new)
- `/discover/leaderboard` - Community leaderboard (LEAD)
- `/discover/communities` - Community browse (future)

**History:** `/discover/courses` was originally a non-role-aware browse page. Conv 042 promoted the experimental `/explore/*` role-aware pages to `/discover/*`, replacing the old browse page. The `/explore/` namespace was deleted entirely. `/course/[slug]` remains as-is pending client confirmation.

**Rationale:** PAGES-MAP.md represents pre-client-change design. The `/discover/*` namespace provides clear organization for browsing pages within the new app shell architecture. Single authoritative route per resource type — the role-aware version is strictly superior (visitors see the same content, members get role-specific tabs).

**See:** `src/components/layout/DiscoverSlidePanel.tsx`, `src/pages/discover/`

### Singular Resource Routes Convention
**Date:** 2026-02-03 (Session 175)

Individual resource pages use singular nouns; collection pages use plural:

| Pattern | Example | Description |
|---------|---------|-------------|
| `/discover/{plural}` | `/discover/creators` | Browse/listing pages |
| `/{singular}/[param]` | `/creator/[handle]` | Individual resource |
| `/{singular}/[param]/{action}` | `/course/[slug]/learn` | Resource sub-routes |

Current routes:
- `/creator/[handle]` - Creator profile (CPRO)
- `/teacher/[handle]` - Teacher profile (STPR)
- `/course/[slug]` - Course detail (CDET)
- `/course/[slug]/learn` - Course content (CCNT)
- `/course/[slug]/book` - Session booking (SBOK)

API routes remain plural (`/api/courses/`, `/api/creators/`) as a separate namespace.

**Rationale:** REST convention distinguishes collections from resources; shorter, more shareable profile URLs; profile pages are destinations, not discovery.

**See:** `src/pages/creator/`, `src/pages/teacher/`, `src/pages/course/`

### Activity vs Resource Route Namespaces
**Date:** 2026-02-04 (Session 177)

Dashboard and tool pages use **activity namespaces** (verb/gerund form), while public profile pages use **resource namespaces** (noun form):

| Namespace | Purpose | Examples |
|-----------|---------|----------|
| `/creating/*` | Creator's dashboard & tools | `/creating`, `/creating/studio`, `/creating/earnings` |
| `/teaching/*` | Teacher's dashboard & tools | `/teaching`, `/teaching/earnings`, `/teaching/students` |
| `/learning/*` | Student's dashboard & tools | `/learning` (future) |
| `/creator/*` | Creator profiles (public) | `/creator/[handle]` |
| `/teacher/*` | Teacher profiles (public) | `/teacher/[handle]` |
| `/course/*` | Course resources (public) | `/course/[slug]`, `/course/[slug]/book` |

Activity namespaces communicate "what I'm doing" and group related tools. Resource namespaces are for viewing public content.

**Rationale:** Clear separation between private dashboard tools and public profile pages; intuitive mental model; consistent with singular resource convention.

**See:** `src/pages/creating/`, `src/pages/teaching/`

### Teacher Course Detail Route: `/teaching/courses/[courseId]`
**Date:** 2026-03-25 (Conv 030)

Per-course teacher detail page uses `/teaching/courses/[courseId]` (activity namespace), not `/course/[slug]/teach` (resource namespace). Keeps the teacher in their workspace, consistent with all other `/teaching/*` routes. Uses courseId (not slug) for direct DB lookups.

**Rationale:** Activity namespace consistency; simpler auth model (all `/teaching/*` requires teacher auth); natural breadcrumb (Teaching → Course Name).

### Dedicated Teacher Resources API (Not Shared with Students)
**Date:** 2026-03-25 (Conv 030)

Teacher resources use a dedicated `GET /api/teaching/courses/[courseId]/resources` endpoint rather than extending the existing `/api/courses/[id]/resources` (which requires enrollment). The teacher endpoint includes module grouping with `module_order` and `download_count` not in the student API.

**Rationale:** Allows the teacher resources interface to evolve independently. Isolates teacher auth from student enrollment checks. Avoids widening an existing gate that was intentionally scoped to enrolled students.

### Community Membership Roles: `creator` and `member` Only (Conv 120)
**Date:** 2026-04-15 (Conv 120, supersedes earlier `('creator','teacher','member')` shape)

`community_members.member_role` is narrowed from `('creator','teacher','member')` to `('creator','member')`. The `'teacher'` value is retired across schema, seed, types, API, and UI.

**Why:** Conv 119 audit found `member_role='teacher'` was dead-code drift — no application code wrote the value, but 20+ UI/type/API sites read it. Dev seed fixtures encoded the value, which produced surface-level "teaching communities" tabs that didn't reflect any system invariant. The duplication invited skew between membership rows and the actual source of teaching authority (`teacher_certifications`).

**New rule:** "Communities where the user is teaching" is derived server-side via:
```sql
teacher_certifications tc
  JOIN courses c ON tc.course_id = c.id
  JOIN progressions p ON c.progression_id = p.id
WHERE tc.user_id = ? AND tc.is_active = 1
  AND p.is_active = 1 AND p.deleted_at IS NULL
  AND c.is_active = 1 AND c.deleted_at IS NULL
```

The result is exposed as `MeFullResponse.teachingCommunityIds: string[]` and surfaced through `CurrentUser.getTeachingCommunityIds()` / `isTeachingIn(communityId)`. UI consumers (Teaching tab, Teaching pill, teachingCount badge, feed role annotation) read the derived value.

**Side-fix:** The previous `canUploadResources` gate in 6 Astro community pages allowed `role === 'creator' || role === 'teacher'` but never `isAdmin`. Replaced inline expression with `canUploadCommunityResources(membership, isAdmin)` from `src/lib/permissions.ts`. Admins now correctly see the upload control everywhere the backend already permitted them.

**See:** `src/lib/permissions.ts`, `src/lib/current-user.ts` (`getTeachingCommunityIds`), `src/pages/api/me/full.ts` (`fetchTeachingCommunityIds`), `migrations/0001_schema.sql:222`.

### Community/Feed 1:1 Mapping
**Date:** 2026-02-04 (Session 181)

Each community has exactly one feed. The community page IS the feed. Post categorization uses tags instead of separate feeds.

| Entity | Feed Pattern |
|--------|-------------|
| Community | `community:{community_id}` - tagged posts |
| Course | `course:{course_id}` - enrolled students only |

Tag filtering via query params: `/community/the-commons?tag=announcements`

**Rationale:** Simpler data model (no separate feed entity); tags more flexible than multiple feeds; routing simplification.

**See:** `docs/as-designed/url-routing.md` (Community & Feed Architecture section), `docs/requirements/rfc/CD-036/`

### Community Routes: Hub + Subroute Tab Pattern
**Date:** 2026-02-05 (Session 186, supersedes Session 181)

Communities use the "bare = my" pattern with URL-aware tabs via subroutes:

| Route | Purpose |
|-------|---------|
| `/community` | My Communities hub (mirrors FeedSlidePanel) |
| `/community/[slug]` | Community Feed tab (default) |
| `/community/[slug]/courses` | Community Courses tab |
| `/community/[slug]/resources` | Community Resources tab |
| `/community/[slug]/members` | Community Members tab |
| `/discover/communities` | Find communities to join |

The Commons (`isSystem: true`) redirects `/community/the-commons/courses` to `/community/the-commons` since system communities don't have courses.

**Rationale:** Subroutes provide bookmarkable URLs, browser history integration, and SSR-compatible tab selection (matching the `/course/[slug]/feed` pattern). CommunityTabs receives `initialTab` prop and uses `pushState` for tab navigation.

**See:** `src/pages/community/[slug]/`, `src/components/community/CommunityTabs.tsx`, `docs/as-designed/url-routing.md`

### Aggregated `/feed` Timeline via Stream Follows
**Date:** 2026-02-05 (Session 189)

The `/feed` route displays an aggregated timeline combining posts from all sources the user follows. Uses Stream.io's `timeline:{userId}` feed which aggregates content based on follow relationships.

| Event | Stream Action |
|-------|---------------|
| User enrolls in course | `timeline:userId` follows `course:courseId` |
| User joins community | `timeline:userId` follows `community:slug` |
| User registers | `timeline:userId` follows `community:the-commons` |

FeedSlidePanel shows "Home Feed" as top item linking to `/feed`. Individual feeds (community pages, course feeds) remain accessible below.

**Rationale:** Modern UX expectation; reduces friction to catch up on all activity; Stream has built-in timeline aggregation via follows; The Commons auto-follow ensures new users see activity immediately.

**See:** `src/pages/feed.astro`, `src/lib/stream.ts` (follow/unfollow methods), `src/lib/onboarding.ts`

### No Creator Feeds - Use Communities Instead
**Date:** 2026-02-04 (Session 183)

All feeds are either community feeds or course feeds. There are no personal user or creator feeds.

| Feed Type | Route | Description |
|-----------|-------|-------------|
| Community | `/community/[slug]` | Community page IS the feed |
| Course | `/course/[slug]/feed` | Course discussion for enrolled students |
| ~~Creator~~ | ~~`/creator/[handle]/feed`~~ | **Removed** - creators create communities |

Creators who want announcement feeds should create a community (e.g., "Guy's Main Hall") with no courses, just feed and resources.

**Rationale:** Single feed concept simplifies mental model; avoids slippery slope (if creators have feeds, why not all users?); communities provide built-in structure (members, resources, progressions).

**See:** `FeedSlidePanel.tsx` (shows Communities + Course Feeds only)

### Bookmarkable Feed Tabs via Sub-Routes
**Date:** 2026-02-04 (Session 183)

Course feed tabs are implemented as sub-routes that render the same page with different active tabs (GitHub/Notion pattern):

| Route | Active Tab |
|-------|------------|
| `/course/[slug]` | About (default) |
| `/course/[slug]/feed` | Feed |
| `/course/[slug]/curriculum` | Curriculum (enrolled only) |

URL changes via `pushState` when clicking tabs; back/forward navigation works.

**Rationale:** Bookmarkable and shareable URLs; clean paths without query params; follows established patterns.

**See:** `CourseTabs.tsx`, `/course/[slug]/feed.astro`

### Progressions: Community → Progression → Course Chain
**Date:** 2026-02-04 (Session 182)

Courses belong to progressions, progressions belong to communities. This creates a three-level hierarchy for learning content organization:

| Entity | Belongs To | Contains |
|--------|------------|----------|
| Community | (top-level) | Progressions, Resources, Members |
| Progression | Community | Courses (ordered sequence) |
| Course | Progression | Sessions, Content |

Progression badges:
- `learning_path` - Multi-course sequence (e.g., "AI Fundamentals" with 2 courses)
- `standalone` - Single course (e.g., quick intro courses)

**Rationale:** Enables learning paths with course sequencing ("Course 2 of 3"); allows course copying between progressions; cleaner than direct community→course relationship.

**See:** `migrations/0001_schema.sql` (progressions table), `docs/requirements/rfc/CD-036/`

### Astro File Pattern: Flat Unless Sub-Routes Needed
**Date:** 2026-02-04 (Session 180)

Use flat files (`route.astro`) by default for Astro pages. Only use folder pattern (`route/index.astro`) when:
- Route has sibling files (e.g., `settings/index.astro` with `settings/profile.astro`)
- Route has dynamic params with sub-routes (e.g., `course/[slug]/learn.astro`)

| Pattern | When to Use |
|---------|-------------|
| `route.astro` | Leaf routes with no sub-routes |
| `route/index.astro` | Hub routes with siblings or dynamic params |

**Rationale:** Flat files reduce nesting, are easier to scan in file explorer, and make the file tree mirror the URL tree more directly. Astro produces identical routes for both patterns.

**See:** `src/pages/discover/`, `src/pages/course/[slug]/`

### Matt-Flow Routes Decided by Addressability, Not Page-Count
**Date:** 2026-05-24 (Conv 187)

The load-bearing, implementation-independent routing decision for each Matt flow screen is whether it needs a jump-to / deep-link / redirect URL (addressability) — NOT how many `.astro` files implement it. An addressable route can still be ONE state-driven page (e.g., `/session/[id]` renders Prepare/During/After from status). Page-count is a deferrable build detail; addressability is decided up front.

### ListingShell Is a Page-Level Primitive, Not an AppLayout Slot (LIST-1COL / CD-039)
**Date:** 2026-06-14 (Conv 284)

The single-column "Twitter-style" listings shell — a centered ~640px content column plus a responsive right panel — lives as a page-level primitive `src/components/layout/ListingShell.astro` that listing pages opt into inside `AppLayout`'s default slot, **not** as a new `aside-right` slot baked into `AppLayout`. Listing pages wrap their content and pass filters (or nothing) into the shell's `right-panel` slot. The shell's mobile contract is **reflow, not hide**: a filled (filter) panel reflows to the top of the column below `lg` (`order-1 lg:order-2`); only an empty placeholder panel is desktop-only (`hidden lg:block`).

**Right-panel branch selection (Conv 285, CD-039 Phase 4):** which branch a page uses is decided by whether it has a *standalone filter island*. A page with a relocatable filter rail (e.g. `/communities`, `/members`) moves that rail into the `right-panel` slot. A page with **no** standalone filter island (e.g. `/feeds`) uses the **empty light-blue placeholder** branch and keeps any role/segment tabs **inline** in the column. Role tabs are *navigation coupled to counts*, not relocatable filters — do **not** force a Monolithic-Filter event-bus split just to populate the panel.

**Rationale:** Lowest blast radius — `AppLayout` and ~80 other pages stay untouched, and it mirrors the established "pages compose primitives in the default slot" pattern. The reflow contract keeps filters reachable on mobile (an earlier `hidden lg:block` trapped them in a `display:none` aside); filter islands work at any DOM position because their coordination is global-event-based.

- **Addressable:** Course tabs (`[...tab]`), Enroll Success (Stripe `success_url`, hard requirement), Choose Teacher, Session (`/session/[id]`, one state-driven route), Home/Feed.
- **Non-addressable (overlays/states, no own URL unless user later wants deep-links):** Enroll pre-checkout, Session Scheduled, Home/Course Completed.

**Rationale:** "Needs a URL" and "how many files" are orthogonal. Deciding addressability now unblocks Phase 5 / SubNav routing / PG2 without prematurely committing to a file layout. User reframed away from the single-vs-multi-page framing this conv; resolution captured as a standing principle. Implementation mirrors legacy route patterns.

**See:** `memory/feedback_routing_addressability_first.md`, `.scratch/matt-frames-ready-for-dev.md` § Route Addressability

### Cap AppLayout for the Margin-Jar Fix — No New ContentShell (LAYOUT-SG)
**Date:** 2026-06-15 (Conv 289)

The LAYOUT-SG margin-jar fix (content column shifting between listing and entity page types) is solved by adding a `max-w-[1248px] mx-auto` cap+centering wrapper around the existing sidebar+card group inside `AppLayout`, with the body centering it (`lg:justify-center`) while the grey page stays full-bleed. **No new `ContentShell` component is built** — superseding the LAYOUT-SG spec's "build ContentShell" step.

**Rationale:** Reading `AppLayout.astro` first showed it ALREADY hosts the white card, grey bg, mobile pills, and a left `sub-nav` slot (from NAV-RETROFIT) — only the `1248` cap was missing. A new ContentShell would have been redundant indirection; capping the existing shell fixes the jar app-wide with one container. DOM-verified: at 2xl content=964px exact, cap engaged, `/courses` + `/course/[slug]` now pixel-identical (card x=387) — jar gone.

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.5, `src/layouts/AppLayout.astro`

### Q2 — Utility Column Sits LEFT Across Page Types (LAYOUT-SG)
**Date:** 2026-06-15 (Conv 289)

The utility column (listing filters, entity SubNav, enrollment rail) sits **LEFT** across all page types on desktop. Client-decided in an impromptu meeting; resolves the prior inconsistency where the entity SubNav was already left but listing filters rendered right. `ListingShell`'s filter/utility panel migrated right→left via an `lg:order` swap.

**Rationale:** Client call. Standardizes the layout convention so all utility surfaces share one side. Prior *evidence* leaned right (mobile drawer, 320px right filters), but the client preference is the source of truth.

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.5.3, `src/components/layout/ListingShell.astro`

### Home Right-Side "Coming Soon" Panel Is Bespoke in `index.astro`, Not the Shared Shell (HOME-RPANEL)
**Date:** 2026-06-18 (Conv 298)

Home (`/`) gets a bespoke two-column layout in `index.astro` — feed anchored left (`lg:w-[640px] lg:shrink-0`) + a light-blue flex-grow `<aside>` "coming soon" panel on the **right** (`hidden lg:block lg:flex-1`), killing the dead left gutter the client objected to. It does **not** reuse `ListingShell`'s placeholder. Panel growth caps at AppLayout's 1248px content-card max-width (accepted as-is; widening deferred). Rejected: enabling the `ListingShell` panel as-is (renders LEFT per the Q2/CD-039 decision above), and flipping the global panel side to RIGHT for all listing pages.

**Rationale:** The intent (decorative whitespace-absorber: fixed content + growing panel) is the inverse of `ListingShell`'s flex model (fixed utility panel + growing list), and the shared shell renders its panel LEFT. Diverging Home only keeps the 4 filter pages on the Conv-289 LEFT decision untouched and keeps the shared shell single-purpose. The 1248px cap matches the client's working width.

**See:** `src/pages/index.astro`; Conv 298 Decisions §1, Learnings §1; contrast "Q2 — Utility Column Sits LEFT" (Conv 289) above.

### RTMIG-4 Migration Methodology = A (Legacy Body Into Matt Shell)
**Date:** 2026-05-27 (Conv 203)

Each `/old` page migrated to root renders its legacy body inside the Matt shell (Approach A), rejecting B (legacy as-is with legacy shell → two navbars at root) and C (migrate only the 9 Matt-designed pages, defer rest). Home is the pilot. Governs ~80 more pages.

**Rationale:** Consistent nav everywhere; follows the Conv 201 root pattern; Home was never a real Matt design (only a shell preview) so it's A-by-nature. Per-page loop: build in Matt shell → middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs `:4331` → retire `/old` copy. [STANDIN-MATT] (#25) is A applied to the 7 stand-in pages.

### Links to Unconverted Pages Must 404 — No Resolving Placeholder Stubs
**Date:** 2026-05-27 (Conv 203)

Fake-demo placeholder pages are deleted so links 404 honestly during migration; pages are stubbed + converted per-page when their turn comes. Functional real-data pages stay. Deleted `/saved` `/todo` `/teachers` `/earnings` `/notifications` `/messages` this conv.

**Rationale:** A resolving placeholder hides the migration gap and breaks the "unbuilt routes 404 by design" honesty signal. Dangling chrome links are accepted. See `memory/project_route_404_honesty_standin.md`.

### Page Owns Its SubNav (Slot-Based, Opt-In)
**Date:** 2026-05-27 (Conv 203)

The SubNav strip is page-owned: each page fills `<slot name="sub-nav">` in `AppLayout`, and an unfilled slot collapses the strip entirely (no empty rail). Subnav-less pages (e.g. Home) simply omit the slot.

**Rationale:** SubNav is page-section nav with unique per-page content; a shared layout default isn't semantically shared (the Sidebar is the app-wide nav). Three states fall out free: fill it, omit it, or import a shared list.

### `/courses` Is Public (Removed from PROTECTED_EXACT)
**Date:** 2026-05-27 (Conv 204)

`/courses` is a public browse-all gateway, not a protected "My Courses" page — removed from middleware `PROTECTED_EXACT` so visitors can browse without a 302→/login.

**Rationale:** Conv 192 repurposed `/courses` from legacy "My Courses" to a public catalog; middleware's own line-7 comment already listed courses as public-browsable. Middleware test updated with a public-browse assertion.

### DISC-DROP: `/discover` Folded Into `/courses`
**Date:** 2026-05-27 (Conv 204)

`/discover` is being dropped entirely; its content folds into `/courses` over 4 staged steps. Supersedes the earlier [DISC-UNIFY] loader-unify plan. Stage 1 (role tabs + level/topic/search filters + loader `primary_topic_id` fix) shipped this conv.

**Rationale:** A single course-finding surface beats two overlapping discovery routes; `/courses` is already a Matt-primitive build, so it absorbs the catalog rather than unifying two loaders.

### DISC-ROLE-VIEWS: Re-skin Legacy Per-Role Views as Matt-Inspired (Don't Collapse to a Filter)
**Date:** 2026-05-31 (Conv 222)

The Conv-205 (/courses) and Conv-221 (/communities) ports replaced legacy's distinct per-role components (EnrollmentCard progress, teaching/created/moderation views) with a single filter-only browse catalog, silently dropping per-role rendering. New block DISC-ROLE-VIEWS restores per-role Matt-inspired views across communities + courses (+ feeds/members), preserving legacy functionality as the spec. Implementation rule: **build NEW Matt components; never mutate legacy `/old` `tabs/*Tab.tsx` or the shared dashboard cards** (EnrollmentCard/CreatorCourseCard) — read legacy as the functional spec only. Phases A (communities) + B (courses) shipped this conv via a per-role dispatcher inside the catalog island.

**Rationale:** A port must transfer functionality + content faithfully AND apply Matt styling — both co-equal; Matt designed student-first only, so multi-role rendering is our job, and the legacy per-role views are the functional spec. /old must stay client-vettable; the dashboard's Matt migration is a separate deliberate step, so neither may be mutated by this work.

**See:** `src/components/communities/CommunitiesCatalog.tsx`, `src/components/courses/CoursesCatalog.tsx`, new `Course{Progress,Teaching,Created,Moderation}Card.tsx` + `CommunityRoleFallbackCard.tsx` (all `@matt-inspired`).

### RoleTabBar Is the Canonical Role-Tab Strip; Per-Destination Tabs Are Stateful Adapters
**Date:** 2026-05-31 (Conv 227)

The three near-identical discover role-tab implementations (Courses/Communities/Feeds) converge on the shared `RoleTabBar.tsx` primitive (Rule-of-Three trigger, deferred via [DISC-RTB-RECONCILE]). RoleTabBar is generalized to a presentational primitive (tab `id` decoupled from `role`; `null` role = neutral "All" tab) and is the single registered primitive. `CoursesRoleTabs` + `CommunitiesRoleTabs` keep their state/event/role logic and delegate *rendering* to it (stateful adapters, deregistered from the prov registry); `FeedsRoleTabs` is deleted and `FeedsDirectory` renders `RoleTabBar` directly. Matt's §5 role palette is canonical — teacher→blue, moderator→neutral, active tab rendered in its role's own color; legacy `ROLE_COLORS` (teacher=green/moderator=amber, uniform active) is retired for these tabs.

**Rationale:** Single source of truth for tab markup + palette; honors the §12 primitive-definition rule that a component which merely composes a primitive isn't itself a primitive. User directive "favour Matt's colours" settled the palette conflict.

**Consequences:** Visible restyle of /courses, /communities, /feeds role tabs (browser-confirmed); 3 registry entries removed; follow-up [RTB-HOOK] (#37) tracks extracting a shared `useRoleTabs` hook for the still-duplicated visible-tab derivation + hash-sync logic.

**See:** `src/components/RoleTabBar.tsx`, `src/components/courses/CoursesRoleTabs.tsx`, `src/components/communities/CommunitiesRoleTabs.tsx`, `src/components/feed/directory/FeedsDirectory.tsx`; spec in `docs/as-designed/matt-design-system/02-architecture.md` §RTB.

### Host-Aware Shared Card via `context` Prop
**Date:** 2026-05-31 (Conv 222)

The shared Conv-205 `CourseCatalogCard` (used by the All tab, recommendations, and a communities mirror) takes a `context` prop (`"catalog"` vs default). `context="catalog"` opts into richer fields (badge/sessions/duration/creator avatar+link); the default stays trimmed for recommendations.

**Rationale:** Lets one host enrich its content without forking the component or mutating every caller — avoids the "modify-shipped-card breaks all callers" dilemma while keeping design symmetry.

### `/profile` Is a Flat 6-Tab Account Hub (Settings Flattened)
**Date:** 2026-05-28 (Conv 212)

`/profile` is retrofitted from a `@stand-in` stub into a flat 6-tab account area (Account / Edit Profile / Interests / Payments / Notifications / Security) built on the `[...tab].astro` + `_profile-tabs.ts` tab-family idiom. The legacy navbar-slideout destinations and the `/settings` 5-card hub are flattened into siblings rather than kept as a nested hub-tab. Public `/@handle` stays a separate outward-facing route; Help, Dark-mode toggle, and Sign-out are Account-tab actions (none is its own tab). The scaffold reuses the existing `/settings/*` React islands lightly Matt-shelled; faithful per-tab Matt redesign is deferred (#33 [PROF-TAB-REDESIGN]).

**Rationale:** Matches the course flat-tab model (no nested menus); separates outward (`/@handle`) from inward (account management); kills the dead placeholder SubNav (#29). Separating structure (route shape, flatten-the-hub, tab-vs-action — hard to reverse) from fidelity (per-tab, low-risk) made the structural cut completable in one conv with tests locking it before any pixel polish. Closes [STANDIN-MATT] — 0 `@stand-in` pages remain.

**See:** `src/pages/profile/[...tab].astro`, `src/pages/profile/_profile-tabs.ts`; pattern mirrors `course/[slug]/[...tab].astro`.

### `/profile` Is the Permanent Private Account Hub; Public Profile Is a Separate `/@handle`
**Date:** 2026-05-29 (Conv 216)

`/profile` remains the private account/settings hub permanently. The earlier "redirect `/profile`→`/@me`" plan note is dropped. The public-facing profile is the separate `/@handle` route (with a `/@me` self-alias), migrated to root under RTMIG-4.

**Rationale:** The pre-flip `UserAccountDropdown` linked "View Profile → /@handle" and "Settings → /settings" as distinct items — they were always separate surfaces. Redirecting the private hub onto the public profile would destroy the hub. The user's recollection that `/profile` redirected to `@me` was inaccurate; reading the pre-flip worktree (`608346a2`) settled it. The Account-tab "View public profile" link lights up when `/@handle` migrates to root.

### Consolidate /visitor into /profile (Auth-Aware Account Surface); noindex Account/Auth Pages (PROF-MERGE)
**Date:** 2026-06-29 (Conv 349)

The standalone public `/visitor` route is **folded into `/profile`**, which becomes auth-aware (mirroring how `/` already swaps chrome by auth): logged-out users get the Log in / Sign up + shared `<ThemeToggle>` entry surface; signed-in users get the account hub. The Sidebar profile chip now **always** links to `/profile`; `visitor.astro` is deleted. **Middleware:** `/profile` leaves `PROTECTED_PREFIXES` (bare `/profile` is now **public**) and its settings sub-tabs are guarded by a new `PROTECTED_SUBPATHS_ONLY = ['/profile']` rule (everything under `/profile/` stays member-only; bare path public). A new `noindex?: boolean` prop on `BaseHead`/`AppLayout` emits `<meta name="robots" content="noindex,follow">`, applied to `/profile`, `/login`, and `/signup`.

**Rationale:** Two lenses converged. **Addressability** — `/visitor` had exactly one inbound (the Sidebar chip), zero redirects/deep-links/external links, and bounced authed users to `/profile`; it never earned a standalone URL, and its slug didn't name its purpose. **SEO** — the logged-out account-entry surface has no index value and shouldn't compete with `/` (the sole public marketing page); the app had **no** robots/noindex mechanism (every public page was indexable; `robots.txt` is `Allow: /`), so the merge added the `noindex` hook the account/auth surfaces needed anyway. The merge keeps the exact logged-out content while removing a thin, badly-named route and de-duplicating the shared `<ThemeToggle>`.

**Supersedes** the Conv-216 two-route split below (the no-overlay / links-not-forms principle still holds — it now lives in `/profile`'s logged-out branch).

**See:** `src/pages/profile/[...tab].astro`, `src/middleware.ts`, `src/components/BaseHead.astro`, `src/components/Sidebar.tsx`

### No Overlay/Popover for Account Surfaces; Visitor + Profile List Links, Not Embedded Forms
**Date:** 2026-05-29 (Conv 216)

The auth/account surfaces use no overlays or popovers. `/login` and `/signup` stay standalone form pages (reusable as timeout/redirect targets). A new public `/visitor` page (symmetric to `/profile`) lists Login/Sign-up as links; `/profile` lists Sign-out as an action. Both surfaces carry a shared `<ThemeToggle>` component (`src/components/ui/ThemeToggle.tsx`), so dark mode is now reachable while logged out (legacy had no visitor theme toggle). The Sidebar visitor chip points to `/visitor` (was `/login`).

**Rationale:** "Popover" = the slide-out submenu the client explicitly rejected (the reason Conv 212 ported those options to SubNav tabs). Listing links instead of embedding form content honors that rejection and keeps the standalone auth pages reusable by timeout flows.

**Superseded (partial) by Conv 349 [PROF-MERGE]:** the separate `/visitor` route was folded into an auth-aware `/profile` (bare `/profile` now public + `noindex`); the links-not-forms + no-overlay principle persists in `/profile`'s logged-out branch.

### Dashboard as Homepage
**Date:** 2026-01-29 (Session 145)

The homepage (`/`) now shows the dashboard layout (DashLayout) for all users—visitors and authenticated. Marketing content moved to `/welcome` (WELC).

- `/` - Dashboard hub (was `/dash`, now homepage)
- `/welcome` - Marketing landing page (was `/`)
- `/dash/*` sub-routes remain (`/dash/discover`, `/dash/courses`, `/dash/messages`, etc.)
- Uses `DashLayout.astro` with `DashNavbar.tsx` React island
- Role-aware menu items (Visitor, Student, Teacher, Creator)
- Two slide-out panels: FeedSlidePanel (full-height), MoreSlidePanel (smaller)
- Visitor-friendly: no auth redirect, shows marketing CTAs

**Rationale:** Dashboard-first experience shows the product immediately; marketing content preserved for campaigns.

**See:** `src/pages/index.astro`, `src/pages/welcome.astro`, `src/layouts/DashLayout.astro`

### Role-Based Home Page Landing
**Date:** 2026-02-01 (Session 155)

Users landing on `/` are automatically directed based on their role:

| User Type | Landing Action |
|-----------|---------------|
| Visitor | Auto-open Discover slideout |
| Student (no special roles) | Auto-open Feeds slideout |
| Teacher / Creator | Redirect to `/workspace` |
| Admin | Redirect to `/messages` |

Additionally, Admins see a "To Admin" navbar item (after "More") linking to `/admin`.

**Rationale:** Tailors the home experience to each user's primary action without adding a new "Home" navbar item. Reuses existing navigation destinations.

**See:** `src/components/layout/AppNavbar.tsx` (role-based useEffect)

### CurrentUser Global State Architecture
**Date:** 2026-02-03 (Session 171, expanded from Sessions 145, 161)

Use a `CurrentUser` class singleton stored on `window.__peerloop.currentUser` for shared user state across Astro islands.

- Single `/api/me/full` endpoint returns user identity + all course relationships + profile data
- Stale-while-revalidate: hydrate from localStorage instantly, refresh from API in background
- Course-aware role methods: `isTeacherFor(courseId)`, `isCreatorFor(courseId)`
- Explicit courseId parameters (not implicit from URL)

**Comprehensive user data (Session 171):**
- Identity: `id`, `email`, `name`, `handle`, `title`, `avatarUrl`
- Bios: `bioShort` (tagline), `bioFull` (detailed), `teachingPhilosophy`
- Contact: `website`, `location`, `linkedinUrl`, `twitterUrl`, `youtubeUrl`
- Settings: `privacyPublic`, `emailVerified`
- Capabilities: `canCreateCourses`, `canTakeCourses`, `canTeachCourses`, `canModerateCourses`, `isAdmin`
- Stats: `studentsTaught`, `coursesCreated`, `coursesCompleted`, `averageRating`, `totalReviews`
- Profile: `expertise[]` (tags), `qualifications[]` (sentences with display order)
- Stripe Connect (Session 255): `stripeAccountId`, `stripeStatus`, `stripePayoutsEnabled`, `hasStripeConnected()`

**Architectural principle:** CurrentUser is a **read-only convenience cache**, not a source of truth. Components read it for UI decisions (show/hide, badges, prompts). API endpoints always derive identity from the JWT session and query the DB — they never trust client-sent CurrentUser data. Stale data is a UX issue, not a security concern.

**Rationale:** Storage is abundant (~5MB localStorage limit, user data <10KB), network calls are expensive (latency, loading spinners), user profile data is stable within a session. Load everything once at login, use everywhere - eliminates API calls for own profile display.

**See:** `src/lib/current-user.ts`, `src/pages/api/me/full.ts`, `docs/as-designed/state-management.md`

> **Insight:** This follows a "summary vs. detail" pattern common in client-side caching. CurrentUser carries the summary (status, boolean flags, IDs) for instant UI decisions — "should I show this button?" Detailed settings pages still need their own API for the full picture (e.g., Stripe requirements, disabled reasons). The rule of thumb: if the data answers a yes/no question across multiple pages, cache it; if it's only needed on one page, fetch it there. (Session 255)

### CurrentUser Data Freshness - Window Focus Refresh
**Date:** 2026-02-01 (Session 156)

When a user returns to the browser tab, `refreshCurrentUser()` is called to fetch fresh data from `/api/me/full`. This catches external changes (admin grants capability, creator certifies ST) that occurred while the user was away.

**Implementation:** Window focus event listener in `AppNavbar.tsx`.

**Options Considered:**
1. Page navigation only (already implemented)
2. Window focus refresh ← Chosen
3. Periodic polling
4. Lightweight version check endpoint
5. SSE/WebSocket push

**Rationale:** Simple (5 lines), no server changes, covers main scenario (user away while admin makes changes). Page navigation already refreshes on route change. Polling/push are overkill for MVP.

**Note:** Client state is optimistic UI; server always validates permissions on API calls. Stale client state is a UX issue, not a security issue.

**See:** `src/components/layout/AppNavbar.tsx`, `docs/as-designed/state-management.md`

### CurrentUser Cache Structural Guard
**Date:** 2026-03-09 (Session 362)

LocalStorage cache of `MeFullResponse` is validated with `isValidCachedData()` before hydrating the `CurrentUser` singleton. Checks 6 critical fields (`user.id`, `user.name`, `user.handle`, `enrollments`, `teacherCertifications`, `createdCourses`). If validation fails, cache is silently discarded and the UI shows a brief loading skeleton until the API refresh completes.

**Trigger:** After a staging deploy, the AppNavbar flashed briefly then disappeared for users with existing localStorage data. The cached `MeFullResponse` had an incompatible shape — `JSON.parse()` succeeded but React rendered `undefined` fields as empty, causing the flash-then-vanish.

**Options Considered:**
1. Build version key — invalidate all caches on every deploy
2. Full schema validation — check every field
3. Structural guard — check only constructor-critical fields ← Chosen

**Rationale:** Build version key penalizes all users on every deploy. Schema validation creates maintenance burden. Structural guard is self-healing, zero-config, and only triggers on actual structural mismatch. Semantic staleness (correct shape, stale values) is already handled by the background API refresh.

**See:** `src/lib/current-user.ts` (`isValidCachedData`), `tests/lib/current-user-cache.test.ts`, `docs/as-designed/state-management.md` (Cache Structural Guard section)

> **Insight:** The stale-while-revalidate pattern is great for perceived performance but creates this class of bug when the API contract changes across deploys. The structural guard is the minimum viable protection — it doesn't prevent all stale data (that's the API refresh's job), it only prevents the UI from crashing on structurally incompatible data. This is the same principle behind defensive JSON parsing in any client that caches API responses. (Session 362)

### CurrentUser Version Polling for Server-Side Change Detection
**Date:** 2026-03-19 (Conv 013)

Monotonic `data_version` counter on the `users` table, bumped by mutation endpoints that change CurrentUser-relevant data. Client polls `GET /api/me/version` every 30 seconds. Version mismatch triggers `refreshCurrentUser()`.

**Rationale:** CurrentUser had no mechanism to detect external changes (admin actions, other users' enrollments, incoming messages). Dashboard API calls were serving as the de facto freshness mechanism. Version polling is the simplest approach — one column, one endpoint, one `setInterval`. Compatible with future SSE/WebSocket upgrade.

**Scope:** Only bumps for data CurrentUser carries (identity, capabilities, enrollments, certs, courses, stats, moderations, unread counts). Does NOT bump for operational data (session schedules, earnings, feed activity) — those are fetched by dashboard APIs at navigation time.

**See:** `src/lib/user-data-version.ts`, `src/pages/api/me/version.ts`, `docs/as-designed/state-management.md` (Version Polling section)

> **Insight:** This is the Meteor DDP pattern minus the push transport. Meteor's oplog tailing was just *detecting* changes — the clever part was reactive propagation. We already have reactive propagation (`setCurrentUser` → `notifyListeners` → `useCurrentUser` re-renders). The version counter is the simplest possible change detector. (Conv 013)

### `setCurrentUser` (id, dataVersion) Dedup Guard
**Date:** 2026-05-06 (Conv 149)

`setCurrentUser` skips its `notifyListeners(user)` call when `prev.id === next.id && prev.dataVersion === next.dataVersion`. The new `CurrentUser` instance is dropped on the floor; the previously cached singleton remains the live reference.

**Trigger:** [UCM] sanity check found that `useCurrentUser()` returned a fresh ref on every `refreshCurrentUser()`. AppNavbar's window-focus handler calls `refreshCurrentUser()` on every tab-back, churning all `[currentUser]`-keyed `useMemo`/`useCallback` deps across the app. Conv 149's LE-P3/4/5 useMemo extractions were silently undermined by this — local memos were correct but the singleton-update layer leaked instability.

**Options Considered:**
1. Memoize at the hook level via setState callback equality check — only the React hook would dedup; raw `subscribeToUserChange` consumers still fire.
2. `deepEqual(prev, next)` guard in `refreshCurrentUser` — wider check but expensive and ad-hoc.
3. Dedup at `setCurrentUser` using existing `dataVersion` ← Chosen. O(1), reuses server-side invariant, fixes the issue at the singleton-update site so all consumers benefit.

**Rationale:** `dataVersion` is the server's source-of-truth for "did the data change?" — the polling endpoint already relies on it. Reusing this invariant at the singleton-update site means equality semantics are aligned with what the backend asserts, not invented locally.

**Consequences:** All `subscribeToUserChange` consumers fire only on real data changes. Test fixtures simulating server-driven updates must bump `dataVersion` (3 fixtures updated this conv); a "does NOT notify when refresh returns same id + dataVersion (dedup)" regression test was added. Production behavior unchanged because the server already bumps `dataVersion` on every CurrentUser-relevant mutation.

**See:** `src/lib/current-user.ts:setCurrentUser`, `tests/lib/current-user-listeners.test.ts`, `tests/lib/current-user-cache.test.ts`

> **Insight:** Memoization established at the consumer is undermined when the producer churns. When investigating why `useMemo`/`useCallback` extractions don't deliver expected wins, audit the source of each dep value — singleton/global stores often leak ref-instability that local memoization cannot recover. (Conv 149)

### `isHydrated` Flag Pattern for SSR-Safe CurrentUser-Derived Rendering
**Date:** 2026-05-20 (Conv 164)

Components that conditionally render based on `CurrentUser` (or any localStorage/window-derived state) MUST use the `isHydrated` flag pattern, not read state in the `useState` initializer. `getCurrentUser()` returns `null` on the server but reads `window.__peerloop`/localStorage on the client — using it in `useState(getCurrentUser())` causes a first-render SSR/CSR divergence that React reports as a hydration mismatch.

**Pattern:**
```tsx
const [user, setUser] = useState<CurrentUser | null>(null);
const [isHydrated, setIsHydrated] = useState(false);

useEffect(() => {
  const cached = getCurrentUser();
  if (cached) setUser(cached);
  setIsHydrated(true);
}, []);

{isHydrated && admin && <UserChip user={admin} />}
```

**Rationale:** Already the established convention in `AppNavbar.tsx:144-158`. AdminNavbar.tsx:90 was the lone outlier (`useState(getCurrentUser())`), root-causing [BR-NAVBAR-HYDRATE]. Repo grep `useState[<(].*getCurrentUser\(\)` returned exactly one hit pre-fix.

**Consequences:** User chip renders milliseconds-later (post-hydration) but the conditional block is hydration-stable. Convention applies to any role-gated UI derived from CurrentUser. Astro `data-astro-transition-persist` makes hydration errors travel across page navigations — a buggy navbar's error replays on subsequent non-admin routes, so a single buggy navbar can look like a project-wide problem (Conv 163 [DLE] misdiagnosis).

**See:** `src/components/layout/AppNavbar.tsx:144-158` (reference impl), `src/components/layout/AdminNavbar.tsx` (Conv 164 fix)

### CurrentUser "Consume What's Loaded" Principle
**Date:** 2026-03-19 (Conv 013)

If CurrentUser already loads data (for any reason), consume it from CurrentUser rather than re-fetching. Dashboard endpoints remain for operational/transactional data (earnings, session schedules, pending counts) that CurrentUser doesn't carry.

**Supersedes:** The earlier "summary vs. detail" rule from Session 171: *"If data answers a yes/no question across multiple pages, cache it. If it's only needed on one page, fetch it there."* That rule created a blind spot where dashboards re-fetched data CurrentUser already loaded for permission checking.

**Applied:** StudentDashboard refactor (Phase 2) will consume `useCurrentUser().getEnrollments()` instead of `fetch('/api/me/enrollments')`. TeacherDashboard and CreatorDashboard keep their endpoints (operational data is genuinely unique).

**See:** `docs/as-designed/state-management.md` (Principle section)

### Dashboard Data Flow: CurrentUser for Identity, API for Transactional
**Date:** 2026-03-26 (Conv 033)

All dashboards use `useCurrentUser()` for identity (name, handle, capabilities). Dedicated API endpoints return only transactional data (earnings, stats, pending counts, rosters). `is_available` stays in the teacher API response as operational state, not identity.

**Refines:** The "Consume What's Loaded" principle above. Conv 033 applied it uniformly: TeacherDashboard and CreatorDashboard were refactored to stop re-fetching identity from their APIs. API responses trimmed accordingly.

**Rationale:** Consistent pattern across all 4 dashboards (/learning, /teaching, /creating, /dashboard). Eliminates redundant identity fields in API payloads. Clear boundary: if CurrentUser has it, use it; if it's transactional, fetch it.

**See:** `src/components/dashboard/TeacherDashboard.tsx`, `src/components/dashboard/CreatorDashboard.tsx`

### Global State Pattern for Cross-Island Communication
**Date:** 2026-02-01 (Session 157)

Use global state on `window.__peerloop` with custom events for features that need to work across Astro React islands. This extends the CurrentUser pattern to other cross-cutting concerns.

**Applied to:** Login modal (can be triggered from any React island, executes callback after login)

**Pattern:**
- Store state on `window.__peerloop.{feature}`
- Dispatch custom events on state change (`peerloop:{feature}:change`)
- Components subscribe to events and re-render
- Pending callbacks stored globally, executed after completion

**Rationale:** Astro's multi-island architecture means each `client:load` React component is a separate React root. React Context cannot be shared between islands. Global state with events matches the established `currentUser` pattern.

**See:** `src/lib/auth-modal.ts`, `src/lib/current-user.ts`

### Monolithic-Filter Surfaces Split into Filter + List Islands via Window Events (LIST-1COL)
**Date:** 2026-06-14 (Conv 284)

To relocate a surface's filters into the `ListingShell` right panel, a monolithic single-island directory (filters as internal island state, e.g. `/members`) is split into a filters island + a list island coordinating via global `window` events (`members:filterchange` / `members:clearfilters`) — the same cross-island event pattern as the login modal. Both islands seed initial state from the **same** source (`?roles=` + defaults) so the first fetch matches with no mount race, and the filter island skips its mount-time dispatch (the list does its own initial fetch) to avoid a double fetch. Communities/courses were already two-island event-bus; this brings `/members` into the same architecture.

**Rationale:** A filters island and a list island can be placed independently in the DOM (filter in the shell's right panel, reflowed to the top on mobile) because their coordination is position-independent global events. Seeding both from one source and suppressing the filter island's initial dispatch are the two race-avoidance rules.

**See:** `src/components/members/MembersFilters.tsx`, `src/components/members/MembersDirectory.tsx`

### Admin Approach - Hybrid
**Date:** 2025-12-29

Use hybrid approach: Dedicated `/admin/*` routes + inline Context Actions.

**Rationale:** Admin dashboard for complex tasks; inline Context Actions for quick access while browsing public pages.

### Component Folder Organization: ui/, layout/, domain/
**Date:** 2026-02-01 (Session 153)

Component folders follow a "who + what" mental model:

```
src/components/
├── ui/                      # Design system primitives (charts, future: buttons, modals)
├── layout/                  # App shell (AppNavbar, Header, Footer, slide panels)
├── creators/
│   ├── profiles/            # Public-facing display
│   └── studio/              # Authoring tools
├── teachers/
│   ├── profiles/            # Public-facing display
│   └── workspace/           # Management tools
└── marketing/               # Visitor-facing (includes welcome/)
```

**Naming convention for domain subfolders:**
- `profiles/` - Public display components (cards, browse, profile views)
- `studio/` - Content authoring (editors, creation tools)
- `workspace/` - Task management (availability, earnings, sessions)

**Rationale:** Eliminates "which folder?" cognitive overhead. Names answer "who uses this?" (domain folder) and "what purpose?" (subfolder). Self-documenting import paths.

**See:** `src/components/` structure, Session 153 Decisions.md

### Context Actions Design
**Date:** 2025-12-29

- Icon-only trigger (no text label)
- Navigation to admin pages (no inline forms on public pages)
- Role-aware with sections for Admin, Creator, Teacher
- Build admin pages first (8.1-8.8), Context Actions on top (8.9)

**Rationale:** Security (privileged components not rendered for non-privileged users); simplicity (forms only in admin area).

### Explicit Feed Creation Model (Stream.io)
**Date:** 2026-01-20

Community feeds (Course Discussion, Instructor Feed) require explicit creator action to enable. Feeds are not auto-created when courses or creators are created.

- Course Discussion: Creator enables via Course Studio/Settings
- Instructor Feed: Creator enables via profile/settings
- Database flags: `discussion_feed_enabled`, `instructor_feed_enabled`
- Stream feed only created on first enable; disable hides but preserves data

**Rationale:** Resource control (not every course needs discussion); creator intent (opt-in signals commitment to moderate); Stream costs (only create feeds that will be used); progressive disclosure.

**See:** `src/pages/api/courses/[slug]/discussion-feed.ts`, `src/pages/api/me/instructor-feed.ts`

### Dedicated Stream Feed Groups
**Date:** 2026-01-20 (Stream-group constraint clarified Conv 280)

Use dedicated feed groups in Stream Dashboard for each feed type instead of sharing a single group with ID prefixes.

- `townhall` - System feed (admin-only; the user-facing slug is `system` since SYS-RENAME Conv 280, but the **Stream group stays `townhall`** — see below)
- `course` - Course discussion feeds (`course:{courseId}`)
- `instructor` - Instructor feeds (`instructor:{userId}`)
- `notification` - User notifications
- `user`, `timeline`, `timeline_aggregated` - User-specific feeds

**Stream groups are dashboard-declared, not write-creatable.** A Stream feed *group* is app-level config registered in the Stream dashboard; code can only *use* an existing group — pointing at an unregistered group 400s with `FeedConfigException` ("… feed group does not exist"). Discovered Conv 280 when renaming the system feed's group `townhall`→`system` 500'd at runtime; `db:seed` cannot provision it. The group value therefore stays `townhall` behind the documented `SYSTEM_STREAM_GROUP` constant in `src/lib/system-feed.ts`, even though the user-facing feed is now named `system`.

**Rationale:** Cleaner feed IDs; independent group configuration; eliminates client-side filtering; better separation of concerns. The Stream group is internal infra never shown to users, so renaming it for cosmetic alignment is zero user-facing benefit against a coordinated-dashboard-change cost.

**See:** `docs/reference/stream.md`, Stream Dashboard Feed Groups, `src/lib/system-feed.ts`

### SYS-RENAME: System Feed Renamed the-commons/townhall → `system` (Pre-Production Value Rename)
**Date:** 2026-06-14 (Conv 280)

The admin-only platform feed (formerly "The Commons" / "Town Hall") is renamed to **System** at the value level, not just display. Slug `the-commons`→`system`, community id `comm-the-commons`→`comm-system`, name `The Commons`→`System`, route `/api/feeds/townhall`→`/api/feeds/system`, component `TownHallFeed`→`SystemFeed`. New canonical constants in `src/lib/system-feed.ts` (SLUG/COMMUNITY_ID/NAME/STREAM_GROUP/STREAM_ID). The data model already keyed off `type:'system'` (`FeedsHub.tsx`), so the legacy names survived only as identifiers/comments. Substantive + structural names renamed now; ~26 files of cosmetic var-names/comments deferred to `[SYS-RENAME-COSMETIC]`. The one functional `townhall` value that stays is the Stream feed group (see Dedicated Stream Feed Groups).

**Cosmetic follow-up ([SYS-RENAME-COSMETIC], Conv 282):** the deferred cosmetic pass completed under a **"rename the branding, preserve the live value"** rule. Comments/log strings → "system feed", file-local `townhall*` vars → `systemFeed*` (5 feed/discover components), and the duplicate `SYSTEM_FEED_ID` consolidated into canonical `SYSTEM_FEED_SLUG`. **Deliberate keepers** (every `townhall` that is a live Stream identifier): `SYSTEM_STREAM_GROUP='townhall'` (`system-feed.ts`), `seed-feeds.mjs` `feedGroup:'townhall'`, `tests/lib/promotion.test.ts` `streamGroup:'townhall'`, and `townhall:main` Stream addresses in docs. Stream feed groups are dashboard-declared, not write-creatable — pointing code at a renamed group 500s with `FeedConfigException`. Excluded the cross-file `isTheCommons` prop rename (deferred). 18 code files + 13 reference docs corrected (incl. 3 factual auto-join-on-signup errors removed from ROLES/DB-API/google-oauth + the seed comment).

**Rationale:** Pre-production (no users, no real data, full seed control) is the one cheap window to rename values at the root before the slug/Stream group calcify post-launch; constant-izing-but-keeping-values leaves a permanent naming scar. ~50 files changed + re-seed; 5 gates green (test 6713); browser-verified (`/community/system` renders "System", admin POST 200, non-admin 403, old route 404).

**See:** `src/lib/system-feed.ts`

### Stream Chat for Private Messaging
**Date:** 2026-01-21

Use Stream Chat for private messaging between students, teachers, and creators. This aligns with the existing Stream.io integration for activity feeds.

**Rationale:** Client directive; consistent with existing Stream Feeds integration; reduces vendor complexity (single real-time provider); proven scalability; feature-rich (typing indicators, read receipts, reactions, threads).

**See:** `docs/as-designed/messaging.md`

### BigBlueButton for Video Conferencing
**Date:** 2026-01-20

Use BigBlueButton (BBB) as the video conferencing platform for tutoring sessions, implemented via VideoProvider abstraction.

- VideoProvider interface in `src/lib/video/types.ts`
- BBB adapter in `src/lib/video/bbb.ts`
- Environment: `BBB_URL`, `BBB_SECRET`
- Sessions table: `bbb_meeting_id`, `bbb_internal_meeting_id`, `bbb_attendee_pw`, `bbb_moderator_pw`

**Rationale:** Client (Brian) chose BBB over PlugNmeet for video platform. VideoProvider abstraction allows future swapping if needed.

**See:** `docs/reference/bigbluebutton.md`, `src/lib/video/`

### Homepage Landing Strategy (RESOLVED)
**Date:** 2026-01-29 (Session 145)
**Status:** Resolved - Option 2 chosen

Client decided to use the app itself as the landing page. Dashboard at `/`, marketing at `/welcome`.

**Decision:** Option 2 - App as Landing
- `/` shows DashLayout (dashboard) for all users
- `/welcome` contains marketing content (moved from old `/`)
- Marketing components (`src/components/home/`) still used at `/welcome`

**See:** "Dashboard as Homepage" decision above

### Session Booking Flow — Target Design
**Date:** 2026-03-04 (Session 325), updated 2026-03-05 (Session 331)

Defined the target booking flow for multi-session courses:
- **Single session:** Student selects course → teacher already known from enrollment (skip selection) → go directly to availability for next unbooked module
- **Multi-session:** After confirming, success screen offers "Book Next Session" → advances to next unbooked module in `module_order` sequence
- **Module ordering:** Positional — modules assigned by chronological order of booked sessions, not stored at booking time. See "Positional Module Assignment" decision in Database section.
- **Session limit:** API enforces `completed + scheduled < module count`; 422 when all modules have sessions
- **Cancellation policy (Session 333):** Always allowed (per CD-033: "bail at anytime"). Late cancellations (< 24h before start) require a reason, sent to teacher as in-app notification. `is_late_cancel` flag saved for admin visibility. `cancelled_at` timestamp recorded.
- **Reschedule limit (Session 333):** Max 2 reschedules per session. 3rd attempt returns 422 with guidance to cancel and rebook. `reschedule_count` tracked per session; `can_reschedule` flag in GET response.
- **Rebooking guard (Session 333):** `POST /api/sessions` rejects if `enrollment.status` not in `('enrolled', 'in_progress')` — returns 403.
- **Mark Complete gating (Session 333):** Module completion button disabled until the module's tutoring session is `completed`. Contextual hints: "Book a session first" (linked) / "Session scheduled for [date]" / enabled. Uses existing `GET /api/sessions` with client-side module→status mapping.
- **Session completion healing (Session 334):** Teachers and creators can manually mark sessions complete via `POST /api/sessions/[id]/complete` when BBB webhook fails. Guards: must be `teacher_id` or `creator_id`, `scheduled_end` must be past. All completion paths (webhook, manual, admin) use shared `completeSession()` function.

**Rationale:** The enrollment already establishes the teacher. Modules define session content. The booking wizard should reflect both rather than requiring re-selection. Cancellation/reschedule policies balance student freedom (CD-033) with teacher accountability.

**See:** `docs/as-designed/session-booking.md`, `src/lib/booking.ts`

### Platform Terminology: GLOSSARY.md as Source of Truth
**Date:** 2026-03-05 (Session 346)

Created `GLOSSARY.md` at docs repo root as the single prescriptive source of truth for all platform terminology. Covers identity hierarchy, core domain terms, DB table naming, component naming, and URL routes. If code contradicts the glossary, the code is the bug.

**Rationale:** Naming inconsistencies ("Student-Teacher" vs "Teacher," "user" vs "member") had cascaded into schema ambiguities, code bugs (the `/discover/teachers` duplication), and documentation drift. A dedicated glossary prevents recurrence by establishing rules before code is written.

**See:** `GLOSSARY.md`

### "Teacher" Replaces "Student-Teacher" Platform-Wide
**Date:** 2026-03-05 (Session 346)

The term "Student-Teacher" (and abbreviations "S-T", "ST") is retired. Use "Teacher" everywhere — schema, code, components, API routes, UI text, documentation. Since all teachers on Peerloop are former students (that's the flywheel), the "student" prefix is redundant and confusing.

**Trigger:** `student_teachers` table name made rows look like people instead of certifications, causing a JOIN bug. The broader naming ("STCard", "st-sessions", "student_teacher_id") compounded the confusion.

**Consequence:** `student_teachers` table → `teacher_certifications`. Components: `ST*` → `Teacher*`. Routes: `/api/student-teachers/*` → `/api/teachers/*`. User story IDs (US-T###) stay frozen.

**See:** `GLOSSARY.md` §1, PLAN.md TERMINOLOGY block

### Identity Hierarchy: Visitor → Member → Student → Teacher → Creator
**Date:** 2026-03-05 (Session 346)

Formal identity hierarchy: **Visitor** (unauthenticated) → **Member** (has account) → **Student** (enrolled) → **Teacher** (certified) → **Creator** (creates courses). These are progressive and non-exclusive — one person can hold multiple roles simultaneously.

In code: `users` table and `user`/`userId` stay (universal auth convention). In UI text: "member" for authenticated, "visitor" for unauthenticated. Never call a non-logged-in person a "user" in UI text.

**Rationale:** The hierarchy maps to the Peerloop flywheel. Clear definitions prevent code that conflates different identity levels.

**See:** `GLOSSARY.md` §1

### Instructor-Only Webcam Storage
**Date:** 2026-03-27 Conv 037

Only the instructor's (Teacher's) webcam is stored in session recordings. Student webcams are not persisted.

**Rationale:** Student privacy — students may include minors. Also reduces file size significantly (~50-200MB/hour for instructor-only vs multi-stream). Blindside Networks provides per-account webcam storage configuration.

**Consequences:** Documented in POLICIES.md §6. ✅ Enabled by Blindside Networks (2026-03-29, support ticket #21121).

### BBB `autoStartRecording=true` Default Across All Sessions
**Date:** 2026-05-13 Conv 159

All BBB room creations send both `record=true` and `autoStartRecording=true`. Implemented as a three-layer fallback (`options ?? config.defaults ?? true`) in `BBBProvider`: `CreateRoomOptions.autoStartRecording?` (caller), `BBBConfig.defaults.autoStartRecording` (factory default `true`), and explicit `true` in the `join.ts` `roomOptions` for clarity.

**Rationale:** `record=true` only enables BBB's recording capability — the moderator's Record button appears, but recording does not begin until the moderator clicks it. Audit during a recording-gap investigation discovered `autoStartRecording` was never sent anywhere in the codebase; the resulting "moderator must remember to click Record" workflow had been silently leaking recordings. Peerloop policy is "every 1-on-1 tutoring session recorded", so auto-start matches policy. The two-parameter BBB design fits universities (per-session opt-in by instructor); for our use case it's a footgun.

**Consequences:** All future sessions auto-start recording. No UI option to disable auto-start (would be added via existing `enableRecording=false` toggle if needed). Mirror pattern follows `enableRecording`'s existing 3-layer fallback.

**See:** `src/lib/video/bbb.ts`, `src/lib/video/types.ts`, `src/pages/api/sessions/[id]/join.ts`, `docs/reference/bigbluebutton.md` §Recording Lifecycle & Diagnostics

### Await (Not waitUntil) for Must-Succeed Worker Side-Effects
**Date:** 2026-04-12 (Conv 109)

In Cloudflare Workers, any side-effect that must succeed (DB writes, notifications) must be `await`ed before the Response is returned. `ctx.waitUntil()` is for best-effort work only (telemetry, cache warming). Fire-and-forget with `.catch()` is acceptable for non-critical convenience operations.

**Rationale:** Workers can kill unawaited promises after Response is sent. Client demo revealed session invite notifications silently failing because `notifySessionInvite()` was not awaited — teacher saw success but student never received notification.

> **Insight:** The `waitUntil` vs `await` distinction is a common source of subtle bugs in Workers. The failure mode is silent — the operation works in dev (where the runtime is more lenient) but drops in production under load.

---


### HOME-FEED-MERGE: `/` Landing Feed via One Auth-Aware Endpoint (Server-Side Interleaving)
**Date:** 2026-06-10 (Conv 258)

Per client directive, `/feed` content merges into the Home (`/`) page — only the progression Nudge(s) plus the feed remain of the prior Home content; `/feed` stays as a route but is auth-only (visitor → `/`) and is removed from the Sidebar (NAV + COLLAPSED_NAV; route kept, mirroring the Conv-250 `/feeds` removal). The Home feed is served by **one auth-aware `/api/feeds/smart` endpoint** doing server-side interleaving (chosen over two endpoints with client merge), with two internal aggregators — a member feed (gated by data) and a marketing feed (public, not auth-gated). Design: 3 sources + gradient + S3-backfill; cursor Option A (mode-selected backbone, `(created_at, id)` tiebreaker, "caught up → discover" boundary, page-1 best-of-recent boost); visible "you're missing this" framing; quiet intent-preserving per-post CTAs + sticky sign-up bar; Home feed-leads with a visitor thin-orienting-line. Updates the prior FeedsHub-on-`/`-landing direction (see `FeedsHub Mounted on "/"` above) for the Home feed surface.

**Rationale:** Server-side interleaving owns the source gradient so the client stays a dumb island; conversion comes from a concentrated loud ask (sticky bar) over a credible quiet stream. Full design in `plan/home-feed-merge/README.md`.

**Consequences:** Sidebar `/feed` link removed (built, `src/components/Sidebar.tsx`). A speculative client-meeting feeds model (Discovery Rails, rail taxonomy, Commons → admin-only, promotion-in-MVP) is captured at `plan/home-feed-merge/client-meeting-2026-06-10-feeds.md` but is NOT adopted — gated on client sign-off on (1) townhall retirement and (2) promotion pricing/policy.

### HOME-FEED-MERGE Marketing Feed: Rails-Backed Cards + Tier-5 Commons Anchor Retired
**Date:** 2026-06-11 (Conv 266)

The marketing (public/visitor) aggregator `getMarketingCandidates` (`src/lib/smart-feed/marketing.ts`) consumes an **injected `DiscoveryRailsBlob`** (Conv 261) for its suggestion cards — only the sample-post query is net-new; the 6 trending/popular/new × course/community rails are a pure mapping, no duplicate aggregation (the redundancy `[RECO-UNIFY]` #31 removes anyway). The Conv-258 always-full cascade's **tier-5 "The Commons anchor" is dropped** (tiers 1–4 only); `getMarketingCandidates` excludes `system` feeds entirely and no anchor sub-task is created.

**Rationale:** Dependency-injecting the rails blob keeps the builder unit-testable and reuses the exact card set. Tier-5's sole premise ("everyone's auto-joined the Commons") was deleted by SYS-RENAME (Conv 259), which retired `autoJoinTheCommons` and made the System feed admin-only; tiers 1–4 already draw globally from all public content, so always-full still holds. Pulling Commons posts into a logged-out feed would leak admin-only content.

**Consequences:** Phase 3 must thread the real blob (KV-read + compute fallback) into `getSmartFeed`. Member-facing System content reaches users via Announcements (`[ADMIN-FEED-UI]` #30), not the marketing feed.

### HOME-FEED-MERGE: Two-Tier Rails Read Extracted to a Shared Lib Module
**Date:** 2026-06-11 (Conv 267)

The KV-read + compute-fallback that fetches the `DiscoveryRailsBlob` is extracted into a shared `src/lib/discovery-rails/serve.ts` (`loadDiscoveryRailsBlob(db, kv?)` + `getDiscoveryRailsKV()`), consumed by **both** the `/api/discovery/rails` endpoint (refactored onto it, behavior-identical) and the un-gated `/api/feeds/smart` endpoint (Phase 3) — chosen over duplicating the two-tier logic in the smart endpoint. KV is passed as a parameter so the read policy stays unit-testable. Phase 3 also un-gates `/api/feeds/smart` (drops the 401 → auth-aware `userId = session?.userId ?? null`, degrade-to-no-cards on blob failure) and adds auth-varying cache headers (visitor `public,max-age=60` + `Vary:Cookie`; authed `private,no-store`).

**Rationale:** One implementation, no drift between the two rails consumers; durable per §Solution Quality. The endpoint is the only gate now (middleware lists `/api/` as public).

**Consequences:** `serve.ts` + barrel exports added; `rails.ts` inline logic deleted (~40 lines), `X-Discovery-Source` preserved. The visitor-cacheable smart feed depends on this shared reader.

### PROMOTE-PIPELINE Delivery = Reference + Teaser Lane (D1 Only, No Stream Write)
**Date:** 2026-06-11 (Conv 263)

Promotion delivers cross-membership-boundary via the **pull** model: a promoted post lives only in its origin Stream feed; a `post_promotions` D1 row references it (`source_activity_id`), and every higher-feed appearance is assembled at **read time** (lane query → enrich-by-id → display-only teaser). Stream is **never written** to — no copy (rejected: engagement-split + duplication) and no `to`-target (rejected: SYS-RENAME made System admin-only + retired `autoJoinTheCommons`, so a TO-target reaches only admins). This rewrites the shipped copy-based `promote.ts` (Conv 262) into a reference-only writer; `post_promotions.target_activity_id` is dropped. A `canPromote` flag is added to feed GET. The Announcement model reuses the same pull pattern. Inbound visitors get posture A (read-only — see [§4 Auth](04-auth.md)).

**Rationale:** The app already reads feeds three ways — native `feed.get`, `timeline:userId` fanout (both push, in-boundary only), and SmartFeed D1-select + `getActivitiesByIds` (pull). Cross-boundary delivery is exactly what feed-level access control blocks, so only the pull pattern delivers uniformly at every level (Course→Community→System). Full design in `plan/home-feed-merge/README.md`.

### PROMOTE-PIPELINE Step 3: Promote Endpoint Speaks Stream Activity ID (Not `feed_activities.id`)
**Date:** 2026-06-11 (Conv 269)

The `POST /api/feeds/promote` endpoint body is `{ streamActivityId, password }`; it resolves the canonical row via `WHERE stream_activity_id = ?` (UNIQUE-indexed), not by the `feed_activities.id` FK the Conv-262 endpoint keyed on. Internal FK / `recordPromotion` / lane stay on `feed_activities.id` — only the **client-facing contract** speaks Stream id. Rejected: the read path attaching `feedActivityId` to each activity (endpoint unchanged).

**Rationale:** The client holds only the Stream activity id everywhere — reactions/comments already POST `activityId: activity.id`. Resolving by Stream id matches the system-wide client identity model and scales free to every future promote surface (home feed, nudge), which also hold only Stream ids; the read-path-join option would repeat the join per surface. The UNIQUE index on `feed_activities.stream_activity_id` also hardens the 1:1 lookup.

**Consequences:** Endpoint body renamed; dead "no Stream activity" guard dropped; `idx_feed_activities_stream` UNIQUE index added; 8 new endpoint tests. `src/pages/api/feeds/promote.ts`, `migrations/0001_schema.sql`.

### Entity-Promo (FEED-U3) Surfaces via the Marketing/Discovery Path, Not the Promoted Lane; A2 Composer Authors Into the Entity's Own Public Feed
**Date:** 2026-06-12 (Conv 274)

The entity-promo home-feed render path uses the **marketing sample-post query** (any public-feed post), NOT the Promoted lane — a code trace found `getSmartFeed` never calls `getPromotedActivities` and `GET /api/feeds/promoted` has no UI consumer at all (the lane-on-feed-pages path is a separate, unbuilt feature). An entity-promo is a Stream post carrying `postKind:'entity_promo'` + `promoEntityType` + `promoEntityId` custom fields; it is kept as `kind='sample-post'` (NOT a new `kind='entity-promo'`, which the orchestrator's `e.kind === 'sample-post'` injectable filter would silently drop) and discriminated at **render** via a `promoContext` field (checked before the discovery branch in `SmartFeed.tsx`), with its anchor resolved from `promoEntityType:promoEntityId` (reusing `fetchDiscoveryAnchors`), not from the post's home feed. The A2 composer (`createEntityPromo`) authors the promo into the **entity's own public feed** (from=to=entity feed) and also records a `post_promotions` row — chosen over authoring into the chain target + building the unbuilt lane→home-feed consumer.

**Rationale:** Cross-boundary reach to non-members is already achieved by home discovery of a public-feed post, so the lowest-risk path coheres with the shipped backbone and carries no unbuilt-lane dependency. Keeping `kind='sample-post'` means the orchestrator never special-cases entity-promo (no drop risk) while render still picks the promoted-entity anchor. The `post_promotions` row exists for U3c moderation + a future lane, not for home-feed visibility.

**Consequences:** `src/lib/promotion/create.ts` (`createEntityPromo`), `src/lib/smart-feed/enrichment.ts` (`readPromoFields` + `promoContext`), `src/components/feed/SmartFeed.tsx` (entity-promo render branch), `src/pages/api/feeds/promote-entity.ts` + `promotable-entities.ts`, `src/components/feed/EntityPromoComposer.tsx` (`@matt-inspired`, unmounted until U3d). U3c owns the deferred announcement model; U3d mounts the composer.

### Announcement Fan-Out = A+B (Read-Time Feed Pin + Optional Per-User Notify) — D1-Only (FEED-U3c④)
**Date:** 2026-06-12 (Conv 277)

Platform-wide announcements (admin→all-members broadcast) deliver via **A+B**: every announcement renders in the home smart feed at read time (read-time fan-out, zero write amplification, mirrors promotion delivery model ① — `announcements`↔`post_promotions`, `announcement_dismissals`↔`smart_feed_dismissals`, dials↔`platform_stats`, `purgeExpiredAnnouncements`↔`purgeExpiredPromotions`), and an optional `notify` flag additionally fans out a per-user 'system' notification (chunked over `getAllActiveUserIds`) for time-sensitive ones (e.g. maintenance) that must be seen even if the user never opens the feed. The announcement is **D1-only** — text lives entirely in the `announcements` table; no Stream activity, no per-read Stream fetch (a one-way broadcast needs no native reactions/comments and references no pre-existing post). The pin contract is "pinned, first-page-only, never in the cursor," wired in the smart-feed orchestrator (parallel fetch + widened `FeedItem` union + prepend), not the lib. Rejected: pure A (can't guarantee an urgent message is seen), pure B (buries feed-native posts in the inbox), C/dedicated read path (most net-new code, no reuse), Stream-backed storage (would only hold text D1 stores directly).

**Rationale:** An announcement is structurally "a post broadcast to everyone," so the durable choice reuses the settled promotion read-time substrate; the 4 example announcements showed ①③④ are feed-native while only maintenance wants the bell, so A+B covers both surfaces with the least new code. The earlier "A vs C" framing conflated "own table" with "own read path" — the real reuse is the lane assembly, not Stream.

**Consequences:** `src/lib/announcements/{config,create,query,dismiss,retention}.ts`, `src/lib/auth/session.ts` (`getAllActiveUserIds`), `src/lib/smart-feed/index.ts` (pin), `src/components/feed/AnnouncementCard.tsx` + `SmartFeed.tsx`, `/admin/announcements` page+island+nav, 3 endpoints, `workers/cron/src/index.ts` (`purgeExpiredAnnouncements`). Schema in 02-database.md (`announcements` + `announcement_dismissals` + optional `active_until`).
