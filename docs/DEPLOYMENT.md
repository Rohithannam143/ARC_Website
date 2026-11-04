# ARC production deployment (Vercel + Render + Supabase)

This repository is prepared for a split deployment:
- **Vercel** serves the Vite frontend from `dist`.
- **Render** runs the Express API from `server/index.ts`.
- **Supabase** provides the PostgreSQL schema and future authentication/cloud storage.

> Important: the current notes UI still saves to browser localStorage. Supabase helpers/schema are present, but sign-in and UI-driven cloud sync have not been implemented. Deploying Supabase does not automatically turn on cross-device sync.

## 1. Push and deploy the frontend on Vercel

1. Sign in to Vercel and import `Rohithannam143/ARC_Website`.
2. Select the `main` branch. Framework preset: **Vite**. Root directory: `./`.
3. Build command: `npm run build`; output directory: `dist`; install command: `npm install`.
4. Add environment variable `VITE_API_URL` with the public Render API origin, for example `https://arc-api.onrender.com` (no trailing slash).
5. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` only if using the Supabase client. These are public client settings; never use a service-role key in Vercel frontend variables.
6. Deploy. Copy the resulting Vercel origin, e.g. `https://arc-website.vercel.app`.

The included `vercel.json` configures SPA fallback routing.

## 2. Deploy the API on Render

1. Create a **New Web Service** and connect the same GitHub repository.
2. Use the repository root. The included `render.yaml` sets Node 22, build command, start command, and health check.
3. Set the following environment variables in Render:
   - `GEMINI_API_KEY`: a newly generated Gemini key (keep it secret; never commit it).
   - `GEMINI_MODEL`: `gemini-2.5-flash` unless you choose another supported model.
   - `CLIENT_ORIGIN`: exact Vercel production origin, e.g. `https://arc-website.vercel.app`. For Vercel preview domains, add each permitted origin comma-separated if you intend to allow them.
   - `PORT`: Render supplies this automatically; leave it unset unless required.
4. Deploy and wait for the service to become healthy.
5. Verify `https://YOUR-RENDER-SERVICE.onrender.com/api/health`. Expected JSON includes `ok: true` and `aiConfigured: true` once the key is configured.

After first deployment, if the Vercel URL changes, update Render's `CLIENT_ORIGIN` and redeploy/restart the API.

## 3. Connect the frontend to the API

In Vercel project settings, set `VITE_API_URL` to the Render service origin (no trailing slash), then redeploy the frontend. The app uses the Vite proxy automatically in local development when this variable is blank.

## 4. Prepare Supabase

1. Create a Supabase project.
2. Run `database/schema.sql` in the Supabase SQL Editor.
3. Configure Auth providers and redirect URLs if/when the app's authentication UI is implemented.
4. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in Vercel only when the frontend integration is ready.
5. Keep the Supabase service-role key private; it is not needed by the current browser-only notes implementation.

**Current limitation:** the schema and `src/lib/cloudNotes.ts` helper are foundations only. Do not advertise cloud sync as available until authentication, sync UI, and conflict handling are implemented and tested.

## 5. Post-deployment smoke tests

- Open the Vercel URL over HTTPS.
- Open `/api/health` on the Render URL; confirm `ok: true`.
- In the ARC UI, ask the AI assistant a simple question; confirm a response and inspect browser console/network for CORS errors.
- Create/edit/delete a note, refresh, and confirm local browser persistence.
- Test a second browser/device to confirm the known limitation: notes do not sync between devices yet.
- Check Render logs for Gemini errors and verify no secrets are printed.

## Security and operational notes

- Rotate any API key that has been pasted into chat, source control, or another public location. Use a fresh key in Render's secret environment variables.
- Never commit `.env`, Gemini API keys, or Supabase service-role keys.
- CORS must contain the exact Vercel origin. Avoid wildcard origins for production.
- The API has Helmet headers, JSON size limits, request validation, and a basic AI rate limit. Add stronger abuse protection/monitoring before broad public launch.
- Render free instances may sleep when idle; the first request after inactivity can be slow.
- A successful Vite build is not a full production QA or security audit.
