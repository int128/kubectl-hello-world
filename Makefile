TARGET=kubectl-hello_world

.PHONY: run dist clean

all: $(TARGET)

$(TARGET): main.go
	go build -o $@

run: $(TARGET)
	PATH="$$PATH:$$PWD" kubectl hello-world -h

dist:
	gox --osarch 'darwin/amd64 linux/amd64 windows/amd64' -output 'dist/$(TARGET)_{{.OS}}_{{.Arch}}'

clean:
	rm -fr dist/ $(TARGET)
