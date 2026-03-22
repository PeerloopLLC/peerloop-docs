# Block 0: Foundation Features

**Block:** 0
**Focus:** Database schema, Authentication, Navigation shell
**Pages:** LGIN, SGUP, PWRS

---

## LGIN - Login

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-LGIN-001 | View login form | Display | Page load | Render form | Login form | US-G011 | GO-001 | - | MVP | 1 | 2025-12-25 |
| F-LGIN-002 | Submit email/password | Action | Click Login | POST /api/auth/login, set session | Login button | US-G011 | GO-001 | F-LGIN-001 | MVP | 4 | 2025-12-25 |
| F-LGIN-003 | Login with Google | Action | Click Google | OAuth redirect | Google button | US-G012 | GO-001 | F-LGIN-001 | MVP | 4 | 2025-12-25 |
| F-LGIN-004 | Login with GitHub | Action | Click GitHub | OAuth redirect | GitHub button | US-G012 | GO-001 | F-LGIN-001 | MVP | 3 | 2025-12-25 |
| F-LGIN-005 | Show validation errors | Display | Invalid input | Display error messages | Error text | US-G011 | - | F-LGIN-002 | MVP | 1 | 2025-12-25 |
| F-LGIN-006 | Click forgot password | Action | Click link | Navigate to PWRS | Link | US-G013 | GO-001 | - | MVP | 0.5 | 2025-12-25 |
| F-LGIN-007 | Click sign up | Action | Click link | Navigate to SGUP | Link | US-G011 | GO-001 | - | MVP | 0.5 | 2025-12-25 |
| F-LGIN-008 | Redirect after login | Action | Successful login | Redirect to dashboard or intended page | - | US-G012 | GO-001 | F-LGIN-002 | MVP | 1 | 2025-12-25 |

---

## SGUP - Sign Up

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-SGUP-001 | View signup form | Display | Page load | Render form | Signup form | US-G013 | GO-001 | - | MVP | 1 | 2025-12-25 |
| F-SGUP-002 | Submit registration | Action | Click Sign Up | POST /api/auth/register | Sign up button | US-G013 | GO-001 | F-SGUP-001 | MVP | 4 | 2025-12-25 |
| F-SGUP-003 | Signup with Google | Action | Click Google | OAuth redirect + create user | Google button | US-G013 | GO-001 | F-SGUP-001 | MVP | 2 | 2025-12-25 |
| F-SGUP-004 | Signup with GitHub | Action | Click GitHub | OAuth redirect + create user | GitHub button | US-G013 | GO-001 | F-SGUP-001 | MVP | 2 | 2025-12-25 |
| F-SGUP-005 | Email verification sent | Display | After submit | Show "check email" message | Confirmation message | US-P008 | GO-001 | F-SGUP-002 | MVP | 2 | 2025-12-25 |
| F-SGUP-006 | Validate email format | Action | Type email | Client-side validation | Email input | US-G013 | - | F-SGUP-001 | MVP | 0.5 | 2025-12-25 |
| F-SGUP-007 | Validate password strength | Action | Type password | Show strength indicator | Password input | US-G013 | - | F-SGUP-001 | MVP | 1 | 2025-12-25 |
| F-SGUP-008 | Click login link | Action | Click link | Navigate to LGIN | Link | US-G012 | GO-001 | - | MVP | 0.5 | 2025-12-25 |

---

## PWRS - Password Reset

| ID | Feature | Type | User Action | Developer Action | UI Element | Stories | Goals | Depends On | Status | Hours | Updated |
|----|---------|------|-------------|------------------|------------|---------|-------|------------|--------|-------|---------|
| F-PWRS-001 | View reset request form | Display | Page load | Render email input | Reset form | US-P009 | GO-001 | - | MVP | 1 | 2025-12-25 |
| F-PWRS-002 | Submit reset request | Action | Click Submit | POST /api/auth/reset-request | Submit button | US-P009 | GO-001 | F-PWRS-001 | MVP | 2 | 2025-12-25 |
| F-PWRS-003 | Show confirmation | Display | After submit | Show "check email" message | Confirmation | US-P009 | GO-001 | F-PWRS-002 | MVP | 0.5 | 2025-12-25 |
| F-PWRS-004 | View new password form | Display | Click email link | Render password inputs | New password form | US-P010 | GO-001 | F-PWRS-002 | MVP | 1 | 2025-12-25 |
| F-PWRS-005 | Submit new password | Action | Click Submit | POST /api/auth/reset-password | Submit button | US-P010 | GO-001 | F-PWRS-004 | MVP | 2 | 2025-12-25 |
| F-PWRS-006 | Redirect to login | Action | Password reset | Navigate to LGIN with success | - | US-P010 | GO-001 | F-PWRS-005 | MVP | 0.5 | 2025-12-25 |

---

## Block 0 Summary

| Page | Features | Hours |
|------|----------|-------|
| LGIN | 8 | 15 |
| SGUP | 8 | 13 |
| PWRS | 6 | 7 |
| **Total** | **22** | **35** |
