cask "silknest" do
  version "1.3.0"
  sha256 "31045271a80094cfe84046ab3d42e4a9c9e033edd42b50679dacbf845b335a1f"

  url "https://github.com/shxwat/silknest/releases/download/v#{version}/SilkNest-#{version}.dmg"
  name "SilkNest"
  desc "Clipboard manager with a spider that keeps everything local"
  homepage "https://silknest.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # SilkNest updates itself (signed updates from silknest.app).
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "SilkNest.app"

  uninstall quit:       "studio.webber.spider",
            login_item: "SilkNest"

  zap trash: [
    "~/Library/Application Support/SilkNest",
    "~/Library/Caches/studio.webber.spider",
    "~/Library/HTTPStorages/studio.webber.spider",
    "~/Library/Preferences/studio.webber.spider.plist",
  ]

  caveats <<~EOS
    SilkNest is not notarized by Apple yet, so macOS blocks the first launch:
      1. Open SilkNest once and click "Done" when macOS says it can't be checked.
      2. Open System Settings → Privacy & Security, scroll down and click "Open Anyway".
    After that it opens normally. Releases are signed with SilkNest's own certificate
    and every download has a published SHA-256 (see https://github.com/shxwat/silknest/releases).

    Optional: for 1-click paste, allow SilkNest in System Settings → Privacy & Security → Accessibility.
  EOS
end
