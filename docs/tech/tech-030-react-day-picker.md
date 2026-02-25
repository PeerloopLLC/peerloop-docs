# tech-030: react-day-picker

**Package:** `react-day-picker` v9.13.2
**Added:** Session 288 (S-T-CALENDAR block)
**License:** MIT
**Bundle:** ~22 kB

## Why Chosen

Selected for the availability calendar month-view. Decision documented in Session 287 (CURRENT-BLOCK-PLAN.md).

**Evaluated alternatives:**
| Package | Why Rejected |
|---------|-------------|
| FullCalendar | No non-contiguous multi-select, opinionated CSS, large bundle |
| react-calendar | Can't replace cell structure for custom rendering |
| react-big-calendar | Massive bundle, event-level calendar (wrong tool) |
| @schedule-x | Event-level only, no day-level multi-select |

**Key capabilities used:**
- Full `Day` component replacement via `components` prop
- `mode="multiple"` for non-contiguous multi-select
- Headless/unstyled (Tailwind-native)
- `CalendarDay.isoDate` for stable date keys

## Current Usage

**Note:** The initial implementation (Session 288) uses a **custom calendar grid** rather than DayPicker's built-in grid. This was simpler for the specific availability cell rendering needs. The package is installed for potential future use of its DayPicker component (e.g., in the student booking flow).

**Files:**
- `src/components/student-teachers/workspace/AvailabilityCalendar.tsx` — Custom grid (does not import DayPicker)
- `src/components/student-teachers/workspace/availability-utils.ts` — Calendar merge logic (framework-agnostic)

## API Reference

```typescript
import { DayPicker } from 'react-day-picker';
import type { DayProps, DayButtonProps, CalendarDay } from 'react-day-picker';

// Custom Day component override
<DayPicker
  mode="multiple"
  selected={selectedDates}
  onSelect={setSelectedDates}
  components={{ Day: CustomDay }}
/>

// CalendarDay properties
day.date      // Date object
day.isoDate   // "YYYY-MM-DD" string
day.outside   // boolean — not in displayed month
```

## Caveats

- v9 docs use redirect-heavy navigation; check `/docs/appearance`, `/guides/custom-components`, `/selections/selection-modes`
- `CustomComponents` type requires `typeof components.Day` (not a generic interface)
- The `useDayPicker()` hook provides `components` and `classNames` for composing around defaults

## References

- [Official docs](https://daypicker.dev)
- [Custom components guide](https://daypicker.dev/guides/custom-components)
- [GitHub](https://github.com/gpbl/react-day-picker)
