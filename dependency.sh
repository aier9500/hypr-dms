sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf install -y hyprland

sudo dnf copr enable -y avengemedia/danklinux    # quickshell, ghostty
sudo dnf install -y ghostty

sudo dnf copr enable -y avengemedia/dms
sudo dnf install -y dms

systemctl --user enable dms.service

# Hyprshell Alt-Tab switcher

sudo dnf install -y libadwaita-devel gtk4-layer-shell-devel
cargo install hyprshell

# Dank ASUS Control Center (DMS bar widget: power profile, wattage, dGPU, cardwire)

sudo dnf install -y asusctl asusctl-rog-gui    # needs Terra repo
systemctl enable --now asusd.service
mkdir -p ~/.config/DankMaterialShell/plugins
git clone https://github.com/aier9500/DankAsusControl.git ~/.config/DankMaterialShell/plugins/dankAsusControlCenter

# ProArt key → toggle the widget popout
./proart-key/install.sh