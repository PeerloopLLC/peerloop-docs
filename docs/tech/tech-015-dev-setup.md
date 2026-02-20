# tech-015-dev-setup.md

Development environment setup and required external tools.

## Overview

This document tracks all external tools required for Peerloop development beyond npm packages. Use `scripts/check-env.sh` to verify your environment.

## Required Tools

| Tool | Required Version | Install Command | Purpose |
|------|------------------|-----------------|---------|
| Node.js | 22.19.0 (exact) | `nvm install 22.19.0` | Runtime |
| npm | >=10.0.0 | Bundled with Node | Package manager |
| Wrangler | >=4.0.0 | `npm install -g wrangler` | Cloudflare CLI |
| Stripe CLI | >=1.0.0 | `brew install stripe/stripe-cli/stripe` | Payment testing |

## Version Pinning Strategy

| Mechanism | File | Purpose |
|-----------|------|---------|
| `.nvmrc` | Node version | Auto-switch with nvm |
| `engines` | package.json | Warn on wrong Node/npm |
| `package-lock.json` | npm packages | Exact dependency versions |

## Installation

### Node.js (via nvm)

```bash
# Install nvm if not present
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Install and use correct Node version
nvm install
nvm use
```

### Wrangler (Cloudflare CLI)

```bash
# Global install (recommended for CLI usage)
npm install -g wrangler

# Or use project-local version
npx wrangler --version
```

### Stripe CLI

```bash
# macOS (Homebrew)
brew install stripe/stripe-cli/stripe

# Login to Stripe
stripe login

# Verify
stripe --version
```

## Machine-Specific Notes

See `docs/tech/tech-013-devcomputers.md` for machine capabilities.

| Machine | D1 Local | R2 Local | Notes |
|---------|----------|----------|-------|
| MacMiniM4-Pro (64GB) | Yes | Yes | Full functionality |
| MacMiniM4 (24GB) | Yes | Yes | Full functionality |

## Environment Variables

After installing tools, copy `.dev.vars.example` to `.dev.vars` and fill in your credentials.

See [tech-026-env-vars-secrets.md](tech-026-env-vars-secrets.md) for the complete environment variable reference.

## Environment Validation

Run the pre-flight check before starting development:

```bash
./scripts/check-env.sh
```

This validates:
- Node.js version matches `.nvmrc`
- npm version meets minimum
- Wrangler is installed
- Stripe CLI is installed and logged in

## Keeping Tools Updated

### Node.js
```bash
nvm install 22.19.0  # Update .nvmrc when changing
```

### Wrangler
```bash
npm update -g wrangler
# Or for project-local: npm update wrangler
```

### Stripe CLI
```bash
brew upgrade stripe/stripe-cli/stripe
```

## Troubleshooting

### Wrong Node Version
```bash
nvm use  # Reads from .nvmrc
```

### Wrangler Auth Issues
```bash
wrangler logout
wrangler login
```

### Stripe CLI Not Logged In
```bash
stripe login
# Opens browser for authentication
```

## References

- [nvm documentation](https://github.com/nvm-sh/nvm)
- [Wrangler documentation](https://developers.cloudflare.com/workers/wrangler/)
- [Stripe CLI documentation](https://stripe.com/docs/stripe-cli)
