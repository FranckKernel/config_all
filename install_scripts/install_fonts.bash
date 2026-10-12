#!/usr/bin/env bash

set -e

FONT="JetBrainsMono Nerd Font"

if [ -f /etc/os-release ]; then
	source /etc/os-release

	if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
		echo "Detected: Arch Linux"
		SYSTEM="arch"
	elif [[ "$ID" == "fedora" || "$ID_LIKE" == "fedora" ]]; then
		echo "Detected: Fedora Linux"
		SYSTEM="fedora"
	elif command -v apt-get >/dev/null 2>&1; then
		echo "Detected: Debian-based Linux ($ID)"
		SYSTEM="debian"
	else
		echo "Detected: Other Linux ($ID)"
		SYSTEM="linux"
	fi

elif [[ "$(uname)" == "Darwin" ]]; then
	echo "Detected: macOS"
	SYSTEM="macOS"

else
	echo "Unknown OS"
	exit 2
fi

case "$SYSTEM" in
arch)
	if pacman -Q ttf-jetbrains-mono-nerd >/dev/null 2>&1; then
		echo "$FONT is already installed."
	else
		echo "Installing $FONT..."

		if command -v yay >/dev/null 2>&1; then
			yay -S --needed --noconfirm ttf-jetbrains-mono-nerd
		elif command -v paru >/dev/null 2>&1; then
			paru -S --needed --noconfirm ttf-jetbrains-mono-nerd
		else
			sudo pacman -S --needed ttf-jetbrains-mono-nerd
		fi
	fi
	;;

fedora)
	if rpm -q jetbrains-mono-fonts >/dev/null 2>&1; then
		echo "$FONT is already installed."
	else
		echo "Installing $FONT..."
		sudo dnf install -y jetbrains-mono-fonts
	fi
	;;

macOS)
	if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
		echo "$FONT is already installed."
	else
		echo "Installing $FONT..."
		brew install --cask font-jetbrains-mono-nerd-font
	fi
	;;
debian)
	printf "\n\n\n================\n\n\n"
	printf "ON Debian machine!!!!"
	sudo apt -y install curl xz-utils fontconfig
	if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
		echo "JetBrainsMono Nerd Font is already installed."
	else
		echo "Installing JetBrainsMono Nerd Font..."

		sudo apt install -y curl xz-utils fontconfig
		mkdir -p ~/.local/share/fonts/JetBrainsMono

		curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz |
			tar -xJ -C ~/.local/share/fonts/JetBrainsMono

		fc-cache -f
	fi

	;;

linux)
	echo "Unsupported Linux distribution: $ID"
	echo "Please install JetBrainsMono Nerd Font manually."
	exit 2
	;;
esac

echo "$FONT is ready."
