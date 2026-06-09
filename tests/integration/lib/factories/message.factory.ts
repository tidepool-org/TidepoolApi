import { uniqueGuid } from '../unique.js';

export function newMessagePayload(text?: string) {
  return {
    message: {
      messagetext: text ?? 'Integration test message',
      timestamp: new Date().toISOString(),
      guid: uniqueGuid(),
    },
  };
}

export function editMessagePayload(newText: string) {
  return {
    message: {
      messagetext: newText,
      timestamp: new Date().toISOString(),
    },
  };
}
