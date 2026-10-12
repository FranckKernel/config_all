#!/usr/bin/bash

sudo apt update
sudo apt install -y sddm kde-plasma-desktop wl-clipboard
# It will ask, and put sddm as your default login/display manager
# You can reboot the rasberry pie from there. Should have a graphical user interface login
# It will ask for your name and password. And should have plasma (wayland) and (x11) as option.
# Pick any.

# Webbrowser and terminal
sudo apt install -y firefox-esr kitty

# network and audio
sudo apt install -y network-manager plasma-nm
sudo apt install -y pipewire pipewire-pulse wireplumber plasma-pa

# Compiling, Interpreting and Build tools. (Needed for a lot of pacakges)
sudo apt install -y build-essential

# To get good tools (Those are CLI/Terminal Tools)
sudo apt install -y curl wget git vim nano           # text editor and getting stuff from the internet. You need these
sudo apt install -y fish zsh tmux lf                 # good tools (You NEED a terminal. So kitty is important). Needed for decent terminal. Fish has good defaults
sudo apt install -y atuin eza lsd zoxide lazygit bat # better and more niche tools (dependancy of stuff i recommend you use, some stuff broken without)

# Neovim is a better vim.
# sudo apt install -y neovim
# We'll install it another way

# si apres reboot pas de GUI environment:
# sudo systemctl enable --now sddm

# =================================             optional. Pour i3

# Another sound controller thing

if [[ "$1" == "i3" ]]; then
	sudo apt install -y i3

	# Needed for x11 as a whole
	sudo apt install -y x11-xserver-utils x11-utils arandr

	# Needed for i3
	sudo apt install -y xclip xdotool feh rofi picom brightnessctl pavucontrol waybar polybar
fi
