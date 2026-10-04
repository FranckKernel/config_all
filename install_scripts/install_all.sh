#!/usr/bin/env bash

set -e

BASE_URL="https://raw.githubusercontent.com/FranckKernel/config_all/desktop/install_scripts"

SCRIPTS=(
	install_fonts.bash
	install_zsh.bash
	install_tmux.bash
	install_lf.bash
	install_nvim.bash
)

for script in "${SCRIPTS[@]}"; do
	curl -fsSL "$BASE_URL/$script" | bash
done
