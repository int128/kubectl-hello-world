# hello-kubectl-plugin [![CircleCI](https://circleci.com/gh/int128/hello-kubectl-plugin.svg?style=shield)](https://circleci.com/gh/int128/hello-kubectl-plugin) [![GoDoc](https://godoc.org/github.com/int128/hello-kubectl-plugin?status.svg)](https://godoc.org/github.com/int128/hello-kubectl-plugin)

This is a kubectl plugin to say Hello World.

It is based on [kubernetes/sample-cli-plugin](https://github.com/kubernetes/sample-cli-plugin).

## Getting Started

Download [the latest release](https://github.com/int128/hello-kubectl-plugin/releases) and install it.

```
% kubectl hello
I0228 15:19:48.114978   18579 hello.go:47] Hello World from default
```

```
% kubectl hello --help
Say hello world

Usage:
  hello [flags]

Examples:

	kubectl hello


Flags:
      --as string                      Username to impersonate for the operation
      --as-group stringArray           Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --cache-dir string               Default HTTP cache directory (default "~/.kube/http-cache")
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

## Contributions

This is an open source software.
Feel free to open issues and pull requests.

## Development

You can build and run it as follows:

```
% go build -o kubectl-hello
% export PATH=$PATH:$PWD
% kubectl hello
```

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

### Checksum mismatch of go.sum

Some module causes checksum mismatch between GOOS such as macOS and Linux.

```
go: verifying k8s.io/client-go@v10.0.0+incompatible: checksum mismatch
	downloaded: h1:F1IqCqw7oMBzDkqlcBymRq1450wD0eNqLE9jzUrIi34=
	go.sum:     h1:+xQQxwjrcIPWDMJBAS+1G2FNk1McoPnb53xkvcDiDqE=
Exited with code 1
```

According to [golang/go#27925](https://github.com/golang/go/issues/27925),
add the following command on CI for workaround.

```sh
sed -e '/^k8s.io\/client-go /d' -i go.sum
```
