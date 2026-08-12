#!/usr/bin/env bash
# Build PureRGB ROMs and create BPS patch files for release.
#
# Requirements:
#   - make, rgbds (see INSTALL.md)
#   - Floating IPS (flips): https://github.com/Alcaro/Flips/releases/latest
#     Run tools/install_flips.sh to install flips into WSL without sudo.
#
# Base ROMs (unmodified) must live one directory above this project:
#   Pokemon Red Raw.gbc
#   Pokemon Blue Raw.gbc
#   Pokemon Green Raw.gbc
#
# Output: releases/<version>/Pokemon_PureRed_v<version>.bps
#         releases/<version>/Pokemon_PureBlue_v<version>.bps
#         releases/<version>/Pokemon_PureGreen_v<version>.bps
#         releases/<version>/pure_rgb_readme.txt
#
# Usage:
#   tools/build_release.sh
#   make release
#   FLIPS=/path/to/flips tools/build_release.sh
#   MAKEFLAGS=-j8 make release

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARENT="$(dirname "$ROOT")"
FLIPS="${FLIPS:-flips}"
README_SRC="$ROOT/tools/pure_rgb_readme.txt"

RED_BASE="$PARENT/Pokemon Red Raw.gbc"
BLUE_BASE="$PARENT/Pokemon Blue Raw.gbc"
GREEN_BASE="$PARENT/Pokemon Green Raw.gbc"

require_base_rom() {
	local path="$1"
	if [[ ! -f "$path" ]]; then
		echo "error: base ROM not found: $path" >&2
		exit 1
	fi
}

VERSION="$(
	grep -m1 '^db "' "$ROOT/version_number.asm" \
	| sed 's/^db "\(.*\)"/\1/'
)"
if [[ -z "$VERSION" ]]; then
	echo "error: could not read version from version_number.asm" >&2
	exit 1
fi

RELEASE_DIR="$ROOT/releases/$VERSION"

require_base_rom "$RED_BASE"
require_base_rom "$BLUE_BASE"
require_base_rom "$GREEN_BASE"

if [[ ! -f "$README_SRC" ]]; then
	echo "error: readme template not found: $README_SRC" >&2
	exit 1
fi

if ! command -v "$FLIPS" >/dev/null 2>&1; then
	echo "error: Floating IPS (flips) not found in PATH" >&2
	echo "Run tools/install_flips.sh or set FLIPS to the flips executable path." >&2
	exit 1
fi

echo "Building ROMs (skipped if already up to date)..."
cd "$ROOT"
make pokered.gbc pokeblue.gbc pokegreen.gbc

for rom in pokered.gbc pokeblue.gbc pokegreen.gbc; do
	if [[ ! -f "$ROOT/$rom" ]]; then
		echo "error: build did not produce $rom" >&2
		exit 1
	fi
done

mkdir -p "$RELEASE_DIR"
cp "$README_SRC" "$RELEASE_DIR/pure_rgb_readme.txt"

create_patch() {
	local name="$1"
	local base="$2"
	local built="$3"
	local patch="$RELEASE_DIR/Pokemon_${name}_v${VERSION}.bps"

	echo "Creating $patch"
	"$FLIPS" --create "$base" "$built" "$patch"
}

create_patch PureRed "$RED_BASE" "$ROOT/pokered.gbc"
create_patch PureBlue "$BLUE_BASE" "$ROOT/pokeblue.gbc"
create_patch PureGreen "$GREEN_BASE" "$ROOT/pokegreen.gbc"

echo
echo "Release files written to: $RELEASE_DIR"
