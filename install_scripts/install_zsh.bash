#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
	brew install coreutils
	alias mv='gmv'
fi

# Backup existing ~/.config/zsh if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/zsh ] && mv --backup=numbered ~/.config/zsh ~/.config/zsh_backup

# Clone the repository if ~/.config/zsh does not exist
git clone https://github.com/FranckKernel/config_zsh ~/.config/zsh

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak
#--backup == numbered is not posix complient, so figure it out.

cd ~/.config/zsh || {
	echo "could not cd"
	return 1
}
chmod 744 ./install_commands.sh
./zsh_clone_command.sh # clones oh-my-zsh and powerlevel-10k and other things
./package_install_commands.sh
# This also install a bunch of packages, look at it. It's a system wide install, you'll need
# admin privilede. It's supposed to just work for mac and arch. (I use arch only, mac was for friends)
# So, it should work on mac.

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak

# must do it first, because it will change the zsh config
[ -f ~/.p10k.zsh ] && mv --backup=numbered ~/.p10k.zsh ~/.p10k.zsh.bak
ln -s ~/.config/zsh/.p10k.zsh ~/.p10k.zsh

# Backup existing ~/.zshrc if it exists, using numbered backups
[ -f ~/.zshrc ] && mv --backup=numbered ~/.zshrc ~/.zshrc.bak
# Create a symbolic link. If this fail, then it is bad
ln -s ~/.config/zsh/.zshrc ~/.zshrc

# ----- Optional --------
./install_lf_config.sh
# ----- End of Optional -----
