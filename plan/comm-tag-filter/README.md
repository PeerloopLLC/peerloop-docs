# COMM-TAG-FILTER — Real Commons feed tag/channel filtering

**Focus:** Turn the Commons feed's decorative tag chips into a real, data-backed filter
**Status:** 📋 PENDING — design + decisions LOCKED (Conv 238); **build-ready**, deferred to its own conv (pending only a courtesy Matt check)
**Task:** [COMM-TAG-FILTER] (#1)
**Origin:** Conv 237 COMM-DETAIL port flagged the legacy `?tag=` chips as decorative and dropped them; Conv 238 investigation found there is no backing data model at all.

## Why this is a feature, not a wiring task

The legacy `/old/discover/community/[slug]` rendered a "Filter:" chip row for The Commons:

```ts
const commonsTags = isTheCommons ? ['general', 'announcements', 'help'] : undefined;
// chips → href={`/discover/community/${slug}?tag=${t}`}
```

Three problems, all confirmed Conv 238:

1. **The tag vocabulary was hardcoded** — `['general','announcements','help']` is a literal in the page, not from any table.
2. **Posts have no tags.** `feed_activities` (schema:1300) is `id / feed_type / feed_id / actor_id / activity_type / stream_activity_id / created_at` — no tag/channel column. Post bodies live in Stream.io, which carries no tag/topic custom field.
3. **Nothing read `?tag=`.** `TownHallFeed` + `GET /api/feeds/townhall` (limit/offset only) never consumed the param.

So the chips linked to a param nothing read, filtering over tags that didn't exist, drawn from a hardcoded list. Doubly decorative. Making them "real" requires net-new data + posting + query + UI.

## Decision 1 (PIVOTAL) — channels vs the topic taxonomy ✅ LOCKED = Channels (Conv 238)

What do the chips represent? This drives the whole data model.

| Option | What it is | Fit |
|---|---|---|
| **A · Channels** ✅ **CHOSEN** | A small per-community set of posting categories (default Commons: `general`, `announcements`, `help`). Each post picks one. Rendered as `#general` chips. | Matches the placeholder intent; small chip row; correct mental model for a "town hall." |
| B · Topic taxonomy | Reuse the existing `tags` table (55 skill tags / 15 topics, used for onboarding + course tagging + matching). | Poor fit — those are *learning-interest* tags, not post categories; 55 chips is unusable; conflates matching with feed organization. |

**LOCKED: Channels (Conv 238, user).** The taxonomy exists for a different purpose; overloading it couples feed UX to the matching system. Channels are the honest model for "filter this community's conversation." *(Still worth a courtesy check with Matt on the product framing — see open questions.)*

## Decision 2 — channel vocabulary storage ✅ LOCKED = `community_channels` table (Conv 238)

| Option | Cost | Durability |
|---|---|---|
| B1 · Fixed list for the Commons only | Trivial — a column + the Commons' 3 channels seeded | MVP; other communities can't have channels |
| **B2 · `community_channels` table** ✅ **CHOSEN** | One small table (community_id, slug, label, display_order) seeded for the Commons | Generalizes to any community; creator-configurable later |

**LOCKED: B2 — `community_channels` table (Conv 238, user).** Barely more work than hardcoding and avoids a second migration when channels go per-community.

## Build phases (deferred — own conv)

### TAG-SCHEMA — data model
- [ ] Add `channel TEXT` (nullable) to `feed_activities` (+ index on `(feed_type, feed_id, channel, created_at)`)
- [ ] New `community_channels` table (B2); seed the Commons with `general` / `announcements` / `help`
- [ ] Mirror the channel onto the Stream activity custom data (so Stream-sourced reads carry it)
- [ ] Backfill: existing Commons posts → `general` (default channel)

### TAG-COMPOSER — posting
- [ ] `TownHallFeed` composer: add a channel selector (Matt `Select` or chip toggle) when posting to a channelled community; default `general`
- [ ] `POST /api/feeds/townhall`: accept + validate `channel` against `community_channels`; write to `feed_activities.channel` + Stream custom data

### TAG-QUERY — filtering
- [ ] `GET /api/feeds/townhall`: accept `?channel=` (or `?tag=`), filter the query; `all`/absent = no filter
- [ ] `TownHallFeed`: read the active channel, refetch on change, reflect in URL (`?tag=`)

### TAG-UI — chips (Matt)
- [ ] Render the channel chips **in the Feed tab body** (NOT the SubNav — per COMM-DETAIL: SubNav = destinations only, filters = tab body)
- [ ] Matt-token chip styling (reuse an existing chip primitive if one fits — scan first per the primitive-candidates rule); `All` + one chip per channel; active state from URL
- [ ] Drive chips from `community_channels` (B2), not a hardcoded list

### TAG-VERIFY
- [ ] Tests: API channel filter, composer write, backfill correctness
- [ ] Browser-verify on `/community/the-commons/feed`: post to a channel, filter by it, `All` resets
- [ ] 5 gates + prov:sweep

## Open questions for the user / Matt
- ✅ ~~Decision 1 + 2~~ — LOCKED Conv 238 (channels + `community_channels` table). Build-ready.
- Courtesy check with Matt: is the channel-filter framing OK, and does he have a Figma frame for the Commons channel chips, or is this `@matt-inspired` (build with tokens, no source frame)?
- Should non-Commons communities get channels at launch, or Commons-only first? (B2 supports either; default plan = seed Commons only, others empty = no chip row.)

## Cross-references
- Tracked in `PLAN.md` under the ROUTE-MIGRATION row (COMM-DETAIL follow-ups).
- Sibling COMM-DETAIL follow-ups: [CT-RESTYLE] #3, [COMM-LEAVE] #4, [MOD-TOGGLE] #5.
- The "filters → tab body, not SubNav" rule is from the COMM-DETAIL routing decision (`docs/decisions/11-new-routing.md`).
