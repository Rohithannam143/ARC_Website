# ARC — AI Knowledge Workspace

ARC is a calm, local-first workspace for capturing thoughts and connecting ideas. The product is being developed as a responsive web app plus a Flutter mobile client.

## What is in this repository now
- React 19 + TypeScript + Vite web app
- Responsive notes workspace with dark/light themes
- Create, edit, search, favorite and delete notes
- Browser-local autosave
- Rich-text editor foundation (TipTap)
- Interactive 3D knowledge graph foundation (React Three Fiber)
- Gemini API endpoints for note Q&A and summarization; key stays on server
- Calculator API endpoint
- Supabase/PostgreSQL schema with row-level security and cloud-note helper functions
- PWA manifest and service-worker app-shell cache
- Flutter mobile starter with local note storage and theme switching
- GitHub Actions web build workflow

## Run the web app

```bash
npm install
cp .env.example .env
# Set GEMINI_API_KEY in the server environment for AI
npm run api
# In another terminal
npm run dev
```

Open http://localhost:5173.

## Mobile starter

```bash
cd apps/mobile
flutter pub get
flutter run
```

## Supabase setup
Run `database/schema.sql` in the Supabase SQL editor. Configure `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` for the web client. The helper functions are in `src/lib/cloudNotes.ts`. Authentication and sync UI must be wired before production cloud sync is considered enabled. See [docs/SETUP.md](docs/SETUP.md).

## Security
- Never commit `.env`.
- Never expose `GEMINI_API_KEY` or a Supabase service-role key in frontend/mobile code.
- Supabase anon keys are public client configuration and rely on correctly configured row-level security.

## Honest implementation status
ARC is an active MVP foundation, not yet a production-complete Obsidian replacement. The current web notes are stored locally in the browser. Supabase schema/helpers exist but end-user authentication and live sync are not yet connected to the UI. The Flutter client is a starter app, not a release-ready Android/iOS product. Remaining work includes robust sync/conflict resolution, auth screens, full graph relationships, backlinks/wiki-link parsing, import/export, revision history, automated unit/e2e tests, accessibility review, deployment configuration, and signed mobile releases.
