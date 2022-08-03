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

CHECK_DOC_TOOL = markdownlint
CHECK_SPEC_TOOL = spectral lint --quiet --ignore-unknown-format
PUBLISH_TOOL = stoplight push

DOC_FOLDER = docs
SPEC_FOLDER = reference
TEMPLATE_FOLDER = templates

BUILD_FOLDER = build
PUBLIC_FOLDER  = $(BUILD_FOLDER)/public
PRIVATE_FOLDER = $(BUILD_FOLDER)/private

SOURCE_TOC = $(TEMPLATE_FOLDER)/toc.json
TARGET_PUBLIC_TOC  = $(PUBLIC_FOLDER)/${notdir $(SOURCE_TOC)}
TARGET_PRIVATE_TOC = $(PRIVATE_FOLDER)/${notdir $(SOURCE_TOC)}

SOURCE_DOCS = ${shell find $(DOC_FOLDER) -type f -iname '*.md' | sort}
TARGET_PUBLIC_DOCS  = ${addprefix $(PUBLIC_FOLDER)/, $(SOURCE_DOCS)}
TARGET_PRIVATE_DOCS = ${addprefix $(PRIVATE_FOLDER)/, $(SOURCE_DOCS)}

SOURCE_SPECS = ${shell find $(SPEC_FOLDER) -type f -iname '*.yaml' | sort}
COMBINED_SPEC = $(SPEC_FOLDER)/combined.v1.yaml
TARGET_PUBLIC_SPECS  = ${addprefix $(PUBLIC_FOLDER)/, $(SOURCE_SPECS)}
TARGET_PRIVATE_SPECS = ${addprefix $(PRIVATE_FOLDER)/, $(SOURCE_SPECS)}

all: check_files publish

.PHONY: clean
clean:
	-rm -rv $(BUILD_FOLDER)

.PHONY: install_tools
install_tools:
	npm install --location=global markdownlint-cli
	npm install --location=global @stoplight/cli
	npm install --location=global @stoplight/spectral-cli
	npm install --location=global openapi-merge-cli
PLATFORM := $(shell uname -s)
ifeq ($(PLATFORM),Darwin)
	brew install jsonnet
endif
ifeq ($(PLATFORM),Linux)
	git clone https://github.com/Microsoft/vcpkg.git
	cd vcpkg
	./bootstrap-vcpkg.sh
	./vcpkg integrate install
	vcpkg install jsonnet
endif

.PHONY: check_env
check_env:
	test -n "$(PUBLIC_STOPLIGHT_TOKEN)" # PUBLIC_STOPLIGHT_TOKEN
	test -n "$(PRIVATE_STOPLIGHT_TOKEN)" # PRIVATE_STOPLIGHT_TOKEN

.PHONY: check_files
check_files: check_docs check_specs

.PHONY: check_docs
check_docs:
	@for file in $(SOURCE_DOCS); \
	do \
		echo $(CHECK_DOC_TOOL) $$file; \
		$(CHECK_DOC_TOOL) $$file; \
	done

.PHONY: check_specs
check_specs:
	@# if we pass *.yaml directly to `spectral` lint, it mixes all the files together, hence the loop
	@for file in $(SOURCE_SPECS); \
	do \
		echo $(CHECK_SPEC_TOOL) $$file; \
		$(CHECK_SPEC_TOOL) $$file; \
	done

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
	jsonnet --ext-str excludeTags="Internal" \
		--ext-str sourceFolder=$(SPEC_FOLDER)/ \
		--ext-str outputFile=$(COMBINED_SPEC) \
		--output-file $(PUBLIC_FOLDER)/openapi-merge.json \
		$(TEMPLATE_FOLDER)/openapi-merge.jsonnet
	cd $(PUBLIC_FOLDER) && npx openapi-merge-cli
	find $(PUBLIC_FOLDER) -maxdepth 2 \( -iname '*.yaml' -or -iname openapi-merge.json \) -not -ipath '*$(COMBINED_SPEC)*' -delete

$(TARGET_PUBLIC_SPECS):
	mkdir -p $(@D)
	cp ${subst $(PUBLIC_FOLDER)/,,$@} $@

.PHONY: private_specs
private_specs: $(TARGET_PRIVATE_SPECS)
	@# the sourceFolder and outputFile must be relative to the config file location!
	jsonnet --ext-str excludeTags="" \
		--ext-str sourceFolder=$(SPEC_FOLDER)/ \
		--ext-str outputFile=$(COMBINED_SPEC) \
		--output-file $(PRIVATE_FOLDER)/openapi-merge.json \
		$(TEMPLATE_FOLDER)/openapi-merge.jsonnet
	cd $(PRIVATE_FOLDER) && npx openapi-merge-cli
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
publish_public: check_env prepare_public
	cd $(PUBLIC_FOLDER) && $(PUBLISH_TOOL) --ci-token $(PUBLIC_STOPLIGHT_TOKEN) 

.PHONY: publish_private
publish_private: check_env prepare_private
	cd $(PRIVATE_FOLDER) && $(PUBLISH_TOOL) --ci-token $(PRIVATE_STOPLIGHT_TOKEN) 
