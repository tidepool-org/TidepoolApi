import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Alerts', () => {
  beforeAll(() => ensureTestUsers());
  const alertsConfig = {
    urgentLow: { enabled: true, threshold: { value: 55, units: 'mg/dL' } },
    low: { enabled: true, threshold: { value: 70, units: 'mg/dL' }, delay: 20, repeat: 30 },
    high: { enabled: false, threshold: { value: 250, units: 'mg/dL' }, delay: 60, repeat: 120 },
    noCommunication: { enabled: false },
    notLooping: { enabled: false },
  };

  describe('POST /v1/users/{userId}/followers/{followerId}/alerts', () => {
    it('creates an alerts config', async () => {
      // user2 follows user1 (permission was granted in 05-access)
      const res = await apiClient.post(
        `/v1/users/${fixtures.user1.id}/followers/${fixtures.user2.id}/alerts`,
        alertsConfig,
      );

      expect([200, 201]).toContain(res.status);
    });
  });

  describe('GET /v1/users/{userId}/followers/{followerId}/alerts', () => {
    it('returns the alerts config', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user1.id}/followers/${fixtures.user2.id}/alerts`,
      );

      expect(res.status).toBe(200);
      expect(res.data).toHaveProperty('urgentLow');
    });

    it('returns 404 when no config exists', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user2.id}/followers/${fixtures.user1.id}/alerts`,
      );

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /v1/users/{userId}/followers/{followerId}/alerts', () => {
    it('deletes the alerts config', async () => {
      const res = await apiClient.delete(
        `/v1/users/${fixtures.user1.id}/followers/${fixtures.user2.id}/alerts`,
      );

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 401 without auth', async () => {
      const res = await anonClient.get(
        `/v1/users/${fixtures.user1.id}/followers/${fixtures.user2.id}/alerts`,
      );

      expect(res.status).toBe(401);
    });
  });
});
