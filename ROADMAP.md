# ROADMAP

Single TODO list and change log. Setup and keybinds live in `README.md`.

## TODO

- [ ] First-boot test on hardware: `install.sh` from a clean clone, `autostart.lua` bringing up dms.service without the `add-wants` symlink, dankswitcher confirm on Alt release, gesture feel, master layout defaults, OpenWhispr native backend and its `pcall(require)` edit to `hyprland.lua`, `toggle_float_centered` monitor fields, `dms:` layer namespaces.
- [ ] Wallpapers: link to niri-dms (current), git-lfs, or copy.
- [ ] hyprshot binds if `dms screenshot` region UI disappoints.

## Changes

- 2026-10-17 — Repo created from niri-dms. Hyprland 0.56+ Lua config, DMS shell, master layout with cycle bind, scratch special workspace, resize submap, three gestures, dankswitcher on Alt+Tab, DMS overview on Mod+Tab. Plan: `action-plans/hypr-dms.md`.
- 2026-10-17 — Dropped `hypr/template/`; `hypr/user/*` is tracked. `hyprland.lua` loads `dms/*` via `pcall(require)` and no longer loads `dms/binds.lua`: `hl.bind` stacks, so DMS defaults double-fired every shared key (`Mod+M`, `Mod+Tab`). The 3-finger swipe, once shadowed by the DMS copy, stays in `user/inputs.lua`. `kb_variant = "colemak_dh"` pinned in `user/inputs.lua`; fcitx5 cannot set Hyprland's layout.
- 2026-10-17 — `install.sh` replaces the README install steps. `user/fcitx5.lua` became `user/autostart.lua`, which also starts `dms.service`; the `hyprland-session.target.wants/dms.service` symlink is gone.
- 2026-10-17 — Layouts reduced to master and dwindle; `Mod+Shift+Space` toggles. `consume_or_expel` binds removed (master layout rejected them at runtime). Bar and island blur now sample windows beneath: xray rules dropped from `dms/layout.lua`, blur rule for `dms:bar|dankisland` added in `theme.lua`.
- 2026-10-17 — `Mod+T` toggles floating both ways (`float({ action = "toggle" })`; bare `float()` only set it). `Mod+C` centres. `Mod+Home/End` and `Mod[+Shift]+Equal/Minus` removed. Global animation curve `apple` (iOS sheet easing 0.32, 0.72, 0, 1) replaces Hyprland's long-tailed default.
