---
name: plato_walk_mocked_service_divergence
description: "PLATO browser-walk row-identity vs API-producer oracle EXCLUDES notifications (producer mocks silent, live writes real); user_stats was a fire-and-forget Worker bug fixed Conv 384."
metadata: 
  node_type: memory
  type: reference
  originSessionId: ba09882c-f2ba-4a31-b50d-afacc336e107
---

[PLATO-SEQ] browser-walk validation caveat (Conv 384). A browser walk on the **live** dev server and the **API-producer** oracle (`ecosystem.sqlite`, `activities.sqlite`, …) will NOT be row-identical on tables written by **producer-mocked services**:

- **`notifications` — irreducible, EXCLUDE it from the per-table COUNT diff.** The producer's `MockRegistry` silences every `notify*` call (oracle = 0 rows); the live server writes them for real (session_booked/completed, enrollment_completed, system…). No bridge reconciles it. `ecosystem-walk` matched **69/70** tables with this exclusion; `activities-walk` matched 68/70.
- **`user_stats` — WAS a bug, fixed Conv 384 `[PSA-WAITUNTIL]`.** `completeSession`'s `triggerPostSessionActions` (stats + completion notifications) ran fire-and-forget (`booking.ts:171`) → dropped on Worker teardown → user_stats never persisted after a live BBB `room_ended`. Now `waitUntil`-wrapped on both BBB webhook paths (`booking.ts` optional param + `webhooks/bbb.ts`). Post-fix, a walk's user_stats matches the oracle.

**The Conv-383 "activities walk 70/70 identical" claim was INACCURATE** — `activities-walk.sqlite` diverges from its oracle on `notifications` (0 vs 6) AND `user_stats` (3 vs 1); the 8 activities verify assertions pass but never check those two tables. Re-walk activities with the fixed code to refresh its user_stats.

**CUT-2 enroll bridge** (browser can't cross Stripe Checkout): pipe a `checkout.session` JSON — metadata `pending_enrollment_id`/`student_id`/`course_id`/`creator_id`/`instructor_type:creator`/`teacher_certification_id`/`assigned_teacher_id`, **NO `payment_intent`** (→ 0 transactions/splits, matching the mock) — to `./scripts/trigger-webhook.sh stripe-direct-raw checkout.session.completed -`. See [[plato-context]].
