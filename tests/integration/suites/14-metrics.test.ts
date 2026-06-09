import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Metrics', () => {
  beforeAll(() => ensureTestUsers());
  describe('GET /metrics/thisuser/{eventName}', () => {
    it('records a metric event for logged-in user', async () => {
      const res = await apiClient.get('/metrics/thisuser/integration_test_event', {
        params: { source: 'integration-tests' },
      });

      expect(res.status).toBe(200);
    });

    it('returns 401 without auth', async () => {
      const res = await anonClient.get('/metrics/thisuser/integration_test_event');
      expect(res.status).toBe(401);
    });
  });

  describe('GET /metrics/user/{userId}/{eventName}', () => {
    it('records a metric event for named user', async () => {
      const res = await apiClient.get(
        `/metrics/user/${fixtures.user1.id}/integration_test_event`,
        { params: { source: 'integration-tests' } },
      );

      expect(res.status).toBe(200);
    });
  });
});
