# tech-009-react-big-calendar.md

**Library:** react-big-calendar
**Type:** Calendar UI Component
**Website:** https://jquense.github.io/react-big-calendar/
**Repository:** https://github.com/jquense/react-big-calendar
**Source:** Technology decision session (2025-12-26)
**Status:** SELECTED (2025-12-26)

---

## Overview

react-big-calendar is a comprehensive calendar UI component for React applications. It provides a Google Calendar-like interface for displaying and managing events, supporting multiple views (month, week, day, agenda).

**Key Value Proposition:**
- Full-featured calendar display (not just date picker)
- Multiple views (month, week, day, agenda)
- Flexible event rendering
- Drag-and-drop support
- Localization support
- MIT licensed (free)

---

## Why react-big-calendar for PeerLoop

### Decision Context

Evaluated against: **Cal.com** and **custom build**

| Criterion | react-big-calendar | Cal.com | Custom |
|-----------|-------------------|---------|--------|
| Type | UI component | Full platform | From scratch |
| Booking logic | Build yourself | Included | Build yourself |
| External dependency | None (npm) | Service/self-host | None |
| Customization | Full control | Limited | Full control |
| Dev time | Medium | Low | High |
| Cost | Free | Free/Paid | Free |

### Why react-big-calendar Won

1. **Right Level of Abstraction** - UI component, not full platform
2. **No External Dependency** - Unlike Cal.com, no service to integrate
3. **Full Control** - Style and behavior exactly as needed
4. **Works with D1** - Store availability/bookings in our database
5. **16h Budget Fits** - Block 4 budgets 16h for booking features

### What We're Building

| Component | Tool |
|-----------|------|
| Calendar display | react-big-calendar |
| Availability storage | Cloudflare D1 |
| Booking logic | Custom (API routes) |
| Time slots | Custom calculation |

Cal.com would be overkill - we'd need to sync users, handle webhooks, and manage an external dependency for functionality we can build in the budgeted time.

---

## Features

### Views
- **Month** - Overview of all bookings
- **Week** - Detailed weekly schedule
- **Day** - Single day focus
- **Agenda** - List view of upcoming events

### Interactions
- Click to select time slot
- Drag to resize events
- Drag to move events
- Custom event rendering

### Customization
- Custom toolbar
- Custom date/time cells
- Custom event components
- Theming via CSS

---

## Integration for PeerLoop

### Installation

```bash
npm install react-big-calendar date-fns
```

### Basic Setup

```typescript
// src/components/AvailabilityCalendar.tsx
import { Calendar, dateFnsLocalizer } from 'react-big-calendar';
import { format, parse, startOfWeek, getDay } from 'date-fns';
import 'react-big-calendar/lib/css/react-big-calendar.css';

const locales = { 'en-US': require('date-fns/locale/en-US') };

const localizer = dateFnsLocalizer({
  format,
  parse,
  startOfWeek,
  getDay,
  locales,
});

interface AvailabilitySlot {
  id: string;
  title: string;
  start: Date;
  end: Date;
  teacherId: string;
}

export function AvailabilityCalendar({
  slots,
  onSelectSlot
}: {
  slots: AvailabilitySlot[];
  onSelectSlot: (slot: AvailabilitySlot) => void;
}) {
  return (
    <Calendar
      localizer={localizer}
      events={slots}
      startAccessor="start"
      endAccessor="end"
      onSelectEvent={onSelectSlot}
      views={['week', 'day']}
      defaultView="week"
      min={new Date(0, 0, 0, 8, 0)}  // 8 AM
      max={new Date(0, 0, 0, 20, 0)} // 8 PM
      step={30}
      timeslots={2}
    />
  );
}
```

### Teacher Availability Editor

```typescript
// For Teachers to set their availability
export function AvailabilityEditor({
  teacherId,
  availability,
  onSave
}: {
  teacherId: string;
  availability: AvailabilitySlot[];
  onSave: (slots: AvailabilitySlot[]) => void;
}) {
  const [slots, setSlots] = useState(availability);

  const handleSelectSlot = ({ start, end }: { start: Date; end: Date }) => {
    const newSlot: AvailabilitySlot = {
      id: crypto.randomUUID(),
      title: 'Available',
      start,
      end,
      teacherId,
    };
    setSlots([...slots, newSlot]);
  };

  return (
    <Calendar
      localizer={localizer}
      events={slots}
      selectable
      onSelectSlot={handleSelectSlot}
      onSelectEvent={(slot) => {
        // Remove slot on click
        setSlots(slots.filter(s => s.id !== slot.id));
      }}
      views={['week']}
      defaultView="week"
    />
  );
}
```

### Student Booking View

```typescript
// For Students to book sessions
export function BookingCalendar({
  teacherId,
  availableSlots,
  bookedSlots,
  onBook,
}: {
  teacherId: string;
  availableSlots: AvailabilitySlot[];
  bookedSlots: AvailabilitySlot[];
  onBook: (slot: AvailabilitySlot) => void;
}) {
  const allEvents = [
    ...availableSlots.map(s => ({ ...s, type: 'available' })),
    ...bookedSlots.map(s => ({ ...s, type: 'booked' })),
  ];

  return (
    <Calendar
      localizer={localizer}
      events={allEvents}
      onSelectEvent={(event) => {
        if (event.type === 'available') {
          onBook(event);
        }
      }}
      eventPropGetter={(event) => ({
        className: event.type === 'available' ? 'slot-available' : 'slot-booked',
        style: {
          backgroundColor: event.type === 'available' ? '#10b981' : '#9ca3af',
          cursor: event.type === 'available' ? 'pointer' : 'not-allowed',
        },
      })}
    />
  );
}
```

---

## Database Schema (D1)

### Availability Table

```sql
CREATE TABLE availability (
  id TEXT PRIMARY KEY,
  teacher_id TEXT NOT NULL REFERENCES users(id),
  day_of_week INTEGER NOT NULL,  -- 0=Sunday, 6=Saturday
  start_time TEXT NOT NULL,       -- "09:00"
  end_time TEXT NOT NULL,         -- "17:00"
  timezone TEXT NOT NULL DEFAULT 'America/New_York',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE(teacher_id, day_of_week, start_time)
);
```

### Sessions Table (Bookings)

```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  teacher_id TEXT NOT NULL REFERENCES users(id),
  student_id TEXT NOT NULL REFERENCES users(id),
  course_id TEXT NOT NULL REFERENCES courses(id),
  scheduled_start TEXT NOT NULL,
  scheduled_end TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'scheduled',  -- scheduled, completed, cancelled
  plugnmeet_room_id TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

---

## API Endpoints

### Get Teacher Availability

```typescript
// GET /api/teachers/:id/availability
export async function GET({ params, env }) {
  const { id } = params;

  const availability = await env.DB.prepare(`
    SELECT * FROM availability WHERE teacher_id = ?
  `).bind(id).all();

  return Response.json(availability.results);
}
```

### Get Available Slots

```typescript
// GET /api/teachers/:id/slots?date=2025-01-15
export async function GET({ params, request, env }) {
  const { id } = params;
  const url = new URL(request.url);
  const date = url.searchParams.get('date');

  // Get Teacher's availability pattern
  const availability = await getAvailability(env.DB, id);

  // Get existing bookings
  const bookings = await getBookings(env.DB, id, date);

  // Calculate available slots
  const slots = calculateAvailableSlots(availability, bookings, date);

  return Response.json(slots);
}
```

### Book Session

```typescript
// POST /api/sessions
export async function POST({ request, env }) {
  const { teacherId, studentId, courseId, start, end } = await request.json();

  // Validate slot is still available
  const isAvailable = await checkSlotAvailable(env.DB, teacherId, start, end);
  if (!isAvailable) {
    return Response.json({ error: 'Slot no longer available' }, { status: 409 });
  }

  // Create session
  const sessionId = crypto.randomUUID();
  await env.DB.prepare(`
    INSERT INTO sessions (id, teacher_id, student_id, course_id, scheduled_start, scheduled_end)
    VALUES (?, ?, ?, ?, ?, ?)
  `).bind(sessionId, teacherId, studentId, courseId, start, end).run();

  // TODO: Send confirmation emails

  return Response.json({ sessionId });
}
```

---

## Styling

### Tailwind Integration

```css
/* src/styles/calendar.css */
.rbc-calendar {
  @apply font-sans;
}

.rbc-toolbar {
  @apply mb-4 flex gap-2;
}

.rbc-toolbar button {
  @apply px-3 py-1 rounded border border-gray-300 hover:bg-gray-100;
}

.rbc-toolbar button.rbc-active {
  @apply bg-blue-500 text-white border-blue-500;
}

.slot-available {
  @apply bg-green-500 text-white cursor-pointer hover:bg-green-600;
}

.slot-booked {
  @apply bg-gray-400 text-white cursor-not-allowed;
}
```

---

## Timezone Handling

```typescript
import { formatInTimeZone, zonedTimeToUtc } from 'date-fns-tz';

// Store in UTC, display in user's timezone
export function displaySlot(slot: AvailabilitySlot, userTimezone: string) {
  return {
    ...slot,
    start: formatInTimeZone(slot.start, userTimezone, 'yyyy-MM-dd HH:mm'),
    end: formatInTimeZone(slot.end, userTimezone, 'yyyy-MM-dd HH:mm'),
  };
}

// Convert user input to UTC for storage
export function toUTC(dateTime: string, userTimezone: string): Date {
  return zonedTimeToUtc(dateTime, userTimezone);
}
```

---

## Comparison: react-big-calendar vs Cal.com

| Aspect | react-big-calendar | Cal.com |
|--------|-------------------|---------|
| What you get | Calendar UI component | Full booking platform |
| Booking logic | Build yourself | Included |
| User management | Use your own | Separate system |
| Payments | Integrate Stripe yourself | Built-in |
| Reminders | Build yourself | Built-in |
| Customization | Complete | Limited |
| Dependency | npm package | External service |
| Data location | Your D1 | Their servers (or self-host) |

**Decision:** react-big-calendar gives us the calendar UI; we build the booking logic ourselves using our existing D1 and auth systems.

---

## User Stories Covered

| Story ID | Story | How Implemented |
|----------|-------|-----------------|
| US-S083 | View Teacher availability | Calendar display with available slots |
| US-S084 | Book session with Teacher | Click slot → booking API |
| US-S085 | Schedule Later option | "Schedule Later" button in UI |
| US-T004 | Teacher sets availability | Availability editor calendar |
| US-T005 | Teacher views schedule | Week view of booked sessions |

---

## References

### Official Documentation
- [react-big-calendar Docs](https://jquense.github.io/react-big-calendar/)
- [GitHub Repository](https://github.com/jquense/react-big-calendar)
- [Storybook Examples](https://jquense.github.io/react-big-calendar/storybook/)

### Tutorials
- [React Calendar Components](https://www.builder.io/blog/best-react-calendar-component-ai)

### Related Libraries
- [date-fns](https://date-fns.org/) - Date manipulation
- [date-fns-tz](https://github.com/marnusw/date-fns-tz) - Timezone support
