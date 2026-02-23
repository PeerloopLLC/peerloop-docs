# API: Recommendations

Personalized course and community recommendations based on onboarding interests.

**Last Updated:** 2026-02-22 (Session 259)

---

## Endpoints

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/api/recommendations/courses` | GET | Optional | Personalized course recommendations |
| `/api/recommendations/communities` | GET | Optional | Personalized community recommendations |

---

## GET /api/recommendations/courses

Returns personalized course recommendations based on onboarding topic interests, with fallback to popular courses.

### Algorithm

1. **Category match (80 pts):** `user_topic_interests` → `topics.category_id` → `courses.category_id`
2. **Tag bonus (max 20 pts):** `user_interests.tag` ↔ `course_tags.tag` — `MIN(overlap, 5) * 4`
3. **Exclusions:** enrolled courses, inactive courses, deleted courses
4. **Ordering:** score DESC, student_count DESC, rating DESC
5. **Backfill:** popular courses if personalized results < limit

### Query Parameters

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `limit` | integer | 10 | 20 | Number of results |

### Auth Behavior

| State | Result |
|-------|--------|
| Authenticated with interests | Personalized results (source: `personalized`) |
| Authenticated, no interests | Popular courses (source: `popular`) |
| Anonymous | Popular courses (source: `popular`) |

### Response

```json
{
  "items": [
    {
      "id": "crs-...",
      "slug": "javascript-101",
      "title": "JavaScript 101",
      "tagline": "Learn JS fundamentals",
      "thumbnailUrl": "https://...",
      "priceCents": 4999,
      "currency": "USD",
      "rating": 4.5,
      "ratingCount": 10,
      "studentCount": 100,
      "badge": "popular",
      "level": "beginner",
      "sessionCount": 8,
      "totalDuration": "16 hours",
      "categoryId": "cat-...",
      "creator": {
        "name": "Jane Doe",
        "avatarUrl": "https://...",
        "handle": "janedoe"
      }
    }
  ],
  "source": "personalized",
  "total": 5
}
```

### Errors

| Status | Condition |
|--------|-----------|
| 503 | Database unavailable |
| 500 | Internal error |

---

## GET /api/recommendations/communities

Returns personalized community recommendations via transitive matching chain, with fallback to popular communities.

### Algorithm

**Matching chain:** `user_topic_interests` → `topics.category_id` → `courses.category_id` → `courses.progression_id` → `progressions.community_id` → `communities`

**Exclusions:** already-joined (via `community_members`), system communities, archived communities

**Fallback:** popular public communities ordered by member_count DESC

### Query Parameters

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `limit` | integer | 10 | 20 | Number of results |

### Auth Behavior

Same as courses endpoint above.

### Response

```json
{
  "items": [
    {
      "id": "com-...",
      "slug": "js-developers",
      "name": "JS Developers",
      "description": "JavaScript community",
      "icon": null,
      "memberCount": 150,
      "postCount": 42,
      "creator": {
        "id": "usr-...",
        "name": "Jane Doe",
        "handle": "janedoe"
      }
    }
  ],
  "source": "personalized",
  "total": 3
}
```

### Errors

| Status | Condition |
|--------|-----------|
| 503 | Database unavailable |
| 500 | Internal error |

---

## Related

- [API-PLATFORM.md](API-PLATFORM.md) — Topics endpoint (onboarding data source)
- [API-ENROLLMENTS.md](API-ENROLLMENTS.md) — Onboarding profile endpoint
- [API-COMMUNITY.md](API-COMMUNITY.md) — Community listing endpoint
