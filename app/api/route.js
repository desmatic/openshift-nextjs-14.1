export const dynamic = 'force-dynamic'

const data = { "message": "Hello world!" }

export async function GET(request) {
    return Response.json(data)
}

export async function POST(request) {
    const res = await request.json()
    return Response.json(data)
}
