# VIKMA admin setup

Run the main database script first: `supabase/schema.sql`.

## Make your own account the first administrator

1. Sign up for VIKMA once after the frontend is connected to Supabase.
2. In Supabase, open SQL Editor and run this statement, replacing the email with the exact email used for your signup:

```sql
update public.profiles
set role = 'admin'
where id = (
  select id from auth.users
  where lower(email) = lower('YOUR_LOGIN_EMAIL')
);
```

3. Confirm that exactly one row was updated. If zero rows were updated, first create the account in the website and verify the email if email confirmation is enabled.
4. Sign out and sign in again so the website refreshes the account role.

Do not make ordinary users administrators. Never put the Supabase service-role key in website JavaScript or GitHub.

## Supabase browser configuration

The browser app needs:
- Project URL (shown on the Supabase project page)
- Publishable key / legacy anon public key (Project Settings > API Keys)

These are public client values and can be placed in the frontend configuration. Never use the secret key or service_role key in a browser app.

## Current implementation status

The SQL schema creates profiles, 10 main marketplace categories with 98 subcategories, all 25 Sri Lankan districts, listings, listing images, favorites, reports, Row Level Security policies and the public listing-images storage bucket.

The frontend still needs to be wired to the project's URL and publishable key before multi-user sign-in, cloud listing creation and image uploads become live. Test with a second ordinary account before public launch.
