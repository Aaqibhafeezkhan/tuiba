class Tuiba < Formula
  desc "Game Boy Advance emulator running in your terminal"
  homepage "https://github.com/Huseynteymurzade28/tuiba"
  version "0.16.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Huseynteymurzade28/tuiba/releases/download/v#{version}/tuiba-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 :no_check
    end
    on_intel do
      url "https://github.com/Huseynteymurzade28/tuiba/releases/download/v#{version}/tuiba-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 :no_check
    end
  end

  def install
    target = Hardware::CPU.arm? ? "aarch64-apple-darwin" : "x86_64-apple-darwin"
    bin.install "tuiba-v#{version}-#{target}/tuiba"
  end

  test do
    assert_match "tuiba", shell_output("#{bin}/tuiba --help")
  end
end
