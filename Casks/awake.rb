cask "awake" do
  version "1.0.0"
  sha256 "ed4052a49bb0236c31b2c3b134bcbdfe6aefa9721ad7320546063ecde61c273c"

  url "https://github.com/arthur-bump-pm/awake-mac/releases/download/v#{version}/Awake-#{version}.zip"
  name "Awake"
  desc "Menu bar app that keeps your Mac running and online away from your desk"
  homepage "https://github.com/arthur-bump-pm/awake-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Awake.app"
  binary "#{appdir}/Awake.app/Contents/MacOS/awakectl"

  # Awake isn't notarized: clear the download flag so the first open doesn't stop at Gatekeeper.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Awake.app"]
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
