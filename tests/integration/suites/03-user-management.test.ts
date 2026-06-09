import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { UserSchema } from '../lib/schemas/user.schema.js';
import { newCustodialUserPayload } from '../lib/factories/user.factory.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('User Management', () => {
  beforeAll(() => ensureTestUsers());
  describe('GET /auth/user (current user)', () => {
    it('returns the logged-in user', async () => {
      const res = await apiClient.get('/auth/user');
      expect(res.status).toBe(200);
      UserSchema.parse(res.data);
      expect(res.data.userid).toBe(fixtures.user1.id);
    });

    it('returns 401 without session token', async () => {
      const res = await anonClient.get('/auth/user');
      expect(res.status).toBe(401);
    });
  });

  describe('PUT /auth/user (update current)', () => {
    it('updates termsAccepted for current user', async () => {
      const now = new Date().toISOString();
      const res = await apiClient.put('/auth/user', {
        updates: { termsAccepted: now },
      });

      expect(res.status).toBe(200);
      UserSchema.parse(res.data);
    });
  });

  describe('GET /auth/user/{userId}', () => {
    it('returns user by ID', async () => {
      const res = await apiClient.get(`/auth/user/${fixtures.user2.id}`);
      expect(res.status).toBe(200);
      UserSchema.parse(res.data);
      expect(res.data.userid).toBe(fixtures.user2.id);
    });

    it('returns 404 for non-existent user', async () => {
      const res = await apiClient.get('/auth/user/000000000000000000000000');
      expect(res.status).toBe(404);
    });
  });

  describe('POST /auth/user/{userId}/user (custodial)', () => {
    it('creates a custodial user', async () => {
      const { payload, email } = newCustodialUserPayload('cust1');
      const res = await apiClient.post(
        `/auth/user/${fixtures.user1.id}/user`,
        payload,
      );

      expect(res.status).toBe(201);
      UserSchema.parse(res.data);
      fixtures.custodialUser.id = res.data.userid;
      saveFixtures();
    });

    it('returns 409 for duplicate email', async () => {
      const { payload } = newCustodialUserPayload('cust1');
      // Use existing user1 email to trigger conflict
      payload.username = fixtures.user1.email;
      payload.emails = [fixtures.user1.email];
      const res = await apiClient.post(
        `/auth/user/${fixtures.user1.id}/user`,
        payload,
      );

      expect(res.status).toBe(409);
    });
  });

  describe('DELETE /auth/user/{userId}', () => {
    it('deletes the custodial user', async () => {
      if (!fixtures.custodialUser.id) return;
      const res = await apiClient.delete(
        `/auth/user/${fixtures.custodialUser.id}`,
      );

      expect(res.status).toBe(202);
    });
  });
});
