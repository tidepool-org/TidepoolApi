import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Metadata', () => {
  beforeAll(() => ensureTestUsers());
  const profileData = { fullName: 'Test User One', patient: { birthday: '1990-01-15' } };

  describe('POST /metadata/{userId}/{collection}', () => {
    it('creates profile metadata', async () => {
      const res = await apiClient.post(
        `/metadata/${fixtures.user1.id}/profile`,
        profileData,
      );

      // API may return 200 (upsert) or 201 (created)
      expect([200, 201]).toContain(res.status);
    });
  });

  describe('GET /metadata/{userId}/{collection}', () => {
    it('returns profile metadata', async () => {
      const res = await apiClient.get(
        `/metadata/${fixtures.user1.id}/profile`,
      );

      expect(res.status).toBe(200);
      expect(res.data).toBeTypeOf('object');
    });

    it('returns 401 without auth', async () => {
      const res = await anonClient.get(
        `/metadata/${fixtures.user1.id}/profile`,
      );

      expect(res.status).toBe(401);
    });
  });

  describe('PUT /metadata/{userId}/{collection}', () => {
    it('updates profile metadata', async () => {
      const res = await apiClient.put(
        `/metadata/${fixtures.user1.id}/profile`,
        { ...profileData, fullName: 'Updated Name' },
      );

      expect(res.status).toBe(200);
    });
  });

  describe('GET /metadata/users/{userId}/users', () => {
    it('lists trust relationships', async () => {
      const res = await apiClient.get(
        `/metadata/users/${fixtures.user1.id}/users`,
      );

      // May return 200 with data or 404 if no relationships
      expect([200, 404]).toContain(res.status);
    });
  });
});
