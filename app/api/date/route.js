import { promisify } from 'util'
import { exec as execAsync } from 'child_process'
const exec = promisify(execAsync)

export const dynamic = 'force-dynamic'

export async function GET(request) {
    //const url = new URL(request.url)
    const message = {}
    const date = await exec('./app/scripts/date.sh');
    //message['stdout'] = stdout

    return Response.json(date)
}

export async function POST(request) {
    const res = await request.json()
    return Response.json(res)
}
