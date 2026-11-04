#!/bin/sh
# Installs everything this repo uses, then links its configs into ~/.config. Safe to rerun.
set -e
cd "$(dirname "$(readlink -f "$0")")"

sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf install -y hyprland

sudo dnf copr enable -y avengemedia/danklinux    # quickshell, ghostty
sudo dnf install -y ghostty

sudo dnf copr enable -y avengemedia/dms
sudo dnf install -y dms

# Apps the binds and autostart launch
sudo dnf install -y nautilus fastfetch fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.missioncenter.MissionCenter com.dec05eba.gpu_screen_recorder \
	com.microsoft.Edge io.github.zarestia_dev.rclone-manager

# Dank ASUS Control Center (DMS bar widget: power profile, wattage, dGPU, cardwire)

sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
sudo dnf install -y asusctl asusctl-rog-gui
sudo systemctl enable --now asusd.service
mkdir -p ~/.config/DankMaterialShell/plugins
[ -d ~/.config/DankMaterialShell/plugins/dankAsusControlCenter ] ||
	git clone https://github.com/aier9500/DankAsusControl.git ~/.config/DankMaterialShell/plugins/dankAsusControlCenter

# ProArt key → toggle the widget popout
./proart-key/install.sh

# Configs last; an existing ~/.config/hypr folder moves to ~/.config/hypr.bak
if [ -d ~/.config/hypr ] && [ ! -L ~/.config/hypr ]; then
	mv ~/.config/hypr ~/.config/hypr.bak
fi
ln -sfn "$PWD/hypr" ~/.config/hypr
mkdir -p ~/.config/fastfetch
ln -sf "$PWD/config.jsonc" ~/.config/fastfetch/config.jsonc
