TARGET := kubectl-hello_world
OSARCH := darwin/amd64 linux/amd64 windows/amd64

.PHONY: check run release_bin release_homebrew release clean

all: $(TARGET)

check:
	golint
	go vet

$(TARGET): check
	go build -o $@

run: $(TARGET)
	PATH="$$PATH:$$PWD" kubectl hello-world -h

dist/bin: check
	gox --osarch '$(OSARCH)' -output 'dist/bin/$(TARGET)_{{.OS}}_{{.Arch}}'

release_bin: dist/bin
	ghr -u "$(CIRCLE_PROJECT_USERNAME)" -r "$(CIRCLE_PROJECT_REPONAME)" -b "$$(ghch -F markdown --latest)" "$(CIRCLE_TAG)" dist/bin

dist/$(TARGET).rb: dist/bin
	./homebrew.sh dist/bin/$(TARGET)_darwin_amd64 > dist/$(TARGET).rb

release_homebrew: dist/$(TARGET).rb
	ghcp -u "$(CIRCLE_PROJECT_USERNAME)" -r "homebrew-$(CIRCLE_PROJECT_REPONAME)" -m "$(CIRCLE_TAG)" -C dist/ $(TARGET).rb

release: release_bin release_homebrew

clean:
	-rm "$(TARGET)"
	-rm -r dist/
