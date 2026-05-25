> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 4. Open Questions

Consolidated across the architectural review and source-doc review. Resolve during [MATT-PRE-PLAN] before token files are finalized.

**Visual / interaction:**

1. **Visitor flow on currently-Member-only pages.** Matt's design enumerates Visitor as a role. POLICIES §7 lists pages as Member-only (`/community`, `/courses`, etc.) that the middleware redirects to `/login`. Does Matt's design imply some of these should become Public-browsable for Visitors? Or does Visitor only see Public-browsable pages? — Likely the latter; confirm during [MATT-PRE-PLAN].
2. **Account dropdown.** Existing `UserMenu` component has role-based menu items (My Learning / My Teaching / Creator Studio / Settings / Sign Out). Where does this live in Matt's design? The Teacher screen sidebar shows the profile chip at the bottom — does it open this menu on click?
3. **Footer.** Existing app has `PublicFooter` / `GatedFooter`. Matt's screens don't show a footer. Decision needed: does Matt's design omit footers entirely, or is it just not shown in the happy-path screens?

**Structural:**

4. **Inner column grid inside Main Panel** — Matt's screens show flexible width content. Is there a fixed N-column inner grid, or is the Main Panel just fluid width with content blocks stacking naturally? **Working answer Conv 172 (Batch 4):** no formal grid; fluid-width content with primitives composing naturally. Verification pending — if a Matt populated-page frame shows a Figma layout-grid overlay, override this answer.
5. **Featured-course card on Home page** — is the dark hero on Home the same component as the full Course Header (just rendered in a smaller container), or a distinct "Featured Course" variant?
6. **Free Teacher badge on Teacher page** — green-tinted badge with "Schedule Live Session" CTA. Is this a Teacher state-variant (free vs paid) or a per-page badge component?
9. **Distinct Main Panel inner layouts** *(Conv 172 addition).* Matt's 31 happy-path screens contain multiple distinct inner-Main-Panel layout shapes: Home community feed; Course detail (Course Header + vertical Sub Nav + tab content); Teacher profile (Teacher Header + Sub Nav); Discover / Explore pages; possibly Settings, Admin, and others. The §2 layout-shell ASCII diagram captures only the Course-detail variant. How do we catalog and abstract these inner-shell layout variants for `MattLayout.astro` slot design? Likely: enumerate per-page-type during [MATT-PRE-PLAN], group by shape, identify shared primitives.

**Implementation** *(added Conv 172)***:**

8. **CSS length units.** What units should the token system use? Tailwind 4 natively uses indexed names + rem values (`--spacing-1: 0.25rem`). We've chosen pixel NAMES (Conv 172 — `--space-4`), but unit-VALUES are orthogonal:
   - **Pure px:** concrete, predictable, matches measurements. No accessibility scaling.
   - **Pure rem:** accessibility-correct (respects user font-size). Creates awkward `--space-4: 0.25rem` mapping.
   - **Hybrid:** rem for typography + spacing, px for borders + UI hairlines. Common design-system convergence.

   Decision affects all of `tokens-primitives.css` — wrong call means a global find-replace later. Token NAMES are decided (pixel-named, Conv 172) — this is about VALUES.

**Designer-side:**

7. **Typo to flag with Matt:** Teacher page says "**Exertise**" — should be "**Expertise**".

---

