> [!NOTE]
> Hyprland port of [niri-dms](https://github.com/aier9500/niri-dms). **Hyprland 0.56+ required** (Lua config).

> [!TIP]
> This repo uses a symlink: `~/.config/hypr` points to `~/.dotfiles/hypr-dms/hypr`. All Hyprland configs are edited in one place. `Mod` below is the Super key.

# Hyprland + DMS dotfiles

[DMS](https://danklinux.com) (DankMaterialShell) is the shell: bar, launcher, notifications, lock screen and settings GUI. Hyprland is the compositor underneath.

## Install

Fedora 44 or newer. The script enables three COPRs (community package repositories on Fedora's build service), installs Hyprland 0.56, DMS and ghostty, runs `dms setup`, and links `~/.config/hypr` to this repo. An existing `~/.config/hypr` is moved to a timestamped `.bak`.

```bash
git clone https://github.com/aier9500/hypr-dms ~/.dotfiles/hypr-dms
~/.dotfiles/hypr-dms/install.sh
```

Relogin and choose Hyprland. `Mod+Return` opens a terminal and `Mod+F4` quits Hyprland. Hyprland reloads on every save under `hypr/user`. `hypr/user/autostart.lua` starts DMS and fcitx5; add other startup programs there.

> [!WARNING]
> **Do not run `dms setup` by hand.** It rewrites `hypr/hyprland.lua` with the DMS default, through the `~/.config/hypr` symlink. That file loads `dms/binds.lua`, and the run refills it, so every DMS default bind fires next to its twin in `hypr/user/binds.lua` (`Mod+M` opens two panels, `Mod+Tab` toggles the overview twice). `install.sh` runs it on a plain directory first and keeps only `dms/`. DMS saves the replaced file under `hypr/.dms-backups/`.
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
> `Mod+Shift+/` opens the DMS keybind viewer. Binds that run a Lua function, and the resize submap (`Mod+R`), are listed by their `description`. Binds added in the DMS GUI land in `dms/binds-user.lua` and fire alongside any `hypr/user/binds.lua` bind on the same key. The viewer reports "dms binds are not loaded" and offers to add the include; decline, or every default fires twice again.

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

Optional — skip if you don't use multiple keyboard layouts. `hypr/user/autostart.lua` starts fcitx5 and sets `XMODIFIERS` for X11 compatibility. The layouts and the switch hotkey are managed in `fcitx5` itself (`fcitx5-configtool` GUI available). fcitx5 can only change the compositor layout on KDE and GNOME, so `hypr/user/inputs.lua` pins `kb_variant = "colemak_dh"` for Hyprland. Rime therefore receives Colemak keysyms; change `kb_variant` there if you type Rime on QWERTY.

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
