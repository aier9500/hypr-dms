# First Steps

Run the `dependency.sh` to install all the programs used in this repo. It also installs [Dank ASUS Control Center](https://github.com/aier9500/DankAsusControl) into DMS plugins; add `dankAsusControlCenter` to a bar section in DMS settings afterwards.

# Lockscreen Optimisation With Gaze

> [!tip]
> The following allows DMS lock screen to skip face unlock when you input your password, reducing the annoying wait time when face recognition doesn't work.

**First**

```bash
cp ~/.local/state/DankMaterialShell/pam/dankshell ~/.local/state/DankMaterialShell/pam/dankshell-gaze
$EDITOR ~/.local/state/DankMaterialShell/pam/dankshell-gaze
```

Swap the order so that the line

`auth    sufficient  pam_unix.so nullok try_first_pass`

is before

`auth    sufficient  pam_gaze.so`

as such:

```ini
auth    sufficient  pam_unix.so nullok try_first_pass
auth    sufficient  pam_gaze.so
```

**Second**

In `~/.config/DankMaterialShell/settings.json`,

set `lockPamPath` to the `dankshell-gaze` file as such:

```json
"lockPamPath": "/home/aier/.local/state/DankMaterialShell/pam/dankshell-gaze",
```

# ProArt Key

The ProArt key (top-right, next to power) sends a raw HID report the kernel doesn't map to any key, so Hyprland and keyd never see it. `proart-key/` holds a listener that reads the keyboard's `hidraw` device and toggles the Dank ASUS Control popout, G-Helper style.

```bash
./proart-key/install.sh    # already run by dependency.sh
```

Installs a udev rule (the one `sudo` step), the script to `~/.local/bin`, and a user service. Change `ACTION` in `proart-key/proart-key` to run something else.

# App Switcher

This repo uses `hyprshell` for app switcher, configure with:

```bash
hyprshell config edit
```
