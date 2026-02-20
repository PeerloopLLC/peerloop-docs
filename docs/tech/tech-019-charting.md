# tech-019-charting.md

**Library:** chart.js + react-chartjs-2
**Type:** Data Visualization / Charts
**Website:** https://www.chartjs.org/
**Source:** CANA (Creator Analytics), Admin Analytics, ST Analytics
**Status:** ACTIVE (2026-02-06, migrated from Recharts)

---

## Overview

Canvas-based charting library for analytics dashboards. Replaced Recharts in Session 209 due to bundle size — Recharts bundled 392 KB (115 KB gzip) from monolithic D3 internals. chart.js with selective component registration produces 188.5 KB (65.6 KB gzip), a 43% gzip reduction.

**Key Value Proposition:**
- Tree-shakeable via register pattern (only import what you use)
- Canvas-based (better performance for analytics datasets)
- `react-chartjs-2` provides thin React wrapper (~3 KB gzip)
- Responsive by default via ResizeObserver

---

## Why chart.js for PeerLoop

### Decision Context (Session 209)

Recharts was the original choice for fastest implementation. It was replaced when staging deploy revealed the chart bundle was the largest client asset — nearly 2x the React runtime.

| Criterion | Recharts (former) | chart.js (current) | Tremor | Nivo |
|-----------|-------------------|---------------------|--------|------|
| Bundle (gzip) | ~115 KB | ~65 KB | ~200KB+ | ~180KB |
| Rendering | SVG | Canvas | SVG | SVG/Canvas |
| Tree-shaking | Poor (D3 internals) | Excellent (register) | N/A | Moderate |
| React integration | Native components | Wrapper | Native | Native |
| jsdom test support | Works (SVG) | Needs mocks (canvas) | Works | Partial |
| Learning curve | Low | Low | Low | Medium |

### Why chart.js Won

1. **Smallest bundle** — register pattern excludes unused chart types
2. **Canvas performance** — faster re-renders for analytics dashboards
3. **Clean migration** — abstraction layer meant zero consumer changes
4. **Mature ecosystem** — large community, extensive plugin system

### Trade-offs Accepted

- **Canvas not SVG** — no CSS styling of chart elements, no DOM inspection. Fine for analytics.
- **Test mocks required** — jsdom lacks canvas getContext and ResizeObserver. Global mocks in `vitest.setup.ts` handle this.

---

## Chart Types in Use

| Chart Type | Purpose | chart.js Component | Wrapper |
|------------|---------|---------------------|---------|
| Line/Area | Enrollment & revenue trends | `Line` with `fill: true` | `AreaChart.tsx` |
| Bar | Sessions, ST performance | `Bar` | `BarChart.tsx` |
| Pie/Donut | Progress distribution, revenue split | `Doughnut` | `PieChart.tsx` |
| Funnel | Conversion funnel | Pure React/CSS | `FunnelChart.tsx` |

**9 consumer components** import from `@components/ui/charts` — none import `chart.js` directly.

---

## Architecture

### Abstraction Layer

All chart components are wrapped behind library-agnostic interfaces in `src/components/ui/charts/`:

```
src/components/ui/charts/
├── chart-setup.ts    # Centralized chart.js registration
├── types.ts          # Library-agnostic interfaces
├── index.ts          # Re-exports
├── AreaChart.tsx      # Line + fill (chart.js)
├── BarChart.tsx       # Bar (chart.js)
├── PieChart.tsx       # Doughnut (chart.js)
└── FunnelChart.tsx    # Pure React/CSS (no library)
```

### Registration Pattern

chart.js tree-shaking works via explicit registration — only registered components are bundled:

```typescript
// chart-setup.ts — single registration point
import { Chart as ChartJS, ArcElement, BarElement, LineElement,
  PointElement, CategoryScale, LinearScale, Filler, Tooltip, Legend
} from 'chart.js';

ChartJS.register(ArcElement, BarElement, LineElement, PointElement,
  CategoryScale, LinearScale, Filler, Tooltip, Legend);
```

### Standardized Data Format

```typescript
// types.ts — same interfaces since initial implementation
export interface TimeSeriesData {
  date: string;
  [key: string]: number | string;
}

export interface CategoryData {
  name: string;
  value: number;
  color?: string;
}

export interface ChartConfig {
  height?: number;
  colors?: string[];
  showLegend?: boolean;
  showTooltip?: boolean;
  animate?: boolean;
}
```

### Implementation Example

```typescript
// AreaChart.tsx — chart.js Line with fill
import { Line } from 'react-chartjs-2';
import { ChartJS } from './chart-setup';
import type { ChartOptions } from 'chart.js';

const options: ChartOptions<'line'> = {
  responsive: true,
  maintainAspectRatio: false,
  // ChartOptions<'line'> provides full type inference for callbacks
  plugins: {
    tooltip: {
      callbacks: {
        label: (context) => ` ${context.dataset.label}: ${context.parsed.y}`,
      },
    },
  },
};

return (
  <div style={{ width: '100%', height }}>
    <Line data={chartData} options={options} />
  </div>
);
```

---

## Pricing

| Library | Cost |
|---------|------|
| chart.js | Free (MIT) |
| react-chartjs-2 | Free (MIT) |

---

## Installation

```bash
npm install chart.js react-chartjs-2
```

Types included in both packages (no @types needed).

---

## References

- chart.js docs: https://www.chartjs.org/docs/
- react-chartjs-2 docs: https://react-chartjs-2.js.org/
- chart.js migration guide (v3→v4): https://www.chartjs.org/docs/latest/migration/v4-migration.html

---

## Caveats & Gotchas

1. **Canvas mocks for testing** — jsdom doesn't implement `HTMLCanvasElement.getContext()` or `ResizeObserver`. Both are mocked globally in `vitest.setup.ts`. Tests that render chart components work without per-file mocking, but don't verify actual canvas output.

2. **chart.js v4 grid config** — `grid.drawBorder` was removed in v4. Use `border: { display: true/false }` as a sibling to `grid` instead.

3. **Type-safe options** — Always annotate options with `ChartOptions<'bar'>` (or `'line'`, `'doughnut'`). This gives full type inference for callbacks. Without it, TypeScript can't match callback parameter types.

4. **Parsed values can be null** — chart.js tooltip callbacks receive `context.parsed.y` as `number | null`. Always use `?? 0` when passing to formatters.

5. **Vite cache after install** — After adding chart.js (or any new dependency), the Vite dev server may serve stale pre-bundled files from `node_modules/.vite/`. Fix: `rm -rf node_modules/.vite && npm run dev`.

6. **FunnelChart is pure React** — `FunnelChart.tsx` uses CSS percentage widths, not chart.js. It has zero library dependency and no canvas involvement.

7. **Cutout percentage** — chart.js `Doughnut` uses `cutout: '60%'` (percentage string) for the inner hole, not absolute pixel values like Recharts. The `PieChart` wrapper converts the legacy `innerRadius`/`outerRadius` pixel props to a cutout percentage.

---

## Bundle History

| Date | Library | Raw Size | Gzip Size | Notes |
|------|---------|----------|-----------|-------|
| 2026-01-22 | Recharts | 392 KB | 115 KB | Initial implementation |
| 2026-02-06 | chart.js | 188.5 KB | 65.6 KB | Session 209 migration |
