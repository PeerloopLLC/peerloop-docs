---
description: Project-specific timecard settings (extends /q-timecard)
argument-hint: ""
---

# Peerloop Timecard Settings

**Extends:** `/q-timecard` (that skill reads this for project-specific config)

---

## Default Values

| Field | Value | Notes |
|-------|-------|-------|
| `Bill?` | `Block-06` | Current implementation block |
| `defaultRepo` | `code` | Used when `repo=` is omitted from `/q-timecard` |

Update the `Bill?` default as the project progresses through blocks.

---

## Machine Tracking

Machine name is read from `~/.claude/.machine-name` (created by global `detect-machine.sh` hook).

Machines:
- `MacMiniM4-Pro` - Mac Mini M4 Pro, 64GB (full functionality)
- `MacMiniM4` - Mac Mini M4, 24GB (full functionality)
