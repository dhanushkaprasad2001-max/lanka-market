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

The first administrator still needs to be promoted after creating an account. Test with a second ordinary account before public launch. This project is still under development and needs end-to-end testing before it should be treated as a production-ready marketplace.
