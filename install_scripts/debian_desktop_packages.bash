#!/usr/bin/bash

sudo apt update
sudo apt install sddm kde-plasma-desktop
# It will ask, and put sddm as your default login/display manager
# You can reboot the rasberry pie from there. Should have a graphical user interface login
# It will ask for your name and password. And should have plasma (wayland) and (x11) as option.
# Pick any.

# Webbrowser and terminal
sudo apt install firefox-esr kitty

# network and audio
sudo apt install network-manager plasma-nm
sudo apt install pipewire pipewire-pulse wireplumber plasma-pa

# To get good tools (Those are CLI/Terminal Tools)
sudo apt install curl wget git vim nano           # text editor and getting stuff from the internet
sudo apt install fish zsh tmux lf                 # good tools (You NEED a terminal. So kitty is important)
sudo apt install atuin eza lsd zoxide lazygit bat # better and more niche tools (dependancy of stuff i recommend you use)

sudo apt install build-essential

# Neovim is a better vim.
sudo apt install neovim

# si apres reboot pas de GUI environment:
# sudo systemctl enable --now sddm

# =================================             optional. Pour i3

# Another sound controller thing

if [[ "$1" == "i3" ]]; then
	# Needed for x11 as a whole
	sudo apt install i3
	sudo apt install x11-server-utils x11-utils arandr

	# Needed for i3
	sudo apt install xdotool feh rofi picom brightnessctl pavucontrol
fi
