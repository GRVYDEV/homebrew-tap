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
      # Resolve paths to absolute (the binary may have a different cwd).
      args=()
      for arg in "$@"; do
        if [[ "$arg" != -* ]]; then
          if [[ -d "$arg" ]]; then
            args+=("$(cd "$arg" && pwd)")
          elif [[ -f "$arg" ]]; then
            args+=("$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")")
          else
            args+=("$arg")
          fi
        else
          args+=("$arg")
        fi
      done
      # Direct-exec the binary so tauri-plugin-single-instance can detect
      # the lock and forward args to an already-running instance.
      # `open -a` routes through Apple Events and bypasses single_instance.
      nohup "#{appdir}/Marky.app/Contents/MacOS/marky" "${args[@]}" >/dev/null 2>&1 &
      disown >/dev/null 2>&1 || true
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
