import { readFileSync, writeFileSync, existsSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const FIXTURES_PATH = resolve(__dirname, '../.fixtures.json');

export interface UserFixture {
  id: string;
  email: string;
  password: string;
  sessionToken: string;
  accessToken?: string;
  refreshToken?: string;
}

export interface ClinicFixture {
  id: string;
  shareCode: string;
  name: string;
}

export interface PatientFixture {
  id: string;
  fullName: string;
}

export interface DataSetFixture {
  id: string;
  uploadId: string;
}

export interface MessageFixture {
  id: string;
}

export interface Fixtures {
  runPrefix: string;
  user1: UserFixture;
  user2: UserFixture;
  clinic: Partial<ClinicFixture>;
  patient: Partial<PatientFixture>;
  dataSet: Partial<DataSetFixture>;
  message: Partial<MessageFixture>;
  custodialUser: { id: string };
  patientTagId: string;
  prescriptionId: string;
}

let _cached: Fixtures | null = null;

function load(): Fixtures {
  if (!existsSync(FIXTURES_PATH)) {
    throw new Error('Fixtures file not found. Did global-setup run?');
  }
  return JSON.parse(readFileSync(FIXTURES_PATH, 'utf-8'));
}

/** Lazily-loaded mutable shared fixtures. Reads from disk on first property access. */
export const fixtures: Fixtures = new Proxy({} as Fixtures, {
  get(_target, prop, receiver) {
    if (!_cached) _cached = load();
    return Reflect.get(_cached, prop, receiver);
  },
  set(_target, prop, value, receiver) {
    if (!_cached) _cached = load();
    return Reflect.set(_cached, prop, value, receiver);
  },
});

/** Persist current fixture state to disk for subsequent test files. */
export function saveFixtures(): void {
  if (!_cached) throw new Error('No fixtures loaded to save');
  writeFileSync(FIXTURES_PATH, JSON.stringify(_cached, null, 2));
}
