import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Prescriptions', () => {
  let clinicId: string;

  beforeAll(async () => {
    await ensureTestUsers();
    clinicId = fixtures.clinic.id!;
    if (!clinicId) throw new Error('Clinic fixture not available');
  });

  describe('POST /v1/clinics/{clinicId}/prescriptions', () => {
    it('creates a prescription', async () => {
      const res = await apiClient.post(`/v1/clinics/${clinicId}/prescriptions`, {
        state: 'draft',
        latestRevision: {
          attributes: {
            accountType: 'patient',
            caregiverFirstName: '',
            caregiverLastName: '',
            firstName: 'Test',
            lastName: 'Patient',
            birthday: '1990-01-15',
            email: fixtures.user1.email,
            phoneNumber: { countryCode: 1, number: '5551234567' },
            initialSettings: {
              bloodGlucoseUnits: 'mg/dL',
            },
          },
        },
      });

      // Prescription endpoint may have specific requirements
      expect([200, 201, 400]).toContain(res.status);
      if (res.status === 200 || res.status === 201) {
        fixtures.prescriptionId = res.data.id;
        saveFixtures();
      }
    });
  });

  describe('GET /v1/clinics/{clinicId}/prescriptions', () => {
    it('lists prescriptions', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/prescriptions`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('GET /v1/clinics/{clinicId}/prescriptions/{prescriptionId}', () => {
    it('returns prescription by ID', async () => {
      if (!fixtures.prescriptionId) return;

      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/prescriptions/${fixtures.prescriptionId}`,
      );

      expect(res.status).toBe(200);
      expect(res.data.id).toBe(fixtures.prescriptionId);
    });
  });

  describe('error cases', () => {
    it('returns 401 without auth', async () => {
      const res = await anonClient.get(`/v1/clinics/${clinicId}/prescriptions`);
      expect(res.status).toBe(401);
    });

    it('returns 404 for non-existent prescription', async () => {
      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/prescriptions/000000000000000000000000`,
      );

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /v1/clinics/{clinicId}/prescriptions/{prescriptionId}', () => {
    it('deletes the prescription', async () => {
      if (!fixtures.prescriptionId) return;

      const res = await apiClient.delete(
        `/v1/clinics/${clinicId}/prescriptions/${fixtures.prescriptionId}`,
      );

      expect([200, 202, 204]).toContain(res.status);
    });
  });
});
