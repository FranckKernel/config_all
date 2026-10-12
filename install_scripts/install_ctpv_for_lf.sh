#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
fi

have() { command -v "$1" >/dev/null 2>&1; }

# Try the package manager first
install_ctpv() {
	if have yay; then
		yay -S --needed --noconfirm ctpv
	elif have paru; then
		paru -S --needed --noconfirm ctpv
	elif have brew; then
		brew install ctpv
	elif have apt; then
		sudo apt update
		sudo apt install -y ctpv # probably not in Debian repos, falls back to the manual build
	elif have dnf; then
		sudo dnf install -y ctpv --skip-unavailable
	else
		echo "Could not find a known package manager. Please install ctpv manually."
		return 1
	fi
}

# Manual build, works on Debian-based and Fedora-based systems
install_ctpv_manual() {
	# Install build dependencies
	if have apt; then
		sudo apt update
		sudo apt install -y build-essential git libmagic-dev
	elif have dnf; then
		sudo dnf install -y file-devel git make gcc
	else
		echo "Manual build only supports apt and dnf systems."
		return 1
	fi

	# Build in a subshell so the cd never leaks into the caller
	(
		tmp_dir=$(mktemp -d) || {
			echo "Failed to create temp dir"
			exit 1
		}
		trap 'rm -rf "$tmp_dir"' EXIT
		git clone https://github.com/NikitaIvanovV/ctpv "$tmp_dir/ctpv" || exit 2
		cd "$tmp_dir/ctpv" || exit 3
		make || exit 4
		sudo make install || exit 5
	) || return $?

	echo "ctpv installed successfully!"
}

install_ctpv
last_status=$?

# If the package manager route failed, build from source
if [ $last_status -ne 0 ]; then
	echo "Package install failed. Trying manual build..."
	install_ctpv_manual
	last_status=$?
fi

exit $last_status
