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

# ProArt Key Toggle DankAsusControl

- Creates a service that listens to the keypress (not supported by the Linux kernel by default as of 2026-10-24).
- Makes it toggle DankAsusControl (custom fork).

# Per-Monitor Workspaces

Each monitor has its own workspaces 1–10, like niri. `Super+1`–`Super+0` switches workspaces on the focused monitor. The binds are in `hypr/user/workspaces.lua`.

- A monitor that's on by itself always uses IDs 1–10. With two on, the external monitor uses 1–10 and the laptop uses 11–20. The DMS bar shows these raw IDs.
- `Super+G` moves windows left on a turned-off monitor's workspaces onto the current workspace.
- `hypr/hyprsplit/` is a vendored copy of [hyprsplit](https://github.com/shezdy/hyprsplit) at commit `6b00b67`, with one local patch: upstream treats `workspace_back_and_forth = 0` as on, so `Super+Ctrl+Left/Right` at the first or last workspace bounced to the previous one. To update it, copy the new `init.lua` over the old one and reapply the patch (search `local patch`) unless upstream fixed it.
