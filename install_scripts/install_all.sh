#!/usr/bin/env bash

set -e

BASE_URL="https://raw.githubusercontent.com/FranckKernel/config_all/desktop/install_scripts"

SCRIPTS=(
	install_rust.bash
	package_install_commands.sh
	install_fonts.bash
	install_kitty.bash
	install_zsh.bash
	install_tmux.bash
	install_lf.bash
	install_ctpv_for_lf.sh
	install_i3.bash
	install_nvim.bash
	install_mpd.bash
	install_hyprland_gui.bash
	install_aerospace_gui.bash
)

for script in "${SCRIPTS[@]}"; do
	printf "\n\n=========== Installing and configuring %s ======= \n\n" "$script"
	curl -fsSL "$BASE_URL/$script" | bash
done

printf -- "\n\n=================== IT WAS ALL INSTALLED AND IT WORKED YAY!!!! ================\n\n"
