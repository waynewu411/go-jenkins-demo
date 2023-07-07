package service

import (
	"context"
	"log"
	"net"
	"net/http"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/reflection"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	pb "github.com/waynewu411/go-jenkins-demo/proto"
)

func startGrpcServer(srv *DemoServer, quit chan bool) {
	defer func() {
		quit <- true
	}()

	addr := ":50050"
	listener, err := net.Listen("tcp", addr)
	if err != nil {
		log.Printf("failed to listen, addr: %v, error: %v", addr, err)
		return
	}
	log.Printf("listener started, addr: %v", addr)

	server := grpc.NewServer()

	pb.RegisterDemoServer(server, srv)
	log.Printf("grpc server registered")

	reflection.Register(server)

	log.Printf("starting grpc server, addr: %v", addr)
	if err = server.Serve(listener); err != nil {
		log.Printf("fail to serve, error: %v", err)
		return
	}
}

func startGrpcGatewayServer(srv *DemoServer, quit chan bool) {
	defer func() {
		quit <- true
	}()

	log.Printf("starting grpc-gateway server")

	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	mux := runtime.NewServeMux()

	opts := []grpc.DialOption{grpc.WithTransportCredentials(insecure.NewCredentials())}
	grpcSrvEndpoint := "localhost:50050"
	if err := pb.RegisterDemoHandlerFromEndpoint(
		ctx,
		mux,
		grpcSrvEndpoint,
		opts,
	); err != nil {
		log.Printf("fail to register demo handler from endpoint, endpoint: %v, error: %v", grpcSrvEndpoint, err)
		return
	}
	log.Printf("grpc server registered")

	addr := ":8080"
	log.Printf("starting grpc-gateway server, addr: %v", addr)
	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Printf("fail to ListenAndServe for grpc-gateway server, error: %s", err)
		return
	}

}

func StartDemoService() {
	srv := newDemoServer()

	quit := make(chan bool)
	go startGrpcServer(srv, quit)
	go startGrpcGatewayServer(srv, quit)
	if <-quit {
		log.Fatalf("grpc server stopped")
	}
}
