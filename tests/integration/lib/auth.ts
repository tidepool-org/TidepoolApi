import axios from 'axios';
import { config } from './config.js';

const rawAuthClient = axios.create({
  baseURL: config.authUrl,
  timeout: 15_000,
  validateStatus: () => true,
});

const rawApiClient = axios.create({
  baseURL: config.baseUrl,
  timeout: 15_000,
  validateStatus: () => true,
});

export interface TokenResponse {
  access_token: string;
  refresh_token?: string;
  expires_in: number;
  refresh_expires_in?: number;
  scope?: string;
  id_token?: string;
}

export interface TokenErrorResponse {
  error: string;
  error_description?: string;
}

/** Obtain OIDC access token via password grant. */
export async function obtainAccessToken(
  username: string,
  password: string,
): Promise<TokenResponse> {
  const res = await rawAuthClient.post(
    `/realms/${config.realm}/protocol/openid-connect/token`,
    new URLSearchParams({
      grant_type: 'password',
      client_id: config.clientId!,
      client_secret: config.clientSecret!,
      username,
      password,
    }),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
  );
  if (res.status !== 200) {
    throw new Error(`OIDC token failed (${res.status}): ${JSON.stringify(res.data)}`);
  }
  return res.data;
}

/** Refresh an OIDC access token. */
export async function refreshAccessToken(refreshToken: string): Promise<TokenResponse> {
  const res = await rawAuthClient.post(
    `/realms/${config.realm}/protocol/openid-connect/token`,
    new URLSearchParams({
      grant_type: 'refresh_token',
      client_id: config.clientId!,
      client_secret: config.clientSecret!,
      refresh_token: refreshToken,
    }),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
  );
  if (res.status !== 200) {
    throw new Error(`OIDC refresh failed (${res.status}): ${JSON.stringify(res.data)}`);
  }
  return res.data;
}

/** Raw OIDC token request — returns full axios response (for testing error cases). */
export async function rawOidcTokenRequest(params: Record<string, string>) {
  return rawAuthClient.post(
    `/realms/${config.realm}/protocol/openid-connect/token`,
    new URLSearchParams(params),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
  );
}

export interface LegacyLoginResult {
  sessionToken: string;
  userId: string;
  user: Record<string, unknown>;
}

/** Legacy login via POST /auth/login with Basic auth. */
export async function legacyLogin(
  email: string,
  password: string,
): Promise<LegacyLoginResult> {
  const res = await rawApiClient.post('/auth/login', null, {
    headers: {
      Authorization: `Basic ${Buffer.from(`${email}:${password}`).toString('base64')}`,
    },
  });
  if (res.status !== 200) {
    throw new Error(`Legacy login failed (${res.status}): ${JSON.stringify(res.data)}`);
  }
  return {
    sessionToken: res.headers['x-tidepool-session-token'],
    userId: res.data.userid,
    user: res.data,
  };
}

/** Create a new user account via POST /auth/user. */
export async function createUser(
  email: string,
  password: string,
): Promise<{ userId: string; sessionToken: string }> {
  const res = await rawApiClient.post('/auth/user', {
    username: email,
    emails: [email],
    password,
  });
  if (res.status !== 201) {
    throw new Error(`Create user failed (${res.status}): ${JSON.stringify(res.data)}`);
  }
  return {
    userId: res.data.userid,
    sessionToken: res.headers['x-tidepool-session-token'],
  };
}

/** Server login via POST /auth/serverlogin. */
export async function serverLogin(): Promise<string> {
  if (!config.serverSecret) throw new Error('TIDEPOOL_SERVER_SECRET not configured');
  const res = await rawApiClient.post('/auth/serverlogin', null, {
    headers: {
      'X-Tidepool-Server-Name': 'integration-tests',
      'X-Tidepool-Server-Secret': config.serverSecret,
    },
  });
  if (res.status !== 200) {
    throw new Error(`Server login failed (${res.status}): ${JSON.stringify(res.data)}`);
  }
  return res.headers['x-tidepool-session-token'];
}
