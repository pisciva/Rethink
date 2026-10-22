import { cors, preflight } from '../../../../lib/cors.ts';
import { catalog } from '../../../../lib/v2/content.ts';

export const dynamic = 'force-dynamic';
export function GET(request: Request) { return cors(request, () => Response.json(catalog)); }
export function OPTIONS(request: Request) { return preflight(request, 'GET'); }
