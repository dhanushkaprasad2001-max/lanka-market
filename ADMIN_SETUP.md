# VIKMA admin setup

## First administrator

The connected owner account has already been promoted to `admin`. The role is stored in `public.profiles`; do not promote ordinary users. If ownership needs to be transferred, verify the exact account first and run an explicit update in the Supabase SQL Editor.

## Supabase browser configuration

The browser app uses the project's URL and publishable key. Publishable keys are intended for browser use. Never use a secret key or service_role key in frontend code.

## Current database

- 10 main marketplace categories
- 117 second-level categories
- 83 third-level categories (210 active categories total)
- All 25 Sri Lankan districts
- Profiles, listings, listing images, favorites, listing reports, conversations and messages
- Row Level Security enabled on all marketplace tables
- Public listing-images storage bucket
- Additional indexes for category, district, image, favorite and report lookups
- Internal trigger-function execution grants tightened

## Current website features

The frontend includes Google/email sign-in, ad creation with up to five images, category and district browsing, price range filters, load-more results, listing details, favorites, buyer/seller messaging, seller tools (edit title/price, mark approved ads sold, delete ads), an administrator ad-review queue, and a report-review queue.

The connected owner account is already an administrator. Test with a second ordinary account before public launch. This project is still under development and needs end-to-end testing before it should be treated as a production-ready marketplace.


## Phone OTP setup

The profile page now contains a phone-verification flow. It will not send SMS until a provider is configured.

1. Create and verify an SMS provider account (for example, Twilio).
2. In Supabase Dashboard, open Authentication → Sign In / Providers → Phone.
3. Enable Phone and configure the provider with its credentials inside Supabase. Never put SMS provider secrets in `index.html` or send them in chat.
4. Save the provider settings, then test with your own number before enabling public use.
5. Keep OTP rate limits enabled and configure CAPTCHA to reduce abuse.

Supabase phone OTP requires an SMS provider and may incur charges. See [Supabase Phone Sign-In](https://supabase.com/docs/guides/auth/phone-login).

## Payments and featured ads

Featured-ad payment processing is not activated. To enable it safely, the owner must first open a merchant account with a Sri Lankan payment provider such as PayHere and obtain the merchant credentials. The secret credentials must be stored as Supabase Edge Function secrets, never in the public website. After merchant onboarding, implement and test server-side payment creation and signature-verified webhooks before accepting payments.

## Before public launch

- Test registration, Google login, sign-out and session restore.
- Test one buyer and one seller account separately; verify that chat messages remain private to the conversation participants.
- Test listing creation, image upload, admin approval, edits, sold status and deletion.
- Configure phone SMS provider and test OTP delivery if phone verification is required.
- Configure a payment provider before enabling any paid listing promotion.
- Enable leaked-password protection in Supabase Auth security settings.
- Set up backups, abuse reporting, rate limits and a privacy policy/contact process.
