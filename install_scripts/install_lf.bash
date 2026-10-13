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
if [[ "$SYSTEM" == "unknown" ]]; then
	echo "Unsupported OS" >&2
	exit 2
fi

# (2) define BIN before any use
BIN="$HOME/.cargo/bin"
export PATH="$BIN:$HOME/.local/bin:$PATH"
# so what if its present twice, should help if called manually

have() { command -v "$1" >/dev/null 2>&1; }

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

safe_clone https://github.com/PoutineSyropErable/config_lf ~/.config/lf

# ================== Actually Installing Lf itself:

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
if have lf; then
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
		if have brew; then
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

if ! have cargo; then
	printf '\n\n cargo not found \n\n' >&2
	exit 1
fi

cargo install --force trashy

if [ -x "$BIN/trashy" ]; then
	: # already named trashy, nothing to do
elif [ -x "$BIN/trash" ] && file -b "$BIN/trash" | grep -q '^ELF'; then
	ln -sf "$BIN/trash" "$BIN/trashy"
else
	echo "No usable trashy binary found in $BIN" >&2
	exit 1
fi

echo "Done. Run: lf"
