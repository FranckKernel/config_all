#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
	alias mv='gmv'
fi

# This rely on gnu mv (--backup=numbered). So alias mv=gmv on mac

# Backup existing ~/.config/tmux if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/tmux ] && mv --backup=numbered ~/.config/tmux ~/.config/tmux_backup

# Clone the repository if ~/.config/tmux does not exist
git clone https://github.com/FranckKernel/config_tmux ~/.config/tmux

# Backup existing ~/.tmux.conf if it exists, using numbered backups
[ -f ~/.tmux.conf ] && mv --backup=numbered ~/.tmux.conf ~/.tmux.conf.bak

# Create a symbolic link only if the cloned .tmux.conf exists
ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf

git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ====================== Need tmux sessionizer
[ -d ~/.config/tmux ] && mv --backup=numbered ~/.config/tmux-sessionizer ~/.config/tmux-sessionizer_backup

git clone https://github.com/FranckKernel/config_tmux-sessionizer ~/.config/tmux-sessionizer
ln -s ~/.config/tmux-sessionizer ~/.config/tmux-sessionizer-config

# And now the local executable (So it's in the path)
ln -s ~/.local/tmux-sessionizer/tmux-sessionizer ~/.local/bin/tmux-sessionizer

[ -d ~/.local/tmux-sessionizer ] && mv --backup=numbered ~/.local/tmux-sessionizer ~/.local/tmux-sessionizer_backup
git clone https://github.com/FranckKernel/tmux-sessionizer --depth=1 ~/.local/tmux-sessionizer
ln -s ~/.local/tmux-sessionizer ~/.local/tmux-sessionizer-local

#============= For macos, we need to replace /usr/bin/zsh with /bin/zsh
cd ~/.config/tmux || {
	echo "could not cd"
	return 1
}

if [[ "$(uname -s)" == "Darwin" ]]; then
	sed -i '' 's|/usr/bin/zsh|/bin/zsh|g' .tmux.conf
fi
