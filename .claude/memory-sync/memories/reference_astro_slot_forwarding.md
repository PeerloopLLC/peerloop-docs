---
name: reference-astro-slot-forwarding
description: "Astro Fragment slot-forwarding suppresses the child component's named-slot fallback content, even when the forwarded slot is empty. Don't rely on dual-layer fallbacks — put defaults at the layout/consumer level via ternary, or use Astro.slots.has() to suppress the Fragment entirely."
metadata: 
  node_type: memory
  type: reference
  originSessionId: b954cdf5-6eac-4506-8e8f-b77da3063b18
---

# Astro slot-forwarding suppresses fallback content

When a parent layout forwards a named slot to a child component via Fragment,
the child component's `<slot name="...">FALLBACK</slot>` default content is
suppressed — even when the parent's source slot is empty.

## The trap

```astro
{/* AppLayout.astro */}
<HeaderBar>
  <Fragment slot="header-center">
    <slot name="header-bar-mobile-center" />
  </Fragment>
</HeaderBar>

{/* HeaderBar.astro */}
<slot name="header-center">
  <span data-matt="brand-mark">∞ PeerLoop</span>  {/* never renders */}
</slot>
```

If the page calling `<AppLayout>` does NOT provide `header-bar-mobile-center`,
the inner `<slot name="header-bar-mobile-center" />` resolves to empty — but
the surrounding `<Fragment slot="header-center">` is *syntactically* non-empty,
so `HeaderBar` sees `header-center` as "filled (with empty content)" and the
brand fallback is suppressed.

Conv 175 [MSH-VIZ]: empty floating-pill at tablet portrait — HeaderBar's center
slot rendered nothing because AppLayout's Fragment-forwarding overrode the
brand default.

## What didn't work

Wrapping the Fragment in `{Astro.slots.has('header-bar-mobile-center') && ...}`
*did not* restore the fallback. Astro still rendered the slot as filled. Root
cause not pinned down — either `Astro.slots.has` returned true unexpectedly,
or the short-circuit evaluation still produced a Fragment-shaped result that
Astro counted as filled. Either way, the dual-layer fallback pattern is too
fragile to rely on.

## The fix

Move defaults to the layout/consumer (AppLayout), inside *unconditional*
Fragments, with `Astro.slots.has()` ternaries:

```astro
<HeaderBar>
  <Fragment slot="header-center">
    {Astro.slots.has('header-bar-mobile-center') ? (
      <slot name="header-bar-mobile-center" />
    ) : (
      <span data-matt="brand-mark">∞ PeerLoop</span>
    )}
  </Fragment>
</HeaderBar>
```

This collapses the dual-layer fallback into one — defaults live where the
component is consumed; the primitive (HeaderBar) becomes a pure shell.

## How to apply

- When building Matt-shell or any Astro layout component with slot-forwarding,
  put default content in the layout consumer, not in the primitive's slot
  fallback.
- If you keep a default in a primitive's `<slot>` tag, do NOT also forward
  that slot from a parent layout — pick one location.
- Suspect this bug when a slot renders empty despite the primitive's source
  showing fallback content.

Tracked as cleanup in [[MSH-REFINE]]: remove now-dead slot fallbacks from
`HeaderBar.astro` so the only source of defaults is `AppLayout.astro`.
