---
name: Staging integration testing plan
description: Expand BBB-VERIFY into full staging integration test block covering Stream, Resend, Stripe, BBB — with plus-addressed email capture
type: project
---

User wants to expand DEV-WEBHOOKS.BBB-VERIFY (or replace it) into a broader staging integration testing block covering all external services: Stream.io, Resend (email), Stripe, and BBB.

**Why:** These services can only be verified end-to-end on staging — local dev uses mocks/CLI forwarding, but the real webhook delivery, API callbacks, and email sending paths are untested.

**Email capture strategy:** Use plus-addressing on `fgorrie@bio-software.com` to capture all outbound emails. Each test user gets a unique plus address (e.g., `fgorrie+sarah@bio-software.com`, `fgorrie+marcus@bio-software.com`). All emails land in one inbox, filterable by the plus tag. This avoids needing real recipient addresses while verifying the full Resend delivery path.

**How to apply:** When building the staging test plan, design around plus-addressed emails for all user accounts, and cover all four external services as a unified staging verification block.
