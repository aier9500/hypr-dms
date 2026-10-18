sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf install -y hyprland

sudo dnf copr enable -y avengemedia/danklinux    # quickshell, ghostty
sudo dnf install -y ghostty

sudo dnf copr enable -y avengemedia/dms
sudo dnf install -y dms

systemctl --user add-wants hyprland-session.target dms.service