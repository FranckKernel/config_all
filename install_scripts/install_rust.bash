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

install_rustup() {
	if have pacman; then
		pkg_install rustup || return 1
		rustup default stable
	elif have apt; then
		# Debian: install rustup, then initialize the stable toolchain
		pkg_install rustup || return 1
		rustup default stable || return 1
	else
		pkg_install rustup || return 1
		if have brew; then
			export PATH="$(brew --prefix rustup)/bin:$PATH"
		fi
		rustup-init -y || return 1
		. "$HOME/.cargo/env"
	fi
}

install_rust() {
	pkg_install rust
}

setup_rust() {
	if have rustc || have cargo || have rustup || [ -x "$HOME/.cargo/bin/rustup" ]; then
		echo "rust already present, nothing to do"
		return 0
	fi

	echo "installing rustup..."
	if install_rustup; then
		return 0
	fi

	echo "rustup failed, falling back to rust..."
	install_rust
}

setup_rust
