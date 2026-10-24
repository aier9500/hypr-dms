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

# App Switcher

This repo uses `hyprshell` for app switcher, configure with:

```bash
hyprshell config edit
```

# ProArt Key Toggle DankAsusControl

- Creates a service that listens to the keypress (not supported by the Linux kernel by default as of 2026-10-24).
- Makes it toggle DankAsusControl (custom fork).
