# Staging Webhook Setup Checklist

**Created:** Conv 037 (2026-03-27)
**Context:** R2 bucket isolation complete, `staging.peerloop.pages.dev` already active. These are the remaining manual steps to enable webhook testing on staging.

---

## 1. Cloudflare Dashboard — Preview Secrets

Verify all secrets are set in the CF Dashboard **Preview** tab (Settings > Environment Variables > Preview):

| Secret | Value | Notes |
|--------|-------|-------|
| `JWT_SECRET` | Different from prod recommended | Prevents staging tokens working on prod |
| `STRIPE_SECRET_KEY` | `sk_test_...` | Must be test mode key |
| `STRIPE_WEBHOOK_SECRET` | From Stripe Dashboard (step 2) | New signing secret for staging endpoint |
| `BBB_SECRET` | Same as prod | Same Blindside Networks account |
| `STREAM_API_SECRET` | Dev app secret | Dev app `1457190` (different from prod `1456912`) |
| `RESEND_API_KEY` | Same test key | OK to share between preview/prod for test mode |

**How to access:** Cloudflare Dashboard > Pages > peerloop > Settings > Environment Variables > Preview tab

---

## 2. Stripe Dashboard — Staging Webhook Endpoint

In Stripe Dashboard (**test mode**):

1. Go to Developers > Webhooks
2. Click "Add endpoint"
3. URL: `https://staging.peerloop.pages.dev/api/webhooks/stripe`
4. Select events (match production):
   - `checkout.session.completed`
   - `checkout.session.expired`
   - `transfer.paid`
   - `account.updated`
   - (any others currently on the production endpoint)
5. Save and copy the **signing secret** (`whsec_...`)
6. Paste that signing secret into CF Dashboard Preview as `STRIPE_WEBHOOK_SECRET`

---

## 3. Blindside Networks — Email to Binoy/Fred

Email `binoy.wilson@blindsidenetworks.com` (cc Fred Dixon) with:

### Request 1: Webcam Storage
> Please set **instructor-only webcam storage** on the Peerloop account. We do not want student/viewer webcams stored in recordings.

### Request 2: Analytics Callback Confirmation
> Our analytics callback endpoint is live at:
> `https://staging.peerloop.pages.dev/api/webhooks/bbb-analytics`
>
> Can you confirm:
> 1. Is the `meta_analytics-callback-url` parameter sufficient to trigger callbacks, or do you also need to configure something on your side?
> 2. Is the JWT shared secret for analytics callbacks the same as our BBB API shared secret?

### Request 3: Production URL (when ready)
> We will provide the production callback URL separately once we deploy to production.

---

## 4. Verification

After completing steps 1-3:

- [ ] Run a test Stripe checkout on `staging.peerloop.pages.dev` — confirm webhook fires and creates enrollment in staging D1
- [ ] Join a BBB session on staging — confirm meeting-ended webhook fires back to staging
- [ ] Upload a test file on staging — confirm it appears in `peerloop-storage-staging` R2 (not production)
- [ ] Run a BBB session to completion — confirm analytics callback arrives (if Blindside has confirmed setup)

---

## Background (already done — Conv 037)

- `peerloop-storage-staging` R2 bucket created
- `wrangler.toml` updated — preview uses staging R2
- `staging` branch exists and deploys to `staging.peerloop.pages.dev`
- D1 staging, KV staging already configured
- BBB webhooks are per-meeting (auto-set from request origin — no vendor config needed)
- Stream.io webhooks not used (client-side real-time only)
