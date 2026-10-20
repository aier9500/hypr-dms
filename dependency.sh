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