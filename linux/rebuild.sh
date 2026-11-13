#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script applies the Linux Home Manager configuration." >&2
  exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Run this as your regular user, not with sudo." >&2
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is not available. Run ./linux/bootstrap.sh first." >&2
  exit 1
fi

NIX_CONFIG="${NIX_CONFIG:-}
extra-experimental-features = nix-command flakes"
export NIX_CONFIG

exec nix --extra-experimental-features "nix-command flakes" \
  run "$DIR#home-manager" -- switch --flake "$DIR#linux" --impure "$@"
