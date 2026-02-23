# Session Decisions - 2026-02-22

## 1. Recommendation Scoring: 80/20 Category-to-Tag Weighting
**Type:** Implementation
**Topics:** d1, astro

**Trigger:** Designing the personalized course recommendation algorithm — need to balance two signals from onboarding data.

**Options Considered:**
1. Equal weight (50/50 category + tag) — risk: tag noise dominates
2. Category-only (100% category match) — risk: misses nuance
3. 80/20 split with tag cap ← Chosen
4. Machine learning model — overkill for MVP

**Decision:** Category match = 80 points, tag overlap = MIN(match_count, 5) * 4 points (max 20). A course in the user's interested category always outranks one matched by tags alone.

**Rationale:** Category selection during onboarding is an explicit intent signal — the user consciously chose "Programming." Tags are synced from topic names and are a weaker, more granular signal. The cap at 5 tags prevents courses with many tags from gaming the score.

**Consequences:** Scoring is a single SQL CTE query with no application-level computation. Backfill with popular courses when personalized results < limit ensures the band always has content.

---

## 2. Community Recommendations via Transitive Progression Chain
**Type:** Implementation
**Topics:** d1

**Trigger:** Communities don't have a direct `category_id` — need to connect user interests to community recommendations.

**Options Considered:**
1. Add `category_id` to communities table — requires schema change, doesn't model reality
2. Transitive chain: interests → categories → courses → progressions → communities ← Chosen
3. Tag-based matching on community name/description — too fuzzy

**Decision:** Match communities transitively through the existing data model: `user_topic_interests` → `topics.category_id` → `courses.category_id` → `courses.progression_id` → `progressions.community_id` → `communities`.

**Rationale:** The existing schema already models the relationship — courses belong to categories AND progressions, and progressions belong to communities. Using this chain means zero schema changes and the recommendations naturally align with the platform's content structure.

**Consequences:** 4-level JOIN chain in SQL, but all via indexed foreign keys. Falls back to popular communities when no transitive matches exist.

---

## 3. localStorage for Recommendation Dismiss State
**Type:** Implementation
**Topics:** astro

**Trigger:** Users need to dismiss the recommendation band, and it should stay dismissed across page navigations.

**Options Considered:**
1. Server-side user preference (API + DB column) — heavyweight for a cosmetic preference
2. localStorage with namespaced keys ← Chosen
3. Session storage — resets on tab close, too ephemeral

**Decision:** Use `localStorage.getItem('peerloop:recs:courses:dismissed')` to persist dismiss state. Check before fetching — if dismissed, render nothing and skip the API call entirely.

**Rationale:** Recommendation bands are non-critical UI chrome. Server-side storage adds schema and API complexity for something that's fine to reset if the user clears browser data (seeing recommendations again is a feature, not a bug). The `peerloop:recs:*` namespace keeps all recommendation keys discoverable.

**Consequences:** Dismiss state is per-browser, not per-account. A user who clears localStorage or uses a different browser will see recommendations again.
