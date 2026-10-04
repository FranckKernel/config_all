#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
	alias mv='gmv'
fi

git_clone() {
	# Backup existing ~/.config/lf if it exists, using numbered backups (~1, ~2, etc.)
	[ -d ~/.config/lf ] && mv --backup=numbered ~/.config/lf ~/.config/lf_backup

	# Clone the lf configuration repository
	git clone https://github.com/PoutineSyropErable/config_lf ~/.config/lf
}

# git_clone

# ================== Actually Installing Lf itself:
#!/usr/bin/env bash
set -euo pipefail

# --- detect system ---
SYSTEM="unknown"
if [[ "$(uname)" == "Darwin" ]]; then
	SYSTEM="macos"
elif [[ -f /etc/os-release ]]; then
	. /etc/os-release
	like=" ${ID_LIKE:-} "
	if [[ "$ID" == "arch" || "$like" == *" arch "* ]]; then
		SYSTEM="arch"
	elif [[ "$ID" == "fedora" || "$like" == *" fedora "* ]]; then
		SYSTEM="fedora"
	else
		SYSTEM="linux"
	fi
fi

echo "Detected: $SYSTEM"
[[ "$SYSTEM" == "unknown" ]] && {
	echo "Unsupported OS"
	exit 2
}

# --- fallback: official release binary ---
install_lf_binary() {
	local os arch url dest="$HOME/.local/bin"

	case "$(uname -s)" in
	Linux) os="linux" ;;
	Darwin) os="darwin" ;;
	*)
		echo "Unsupported OS for binary install"
		return 2
		;;
	esac

	case "$(uname -m)" in
	x86_64 | amd64) arch="amd64" ;;
	aarch64 | arm64) arch="arm64" ;;
	armv7l) arch="arm" ;;
	i386 | i686) arch="386" ;;
	*)
		echo "Unsupported architecture: $(uname -m)"
		return 2
		;;
	esac

	url="https://github.com/gokcehan/lf/releases/latest/download/lf-${os}-${arch}.tar.gz"
	mkdir -p "$dest"
	echo "Downloading $url"
	curl -fsSL "$url" | tar -xz -C "$dest" lf
	chmod +x "$dest/lf"
	echo "Installed to $dest/lf"
	case ":$PATH:" in
	*":$dest:"*) ;;
	*) echo "Add $dest to your PATH." ;;
	esac
}

# --- install lf ---
if command -v lf >/dev/null 2>&1; then
	echo "lf is already installed: $(lf -version)"
else
	case "$SYSTEM" in
	arch)
		sudo pacman -S --needed --noconfirm lf
		;;
	fedora)
		sudo dnf install -y lf || install_lf_binary
		;;
	macos)
		if command -v brew >/dev/null 2>&1; then
			brew install lf
		else
			install_lf_binary
		fi
		;;
	linux)
		install_lf_binary
		;;
	esac
fi

# --- starter config ---
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/lf/lfrc"
if [[ ! -f "$cfg" ]]; then
	mkdir -p "$(dirname "$cfg")"
	curl -fsSL https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfrc.example -o "$cfg"
	echo "Wrote starter config to $cfg"
fi

echo "Done. Run: lf"
