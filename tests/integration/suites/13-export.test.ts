import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Export', () => {
  beforeAll(() => ensureTestUsers());
  describe('GET /export/{userId}', () => {
    it('exports data as JSON', async () => {
      const res = await apiClient.get(`/export/${fixtures.user1.id}`, {
        params: { format: 'json' },
      });

      expect([200, 204]).toContain(res.status);
    });

    it('exports data as Excel', async () => {
      const res = await apiClient.get(`/export/${fixtures.user1.id}`, {
        params: { format: 'excel' },
        responseType: 'arraybuffer',
      });

      expect([200, 204]).toContain(res.status);
    });

    it('supports date range filters', async () => {
      const res = await apiClient.get(`/export/${fixtures.user1.id}`, {
        params: {
          format: 'json',
          startDate: new Date(Date.now() - 86400000).toISOString(),
          endDate: new Date().toISOString(),
        },
      });

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 401 without auth', async () => {
      const res = await anonClient.get(`/export/${fixtures.user1.id}`, {
        params: { format: 'json' },
      });

      expect(res.status).toBe(401);
    });
  });
});
