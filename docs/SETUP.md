# ARC setup guide

## Web
1. Install Node.js 20.19+ or 22.12+.
2. Run `npm install`.
3. Copy `.env.example` to `.env`.
4. Put your Gemini key in `GEMINI_API_KEY` on the API server only.
5. Run `npm run api` and `npm run dev` in separate terminals.

## Optional Supabase persistence
1. Create a Supabase project.
2. Run `database/schema.sql` in its SQL editor.
3. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in the web environment.
4. Enable the authentication provider you want in Supabase.
5. The cloud data helpers are in `src/lib/cloudNotes.ts`; wire authentication and sync UI before enabling production sync. Row-level security restricts note access to the authenticated owner.

## Deployment
Deploy the Vite web app to a static host and the Express API to a Node host. Configure the same origin or set `CLIENT_ORIGIN` to the exact deployed web origin. Add Gemini credentials only to the API host's secret store. Configure Supabase URL/anon key as public frontend configuration. Do not use the Supabase service-role key in a browser or mobile app.

## Mobile
The Flutter scaffold lives in `apps/mobile`. Run `flutter pub get` then `flutter run` from that directory. Cloud login/sync and platform release signing remain to be implemented.
