import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, clientAs } from '../lib/http-client.js';
import { fixtures } from '../lib/fixtures.js';
import { ClinicianSchema } from '../lib/schemas/clinic.schema.js';
import { uniqueEmail, uniqueName } from '../lib/unique.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Clinician Management', () => {
  let clinicId: string;
  let inviteClinicianEmail: string;

  beforeAll(async () => {
    await ensureTestUsers();
    clinicId = fixtures.clinic.id!;
    if (!clinicId) throw new Error('Clinic fixture not available');
    inviteClinicianEmail = uniqueEmail('clinician_invite');
  });

  describe('GET /v1/clinics/{clinicId}/clinicians', () => {
    it('lists clinicians (creator should be admin)', async () => {
      const res = await apiClient.get(`/v1/clinics/${clinicId}/clinicians`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
      expect(res.data.length).toBeGreaterThanOrEqual(1);

      const admin = res.data.find((c: any) => c.id === fixtures.user1.id);
      expect(admin).toBeDefined();
      expect(admin.roles).toContain('CLINIC_ADMIN');
    });
  });

  describe('POST /v1/clinics/{clinicId}/invites/clinicians', () => {
    it('invites a new clinician by email', async () => {
      const res = await apiClient.post(
        `/v1/clinics/${clinicId}/invites/clinicians`,
        {
          email: inviteClinicianEmail,
          roles: ['CLINIC_MEMBER'],
        },
      );

      // 200 or 409 if already invited
      expect([200, 201, 409]).toContain(res.status);
    });

    it('returns error for duplicate invite', async () => {
      const res = await apiClient.post(
        `/v1/clinics/${clinicId}/invites/clinicians`,
        {
          email: inviteClinicianEmail,
          roles: ['CLINIC_MEMBER'],
        },
      );

      expect([409]).toContain(res.status);
    });
  });

  describe('GET /v1/clinicians/{userId}/clinics', () => {
    it('lists clinics for the current user', async () => {
      const res = await apiClient.get(
        `/v1/clinicians/${fixtures.user1.id}/clinics`,
      );

      expect(res.status).toBe(200);
      expect(Array.isArray(res.data)).toBe(true);
    });
  });

  describe('error cases', () => {
    it('returns 404 for non-existent clinic', async () => {
      const res = await apiClient.get(
        '/v1/clinics/000000000000000000000000/clinicians',
      );

      expect(res.status).toBe(404);
    });

    it('returns 403 when non-member tries to list clinicians', async () => {
      const user2Client = clientAs(fixtures.user2.sessionToken);
      const res = await user2Client.get(
        `/v1/clinics/${clinicId}/clinicians`,
      );

      expect(res.status).toBe(403);
    });
  });
});
