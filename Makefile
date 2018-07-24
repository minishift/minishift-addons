# Copyright (C) 2018 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Setting up paths
REPOPATH ?= github.com/minishift/minishift-addons
TEST_DIR ?= $(CURDIR)/testing
BIN_DIR ?= $(TEST_DIR)/bin

MINISHIFT_LATEST_URL=http://artifacts.ci.centos.org/minishift/minishift/master/latest

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
ORG := github.com/minishift

# Platfrom dependency
ifeq ($(GOOS),windows)
	IS_EXE := .exe
endif

# Integration tests
TIMEOUT ?= 3600s
MINISHIFT_BINARY ?= $(TEST_DIR)/bin/minishift$(IS_EXE)

# Make target definitions
default:
	@echo "Nothing to make. Run 'make integration' to run integration tests."

.PHONY: integration
integration: ADDON ?= ""
integration: vendor
integration: $(BIN_DIR)/minishift
integration:
	mkdir -p $(TEST_DIR)/integration-test
	go test -timeout $(TIMEOUT) $(REPOPATH)/test/integration --tags=integration -v -args --test-dir $(TEST_DIR)/integration-test --binary $(MINISHIFT_BINARY) \
	--run-before-feature="$(RUN_BEFORE_FEATURE)" --test-with-specified-shell="$(TEST_WITH_SPECIFIED_SHELL)" --tags=$(ADDON) $(GODOG_OPTS)

vendor:
	dep ensure -v

$(BIN_DIR)/minishift:
	@echo "Downloading latest minishift binary at $(BIN_DIR)/minishift$(IS_EXE)..."
	@mkdir -p $(BIN_DIR)
	@cd $(BIN_DIR) && \
	curl -LO --progress-bar $(MINISHIFT_LATEST_URL)/$(GOOS)-$(GOARCH)/minishift$(IS_EXE) && \
	chmod 755 minishift$(IS_EXE)
	@echo "Done."

.PHONY: clean
clean:
	rm -rf $(TEST_DIR)
	rm -rf  vendor
	rm -rf $(GOPATH)/pkg/$(GOOS)_$(GOARCH)/$(ORG)
