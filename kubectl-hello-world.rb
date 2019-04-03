class KubectlHelloWorld < Formula
  desc "A kubectl plugin just saying Hello World!"
  homepage "https://github.com/int128/kubectl-hello-world"
  url "https://github.com/int128/kubectl-hello-world/releases/download/${CIRCLE_TAG}/kubectl-hello-world_darwin_amd64.zip"
  version "${CIRCLE_TAG}"
  sha256 "$(cat build/dist/kubectl-hello-world_darwin_amd64.zip.sha256)"

  def install
    bin.install "kubectl-hello_world"
  end

  test do
    system "#{bin}/kubectl-hello_world -h"
  end
end
