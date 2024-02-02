import { promisify } from 'util'
import { exec as execAsync } from 'child_process'
const exec = promisify(execAsync)

export const dynamic = 'force-dynamic'

export async function GET(request) {
    let date = {}
    try {
        date = await exec('./app/scripts/date.sh')
    } catch (e) {
        console.error(e)
    }

    return Response.json(date)
}

export async function POST(request) {
    const res = await request.json()
    return Response.json(res)
}
