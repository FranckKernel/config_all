#!/usr/bin/env bash

# Hyprland is Linux only
if [[ "$(uname -s)" != "Linux" ]]; then
	echo "Not Linux, skipping hyprland install."
	exit 0
fi

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

I3_REPO="https://github.com/FranckKernel/config_i3"
I3_DIR="$HOME/.config/i3"

POLYBAR_REPO="https://github.com/FranckKernel/config_polybar"
POLYBAR_DIR="$HOME/.config/polybar"

safe_clone "$I3_REPO" "$I3_DIR"
safe_clone "$POLYBAR_REPO" "$POLYBAR_DIR"
