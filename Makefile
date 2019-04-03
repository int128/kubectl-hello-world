NAME := kubectl-hello-world
TARGET := kubectl-hello_world
LDFLAGS :=
CIRCLE_TAG ?= v0.0.0
BUILD_DIR := build

.PHONY: all run dist release clean

all: $(BUILD_DIR)/$(TARGET)

check:
	golint
	go vet

$(BUILD_DIR)/$(TARGET):
	go build -o "$@" -ldflags "$(LDFLAGS)"

run: $(BUILD_DIR)/$(TARGET)
	-PATH="$(BUILD_DIR):$(PATH)" kubectl hello-world -h

dist:
	VERSION="$(CIRCLE_TAG)" goxzst \
		-d "$(BUILD_DIR)/dist" -o "$(TARGET)" \
		-t "hello-world.yaml kubectl-hello-world.rb" \
		-- -ldflags "$(LDFLAGS)"
	mv "$(BUILD_DIR)/dist/kubectl-hello-world.rb" "$(BUILD_DIR)/kubectl-hello-world.rb"

release: dist
	ghr -u "$(CIRCLE_PROJECT_USERNAME)" -r "$(CIRCLE_PROJECT_REPONAME)" \
		-b "$$(ghch -F markdown --latest)" \
		"$(CIRCLE_TAG)" "$(BUILD_DIR)/dist"
	ghcp -u "$(CIRCLE_PROJECT_USERNAME)" -r "homebrew-$(CIRCLE_PROJECT_REPONAME)" \
		-m "$(CIRCLE_TAG)" \
		-C "$(BUILD_DIR)" "kubectl-hello-world.rb"

clean:
	-rm -r $(BUILD_DIR)/
