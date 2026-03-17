# RFC Index

**Last Updated:** 2026-03-17

## Rationale

The system was designed from 34 client documents (CD-001 through CD-034). The site was then generated from those original specifications.

New client documents (CD-035+) have impacts on what was already written and must be carefully considered in light of the current implementation state. Therefore, they are documented as RFCs (Requests for Change) rather than applied immediately.

**Workflow:** Once the site is completely generated from the original 34 documents, all RFCs will be reviewed together and changes made in a coordinated manner.

---

## Lookup Table

| ID | Title | Status | Items | Done | Priority |
|----|-------|--------|-------|------|----------|
| [CD-035](./CD-035/) | UX & Pricing Changes | Open | 30 | 0 | High |
| [CD-036](./CD-036/) | Communities, Progressions & Feeds | In Progress | 32 | 19 | High |
| [CD-037](./CD-037/) | Instant Session Booking ("Book Now") | Closed | 30 | 30 | High |

## Status Key

| Status | Meaning |
|--------|---------|
| Open | Not started |
| In Progress | Work underway |
| Blocked | Waiting on questions/dependencies |
| Closed | All items complete |

## Structure

Each RFC folder contains:
- `original.txt` - Raw client input (or `original.[ext]` if file)
- `CD-XXX.md` - Formatted source document (includes Comments section for dated feedback)
- `RFC.md` - Actionable checklist

## Quick Commands

- `/w-add-client-note` - Create new RFC from client input
- Check `RFC/CD-XXX/RFC.md` for pending items
