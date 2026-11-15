cask "awake" do
  version "1.2.0"
  sha256 "6ddd91e671cd841cde14e610d93828a9edd6c1edf32a41217533e05813d6d503"

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
