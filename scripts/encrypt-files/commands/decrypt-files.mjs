import fsp from 'node:fs/promises';
import fs from 'node:fs';
import { pipeline } from 'node:stream/promises';
import path from 'node:path';
import crypto from 'node:crypto';


const ALGO = 'aes-256-cbc';


export default async function decryptFiles({ key, input, output }) {
    await fsp.mkdir(output, { recursive: true });

    const ivFilepath = path.join(input, '.iv');
    const iv = await fsp.readFile(ivFilepath, { encoding: null });

    key = Buffer.from(key, 'hex');

    walkDirectory(input, key, iv, output);
}

async function walkDirectory(input, key, iv, output) {
    const relativePath = path.relative(input, output);
    const dest = path.resolve(input, relativePath);

    const files = [];
    const directories = [];

    const entries = await fsp.readdir(input);

    for (const entry of entries) {
        const fullpath = path.join(input, entry);
        const stat = await fsp.stat(fullpath);

        if (stat.isFile() && entry !== '.iv') {
            files.push({
                src: fullpath,
                dest: path.join(dest, entry),
            });
        }

        if (stat.isDirectory()) {
            directories.push({
                src: fullpath,
                dest: path.join(dest, entry),
            });
        }
    }

    if (files.length) {
        await fsp.mkdir(dest, { recursive: true });

        for (const file of files) {
            await decryptAndWriteFile(key, iv, file.src, file.dest);
        }
    }

    if (directories.length > 0) {
        for (const dir of directories) {
            await walkDirectory(dir.src, key, iv, dir.dest);
        }
    }
}

function decryptAndWriteFile(key, iv, src, dest) {
    const cipher = crypto.createDecipheriv(ALGO, key, iv);
    const readStream = fs.createReadStream(src, { encoding: null });
    const writeStream = fs.createWriteStream(dest, { encoding: null });

    return pipeline(readStream, cipher, writeStream);
}
