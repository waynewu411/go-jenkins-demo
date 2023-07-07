package service

import (
	"context"

	pb "github.com/waynewu411/go-jenkins-demo/proto"
)

type DemoServer struct {
	pb.UnimplementedDemoServer
}

func newDemoServer() *DemoServer {
	return &DemoServer{}
}

func (srv *DemoServer) Healthz(ctx context.Context, request *pb.HealthzRequest) (*pb.HealthzResponse, error) {
	return &pb.HealthzResponse{}, nil
}

func (srv *DemoServer) Echo(ctx context.Context, request *pb.EchoRequest) (*pb.EchoResponse, error) {
	return &pb.EchoResponse{Response: request.Request}, nil
}
