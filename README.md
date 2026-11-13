# Linux dotfiles

This branch contains a lightweight Linux setup based on standalone Home Manager. It is separate from the Mac configuration and does not use NixOS or Homebrew.

Clone the repository and run the bootstrap from its root:

```sh
git clone --branch linux-only https://github.com/gnayoaixliu/dotfiles.git
cd dotfiles
./linux/bootstrap.sh
```

See [linux/README.md](linux/README.md) for prerequisites, what the setup manages, and how to apply later changes with `./linux/rebuild.sh`.
