#!/usr/bin/env bash

# Hyprland is Linux only
if [[ "$(uname -s)" != "Linux" ]]; then
	echo "Not Linux, skipping hyprland install."
	exit 0
fi

HYPR_REPO="https://github.com/FranckKernel/config_hypr"
HYPR_DIR="$HOME/.config/hypr"

ROFI_REPO="https://github.com/FranckKernel/config_rofi"
ROFI_DIR="$HOME/.config/rofi"

WAYBAR_REPO="https://github.com/FranckKernel/config_ironbar"
WAYBAR_DIR="$HOME/.config/ironbar"

IRONBAR_REPO="https://github.com/FranckKernel/config_ironbar"
IRONBAR_DIR="$HOME/.config/ironbar"

# ---------- GitHub config ----------
# Back up an existing config with a timestamp. Numbered backups of a
# directory don't work well with mv, since it would move it *into* an
# existing backup dir.
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

safe_clone "$HYPR_REPO" "$HYPR_DIR"
safe_clone "$ROFI_REPO" "$ROFI_DIR"
safe_clone "$IRONBAR_REPO" "$IRONBAR_DIR"
safe_clone "$WAYBAR_REPO" "$WAYBAR_DIR"

# ---------- Packages ----------
have() { command -v "$1" >/dev/null 2>&1; }

# Edit this list to taste
if have pacman; then
	sudo pacman -S --needed --noconfirm \
		hyprland xdg-desktop-portal-hyprland kitty rofi hyprpaper hyprlock hypridle waybar ironbar polkit-kde-agent \
		network-manager-applet kanata swayosd
elif have dnf; then
	sudo dnf install -y \
		hyprland xdg-desktop-portal-hyprland kitty rofi hyprpaper hyprlock hypridle waybar ironbar polkit-kde \
		network-manager-applet kanata swayosd
else
	echo "no supported package manager (pacman/dnf) found" >&2
	exit 1
fi

echo "hyprland installed. Log out and pick Hyprland at your login screen, or run 'Hyprland' from a TTY."
