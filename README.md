> [!NOTE]
> Hyprland port of [niri-dms](https://github.com/aier9500/niri-dms). **Hyprland 0.56+ required** (Lua config).

> [!CAUTION]
> The commands in this README assume the repo lives at `~/.dotfiles/hypr-dms`.
> Clone it there with the command below, or adjust the `repo=` line in each block.

> [!TIP]
> This repo uses a symlink: `~/.config/hypr` points to `~/.dotfiles/hypr-dms/hypr`. All Hyprland configs are edited in one place. `Mod` below is the Super key.

# Hyprland + DMS dotfiles

[DMS](https://danklinux.com) (DankMaterialShell) is the shell: bar, launcher, notifications, lock screen and settings GUI. Hyprland is the compositor underneath.

## To clone this repo

```bash
mkdir -p ~/.dotfiles
git clone https://github.com/aier9500/hypr-dms ~/.dotfiles/hypr-dms
```

## Install Hyprland & DMS

### Installing packages on Fedora

Fedora 44 or newer. Hyprland 0.56 comes from a COPR (a community package repository on Fedora's build service).

```bash
sudo dnf copr enable lionheartp/Hyprland         # hyprland 0.56
sudo dnf copr enable avengemedia/danklinux       # quickshell, ghostty
sudo dnf copr enable avengemedia/dms
sudo dnf install hyprland xdg-desktop-portal-hyprland hyprland-guiutils dms ghostty
dms setup                                        # writes ~/.config/hypr/ files and the hyprland-session.target unit
systemctl --user add-wants hyprland-session.target dms   # DMS starts and stops with Hyprland
```

### Back up your current `~/.config/hypr`

Backs up `~/.config/hypr` to `~/.config/hypr.bak`. Skips when it is already a symlink, since moving a symlink to the repo would nest the folders.

```bash
[ -d ~/.config/hypr ] && [ ! -L ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.bak
```

### Scaffold, then link repo Hyprland configs to `~/.config/hypr`

> [!NOTE]
> The repo supplies config templates in `hypr/template`. The block below copies them to `hypr/user` (gitignored), where you edit them.
>
> The `hypr/dms/*.lua` files are also gitignored: DMS rewrites them (colours, cursor, outputs, GUI keybinds and window rules) as you use its GUI. The block copies the ones `dms setup` wrote from the backup, then creates empty placeholders for the rest so Hyprland does not fail on a missing `require`.

```bash
repo=~/.dotfiles/hypr-dms/hypr

ln -sfn "$repo" ~/.config/hypr                 # symlink repo hypr/ to ~/.config/hypr
mkdir -p "$repo/user" "$repo/dms"
cp -rn "$repo/template/." "$repo/user/"        # copy templates
cp -rn ~/.config/hypr.bak/dms/. "$repo/dms/" 2>/dev/null   # keep what dms setup wrote

# Stub loop for any DMS file still missing
for file in colors outputs layout cursor input binds binds-user windowrules; do
  if [ ! -e "$repo/dms/$file.lua" ]; then
    touch "$repo/dms/$file.lua"
  fi
done
```

Relogin and choose Hyprland. `Mod+Return` opens a terminal and `Mod+F4` quits Hyprland. After editing a file in `hypr/user`, run `hyprctl reload`.

> [!WARNING]
> **Do not re-run a full `dms setup`.** A full run always rewrites `hypr/hyprland.lua` with the DMS default, through the `~/.config/hypr` symlink, which removes this repo's `require` lines. It also refills `hypr/dms/binds.lua` with the DMS default keybinds, which then fire a second time next to the binds in `hypr/user/binds.lua`. DMS saves the replaced file under `hypr/.dms-backups/`.
>
> To recover, restore `hypr/hyprland.lua` from git, empty `hypr/dms/binds.lua`, and reload Hyprland:
>
> ```bash
> git -C ~/.dotfiles/hypr-dms checkout hypr/hyprland.lua && : > ~/.dotfiles/hypr-dms/hypr/dms/binds.lua && hyprctl reload
> ```
>
> If the screen is black, switch to a TTY with `Ctrl+Alt+F3`, log in, run the first two commands above, then run `hyprctl -i 0 reload`. The `-i 0` flag selects the first running Hyprland instance, which a TTY shell does not know about.

> [!TIP]
> Monitors (refresh rate, layout, scale) are set in DMS Settings → Displays, which writes `dms/outputs.lua`.

> [!TIP]
> Per-app window rules: `Mod+Shift+W` opens the DMS editor, which writes `dms/windowrules.lua`.

> [!TIP]
> `Mod+Shift+/` opens the DMS keybind viewer. Binds that run a Lua function, and the resize submap (`Mod+R`), are listed by their `description`.

### Alt+Tab window switcher (`dankswitcher`)

`dankswitcher` is a DMS plugin that shows an icon strip of open windows. Hold `Alt` and press `Tab` to cycle, release `Alt` to focus the selected window. `Mod+Tab` opens the DMS workspace overview instead.

```bash
mkdir -p ~/.local/src
git clone https://github.com/hkdb/dankswitcher ~/.local/src/dankswitcher
~/.local/src/dankswitcher/install.sh
dms ipc call plugin-scan scan
dms ipc call plugins enable dankswitcher
```

The `Alt` binds are already in `hypr/user/binds.lua`. If releasing `Alt` does not select the window, replace the dankswitcher binds with the commented fallback beside them, which makes `Alt+Tab` focus the previous window.

## Nvidia

Skip on AMD and Intel. Use the open kernel modules: required on RTX 50-series, recommended on Turing (GTX 16xx, RTX 20xx) and newer. RPM Fusion's prebuilt `kmod-nvidia` uses them by default ([RPM Fusion NVIDIA howto](https://rpmfusion.org/Howto/NVIDIA)). Then enable DRM modesetting and reboot:

```bash
echo 'options nvidia_drm modeset=1' | sudo tee /etc/modprobe.d/nvidia.conf
cat /sys/module/nvidia_drm/parameters/modeset   # prints Y after the reboot
```

See the [Hyprland Nvidia page](https://wiki.hypr.land/0.56.0/Nvidia/) for the rest.

### Nvidia High VRAM Fix

Optional. Nvidia drivers can hold on to freed VRAM in Wayland compositors. This driver profile limits the free buffer pool for the `Hyprland` process. Hyprland's wiki does not document it, so check VRAM use before and after. Relogin to apply.

```bash
sudo mkdir -p /etc/nvidia/nvidia-application-profiles-rc.d/
sudo tee /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json > /dev/null << 'EOF'
{
  "rules": [
    {
      "pattern": {
        "feature": "procname",
        "matches": "Hyprland"
      },
      "profile": "Limit Free Buffer Pool On Wayland Compositors"
    }
  ],
  "profiles": [
    {
      "name": "Limit Free Buffer Pool On Wayland Compositors",
      "settings": [
        {
          "key": "GLVidHeapReuseRatio",
          "value": 0
        }
      ]
    }
  ]
}
EOF
sudo chmod 644 /etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json
```

### Multi-GPU

> [!IMPORTANT]
> On multi-GPU machines (e.g. a laptop with a dGPU), render Hyprland on the iGPU to avoid dGPU wake-up lag. Add this line to `hypr/user/misc.lua`, with `cardN` from `ls -l /dev/dri/by-path`:
>
> ```lua
> hl.env("AQ_DRM_DEVICES", "/dev/dri/cardN")
> ```
>
> Card numbers can change between boots. The [Hyprland multi-GPU page](https://wiki.hypr.land/0.56.0/Configuring/Advanced-and-Cool/Multi-GPU/) shows stable udev symlinks. Single-GPU machines need nothing here.

## Wallpapers

Wallpapers are not in this repo. Take them from [niri-dms/wallpapers](https://github.com/aier9500/niri-dms/tree/master/wallpapers).

## fcitx5 + Rime Setup (Keyboard Layout Management, Chinese)

Optional — skip if you don't use multiple keyboard layouts. This repo's Hyprland config starts fcitx5 and sets `XMODIFIERS` for X11 compatibility (see `hypr/user/fcitx5.lua`). The layouts and the switch hotkey are managed in `fcitx5` itself (`fcitx5-configtool` GUI available).

```bash
sudo dnf install fcitx5 fcitx5-rime fcitx5-configtool
```

## Voice Typing (`OpenWhispr`)

Dictation with text cleanup.

OpenWhispr has a native Hyprland backend. It registers its hotkey through `hyprctl` and exposes a D-Bus service (`com.openwhispr.App`) that Hyprland binds call.

### Install OpenWhispr

Download the `.rpm` from the [OpenWhispr releases](https://github.com/OpenWhispr/openwhispr/releases/latest) and install it:

```bash
sudo dnf install ./OpenWhispr-*.rpm
```

Then install `wtype`, which OpenWhispr uses to type the result into other apps on Hyprland:

```bash
sudo dnf install wtype
```

Set up OpenWhispr within the GUI.

> [!TIP]
> **Dictation model recommendations:**
>
> GPU: Turbo\
> Capable iGPU: Small\
> Smaller models: Base, Tiny
>
> **Cleanup model recommendations:**
>
> GPU (4-6 GB VRAM): Gemma 4 E4B\
> GPU (6+ GB VRAM): Qwen 3.5 9B\
> Off-device: OpenWhispr Cloud, self-host, no cleanup.
>
> **My setup:**
> 4060 Mobile 8 GB VRAM, Turbo + Gemma 4 E4B.

### Hotkey

`Alt+Space` (in `hypr/user/binds.lua`) sends the dictation toggle to the running OpenWhispr:

```bash
dbus-send --session --type=method_call --dest=com.openwhispr.App /com/openwhispr/App com.openwhispr.App.Toggle
```

Start OpenWhispr from the DMS launcher (`Mod+A`), focus another app, and press `Alt+Space`.

> [!IMPORTANT]
> Keep OpenWhispr's own dictation hotkey (Settings → Hotkeys) at its default, `Ctrl+Super`. If you set it to `Alt+Space` too, both binds fire after a config reload and cancel each other.
>
> OpenWhispr writes its own bind to `hypr/openwhispr-binds.lua` (gitignored) and adds one `pcall(require, ...)` line to `hypr/hyprland.lua`. `git status` shows that line as a change; leave it.

### Window rule

`hypr/user/theme.lua` keeps only the rule for OpenWhispr's recording pill (the small floating recorder window) and places it 16px from the bottom-right corner without stealing focus.
