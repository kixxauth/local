import { parseArgs } from 'node:util';
import generateEncryptionKey32 from './commands/generate-encryption-key.js';
import encryptFiles from './commands/encrypt-files.js';
import decryptFiles from './commands/decrypt-files.js';


const args = process.argv.slice(2);
const cmd = args.shift();


function main(command) {
    // eslint-disable-next-line no-use-before-define
    const handler = commands[command];

    if (typeof handler !== 'function') {
        throw new Error(`Could not find a handler for command "${ command }"`);
    }

    Promise.resolve(handler()).catch((error) => {
        // eslint-disable-next-line no-console
        console.log(`Error while executing command "${ command }"`);
        // eslint-disable-next-line no-console
        console.log(error.stack);
    });
}

const commands = {
    genkey() {
        process.stdout.write(generateEncryptionKey32());
    },

    encryptfiles() {
        const opts = parseArgs({ args, options: {
            key: {
                type: 'string',
                short: 'k',
            },
            input: {
                type: 'string',
                short: 'i',
            },
            output: {
                type: 'string',
                short: 'o',
            },
        } });

        const { key, input, output } = opts.values;

        if (!key || key.length !== 64) {
            throw new Error(`Invalid key: "${ key }"`);
        }
        if (!input) {
            throw new Error('Missing --input argument');
        }
        if (!output) {
            throw new Error('Missing --output argument');
        }

        return encryptFiles({ key, input, output });
    },

    decryptfiles() {
        const opts = parseArgs({ args, options: {
            key: {
                type: 'string',
                short: 'k',
            },
            input: {
                type: 'string',
                short: 'i',
            },
            output: {
                type: 'string',
                short: 'o',
            },
        } });

        const { key, input, output } = opts.values;

        if (!key || key.length !== 64) {
            throw new Error(`Invalid key: "${ key }"`);
        }
        if (!input) {
            throw new Error('Missing --input argument');
        }
        if (!output) {
            throw new Error('Missing --output argument');
        }

        return decryptFiles({ key, input, output });
    },
};

main(cmd);
