class KubectlHelloWorld < Formula
  desc "A kubectl plugin just saying Hello World!"
  homepage "https://github.com/int128/kubectl-hello-world"
  url "https://github.com/int128/kubectl-hello-world/releases/download/{{ env "VERSION" }}/kubectl-hello-world_darwin_amd64.zip"
  version "{{ env "VERSION" }}"
  sha256 "{{ .darwin_amd64_zip_sha256 }}"

  def install
    bin.install "kubectl-hello_world"
  end

  test do
    system "#{bin}/kubectl-hello_world -h"
  end
end
