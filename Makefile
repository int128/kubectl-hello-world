NAME := kubectl-hello-world
TARGET := kubectl-hello_world
LDFLAGS :=
CIRCLE_TAG ?= v0.0.0
BUILD_DIR := build
DIST_DIR := $(BUILD_DIR)/dist

# targets for GitHub Releases
DIST_TARGET += $(DIST_DIR)/$(NAME)_linux_amd64.zip
DIST_TARGET += $(DIST_DIR)/$(NAME)_linux_amd64.zip.sha256
DIST_TARGET += $(DIST_DIR)/$(NAME)_darwin_amd64.zip
DIST_TARGET += $(DIST_DIR)/$(NAME)_darwin_amd64.zip.sha256
DIST_TARGET += $(DIST_DIR)/$(NAME)_windows_amd64.zip
DIST_TARGET += $(DIST_DIR)/$(NAME)_windows_amd64.zip.sha256

.PHONY: all
all: $(BUILD_DIR)/$(TARGET)

.PHONY: clean
check:
	golint
	go vet

$(BUILD_DIR)/$(TARGET):
	go build -o "$@" -ldflags "$(LDFLAGS)"

.PHONY: run
run: $(BUILD_DIR)/$(TARGET)
	-PATH="$(BUILD_DIR):$(PATH)" kubectl hello-world -h

.PHONY: dist
dist: $(DIST_TARGET)

$(BUILD_DIR)/osarch/%/$(TARGET):
	GOOS=$(firstword $(subst _, ,$*)) \
	GOARCH=$(lastword $(subst _, ,$*)) \
	go build -o "$@" -ldflags "$(LDFLAGS)"

$(DIST_DIR)/$(NAME)_%.zip: $(BUILD_DIR)/osarch/%/$(TARGET)
	mkdir -p "$(@D)"
	cd "$(<D)" && zip "$(abspath $@)" "$(TARGET)"
	zip "$(abspath $@)" LICENSE

%.sha256: %
	shasum -a 256 -b "$<" | cut -f1 -d' ' > "$@"

.PHONY: homebrew
homebrew: $(BUILD_DIR)/homebrew/$(NAME).rb

$(BUILD_DIR)/homebrew/$(NAME).rb: $(DIST_DIR)/$(NAME)_darwin_amd64.zip.sha256
	mkdir -p "$(@D)"
	./homebrew.sh "$(CIRCLE_TAG)" "$(shell cat $<)" > "$@"

.PHONY: release
release: dist homebrew
	ghr -u "$(CIRCLE_PROJECT_USERNAME)" -r "$(CIRCLE_PROJECT_REPONAME)" \
		-b "$$(ghch -F markdown --latest)" \
		"$(CIRCLE_TAG)" "$(DIST_DIR)"
	ghcp -u "$(CIRCLE_PROJECT_USERNAME)" -r "homebrew-$(CIRCLE_PROJECT_REPONAME)" \
		-m "$(CIRCLE_TAG)" \
		-C "$(BUILD_DIR)/homebrew" "$(NAME).rb"

.PHONY: clean
clean:
	-rm -r $(BUILD_DIR)/
