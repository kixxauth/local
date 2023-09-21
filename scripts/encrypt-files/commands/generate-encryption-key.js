import crypto from 'node:crypto';

export default function generateEncryptionKey32() {
    return crypto.randomBytes(32).toString('hex');
}
