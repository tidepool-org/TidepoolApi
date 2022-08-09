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
PLATFORM = ${shell uname -s}

CHECK_DOC_TOOL = markdownlint
CHECK_SPEC_TOOL = spectral
JSON_TOOL = jsonnet
MERGE_SPEC_TOOL = npx openapi-merge-cli
PUBLISH_TOOL = stoplight

DOC_FOLDER = docs
SPEC_FOLDER = reference
TEMPLATE_FOLDER = templates

BUILD_FOLDER = build
PUBLIC_FOLDER  = $(BUILD_FOLDER)/public
PRIVATE_FOLDER = $(BUILD_FOLDER)/private

SOURCE_TOC = toc.json
TARGET_PUBLIC_TOC  = $(PUBLIC_FOLDER)/${notdir $(SOURCE_TOC)}
TARGET_PRIVATE_TOC = $(PRIVATE_FOLDER)/${notdir $(SOURCE_TOC)}

SOURCE_DOCS = ${shell find $(DOC_FOLDER) -type f -iname '*.md' | sort}
TARGET_PUBLIC_DOCS  = ${addprefix $(PUBLIC_FOLDER)/, $(SOURCE_DOCS)}
TARGET_PRIVATE_DOCS = ${addprefix $(PRIVATE_FOLDER)/, $(SOURCE_DOCS)}

SOURCE_SPECS = ${shell find $(SPEC_FOLDER) -type f -iname '*.yaml' | sort}
COMBINED_SPEC = combined.v1.yaml
TARGET_PUBLIC_SPECS  = ${addprefix $(PUBLIC_FOLDER)/, $(SOURCE_SPECS)}
TARGET_PRIVATE_SPECS = ${addprefix $(PRIVATE_FOLDER)/, $(SOURCE_SPECS)}

all: check_files publish

.PHONY: clean
clean:
	-rm -rv $(BUILD_FOLDER)

.PHONY: install_tools
install_tools: install_check_tools install_publish_tools

.PHONY: install_check_tools
install_check_tools:
	npm install --location=global markdownlint-cli
	npm install --location=global @stoplight/spectral-cli

.PHONY: install_publish_tools
install_publish_tools:
	npm install --location=global @stoplight/cli
	npm install --location=global openapi-merge-cli
ifeq ($(PLATFORM),Darwin)
	brew install jsonnet
endif
ifeq ($(PLATFORM),Linux)
	go install github.com/google/go-jsonnet/cmd/jsonnet@latest
endif

.PHONY: check_env
check_env: check_public_env check_private_env
	$(CHECK_DOC_TOOL) --version
	$(CHECK_SPEC_TOOL) --version
	$(PUBLISH_TOOL) --version
	$(MERGE_SPEC_TOOL) --version
	$(JSON_TOOL) --version

.PHONY: check_public_env
check_public_env:
	test -n "$(PUBLIC_STOPLIGHT_TOKEN)" # PUBLIC_STOPLIGHT_TOKEN

.PHONY: check_private_env
check_private_env:
	test -n "$(PRIVATE_STOPLIGHT_TOKEN)" # PRIVATE_STOPLIGHT_TOKEN

.PHONY: check_files
check_files: check_docs check_specs

.PHONY: check_docs
check_docs: $(SOURCE_DOCS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_DOCS)
$(SOURCE_DOCS):
	$(CHECK_DOC_TOOL) $@

.PHONY: check_specs
check_specs: $(SOURCE_SPECS)

# these are not really phony, just designating them as such to force Make to run the check tool
.PHONY: $(SOURCE_SPECS)
$(SOURCE_SPECS):
	$(CHECK_SPEC_TOOL) lint --quiet --ignore-unknown-format $@

.PHONY: list_files
list_files: list_docs list_specs

.PHONY: list_docs
list_docs:
	@echo ===============================================================
	@echo Documentation Files \(${words $(SOURCE_DOCS)}\)
	@echo ===============================================================
	@for file in $(SOURCE_DOCS); \
	do \
		echo $$file; \
	done

.PHONY: list_specs
list_specs:
	@echo ===============================================================
	@echo API Specification Files \(${words $(SOURCE_SPECS)}\)
	@echo ===============================================================
	@for file in $(SOURCE_SPECS); \
	do \
		echo $$file; \
	done

.PHONY: prepare
prepare: prepare_public prepare_private

.PHONY: prepare_public
prepare_public: public_docs public_toc public_specs

.PHONY: prepare_private
prepare_private: private_docs private_toc private_specs

.PHONY: public_docs
public_docs: $(TARGET_PUBLIC_DOCS)

$(TARGET_PUBLIC_DOCS):
	mkdir -p $(@D)
	cp ${subst $(PUBLIC_FOLDER)/,,$@} $@

.PHONY: private_docs
private_docs: $(TARGET_PRIVATE_DOCS)

$(TARGET_PRIVATE_DOCS):
	mkdir -p $(@D)
	cp ${subst $(PRIVATE_FOLDER)/,,$@} $@

.PHONY: public_specs
public_specs: $(TARGET_PUBLIC_SPECS)
	@# the sourceFolder and outputFile must be relative to the config file location!
	$(JSON_TOOL) --ext-str excludeTags="Internal" \
		--ext-str sourceFolder=./ \
		--ext-str outputFile=$(COMBINED_SPEC) \
		--output-file $(PUBLIC_FOLDER)/$(SPEC_FOLDER)/openapi-merge.json \
		$(TEMPLATE_FOLDER)/openapi-merge.jsonnet
	cd $(PUBLIC_FOLDER)/$(SPEC_FOLDER) && $(MERGE_SPEC_TOOL)
	find $(PUBLIC_FOLDER) -maxdepth 2 \( -iname '*.yaml' -or -iname openapi-merge.json \) -not -ipath '*$(COMBINED_SPEC)*' -delete

$(TARGET_PUBLIC_SPECS):
	mkdir -p $(@D)
	cp ${subst $(PUBLIC_FOLDER)/,,$@} $@

.PHONY: private_specs
private_specs: $(TARGET_PRIVATE_SPECS)
	@# the sourceFolder and outputFile must be relative to the config file location!
	$(JSON_TOOL) --ext-str excludeTags="" \
		--ext-str sourceFolder=./ \
		--ext-str outputFile=$(COMBINED_SPEC) \
		--output-file $(PRIVATE_FOLDER)/$(SPEC_FOLDER)/openapi-merge.json \
		$(TEMPLATE_FOLDER)/openapi-merge.jsonnet
	cd $(PRIVATE_FOLDER)/$(SPEC_FOLDER) && $(MERGE_SPEC_TOOL)
	find $(PRIVATE_FOLDER) -maxdepth 2 \( -iname '*.yaml' -or -iname openapi-merge.json \) -not -ipath '*$(COMBINED_SPEC)*' -delete

$(TARGET_PRIVATE_SPECS):
	mkdir -p $(@D)
	cp ${subst $(PRIVATE_FOLDER)/,,$@} $@

.PHONY: public_toc
public_toc: $(TARGET_PUBLIC_TOC)

$(TARGET_PUBLIC_TOC): $(SOURCE_TOC)
	mkdir -p $(@D)
	cp $< $@

.PHONY: private_toc
private_toc: $(TARGET_PRIVATE_TOC)

$(TARGET_PRIVATE_TOC): $(SOURCE_TOC)
	mkdir -p $(@D)
	cp $< $@

.PHONY: publish
publish: publish_public publish_private

.PHONY: publish_public
publish_public: check_public_env prepare_public
	cd $(PUBLIC_FOLDER) && $(PUBLISH_TOOL) push --ci-token $(PUBLIC_STOPLIGHT_TOKEN) 

.PHONY: publish_private
publish_private: check_private_env prepare_private
	cd $(PRIVATE_FOLDER) && $(PUBLISH_TOOL) push --ci-token $(PRIVATE_STOPLIGHT_TOKEN) 
