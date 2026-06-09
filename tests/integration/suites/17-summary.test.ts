import { describe, it, expect, beforeAll } from 'vitest';
import { config } from '../lib/config.js';
import { fixtures } from '../lib/fixtures.js';
import { anonClient } from '../lib/http-client.js';
import { serverLogin } from '../lib/auth.js';
import { ensureTestUsers } from '../setup/global-setup.js';
import axios from 'axios';

const skip = !config.hasServerSecret;

describe.skipIf(skip)('Summary (server token)', () => {
  let serverClient: ReturnType<typeof axios.create>;

  beforeAll(async () => {
    await ensureTestUsers();
    const serverToken = await serverLogin();
    serverClient = axios.create({
      baseURL: config.baseUrl,
      timeout: 25_000,
      validateStatus: () => true,
      headers: { 'X-Tidepool-Session-Token': serverToken },
    });
  });

  describe('GET /v1/summaries/{summaryType}/{userId}', () => {
    it('returns CGM summary', async () => {
      const res = await serverClient.get(
        `/v1/summaries/cgm/${fixtures.user1.id}`,
      );

      // May return 200 with summary or 404 if no data
      expect([200, 404]).toContain(res.status);
    });

    it('returns BGM summary', async () => {
      const res = await serverClient.get(
        `/v1/summaries/bgm/${fixtures.user1.id}`,
      );

      expect([200, 404]).toContain(res.status);
    });

    it('returns 400 for invalid summary type', async () => {
      const res = await serverClient.get(
        `/v1/summaries/invalid/${fixtures.user1.id}`,
      );

      expect(res.status).toBe(400);
    });
  });

  describe('error cases', () => {
    it('returns 401 without server token', async () => {
      const res = await anonClient.get(
        `/v1/summaries/cgm/${fixtures.user1.id}`,
      );

      expect(res.status).toBe(401);
    });
  });
});
