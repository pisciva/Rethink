import { cors, preflight } from '../../../../src/http/cors.ts';
import { catalog } from '../../../../src/content/catalog.ts';
export const dynamic = 'force-dynamic';
export function GET(request: Request) { return cors(request, () => Response.json(catalog)); }
export function OPTIONS(request: Request) { return preflight(request, 'GET'); }
