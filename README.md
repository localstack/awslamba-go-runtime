# AWS Lamba Golang Runtime

Custom Golang runtime for the execution of AWS Lambdas used in [LocalStack](https://github.com/localstack/localstack).

This is a modification of the custom runtime of [lambdaci](https://github.com/lambci/docker-lambda) (Thank you guys!)

This custom runtime avoids using the **/var** folder as main place where to locate other files.
It contains the source code of the [docker-lambda mockserver](https://github.com/lambci/docker-lambda/blob/master/provided/run/init.go) to build the binary.


## Build and test

To build run

    make build

To run the test using the example handler from `examples/handler`, run

    make test

The output should look something like:

```
go install ./...
go build -o /home/thomas/workspace/localstack/awslamba-go-runtime/bin/handler examples/handler/handler.go
AWS_LAMBDA_EVENT_BODY='{"name": "localstack"}' \
_HANDLER=/home/thomas/workspace/localstack/awslamba-go-runtime/bin/handler \
/home/thomas/workspace/localstack/awslamba-go-runtime/bin/aws-lambda-mock
START RequestId: 1873091d-b4ba-16f0-3a81-ff18c513f6de Version: $LATEST
END RequestId: 1873091d-b4ba-16f0-3a81-ff18c513f6de
REPORT RequestId: 1873091d-b4ba-16f0-3a81-ff18c513f6de	Init Duration: 300000.00 ms	Duration: 4.50 ms	Billed Duration: 5 ms	Memory Size: 1536 MB	Max Memory Used: 0 MB	

"Hello localstack!"
```

## Create cross-plattform distributions

Run

	DIST_VERSION=0.3.0 make dist

To create the following file tree:

```
dist
├── awslamba-go-runtime-0.3.0-linux-amd64
│   ├── aws-lambda-mock
│   └── mockserver
├── awslamba-go-runtime-0.3.0-linux-amd64.tar.gz
├── awslamba-go-runtime-0.3.0-linux-arm64
│   ├── aws-lambda-mock
│   └── mockserver
└── awslamba-go-runtime-0.3.0-linux-arm64.tar.gz
```

The .tar.gz files can then be used for a release.


## Legal

* `cmd/mockserver/main.go`: Copyright 2016 Michael Hart and LambCI contributors
