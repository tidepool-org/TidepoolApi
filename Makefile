#
# Tidepool API documentation
# Copyright (c)2022 Tidepool Project
#
# This Makefile is used to prepare Tidepool's API documentation for publishing to the Redocly platform.
# The documentation appears at https://tidepool.redocly.app.
#

#
# import .env file, if one exists in the same folder
#
-include .env

SHELL = /bin/sh

# source folders & files
DOC_FOLDER = docs
SPEC_FOLDER = reference
ASSET_FOLDER = assets
SOURCE_TOC = sidebars.yaml
SOURCE_ROOT_DOC = index.md
SOURCE_TOC_DOCS = ${shell awk '/page:.+\.md/ { print $$3 }' $(SOURCE_TOC) | tr '\n"' ' ' | sort}
SOURCE_DOCS = ${shell { echo $(SOURCE_ROOT_DOC); find $(DOC_FOLDER) -type f -iname '*.md'; } | sort}
SOURCE_DOCS_FOR_TOC = ${shell { echo $(SOURCE_ROOT_DOC); find $(DOC_FOLDER) -type f -iname '*.md' ! -name 'README.md' ! -path 'docs/uploader/checklists/*'; } | sort}
SOURCE_SPECS = ${shell find $(SPEC_FOLDER) -type f -iname '*.yaml' | grep -F -v -f .exclude_specs | sort}
SOURCE_SPECS_TOP_LEVEL = ${shell find $(SPEC_FOLDER) -maxdepth 1 -type f -iname '*.yaml' | sort}
SOURCE_ASSETS = ${shell find $(ASSET_FOLDER) -type f -iname '*.png' | sort}
TOOLS_BIN = tools/bin
NPM_BIN = node_modules/.bin

# output folders
BUILD_FOLDER = build
CODEGEN_FOLDER = $(BUILD_FOLDER)/generated

#############################################################################
# rules
#############################################################################

all: list_targets

.PHONY: list_targets
list_targets:
	@echo TARGETS
	@awk '/^[a-z_]+:/ { print "    ",$$1 }' $(MAKEFILE_LIST) | sort

.PHONY: clean
clean:
	@rm -rf $(BUILD_FOLDER) tools node_modules

.PHONY: clobber
clobber: clean

$(BUILD_FOLDER) $(CODEGEN_FOLDER) $(TOOLS_BIN):
	@mkdir -p $@

GO_TOOLS = \
	$(TOOLS_BIN)/oapi-codegen

$(TOOLS_BIN)/oapi-codegen: $(TOOLS_BIN)
	@GOBIN=$(shell pwd)/$(TOOLS_BIN) go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@v2.5.0


$(NPM_BIN)/%:
	@$(MAKE) install_npm_pkgs

NPM_TOOLS = \
	$(NPM_BIN)/markdown-link-check \
	$(NPM_BIN)/markdownlint \
	$(NPM_BIN)/redocly \
	$(NPM_BIN)/spectral

NPM_PKG_SPECS = \
	@openapi-contrib/json-schema-to-openapi-schema@4.3.2 \
	@redocly/cli@2.31.5 \
	@stoplight/spectral-cli@6.16.0 \
	markdown-link-check@3.14.2 \
	markdownlint-cli@0.48.0

.PHONY: install_npm_pkgs
install_npm_pkgs:
# When using --no-save, any dependencies not included will be deleted, so one
# has to install all the packages all at the same time. But it saves us from
# having to muck with packages.json.
	npm i --prefix $(CURDIR) --no-save --local $(NPM_PKG_SPECS)

.PHONY: install_tools
install_tools: $(GO_TOOLS) $(NPM_TOOLS)

.PHONY: check
check: check_tools check_files check_toc

.PHONY: check_tools
check_tools:
	@[ "$${QUIET:-}" = "true" ] || echo "./scripts/check_doc.sh --self-check"
	@./scripts/check_doc.sh --self-check
	@[ "$${QUIET:-}" = "true" ] || echo "./scripts/check_spec.sh --self-check"
	@./scripts/check_spec.sh --self-check
	@[ "$${QUIET:-}" = "true" ] || echo "./scripts/generate_clinic.sh --self-check"
	@./scripts/generate_clinic.sh --self-check

.PHONY: check_files
check_files: check_docs check_specs check_todo

.PHONY: check_todo
check_todo:
	@[ "$${QUIET:-}" = "true" ] || ( echo "grep -nR TODO docs/* reference/*"; grep -nR TODO docs/* reference/* || true )

.PHONY: check_docs
check_docs: $(SOURCE_DOCS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_DOCS)
$(SOURCE_DOCS):
	@[ "$${QUIET:-}" = "true" ] || echo "/scripts/check_doc.sh $@"
	@./scripts/check_doc.sh $@

# check spec files, plus try to generate code from them
.PHONY: check_specs
check_specs: $(SOURCE_SPECS_TOP_LEVEL) generate_clinic_service

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_SPECS)
$(SOURCE_SPECS):
	@[ "$${QUIET:-}" = "true" ] || echo "./scripts/check_spec.sh $@"
	@./scripts/check_spec.sh $@

.PHONY: check_toc
check_toc: $(SOURCE_TOC)
	@[ "$${QUIET:-}" = "true" ] || ( \
		echo "==============================================================="; \
		echo "Check that all ${words $(SOURCE_TOC_DOCS)} files listed in '$(SOURCE_TOC)' exist"; \
		echo "==============================================================="; \
		ls -1 $(SOURCE_TOC_DOCS); \
		echo "==============================================================="; \
		echo "Differences between '$(SOURCE_TOC)' and documentation files in '$(DOC_FOLDER)'"; \
		echo "==============================================================="; \
	)
	@echo $(SOURCE_TOC_DOCS) $(SOURCE_DOCS_FOR_TOC) | tr ' ' '\n' | sort | uniq -u | grep . && exit 1 || ([ "$${QUIET:-}" = "true" ] || echo no differences detected )

.PHONY: list_files
list_files: list_docs list_specs list_assets

.PHONY: list_docs
list_docs:
	@echo ===============================================================
	@echo Documentation Files \(${words $(SOURCE_DOCS)}\)
	@echo ===============================================================
	@ls -1 $(SOURCE_DOCS)

.PHONY: list_specs
list_specs:
	@echo ===============================================================
	@echo API Specification Files \(${words $(SOURCE_SPECS)}\)
	@echo ===============================================================
	@ls -1 $(SOURCE_SPECS)

.PHONY: list_assets
list_assets:
	@echo ===============================================================
	@echo Asset Files \(${words $(SOURCE_ASSETS)}\)
	@echo ===============================================================
	@ls -1 $(SOURCE_ASSETS)

##############################################################################################
# adapted from https://github.com/tidepool-org/clinic/blob/master/Makefile
##############################################################################################

.PHONY: generate_clinic_service
generate_clinic_service: $(CODEGEN_FOLDER)/clinic/clinic.v1.yaml

$(CODEGEN_FOLDER)/clinic/clinic.v1.yaml: $(SPEC_FOLDER)/clinic.v1.yaml | $(CODEGEN_FOLDER)
	@[ "$${QUIET:-}" = "true" ] || echo "./scripts/generate_clinic.sh $< $@"
	@./scripts/generate_clinic.sh $< $@

##############################################################################################
# integration tests
##############################################################################################

.PHONY: test_integration
test_integration:
	cd tests/integration && npx vitest run

.PHONY: test_integration_suite
test_integration_suite:
	cd tests/integration && npx vitest run suites/$(SUITE).test.ts
