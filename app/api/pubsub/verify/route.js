import { Storage } from '@google-cloud/storage'
import { promisify } from 'util'
import { exec as execAsync } from 'child_process'

const exec = promisify(execAsync)
export const dynamic = 'force-dynamic'

async function downloadFile(bucket, filename, infile) {
    const storage = new Storage()
    console.log(infile)
    const options = { destination: infile }
    await storage.bucket(bucket).file(filename).download(options)
}

async function uploadFile(bucket, filename, outfile) {
    const storage = new Storage()
    const options = { destination: filename.replace('/inbound/', '/outbound/').replace(/(\.gz|\.z)$/i, '') }
    console.log(outfile)
    console.log(options)
    await storage.bucket(bucket).upload(outfile, options)
}

async function convertFile(scriptname, infile, outfile) {
    const cmd = `./app/scripts/${scriptname} ${infile} ${outfile}`
    console.log(cmd)
    const { stdout, stderr } = await exec(cmd)
    console.log(stdout)
    const head = await exec(`head ${outfile}`)
    console.log(head)
}

async function deleteFile(bucket, filename) {
    const storage = new Storage();
    console.log(filename)
    await storage.bucket(bucket).file(filename).delete()
}

export async function POST(request) {
    const { message } = await request.json()

    try {
        const data = JSON.parse(atob(message.data))
        const infile = '/tmp/' + data.name.split('/').reverse()[0] + ".input"
        const outfile = '/tmp/' + data.name.split('/').reverse()[0] + ".output"
        await downloadFile(data.bucket, data.name, infile)
        await convertFile("verify.sh", infile, outfile)
        await uploadFile(data.bucket, data.name, outfile)
        await deleteFile(data.bucket, data.name)
        console.log(JSON.stringify(data))
    } catch (e) {
        console.log(`Error: ${e}`)
    }

    return Response.json(message)
}
