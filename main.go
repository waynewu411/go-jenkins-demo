package main

import (
	"log"

	"github.com/waynewu411/go-jenkins-demo/service"
)

var (
	Version string = "latest"
	Build   string = ""
)

func logVersionAndBuild() {
	log.Printf("demo, version: %v, build: %v", Version, Build)
}

func main() {
	logVersionAndBuild()

	service.StartDemoService()
}
