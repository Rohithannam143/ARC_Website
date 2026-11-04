# ARC — AI Knowledge Workspace

ARC is a local-first knowledge workspace with a React/Vite web client and an Express/Gemini API. The repository includes deployment configuration for Vercel (frontend), Render (API), and Supabase (database foundation).

## Current web features
- React 19 + TypeScript + Vite workspace
- Responsive notes UI with dark/light themes
- Create, edit, search, favorite and delete notes
- Browser-local autosave
- TipTap rich-editor foundation and 3D graph foundation
- Gemini note Q&A/summarization API (server-side key)
- API health endpoint, request validation, rate limiting and Helmet
- Supabase/PostgreSQL notes schema with row-level security (integration foundation)
- PWA manifest/service-worker app-shell cache

## Deploy

Follow [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for step-by-step Vercel + Render + Supabase setup.

- Vercel frontend: `npm run build`, output `dist`, set `VITE_API_URL` to the Render API origin.
- Render API: `npm install`, `npm run start:api`; set `GEMINI_API_KEY` and `CLIENT_ORIGIN` in Render's environment settings.
- Supabase: run `database/schema.sql` in the SQL Editor.

## Local development

```bash
npm install
cp .env.example .env
npm run api
# In another terminal:
npm run dev
```

## Honest implementation status

The web build is configured for deployment, but ARC is not yet a production-complete knowledge-management product. Notes currently persist in the browser's localStorage. Supabase schema/helpers exist, but authentication and UI-driven cloud sync are not wired. The graph is a visual foundation rather than a graph derived from backlinks. Import/export, revision history, robust offline conflict resolution, full mobile clients, and end-to-end tests remain future work.

## Security
- Never commit `.env`.
- Keep `GEMINI_API_KEY` and Supabase service-role keys on trusted servers only.
- Rotate any credential exposed in chat or source control.
