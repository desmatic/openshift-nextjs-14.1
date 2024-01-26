export const dynamic = 'force-dynamic'

export async function GET(request) {
    const url = new URL(request.url)
    const echo = {}
    for (const key in url) {
        if (typeof url[key] === 'string')
            echo[key] = url[key]
    }
    return Response.json(echo)
}

export async function POST(request) {
    const res = await request.json()
    return Response.json(res)
}
