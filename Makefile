APP=go-jenkins-demo
VERSION?=latest
BUILD?=$(shell /bin/date +%Y%m%d%H%M%S)
PLATFORM?=linux/amd64,linux/arm64
REGISTRY?=docker.io/waynewu411

proto:
	docker run --rm -it -v "$(PWD)":/app docker.io/waynewu411/go-builder:1.19-1.0 sh -c \
	"cd /app && rm -f proto/*.go && \
		protoc --go_out=proto --go_opt=paths=source_relative \
			--go-grpc_out=proto --go-grpc_opt=paths=source_relative \
			--grpc-gateway_out=proto --grpc-gateway_opt=paths=source_relative --grpc-gateway_opt=allow_delete_body=true \
			--proto_path=proto \
			proto/demo.proto"

image:
	docker buildx build -o type=docker --build-arg VERSION=$(VERSION) --build-arg BUILD=$(BUILD) . -t $(REGISTRY)/$(APP):$(VERSION)

ximage:
	docker buildx create --name imagebuilder --driver=remote tcp://buildkitd-non-tls:1234 --bootstrap --use; docker buildx build -o type=registry --build-arg VERSION=$(VERSION) --build-arg BUILD=$(BUILD) --platform=$(PLATFORM) . -t $(REGISTRY)/$(APP):$(VERSION) -t $(REGISTRY)/$(APP):latest

.PHONY: proto image ximage