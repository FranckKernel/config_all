#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
	alias mv='gmv'
fi

# Ensure the logs directory exists
mkdir -p ~/.config/nvim_logs

# Backup existing ~/.config/nvim if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/nvim ] && mv --backup=numbered ~/.config/nvim ~/.config/nvim_backup
# need coreutils, gmv on mac

mkdir -p ~/.config/nvim

# Clone the Neovim configuration repository and the submodules
git clone --branch fully_lazy https://github.com/FranckKernel/config_nvim ~/.config/nvim --recurse-submodules

#or, two parter:
git clone https://github.com/FranckKernel/config_nvim ~/.config/nvim
cd ~/.config/nvim || {
	echo "could not cd"
	return 1
}

git submodule update --init --recursive

# and other update:
git pull --recurse-submodules
git submodule update --recursive --remote

# ========================== Need tree-sitter-cli
cargo install tree-sitter-cli

# ============================ Need the submodules
git submodule init
# This reads .gitmodules and sets up the local configuration for the submo

git submodule update --recursive
# This fetches all submodule commits and checks them out.

git submodule update --remote --recursive

# Get luarocks
