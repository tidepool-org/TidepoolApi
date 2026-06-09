import { describe, it, expect, beforeAll } from 'vitest';
import { anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { UserSchema, TokenDataSchema } from '../lib/schemas/user.schema.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Auth Legacy (v1)', () => {
  beforeAll(() => ensureTestUsers());
  let sessionToken: string;

  describe('POST /auth/login', () => {
    it('returns user and session token with valid basic auth', async () => {
      const credentials = Buffer.from(
        `${fixtures.user1.email}:${fixtures.user1.password}`,
      ).toString('base64');

      const res = await anonClient.post('/auth/login', null, {
        headers: { Authorization: `Basic ${credentials}` },
      });

      expect(res.status).toBe(200);
      expect(res.headers['x-tidepool-session-token']).toBeTypeOf('string');
      UserSchema.parse(res.data);
      sessionToken = res.headers['x-tidepool-session-token'];
    });

    it('returns 401 for bad credentials', async () => {
      const credentials = Buffer.from(
        `${fixtures.user1.email}:WrongPassword!`,
      ).toString('base64');

      const res = await anonClient.post('/auth/login', null, {
        headers: { Authorization: `Basic ${credentials}` },
      });

      expect(res.status).toBe(401);
    });

    it('returns 401 when auth header is missing', async () => {
      const res = await anonClient.post('/auth/login');
      expect(res.status).toBe(401);
    });
  });

  describe('GET /auth/login (refresh)', () => {
    it('refreshes session token', async () => {
      const res = await anonClient.get('/auth/login', {
        headers: { 'X-Tidepool-Session-Token': sessionToken },
      });

      expect(res.status).toBe(200);
      expect(res.headers['x-tidepool-session-token']).toBeTypeOf('string');
      TokenDataSchema.parse(res.data);
    });

    it('returns 401 with invalid session token', async () => {
      const res = await anonClient.get('/auth/login', {
        headers: { 'X-Tidepool-Session-Token': 'invalid-token' },
      });

      expect(res.status).toBe(401);
    });
  });

  describe('GET /auth/token', () => {
    it('validates a valid session token', async () => {
      const res = await anonClient.get('/auth/token', {
        headers: { 'X-Tidepool-Session-Token': sessionToken },
      });

      expect(res.status).toBe(200);
      TokenDataSchema.parse(res.data);
    });

    it('returns 401 for invalid token', async () => {
      const res = await anonClient.get('/auth/token', {
        headers: { 'X-Tidepool-Session-Token': 'not-a-real-token' },
      });

      expect(res.status).toBe(401);
    });
  });

  describe('POST /auth/logout', () => {
    it('logs out successfully', async () => {
      // Use a fresh login so we don't invalidate the fixture token
      const credentials = Buffer.from(
        `${fixtures.user1.email}:${fixtures.user1.password}`,
      ).toString('base64');
      const loginRes = await anonClient.post('/auth/login', null, {
        headers: { Authorization: `Basic ${credentials}` },
      });
      const tempToken = loginRes.headers['x-tidepool-session-token'];

      const res = await anonClient.post('/auth/logout', null, {
        headers: { 'X-Tidepool-Session-Token': tempToken },
      });

      expect(res.status).toBe(200);
    });
  });
});
