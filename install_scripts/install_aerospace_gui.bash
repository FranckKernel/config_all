#!/usr/bin/env bash

# AeroSpace + SketchyBar are macOS only
if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "Not macOS, skipping aerospace/sketchybar install."
	exit 0
fi

AEROSPACE_REPO="https://github.com/FranckKernel/config_aerospace"
AEROSPACE_DIR="$HOME/.config/aerospace"
AEROSPACE_CONFIG="$HOME/.aerospace.toml"

SKETCHYBAR_REPO="https://github.com/FranckKernel/config_sketchybar"
SKETCHYBAR_DIR="$HOME/.config/sketchybar"

# ---------- GitHub config ----------
# Back up an existing config with a timestamp.
safe_clone() {
	local repo="$1"
	local dir="$2"

	if [[ -e "$dir" || -L "$dir" ]]; then
		mv "$dir" "${dir}.bak.$(date +%Y%m%d-%H%M%S)" || {
			echo "could not back up $dir" >&2
			return 1
		}
	fi

	git clone "$repo" "$dir" || {
		echo "git clone failed: $repo" >&2
		return 1
	}
}

# Create a symlink, backing up whatever is already at the destination.
# Skips if the link is already correct.
safe_link() {
	local src="$1"
	local dest="$2"

	if [[ ! -e "$src" ]]; then
		echo "link source missing: $src" >&2
		return 1
	fi

	# Already the right symlink: nothing to do
	if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
		echo "already linked: $dest"
		return 0
	fi

	# Something else is there (file, dir, or a different symlink): back it up
	if [[ -e "$dest" || -L "$dest" ]]; then
		mv "$dest" "${dest}.bak.$(date +%Y%m%d-%H%M%S)" || {
			echo "could not back up $dest" >&2
			return 1
		}
	fi

	ln -s "$src" "$dest" || {
		echo "ln failed: $dest" >&2
		return 1
	}
}

safe_clone "$AEROSPACE_REPO" "$AEROSPACE_DIR"
safe_clone "$SKETCHYBAR_REPO" "$SKETCHYBAR_DIR"

safe_link "$AEROSPACE_DIR/.aerospace.toml" "$AEROSPACE_CONFIG"

# ---------- Packages ----------
have() { command -v "$1" >/dev/null 2>&1; }

if ! have brew; then
	echo "Homebrew is required but was not found." >&2
	exit 1
fi

brew install --cask nikitabobko/tap/aerospace
brew install sketchybar

echo "AeroSpace and SketchyBar installed."
echo "Log out/restart your session if necessary, then start AeroSpace."
