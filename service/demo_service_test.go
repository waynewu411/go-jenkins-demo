package service

import (
	"context"
	"math/rand"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	pb "github.com/waynewu411/go-jenkins-demo/proto"
	"github.com/waynewu411/go-jenkins-demo/util"
)

func setup() error {
	return nil
}

func TestMain(m *testing.M) {
	if err := setup(); err != nil {
		os.Exit(1)
	}
	os.Exit(m.Run())
}

func newMockDemoServer(t *testing.T) *DemoServer {
	return newDemoServer()
}

func TestHealthz(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		srv := newMockDemoServer(t)

		_, err := srv.Healthz(context.Background(), &pb.HealthzRequest{})

		assert.NoError(t, err)
	})
}

func TestEcho(t *testing.T) {
	t.Run("success", func(t *testing.T) {
		var (
			message = util.RandomString(int(rand.Int31n(256)))
		)
		srv := newMockDemoServer(t)

		response, err := srv.Echo(context.Background(), &pb.EchoRequest{Request: message})

		assert.NoError(t, err)
		assert.Equal(t, message, response.Response)
	})
}
