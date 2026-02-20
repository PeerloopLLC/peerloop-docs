---
description: Export database table schema (and optionally data) to TSV
argument-hint: "TABLE=table_name DATA=true"
---

# Schema Dump

Export a database table's schema and optionally seed data to a TSV file.

---

## Arguments

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `TABLE` | Yes | - | Table name (e.g., `users`, `courses`) |
| `DATA` | No | `false` | Include seed data records (`true`/`false`) |

**Usage:**
- `/L-schema-dump TABLE=users` - Schema only
- `/L-schema-dump TABLE=users DATA=true` - Schema + up to 6 data records
- `/L-schema-dump TABLE=courses DATA=true` - Schema + course data

---

## Output

**Location:** `../Peerloop/data/schema/YYYY-MM-DD/{table_name}_schema.tsv`

**Format:** TSV with schema metadata as columns, data records as additional columns

### Schema Columns (always included)

| Column | Description |
|--------|-------------|
| `column_name` | Field name |
| `data_type` | TEXT, INTEGER, REAL |
| `nullable` | YES/NO |
| `default_value` | Default if any |
| `primary_key` | YES/NO |
| `unique` | YES/NO |
| `check_constraint` | Allowed values if CHECK exists |
| `foreign_key` | Referenced table.column if FK |
| `notes` | Additional context |

### Data Columns (if DATA=true)

- One column per record, using the record's primary key as header
- Maximum 6 records to keep file readable
- Empty cells for NULL values

---

## Execution Flow

### Step 1: Parse Arguments

Extract `TABLE` and `DATA` from arguments.

**Validation:**
- `TABLE` is required - exit with error if missing
- `DATA` defaults to `false` if not provided

### Step 2: Read Schema

Read `../Peerloop/migrations/0001_schema.sql` and extract the CREATE TABLE statement for the specified table.

**Extract for each column:**
- Column name
- Data type (TEXT, INTEGER, REAL)
- NOT NULL constraint → nullable = NO
- DEFAULT value
- PRIMARY KEY
- UNIQUE constraint
- CHECK constraint (parse allowed values)
- REFERENCES clause (foreign key)

### Step 3: Read Seed Data (if DATA=true)

Read `../Peerloop/migrations/0002_seed.sql` and extract INSERT statements for the table.

**Limit to 6 records** to keep the TSV readable.

**Parse each record's values** matching column order from the INSERT statement.

### Step 4: Create Output Directory

```bash
mkdir -p ../Peerloop/data/schema/$(date '+%Y-%m-%d')
```

### Step 5: Generate TSV

**Header row:** Schema column names + record IDs (if DATA=true)

**Data rows:** One per schema column, with:
- Schema metadata in first 9 columns
- Record values in subsequent columns (if DATA=true)

### Step 6: Write File

Write to `../Peerloop/data/schema/YYYY-MM-DD/{table_name}_schema.tsv`

### Step 7: Confirm

Display:
```
Created: ../Peerloop/data/schema/YYYY-MM-DD/{table_name}_schema.tsv
  Schema columns: {count}
  Data records: {count or "none"}
```

---

## Example Output

**Command:** `/L-schema-dump TABLE=users DATA=true`

**File:** `../Peerloop/data/schema/2026-01-31/users_schema.tsv`

```
column_name	data_type	nullable	...	usr-guy	usr-sarah	usr-brian
id	TEXT	NO	...	usr-guy	usr-sarah	usr-brian
email	TEXT	NO	...	guy@x.com	sarah@x.com	brian@x.com
name	TEXT	NO	...	Guy	Sarah	Brian
...
```

---

## Error Handling

| Error | Message |
|-------|---------|
| Missing TABLE argument | `Error: TABLE argument required. Usage: /L-schema-dump TABLE=users` |
| Table not found in schema | `Error: Table '{name}' not found in ../Peerloop/migrations/0001_schema.sql` |
| No seed data (when DATA=true) | `Warning: No seed data found for '{name}' in ../Peerloop/migrations/0002_seed.sql` (creates schema-only file) |

---

## Notes

- Schema is extracted from SQL files (source of truth), not from D1 database
- Works on any development machine (no remote D1 dependency)
- Dated folders allow keeping snapshots as schema evolves
- Maximum 6 records keeps TSV readable in spreadsheet applications
