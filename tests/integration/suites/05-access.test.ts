import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, clientAs, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Access / Permissions', () => {
  beforeAll(() => ensureTestUsers());
  describe('POST /access/{sharerId}/{userId} — grant permission', () => {
    it('grants view permission from user1 to user2', async () => {
      const res = await apiClient.post(
        `/access/${fixtures.user1.id}/${fixtures.user2.id}`,
        { view: {} },
      );

      // 200 or 201 depending on whether permission existed
      expect([200, 201]).toContain(res.status);
    });
  });

  describe('GET /access/{sharerId}/{userId}', () => {
    it('returns permissions for user2 on user1 data', async () => {
      const res = await apiClient.get(
        `/access/${fixtures.user1.id}/${fixtures.user2.id}`,
      );

      expect(res.status).toBe(200);
      expect(res.data).toBeTypeOf('object');
      expect(res.data).toHaveProperty('view');
    });

    it('returns 401 without auth', async () => {
      const res = await anonClient.get(
        `/access/${fixtures.user1.id}/${fixtures.user2.id}`,
      );

      expect(res.status).toBe(401);
    });
  });

  describe('GET /access/{sharerId}', () => {
    it('lists all users in group', async () => {
      const res = await apiClient.get(`/access/${fixtures.user1.id}`);

      expect(res.status).toBe(200);
      expect(res.data).toBeTypeOf('object');
    });
  });

  describe('GET /access/groups/{userId}', () => {
    it('lists groups where user2 has access', async () => {
      const user2Client = clientAs(fixtures.user2.sessionToken);
      const res = await user2Client.get(`/access/groups/${fixtures.user2.id}`);

      expect(res.status).toBe(200);
      expect(res.data).toBeTypeOf('object');
    });
  });

  describe('error cases', () => {
    it('returns 404 for non-existent sharer', async () => {
      const res = await apiClient.get(
        '/access/000000000000000000000000/000000000000000000000001',
      );

      expect([403, 404]).toContain(res.status);
    });
  });
});
