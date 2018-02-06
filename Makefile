BUILD_DIR=$(shell pwd)/build
TEST_DIR=$(shell pwd)/tests
UTIL_DIR=$(shell pwd)/utils
ADDON_DIR=$(shell pwd)/add-ons
BIN_DIR=$(BUILD_DIR)/bin
MINISHIFT_LATEST_URL=$(shell python $(UTIL_DIR)/minishift_latest_version.py)
ARCHIVE_FILE=$(shell echo $(MINISHIFT_LATEST_URL) | rev | cut -d/ -f1 | rev)
MINISHIFT_UNTAR_DIR=$(shell echo $(ARCHIVE_FILE) | sed 's/.tgz//')
TEST_FILES=$(shell find $(TEST_DIR) -name 'test_*.sh')

.PHONY: init
init:
	mkdir -p $(BUILD_DIR)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

$(BIN_DIR)/minishift:
	@echo "Downloading latest minishift binary at $(BIN_DIR)/minishift..."
	@mkdir -p $(BIN_DIR)
	@cd $(BIN_DIR) && \
	curl -LO --progress-bar $(MINISHIFT_LATEST_URL) && \
	tar xzf $(ARCHIVE_FILE) && \
	mv $(MINISHIFT_UNTAR_DIR)/minishift .
	@echo "Done."

.PHONY: test
test: TEST_ADDON_NAME="all"
test: $(BIN_DIR)/minishift
	@$(UTIL_DIR)/test_runner.sh $(BIN_DIR)/minishift $(TEST_DIR) $(ADDON_DIR) $(TEST_ADDON_NAME)
