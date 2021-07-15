build:
	cd runtime && \
	go mod download && \
	GOOS=linux go build aws-lambda-mock.go;

build-test:
	cd example && \
	go mod download && \
	GOOS=linux go build handler.go;

test:
	make build && make build-test &&\
	_HANDLER=${PWD}/example/handler ./runtime/aws-lambda-mock


zip:
	make build && zip runtime.zip runtime/aws-lambda-mock runtime/mockserver

zip-example:
	make build-test && cd example && zip example.zip handler