import { config as loadDotenv } from 'dotenv';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
loadDotenv({ path: resolve(__dirname, '../.env') });

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

function optional(name: string): string | undefined {
  return process.env[name] || undefined;
}

export const config = {
  baseUrl: required('TIDEPOOL_BASE_URL'),
  authUrl: required('TIDEPOOL_AUTH_URL'),
  realm: required('TIDEPOOL_REALM'),
  clientId: optional('TIDEPOOL_CLIENT_ID'),
  clientSecret: optional('TIDEPOOL_CLIENT_SECRET'),
  serverSecret: optional('TIDEPOOL_SERVER_SECRET'),

  get hasOidcCredentials(): boolean {
    return !!(this.clientId && this.clientSecret);
  },

  get hasServerSecret(): boolean {
    return !!this.serverSecret;
  },
};
