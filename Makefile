NAME := kubectl-hello-world
TARGET := kubectl-hello_world
LDFLAGS :=
OSARCH := linux_amd64 darwin_amd64 windows_amd64
CIRCLE_TAG ?= v0.0.0
BUILD_DIR := build

dist_zip := $(OSARCH:%=$(BUILD_DIR)/dist/$(NAME)_%.zip)
dist_sha256 := $(OSARCH:%=$(BUILD_DIR)/dist/$(NAME)_%.zip.sha256)

.PHONY: all run dist homebrew release clean

all: $(BUILD_DIR)/$(TARGET)

check:
	golint
	go vet

$(BUILD_DIR)/$(TARGET):
	go build -o "$@" -ldflags "$(LDFLAGS)"

run: $(BUILD_DIR)/$(TARGET)
	-PATH="$(BUILD_DIR):$(PATH)" kubectl hello-world -h

dist: $(dist_zip) $(dist_sha256) $(BUILD_DIR)/dist/hello-world.yaml

$(BUILD_DIR)/crossbuild/%/$(TARGET):
	GOOS=$(firstword $(subst _, ,$*)) GOARCH=$(lastword $(subst _, ,$*)) go build -o "$@" -ldflags "$(LDFLAGS)"

$(BUILD_DIR)/dist/$(NAME)_%.zip: $(BUILD_DIR)/crossbuild/%/$(TARGET)
	mkdir -p "$(@D)"
	cd "$(<D)" && zip "$(abspath $@)" "$(TARGET)"
	zip "$@" LICENSE

%.sha256: %
	shasum -a 256 -b "$<" | cut -f1 -d' ' > "$@"

$(BUILD_DIR)/dist/hello-world.yaml: $(dist_sha256)
	echo "cat<<EOF\n$$(cat hello-world.yaml)\nEOF" | bash -e | tee "$@"

homebrew: $(BUILD_DIR)/homebrew/$(NAME).rb

$(BUILD_DIR)/homebrew/$(NAME).rb: $(dist_sha256)
	mkdir -p "$(@D)"
	echo "cat<<EOF\n$$(cat kubectl-hello-world.rb)\nEOF" | bash -e | tee "$@"

release: dist homebrew
	ghr -u "$(CIRCLE_PROJECT_USERNAME)" -r "$(CIRCLE_PROJECT_REPONAME)" \
		-b "$$(ghch -F markdown --latest)" \
		"$(CIRCLE_TAG)" "$(BUILD_DIR)/dist"
	ghcp -u "$(CIRCLE_PROJECT_USERNAME)" -r "homebrew-$(CIRCLE_PROJECT_REPONAME)" \
		-m "$(CIRCLE_TAG)" \
		-C "$(BUILD_DIR)/homebrew" "$(NAME).rb"

clean:
	-rm -r $(BUILD_DIR)/
