import { uniqueName } from '../unique.js';

export function newClinicPayload() {
  const name = uniqueName('TestClinic');
  return {
    name,
    address: '123 Test Street',
    city: 'Test City',
    postalCode: '94105',
    state: 'CA',
    country: 'US',
    clinicType: 'provider_practice',
    clinicSize: '0-249',
    preferredBgUnits: 'mg/dL',
    timezone: 'US/Pacific',
  };
}

export function updateClinicPayload(original: Record<string, unknown>) {
  return {
    ...original,
    city: 'Updated City',
  };
}

export function newPatientTagPayload() {
  return {
    name: uniqueName('Tag'),
  };
}
