> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 1. Strategic Context

**Why Matt came in late.** The app was deliberately built ~5 months BEFORE bringing in a designer, so Matt would design against a functional, complex reality — not speculate about one. This avoids the common failure mode of designers producing imperfect mockups of flows they don't yet understand.

**Matt's brief.** Simplify, design, and present the **80/20 Pareto perspective** for the student → teacher journey. Matt's value-proposition focus is **proving the flywheel that Peerloop is built on: turning students into teachers.** The 31 happy-path screens are the **first leg** of that flywheel journey, captured with deliberately simplified single-role views (which is why multi-role complexity was kept out of Matt's brief — it would have slowed him down without adding value to the core flywheel demonstration).

**The user's 3-part job:**

1. ✅ Make sure the app is fully functional first (achieved across the prior ~170 convs)
2. 🚧 Merge Matt's perspectives into the working app (this is `/matt/*` re-skin work)
3. 🚧 Extrapolate Matt's designs to the rest of the app (the ~84 existing pages Matt didn't draw)

**Implication for the design system.** Matt's 31 happy-path screens are the **calibration set** for a design language; the **~84 existing pages are the extrapolation test.** This raises the bar:

- **Tokens** must be complete and consistent enough that an unseen page (e.g. `/admin/payouts`, `/settings/security`) can be styled correctly from tokens alone, without inventing values mid-implementation.
- **Layout primitives** must compose into shapes Matt never drew (admin multi-pane layouts, modal-heavy flows, settings forms, error states).
- **Component primitives** must cover patterns the happy path doesn't exercise (data tables, complex forms, empty/error/loading states for less-glamorous pages).
- **The North Star tiebreaker for any visual decision:** does this surface the flywheel? Does this lower the friction of the student → teacher transition?

**Action item for [MATT-PRE-PLAN]:** explicitly enumerate **what's missing from Matt's set** — gaps in his happy-path visual language that we'll need to fill with extrapolation judgment. Surface these during planning, not piecemeal during implementation. Candidates so far: admin layouts, data tables, complex forms, error/empty/loading states, the **Role Tab Bar** (multi-role perspective switcher — Matt didn't draw it because his design doesn't account for users holding multiple roles for the same entity).

**Authority split.**

- **Matt's design = visual spec for the happy path.** Use it for tokens, primitive components, page-shell layout, entity-header treatment.
- **Existing Peerloop app = behavioral spec.** Routing, data fetching, role logic, multi-role switching, permission gating — all live in the real app. The happy path was _deliberately simplified_ to spare Matt from the full multi-role complexity.
- **`/matt/*` is visual re-skinning, not architecture work.** Each `/matt/*` route corresponds to an existing page; we wrap its existing data/behavior in Matt's tokens + components.

---

