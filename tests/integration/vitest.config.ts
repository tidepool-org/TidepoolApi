import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    dir: 'suites',
    globals: true,
    testTimeout: 30_000,
    hookTimeout: 60_000,
    fileParallelism: false,
    sequence: {
      sequencer: class Sequencer {
        async shard(files: string[]) { return files; }
        async sort(files: string[]) {
          return files.sort((a, b) => a.localeCompare(b));
        }
      },
    },
  },
});
