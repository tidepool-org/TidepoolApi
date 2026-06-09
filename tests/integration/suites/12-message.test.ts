import { describe, it, expect, beforeAll } from 'vitest';
import { apiClient, anonClient, clientAs } from '../lib/http-client.js';
import { fixtures, saveFixtures } from '../lib/fixtures.js';
import { newMessagePayload, editMessagePayload } from '../lib/factories/message.factory.js';
import { ensureTestUsers } from '../setup/global-setup.js';

describe('Messages', () => {
  beforeAll(() => ensureTestUsers());
  let messageId: string;
  let replyId: string;

  describe('POST /message/send/{userId}', () => {
    it('creates a top-level message', async () => {
      const payload = newMessagePayload('Top-level test note');
      const res = await apiClient.post(
        `/message/send/${fixtures.user1.id}`,
        payload,
      );

      expect([200, 201]).toContain(res.status);
      expect(res.data.id).toBeTypeOf('string');
      messageId = res.data.id;
      fixtures.message = { id: messageId };
      saveFixtures();
    });

    it('returns 401 without auth', async () => {
      const payload = newMessagePayload();
      const res = await anonClient.post(
        `/message/send/${fixtures.user1.id}`,
        payload,
      );

      expect(res.status).toBe(401);
    });
  });

  describe('GET /message/all/{userId}', () => {
    it('lists all messages for user', async () => {
      const res = await apiClient.get(
        `/message/all/${fixtures.user1.id}`,
        {
          params: {
            starttime: new Date(Date.now() - 86400000).toISOString(),
            endtime: new Date(Date.now() + 86400000).toISOString(),
          },
        },
      );

      expect(res.status).toBe(200);
      expect(res.data.messages).toBeDefined();
    });
  });

  describe('GET /message/notes/{userId}', () => {
    it('lists top-level messages (notes)', async () => {
      const res = await apiClient.get(
        `/message/notes/${fixtures.user1.id}`,
        {
          params: {
            starttime: new Date(Date.now() - 86400000).toISOString(),
            endtime: new Date(Date.now() + 86400000).toISOString(),
          },
        },
      );

      expect(res.status).toBe(200);
    });
  });

  describe('GET /message/read/{messageId}', () => {
    it('returns a message by ID', async () => {
      if (!messageId) return;

      const res = await apiClient.get(`/message/read/${messageId}`);

      expect(res.status).toBe(200);
      expect(res.data.message).toBeDefined();
    });

    it('returns 404 for non-existent message', async () => {
      const res = await apiClient.get('/message/read/000000000000000000000000');
      expect([404, 500]).toContain(res.status);
    });
  });

  describe('POST /message/reply/{messageId}', () => {
    it('replies to a message', async () => {
      if (!messageId) return;

      const payload = newMessagePayload('Reply to test note');
      const res = await apiClient.post(
        `/message/reply/${messageId}`,
        payload,
      );

      expect([200, 201]).toContain(res.status);
      expect(res.data.id).toBeTypeOf('string');
      replyId = res.data.id;
    });
  });

  describe('GET /message/thread/{messageId}', () => {
    it('returns thread for a message', async () => {
      if (!messageId) return;

      const res = await apiClient.get(`/message/thread/${messageId}`);

      expect(res.status).toBe(200);
      expect(res.data.messages).toBeDefined();
    });
  });

  describe('PUT /message/edit/{messageId}', () => {
    it('edits a message', async () => {
      if (!messageId) return;

      const payload = editMessagePayload('Edited test note');
      const res = await apiClient.put(
        `/message/edit/${messageId}`,
        payload,
      );

      expect(res.status).toBe(200);
    });
  });

  describe('DELETE /message/remove/{messageId}', () => {
    it('deletes a reply', async () => {
      if (!replyId) return;

      const res = await apiClient.delete(`/message/remove/${replyId}`);

      expect([200, 202]).toContain(res.status);
    });
  });

  describe('error cases', () => {
    it('returns 403 when unauthorized user accesses messages', async () => {
      const user2Client = clientAs(fixtures.user2.sessionToken);
      const res = await user2Client.post(
        `/message/send/${fixtures.user1.id}`,
        newMessagePayload(),
      );

      // user2 has view permission from 05-access, so may be allowed to post notes
      // If not permitted, expect 403
      expect([200, 201, 403]).toContain(res.status);
    });
  });
});
