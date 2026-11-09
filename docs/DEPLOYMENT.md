# ARC production deployment (Vercel + Render + Supabase)

ARC keeps provider credentials on the API server. Never put AI keys in Vite variables or commit them.

## 1. Frontend on Vercel
- Import `Rohithannam143/ARC_Website`, choose Vite, root directory `./`.
- Build: `npm run build`; output: `dist`.
- Set `VITE_API_URL` to the public API service origin (no trailing slash).
- Set Supabase public URL/anon key only after enabling the cloud-sync UI.
- Deploy and note the exact Vercel origin.

## 2. API on Render
- Create a Web Service from this repository. Build with `npm install`; start with `npm run start:api`.
- Set `CLIENT_ORIGIN` to the exact Vercel origin.
- Set one AI provider:
  - Gemini: `AI_PROVIDER=gemini`, `GEMINI_API_KEY`, and optional `GEMINI_MODEL`.
  - Any OpenAI-compatible API: `AI_PROVIDER=openai-compatible`, `AI_BASE_URL`, `AI_API_KEY`, and `AI_MODEL`.
- For local Ollama on the same machine as the API, use `AI_BASE_URL=http://localhost:11434/v1`, an installed model name in `AI_MODEL`, and leave `AI_API_KEY` blank. A cloud-hosted Render API cannot reach Ollama running on your personal PC at localhost; use a securely hosted endpoint or run the API and Ollama on the same machine.
- Render provides `PORT`; do not hardcode it.

## 3. Free AI choices and limits
There is no legitimate hosted AI API key that is both free and unlimited. Free cloud services impose request/token quotas and can change them. Groq offers a free developer tier with published model-specific rate limits; Cloudflare Workers AI has a daily free allocation. Gemini also applies per-project RPM/TPM/RPD quotas. Check the provider's current dashboard before production use.
Example Groq settings: `AI_PROVIDER=openai-compatible`, `AI_BASE_URL=https://api.groq.com/openai/v1`, `AI_API_KEY=<your Groq key>`, and `AI_MODEL=openai/gpt-oss-20b` (confirm the model is enabled for your account). Create your own key at [Groq Console](https://console.groq.com/keys). Groq's free tier is rate-limited; model-specific quotas are published in its [rate-limit documentation](https://console.groq.com/docs/rate-limits).\n\nFor no per-request provider quota, run an open model locally with Ollama on hardware you control. This is limited by your device's RAM, CPU/GPU, speed and storage—not an unlimited hosted service. Do not expose an unauthenticated Ollama endpoint to the public internet.

## 4. Health check and troubleshooting
- Open `https://YOUR-API/api/health`. Check `ok`, `aiConfigured`, `aiProvider` and `aiModel`.
- 401/403: provider key missing, invalid or unauthorized.
- 429: provider quota/rate limit reached; wait or switch provider.
- 502 connection error: verify `AI_BASE_URL`, model name, provider availability and server logs.
- 504: upstream timed out; retry with a shorter note.
- If using Gemini, verify the API key belongs to the intended Google AI Studio project and inspect that project's active quotas.

## 5. Supabase status
The notes screen currently persists locally in the browser. SQL schema and helper functions exist, but the production sign-in and conflict-safe sync workflow are not yet wired. Do not treat cloud sync as enabled until it is implemented and tested.

## Security
- Keep `GEMINI_API_KEY` and `AI_API_KEY` only in the API host's secret environment.
- Rotate any key exposed in chat, logs or Git.
- Do not use a Supabase service-role key in a browser.
- The API applies a per-IP request limiter. Add authenticated user quotas and abuse monitoring before opening it publicly.
