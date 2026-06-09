import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, clientAs, anonClient } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { newPatientPayload, updatePatientPayload } from '../lib/factories/patient.factory.js';
import { newPatientTagPayload } from '../lib/factories/clinic.factory.js';
import { PatientSchema, PatientTagSchema } from '../lib/schemas/patient.schema.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Patient Management', () => {
  let clinicId: string;
  let patientPayload: ReturnType<typeof newPatientPayload>;

  beforeAll(async () => {
    await ensureTestUsers();
    clinicId = fixtures.clinic.id!;
    if (!clinicId) throw new Error('Clinic fixture not available');
    patientPayload = newPatientPayload(1);
  });

  describe('patient tags', () => {
    it('POST /v1/clinics/{clinicId}/patient_tags creates a tag', async () => {
      const res = await apiClient.post(
        `/v1/clinics/${clinicId}/patient_tags`,
        newPatientTagPayload(),
      );

      expect(res.status).toBe(200);
      PatientTagSchema.parse(res.data);
      fixtures.patientTagId = res.data.id;
      saveFixtures();
    });
  });

  describe('POST /v1/clinics/{clinicId}/patients', () => {
    it('creates a custodial patient', async () => {
      const res = await apiClient.post(
        `/v1/clinics/${clinicId}/patients`,
        patientPayload,
      );

      expect(res.status).toBe(200);
      PatientSchema.parse(res.data);

      fixtures.patient = {
        id: res.data.id,
        fullName: res.data.fullName,
      };
      saveFixtures();
    });

    it('returns 400 for invalid birthDate', async () => {
      const res = await apiClient.post(`/v1/clinics/${clinicId}/patients`, {
        fullName: 'Bad Patient',
        birthDate: 'not-a-date',
      });

      expect(res.status).toBe(400);
    });
  });

  describe('GET /v1/clinics/{clinicId}/patients', () => {
    it('lists patients', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/patients`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
      expect(res.data.length).toBeGreaterThanOrEqual(1);
    });

    it('filters patients by search term', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/patients`, {
        params: { search: fixtures.patient.fullName },
      });

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('GET /v1/clinics/{clinicId}/patients/{patientId}', () => {
    it('returns patient by ID', async () => {
      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/patients/${fixtures.patient.id}`,
      );

      expect(res.status).toBe(200);
      PatientSchema.parse(res.data);
      expect(res.data.id).toBe(fixtures.patient.id);
    });

    it('returns 404 for non-existent patient', async () => {
      const res = await apiClient.get(
        `/v1/clinics/${clinicId}/patients/000000000000000000000000`,
      );

      expect(res.status).toBe(404);
    });
  });

  describe('PUT /v1/clinics/{clinicId}/patients/{patientId}', () => {
    it('updates patient details', async () => {
      const updated = updatePatientPayload(patientPayload);
      const res = await apiClient.put(
        `/v1/clinics/${clinicId}/patients/${fixtures.patient.id}`,
        updated,
      );

      expect(res.status).toBe(200);
      expect(res.data.fullName).toBe(updated.fullName);
    });
  });

  describe('patient tag assignment', () => {
    it('assigns tag to patient via PUT', async () => {
      if (!fixtures.patientTagId) return;

      const getRes = await apiClient.get(
        `/v1/clinics/${clinicId}/patients/${fixtures.patient.id}`,
      );
      const res = await apiClient.put(
        `/v1/clinics/${clinicId}/patients/${fixtures.patient.id}`,
        { ...getRes.data, tags: [fixtures.patientTagId] },
      );

      expect(res.status).toBe(200);
    });
  });

  describe('GET /v1/patients/{userId}/clinics', () => {
    it('lists clinics for patient', async () => {
      if (!fixtures.patient.id) return;

      const res = await apiClient.get(
        `/v1/patients/${fixtures.patient.id}/clinics`,
      );

      // Patient may or may not have direct user access
      expect([200, 403]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 403 when non-member tries to list patients', async () => {
      const user2Client = clientAs(fixtures.user2.sessionToken);
      const res = await user2Client.get(
        `/v1/clinics/${clinicId}/patients`,
      );

      expect(res.status).toBe(403);
    });
  });
});
