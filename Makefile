build:
	cd runtime && \
	go mod download && \
	GOOS=linux go build aws-lambda-mock.go;

zip:
	make build && zip runtime.zip runtime/aws-lambda-mock runtime/mockserver