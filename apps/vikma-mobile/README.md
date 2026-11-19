# VIKMA Mobile

This folder is an isolated app copy of the VIKMA marketplace frontend. It uses the existing Supabase project and tables; it does not modify the production website files.

## PWA deployment

Create a separate Cloudflare Pages project from this repository and select branch `vikma-mobile-app`. Set the project root/output directory to `apps/vikma-mobile/www` and leave the build command empty. The intended app origin is `https://vikma-mobile.pages.dev`.

Before enabling email confirmation and Google OAuth on this separate origin, add `https://vikma-mobile.pages.dev/` to the Supabase Auth URL Configuration redirect allow list and ensure the Google OAuth provider allows the callback flow. The existing website keeps its own redirect URL.

## Android APK

The GitHub Actions workflow builds a debug APK and uploads it as an artifact. Open Actions → Build VIKMA Android APK → latest successful run → Artifacts. A debug APK is for direct testing; a signed release APK/AAB requires a private signing keystore and protected GitHub secrets.

## Important

The PWA and Android app use the existing VIKMA Supabase project URL and publishable key from the frontend copy. No service-role key is included. The app has its own noindex frontend copy so it does not compete with the production website in search results.
