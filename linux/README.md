# Linux terminal setup

This folder provides a standalone Home Manager setup for Linux. It does not use NixOS, nix-darwin, or Homebrew. The Linux flake has its own lock file and only includes Nixpkgs and Home Manager.

## First setup

Clone this repository, then from its root run:

```sh
./linux/bootstrap.sh
```

The bootstrap checks that it is running as a regular Linux user, links the checkout to `~/.dotfiles`, and asks before installing Determinate Nix if Nix is missing. The Nix installer may request your password to configure its system service. After Nix is available, the script activates the Linux Home Manager configuration.

If the Linux machine does not use systemd, install Nix using the appropriate instructions for that system, then run the bootstrap again.

## Apply later changes

From the repository root, run:

```sh
./linux/rebuild.sh
```

The Linux configuration installs command-line tools and manages terminal/editor configuration. It does not install desktop applications. WezTerm settings are linked if you install WezTerm separately.

Home Manager configures Zsh but does not change the account's system login shell. If Zsh is not already your default shell, use the Linux distribution's account tools to select it.

The username and home directory are read from the current login environment when Home Manager runs, so the same Linux flake can be used by different Linux users without editing the config.
