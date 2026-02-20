# API Reference: Database

D1 database access patterns and helpers. Part of [API Reference](API-REFERENCE.md).

Location: `src/lib/db/index.ts`

---

## Query Functions

### `queryAll<T>(db, sql, params)`

Execute query and return all results.

```typescript
import { queryAll } from '@lib/db';

const users = await queryAll<User>(
  db,
  'SELECT * FROM users WHERE is_creator = ?',
  [1]
);
```

---

### `queryFirst<T>(db, sql, params)`

Execute query and return first result or null.

```typescript
import { queryFirst } from '@lib/db';

const user = await queryFirst<User>(
  db,
  'SELECT * FROM users WHERE email = ?',
  [email]
);
```

---

### `execute(db, sql, params)`

Execute write query (INSERT, UPDATE, DELETE).

```typescript
import { execute } from '@lib/db';

await execute(
  db,
  'UPDATE users SET name = ? WHERE id = ?',
  [newName, userId]
);
```

---

### `batch(db, statements)`

Execute multiple statements atomically.

```typescript
import { batch } from '@lib/db';

await batch(db, [
  { sql: 'INSERT INTO users ...', params: [...] },
  { sql: 'INSERT INTO profiles ...', params: [...] },
]);
```

---

## Utility Functions

| Function | Description |
|----------|-------------|
| `getDB(locals)` | Get D1 database from Astro locals |
| `generateId()` | Generate UUID v4 for primary keys |
| `now()` | Current ISO 8601 timestamp |
| `parseTimestamp(str)` | Parse D1 timestamp to Date |

---

## Pagination Helpers

```typescript
import {
  parsePagination,
  paginationOffset,
  createPaginatedResult
} from '@lib/db';

// Parse from URL params
const { page, limit } = parsePagination(url.searchParams);

// Calculate offset
const offset = paginationOffset(page, limit);

// Query with pagination
const items = await queryAll(db,
  'SELECT * FROM courses LIMIT ? OFFSET ?',
  [limit, offset]
);

// Create paginated response
return createPaginatedResult(items, total, page, limit);
```

**Response format:**
```json
{
  "items": [...],
  "total": 100,
  "page": 1,
  "limit": 20,
  "totalPages": 5,
  "hasMore": true
}
```
