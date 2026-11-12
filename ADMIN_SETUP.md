# VIKMA admin setup

## First administrator

The database is already connected to the VIKMA website and the expanded category migration has been applied.

1. Create your own account through the VIKMA website using the email address you want to use as the owner/admin.
2. After signup, run the following in the Supabase SQL Editor, replacing the email with the exact signup email:

```sql
update public.profiles
set role = 'admin'
where id = (
  select id from auth.users
  where lower(email) = lower('YOUR_LOGIN_EMAIL')
);
```

3. Confirm that one row was updated. Sign out and sign back in to refresh the admin role.

Do not make ordinary users administrators. Never put the Supabase service-role key in website JavaScript or GitHub.

## Supabase browser configuration

The browser app uses the project's URL and publishable key. Publishable keys are intended for browser use. Never use a secret key or service_role key in frontend code.

## Current database

- 10 main marketplace categories
- 117 second-level categories
- 83 third-level categories (210 active categories total)
- All 25 Sri Lankan districts
- Profiles, listings, listing images, favorites and listing reports
- Row Level Security enabled on all marketplace tables
- Public listing-images storage bucket
- Additional indexes for category, district, image, favorite and report lookups
- Internal trigger-function execution grants tightened

## Current website features

The frontend includes sign-in/sign-up, ad creation with up to five images, category and district browsing, listing detail views, favorites, seller tools (edit title/price, mark approved ads sold, delete ads), an administrator ad-review queue, and a report-review queue.

The first administrator still needs to be promoted after creating an account. Test with a second ordinary account before public launch. This project is still under development and needs end-to-end testing before it should be treated as a production-ready marketplace.
