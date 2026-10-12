#!/usr/bin/env bash
# setup-mpd.sh - pull mpd/mpc configs from GitHub, create the files mpd.conf
# refers to (db, log, pid, state, sticker, playlists, fifo), then switch mpd
# from the system service to the user service.

# For now, mpd setup will be Linux Systemctl only
if [[ "$(uname -s)" != "Linux" ]]; then
	echo "Not Linux, skipping hyprland install."
	exit 0
fi

have() { command -v "$1" >/dev/null 2>&1; }
if ! have systemctl; then
	echo "No systemctl, I'm not gonna install mpd"
	exit 0
fi

if ! have mpd || ! have mpd; then
	echo "Install mpd and mpc yourself if you want it"
	exit 0
fi

set -euo pipefail

REPO="${REPO:-https://github.com/FranckKernel/config_all}"
BRANCH="${BRANCH:-}" # empty = default branch
MPD_CONF_DIR="$HOME/.config/mpd"
MPC_CONF_DIR="$HOME/.config/mpc"
FIFO="/tmp/mpd.fifo"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die() {
	printf '\033[1;31mxx\033[0m  %s\n' "$*" >&2
	exit 1
}

[ "$(id -u)" -ne 0 ] || die "Run as your normal user, not root."
command -v git >/dev/null || die "git is required."
command -v mpd >/dev/null || die "mpd is not installed."

# --- 1. fetch configs (repo root contains mpd/ and mpc/) ----------------------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

info "Cloning $REPO"
git clone --depth 1 ${BRANCH:+--branch "$BRANCH"} "$REPO" "$TMP/repo"

copy_cfg() { # copy_cfg <dir in repo> <destination>
	local src="$TMP/repo/$1" dest="$2"
	[ -d "$src" ] || {
		warn "'$1/' not found in repo, skipping"
		return
	}
	mkdir -p "$dest"
	if [ -n "$(ls -A "$dest" 2>/dev/null)" ]; then
		local bak="$dest.bak.$(date +%Y%m%d-%H%M%S)"
		cp -a "$dest" "$bak"
		info "Backed up existing $dest -> $bak"
	fi
	cp -a "$src"/. "$dest"/
	info "Installed $1/ -> $dest"
}

copy_cfg mpd "$MPD_CONF_DIR"
copy_cfg mpc "$MPC_CONF_DIR"

CONF="$MPD_CONF_DIR/mpd.conf"
[ -f "$CONF" ] || die "$CONF missing after copy; check the repo layout."

# MPD does not expand $HOME, so replace it with the real path
# if grep -q '\$HOME' "$CONF"; then
# 	sed -i "s|\$HOME|$HOME|g" "$CONF"
# 	info "Expanded \$HOME in $CONF"
# fi

# --- 2. create the files/dirs the config points to ---------------------------
info "Creating mpd files and directories"
mkdir -p "$HOME/.mpd"
mkdir -p "$MPD_CONF_DIR/playlists"
touch "$HOME/.config"/{database,log,pid,state}
touch "$HOME/.mpd"/{mpd.db,mpd.log,mpd.pid,mpd.mpdstate}
# make both since i switch between them when mpd breaks

[ -d "$HOME/Music/My Music" ] || warn "~/Music/My Music does not exist"

if [ ! -p "$FIFO" ]; then
	rm -f "$FIFO"
	mkfifo "$FIFO"
	info "Created FIFO $FIFO"
fi

# --- 3. stop system mpd, start user mpd --------------------------------------
info "Stopping and disabling system-wide mpd (needs sudo)"
sudo systemctl disable --now mpd.service mpd.socket 2>/dev/null || true
pkill -x mpd 2>/dev/null || true
sleep 1

info "Enabling and starting mpd in user mode"
systemctl --user daemon-reload
systemctl --user enable --now mpd.service

sleep 1
if command -v mpc >/dev/null; then
	mpc update || warn "mpc update failed, check the mpd log"
	mpc outputs || true
fi

info "Done. Status: systemctl --user status mpd"
