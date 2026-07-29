# DISCOVERY-ASIDE — the recommendations aside: narrow screens, recency, and community interests

**Focus:** Restore a recommendations surface below `lg`, add a Recently Visited section, and give communities first-class interest tags
**Status:** ✅ **COMPLETE — all four phases shipped** (Phases 1–3 Conv 431, Phase 4 Conv 432)
**Tasks:** `[REC-MOBILE]` (Ph1 ✅) · `[REC-RECENT]` (Ph2–3 ✅) · `[COMM-TOPICS]` (Ph4 ✅)
**Origin:** `[REC-REHOME]` (Conv 427) rehomed the two recommendation carousels into the right rail and accepted, explicitly, that narrow screens would lose the surface entirely. Conv 431 examined the consequence and the discussion expanded into recency + community taxonomy.

---

## The defect

Conv 427 (`9b0c5dff`) deleted `RecommendedCourses.tsx` / `RecommendedCommunities.tsx` and both `/api/recommendations/*` endpoints, replacing them with `DiscoveryRails` mounted in `<aside class="hidden lg:block lg:flex-1">` on `/`, `/courses`, `/communities`.

The deleted carousels had **no breakpoint gating** — an `overflow-x-auto` horizontal scroll band, a shape that suits a phone. Their replacement is desktop-only, and `--breakpoint-lg` is **1025px** in this project (`tokens-tailwind-bridge.css:319`, Conv 175 — Matt's desktop boundary), not the stock 1024.

The commit says so outright: *"Below the lg breakpoint the rail is hidden, so there is currently no recommendations surface on narrow screens (accepted caveat, flagged to the user)."*

**Who loses it:** every viewport under 1025px — phones, iPad portrait (768), and 1024px-class landscape iPads, the last by one pixel.

**Why it matters more than a missing panel:** the aside is the only personalized surface on those pages. `CoursesCatalog.tsx:133-148` sorts only by popular / rating / newest / price-low / price-high — all global. So below 1025px a signed-in member with declared interests sees `/courses` **identical to an anonymous visitor's view**. The `interestTopicIds` are already loaded in `CurrentUser` at zero request cost and nothing on the page uses them.

**Why no gate caught it:** all five gates were green through Conv 427 and still are. A surface hidden behind a media query is not a type error, lint error, test failure or build failure, and nothing in the suite asserts that a given surface renders at 375px. This is the same blind spot as `[MINWIDTH]` / `[SIDEBAR-COLLIDE]`.

---

## The three pages are not equally damaged

Ranked by severity — the opposite of what catalog size suggests (6 courses, 4 communities in seed):

### 1. `/communities` — total loss, no recovery path

Communities have **no topics of their own**. `CommunitiesFilters.tsx:5` states it: *"Communities have no level/topic attributes (unlike courses)."* The rails layer **manufactures** a topical identity per community by walking progressions → courses → `course_tags` → `tags` (`compute.ts:107-111`).

That derived signal has **exactly one consumer** — the aside. No filter, sort or facet exposes it; `CommunitiesFilters` offers only search + three sorts (`members`/`posts`/`newest`). Hide the aside and the signal becomes unreachable anywhere in the product.

Measured against the seed, the derivation does work today:

| Community | derived topics |
|---|---|
| AI for You | 3 |
| Automation Majors | 2 |
| The Q-System | 2 |
| System | 0 *(excluded from catalog anyway)* |

But it has a **cold-start hole**: a community with no progressions, or none of whose courses are tagged, derives zero topics — and `lanes.ts:119` only scores entities with `overlap > 0`, so it can never enter For You. It reaches Trending/New/Popular only. New communities are exactly the ones needing discovery.

### 2. `/courses` — degraded, manually recoverable

`CoursesFilters` carries a **topic** filter reading the same `course_tags` data the For You lane ranks on. A narrow-screen user who knows what they want can approximate the lane by hand. Clumsy — requires intent rather than serendipity — but the path exists.

### 3. Home — no real gap

`SmartFeed` renders interest-matched `SuggestionCard`s from the **same** rails blob (`marketing.ts:333` computes `topicMatched` from `viewerTopicIds`; `buildCards()` is fed by `railsBlob` at `:406`), with no breakpoint gating anywhere in `SmartFeed.tsx` or `SuggestionCard.tsx`. Home's mobile column already carries an interest-ranked entity surface.

---

## Findings that shaped the design

**1. `DiscoveryRails` is not chrome-free.** Its own doc comment (`:33-35`) claims it "renders lanes and nothing else — no panel chrome, no width." Line 146 renders `rounded-16 border border-border-default bg-white p-16`. The "no width" half is true; the chrome claim is false and the comment needs fixing. An inline mobile mount inherits a white bordered panel.

**2. `feed_visits` is a trap, not a recency shortcut.** Its shape looks perfect — `(user_id, feed_type ∈ {course,community,system}, feed_id, last_visited_at)`. It is unusable for two independent reasons:
  - **Wrong event.** `recordFeedVisit` is called only from the feed API endpoints. Bare `/course/slug` and `/community/slug` both default to `tab = 'about'` (`[...tab].astro:106` / `:76`), so it records "opened the Feed tab", not "visited".
  - **Writing to it would break unread badges.** `last_visited_at` is load-bearing for new-post counts (`candidates.ts:164`, `feed-activity.ts:158`). Bumping it on an About-tab landing would mark the feed seen and silently clear badges for unread posts.

  ⇒ Recency needs its **own** store.

**3. The course → community parent chain is nullable.** `courses.progression_id TEXT REFERENCES progressions(id) ON DELETE SET NULL` (`0001_schema.sql:342`). All 6 seeded courses resolve to a community, but the chain is optional by design — "parent communities of recently visited courses" needs defined behaviour when there is no parent.

**4. The taxonomy already has the shape for community tags.** `user_tags` and `course_tags` are the identical two-column join onto `tags`, and `tags.topic_id NOT NULL` rolls topics up for free. `community_tags` is the **third instance of an established pattern**, not a new design.

---

## Phase 1 — narrow-screen aside (the regression) ✅ COMPLETE (Conv 431)

- [x] `maxLanes` prop on `DiscoveryRails` — slices after `buildDiscoveryLanes`, so claim-order is untouched and the kept lane is the one a full-height mount leads with
- [x] Mounted inline in the listing column on `/courses` + `/communities`, `lg:hidden` so wide screens don't get it twice. **Home skipped** (user decision) — its `SmartFeed` already renders ungated interest-matched suggestion-cards
- [x] **No** fallback children on the narrow mount — an empty rail collapses to nothing
- [x] Placed below `OnboardingNudgeBanner`, above the catalog
- [x] Fixed the false "no panel chrome" doc comment
- [x] Verified live at 375px and 320px via the `[VPHARNESS]` iframe harness

### A second island per host — and the de-dupe it forced

Both mounts hydrate at **every** viewport: the hidden one is `display:none`, not un-rendered. `loadDiscoveryRails` had **no in-flight de-duplication**, so on a cold cache both islands would miss `readCache()` in the same tick and fire two identical requests for a blob that is global and identical for every viewer.

Added a module-level `inFlight` promise in `lib/discovery-rails/client.ts`, cleared on settle (either outcome, so a rejection can never poison it). `forceRefresh` deliberately does **not** join an in-flight load — its caller is asking for a fresh read.

### Live verification (dev seed, iframe harness)

Exactly one mount visible at every width; desktop unchanged; **zero horizontal overflow at 320px**:

| URL | width | narrow mount | aside | lane shown |
|---|---|---|---|---|
| `/courses` | 375 / 320 | visible (329px) | `display:none` | Trending courses |
| `/communities` | 375 / 320 | visible | `display:none` | Trending communities |
| `/courses` | 1280 | hidden | visible, 3 lanes | unchanged |
| `/communities` | 1280 | hidden | visible, 2 lanes | unchanged |

**The count-not-filter decision proven in both directions**, signed in as `david.r@example.com` (interests `top-001`, `top-014`):

| viewer | `/courses` @375 | `/communities` @375 |
|---|---|---|
| visitor, no interests | **Trending courses** | **Trending communities** |
| member, with interests | **Courses for you** | **Communities for you** |

A lane-kind filter ("For You only") would have rendered **nothing** in the top row — every signed-out viewer — which is the defect this mount exists to fix. The `/communities` result also proves the *derived* community topics resolve end-to-end through the new mount.

Gates: 5 green — `tsc` clean · `astro check` 0 errors · lint 0 errors (164 pre-existing warnings) · suite **6235 → 6247** (+12: 4 client de-dupe + 8 component) · build complete · `prov:sweep` consistent.

⚠️ **Not yet exercised: the `maxItems={3}` cap on the narrow mount.** The dev seed is too small to fill a lane — the courses Trending lane holds 1 item and communities' holds 2, so the cap never binds. It is pinned by unit test, not by live measurement.

**Why "first available lane" rather than "For You only":** `lanes.ts:108` skips the For You lane entirely when the viewer has no interests, and visitors never have any. For-You-only renders an empty mobile surface for every signed-out user — the population most in need of discovery, and a repeat of the very mistake this phase fixes.

---

## Phases 2–3 — visit tracking + the Recently Visited lane ✅ COMPLETE (Conv 431)

**Storage: localStorage + denormalized snapshot** (user decision). The decisive constraint was one the plan hadn't named: every rail is built `LIMIT topN` (12 items), so **the blob cannot render an arbitrary recently-visited entity** — most visits aren't in it. Storing the display fields at visit time (the entity page has already rendered them) means the lane needs no lookup, no endpoint and no request, and it covers signed-out visitors. A server-only store would have served *fewer* people than the client one, repeating the defect Phase 1 just fixed.

- [x] `src/lib/recent-visits.ts` — capped at 20, newest-first, de-duped per entity, injectable storage/clock
- [x] Identity is **slug**, not id: it's in the URL on both entity pages, unique per entity type, and what the rendered links already use. The course page's parent community (`courses.ts:122-127`) carries no `id`, so slug avoided changing a shared loader.
- [x] `RecordVisit.tsx` — headless `client:load` island on both entity pages. Chosen over an inline `<script define:vars>` because **`define:vars` has zero uses in this codebase**, while every other client-side effect on those pages is already an island.
- [x] `src/lib/discovery-rails/recent-lane.ts` — pure splice, kept out of `lanes.ts` (that module is pure over the *blob*; recency is per-device client state with a different lifetime)
- [x] Type contract: `RailEntity.reason` widened to `RailKind | 'recent'`, and `'recent'` added to `LaneKind` but **deliberately absent from `LANE_ORDER`** — the recency lane is *spliced*, never emitted by the builder. Widening `reason` immediately broke a test helper that assigned `items[0].reason` into a blob rail's `kind`; that break was correct (a *blob* rail genuinely cannot be `'recent'`) and was fixed by narrowing the helper rather than casting. Anything touching `lanes.ts` in Phase 4 must preserve both halves.
- [x] Per-item remove control, **lane-scoped and time-based**: a removal stamps a time; an entry is hidden while `removedAt >= visitedAt`, so **re-visiting resurrects it**. Never suppresses the entity from For You / Trending — those are a different claim.
- [x] Deliberately **not** built on `ephemeral-dismiss.ts`. That module disables persistence in dev/staging so QA sees all dismissible chrome; removing a row here is a **list edit**, not chrome dismissal, so it persists everywhere. *(This supersedes the 🟠 caveat recorded earlier in this file's Cross-references — it does not apply.)*

### Placement and claim order — verified live, both directions

Recency lands **after For You** (user decision), so the narrow `maxLanes={1}` mount still leads with personalization. Claim order — `lanes.ts`'s "an entity appears in at most ONE lane" — is preserved through the splice:

- Visiting `ai-tools-overview` produced **no** recency lane, because For You had already claimed it. Correct, and initially mistaken for a bug.
- Visiting `vibe-coding-101` (which sat alone in *Popular*) put it in recency **and removed the Popular lane entirely** — emptied by the claim, so dropped rather than left as a bare heading.

### The `/communities` bridge — verified

Signed out, `/communities` led with **"Recently visited communities" → `/community/ai-for-you`**, derived purely from two visited **courses**, with no course anywhere on the page. That is the user's own design: import the course signal while keeping the page's entity type pure.

Home's aside gets recency for both types and shows **literal** history, not the bridge — on Home a course is a legitimate row.

### Cross-island sync ✅ CLOSED (Conv 431, same conv)

Initially shipped as a known limitation — the two islands per host held **independent** React state, so a removal on one left the other stale and resizing across `lg` brought the removed row back until reload. Closed on the user's call rather than carried.

`subscribeRecentVisits()` in the store, with `notifyChange()` fired by all three mutators (`recordVisit` / `removeRecentVisit` / `clearRecentVisits`). A window `CustomEvent`, matching how this codebase already does cross-island messaging (`courses:filterchange`, `communities:filterchange`, `lib/auth-modal.ts`'s own `notifyChange`).

**The `storage` event cannot solve the same-document case** — the spec fires it only in *other* documents, never the one that made the write. It is subscribed to as well, which closes the same defect one level out (cross-tab). That was an addition beyond the reported issue, made because it is the same subscription function and the identical defect class.

The direct tick-bump in `handleRemove` was **removed**, leaving one path: mutate the store, everybody re-reads — including the island that made the change, since `dispatchEvent` also runs listeners on the dispatching window. The `setState` now lives in a subscription *callback*, which is the case the `set-state-in-effect` rule explicitly permits, so lint stayed at its 164 baseline.

**Verified live, both dimensions:**

| | before | after remove on ONE island |
|---|---|---|
| narrow mount (clicked) | `vibe-coding-101`, `ai-tools-overview` | `ai-tools-overview` |
| aside (not clicked) | `vibe-coding-101`, `ai-tools-overview` | **`ai-tools-overview`** |
| after resizing past `lg` | — | no stale row |

Cross-tab confirmed with two real tabs: Tab B's list went from two rows to one after Tab A removed an entry, with no navigation in Tab B.

⚠️ **The dev seed masks this lane, the same way it masks `maxItems={3}`.** With 6 courses and 4 communities, For You claims nearly everything, so the recency lane rarely surfaces at all — the systematic starvation is a *consequence* of the after-For-You placement, visible immediately at seed scale and much less likely at production scale. Both behaviours are pinned by unit test; neither is provable live at this data volume. Worth re-measuring against a larger dataset before either is next changed.

Suite **6284 → 6289** (+5: 4 store-subscription, 1 two-island component test that reproduces the defect as it actually occurred).

Gates: 5 green — suite **6247 → 6284** (+37: 20 store, 12 lane-splice, 5 component); lint back at the 164 baseline (the first version added a `set-state-in-effect` warning; replaced with a memo, since the component provably only reaches that code post-mount).

**No generic course lane on `/communities`** (user decision, Conv 431). The aside is a narrow vertical column and every lane pushes the next below the fold; spending that budget on the entity type the user didn't come for is a poor trade, and Home already exists as the both-types surface. The recency bridge — *parent communities of recently visited courses* — imports the course signal while keeping the page's entity type pure, which is the more coherent version of the same impulse. If courses are ever wanted here for conversion reasons, make it contextual ("Courses in your communities") and place it last.

---

## Phase 4 — community interest tags

Reframed in Conv 431 from optional polish to **the piece that retires the underlying weakness**: it closes the cold-start hole, gives narrow-screen users a manual fallback on the worst-hit page, and makes community topics readable by something other than the rails blob.

- [x] `community_tags (community_id, tag_id)` — third instance of the `user_tags` / `course_tags` pattern. Pre-launch, so it lands directly in `migrations/0001_schema.sql`
- [x] **Backfill by materializing today's derivation** — run the existing progressions→courses→tags query once as seed. Every existing community starts exactly where it is now; nothing regresses, and today's implicit value becomes tomorrow's editable default
- [x] Pre-seed the picker at creation from the creator's own `user_tags` (`communities.creator_id` exists; creators already carry tags) — the blank optional field is why taxonomy fields get skipped
- [x] **Union** explicit tags with the derived roll-up at query time rather than overriding — a community genuinely does relate to its courses' topics, and the derived half self-corrects when explicit tags rot
- [x] Unblocks a **topic filter on the `/communities` catalog** — the missing affordance that makes `/communities` the worst-hit page

### Creators are the primary source, but not the sole one

Courses are already creator-sole-source with **no cap**: `/api/me/courses/[id]/index.ts:295` returns 403 unless `creator_id === userId` (not even an admin can edit through that route), and `:434-450` is an unbounded `for` loop over `body.tags`.

**The rails changed what a tag is worth.** Tags used to be a *filing system* — a user picks a topic filter and pulls matching courses. Over-tagging got you into more filter results: mildly annoying and self-limiting, because the user chose the filter. The For You lane makes tags a **distribution channel**: they determine whose personalized lane you appear in, unprompted, and `lanes.ts:124` ranks by `overlap` count — *the more topics you claim, the higher you rank*. A creator optimizing for reach should tag everything, and the system rewards it. With no cap, the exploit is one API call.

This risk **pre-dates this work** and already applies to courses. What is new is that the rails amplified it and it would extend to a second entity type.

Agreed mitigations (Conv 431):

- [x] **Cap the tag count** — and retrofit the same cap onto courses, where the hole is already open. Calibrated from real usage: 55 tags exist, courses average **2.5** and max **3**, so ~5 is generous while blocking claim-all-55. *This is the non-negotiable one — a live incentive problem with a one-line exploit.*
- [x] **Union with derivation** (above), so the signal self-corrects when explicit tags drift
- [x] **Let moderators edit, not only the creator** — communities are collectively run; a course has one accountable author, a community does not, and a creator who drifts away shouldn't freeze a wrong tag
- [x] **Admin override** — admins already govern the taxonomy itself via `/api/admin/topics/[id].ts`; entity-level correction is the natural companion

Other reasons sole-source is weak, recorded for future reference: **drift with no correction** (explicit tags rot, derived ones self-correct); **no feedback loop** (there is no impressions or per-lane click-through anywhere, so a creator cannot learn whether their tags worked); **taxonomy unfamiliarity at the worst moment** (15 topics / 55 tags presented at creation, when the creator wants to get live — and pre-seeding from `user_tags` biases toward the creator's personal interests rather than the community's purpose).

### ✅ Phase 4 shipped — Conv 432

Five gates green; suite **6289 → 6335** (+46: 21 `entity-tags` unit, 16 community-tag API, 5 `/communities` filter, 4 rails union). Lint **164 → 163** (the new Topic control adds none, and the sibling Sort label's pre-existing a11y warning was fixed with it). `prov:sweep` consistent. Verified live against local D1 and a real browser.

**The cap became TWO caps, and the original one was aimed at the wrong quantity.** `lanes.ts` ranks For You by **distinct topic** overlap — `overlapCount` counts `item.topicIds`, and `compute.ts` builds that with `group_concat(DISTINCT tg.topic_id)`. So five tags inside one topic score overlap = 1 and buy *no rank at all*; the rails exploit is topic **spread**, which a 5-tag cap bounds only loosely. But `smart-feed/scoring.ts` scores at *tag* granularity, so that payoff genuinely is per-tag. Two payoffs at two granularities ⇒ `MAX_ENTITY_TAGS = 5` **and** `MAX_ENTITY_TOPICS = 3`. Re-measuring the same seed through `tags.topic_id` gave the number that actually mattered and was never in the original calibration:

| | tags | distinct topics |
|---|---|---|
| average per course | 2.5 | **1.67** |
| max | 3 | **2** |

**`courses.primary_topic_id` was dead, and its death changes the block's own premise.** The plan said `/courses` was "merely degraded — its topic filter reads the same data, so a user can approximate the lane by hand". It does not read the same data. `CoursesCatalog` filtered on `c.primary_topic_id`, a column whose **only writer in the entire repo is the dev seed** — neither create endpoint sets it, no PATCH accepts it. Every course created through the product was permanently unfilterable by topic; only the 6 seeded ones ever responded. The column is now removed and both catalogs read the `course_tags` roll-up, so they match **any** claimed topic rather than one primary (live: `top-014` now returns 5 courses, two of which — `intro-to-n8n` and `vibe-coding-101` — have different primaries and could never have appeared).

**Truncating the backfill is lossless, which is a consequence of the union.** Materializing the derivation at tag level can exceed the cap even though every contributing course is individually legal — the walk aggregates across courses, and `comm-ai-for-you` derived 6 tags. Backfill therefore truncates (system default) rather than rejecting (user claim). Nothing is lost, because `compute.ts` still UNIONs the derived half at query time: verified on local D1, `ai-for-you` resolves all three topics from a 5-tag materialization that dropped `tag-049`.

**Cap selection is round-robin across topics, not a prefix.** A straight `slice(0, 5)` can spend the whole budget inside one topic and drop the entity's other topics entirely — discarding exactly the signal the cap protects. `capTagsPreservingTopics` takes one tag per topic before a second from any.

**The cold-start hole was closed and proven live.** A community inserted with zero progressions, zero courses, and one explicit tag appeared under its topic filter on `/communities` and was correctly absent from every other topic. Before this it derived 0 topics and was unreachable by any topical surface.

Two live readings looked like defects and were **my own instrument**, retracted after checking: `a[href^="/community/"]` was picking up `DiscoveryRailCard` links from the still-hydrating `lg:hidden` rails mount (the Conv-431 finding, hit again), which masked the filter completely until the query was scoped to `article[data-prov-name="CommunityCatalogCard"]`.

---

## Open decisions

1. ✅ **SETTLED (Conv 431) — localStorage + snapshot.** localStorage covers signed-out visitors uniformly and needs no schema; a D1 table gives cross-device continuity but only for signed-in users. **Server-only would repeat the exact mistake this block fixes** — leaving one population with nothing.
2. ✅ **SETTLED (Conv 431) — after For You.** If Recently Visited leads and the narrow mount shows one lane, mobile *never* shows For You. These two cannot be decided independently.
3. ✅ **SETTLED (Conv 431) — recency respects claim order** (verified live both ways). `lanes.ts:130-138` claims each entity for one lane only, so a recently-visited entity would be claimed by that lane and vanish from For You. Probably right (no repeats), but it means recency cannibalises personalization.
4. ✅ **SETTLED (Conv 431) — yes, re-visiting resurrects.** Remove semantics are lane-scoped (settled); persistence across a fresh visit is not.
5. ✅ **SETTLED (Conv 432) — tags, and it was never actually open.** Checked against *consumers* rather than the definition, all three existing surfaces already store tags and roll up to topics at read time (`user_tags` → `api/me/full.ts`, `course_tags` → `compute.ts COURSE_COLS`, communities → the derived walk). Tag-level storage, topic-level reads, uniformly. `community_tags` is a literal third instance and no judgment call was required. The granularity question had teeth only for the **cap** and the **filter** — both topic-level, both resolved below.
6. ✅ **SETTLED (Conv 431) — no.** Its feed already carries ungated interest-matched suggestion-cards, so a second surface duplicates. User said "each page"; recommendation is to skip Home for Phase 1 and give it recency in Phase 3.

---

## Cross-references

- **Not** `COMM-TAG-FILTER` (`plan/comm-tag-filter/README.md`) — that is **channels** (`general`/`announcements`/`help`) for organising a community's *feed posts*. Conv 238 Decision 1 explicitly rejected reusing the topic taxonomy there, on the grounds those are *"learning-interest tags, not post categories."* This block uses the taxonomy for its stated purpose (interest matching); the two stay cleanly separate and do not collide.
- `[REC-REHOME]` origin + build log → `plan/merge-brian/README.md` § Build log §2 M4 + §3 N8
- `[RECO-UNIFY]` #34 → `plan/home-feed-merge/` (Promoted / Peerloop Picks lanes still gated on `[PROMOTE-PIPELINE]` Steps 4-7)
- Responsive verification → `memory/reference_responsive_iframe_harness` (`[VPHARNESS]` / `[MINWIDTH]`)
- ~~Dismiss persistence is disabled in dev + staging (`ephemeral-dismiss.ts`)~~ — **superseded Conv 431**: the remove control is deliberately NOT built on that module (a list edit, not chrome dismissal), so it persists in dev and staging too. Verified live.
