import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, clientAs } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Clinic Advanced Operations', () => {
  let clinicId: string;

  beforeAll(async () => {
    await ensureTestUsers();
    clinicId = fixtures.clinic.id!;
    if (!clinicId) throw new Error('Clinic fixture not available');
  });

  describe('GET /v1/clinics/{clinicId}/tier', () => {
    it('returns clinic tier', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/tier`);

      expect([200, 404]).toContain(res.status);
    });
  });

  describe('GET /v1/clinics/{clinicId}/patient_count', () => {
    it('returns patient count', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/patient_count`);

      expect(res.status).toBe(200);
    });
  });

  describe('suppressed notifications', () => {
    it('GET /v1/clinics/{clinicId}/suppressed_notifications', async () => {
      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/suppressed_notifications`,
      );

      expect([200, 404]).toContain(res.status);
    });

    it('POST /v1/clinics/{clinicId}/suppressed_notifications', async () => {
      const res = await apiClient.post(
        `/v1/clinics/${clinicId}/suppressed_notifications`,
        { patientClinicInvitation: true },
      );

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('membership restrictions', () => {
    it('GET /v1/clinics/{clinicId}/membership_restrictions', async () => {
      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/membership_restrictions`,
      );

      expect([200, 404]).toContain(res.status);
    });

    it('PUT /v1/clinics/{clinicId}/membership_restrictions', async () => {
      const res = await apiClient.put(
        `/v1/clinics/${clinicId}/membership_restrictions`,
        { requiredIdp: '' },
      );

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('EHR settings', () => {
    it('GET /v1/clinics/{clinicId}/settings/ehr', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/settings/ehr`);

      expect([200, 404]).toContain(res.status);
    });

    it('PUT /v1/clinics/{clinicId}/settings/ehr', async () => {
      const res = await apiClient.put(`/v1/clinics/${clinicId}/settings/ehr`, {
        enabled: false,
      });

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('MRN settings', () => {
    it('GET /v1/clinics/{clinicId}/settings/mrn', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/settings/mrn`);

      expect([200, 404]).toContain(res.status);
    });

    it('PUT /v1/clinics/{clinicId}/settings/mrn', async () => {
      const res = await apiClient.put(`/v1/clinics/${clinicId}/settings/mrn`, {
        required: false,
        unique: false,
      });

      expect([200, 204]).toContain(res.status);
    });
  });

  describe('TIDE report', () => {
    it('GET /v1/clinics/{clinicId}/tide_report', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/tide_report`, {
        params: { startDate: new Date(Date.now() - 86400000 * 14).toISOString() },
      });

      // May require specific tier or return 403
      expect([200, 403, 404]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 403 when non-member accesses clinic settings', async () => {
      const user2Client = clientAs(fixtures.user2.sessionToken);
      const res = await user2Client.get(`/v1/clinics/${clinicId}/settings/ehr`);

      expect(res.status).toBe(403);
    });
  });
});
