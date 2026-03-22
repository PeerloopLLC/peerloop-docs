# tech-005: Tailwind CSS

**Type:** CSS Framework
**Status:** CONFIRMED
**Version:** v4.1.18
**Research Date:** 2025-11-30
**Updated:** 2025-12-27 (v4 upgrade)
**Source:** https://tailwindcss.com/

---

## Overview

Tailwind CSS is a utility-first CSS framework providing low-level classes that compose directly in markup. It enables rapid UI development without writing custom CSS.

**Peerloop uses Tailwind v4** with the `@tailwindcss/vite` plugin for Astro integration.

## Core Philosophy

| Principle | Description |
|-----------|-------------|
| **Utility-First** | Small, single-purpose classes |
| **Composable** | Combine classes for any design |
| **No Opinions** | Build any design, not templates |
| **Purged Output** | Unused styles removed in production |

## What's New in v4

Tailwind v4 is a major rewrite with significant changes:

| Feature | v3 | v4 |
|---------|----|----|
| Configuration | JavaScript file | CSS-based `@theme` |
| Plugins | `require()` in JS | `@plugin` in CSS |
| Imports | `@tailwind base/components/utilities` | `@import "tailwindcss"` |
| Custom utilities | `@layer components` | `@utility` directive |
| Dark mode | `darkMode: 'class'` | `@custom-variant dark` |
| Astro integration | `@astrojs/tailwind` | `@tailwindcss/vite` |

### Browser Requirements (v4)

| Browser | Minimum Version |
|---------|-----------------|
| Safari | 16.4+ |
| Chrome | 111+ |
| Firefox | 128+ |

v4 uses modern CSS features (`@property`, `color-mix()`) that older browsers don't support.

## Astro Integration (v4)

### Installation

```bash
npm install tailwindcss @tailwindcss/vite
```

### Configuration

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  integrations: [react()],
  vite: {
    plugins: [tailwindcss()],
  },
});
```

### CSS Setup

```css
/* src/styles/global.css */
@import 'tailwindcss';

@plugin '@tailwindcss/typography';
@plugin '@tailwindcss/forms';

@custom-variant dark (&:is(.dark *));

@theme {
  --color-primary-50: #f0f9ff;
  --color-primary-100: #e0f2fe;
  /* ... more colors ... */
  --color-primary-950: #082f49;

  --font-sans: Inter, system-ui, sans-serif;
}
```

### Usage in Layouts

```astro
---
import "../styles/global.css";
---
<html>
  <body class="bg-white text-slate-900 dark:bg-slate-900 dark:text-slate-50">
    <slot />
  </body>
</html>
```

## Custom Utilities (v4)

In v4, custom utilities use `@utility` instead of `@layer components`:

```css
/* v3 syntax (deprecated) */
@layer components {
  .btn {
    @apply px-4 py-2 rounded-lg font-medium;
  }
}

/* v4 syntax */
@utility btn {
  @apply px-4 py-2 rounded-lg font-medium;
}
```

### Peerloop Utility Classes

```css
@utility container-main {
  @apply mx-auto max-w-7xl px-4 sm:px-6 lg:px-8;
}

@utility btn {
  @apply inline-flex items-center justify-center rounded-lg px-4 py-2 font-medium transition-colors focus:outline-hidden focus:ring-2 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50;
}

@utility btn-primary {
  @apply btn bg-primary-600 text-white hover:bg-primary-700 focus:ring-primary-500;
}

@utility card {
  @apply rounded-xl border border-secondary-200 bg-white p-6 shadow-xs dark:border-secondary-700 dark:bg-secondary-800;
}

@utility input {
  @apply block w-full rounded-lg border border-secondary-300 px-4 py-2 text-secondary-900 placeholder-secondary-400 focus:border-primary-500 focus:ring-primary-500 dark:border-secondary-600 dark:bg-secondary-800 dark:text-secondary-100;
}
```

## Class Name Changes (v3 → v4)

The upgrade tool automatically converts these, but be aware:

| v3 | v4 | Notes |
|----|----|-------|
| `shadow-sm` | `shadow-xs` | Shadow scale renamed |
| `shadow` | `shadow-sm` | |
| `blur-sm` | `blur-xs` | Blur scale renamed |
| `rounded-sm` | `rounded-xs` | Radius scale renamed |
| `outline-none` | `outline-hidden` | Accessibility |
| `ring` | `ring-3` | Explicit width |
| `flex-shrink-0` | `shrink-0` | Shortened |
| `flex-grow` | `grow` | Shortened |
| `!important` prefix | `!` suffix | `!flex` → `flex!` |

### Opacity Utilities

v4 deprecates separate opacity utilities in favor of slash notation:

```html
<!-- v3 (deprecated) -->
<div class="bg-black bg-opacity-50">

<!-- v4 -->
<div class="bg-black/50">
```

## Responsive Design

No changes from v3 - mobile-first breakpoints work the same:

```html
<div class="w-full md:w-1/2 lg:w-1/3">
  <!-- Full width on mobile, half on tablet, third on desktop -->
</div>
```

## Dark Mode

v4 uses `@custom-variant` for dark mode class strategy:

```css
/* In global.css */
@custom-variant dark (&:is(.dark *));
```

Usage remains the same:

```html
<div class="bg-white dark:bg-slate-800 text-gray-900 dark:text-gray-100">
  <!-- Automatic dark mode support -->
</div>
```

## Plugins (v4)

Plugins are now imported via `@plugin` in CSS:

```css
@import 'tailwindcss';

@plugin '@tailwindcss/typography';
@plugin '@tailwindcss/forms';
```

| Plugin | Purpose | Status |
|--------|---------|--------|
| `@tailwindcss/typography` | Prose styling for course content | Active |
| `@tailwindcss/forms` | Better form defaults | Active |
| `@tailwindcss/aspect-ratio` | Video embeds | Built-in (v4) |
| `@tailwindcss/container-queries` | Container queries | Built-in (v4) |

## Performance

### Build Times

v4 is significantly faster than v3:

| Metric | v3 | v4 |
|--------|----|----|
| Full build | ~3s | <1s |
| Incremental | ~500ms | <100ms |

### Production Bundle Size

> "Most Tailwind projects ship less than 10kB of CSS"

| Phase | CSS Size |
|-------|----------|
| Development | Full utility set available |
| Production | Only used classes (~5-15KB gzipped) |

## Theme Configuration (v4)

Configuration moved from JavaScript to CSS `@theme`:

```css
@theme {
  /* Colors */
  --color-primary-500: #0ea5e9;
  --color-primary-600: #0284c7;

  /* Typography */
  --font-sans: Inter, system-ui, sans-serif;

  /* Custom values */
  --spacing-18: 4.5rem;
}
```

These become CSS variables AND Tailwind utilities:
- `--color-primary-500` → `bg-primary-500`, `text-primary-500`, etc.
- `--font-sans` → `font-sans`

## Peerloop Design Tokens

```css
@theme {
  /* Brand colors */
  --color-primary-50: #f0f9ff;
  --color-primary-100: #e0f2fe;
  --color-primary-200: #bae6fd;
  --color-primary-300: #7dd3fc;
  --color-primary-400: #38bdf8;
  --color-primary-500: #0ea5e9;
  --color-primary-600: #0284c7;
  --color-primary-700: #0369a1;
  --color-primary-800: #075985;
  --color-primary-900: #0c4a6e;
  --color-primary-950: #082f49;

  /* Secondary (slate-based) */
  --color-secondary-50: #f8fafc;
  --color-secondary-100: #f1f5f9;
  --color-secondary-200: #e2e8f0;
  --color-secondary-300: #cbd5e1;
  --color-secondary-400: #94a3b8;
  --color-secondary-500: #64748b;
  --color-secondary-600: #475569;
  --color-secondary-700: #334155;
  --color-secondary-800: #1e293b;
  --color-secondary-900: #0f172a;
  --color-secondary-950: #020617;

  /* Typography */
  --font-sans: Inter, system-ui, sans-serif;
}
```

## Migration from v3

### Official Upgrade Tool

```bash
npx @tailwindcss/upgrade
```

**Requirements:**
- Node.js 20+
- Clean git directory (or use `--force`)

**What it does:**
- Updates dependencies
- Migrates `tailwind.config.js` to CSS `@theme`
- Updates class names in templates
- Converts plugin imports

### Manual Migration Steps

If the upgrade tool doesn't work:

1. **Install new packages:**
   ```bash
   npm uninstall @astrojs/tailwind
   npm install tailwindcss @tailwindcss/vite
   ```

2. **Update astro.config.mjs:**
   ```javascript
   import tailwindcss from '@tailwindcss/vite';

   export default defineConfig({
     vite: {
       plugins: [tailwindcss()],
     },
   });
   ```

3. **Update global.css:**
   ```css
   @import 'tailwindcss';
   @plugin '@tailwindcss/typography';
   @plugin '@tailwindcss/forms';
   ```

4. **Migrate theme to CSS `@theme`**

5. **Delete tailwind.config.js/mjs**

### Migration Caveats

| Issue | Solution |
|-------|----------|
| `@astrojs/tailwind` conflicts with v4 | Uninstall before upgrading |
| Older browsers unsupported | Stick with v3 if needed |
| Some plugins not v4-compatible | Check plugin docs |

## React Component Patterns

```jsx
// Reusable component with Tailwind v4
const Button = ({ variant = 'primary', children, ...props }) => {
  const variants = {
    primary: 'bg-primary-600 hover:bg-primary-700 text-white',
    secondary: 'bg-secondary-100 hover:bg-secondary-200 text-secondary-700',
    danger: 'bg-red-600 hover:bg-red-700 text-white',
  };

  return (
    <button
      className={`btn ${variants[variant]}`}
      {...props}
    >
      {children}
    </button>
  );
};
```

## User Story Support

Tailwind enables UI implementation for all user stories:

| Story Category | Tailwind's Role |
|---------------|-----------------|
| Profile display (US-C008, US-S008) | Avatar, card, badge components |
| Course catalog (US-S001, US-S003) | Grid layouts, cards, search UI |
| Dashboard (US-S009, US-T013) | Charts, stats cards, widgets |
| Mobile responsiveness | All stories (implicit requirement) |

---

## References

- [Tailwind CSS v4 Documentation](https://tailwindcss.com/docs)
- [Tailwind CSS v4 Upgrade Guide](https://tailwindcss.com/docs/upgrade-guide)
- [Tailwind CSS with Astro](https://tailwindcss.com/docs/installation/framework-guides/astro)
- [@tailwindcss/vite](https://www.npmjs.com/package/@tailwindcss/vite)
