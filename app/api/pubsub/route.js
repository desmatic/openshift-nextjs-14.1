export const dynamic = 'force-dynamic'

export async function GET(request) {
    const url = new URL(request.url)
    const echo = {}
    for (const key in url) {
        if (typeof url[key] === 'string')
            echo[key] = url[key]
    }
    console.log(JSON.stringify(echo))
    return Response.json(echo)
}


export async function POST(request) {
    const { message } = await request.json()
    const data = JSON.parse(atob(message.data))

    console.log(json.stringify(data))
    return Response.json(message)
}
