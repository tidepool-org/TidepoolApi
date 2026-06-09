import { writeFileSync, existsSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import { runPrefix, uniqueEmail } from '../lib/unique.js';
import { createUser, legacyLogin } from '../lib/auth.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
export const FIXTURES_PATH = resolve(__dirname, '../.fixtures.json');
const TEST_PASSWORD = 'Integrati0nTest!';

let _initialized = false;

/** Create test users and write fixtures to disk. Only runs once per process. */
export async function ensureTestUsers(): Promise<void> {
  if (_initialized) return;

  // If fixtures already exist from a prior suite in this run, reuse them
  if (existsSync(FIXTURES_PATH)) {
    _initialized = true;
    return;
  }

  console.log(`\n  Test run prefix: ${runPrefix}`);

  const email1 = uniqueEmail('user1');
  const created1 = await createUser(email1, TEST_PASSWORD);
  const login1 = await legacyLogin(email1, TEST_PASSWORD);

  const email2 = uniqueEmail('user2');
  const created2 = await createUser(email2, TEST_PASSWORD);
  const login2 = await legacyLogin(email2, TEST_PASSWORD);

  const fixtures = {
    runPrefix,
    user1: {
      id: created1.userId,
      email: email1,
      password: TEST_PASSWORD,
      sessionToken: login1.sessionToken,
    },
    user2: {
      id: created2.userId,
      email: email2,
      password: TEST_PASSWORD,
      sessionToken: login2.sessionToken,
    },
    clinic: {},
    patient: {},
    dataSet: {},
    message: {},
    custodialUser: { id: '' },
    patientTagId: '',
    prescriptionId: '',
  };

  writeFileSync(FIXTURES_PATH, JSON.stringify(fixtures, null, 2));
  console.log(`  Created user1: ${fixtures.user1.id} (${email1})`);
  console.log(`  Created user2: ${fixtures.user2.id} (${email2})\n`);

  _initialized = true;
}
