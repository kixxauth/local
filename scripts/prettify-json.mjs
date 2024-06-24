import fs from 'node:fs';
import path from 'node:path';

const filepath = path.resolve(process.argv[2]);

fs.readFile(filepath, { encoding: 'utf8' }, function onRead(error, utf8) {
    if (error) {
        console.error('File read error:');
        console.error(error);
    } else {
        const jsonData = JSON.parse(utf8);
        console.log(JSON.stringify(jsonData, null, 4));
    }
});
