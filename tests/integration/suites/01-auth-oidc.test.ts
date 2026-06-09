import { describe, it, expect, beforeAll } from 'vitest';
import { config } from '../lib/config.js';
import { fixtures } from '../lib/fixtures.js';
import { rawOidcTokenRequest } from '../lib/auth.js';
import { TokenErrorSchema } from '../lib/schemas/error.schema.js';
import { ensureTestUsers } from '../setup/global-setup.js';

const skip = !config.hasOidcCredentials;

describe.skipIf(skip)('Auth OIDC (v2)', () => {
  beforeAll(() => ensureTestUsers());
  let refreshToken: string;

  describe('password grant', () => {
    it('obtains access and refresh tokens with valid credentials', async () => {
      const res = await rawOidcTokenRequest({
        grant_type: 'password',
        client_id: config.clientId!,
        client_secret: config.clientSecret!,
        username: fixtures.user1.email,
        password: fixtures.user1.password,
      });

      expect(res.status).toBe(200);
      expect(res.data.access_token).toBeTypeOf('string');
      expect(res.data.refresh_token).toBeTypeOf('string');
      expect(res.data.expires_in).toBeTypeOf('number');
      refreshToken = res.data.refresh_token;
    });

    it('returns error for bad credentials', async () => {
      const res = await rawOidcTokenRequest({
        grant_type: 'password',
        client_id: config.clientId!,
        client_secret: config.clientSecret!,
        username: fixtures.user1.email,
        password: 'WrongPassword123!',
      });

      expect(res.status).toBe(400).or(res.status).toBe(401);
      TokenErrorSchema.parse(res.data);
    });

    it('returns error when client_id is missing', async () => {
      const res = await rawOidcTokenRequest({
        grant_type: 'password',
        username: fixtures.user1.email,
        password: fixtures.user1.password,
      });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  describe('refresh token grant', () => {
    it('exchanges refresh token for new tokens', async () => {
      if (!refreshToken) return;

      const res = await rawOidcTokenRequest({
        grant_type: 'refresh_token',
        client_id: config.clientId!,
        client_secret: config.clientSecret!,
        refresh_token: refreshToken,
      });

      expect(res.status).toBe(200);
      expect(res.data.access_token).toBeTypeOf('string');
    });

    it('returns error for invalid refresh token', async () => {
      const res = await rawOidcTokenRequest({
        grant_type: 'refresh_token',
        client_id: config.clientId!,
        client_secret: config.clientSecret!,
        refresh_token: 'invalid-token-value',
      });

      expect(res.status).toBe(400);
      TokenErrorSchema.parse(res.data);
    });
  });
});
