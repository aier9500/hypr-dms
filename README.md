# hypr-dms

A thin layer over [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (DMS) on Hyprland. DMS owns the shell, its settings and `~/.config/hypr/hyprland.lua`. This repo's `user/` folder adds only what DMS Settings can't set:

- Windows-style keybinds (`user/binds.lua`); DMS's keybind editor overrides any of them
- per-monitor workspaces 1–10, like niri (`user/workspaces.lua`)
- fcitx5 for Chinese input, touchpad gesture tuning, the iOS animation curve, a centred screen-share picker (`user/init.lua`)

# Install (Fedora)

1. Install Hyprland, DMS, Ghostty, Nautilus and fcitx5:

   ```bash
   sudo dnf copr enable -y lionheartp/Hyprland
   sudo dnf copr enable -y avengemedia/danklinux
   sudo dnf copr enable -y avengemedia/dms
   sudo dnf install -y hyprland dms ghostty nautilus fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime
   ```

2. Let DMS write its Hyprland config, then link `user/` into it:

   ```bash
   dms setup headless --compositor hyprland --terminal ghostty
   git clone https://github.com/aier9500/hypr-dms ~/.dotfiles/hypr-dms
   ln -s ~/.dotfiles/hypr-dms/user ~/.config/hypr/user
   sed -i 's/^require("dms.binds")$/require("user")/' ~/.config/hypr/hyprland.lua
   ```

   `require("user")` takes the place of DMS's stock binds. The keybind editor's overrides (`dms/binds-user.lua`) still load after it.

3. Log into Hyprland. In DMS Settings, set the keyboard layout (Colemak-DH: layout `us`, variant `colemak_dh`) and focus-follows-mouse; DMS's stock config turns it off.

On an ASUS laptop, add [Dank ASUS Control](https://github.com/aier9500/DankAsusControl) for power profiles, GPU mode and the ProArt key. For Gaze face unlock on the DMS lock screen, see [aier's Fedora](https://tuxies-wiki.theoryy.dev/guides/aiers-fedora/).

# Personal Additions

- Keybinds: DMS Settings → Keybinds. Changes land in `~/.config/hypr/dms/binds-user.lua`.
- Everything else (autostarts, per-device settings): `~/.config/hypr/local.lua`, outside the repo. `user/init.lua` loads it if present and shows its errors.

  ```lua
  hl.on("hyprland.start", function()
  	hl.exec_cmd("flatpak run io.github.zarestia_dev.rclone-manager")
  end)
  ```

# Per-Monitor Workspaces

Each monitor has its own workspaces 1–10, like niri. `Super+1`–`Super+0` switches workspaces on the focused monitor.

- A monitor that's on by itself always uses IDs 1–10. With two on, the external monitor uses 1–10 and the laptop uses 11–20. The DMS bar shows these raw IDs.
- `Super+G` moves windows left on a turned-off monitor's workspaces onto the current workspace.
- `user/hyprsplit/` is a vendored copy of [hyprsplit](https://github.com/shezdy/hyprsplit) at commit `6b00b67`, with one local patch: upstream treats `workspace_back_and_forth = 0` as on, so `Super+Ctrl+Left/Right` at the first or last workspace bounced to the previous one. To update it, copy the new `init.lua` over the old one and reapply the patch (search `local patch`) unless upstream fixed it.
