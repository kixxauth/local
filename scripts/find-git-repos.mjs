// Recursively walk a file directory tree and output a list of remote URLs.
// The URLs are printed to stdout.
import process from 'node:process';
import path from 'node:path';
import fsp from 'node:fs/promises';


const ROOT_DIR = path.resolve(process.argv[2]);

const URLS = new Set();


function main() {
    return processNode(ROOT_DIR);
}

async function processNode(filepath) {
    const stats = await getStats(filepath);

    if (!stats || !stats.isDirectory()) {
        return;
    }

    const basename = path.basename(filepath);

    if (basename === '.git') {
        await processGitDirectory(filepath);
        return;
    }
    if (basename === 'node_modules') {
        return;
    }

    const entries = await fsp.readdir(filepath);

    for (const entry of entries) {
        await processNode(path.join(filepath, entry));
    }
}

async function processGitDirectory(filepath) {
    filepath = path.join(filepath, 'config');

    const utf8 = await fsp.readFile(filepath, { encoding: 'utf8' });

    const lines = utf8.split('\n')
        .map(x => x.trim())
        .filter((x) => x);

    for (const line of lines) {
        if (line.startsWith('url =')) {
            const url = line.replace(/^url\s=\s/, '');

            if (URLS.has(url)) {
                return;
            }

            URLS.add(url);
            console.log(url);
            return;
        }
    }

    console.error('!!NO URL in', filepath);
}

function getStats(filepath) {
    return fsp.stat(filepath).catch(function () {
        return null;
    });
}

main().catch(function (error) {
    console.error('script failed:');
    console.error(error);
});
