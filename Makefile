#
# Tidepool API documentation
# Copyright (c)2022 Tidepool Project
#
# This Makefile prepares and publishes Tidepool's API documentation to the Stoplight platform.
# The documentation appears at https://tidepool.stoplight.io/.
#
# We publish two versions:
#
# 1) The public version
#    This includes only APIs that are callable by anyone.
#    Almost all of them require a valid Tidepool access token.
#
# 2) The private or "full" version
#    This includes all public APIs as well as internal APIs that are callable either only inside Tidepool's VPC, or only with server tokens.
#    This is keeping with the spirit of open-source and transparency, even those APIs are not useful to anyone outside of Tidepool.
#    Afterall, their implementations are readily visible to anyone who looks through our source code.
#
# This script requires two tokens in order to publish those two versions to Stoplight, where they are configured as
# two separate projects. The tokens can be found in each projects settings:
#
#    https://tidepool.stoplight.io/settings/{project}/automation
#
# The tokens are passed in as environment variables:
#   * PUBLIC_STOPLIGHT_TOKEN
#   * PRIVATE_STOPLIGHT_TOKEN
# Do NOT commit plaintext versions of these tokens environment variables into the repository!
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
SOURCE_TOC = toc.json
SOURCE_TOC_DOCS = ${shell awk '/"uri":.+\.md/ { print $$2 }' $(SOURCE_TOC) | tr '\n"' ' ' | sort}
SOURCE_DOCS = ${shell find $(DOC_FOLDER) -type f -iname '*.md' | sort}
SOURCE_SPECS = ${shell find $(SPEC_FOLDER) -type f -iname '*.yaml' | fgrep -v -f .exclude_specs | sort}
SOURCE_SPECS_TOP_LEVEL = ${shell find $(SPEC_FOLDER) -maxdepth 1 -type f -iname '*.yaml' | sort}
MERGED_SPEC = combined.v1.yaml
STATIC_DOCS = docs/index.html
SOURCE_ASSETS = ${shell find $(ASSET_FOLDER) -type f -iname '*.png' | sort}
TOOLS_BIN = tools/bin
NPM_BIN = node_modules/.bin

# output folders
BUILD_FOLDER = build
PUBLIC_FOLDER  = $(BUILD_FOLDER)/public
PRIVATE_FOLDER = $(BUILD_FOLDER)/private
CODEGEN_FOLDER = $(BUILD_FOLDER)/generated

# public targets
PUBLIC_DOC_FOLDER   = $(PUBLIC_FOLDER)/$(DOC_FOLDER)
PUBLIC_SPEC_FOLDER  = $(PUBLIC_FOLDER)/$(SPEC_FOLDER)
PUBLIC_ASSET_FOLDER = $(PUBLIC_FOLDER)/$(ASSET_FOLDER)
PUBLIC_TOC          = $(PUBLIC_FOLDER)/$(SOURCE_TOC)
PUBLIC_SPECS        = ${subst $(SPEC_FOLDER),$(PUBLIC_SPEC_FOLDER),$(SOURCE_SPECS_TOP_LEVEL)}
PUBLIC_MERGED_SPEC  = $(PUBLIC_SPEC_FOLDER)/$(MERGED_SPEC)
PUBLIC_STATIC_DOCS  = $(PUBLIC_SPEC_FOLDER)/$(STATIC_DOCS)

# private targets
PRIVATE_DOC_FOLDER   = $(PRIVATE_FOLDER)/$(DOC_FOLDER)
PRIVATE_SPEC_FOLDER  = $(PRIVATE_FOLDER)/$(SPEC_FOLDER)
PRIVATE_ASSET_FOLDER = $(PRIVATE_FOLDER)/$(ASSET_FOLDER)
PRIVATE_TOC          = $(PRIVATE_FOLDER)/$(SOURCE_TOC)
PRIVATE_SPECS        = ${subst $(SPEC_FOLDER),$(PRIVATE_SPEC_FOLDER),$(SOURCE_SPECS_TOP_LEVEL)}
PRIVATE_MERGED_SPEC  = $(PRIVATE_SPEC_FOLDER)/$(MERGED_SPEC)

#############################################################################
# functions
#############################################################################

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

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
	-rm -rv $(BUILD_FOLDER) tools node_modules

.PHONY: clobber
clobber: clean

$(BUILD_FOLDER) $(PUBLIC_FOLDER) $(PUBLIC_SPEC_FOLDER) $(PRIVATE_FOLDER) $(PRIVATE_SPEC_FOLDER) $(CODEGEN_FOLDER) $(TOOLS_BIN):
	mkdir -p $@

GO_TOOLS = \
	$(TOOLS_BIN)/jsonnet \
	$(TOOLS_BIN)/oapi-codegen

$(TOOLS_BIN)/jsonnet: $(TOOLS_BIN)
	GOBIN=$(shell pwd)/$(TOOLS_BIN) go install github.com/google/go-jsonnet/cmd/jsonnet@v0.20.0

$(TOOLS_BIN)/oapi-codegen: $(TOOLS_BIN)
	GOBIN=$(shell pwd)/$(TOOLS_BIN) go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.13.4

$(NPM_BIN)/%:
	$(MAKE) install_npm_pkgs

NPM_TOOLS = \
	$(NPM_BIN)/markdown-link-check \
	$(NPM_BIN)/markdownlint \
	$(NPM_BIN)/openapi-merge-cli \
	$(NPM_BIN)/redocly \
	$(NPM_BIN)/spectral \
	$(NPM_BIN)/stoplight \
	$(NPM_BIN)/swagger-cli

# TODO: update markdown-link-check version. Right now there's a bug in
# 3.12.x. 3.11.2 is the latest version before 3.12.x. See
# https://github.com/tcort/markdown-link-check/issues/304
NPM_PKG_SPECS = \
	@apidevtools/swagger-cli@^4.0.4 \
	@openapi-contrib/json-schema-to-openapi-schema@^2.2.5 \
	@redocly/cli@^1.0.0-rc.3 \
	@stoplight/cli@^6.0.1280 \
	@stoplight/spectral-cli@^6.8.0 \
	markdown-link-check@3.11.2 \
	markdownlint-cli@^0.33.0 \
	openapi-merge-cli@1.3.1

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
	./scripts/check_doc.sh --self-check
	./scripts/check_spec.sh --self-check
	./scripts/bundle_spec.sh --self-check
	./scripts/merge_specs.sh --self-check
	./scripts/publish.sh --self-check
	./scripts/generate_clinic.sh --self-check
	./scripts/generate_docs.sh --self-check

.PHONY: check_env
check_env: check_public_env check_private_env
	@echo environment is OK

.PHONY: check_public_env
check_public_env:
	@:${call check_defined, PUBLIC_STOPLIGHT_TOKEN}

.PHONY: check_private_env
check_private_env:
	@:${call check_defined, PRIVATE_STOPLIGHT_TOKEN}

.PHONY: check_files
check_files: check_docs check_specs check_todo

.PHONY: check_todo
check_todo:
	-grep -nR TODO docs/* reference/*

.PHONY: check_docs
check_docs: $(SOURCE_DOCS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_DOCS)
$(SOURCE_DOCS):
	./scripts/check_doc.sh $@

# check spec files, plus try to generate code from them
.PHONY: check_specs
check_specs: $(SOURCE_SPECS_TOP_LEVEL) generate_clinic_service

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_SPECS)
$(SOURCE_SPECS):
	./scripts/check_spec.sh $@

.PHONY: check_toc
check_toc: $(SOURCE_TOC)
	@echo ===============================================================
	@echo Check that all ${words $(SOURCE_TOC_DOCS)} files listed in \'$(SOURCE_TOC)\' exist
	@echo ===============================================================
	@ls -1 $(SOURCE_TOC_DOCS)
	@echo ===============================================================
	@echo Differences between \'$(SOURCE_TOC)\' and documentation files in \'$(DOC_FOLDER)\'
	@echo ===============================================================
	@echo $(SOURCE_TOC_DOCS) $(SOURCE_DOCS) | tr ' ' '\n' | sort | uniq -u | grep . && exit 1 || echo no differences detected

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

.PHONY: prepare
prepare: prepare_public prepare_private

.PHONY: prepare_docs
prepare_docs: public_docs private_docs

.PHONY: prepare_toc
prepare_toc: public_toc private_toc

.PHONY: prepare_specs
prepare_specs: public_specs private_specs

.PHONY: prepare_public
prepare_public: public_docs public_toc public_specs public_assets

.PHONY: prepare_private
prepare_private: private_docs private_toc private_specs private_assets

.PHONY: public_docs
public_docs: $(PUBLIC_DOC_FOLDER)

$(PUBLIC_DOC_FOLDER): | $(PUBLIC_FOLDER)
	ln -sf ${abspath $(DOC_FOLDER)} $(@D)

.PHONY: private_docs
private_docs: $(PRIVATE_DOC_FOLDER)

$(PRIVATE_DOC_FOLDER): | $(PRIVATE_FOLDER)
	ln -sf ${abspath $(DOC_FOLDER)} $(@D)

.PHONY: public_specs
public_specs: $(PUBLIC_MERGED_SPEC)

$(PUBLIC_MERGED_SPEC): $(PUBLIC_SPECS) | $(PUBLIC_SPEC_FOLDER)
	./scripts/merge_specs.sh $@ Internal

$(PUBLIC_SPECS): | $(PUBLIC_SPEC_FOLDER)
	./scripts/bundle_spec.sh ${abspath ${subst $(PUBLIC_SPEC_FOLDER),$(SPEC_FOLDER),$@}} $@

.PHONY: private_specs
private_specs: $(PRIVATE_MERGED_SPEC)

$(PRIVATE_MERGED_SPEC): $(PRIVATE_SPECS) | $(PRIVATE_SPEC_FOLDER)
	./scripts/merge_specs.sh $@

$(PRIVATE_SPECS): | $(PRIVATE_SPEC_FOLDER)
	./scripts/bundle_spec.sh ${abspath ${subst $(PRIVATE_SPEC_FOLDER),$(SPEC_FOLDER),$@}} $@

.PHONY: public_static_docs
public_static_docs: $(PUBLIC_STATIC_DOCS)

$(PUBLIC_STATIC_DOCS): public_specs
	./scripts/generate_docs.sh $(PUBLIC_MERGED_SPEC) $@

.PHONY: public_assets
public_assets: $(PUBLIC_ASSET_FOLDER)

$(PUBLIC_ASSET_FOLDER): | $(PUBLIC_FOLDER)
	ln -sf ${abspath $(ASSET_FOLDER)} $(@D)

.PHONY: private_assets
private_assets: $(PRIVATE_ASSET_FOLDER)

$(PRIVATE_ASSET_FOLDER): | $(PRIVATE_FOLDER)
	ln -sf ${abspath $(ASSET_FOLDER)} $(@D)

.PHONY: public_toc
public_toc: $(PUBLIC_TOC)

$(PUBLIC_TOC): $(SOURCE_TOC) | $(PUBLIC_FOLDER)
	ln -sf ${abspath $<} $@

.PHONY: private_toc
private_toc: $(PRIVATE_TOC)

$(PRIVATE_TOC): $(SOURCE_TOC) | $(PRIVATE_FOLDER)
	ln -sf ${abspath $<} $@

.PHONY: publish
publish: publish_public publish_private

.PHONY: publish_public
publish_public: check_public_env prepare_public | $(PUBLIC_FOLDER)
	./scripts/publish.sh $(PUBLIC_FOLDER) $(PUBLIC_STOPLIGHT_TOKEN)

.PHONY: publish_private
publish_private: check_private_env prepare_private | $(PRIVATE_FOLDER)
	./scripts/publish.sh $(PRIVATE_FOLDER) $(PRIVATE_STOPLIGHT_TOKEN)

##############################################################################################
# adapted from https://github.com/tidepool-org/clinic/blob/master/Makefile
##############################################################################################

.PHONY: generate_clinic_service
generate_clinic_service: $(CODEGEN_FOLDER)/clinic/clinic.v1.yaml

$(CODEGEN_FOLDER)/clinic/clinic.v1.yaml: $(SPEC_FOLDER)/clinic.v1.yaml | $(CODEGEN_FOLDER)
	./scripts/generate_clinic.sh $< $@
