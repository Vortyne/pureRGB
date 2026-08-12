#!/usr/bin/env bash
# Install a CLI-only Floating IPS build into ~/.local/bin (no sudo required).
#
# Usage: tools/install_flips.sh
set -euo pipefail

mkdir -p "$HOME/.local/bin"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cd "$tmp"
curl -fsSL -o flips.tar.gz https://github.com/Alcaro/Flips/tarball/v198
tar -xzf flips.tar.gz
cd Alcaro-Flips-*

TARGET=cli make
install -m 755 flips "$HOME/.local/bin/flips"

if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
	echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$HOME/.local/bin:$PATH"
echo "Installed CLI flips to $HOME/.local/bin/flips"
flips --help | head -5
