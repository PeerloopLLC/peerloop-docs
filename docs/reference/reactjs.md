# tech-004: React.js

**Type:** UI Library
**Status:** CONFIRMED
**Research Date:** 2025-11-30
**Source:** https://react.dev/

---

## Overview

React is a JavaScript library for building user interfaces. It's the confirmed UI library for Alpha Peer, to be used within the Astro.js framework.

## Role in Alpha Peer

React will be used for **interactive islands** within Astro pages, not as a full single-page application framework.

### React Components Needed

| Component Type | React Features Used | Priority |
|---------------|---------------------|----------|
| Chat Interface | Stream SDK, useState, useEffect | P0 |
| Calendar/Booking | Date handling, forms | P0 |
| Dashboard Widgets | Data fetching, charts | P0 |
| Video Session Launcher | BBB integration | P0 |
| Course Progress | State management | P0 |
| Profile Editor | Forms, file upload | P0 |
| Search/Filters | Controlled inputs | P0 |
| Activity Feed | Stream SDK, infinite scroll | P1 |
| Notifications | Real-time updates | P1 |

## Key React Patterns for Alpha Peer

### State Management Strategy

Given Astro's islands architecture, choose lightweight state management:

| Option | Use Case | Recommendation |
|--------|----------|----------------|
| useState/useReducer | Component-local state | Primary approach |
| React Context | Shared within island | For island-scoped global state |
| Zustand | Cross-island state | If needed for complex state |
| TanStack Query | Server state | For API data fetching |

**Avoid:** Redux (overkill for islands architecture)

### Data Fetching

```jsx
// TanStack Query for API calls
import { useQuery } from '@tanstack/react-query';

function CourseProgress({ courseId }) {
  const { data, isLoading } = useQuery({
    queryKey: ['progress', courseId],
    queryFn: () => fetchProgress(courseId),
  });

  if (isLoading) return <Skeleton />;
  return <ProgressBar value={data.percentComplete} />;
}
```

### Forms

```jsx
// React Hook Form for complex forms
import { useForm } from 'react-hook-form';

function ProfileEditor() {
  const { register, handleSubmit, formState } = useForm();

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('name', { required: true })} />
      <input {...register('bio')} />
      <button type="submit">Save</button>
    </form>
  );
}
```

## Third-Party React Libraries

### Required (for client-specified services)
| Library | Purpose | Stories |
|---------|---------|---------|
| `stream-chat-react` | Stream Chat UI | US-S016, US-S019, US-C017 |

### Recommended
| Library | Purpose | Stories |
|---------|---------|---------|
| `@tanstack/react-query` | Data fetching | All data-driven UIs |
| `react-hook-form` | Form handling | US-S008, US-C008, US-T003 |
| `date-fns` | Date utilities | US-C006, US-T001 |
| `react-big-calendar` | Calendar views | US-S010, US-C006 |
| `recharts` or `chart.js` | Dashboard charts | US-A019-A025, US-T013 |

### Optional
| Library | Purpose | Consider When |
|---------|---------|---------------|
| `framer-motion` | Animations | Polish phase |
| `react-select` | Advanced dropdowns | Complex filters |
| `react-dropzone` | File uploads | Profile media |

## Astro-React Component Structure

```
/src
  /components
    /react              # React interactive islands
      /chat
        ChatWindow.tsx
        MessageList.tsx
      /calendar
        BookingCalendar.tsx
        TimeSlotPicker.tsx
      /dashboard
        EarningsChart.tsx
        ProgressWidget.tsx
      /forms
        ProfileEditor.tsx
        CourseEditor.tsx
    /astro              # Static Astro components
      Header.astro
      Footer.astro
      CourseCard.astro
```

## TypeScript Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "jsx": "react-jsx",
    "jsxImportSource": "react",
    "strict": true,
    "moduleResolution": "bundler"
  }
}
```

## Performance Considerations

### Bundle Size
With Astro islands, React is only loaded where needed:

```astro
---
// Page loads zero React JS by default
import CourseCard from '../components/astro/CourseCard.astro';
import ChatWidget from '../components/react/ChatWidget';
---

<!-- Static, no JS -->
<CourseCard course={course} />

<!-- Only this island loads React -->
<ChatWidget client:visible userId={userId} />
```

### Hydration Strategies
| Directive | When to Use |
|-----------|-------------|
| `client:load` | Above-fold interactive (chat, nav search) |
| `client:visible` | Below-fold or secondary (calendar, charts) |
| `client:idle` | Non-critical (analytics widgets) |

## User Story Coverage

React itself doesn't directly address user stories but enables them:

| Story Category | React's Role |
|---------------|--------------|
| Messaging (US-S016, etc.) | Stream Chat React components |
| Scheduling (US-C006, US-T001) | Calendar components |
| Profiles (US-S008, US-C008) | Form components |
| Dashboard (US-S009, US-T013) | Data visualization |
| Search (US-S003, US-S004) | Interactive search UI |

## Caveats

### React 19 SSR on Cloudflare Workers

**Issue:** React 19's server-side rendering uses `react-dom/server.browser` which requires the `MessageChannel` API. Cloudflare Workers don't have this API, even with `nodejs_compat_v2`.

**Error:**
```
ReferenceError: MessageChannel is not defined
  at requireReactDomServer_browser_production
```

**Solution:** Configure Vite to use `react-dom/server.edge` instead (designed for edge environments):

```javascript
// astro.config.mjs
export default defineConfig({
  vite: {
    resolve: {
      // Use react-dom/server.edge instead of react-dom/server.browser for React 19.
      // Without this, MessageChannel from node:worker_threads needs to be polyfilled.
      alias: import.meta.env.PROD && {
        'react-dom/server': 'react-dom/server.edge',
      },
    },
  },
});
```

**Why `.edge` works:**
- Designed for edge environments (Cloudflare Workers, Deno, Vercel Edge)
- Uses Web Streams API instead of Node.js-specific APIs
- Doesn't require `MessageChannel`, `worker_threads`, or other Node.js APIs

**Related Issues:**
- [Astro #12824](https://github.com/withastro/astro/issues/12824) - React 19 + Cloudflare Adapter
- [React #31827](https://github.com/facebook/react/issues/31827) - MessageChannel not defined

**Note:** This is a known issue that may be fixed in future React/Astro versions. Check the linked issues for updates.

## Recommendations

1. **Use React only for interactive islands** - Leverage Astro's static-first approach
2. **Keep islands small and focused** - One responsibility per component
3. **Standardize on TanStack Query** - Consistent data fetching pattern
4. **Use TypeScript throughout** - Type safety for complex state
5. **Prefer `client:visible`** - Defer hydration when possible
6. **Use server.edge for SSR on Cloudflare** - Required for React 19

## Integration with Other Technologies

| Technology | Integration Point |
|------------|-------------------|
| **Stream** | `stream-chat-react` components |
| **BigBlueButton** | Join URL generation (server), embed handling |
| **Tailwind** | className styling on React components |
| **Astro** | Islands architecture, SSR data passing |

---

## References

- [React Documentation](https://react.dev/)
- [TanStack Query](https://tanstack.com/query)
- [React Hook Form](https://react-hook-form.com/)
- [Astro React Integration](https://docs.astro.build/en/guides/integrations-guide/react/)
