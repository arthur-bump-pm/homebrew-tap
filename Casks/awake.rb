cask "awake" do
  version "1.0.1"
  sha256 "93edd5d0a5bafa25deec9431458ffcf593b2592d7aef6506b128f2cd2adaa345"

  url "https://github.com/arthur-bump-pm/awake-mac/releases/download/v#{version}/Awake-#{version}.zip"
  name "Awake"
  desc "Keeps your laptop running and online when you close the lid or move"
  homepage "https://github.com/arthur-bump-pm/awake-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Awake.app"
  binary "#{appdir}/Awake.app/Contents/MacOS/awakectl"

  # Awake isn't notarized: clear the download flag so the first open doesn't stop at Gatekeeper.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Awake.app"],
                          writable_paths: ["Awake.app"], writable_base: :appdir, must_succeed: false
  end

  uninstall quit: "io.github.arthur-bump-pm.Awake"

  zap trash: [
    "~/Library/Application Support/Awake",
    "~/Library/Preferences/io.github.arthur-bump-pm.Awake.plist",
  ]

  caveats <<~EOS
    If you set up Awake's admin permission, remove its sudoers rule after uninstalling:
      sudo rm /etc/sudoers.d/awake
  EOS
end
