# LankaMarket

LankaMarket is a Sri Lankan classifieds marketplace project.

## Repository
https://github.com/dhanushkaprasad2001-max/lanka-market

## Current files
- `index.html` — responsive marketplace frontend prototype.
- `supabase/schema.sql` — database schema, security policies, image bucket and seed categories/districts.\n- `supabase/category_migration.sql` — expanded marketplace categories.\n- `supabase/vikma_buyer_seller_messaging.sql` — buyer/seller chat tables and access policies.
- `ADMIN_SETUP.md` — first-admin setup and secure configuration notes.

## Database setup
1. Open your Supabase project.
2. Go to SQL Editor and create a new query.
3. Open `supabase/schema.sql` in this repository, copy the entire file and paste it into SQL Editor.
4. Press Run. Check the results for errors.
5. Follow `ADMIN_SETUP.md` after creating your first website account.

## Important security notes
- Never publish a Supabase secret/service-role key in frontend code.
- Use only the Supabase Project URL and Publishable key (or legacy anon public key) in the browser.
- Row Level Security is enabled on the application tables.
- New user listings are forced to pending approval; only administrators can approve or reject them.
- The current frontend includes category/district search, price range filters, load-more browsing, Google/email authentication, ad posting, favorites, seller tools, moderation, reports and buyer/seller messaging.\n- Before public launch, complete end-to-end testing with separate buyer and seller accounts, verify email/password settings, configure backups and abuse controls, and test uploads on mobile.

## Enable GitHub Pages
Repository Settings → Pages → Deploy from a branch → `main` → `/(root)` → Save.
