NAME := kubectl-hello-world
TARGET := kubectl-hello_world
CIRCLE_TAG ?= snapshot
LDFLAGS :=

.PHONY: check run release clean

all: build/bin/$(TARGET)

check:
	golint
	go vet

build/bin/$(TARGET): check $(wildcard *.go)
	go build -o $@ -ldflags "$(LDFLAGS)"

run: build/bin/$(TARGET)
	-PATH=build/bin:$(PATH) kubectl hello-world -h

build/dist:
	goxz -n "$(NAME)" -o "$(TARGET)" -build-ldflags "$(LDFLAGS)" -d $@
	cd $@ && shasum -a 256 -b * > $(TARGET)_sha256.txt

build/$(NAME).rb: build/dist
	./homebrew.sh build/dist/$(NAME)_darwin_amd64.zip > $@

release: build/dist build/$(NAME).rb
	# GitHub Releases
	ghr -u "$(CIRCLE_PROJECT_USERNAME)" -r "$(CIRCLE_PROJECT_REPONAME)" \
		-b "$$(ghch -F markdown --latest)" \
		"$(CIRCLE_TAG)" build/dist
	# Homebrew tap
	ghcp -u "$(CIRCLE_PROJECT_USERNAME)" -r "homebrew-$(CIRCLE_PROJECT_REPONAME)" \
		-m "$(CIRCLE_TAG)" \
		-C build/ $(NAME).rb

clean:
	-rm -r build/
