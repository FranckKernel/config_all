#!/usr/bin/env bash

# Detect OS
if [ -f /etc/os-release ]; then
	source /etc/os-release
	if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
		echo "Detected: Arch Linux"
		SYSTEM="arch"
	elif [[ "$ID" == "fedora" || "$ID_LIKE" == "fedora" ]]; then
		echo "Detected: Fedora Linux"
		SYSTEM="fedora"
		sudo dnf copr enable dejan/lazygit
	else
		echo "Detected: Other Linux ($ID)"
		SYSTEM="linux"
	fi
elif [[ "$(uname)" == "Darwin" ]]; then
	echo "Detected: macOS"
	SYSTEM="macOS"
else
	echo -e "\n\n-------------------WARNING: Unknown OS---------------------------------\n\n"
	printf "Check package_install.sh, and manually download the packages\n"
	exit 2
fi

# Packages list (common for all supported systems)
PKGS=(
	zoxide
	atuin
	thefuck
	fzf
	bat
	ripgrep
	fd
	tmux
	lf
	lsd
	lazygit
	neovim
	eza
	jq
	tree
	kitty
	git
	coreutils
	curl
	wget
	luarocks
	# luarocks is for neovim image.nvim, but fuck it, putting it here
)

ARCH_PKG=(
	xclip
	wl-clipboard
	neofetch
)

ALL_PKGS=(
	"${PKGS[@]}"
	"${ARCH_PKG[@]}"
)

have() { command -v "$1" >/dev/null 2>&1; }

pkg_install() {
	if have yay; then
		yay -S --needed --noconfirm "$@"
	elif have paru; then
		paru -S --needed --noconfirm "$@"
	elif have pacman; then
		sudo pacman -S --needed --noconfirm "$@"
	elif have dnf; then
		sudo dnf install -y "$@"
	elif have brew; then
		brew install "$@"
	elif have zypper; then
		sudo zypper install -y "$@"
	elif have apt; then
		sudo apt update
		sudo apt install -y "$@"
	else
		echo "no supported package manager found" >&2
		return 1
	fi
}

# Install packages
if [[ "$SYSTEM" == "arch" ]]; then
	echo -e "\n\n--------Installing Arch Linux Packages -------------\n\n"
	if have yay; then
		echo "Using yay to install packages..."
		yay -S --needed --noconfirm "${ALL_PKGS[@]}"
	elif have paru; then
		echo "Using paru to install packages..."
		paru -S --needed --noconfirm "${ALL_PKGS[@]}"
	else
		echo "Falling back to pacman..."
		sudo pacman -S --needed "${ALL_PKGS[@]}"
	fi

elif [[ "$SYSTEM" == "fedora" ]]; then
	echo -e "\n\n--------Installing Fedora Packages -------------\n\n"
	# --skip-unavailable avoids failure if a package doesn't exist
	sudo dnf install -y "${PKGS[@]}" --skip-unavailable

elif [[ "$SYSTEM" == "macOS" ]]; then
	echo -e "\n\n--------Installing macOS Packages -------------\n\n"
	brew install "${PKGS[@]}"

else
	echo -e "\n\n--------Installing Other Linux Packages -------------\n\n"
	# Try apt (Debian/Ubuntu), zypper (openSUSE), or pacman fallback
	if have apt; then
		sudo apt update
		sudo apt install -y "${PKGS[@]}"
	elif have zypper; then
		sudo zypper install -y "${PKGS[@]}"
	elif have pacman; then
		sudo pacman -S --needed "${PKGS[@]}"
	else
		echo "No known package manager found. Please install manually: ${PKGS[*]}"
	fi
fi

# Note: pip / conda setup handled separately as needed
