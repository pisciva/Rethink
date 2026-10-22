import { cors, preflight } from '../../../src/http/cors.ts';
import { aiConfig } from '../../../src/infrastructure/gateway.ts';
export const dynamic = 'force-dynamic';
export function GET(request: Request) {
  const config = aiConfig();
  return cors(request, () => Response.json({ aiConfigured: config.configured && config.valid, provider: config.provider, authConfigured: Boolean(process.env.SUPABASE_URL && (process.env.SUPABASE_PUBLISHABLE_KEY || process.env.SUPABASE_ANON_KEY)), model: config.model }, { headers: { 'Cache-Control': 'no-store' } }));
}
export function OPTIONS(request: Request) { return preflight(request, 'GET'); }
