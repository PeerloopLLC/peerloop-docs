# tech-004: Resend

**Type:** Transactional Email Service
**Status:** ✅ SELECTED (2025-12-26)
**Research Date:** 2025-12-26
**Source:** https://resend.com

---

## Overview

Resend is a developer-focused email API for sending transactional emails. It's built by the same team as React Email, enabling seamless integration with React-based email templates.

## PeerLoop Email Use Cases

| Email Type | Trigger | Priority |
|------------|---------|----------|
| Email verification | User registration | P0 |
| Password reset | User request | P0 |
| Session booking confirmation | Enrollment + scheduling | P0 |
| Session reminder | 24h and 1h before | P0 |
| Session completed | After session ends | P1 |
| Course completion certificate | Teacher recommendation approved | P1 |
| Payout notification | Transfer to bank | P1 |
| Welcome email | First login | P2 |

---

## Pricing

| Tier | Emails/Month | Price | PeerLoop Fit |
|------|--------------|-------|--------------|
| **Free** | 3,000 | $0 | ✅ Genesis Cohort |
| Pro | 50,000 | $20/mo | Growth phase |
| Scale | 100,000+ | Custom | Scale phase |

**Genesis Cohort estimate:** ~60-80 students × ~10 emails/month = 600-800 emails. Free tier is sufficient.

---

## API Reference

### SDK Setup

**Package:** `resend`

```typescript
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);
```

### Send Email

**Endpoint:** `POST https://api.resend.com/emails`

```typescript
const { data, error } = await resend.emails.send({
  from: 'PeerLoop <noreply@send.peerloop.com>',
  to: 'noreply@send.peerloop.com',
  subject: 'Welcome to PeerLoop!',
  html: '<p>Your account is ready.</p>',
  // OR use React Email:
  react: <WelcomeEmail name="John" />,
});

if (error) {
  console.error('Email failed:', error);
  return;
}

console.log('Email sent:', data.id);
```

### Send Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `from` | string | Yes | Sender: `Name <email@domain>` |
| `to` | string \| string[] | Yes | Recipients (max 50) |
| `subject` | string | Yes | Subject line |
| `html` | string | No* | HTML body |
| `text` | string | No | Plain text (auto-generated if omitted) |
| `react` | ReactNode | No* | React Email component |
| `replyTo` | string | No | Reply-to address |
| `cc` | string \| string[] | No | CC recipients |
| `bcc` | string \| string[] | No | BCC recipients |
| `attachments` | array | No | Files (max 40MB total) |
| `tags` | array | No | Metadata key/value pairs |
| `headers` | object | No | Custom email headers |

*Either `html` or `react` is required.

### Batch Emails

Send up to 100 emails in one request:

```typescript
const { data, error } = await resend.batch.send([
  {
    from: 'PeerLoop <noreply@send.peerloop.com>',
    to: 'noreply@send.peerloop.com',
    subject: 'Session Reminder',
    react: <SessionReminderEmail sessionId="123" />,
  },
  {
    from: 'PeerLoop <noreply@send.peerloop.com>',
    to: 'noreply@send.peerloop.com',
    subject: 'Session Reminder',
    react: <SessionReminderEmail sessionId="124" />,
  },
]);
```

**Note:** Batch doesn't support attachments or scheduled sending.

### Schedule Email

```typescript
const { data, error } = await resend.emails.send({
  from: 'PeerLoop <noreply@send.peerloop.com>',
  to: 'noreply@send.peerloop.com',
  subject: 'Your session starts in 1 hour',
  react: <SessionReminderEmail />,
  scheduled_at: '2025-12-27T10:00:00Z', // ISO 8601
});
```

---

## React Email Integration

Resend + React Email are built by the same team. No HTML conversion needed—pass React components directly.

### Setup

```bash
npm install resend @react-email/components
```

### Create Template

```tsx
// emails/verification-email.tsx
import {
  Html,
  Head,
  Body,
  Container,
  Heading,
  Text,
  Button,
  Link,
} from '@react-email/components';

interface VerificationEmailProps {
  name: string;
  verificationUrl: string;
}

export function VerificationEmail({ name, verificationUrl }: VerificationEmailProps) {
  return (
    <Html lang="en">
      <Head />
      <Body style={{ fontFamily: 'sans-serif', padding: '20px' }}>
        <Container>
          <Heading>Verify your email</Heading>
          <Text>Hi {name},</Text>
          <Text>Click the button below to verify your email address:</Text>
          <Button
            href={verificationUrl}
            style={{
              backgroundColor: '#4F46E5',
              color: '#fff',
              padding: '12px 24px',
              borderRadius: '6px',
            }}
          >
            Verify Email
          </Button>
          <Text>
            Or copy this link: <Link href={verificationUrl}>{verificationUrl}</Link>
          </Text>
        </Container>
      </Body>
    </Html>
  );
}
```

### Send Template

```typescript
import { Resend } from 'resend';
import { VerificationEmail } from './emails/verification-email';

const resend = new Resend(process.env.RESEND_API_KEY);

await resend.emails.send({
  from: 'PeerLoop <noreply@send.peerloop.com>',
  to: user.email,
  subject: 'Verify your PeerLoop account',
  react: <VerificationEmail
    name={user.name}
    verificationUrl={`https://peerloop.com/verify?token=${token}`}
  />,
});
```

### Available Components (54 total)

| Component | Purpose |
|-----------|---------|
| `Html` | Root wrapper |
| `Head` | Document head |
| `Body` | Email body |
| `Container` | Centered content wrapper |
| `Section` | Content section |
| `Row` / `Column` | Layout grid |
| `Heading` | h1-h6 headings |
| `Text` | Paragraphs |
| `Link` | Hyperlinks |
| `Button` | CTA buttons |
| `Img` | Images |
| `Hr` | Horizontal rule |
| `Preview` | Preview text (inbox snippet) |
| `CodeBlock` | Syntax-highlighted code |

---

## Domain Setup

### Verified Sending Domain

**Domain:** `send.peerloop.com` (verified in Resend dashboard)
**From address:** `Peerloop <noreply@send.peerloop.com>`

Resend verifies a sending subdomain, not the root domain. This isolates email reputation from the main domain's DNS.

### Required DNS Records

| Type | Name | Value | Purpose |
|------|------|-------|---------|
| TXT | `_resend` | Provided by Resend | Domain verification |
| TXT | @ or subdomain | `v=spf1 include:amazonses.com ~all` | SPF |
| CNAME | `resend._domainkey` | Provided by Resend | DKIM |

### Verification Process

1. Add domain in Resend dashboard
2. Add DNS records to Cloudflare
3. Click "Verify DNS Records" in Resend
4. Status changes: `pending` → `verified` (usually < 1 hour)

### Caveat: Unverified Domain Errors

If the `from` address uses an unverified domain (e.g., `noreply@peerloop.com` instead of `noreply@send.peerloop.com`), Resend returns a **misleading** 422 error:

```
Invalid `from` field. The email address needs to follow the
`email@example.com` or `Name <email@example.com>` format.
```

This looks like a format problem but is actually a domain verification issue. The fix is to use the verified subdomain (`send.peerloop.com`).

For development without a verified domain, use Resend's sandbox sender: `Peerloop <onboarding@resend.dev>`.

---

## Webhooks

### Setup

1. Create endpoint: `POST /api/webhooks/resend`
2. Register URL in Resend dashboard
3. Handle events and return 200 OK

### Event Types

| Event | Trigger | Use Case |
|-------|---------|----------|
| `email.sent` | API request succeeded | Log sent |
| `email.delivered` | Delivered to mail server | Confirm delivery |
| `email.bounced` | Permanently rejected | Mark email invalid |
| `email.complained` | Marked as spam | Unsubscribe user |
| `email.opened` | Recipient opened | Analytics |
| `email.clicked` | Link clicked | Analytics |
| `email.delivery_delayed` | Temporary issue | Monitor |
| `email.failed` | Send failed | Alert/retry |

### Webhook Payload

```json
{
  "type": "email.delivered",
  "created_at": "2025-12-26T10:00:00.000Z",
  "data": {
    "email_id": "49a3999c-0ce1-4ea6-ab68-afcd6dc2e794",
    "from": "noreply@send.peerloop.com",
    "to": ["noreply@send.peerloop.com"],
    "subject": "Welcome to PeerLoop",
    "tags": [
      { "name": "type", "value": "verification" }
    ]
  }
}
```

### Webhook Handler

```typescript
// POST /api/webhooks/resend
export async function POST(request: Request) {
  const payload = await request.json();

  switch (payload.type) {
    case 'email.bounced':
      // Mark email as invalid in DB
      await db.users.update({
        where: { email: payload.data.to[0] },
        data: { emailStatus: 'bounced' }
      });
      break;

    case 'email.complained':
      // Unsubscribe user from marketing
      await db.users.update({
        where: { email: payload.data.to[0] },
        data: { marketingOptOut: true }
      });
      break;

    case 'email.failed':
      // Log for investigation
      console.error('Email failed:', payload.data);
      break;
  }

  return Response.json({ received: true }, { status: 200 });
}
```

### Retry Schedule

If webhook delivery fails, Resend retries at:
- 5 seconds
- 5 minutes
- 30 minutes
- 2 hours
- 5 hours
- 10 hours

---

## PeerLoop Email Templates

### Block 0 Templates (Auth)

| Template | Subject | Variables |
|----------|---------|-----------|
| `VerificationEmail` | Verify your PeerLoop account | name, verificationUrl |
| `PasswordResetEmail` | Reset your password | name, resetUrl, expiresIn |
| `WelcomeEmail` | Welcome to PeerLoop! | name |

### Block 2 Templates (Sessions)

| Template | Subject | Variables |
|----------|---------|-----------|
| `BookingConfirmationEmail` | Session booked | studentName, courseName, instructorName, dateTime |
| `SessionReminderEmail` | Session in {time} | studentName, courseName, instructorName, dateTime, joinUrl |
| `SessionCompletedEmail` | Session completed | studentName, courseName, recordingUrl |

### Block 2 Templates (Payments)

| Template | Subject | Variables |
|----------|---------|-----------|
| `PaymentReceiptEmail` | Payment confirmed | studentName, courseName, amount, receiptUrl |
| `PayoutNotificationEmail` | Payout sent | recipientName, amount, bankLast4 |

---

## Cloudflare Workers Compatibility

Resend works with Cloudflare Workers. Example:

```typescript
// worker.ts
import { Resend } from 'resend';

export default {
  async fetch(request: Request, env: Env) {
    const resend = new Resend(env.RESEND_API_KEY);

    const { data, error } = await resend.emails.send({
      from: 'PeerLoop <noreply@send.peerloop.com>',
      to: 'noreply@send.peerloop.com',
      subject: 'Test from Workers',
      html: '<p>Hello from Cloudflare Workers!</p>',
    });

    if (error) {
      return Response.json({ error }, { status: 500 });
    }

    return Response.json({ id: data.id });
  },
};
```

**Note:** React Email rendering works in Workers but ensure you're using the latest SDK versions.

---

## Best Practices

1. **Use tags** for analytics and filtering:
   ```typescript
   tags: [
     { name: 'type', value: 'verification' },
     { name: 'user_id', value: userId },
   ]
   ```

2. **Handle errors gracefully** - Don't block user actions on email failures

3. **Provide plain text** - Some clients block HTML

4. **Use preview text** - Shows in inbox before opening:
   ```tsx
   <Preview>Verify your email to get started with PeerLoop</Preview>
   ```

5. **Test with Resend's test mode** before production

---

## Environment Variables

See [tech-026-env-vars-secrets.md](tech-026-env-vars-secrets.md) for the full environment variable reference and deployment workflow.

| Variable | Secret? | Where it lives | Purpose |
|----------|:-------:|----------------|---------|
| `RESEND_API_KEY` | **Yes** | `.dev.vars` / `.secrets.cloudflare.*` | Server-side SDK initialization (`re_` prefix) |

Resend has no client-side/publishable key — all API access is server-only.

**From address:** Hardcoded in `src/lib/email.ts` as `Peerloop <noreply@send.peerloop.com>`. All email sending goes through the centralized `sendEmail()` function in that file.

**Dev vs Production:** Use separate API keys created in the [Resend Dashboard](https://resend.com/api-keys). The dev key can use Resend's test mode or a development domain to avoid sending real emails during development.

---

## References

### Official Documentation
- [Resend Documentation](https://resend.com/docs)
- [Resend Introduction](https://resend.com/docs/introduction)
- [Send with Node.js](https://resend.com/docs/send-with-nodejs)

### API Reference
- [Send Email API](https://resend.com/docs/api-reference/emails/send-email)
- [Send Batch Emails API](https://resend.com/docs/api-reference/emails/send-batch-emails)

### Webhooks
- [Webhooks Introduction](https://resend.com/docs/dashboard/webhooks/introduction)
- [Webhook Event Types](https://resend.com/docs/dashboard/webhooks/event-types)

### Domain Setup
- [Domains Introduction](https://resend.com/docs/dashboard/domains/introduction)
- [Email Quota Limits](https://resend.com/docs/knowledge-base/resend-email-quota)

### React Email
- [React Email Documentation](https://react.email/docs)
- [React Email + Resend Integration](https://react.email/docs/integrations/resend)
- [React Email GitHub](https://github.com/resend/react-email)
- [React Email 2.0 Announcement](https://resend.com/blog/react-email-2)
- [React Email 3.0 Announcement](https://resend.com/blog/react-email-3)

### Pricing & Plans
- [Resend Pricing](https://resend.com/pricing)
- [New Free Tier Announcement](https://resend.com/blog/new-free-tier)

### Tutorials
- [Send emails with Cloudflare Workers](https://developers.cloudflare.com/workers/tutorials/send-emails-with-resend/)
- [Create and Send Email Templates (freeCodeCamp)](https://www.freecodecamp.org/news/create-and-send-email-templates-using-react-email-and-resend-in-nextjs/)
