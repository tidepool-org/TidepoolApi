import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { newDataSetPayload, sampleCbgDatum } from '../lib/factories/dataset.factory.js';
import { DataSetSchema } from '../lib/schemas/dataset.schema.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Data Service', () => {
  let dataSetPayload: ReturnType<typeof newDataSetPayload>;

  beforeAll(async () => {
    await ensureTestUsers();
    dataSetPayload = newDataSetPayload();
  });

  describe('POST /v1/users/{userId}/datasets', () => {
    it('creates a new dataset', async () => {
      const res = await apiClient.post(
        `/v1/users/${fixtures.user1.id}/datasets`,
        dataSetPayload,
      );

      expect(res.status).toBe(201);
      DataSetSchema.parse(res.data);

      fixtures.dataSet = {
        id: res.data.id || res.data.uploadId,
        uploadId: res.data.uploadId,
      };
      saveFixtures();
    });

    it('returns 401 without auth', async () => {
      const res = await anonClient.post(
        `/v1/users/${fixtures.user1.id}/datasets`,
        dataSetPayload,
      );

      expect(res.status).toBe(401);
    });
  });

  describe('GET /v1/users/{userId}/datasets', () => {
    it('lists datasets for user', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user1.id}/datasets`,
      );

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('GET /v1/users/{userId}/data_sets', () => {
    it('lists data sets (v2 endpoint)', async () => {
      const res = await apiClient.get(
        `/v1/users/${fixtures.user1.id}/data_sets`,
      );

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('POST /v1/datasets/{dataSetId}/data', () => {
    it('uploads data to the dataset', async () => {
      const uploadId = fixtures.dataSet.uploadId!;
      const datum = sampleCbgDatum();
      datum.uploadId = uploadId;

      const res = await apiClient.post(
        `/v1/datasets/${uploadId}/data`,
        [datum],
      );

      expect(res.status).toBe(200);
    });

    it('returns 400 for invalid data', async () => {
      const uploadId = fixtures.dataSet.uploadId!;
      const res = await apiClient.post(
        `/v1/datasets/${uploadId}/data`,
        [{ invalid: 'datum' }],
      );

      expect([400, 422]).toContain(res.status);
    });
  });

  describe('PUT /v1/datasets/{dataSetId}', () => {
    it('updates dataset metadata', async () => {
      const uploadId = fixtures.dataSet.uploadId!;
      const res = await apiClient.put(`/v1/datasets/${uploadId}`, {
        deviceModel: 'Updated Model',
      });

      expect(res.status).toBe(200);
    });
  });

  describe('GET /data/{userId}', () => {
    it('queries data for user', async () => {
      const res = await apiClient.get(`/data/${fixtures.user1.id}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });

    it('queries data with type filter', async () => {
      const res = await apiClient.get(`/data/${fixtures.user1.id}`, {
        params: { type: 'cbg' },
      });

      expect(res.status).toBe(200);
    });
  });

  describe('error cases', () => {
    it('returns 404 for non-existent dataset', async () => {
      const res = await apiClient.get(
        '/v1/datasets/nonexistent_dataset_id',
      );

      expect([400, 404]).toContain(res.status);
    });
  });
});
