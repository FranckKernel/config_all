#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
	alias mv='gmv'
fi

# This rely on gnu mv (--backup=numbered). So alias mv=gmv on mac

# Backup existing ~/.config/kitty if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/kitty ] && mv --backup=numbered ~/.config/kitty ~/.config/kitty_backup

# Clone the repository if ~/.config/kitty does not exist
git clone https://github.com/FranckKernel/config_kitty ~/.config/kitty
