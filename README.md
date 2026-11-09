# ARC — AI Knowledge Workspace

ARC is a local-first knowledge workspace with a React/Vite web client, TipTap editor and Express AI API.

## Current capabilities
- Responsive React 19 + TypeScript + Vite workspace
- Dark/light themes, search, favorites and local autosave
- TipTap rich-text editing foundation
- 3D knowledge-map visualization foundation
- AI note Q&A and summarization through Gemini or an OpenAI-compatible API
- Server-side provider credentials, request validation, rate limiting and health diagnostics
- Supabase/PostgreSQL schema with row-level security (cloud authentication and sync UI are not yet complete)
- PWA manifest and service-worker app-shell cache

## AI provider setup
See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md). Provider keys belong only on the API server, never in `VITE_*` variables.

- Gemini: `AI_PROVIDER=gemini` + `GEMINI_API_KEY`.
- OpenAI-compatible: `AI_PROVIDER=openai-compatible` + `AI_BASE_URL`, optional `AI_API_KEY`, and `AI_MODEL`.
- Local Ollama: run Ollama on the same machine as the API and use `http://localhost:11434/v1`.

No hosted free API offers guaranteed unlimited usage. Local inference avoids per-request cloud charges but is bounded by your hardware.

## Development
```bash
npm install
cp .env.example .env
npm run api
# in another terminal
npm run dev
```

## Honest implementation status
Notes currently persist in browser localStorage. Supabase schema/helpers are foundations; authentication and UI-driven cloud sync are not yet wired. The graph is a visual foundation rather than a backlink-derived graph. Import/export, revision history, robust offline conflict resolution, full mobile clients and end-to-end tests remain unfinished.

## Security
- Never commit `.env` or provider credentials.
- Rotate keys exposed in chat or source control.
- Do not expose a local Ollama server publicly without authentication and network controls.
