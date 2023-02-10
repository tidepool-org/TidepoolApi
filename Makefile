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

# import .env file, if one exists in the same folder
-include .env

PLATFORM = ${shell uname -s}

# tools
CHECK_DOC_FORMAT_TOOL = markdownlint
CHECK_DOC_LINK_TOOL = markdown-link-check
CHECK_SPEC_TOOL = spectral
JSON_TOOL = jsonnet
MERGE_SPEC_TOOL = openapi-merge-cli
PUBLISH_TOOL = stoplight
SWAGGER_TOOL = swagger-cli
CODEGEN_TOOL = oapi-codegen --old-config-style

# source folders & files
DOC_FOLDER = docs
SPEC_FOLDER = reference
TEMPLATE_FOLDER = templates
SOURCE_TOC = toc.json
SOURCE_TOC_DOCS = ${shell awk '/"uri":.+\.md/ { print $$2 }' $(SOURCE_TOC) | tr '\n"' ' '}
SOURCE_DOCS = ${shell find $(DOC_FOLDER) -type f -iname '*.md' | sort}
SOURCE_SPECS = ${shell find $(SPEC_FOLDER) -type f -iname '*.yaml' | sort}
SOURCE_SPECS_TOP_LEVEL = ${notdir ${shell find $(SPEC_FOLDER) \( -type d -or -iname '*.yaml' \) -mindepth 1 -maxdepth 1 | sort}}
MERGE_CONFIG_TEMPLATE = $(TEMPLATE_FOLDER)/openapi-merge.jsonnet
MERGE_CONFIG = openapi-merge.json
MERGED_SPEC = combined.v1.yaml

# output folders
BUILD_FOLDER = build
PUBLIC_FOLDER  = $(BUILD_FOLDER)/public
PRIVATE_FOLDER = $(BUILD_FOLDER)/private
SERVER_CODEGEN_FOLDER = $(BUILD_FOLDER)/server
CLIENT_CODEGEN_FOLDER = $(BUILD_FOLDER)/client

# public targets
PUBLIC_DOC_FOLDER   = $(PUBLIC_FOLDER)/$(DOC_FOLDER)
PUBLIC_SPEC_FOLDER  = $(PUBLIC_FOLDER)/$(SPEC_FOLDER)
PUBLIC_TOC          = $(PUBLIC_FOLDER)/$(SOURCE_TOC)
PUBLIC_SPECS        = ${addprefix $(PUBLIC_SPEC_FOLDER)/,$(SOURCE_SPECS_TOP_LEVEL)}
PUBLIC_MERGE_CONFIG = $(PUBLIC_SPEC_FOLDER)/$(MERGE_CONFIG)
PUBLIC_MERGED_SPEC  = $(PUBLIC_SPEC_FOLDER)/$(MERGED_SPEC)

# private targets
PRIVATE_DOC_FOLDER   = $(PRIVATE_FOLDER)/$(DOC_FOLDER)
PRIVATE_SPEC_FOLDER  = $(PRIVATE_FOLDER)/$(SPEC_FOLDER)
PRIVATE_TOC          = $(PRIVATE_FOLDER)/$(SOURCE_TOC)
PRIVATE_SPECS        = ${addprefix $(PRIVATE_SPEC_FOLDER)/,$(SOURCE_SPECS_TOP_LEVEL)}
PRIVATE_MERGE_CONFIG = $(PRIVATE_SPEC_FOLDER)/$(MERGE_CONFIG)
PRIVATE_MERGED_SPEC  = $(PRIVATE_SPEC_FOLDER)/$(MERGED_SPEC)

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
	@egrep '^\w+:' $(MAKEFILE_LIST) | sort | sed -E 's/^(Makefile:)?/\t/'

.PHONY: clean
clean:
	-rm -rv $(BUILD_FOLDER)

.PHONY: clobber
clobber: clean

$(BUILD_FOLDER) $(PUBLIC_FOLDER) $(PUBLIC_SPEC_FOLDER) $(PRIVATE_FOLDER) $(PRIVATE_SPEC_FOLDER) $(SERVER_CODEGEN_FOLDER) $(CLIENT_CODEGEN_FOLDER):
	mkdir -p $@

.PHONY: install_tools
install_tools: install_check_env install_check_tools install_publish_tools

.PHONY: install_check_env
install_check_env:
	npm --version
	go version
ifeq ($(PLATFORM),Darwin)
	brew --version
endif

.PHONY: install_check_tools
install_check_tools:
	npm install --location=global markdownlint-cli@0.33.0
	npm install --location=global markdown-link-check@3.10.3
	npm install --location=global @stoplight/spectral-cli@6.6.0

.PHONY: install_publish_tools
install_publish_tools:
	npm install --location=global @stoplight/cli@6.0.1280
	npm install --location=global openapi-merge-cli@1.3.1
ifeq ($(PLATFORM),Darwin)
	brew install jsonnet@0.19.1
endif
ifeq ($(PLATFORM),Linux)
	go install github.com/google/go-jsonnet/cmd/jsonnet@latest
endif

.PHONY: install_codegen_tools
install_codegen_tools:
	npm install --location=global @apidevtools/swagger-cli@4.0.4
	go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest

.PHONY: check
check: check_tools check_files check_toc

.PHONY: check_tools
check_tools: check_check_tools check_publish_tools check_codegen_tools

.PHONY: check_check_tools
check_check_tools:
	$(CHECK_DOC_FORMAT_TOOL) --version
	$(CHECK_DOC_LINK_TOOL) --version
	$(CHECK_SPEC_TOOL) --version

.PHONY: check_publish_tools
check_publish_tools: check_env
	$(JSON_TOOL) --version
	$(MERGE_SPEC_TOOL) --version
	$(PUBLISH_TOOL) --version

.PHONY: check_codegen_tools
check_codegen_tools:
	$(SWAGGER_TOOL) --version
	$(CODEGEN_TOOL) --version

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
check_files: check_docs check_specs

.PHONY: check_docs
check_docs: $(SOURCE_DOCS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_DOCS)
$(SOURCE_DOCS):
	$(CHECK_DOC_FORMAT_TOOL) $@
	$(CHECK_DOC_LINK_TOOL) $@

.PHONY: check_specs
check_specs: $(SOURCE_SPECS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_SPECS)
$(SOURCE_SPECS):
	$(CHECK_SPEC_TOOL) lint --quiet --ignore-unknown-format $@

.PHONY: check_toc
check_toc: $(SOURCE_TOC)
	@echo ===============================================================
	@echo Check that all files listed in \'$(SOURCE_TOC)\' exist
	@echo ===============================================================
	@echo $(SOURCE_TOC_DOCS) | xargs -n1 -I% sh -c '[[ -f % ]] && echo % || echo % -- FILE NOT FOUND'
	@echo ===============================================================
	@echo Differences between \'$(SOURCE_TOC)\' and documentation files in \'$(DOC_FOLDER)\'
	@echo ===============================================================
	@echo $(SOURCE_DOCS) $(SOURCE_TOC_DOCS) | tr ' ' '\n' | sort | uniq -u | xargs -n1 -I% sh -c 'echo %; exit 1'

.PHONY: list_files
list_files: list_docs list_specs

.PHONY: list_docs
list_docs:
	@echo ===============================================================
	@echo Documentation Files \(${words $(SOURCE_DOCS)}\)
	@echo ===============================================================
	@echo $(SOURCE_DOCS) | xargs -n1

.PHONY: list_specs
list_specs:
	@echo ===============================================================
	@echo API Specification Files \(${words $(SOURCE_SPECS)}\)
	@echo ===============================================================
	@echo $(SOURCE_SPECS) | xargs -n1

.PHONY: prepare
prepare: prepare_public prepare_private

.PHONY: prepare_docs
prepare_docs: public_docs private_docs

.PHONY: prepare_toc
prepare_toc: public_toc private_toc

.PHONY: prepare_specs
prepare_specs: public_specs private_specs

.PHONY: prepare_public
prepare_public: public_docs public_toc public_specs

.PHONY: prepare_private
prepare_private: private_docs private_toc private_specs

.PHONY: public_docs
public_docs: $(PUBLIC_DOC_FOLDER)

$(PUBLIC_DOC_FOLDER): | ${dir $(PUBLIC_DOC_FOLDER)}
	ln -sf ${abspath $(DOC_FOLDER)} $(@D)

.PHONY: private_docs
private_docs: $(PRIVATE_DOC_FOLDER)

$(PRIVATE_DOC_FOLDER): | ${dir $(PRIVATE_DOC_FOLDER)}
	ln -sf ${abspath $(DOC_FOLDER)} $(@D)

.PHONY: public_specs
public_specs: $(PUBLIC_MERGED_SPEC)

$(PUBLIC_MERGED_SPEC): $(PUBLIC_MERGE_CONFIG) $(PUBLIC_SPECS)
	cd $(PUBLIC_SPEC_FOLDER) && $(MERGE_SPEC_TOOL)

$(PUBLIC_MERGE_CONFIG): $(MERGE_CONFIG_TEMPLATE) | ${dir $(PUBLIC_MERGE_CONFIG)}
	$(JSON_TOOL) --ext-str excludeTags="Internal" \
		--ext-str sourceFolder=./ \
		--ext-str outputFile=${notdir $(PUBLIC_MERGED_SPEC)} \
		--output-file $@ \
		$(MERGE_CONFIG_TEMPLATE)

$(PUBLIC_SPECS): | $(PUBLIC_SPEC_FOLDER)
	ln -sf ${abspath ${subst $(PUBLIC_SPEC_FOLDER),$(SPEC_FOLDER),$@}} $@

.PHONY: private_specs
private_specs: $(PRIVATE_MERGED_SPEC)

$(PRIVATE_MERGED_SPEC): $(PRIVATE_MERGE_CONFIG) $(PRIVATE_SPECS)
	cd $(PRIVATE_SPEC_FOLDER) && $(MERGE_SPEC_TOOL)

$(PRIVATE_MERGE_CONFIG): $(MERGE_CONFIG_TEMPLATE) | ${dir $(PRIVATE_MERGE_CONFIG)}
	$(JSON_TOOL) --ext-str excludeTags="" \
		--ext-str sourceFolder=./ \
		--ext-str outputFile=${notdir $(PRIVATE_MERGED_SPEC)} \
		--output-file $@ \
		$(MERGE_CONFIG_TEMPLATE)

$(PRIVATE_SPECS): | $(PRIVATE_SPEC_FOLDER)
	ln -sf ${abspath ${subst $(PRIVATE_SPEC_FOLDER),$(SPEC_FOLDER),$@}} $@

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
	find $(PUBLIC_SPEC_FOLDER) -maxdepth 1 \( \( -type l -and -iname '*.yaml' \) -or -iname $(MERGE_CONFIG) \) -print -delete
	$(PUBLISH_TOOL) push --ci-token $(PUBLIC_STOPLIGHT_TOKEN) --directory $(PUBLIC_FOLDER)

.PHONY: publish_private
publish_private: check_private_env prepare_private | $(PRIVATE_FOLDER)
	find $(PRIVATE_SPEC_FOLDER) -maxdepth 1 \( \( -type l -and -iname '*.yaml' \) -or -iname $(MERGE_CONFIG) \) -print -delete
	$(PUBLISH_TOOL) push --ci-token $(PRIVATE_STOPLIGHT_TOKEN) --directory $(PRIVATE_FOLDER)

##############################################################################################
# adapted from https://github.com/tidepool-org/clinic/blob/master/Makefile
##############################################################################################

.PHONY: generate_clinic_service
generate_clinic_service: generate_clinic_server generate_clinic_client

$(BUILD_FOLDER)/clinic.v1.yaml: $(SPEC_FOLDER)/clinic.v1.yaml | $(BUILD_FOLDER)
	$(SWAGGER_TOOL) bundle $< -o $@ -t yaml

.PHONY: generate_clinic_server
generate_clinic_server: $(BUILD_FOLDER)/clinic.v1.yaml | $(SERVER_CODEGEN_FOLDER)
	$(CODEGEN_TOOL) --exclude-tags=Confirmations --package=api --generate=server $< > $(SERVER_CODEGEN_FOLDER)/gen_server.go
	$(CODEGEN_TOOL) --exclude-tags=Confirmations --package=api --generate=spec $< > $(SERVER_CODEGEN_FOLDER)/gen_spec.go
	$(CODEGEN_TOOL) --exclude-tags=Confirmations --package=api --generate=types $< > $(SERVER_CODEGEN_FOLDER)/gen_types.go

.PHONY: generate_clinic_client
generate_clinic_client: $(BUILD_FOLDER)/clinic.v1.yaml | $(CLIENT_CODEGEN_FOLDER)
	$(CODEGEN_TOOL) --exclude-tags=Confirmations --package=api --generate=types $< > $(CLIENT_CODEGEN_FOLDER)/types.go
	$(CODEGEN_TOOL) --exclude-tags=Confirmations --package=api --generate=client $< > $(CLIENT_CODEGEN_FOLDER)/client.go
