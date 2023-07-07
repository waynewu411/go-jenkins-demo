# buildkitd

The following two files come from [Buildkit@Kubernetes](https://github.com/moby/buildkit/tree/master/examples/kubernetes).

- deployment+service.rootless.yaml
- create-certs.sh

deployment+service.rootless.non-tls.yaml is actually a copy of deployment+service.rootless.yaml without tls certs on the service.

After running create-certs.sh as below, we will get the following files:

```bash
# ./create-certs.sh buildkitd
```

- certs files
- buildkit-daemon-certs.yaml: applied to the kubernetes cluster while creating buildkit daemon service. Please refer to deployment+service.rootless.yaml
- buildkit-client-certs.yaml: applied to the kubernetes cluster and include in the yaml file of Jenkins slave pod. Please refer to the yaml file in Jenkinsfile.