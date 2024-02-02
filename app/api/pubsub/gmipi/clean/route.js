import { Storage } from '@google-cloud/storage'
import { promisify } from 'util'
import { exec as execAsync } from 'child_process'

const exec = promisify(execAsync)
export const dynamic = 'force-dynamic'

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms))
}

async function downloadFile(bucket, filename, infile) {
    const storage = new Storage()
    const options = { destination: infile }
    await storage.bucket(bucket).file(filename).download(options)
}

async function uploadFile(bucket, filename, outfile, invalid) {
    const storage = new Storage()
    const fileRename = invalid ? filename + '.invalid' : filename.replace('/inbound/', '/outbound/').replace(/(\.gz|\.z)$/i, '')
    const options = { destination: fileRename }
    await storage.bucket(bucket).upload(outfile, options)
}

async function convertFile(scriptname, infile, outfile) {
    const cmd = `./app/scripts/${scriptname} ${infile} ${outfile}`
    //console.log(cmd)
    const output = await exec(cmd)
    console.log(output)
}

async function deleteFile(bucket, filename) {
    const storage = new Storage();
    await storage.bucket(bucket).file(filename).delete()
}

export async function POST(request) {
    const { message } = await request.json()

    /* we try three times */
    for (let i = 0; i < 3; i++) {
        try {
            const data = JSON.parse(atob(message.data))
            const infile = '/tmp/' + data.name.split('/').reverse()[0] + ".input"
            const outfile = '/tmp/' + data.name.split('/').reverse()[0] + ".output"
            await downloadFile(data.bucket, data.name, infile)
            let invalid = false
            try {
                await convertFile("clean.sh", infile, outfile)
            } catch (e) {
                console.error(e)
                invalid = true
                outfile = infile
            }
            await uploadFile(data.bucket, data.name, outfile, invalid)
            await deleteFile(data.bucket, data.name)
            break
        } catch (e) {
            console.error(e)
            console.log(JSON.stringify(data))
        }
    }

    return Response.json({ "message": "processed" })
}
