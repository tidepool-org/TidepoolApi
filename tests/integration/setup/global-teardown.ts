export default async function globalTeardown() {
  // Best-effort cleanup is intentionally skipped.
  // Test data uses unique prefixes and does not interfere with other runs.
  // In environments with data retention policies, old test data can be identified
  // by the 'test+t{timestamp}_' email prefix pattern.
  console.log('\n  Teardown complete (test data left in place with unique prefix).\n');
}
