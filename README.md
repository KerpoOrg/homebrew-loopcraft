# LoopCraft for Homebrew

[LoopCraft](https://github.com/KerpoOrg/loopcraft) is a free, open-source and
fully offline virtual audio router and mixer for macOS (Apple Silicon,
macOS 15 or later).

```sh
brew install KerpoOrg/loopcraft/loopcraft
loopcraft setup
```

Homebrew builds LoopCraft from source on your Mac, so the first install also
installs Rust and takes a few minutes. `loopcraft setup` then installs the
audio plug-in, starts the daemon and puts the editor in `~/Applications`.

After `brew upgrade loopcraft`, run `loopcraft setup` again. To remove it, run
`loopcraft setup --uninstall`, then `brew uninstall loopcraft`.

See the LoopCraft README for why it isn't signed by Apple. This formula is
released under the same license as LoopCraft, GPL-3.0-or-later.
