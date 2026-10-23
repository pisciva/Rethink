export function GET() {
  return Response.json({ service: 'Rethink Recovery API', client: 'Swift', endpoints: ['/api/health', '/api/v2/catalog', '/api/v2/progress'] }, { headers: { 'Cache-Control': 'no-store' } });
}
