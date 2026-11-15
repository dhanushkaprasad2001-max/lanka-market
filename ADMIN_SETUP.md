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

## Free listings and advertising

Every member may post eligible advertisements for free. VIKMA does not sell featured placements, paid boosts, business promotions or homepage banners. Do not activate payment or monetization-request workflows. The only planned revenue source is Google AdSense, subject to Google's approval and policies.


## Before public launch

- Test registration, Google login, sign-out and session restore.
- Test one buyer and one seller account separately; verify that chat messages remain private to the conversation participants.
- Test listing creation, image upload, admin approval, edits, sold status and deletion.
- Configure phone SMS provider and test OTP delivery if phone verification is required.
- Enable leaked-password protection in Supabase Auth security settings.
- Set up backups, abuse reporting, rate limits and a privacy policy/contact process.



## AdSense and user listings

VIKMA contains user-generated listings. Google states that the publisher is responsible for policy compliance of all user-generated content on pages where ad code appears. Keep listing moderation active, provide a way to report listings, review reported content promptly, and do not place AdSense code on unmoderated or private-message pages. Apply for VIKMA as a separate site in the AdSense account; approval for another website does not automatically approve this domain. See [Google's user-generated content guidance](https://support.google.com/adsense/answer/1355699) and [AdSense program policies](https://support.google.com/adsense/answer/48182).
