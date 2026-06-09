import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Confirmations', () => {
  beforeAll(() => ensureTestUsers());
  describe('signup confirmations', () => {
    it('POST /confirm/send/signup/{userId} sends a signup confirmation', async () => {
      const res = await apiClient.post(
        `/confirm/send/signup/${fixtures.user1.id}`,
      );

      // May return 200, 409 (already confirmed), or other
      expect([200, 201, 409]).toContain(res.status);
    });

    it('GET /confirm/signup/{userId} lists pending confirmations', async () => {
      const res = await apiClient.get(
        `/confirm/signup/${fixtures.user1.id}`,
      );

      // 200 with confirmations or 404 if none
      expect([200, 404]).toContain(res.status);
    });
  });

  describe('invite flow', () => {
    it('POST /confirm/send/invite/{userId} sends an invitation', async () => {
      const res = await apiClient.post(
        `/confirm/send/invite/${fixtures.user1.id}`,
        {
          email: fixtures.user2.email,
          permissions: { view: {} },
        },
      );

      // 200 success or 409 if already invited
      expect([200, 201, 409]).toContain(res.status);
    });

    it('GET /confirm/invite/{userId} lists pending invites for user', async () => {
      const res = await apiClient.get(
        `/confirm/invite/${fixtures.user1.id}`,
      );

      // 200 with invitations or 404 if none
      expect([200, 404]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 401 without auth', async () => {
      const res = await anonClient.post(
        `/confirm/send/signup/${fixtures.user1.id}`,
      );

      expect(res.status).toBe(401);
    });

    it('returns 404 for non-existent user', async () => {
      const res = await apiClient.get(
        '/confirm/signup/000000000000000000000000',
      );

      expect([403, 404]).toContain(res.status);
    });
  });
});
