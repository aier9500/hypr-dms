#!/usr/bin/env bash
# Fedora 44+. Installs Hyprland 0.56 + DMS, runs dms setup, links ~/.config/hypr to this repo.
# Re-runnable: existing dms/*.lua in the repo are kept.
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cfg=${XDG_CONFIG_HOME:-$HOME/.config}/hypr

sudo dnf copr enable -y lionheartp/Hyprland      # hyprland 0.56
sudo dnf copr enable -y avengemedia/danklinux    # quickshell, ghostty
sudo dnf copr enable -y avengemedia/dms
sudo dnf install -y hyprland xdg-desktop-portal-hyprland hyprland-guiutils dms ghostty

# dms setup must write to a real directory, or it overwrites the repo's hyprland.lua.
if [ -L "$cfg" ]; then
	rm "$cfg"
elif [ -d "$cfg" ]; then
	mv "$cfg" "$cfg.bak.$(date +%s)"
fi
dms setup headless --compositor hyprland        # writes $cfg/{hyprland.lua,dms/*} and hyprland-session.target
mkdir -p "$repo/hypr/dms"
cp -rn "$cfg/dms/." "$repo/hypr/dms/"
rm -rf "$cfg"
ln -sfn "$repo/hypr" "$cfg"
: > "$repo/hypr/dms/binds.lua"                   # DMS default keybinds; user/binds.lua replaces them

echo "Done. Log out and pick Hyprland at the login screen."
