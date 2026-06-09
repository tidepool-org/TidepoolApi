import { describe, it, expect } from 'vitest';
import { anonClient } from '../lib/http-client.js';

describe('Health / Smoke', () => {
  it('GET /info returns minimum client versions', async () => {
    const res = await anonClient.get('/info');
    expect(res.status).toBe(200);
    expect(res.data).toBeTypeOf('object');
  });
});
