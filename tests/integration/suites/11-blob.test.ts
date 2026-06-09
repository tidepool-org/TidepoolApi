import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { BlobMetadataSchema } from '../lib/schemas/dataset.schema.js';
import { createHash } from 'crypto';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Blob Service', () => {
  beforeAll(() => ensureTestUsers());
  const content = Buffer.from('Integration test blob content');
  const md5 = createHash('md5').update(content).digest('base64');
  let blobId: string;

  describe('POST /v1/users/{userId}/blobs', () => {
    it('creates a blob with binary content', async () => {
      const res = await apiClient.post(
        `/v1/users/${fixtures.user1.id}/blobs`,
        content,
        {
          headers: {
            'Content-Type': 'application/octet-stream',
            Digest: `MD5=${md5}`,
          },
        },
      );

      expect([200, 201]).toContain(res.status);
      BlobMetadataSchema.parse(res.data);
      blobId = res.data.id;
    });

    it('returns error when Digest header is missing', async () => {
      const res = await apiClient.post(
        `/v1/users/${fixtures.user1.id}/blobs`,
        content,
        {
          headers: { 'Content-Type': 'application/octet-stream' },
        },
      );

      expect([400, 422]).toContain(res.status);
    });
  });

  describe('GET /v1/users/{userId}/blobs', () => {
    it('lists blobs for user', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user1.id}/blobs`,
      );

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('GET /v1/blobs/{blobId}', () => {
    it('returns blob metadata', async () => {
      if (!blobId) return;

      const res = await apiClient.get(`/v1/blobs/${blobId}`);

      expect(res.status).toBe(200);
      BlobMetadataSchema.parse(res.data);
    });

    it('returns 404 for non-existent blob', async () => {
      const res = await apiClient.get(
        '/v1/blobs/000000000000000000000000',
      );

      expect(res.status).toBe(404);
    });
  });

  describe('GET /v1/blobs/{blobId}/content', () => {
    it('returns blob content', async () => {
      if (!blobId) return;

      const res = await apiClient.get(`/v1/blobs/${blobId}/content`, {
        responseType: 'arraybuffer',
      });

      expect(res.status).toBe(200);
    });
  });

  describe('device logs', () => {
    it('POST /v1/users/{userId}/device_logs uploads device logs', async () => {
      const logContent = Buffer.from('device log data');
      const logMd5 = createHash('md5').update(logContent).digest('base64');

      const res = await apiClient.post(
        `/v1/users/${fixtures.user1.id}/device_logs`,
        logContent,
        {
          headers: {
            'Content-Type': 'application/octet-stream',
            Digest: `MD5=${logMd5}`,
          },
          params: {
            startAt: new Date(Date.now() - 3600000).toISOString(),
            endAt: new Date().toISOString(),
          },
        },
      );

      expect([200, 201]).toContain(res.status);
    });

    it('GET /v1/users/{userId}/device_logs lists device logs', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user1.id}/device_logs`,
      );

      expect(res.status).toBe(200);
    });
  });

  describe('error cases', () => {
    it('returns 401 without auth', async () => {
      const res = await anonClient.get(
        `/v1/users/${fixtures.user1.id}/blobs`,
      );

      expect(res.status).toBe(401);
    });
  });
});
