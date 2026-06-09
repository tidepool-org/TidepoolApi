# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TidepoolApi is the API documentation and specification repository for the Tidepool diabetes data platform. It contains OpenAPI 3.0 specs, narrative Markdown/Markdoc documentation, and tooling for validation and code generation. Published to https://tidepool.redocly.app.

## Build Commands

Prerequisites: Node.js >= 16, Go >= 1.19.

```bash
make install_tools              # Install all npm + Go tools (run first)
make check                      # Run ALL checks (docs, specs, TOC, TODOs)
make check_docs                 # Validate all markdown files (markdownlint + link-check)
make check_specs                # Validate all OpenAPI specs (spectral + redocly lint) + generate clinic code
make check_toc                  # Verify sidebars.yaml matches docs/ contents
make check_todo                 # List remaining TODOs
make generate_clinic_service    # Generate Go code from clinic.v1.yaml via oapi-codegen
make clean                      # Remove build/, tools/, node_modules/
make list_targets               # Show all Make targets
```

Validate a single file directly:
```bash
./scripts/check_doc.sh docs/authentication.md    # Lint + link-check one markdown file
./scripts/check_spec.sh reference/clinic.v1.yaml  # Spectral + redocly lint one spec
```

## Architecture

### API Specifications (`reference/`)

OpenAPI 3.0.0 YAML files, one per service, named `{service}.v{version}.yaml`:
- **clinic.v1.yaml** - Clinics service (largest spec, also used for Go code generation)
- **auth.v2.yaml** - Authentication (v2 is active; v1 is excluded)
- **data.v1.yaml**, **access.v1.yaml**, **blob.v1.yaml**, **confirm.v1.yaml**, **export.v1.yaml**, **message.v1.yaml**, **metadata.v1.yaml**, **metrics.v1.yaml**, **prescription.v1.yaml**, **summary.v1.yaml**, **task.v1.yaml**, **general.v1.yaml**, **alerts.v1.yaml**

Shared components in `reference/common/`:
- `models/` - Reusable data schemas (referenced via `$ref: ./common/models/...`)
- `responses/` - Standard HTTP error responses
- `security/` - Auth schemes (Bearer token, Session token, Server token)
- `headers/`, `parameters/` - Shared headers and query parameters

Three specs are excluded from the build (listed in `.exclude_specs`): redox, xealth.v2, auth.v1.

### Documentation (`docs/`)

~60 Markdoc-enhanced markdown files covering integration guides, device data types, authentication, etc. Navigation structure defined in `sidebars.yaml` - every doc must appear there (enforced by `make check_toc`).

### Code Generation

`make generate_clinic_service` bundles the clinic spec and runs oapi-codegen to produce Go server/client code in `build/generated/clinic/`. This mirrors what the [clinic repo](https://github.com/tidepool-org/clinic) does.

## Validation Pipeline

Doc checks run **markdownlint** then **markdown-link-check** then a custom ref-links checker. Spec checks run **spectral lint** then **redocly lint**. CI (`.github/workflows/check.yml`) runs docs, specs, TOC, and TODO checks as parallel matrix jobs.

## Linting Configuration

- **`.spectral.yaml`** - Extends `spectral:oas`; Redocly rules in `redocly.yaml` disable ambiguous-paths, operation-2xx-response, operation-4xx-response
- **`.markdownlint.yaml`** - No line-length limit (MD013 off); allows specific inline HTML elements (tables, MathML); descriptive link text rule disabled
- **`.markdown-link-check.json`** - Ignores certain external domains (FDA, some GitHub URLs)

## Integration Tests

Located in `tests/integration/`. TypeScript + Vitest test suite that exercises all API endpoints against a live environment.

```bash
cd tests/integration && npm install   # Install test dependencies (first time)
make test_integration                 # Run full suite sequentially
make test_integration_suite SUITE=07-clinic  # Run a single suite
```

Configuration: copy `tests/integration/.env.example` to `.env` and fill in credentials. Tests create their own users/data with unique prefixes per run so they don't interfere with each other or require DB cleanup.

Test files in `tests/integration/suites/` are numbered 00-18 and run sequentially. Shared state (user IDs, clinic IDs) flows between suites via `.fixtures.json`.

## Conventions

- API paths follow `/v1/{resource}` pattern
- Schema names use PascalCase; filenames use `snake.v1.yaml` pattern
- Specs reference shared components via relative `$ref` paths into `common/`
- Each spec has `x-tidepool-service` metadata pointing to its source repository
- Environments: integration, production, dev1, qa1, qa2
