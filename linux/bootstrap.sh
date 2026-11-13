#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO="$(cd -- "$DIR/.." && pwd -P)"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script bootstraps the Linux configuration." >&2
  exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Run this as your regular user, not with sudo." >&2
  exit 1
fi

DOTFILES="$HOME/.dotfiles"
if [[ -e "$DOTFILES" || -L "$DOTFILES" ]]; then
  if [[ ! -d "$DOTFILES" || "$(cd -- "$DOTFILES" && pwd -P)" != "$REPO" ]]; then
    echo "$DOTFILES already exists and does not point to this repository." >&2
    echo "Move it aside or make it point to $REPO, then run this script again." >&2
    exit 1
  fi
else
  ln -s "$REPO" "$DOTFILES"
fi

if ! command -v nix >/dev/null 2>&1; then
  if [[ ! -d /run/systemd/system ]]; then
    echo "Nix is missing and automatic installation here requires systemd." >&2
    echo "Install Nix for this Linux system, then run ./linux/bootstrap.sh again." >&2
    exit 1
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "Install curl with your Linux package manager, then run this script again." >&2
    exit 1
  fi

  echo "This will install Determinate Nix on this Linux machine."
  echo "The installer may ask for your password to configure the system Nix service."
  read -r -p "Continue with the Nix installation? [y/N] " REPLY
  case "$REPLY" in
    y|Y|yes|YES|Yes) ;;
    *) echo "Nix was not installed. No Home Manager changes were applied."; exit 0 ;;
  esac

  curl --proto '=https' --tlsv1.2 -sSfL https://install.determinate.systems/nix | sh -s -- install

  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  if ! command -v nix >/dev/null 2>&1; then
    echo "Nix was installed. Open a new terminal and run ./linux/bootstrap.sh again." >&2
    exit 1
  fi
fi

exec "$DIR/rebuild.sh"
