import { uniqueEmail, uniqueMrn, uniqueName } from '../unique.js';

export function newPatientPayload(seq: number = 1) {
  return {
    fullName: uniqueName(`Patient${seq}`),
    birthDate: '1990-01-15',
    email: uniqueEmail(`patient${seq}`),
    mrn: uniqueMrn(seq),
    targetDevices: [],
  };
}

export function updatePatientPayload(original: Record<string, unknown>) {
  return {
    ...original,
    fullName: uniqueName('UpdatedPatient'),
  };
}
