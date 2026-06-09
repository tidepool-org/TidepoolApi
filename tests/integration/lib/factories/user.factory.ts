import { uniqueEmail } from '../unique.js';

export function newUserPayload(role: string, password: string) {
  const email = uniqueEmail(role);
  return {
    payload: {
      username: email,
      emails: [email],
      password,
    },
    email,
    password,
  };
}

export function updateUserPayload() {
  return {
    updates: {
      termsAccepted: new Date().toISOString(),
    },
  };
}

export function newCustodialUserPayload(role: string) {
  const email = uniqueEmail(`custodial_${role}`);
  return {
    payload: {
      username: email,
      emails: [email],
    },
    email,
  };
}
