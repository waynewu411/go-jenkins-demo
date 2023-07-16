# go-jenkins-demo

This is a demo of CI/CD pipeline for golang application. Jenkins is used for CI and ArgoCD is used for CD.

## Environment

In this demo, there is a Kubernetes cluster with the following two physical nodes where Jenkins is installed and running.

k3sm1: 192.168.200.201

k3sw1: 192.168.200.206

There is another server k3sdev (192.169.200.200) which provides nfs storage for Kubernetes cluster and hosts the Gitlab instance.

## Documents

[Install Jenkins in Kubernetes cluster](https://medium.com/@WayneWu411/install-jenkins-in-kubernetes-cluster-3ebf24b5e038)

[Building docker image with buildkit in Jenkins running in Kubernetes cluster](https://medium.com/@WayneWu411/building-docker-image-with-buildkit-in-jenkins-running-in-kubernetes-cluster-ed4535d122ec)

[How to pull image from private container registry in Jenkins pipeline](https://medium.com/@WayneWu411/how-to-pull-image-from-private-container-registry-in-jenkins-pipeline-da7129045852)

[How to Trigger Jenkins Pipeline from Gitlab](https://medium.com/@WayneWu411/how-to-trigger-jenkins-pipeline-from-gitlab-8b581bb9416)