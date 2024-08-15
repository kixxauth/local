import fsp from 'node:fs/promises';
import fs from 'node:fs';
import { pipeline } from 'node:stream/promises';
import path from 'node:path';
import crypto from 'node:crypto';


const ALGO = 'aes-256-cbc';


export default async function encryptFiles({ key, input, output }) {
    const today = new Date();
    const timestring = today.toISOString().split('.')[0];
    const outputDirpath = output;

    await fsp.mkdir(outputDirpath, { recursive: true });

    const iv = crypto.randomBytes(16);
    const ivFilepath = path.join(outputDirpath, '.iv');

    await fsp.writeFile(ivFilepath, iv, { encoding: null });

    key = Buffer.from(key, 'hex');

    walkDirectory(outputDirpath, key, iv, input);
}

async function walkDirectory(outputDirpath, key, iv, dirpath) {
    const relativePath = path.relative(dirpath, outputDirpath);
    const dest = path.resolve(dirpath, relativePath);

    const files = [];
    const directories = [];

    const entries = await fsp.readdir(dirpath);

    for (const entry of entries) {
        const fullpath = path.join(dirpath, entry);
        const stat = await fsp.stat(fullpath);

        if (stat.isFile()) {
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
            await encryptAndWriteFile(key, iv, file.src, file.dest);
        }
    }

    if (directories.length > 0) {
        for (const dir of directories) {
            await walkDirectory(dir.dest, key, iv, dir.src);
        }
    }
}

function encryptAndWriteFile(key, iv, src, dest) {
    const cipher = crypto.createCipheriv(ALGO, key, iv);
    const readStream = fs.createReadStream(src, { encoding: null });
    const writeStream = fs.createWriteStream(dest, { encoding: null });

    return pipeline(readStream, cipher, writeStream);
}
