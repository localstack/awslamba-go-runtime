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
	for d in dist/*; do tar -czf $${d}.tar.gz -C $${d} mockserver aws-lambda-mock; done

$(PLATFORMS):
	GOOS=$(os) GOARCH=$(arch) go build -v -o 'dist/$(DIST_FILE_PREFIX)-$(os)-$(arch)/' ./...
