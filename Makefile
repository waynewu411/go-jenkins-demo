APP=go-jenkins-demo
VERSION?=latest
BUILD?=$(shell /bin/date +%Y%m%d%H%M%S)
PLATFORM?=linux/amd64,linux/arm64
REGISTRY?=waynewu411
UNIT_TEST_PACKAGES=github.com/waynewu411/go-jenkins-demo/service

proto:
	docker run --rm -it -v "$(PWD)":/app waynewu411/go-builder:1.19-1.1 sh -c \
	"cd /app && rm -f proto/*.go && \
		protoc --go_out=proto --go_opt=paths=source_relative \
			--go-grpc_out=proto --go-grpc_opt=paths=source_relative \
			--grpc-gateway_out=proto --grpc-gateway_opt=paths=source_relative --grpc-gateway_opt=allow_delete_body=true \
			--proto_path=proto \
			proto/demo.proto"

unit_test:
	go test --count=1 -cover $(UNIT_TEST_PACKAGES)

build:
	go build -buildvcs=auto .

image:
	docker buildx build -o type=docker --build-arg VERSION=$(VERSION) --build-arg BUILD=$(BUILD) . -t $(REGISTRY)/$(APP):$(VERSION)

ximage:
	docker buildx create --name imagebuilder --driver=remote tcp://buildkitd:1234 --driver-opt=cacert=/certs/ca.pem,cert=/certs/cert.pem,key=/certs/key.pem --bootstrap --use; docker buildx build -o type=registry --build-arg VERSION=$(VERSION) --build-arg BUILD=$(BUILD) --platform=$(PLATFORM) . -t $(REGISTRY)/$(APP):$(VERSION) -t $(REGISTRY)/$(APP):latest

.PHONY: proto image ximage