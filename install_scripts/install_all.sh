#!/usr/bin/env bash

set -e

BASE_URL="https://raw.githubusercontent.com/FranckKernel/config_all/desktop/install_scripts"

# --- Make sure common install locations are on PATH for all child scripts ---
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/.deno/bin:$HOME/go/bin:$HOME/.local/share/nvim/mason/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# --- Homebrew on Linux/macOS (if present) ---
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
elif [[ -x /opt/homebrew/bin/brew ]]; then
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# --- Guarantee standard system dirs are present (append, don't duplicate) ---
for d in /usr/bin /usr/sbin /bin /sbin; do
	case ":$PATH:" in
	*":$d:"*) ;;          # already present → skip
	*) PATH="$PATH:$d" ;; # append if missing
	esac
done
export PATH

# Some Rust installers expect these
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"

SCRIPTS=(
	install_rust.bash
	package_install_commands.sh
	install_fonts.bash
	install_kitty.bash
	install_zsh.bash
	install_tmux.bash
	install_lf.bash
	install_ctpv_for_lf.sh
	install_nvim.bash
	install_mpd.bash
	install_i3.bash
	install_hyprland_gui.bash
	install_aerospace_gui.bash
)

for script in "${SCRIPTS[@]}"; do
	printf "\n\n=========== Installing and configuring %s ======= \n\n" "$script"
	curl -fsSL "$BASE_URL/$script" | bash
done

printf -- "\n\n=================== IT WAS ALL INSTALLED AND IT WORKED YAY!!!! ================\n\n"
