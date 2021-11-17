# distribution
DIST_NAME=awslamba-go-runtime
DIST_VERSION ?= 

# Go parameters
GOCMD=go
GOINSTALL=$(GOCMD) install
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

CURDIR=$(shell pwd)
export GOBIN := $(CURDIR)/bin

all: test build-all

build:
	$(GOINSTALL) ./...

build-example:
	go build -o $(GOBIN)/handler examples/handler/handler.go

test: build build-example
	AWS_LAMBDA_EVENT_BODY='{"name": "localstack"}' \
	_HANDLER=$(GOBIN)/handler \
	$(GOBIN)/aws-lambda-mock

clean:
	$(GOCLEAN)
	rm -rf bin/
	rm -rf dist/

# cross-platform build

DIST_FILE_PREFIX=
ifeq (, $(DIST_VERSION))
	DIST_FILE_PREFIX=$(DIST_NAME)
else
	DIST_FILE_PREFIX=$(DIST_NAME)-$(DIST_VERSION)
endif

PLATFORMS := linux/amd64 linux/arm64

temp = $(subst /, ,$@)
os = $(word 1, $(temp))
arch = $(word 2, $(temp))

dist: $(PLATFORMS)
	for d in dist/*; do \
		if test -d $${d}; then \
			tar -czf $${d}.tar.gz -C $${d} mockserver aws-lambda-mock; \
		fi \
	done; \
	cd dist; \
	for f in handler-*; do \
		cp $${f} handler; \
		tar -czf "example-`basename $${f}`.tar.gz" handler; \
		rm handler; \
	done;


$(PLATFORMS):
	GOOS=$(os) GOARCH=$(arch) go build -v -o 'dist/$(DIST_FILE_PREFIX)-$(os)-$(arch)/' ./...;
	GOOS=$(os) GOARCH=$(arch) go build -v -o 'dist/handler-$(os)-$(arch)' ./examples/handler/handler.go


UID := $(shell id -u)
GID := $(shell id -g)

dist-buster:
	docker run -it --rm --workdir /go/code \
		-v $$(pwd):/go/code \
		-e DIST_VERSION=$(DIST_VERSION) \
		golang:1.16-buster \
		bash -c "make clean dist; chown -R ${UID}:${GID} dist"

.PHONY: dist-buster dist build build-example test clean
