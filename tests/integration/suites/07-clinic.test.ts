import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { newClinicPayload } from '../lib/factories/clinic.factory.js';
import { ClinicSchema } from '../lib/schemas/clinic.schema.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Clinic CRUD', () => {
  let clinicPayload: ReturnType<typeof newClinicPayload>;

  beforeAll(async () => {
    await ensureTestUsers();
    clinicPayload = newClinicPayload();
  });

  describe('POST /v1/clinics', () => {
    it('creates a new clinic', async () => {
      const res = await apiClient.post('/v1/clinics', clinicPayload);

      expect(res.status).toBe(200);
      ClinicSchema.parse(res.data);
      expect(res.data.name).toBe(clinicPayload.name);

      fixtures.clinic = {
        id: res.data.id,
        shareCode: res.data.shareCode,
        name: res.data.name,
      };
      saveFixtures();
    });
  });

  describe('GET /v1/clinics', () => {
    it('lists clinics', async () => {
      const res = await apiClient.get('/v1/clinics', {
        params: { limit: 10, offset: 0 },
      });

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('GET /v1/clinics/{clinicId}', () => {
    it('returns clinic by ID', async () => {
      const res = await apiClient.get(`/v1/clinics/${fixtures.clinic.id}`);

      expect(res.status).toBe(200);
      ClinicSchema.parse(res.data);
      expect(res.data.id).toBe(fixtures.clinic.id);
    });

    it('returns 404 for non-existent clinic', async () => {
      const res = await apiClient.get('/v1/clinics/000000000000000000000000');
      expect(res.status).toBe(404);
    });
  });

  describe('GET /v1/clinics/share_code/{shareCode}', () => {
    it('returns clinic by share code', async () => {
      const res = await apiClient.get(
        `/v1/clinics/share_code/${fixtures.clinic.shareCode}`,
      );

      expect(res.status).toBe(200);
      expect(res.data.id).toBe(fixtures.clinic.id);
    });
  });

  describe('PUT /v1/clinics/{clinicId}', () => {
    it('updates clinic details', async () => {
      const res = await apiClient.put(`/v1/clinics/${fixtures.clinic.id}`, {
        ...clinicPayload,
        city: 'Updated City',
      });

      expect(res.status).toBe(200);
      expect(res.data.city).toBe('Updated City');
    });
  });

  describe('error cases', () => {
    it('returns 400 for invalid payload', async () => {
      const res = await apiClient.post('/v1/clinics', {});
      expect(res.status).toBe(400);
    });

    it('returns 401 without auth', async () => {
      const res = await anonClient.get(`/v1/clinics/${fixtures.clinic.id}`);
      expect(res.status).toBe(401);
    });
  });
});
