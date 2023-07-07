package service

import (
	"context"
	"log"

	pb "github.com/waynewu411/go-jenkins-demo/proto"
)

type DemoServer struct {
	pb.UnimplementedDemoServer
}

func newDemoServer() *DemoServer {
	return &DemoServer{}
}

func (srv *DemoServer) Echo(ctx context.Context, request *pb.EchoRequest) (*pb.EchoResponse, error) {
	log.Printf("-> %v", request)
	return &pb.EchoResponse{Response: request.Request}, nil
}
