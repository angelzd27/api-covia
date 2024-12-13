import dotenv from 'dotenv';
import crypto from 'crypto';

dotenv.config();
const JWT_SECRET = process.env.ENCRPT_KEY;
const IV_LENGTH = 16; // Longitud del vector de inicialización

// Función para cifrar
export function encrypt(text) {
    const iv = crypto.randomBytes(IV_LENGTH); // Vector de inicialización
    const cipher = crypto.createCipheriv('aes-256-cbc', JWT_SECRET, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return `${iv.toString('hex')}:${encrypted}`;
}

// Función para descifrar
export function decrypt(text) {
    const [ivHex, encryptedText] = text.split(':');
    const iv = Buffer.from(ivHex, 'hex');
    const decipher = crypto.createDecipheriv('aes-256-cbc', JWT_SECRET, iv);
    let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}