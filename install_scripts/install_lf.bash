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

git_clone

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

have() { command -v "$1" >/dev/null 2>&1; }

if have trashy || [ -x "$HOME/.cargo/bin/trashy" ]; then
	echo "Done. Run: lf"
	exit 0
fi

# If only trash exists, check what it is
if [ -x "$BIN/trash" ]; then
	# If trash is a symlink already pointing to trashy, we're good
	# (shouldn't happen if trashy doesn't exist)
	# If trash is a wrapper calling trashy, we have a problem
	# If trash is the real binary, symlink trashy -> trash
	if file "$BIN/trash" | grep -q 'symbolic link'; then
		# It's a symlink; follow it
		target="$(readlink -f "$BIN/trash")"
		if [ "$target" = "$BIN/trashy" ]; then
			echo "Done."
			exit 0
		fi
	fi
	echo -e "\n\n\n =================== We have a trash already in cargo, if it's not trashy, but trash-cli, then we have an issue! ================ \n\n\n "
	ln -sf "$BIN/trash" "$BIN/trashy"
fi

if ! have cargo; then
	printf '\n\n cargo not found \n\n' >&2
	exit 1
fi

cargo install --force trashy

BIN="$HOME/.cargo/bin"
if [ -x "$BIN/trashy" ]; then
	: # already named trashy, nothing to do
elif [ -x "$BIN/trash" ] && file -b "$BIN/trash" | grep -q '^ELF'; then
	ln -sf "$BIN/trash" "$BIN/trashy"
else
	echo "No usable trashy binary found in $BIN" >&2
	exit 1
fi

echo "Done. Run: lf"
exit 0
# --- starter config ---
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/lf/lfrc"
if [[ ! -f "$cfg" ]]; then
	mkdir -p "$(dirname "$cfg")"
	curl -fsSL https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfrc.example -o "$cfg"
	echo "Wrote starter config to $cfg"
fi
