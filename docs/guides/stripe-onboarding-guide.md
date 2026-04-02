# Stripe Onboarding Guide for Creators & Teachers

> **Purpose:** Step-by-step guide for Peerloop creators and teachers to connect their Stripe account and start receiving payments.
>
> **Audience:** Client (for creating a help article or walkthrough video)
>
> **Date captured:** 2026-02-18 (Stripe Express onboarding, test mode)

---

## Why You Need to Connect Stripe

Before students can enroll in your courses, you need to connect a Stripe account. This is how you'll receive your earnings:

- **Creators** receive **85%** of course revenue (when teaching directly) or **15% royalty** (when a Teacher teaches)
- **Teachers** receive **70%** of course revenue

Stripe handles all payment processing securely. Peerloop never sees or stores your bank details.

---

## How to Start

1. Log in to Peerloop
2. Go to **Settings** > **Payment Settings** (or navigate directly to `/settings/payments`)
3. Click the **"Connect with Stripe"** button

You'll be redirected to Stripe's secure onboarding form. This process takes **5-10 minutes**.

---

## Screen-by-Screen Walkthrough

### Screen 1: "Let's get started"

**What you'll see:** A split-screen layout. The left panel shows Peerloop branding ("Alpha Peer LLC" in test mode) with a "Return to Alpha Peer LLC" link. The right panel has the form.

**Layout:**
- **Left panel (purple):** Platform branding, "← Return to [Platform name]" link
- **Right panel (white):** Onboarding form

**Fields:**

| Field | What to Enter | Notes |
|-------|--------------|-------|
| Email address | Your email address | Used for Stripe account communications |
| Phone number | Your real mobile number (+1 for US) | Stripe sends a verification code via SMS |

After submitting, Stripe sends an SMS code. Enter it on the next mini-screen to verify.

**Tips for creators:**
- Use a phone number you have immediate access to — you'll receive a verification code
- The email is for your Stripe account (receipts, payout notifications) — can differ from your Peerloop email
- The "← Return to..." link in the left panel safely cancels and takes you back to Peerloop

**Test mode differences:**
- Banner at top: "You're using a test account with test data."
- "Skip this with a test phone number" shortcut appears — click **"Use test phone number"** to bypass SMS
- Email field note: "Email is not needed for test accounts"

### Screen 1b: Phone Verification Code

**What you'll see:** "We sent a text to your phone" — 6-digit code entry (3 digits, dash, 3 digits).

| Element | Description |
|---------|------------|
| Header | "We sent a text to your phone" |
| Subtitle | "Enter the verification code we sent to your number ending in XXXX" |
| Code input | Six individual digit boxes (XXX - XXX format) |
| Resend code | Link to resend if code doesn't arrive |
| Use a different phone number | Link to go back and change the number |

**What to do:** Enter the 6-digit code from the SMS on your phone.

**Tips for creators:**
- Code arrives within 30 seconds typically
- If you don't receive it, click **"Resend code"**
- If you entered the wrong number, click **"Use a different phone number"** to go back

**Test mode:** Click **"Use test code"** — Stripe displays the code `000000` and auto-fills it for you.

---

### Screen 2: Personal Details — "Verify your personal details"

**What you'll see:** A long form under the heading "Verify your personal details" with a "Personal details" breadcrumb/stepper at the top. The subtitle explains: "This information is collected to verify your identity, keep your account safe, and help meet legal and regulatory requirements."

> **Note:** The "Business Type" step (Individual vs Company) may not appear as a separate screen — Stripe defaults to **Individual** for Express accounts. If you do see it, select **Individual** unless you operate under a registered business entity (LLC, Corp, etc.).

**Fields:**

| Field | What to Enter | Notes |
|-------|--------------|-------|
| Legal first name | Your legal first name | Must match government ID (e.g., IRS records) exactly |
| Legal last name | Your legal last name | Must match government ID exactly |
| Email address | Your email | Pre-filled from Peerloop — can be changed. Used for Stripe communications (payout receipts, etc.) |
| Date of birth | Your actual DOB (MM/DD/YYYY) | Required for identity verification |
| Home address — Country | Your country of residence | Dropdown, determines tax forms and payout options |
| Home address — Street | Your residential street address | Used for tax reporting (1099-K in the US) |
| Home address — Apt/Unit | Apartment, unit, or suite | Optional |
| Home address — City | Your city | |
| Home address — State | Your state | Dropdown |
| Home address — Zip code | Your zip code | |
| Phone number | Your phone number (+1 for US) | Must be in the country of your account |
| Last 4 digits of SSN | Your last 4 SSN digits | Required by law for regulatory/tax purposes |

**Why does Stripe need my SSN and address?**
Stripe is a regulated financial service — they're **legally required** to verify your identity and report earnings to the IRS (form 1099-K). **Peerloop never sees or stores this information.** It goes directly to Stripe's secure servers.

**Tips for creators:**
- Use the name exactly as it appears on your government ID — mismatches cause verification delays
- Your home address is used for tax reporting, not displayed publicly
- If you're outside the US, the SSN field will change to your country's equivalent (e.g., SIN for Canada)

**Test mode values (for internal testing only):**

| Field | Test Value |
|-------|-----------|
| First name | `Guy` |
| Last name | `Rymberg` |
| Email | Pre-filled: `guy_rymberg@example.com` |
| DOB | `01/15/1985` (any valid past date) |
| Address | `123 Main St, San Francisco, CA 94105` |
| Phone | `000 000 0000` (any number) |
| SSN last 4 | `0000` |

---

### Screen 3: Business Details — "Tell us a few details about how you earn or collect money"

**What you'll see:** A "Business details" step with two fields: Industry and Website. The subtitle reads: "Tell us a few details about how you earn or collect money with [Platform name]."

**Fields:**

| Field | What to Enter | Notes |
|-------|--------------|-------|
| Industry | Select **"Other educational services"** | Dropdown — search "education" to find it quickly |
| Your website | **Your Peerloop profile URL** | e.g., `peerloop.com/creators/your-handle` (recommended) |

**Alternative to website:** If you don't have a website, click the **"Don't have a website? Add product description instead."** link. The website field changes to a **"Product description"** textarea. Enter a short description of what you teach, e.g.: *"I teach others how to use AI tools effectively in their personal and professional life"*

**Important:** The product description option includes a disclaimer: *"you confirm that you don't use a website, app, social media page, or online profile to promote or sell products or services."* Since you **do** have a Peerloop profile, **we recommend using the website field** with your Peerloop creator profile URL in production.

**Tips for creators:**
- **Industry:** Select **"Other educational services"** — this is the best match for course creators on Peerloop
- **Website (recommended):** Enter your Peerloop creator profile URL. Stripe requires a real, functional URL — not a generic homepage or under-construction page
- **Product description (alternative):** Briefly describe what you teach and how students pay (e.g., per-course enrollment)

**Test mode values:**

| Field | Test Value |
|-------|-----------|
| Industry | Other educational services |
| Website / Product description | Clicked "Add product description instead" → *"I teach others how to get robustly into letting AI assist you in your personal life"* |

---

### Screen 4: Bank Details — "Select an account for payouts"

**What you'll see:** "Select an account for payouts" with subtitle "We'll send earnings you receive to this account." The screen offers two ways to connect your bank:

#### Option A: Connect via Bank Login (recommended)

Stripe partners with Plaid to let you securely log into your bank. You'll see a list of popular banks (Chase, Bank of America, Wells Fargo, etc.) and a search bar.

1. **Find your bank** — search or scroll through the list
2. **Log in** — enter your online banking credentials (goes to Plaid, not Stripe or Peerloop)
3. **Select account** — choose checking or savings for payouts
4. Done — Stripe verifies instantly

**Tips for creators:**
- This is the fastest way — instant verification, no waiting
- Your bank login credentials go to Plaid (a trusted financial data provider), not to Peerloop
- If your bank isn't listed, use the manual entry option below

#### Option B: Manual Bank Account Entry

If you prefer not to use bank login, or your bank isn't listed:

1. Look for **"Enter bank account credentials instead"** or **"Use routing and account number"** link
2. Enter your bank details manually:

A **Stripe-branded modal popup** appears over the page with the heading **"Enter bank details"** and subtitle "Checking and savings accounts are supported."

| Field | What to Enter | Notes |
|-------|--------------|-------|
| Routing number | Your bank's 9-digit routing number | Found on checks, bank app, or bank's website |
| Account number | Your bank account number | Double-check — errors delay payouts |
| Confirm account number | Same as above | Must match exactly |

At the bottom of the modal: *"By adding your bank account to your Stripe account and clicking below, you authorize Stripe to debit your bank as described in these terms."*

**Tips for creators:**
- **Where to find your routing number:** Bottom-left of a check, or in your bank's app under "Account Details"
- **Checking vs savings:** Either works. Most creators use checking for faster access
- Manual entry may require micro-deposit verification (2-3 business days) — Stripe sends two small deposits to confirm the account

**Test mode:**

In test mode, the screen shows simulated institutions instead of real banks. Options:
- **"Test (Non-OAuth)"** — simplest, simulates instant bank connection
- **"Test (OAuth)"** — simulates OAuth bank login flow
- **"Enter test bank account credentials instead →"** — manual entry with test routing `110000000` and account `000123456789`
- Avoid the "Down" options (these simulate failures)

| Test Path | Use For |
|-----------|---------|
| Test (Non-OAuth) | Quick happy path — recommended |
| Enter test bank account credentials instead | Mirrors manual entry experience |

---

### Screen 5: "Save account with Link" (Optional — Skip)

**What you'll see:** A Stripe-branded modal asking to save your account with **Stripe Link** — Stripe's one-click payment network.

- "Share your account faster everywhere Link is accepted."
- "Link encrypts your data."
- Email (pre-filled) and phone number fields
- Two buttons: **"Save with Link"** and **"Finish without saving"**

**What to do:** Click **"Finish without saving"** — this is optional and not related to Peerloop. Stripe Link saves your bank details for use across other Stripe-powered websites, which you may or may not want.

---

### Screen 6: Review & Submit — "Review and submit"

**What you'll see:** A full summary of everything you entered, organized into sections. Each section has an **"Edit" button** to go back and change anything.

**Sections displayed:**

| Section | What It Shows |
|---------|--------------|
| **Business type** | "Individual or sole proprietorship" + your country |
| **Professional details** | Your name + product description or website + industry |
| **Public details** | **Statement descriptor** — this is what appears on students' credit card/bank statements (defaults to your name in uppercase) |
| **Personal details** | Name, email, DOB, address, and confirmation that SSN + phone were provided |
| **Payout details** | Bank name, currency (USD), routing number, last 4 of account number, and payout speed eligibility |

**What to do:**
1. **Review each section carefully** — use the Edit buttons to fix any mistakes
2. Read the agreement text at the bottom (Connected Account Agreement + Acquirer Disclosure)
3. Click **"Agree and submit"**

**Tips for creators:**
- **Check your statement descriptor** — this is what students see on their bank statements when they pay for your course. It defaults to your name in uppercase. If you prefer a different descriptor, click Edit on the "Public details" section
- **Payout details** — confirm the bank account is correct. Look for the "Instant-eligible" badge (green) which means you can opt for instant payouts later (standard payouts are free, instant payouts have a small fee)
- You can still go back and edit any section — nothing is final until you click "Agree and submit"

---

## After Onboarding

Once you return to Peerloop's Payment Settings page (`/settings/payments`), you should see:

- **Green checkmark icon** with **"Connected"** title and green **"active"** badge
- **"Your Stripe account is active and ready to receive payments."**
- Three green checkmarks: **Charges enabled**, **Payouts enabled**, **Details submitted**
- A **"View Dashboard"** button (opens your Stripe Express dashboard in a new tab)

Below the Stripe Connect section, the page also shows a **"How Payments Work"** summary:
1. When a student enrolls in your course, they pay through Stripe Checkout.
2. PeerLoop automatically splits the payment: you receive 85% as the creator (or 70% as a Teacher), and PeerLoop keeps 15%.
3. Funds are transferred to your connected Stripe account, typically within 2 business days.

**You're all set!** Your courses are now ready to accept student enrollments and payments.

---

## Common Questions

### "How long until I get paid?"
Stripe typically holds funds for **2 business days** before releasing to your bank. First payouts may take **7-14 days** as Stripe verifies your account.

### "Can I change my bank account later?"
Yes. Go to **Settings > Payment Settings** and click **"View Dashboard"** to access your Stripe Express dashboard where you can update bank details.

### "What if my status shows 'Restricted'?"
This means Stripe needs additional information. Click **"Update Information"** on the Payment Settings page and provide whatever Stripe requests (usually ID verification or address confirmation).

### "I don't have a US bank account"
Stripe supports payouts in [40+ countries](https://stripe.com/global). Select your country during onboarding and Stripe will show local bank account options.

### "Do I need a business license?"
No. Individual course creators can use their personal identity and bank account. You only need business details if you operate as a registered entity.

---

## Troubleshooting

| Issue | Solution |
|-------|---------|
| Never received SMS code | Check spam, try again, or use a different phone number |
| "Account restricted" after submission | Stripe may need ID verification — check email from Stripe |
| Bank account rejected | Verify routing/account numbers are correct. Stripe doesn't accept all bank types (e.g., some prepaid accounts) |
| Page errors during onboarding | These are usually Stripe-side issues. Refresh and try again. Console errors about CSP or source maps are harmless |

---

## Internal Notes (remove before publishing)

- Onboarding captured during test mode on 2026-02-18
- Test Stripe account: `pk_test_51SkSfYRu7i9fxxy0...`
- Test user: Guy Rymberg (`usr-guy_rymberg`)
- Screens may vary slightly based on Stripe updates and user's country
- Consider recording a screen capture video walking through this flow
