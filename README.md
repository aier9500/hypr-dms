# hypr-dms

Hyprland that works out of the box. [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (DMS) gives you the bar, launcher, settings app and lock screen. This repo adds Windows-style shortcuts, workspaces per monitor, smooth iOS-style animations, CJK input, and fixes for hardware Hyprland doesn't handle on its own.

# Install (Fedora)

Paste this into a terminal:

```bash
sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf copr enable -y avengemedia/danklinux
sudo dnf copr enable -y avengemedia/dms
sudo dnf copr enable -y duxlabs/dux-repo
sudo dnf install -y hyprland dms ghostty dux-files-git fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime

dms setup headless --compositor hyprland --terminal ghostty
git clone https://github.com/aier9500/hypr-dms ~/.dotfiles/hypr-dms
ln -s ~/.dotfiles/hypr-dms/user ~/.config/hypr/user
mkdir -p ~/.config/systemd/user
ln -s ~/.dotfiles/hypr-dms/systemd/hyprland-session.target.d ~/.config/systemd/user/
sed -i 's/^require("dms.binds")$/require("user")/' ~/.config/hypr/hyprland.lua
```

Log out, pick **Hyprland** on the login screen, and log in.

# First Login

Open DMS Settings with `Super+I` and set:

1. **Keyboard layout.** For Colemak-DH: layout `us`, variant `colemak_dh`.
2. **Focus follows mouse.** DMS turns it off by default.
3. **Autostart.** Add apps you want running at login.

Optional extras:

- ASUS laptop: [Dank ASUS Control](https://github.com/aier9500/DankAsusControl) adds power profiles, GPU mode and the ProArt key.
- Face unlock on the lock screen: [Gaze setup in aier's Fedora](https://tuxies-wiki.theoryy.dev/guides/aiers-fedora/).

# Shortcuts

| Keys                | Does                                               |
| ------------------- | -------------------------------------------------- |
| `Super+S`           | App launcher                                       |
| `Super+Return`      | Terminal                                           |
| `Super+E`           | Files                                              |
| `Super+Q`           | Close window                                       |
| `Super+1`–`Super+0` | Go to workspace 1–10                               |
| `Super+Shift+1`–`0` | Move window to workspace 1–10                      |
| `Super+Tab`         | Overview of all windows                            |
| `Super+Arrows`      | Focus the window in that direction                 |
| `Super+T`           | Float or tile the window                           |
| `Super+F`           | Fullscreen                                         |
| `Super+X`           | Scratch space, a hidden workspace you can pop open |
| `Super+V`           | Clipboard history                                  |
| `Super+Shift+S`     | Screenshot                                         |
| `Super+L`           | Lock                                               |

# What Each File Does

| File                  | What it's for                                                                                                                                                                                                                                                                                                            |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `user/local.lua`      | Hardware fixes, on by default. Hyprland lacks macOS-level polish, and some devices are unusable without these. Ships with a Magic Trackpad fix (otherwise it gets flat mouse acceleration) and turns off auto-HDR for fullscreen video, which washes out colours on OLED screens. Edit or delete lines for your machine. |
| `user/binds.lua`      | Default shortcuts. Your changes in DMS Settings → Keybinds win over these.                                                                                                                                                                                                                                               |
| `user/workspaces.lua` | Workspaces per monitor, and the workspace shortcuts.                                                                                                                                                                                                                                                                     |
| `user/init.lua`       | Loads the files above, plus CJK input, gesture tuning and animations.                                                                                                                                                                                                                                                    |
| `systemd/`            | Lets DMS Autostart entries run at login. Without it, DMS warns that `xdg-desktop-autostart.target` isn't active.                                                                                                                                                                                                         |
