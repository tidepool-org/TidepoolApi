import { nanoid } from 'nanoid';

const timestamp = new Date().toISOString().replace(/[-:T.Z]/g, '').slice(0, 14);
const suffix = nanoid(6);

export const runPrefix = `t${timestamp}_${suffix}`;

export function uniqueEmail(role: string): string {
  return `test+${runPrefix}_${role}@tidepool.org`;
}

export function uniqueName(label: string): string {
  return `${label}_${runPrefix}`;
}

export function uniqueMrn(seq: number): string {
  return `MRN_${runPrefix}_${String(seq).padStart(3, '0')}`;
}

export function uniqueGuid(): string {
  return nanoid(24);
}
