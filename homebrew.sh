#!/bin/bash -xe

cat <<EOF
class KubectlHelloWorld < Formula
  desc "A kubectl plugin just saying Hello World!"
  homepage "https://github.com/int128/kubectl-hello-world"
  url "https://github.com/int128/kubectl-hello-world/releases/download/$1/kubectl-hello-world_darwin_amd64.zip"
  version "$1"
  sha256 "$2"

  def install
    bin.install "kubectl-hello_world"
  end

  test do
    system "#{bin}/kubectl-hello_world -h"
  end
end
EOF
