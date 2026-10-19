# First Steps

Run the `dependency.sh` to install all the programs used in this repo.

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

# Overview and App Switcher

This repo uses `hyprshell` for overview and app switcher, configurate with:

```bash
hyprshell config edit
```
