# Homebrew formula for LoopCraft. Its source lives in the LoopCraft repository
# at packaging/homebrew/loopcraft.rb; keep the two the same apart from url and
# sha256, which point at the release tarball.
class Loopcraft < Formula
  desc "Offline virtual audio router and mixer"
  homepage "https://github.com/KerpoOrg/loopcraft"
  url "https://github.com/KerpoOrg/loopcraft/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fae5aa63958faccebd5047c44d4b689188dc86248cbe9b0a701e6067087b60b1"
  license "GPL-3.0-or-later"
  head "https://github.com/KerpoOrg/loopcraft.git", branch: "main"

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    # `loopcraft setup` finds the plug-in and the editor here, across upgrades.
    ENV["LOOPCRAFT_PREFIX"] = opt_prefix.to_s
    # SwiftPM's own sandbox can't start inside Homebrew's.
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    system "cargo", "install", *std_cargo_args(path: "crates/loopcraftd")
    system "cargo", "install", *std_cargo_args(path: "crates/loopcraft-cli")
    system "scripts/build-driver.sh"
    system "scripts/build-editor.sh"

    # A stable identifier, matching the daemon's embedded Info.plist, for macOS privacy permissions.
    system "codesign", "--force", "--sign", "-", "--identifier", "org.kerpo.loopcraft.daemon", bin/"loopcraftd"
    # Homebrew re-signs the plug-in's binary on install; `loopcraft setup`
    # signs the whole bundle again before installing it.
    prefix.install "build/LoopCraft.driver", "build/LoopCraft.app"
  end

  def caveats
    <<~EOS
      To finish, run:
        loopcraft setup

      It installs the audio plug-in (asks for your password and restarts
      macOS's audio service, so sound stops for a few seconds), starts the
      LoopCraft daemon and puts the editor in ~/Applications.

      Run `loopcraft setup` again after every `brew upgrade loopcraft`.
      Before `brew uninstall loopcraft`, run `loopcraft setup --uninstall`.
    EOS
  end

  test do
    assert_match "LoopCraft #{version}", shell_output("#{bin}/loopcraft setup --status")
  end
end
