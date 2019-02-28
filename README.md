# hello-kubectl-plugin

This is a kubectl plugin to say Hello World.

It is based on [kubernetes/sample-cli-plugin](https://github.com/kubernetes/sample-cli-plugin).


```
% go build -o kubectl-hello

% export PATH=$PATH:$PWD

% kubectl hello --help
Say hello world

Usage:
  hello [flags]

Examples:

	kubectl hello


Flags:
      --as string                      Username to impersonate for the operation
      --as-group stringArray           Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --cache-dir string               Default HTTP cache directory (default "/Users/hidetake/.kube/http-cache")
      --certificate-authority string   Path to a cert file for the certificate authority
      --client-certificate string      Path to a client certificate file for TLS
      --client-key string              Path to a client key file for TLS
      --cluster string                 The name of the kubeconfig cluster to use
      --context string                 The name of the kubeconfig context to use
  -h, --help                           help for hello
      --insecure-skip-tls-verify       If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kubeconfig string              Path to the kubeconfig file to use for CLI requests.
  -n, --namespace string               If present, the namespace scope for this CLI request
      --request-timeout string         The length of time to wait before giving up on a single server request. Non-zero values should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests. (default "0")
  -s, --server string                  The address and port of the Kubernetes API server
      --token string                   Bearer token for authentication to the API server
      --user string                    The name of the kubeconfig user to use
```


## Tips

### Dependency hell

The latest version of k8s modules may break dependencies.

According to [kubernetes/client-go#551](https://github.com/kubernetes/client-go/issues/551),
fix tags in `go.mod` as follows:

```
require (
	k8s.io/api kubernetes-1.13.2
	k8s.io/apimachinery kubernetes-1.13.2
	k8s.io/cli-runtime kubernetes-1.13.2
	k8s.io/client-go v10.0.0
)
```

and run `go mod tidy`.
