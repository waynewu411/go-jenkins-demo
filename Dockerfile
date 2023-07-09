FROM waynewu411/go-builder:1.19-1.0 AS builder
ARG VERSION=latest
ARG BUILD
WORKDIR /build
COPY . .
RUN protoc --experimental_allow_proto3_optional \
        --go_out=proto --go_opt=paths=source_relative \
        --go-grpc_out=proto --go-grpc_opt=paths=source_relative \
        --grpc-gateway_out=proto --grpc-gateway_opt=paths=source_relative --grpc-gateway_opt=allow_delete_body=true \
        --proto_path=proto \
        proto/demo.proto && \
        go mod download && go build -ldflags "-X 'main.Version=$VERSION' -X 'main.Build=$BUILD'" -o app

FROM alpine
ARG USER_NAME=docker
ARG USER_UID=1001
ARG USER_GROUP=$USER_NAME
ARG USER_GID=$USER_UID
EXPOSE 8080 50050
COPY --from=builder /build/app /app
RUN addgroup -S $USER_GROUP -g $USER_GID && \
    adduser -S -G $USER_GROUP -u $USER_GID $USER_NAME && \
    chown -R $USER_NAME:$USER_GROUP /app
USER $USER_NAME
ENTRYPOINT [ "/app" ]
