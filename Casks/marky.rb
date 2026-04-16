cask "marky" do
  version "0.1.1"
  sha256 "e701b3121d83c517c8ac37a2e042728c4245b26b96656ee63e2d15f39103889b"

  url "https://github.com/GRVYDEV/marky/releases/download/v#{version}/Marky_#{version}_aarch64.tar.gz"
  name "Marky"
  desc "Fast markdown viewer with folder support and Cmd+K search"
  homepage "https://github.com/GRVYDEV/marky"

  depends_on arch: :arm64

  app "Marky.app"

  postflight do
    wrapper = "#{HOMEBREW_PREFIX}/bin/marky"
    File.write(wrapper, <<~SH)
      #!/bin/bash
      exec /usr/bin/open -a "#{appdir}/Marky.app" --args "$@"
    SH
    File.chmod(0755, wrapper)
  end

  uninstall_postflight do
    wrapper = "#{HOMEBREW_PREFIX}/bin/marky"
    File.delete(wrapper) if File.exist?(wrapper)
  end

  zap trash: [
    "~/Library/Application Support/dev.marky.app",
    "~/Library/Caches/dev.marky.app",
    "~/Library/Preferences/dev.marky.app.plist",
  ]
end
