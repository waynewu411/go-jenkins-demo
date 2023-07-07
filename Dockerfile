FROM qsruluru.azurecr.io/go-builder:1.19-1.2 AS builder
ARG VERSION=latest
ARG BUILD
WORKDIR /build
COPY . .
RUN protoc --experimental_allow_proto3_optional \
        --go_out=proto --go_opt=paths=source_relative \
        --go-grpc_out=proto --go-grpc_opt=paths=source_relative \
        --grpc-gateway_out=proto --grpc-gateway_opt=paths=source_relative --grpc-gateway_opt=allow_delete_body=true \
        --proto_path=cronus-proto \
        webapp/v1/webapp.proto webapp/v1/errors.proto webapp/v1/entitlement.proto webapp/v1/catalog.proto webapp/v1/category.proto  webapp/v1/credits.proto webapp/v1/accountuser.proto webapp/v1/account.proto && \
        go mod download && go build -ldflags "-X 'main.Version=$VERSION' -X 'main.Build=$BUILD'" -o app

FROM alpine
ARG USER_NAME=docker
ARG USER_UID=1001
ARG USER_GROUP=$USER_NAME
ARG USER_GID=$USER_UID
RUN apk add --no-cache tzdata
ENV TZ=Australia/Melbourne
EXPOSE 50051 50052 50053
COPY --from=builder /build/app /app
RUN addgroup -S $USER_GROUP -g $USER_GID && \
    adduser -S -G $USER_GROUP -u $USER_GID $USER_NAME && \
    chown -R $USER_NAME:$USER_GROUP /app
USER $USER_NAME
ENTRYPOINT [ "/app" ]
