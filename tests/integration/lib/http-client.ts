import axios, { AxiosInstance, InternalAxiosRequestConfig } from 'axios';
import { config } from './config.js';
import { fixtures } from './fixtures.js';

function createBaseClient(baseURL: string): AxiosInstance {
  const client = axios.create({
    baseURL,
    timeout: 25_000,
    validateStatus: () => true, // never throw on HTTP status
  });

  client.interceptors.response.use((response) => {
    if (response.status >= 500) {
      console.error(
        `[${response.config.method?.toUpperCase()} ${response.config.url}] ${response.status}`,
        typeof response.data === 'string' ? response.data.slice(0, 200) : response.data,
      );
    }
    return response;
  });

  return client;
}

/** Raw client for auth endpoints — no automatic token injection. */
export const authClient: AxiosInstance = createBaseClient(config.authUrl);

/** API client that auto-injects X-Tidepool-Session-Token from user1 fixture. */
export const apiClient: AxiosInstance = createBaseClient(config.baseUrl);

apiClient.interceptors.request.use((req: InternalAxiosRequestConfig) => {
  if (!req.headers['X-Tidepool-Session-Token'] && fixtures.user1?.sessionToken) {
    req.headers['X-Tidepool-Session-Token'] = fixtures.user1.sessionToken;
  }
  return req;
});

/** Create a client authenticated as a specific user. */
export function clientAs(sessionToken: string): AxiosInstance {
  const client = createBaseClient(config.baseUrl);
  client.interceptors.request.use((req: InternalAxiosRequestConfig) => {
    if (!req.headers['X-Tidepool-Session-Token']) {
      req.headers['X-Tidepool-Session-Token'] = sessionToken;
    }
    return req;
  });
  return client;
}

/** Create an unauthenticated client (no token injection). */
export const anonClient: AxiosInstance = createBaseClient(config.baseUrl);
