# hypr-dms: Niri + DMS dotfiles ported to Hyprland + DMS

Plan: 2026-10-17. Status: COUNCIL-AMENDED, awaiting go/no-go.

**Goal** — A sibling repo `~/Projects/hypr-dms` (GitHub `aier9500/hypr-dms`) that gives a Hyprland
0.56+ user the same experience `niri-dms` gives a Niri user: DMS as shell, the same keybind layout,
templates copied to a gitignored `user/` dir, DMS-managed fragments gitignored. Done when: every
Lua file loads under a real Lua VM, every `hl.*` identifier exists in the Hyprland v0.56.2 API
stub, every Niri bind has a Hyprland counterpart or a listed drop, the README installs from zero
on Fedora, and the initial commits are pushed.

**Decisions taken** (user, 2026-10-17; council amendments marked ◆)
- Config language: Lua (`hyprland.lua`). DMS refuses `dms setup` below Hyprland 0.55; the only
  Fedora package source ships 0.56.2, so the floor is 0.56 ◆.
- Alt-Tab: `dankswitcher` DMS plugin on `Alt+Tab`, binds written inline in `user/binds.lua`
  (the plugin's own Lua hard-wires Super+Tab and unbinds the user's) ◆. Overview: DMS
  `dms ipc call hypr toggleOverview` on `Mod+Tab`.
- Layout: `master` default. One bind cycles `master → dwindle → scrolling`. No notification ◆.
- New Hyprland features: one special workspace, a resize submap, three touchpad gestures.
- Screenshots: `dms screenshot` (ships with DMS; hyprshot is not packaged for Fedora releases) ◆.
- Wallpapers: not copied; README links to `niri-dms/wallpapers` (108 MB would be permanent in a
  public history) ◆.
- No hardware template. Nvidia and multi-GPU notes live in README only.
- OpenWhispr: native Hyprland backend; the shim and desktop override are dropped.
- Smallest initial commit. No speculative files, no "if cheap" items ◆.

## Layout of the new repo

```
hypr-dms/
  README.md
  ROADMAP.md
  .gitignore              # hypr/dms/**  hypr/.dms-backups/  hypr/user/*
  action-plans/hypr-dms.md
  hypr/
    hyprland.lua          # entry, see shape below
    template/             # copied to hypr/user/ by the README scaffold loop
      binds.lua           # all user keybinds, resize submap, layout cycle, dankswitcher binds
      inputs.lua          # touchpad, follow_mouse, warp, middle_click_paste=false, gestures
      theme.lua           # DMS layer blur rules, dankswitcher layer rule, no-CSD env, OpenWhispr window rule
      misc.lua            # general.layout, env vars (Electron/Qt/Nix), misc toggles
      fcitx5.lua          # fcitx5 autostart + XMODIFIERS
```

`hypr/dms/*.lua` are written by `dms setup` and the DMS GUI; gitignored. `hypr/user/*` are the
user's editable copies; gitignored.

**Entry file shape** (`hyprland.lua`, in this order):
1. `hl.on("hyprland.start", ...)` running `dbus-update-activation-environment --systemd --all`
   then `systemctl --user start hyprland-session.target`, copied word for word from the DMS
   embedded template including its `DMS_STARTUP_BEGIN/END` markers.
2. Three emergency binds: `SUPER + Return` terminal, `SUPER + Q` close, `SUPER + F4` exit. A
   broken user file still yields a terminal.
3. Literal `require` lines, one per module (the DMS keybind parser follows only literal
   `require("x")`; wildcards and `pcall` make user binds invisible in the cheat sheet):
   `dms.colors`, `dms.outputs`, `dms.layout`, `dms.cursor`, `dms.input`, `dms.binds`,
   `dms.windowrules`, then `user.misc`, `user.inputs`, `user.theme`, `user.fcitx5`,
   `user.binds`, then `dms.binds-user` last. `hl.unbind` removes only earlier binds, so DMS GUI
   edits in `binds-user.lua` must load after the repo binds. One comment line states this.

## Steps

0. **Scaffold** — play. DONE except ROADMAP: `git init`, `.gitignore`, `.gitattributes`, this plan.

1. **Lua config set** — `task-executor-high`. Write `hypr/hyprland.lua` and the five templates.
   Sources (fetch; never write from memory): Hyprland v0.56.2 `example/hyprland.lua`; wiki
   markdown under `hyprland-wiki/content/configuring/` (core/binds, dispatchers, rules, layouts,
   gestures); DMS embedded `hyprland.lua` and `hypr-binds.lua`
   (`DankMaterialShell/core/internal/config/embedded/`); `hkdb/dankswitcher` `dankswitcher.lua`.
   The generated API stub for v0.56.2 already exists at
   `/tmp/claude-1000/-home-aier-Projects-niri-dms/0af4008d-caa5-4b0b-839b-77a7c3625a42/scratchpad/hl-stubs-0.56.2.lua`.
   Key spelling: `SUPER + SHIFT + T` (DMS spelling: uppercase modifiers, spaces around `+`).
   Every bind on one line; logic goes in a named `local function` bound with a `description`.
   Bind mapping from `niri-dms/niri/template/binds.kdl` (same keys unless listed):
   - `SUPER + Tab` → exec `dms ipc call hypr toggleOverview`; `SUPER + SHIFT + Tab` → `hypr closeOverview`.
   - dankswitcher inline: `ALT + Tab` → `hl.dsp.global("dankswitcher:next")`, `ALT + SHIFT + Tab`
     → `"dankswitcher:prev"`, `ALT + ALT_L` and `ALT + ALT_R` → `"dankswitcher:select"` with
     `{ release = true }`. Commented one-line fallback beside them: `hl.dsp.focus({ last = true })`.
   - `SUPER + Q`, `ALT + F4` → `hl.dsp.window.close()`. `SUPER + F` → fullscreen mode maximized;
     `SUPER + SHIFT + F` → fullscreen. `SUPER + T` → `toggle_float_centered`: float toggle, then
     if floating resize to 50%×65% of the monitor and center (use `hl.get_active_window()` or the
     documented equivalent). `SUPER + SHIFT + T` → `cycle_next({ floating = true })`.
   - Arrows: `SUPER + arrows` focus by direction, `SUPER + SHIFT + arrows` move window by direction.
     `SUPER + Home` → `layout("focusmaster")`, `SUPER + End` → `layout("swapwithmaster")`.
     `SUPER + ALT + Left/Right` → `hl.dsp.layout("consume_or_expel prev|next")` plain dispatcher
     (acts in the scrolling layout, no-op elsewhere).
   - `SUPER + Equal/Minus` → `window.resize` ±100 px width; `SUPER + SHIFT + Equal/Minus` ±100 px height.
   - `SUPER + R` → `hl.dsp.submap("resize")`; `hl.define_submap("resize", ...)`: arrows resize by
     50 px, `Escape` and `Return` → `hl.dsp.submap("reset")`.
   - `SUPER + SHIFT + Space` → `cycle_layout`: table `{"master","dwindle","scrolling"}`, index,
     `hl.config({ ["general.layout"] = ... })`. Reverts on reload; a comment says so.
   - Special workspace `scratch`: `SUPER + Grave` → `workspace.toggle_special("scratch")`;
     `SUPER + SHIFT + Grave` → `window.move({ workspace = "special:scratch" })`.
   - Workspaces: `SUPER + 1..9` focus, `SUPER + SHIFT + 1..9` move, `SUPER + Page_Up/Down` →
     `focus({ workspace = "r-1"|"r+1" })`, `SUPER + SHIFT + Page_Up/Down` move likewise,
     `SUPER + mouse_down/mouse_up` workspace switch (global `binds.scroll_event_delay = 500`),
     `SUPER + mouse_left/right` focus window l/r, `SUPER + CTRL + arrows` focus monitor,
     `SUPER + CTRL + SHIFT + arrows` move window to monitor.
   - Screenshots: `Print`, `SUPER + SHIFT + S`, `XF86Launch1` → exec `dms screenshot`;
     `CTRL + Print`, `CTRL + XF86Launch1` → `dms screenshot full`; `ALT + Print`,
     `ALT + XF86Launch1` → `dms screenshot window`.
   - All other `dms ipc call` spawns, audio/brightness/mpris with `{ locked = true }`,
     `SUPER + F4` exit, `CTRL + ALT + Delete` powermenu, `ALT + Space` OpenWhispr dbus-send:
     unchanged commands.
   - Dropped, one comment line at the top of binds.lua: `toggle-keyboard-shortcuts-inhibit`,
     `center-column`, `center-visible-columns`, `move-workspace-up/down`, `switch-preset-column-width`,
     `reset-window-height`, per-bind `cooldown-ms`.
   `inputs.lua`: touchpad tap, natural scroll, dwt, two-finger scroll, clickfinger;
   `input.follow_mouse = 1`; `cursor.warp_on_change_workspace` and the focus-warp option that
   matches `warp-mouse-to-focus`; `misc.middle_click_paste = false`; `binds.scroll_event_delay = 500`.
   Gestures, one line each: 3-finger horizontal → `workspace`; 4-finger up → exec dispatcher
   `dms ipc call hypr toggleOverview`; 3-finger pinchin → `special`, `workspace_name = "scratch"`.
   `theme.lua`: only rules absent from the DMS embedded template. Blur + `ignore_alpha = 0` on
   `dms:(spotlight|clipboard|settings|control-center|notifications)`; `no_anim` on namespace
   `dankswitcher`; OpenWhispr pill: class `(?i)^open-whispr$` title `^Voice Recorder$`, float,
   `no_initial_focus`, `border_size = 0`, `no_shadow`, `no_blur`, `move` bottom-right 16 px via
   expressions; `hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")`.
   `misc.lua`: `general.layout = "master"` plus only master options that differ from defaults;
   `hl.env` for `ELECTRON_OZONE_PLATFORM_HINT=auto`, `QT_QPA_PLATFORM=wayland;xcb`,
   `NIXOS_OZONE_WL=1`; `misc.disable_hyprland_logo = true`.
   `fcitx5.lua`: `hl.on("hyprland.start", ...)` exec `fcitx5 -d`; `hl.env("XMODIFIERS", "@im=fcitx")`.
   Each template starts with a 1–2 line comment stating what DMS does not cover here. Comments
   `terse` per `/theoryy-docstyle`. No commented-out alternatives except the dropped list and
   the dankswitcher fallback.
   Done: (a) `python3 -m venv` + `pip install lupa` in the scratchpad; every `.lua` loads via
   `lupa` `load(src)`; (b) every `hl.` path and `hl.config` key used appears in
   `hl-stubs-0.56.2.lua`; (c) a stub `hl` table executes each template once without error;
   (d) report lists every bind above as present and the dropped list.

2. **README** — `task-executor-high`, parallel with step 1. Rewrite `niri-dms/README.md` for
   Hyprland, `/theoryy-docstyle` base. Sections, in order:
   - Origin line linking `niri-dms`; "Hyprland 0.56+ required".
   - Clone to `~/.dotfiles/hypr-dms`.
   - Fedora packages: `sudo dnf copr enable lionheartp/Hyprland`, `avengemedia/danklinux`,
     `avengemedia/dms`; `sudo dnf install hyprland xdg-desktop-portal-hyprland hyprland-guiutils dms`.
     Verify names at `https://copr.fedorainfracloud.org/api_3/monitor?ownername=lionheartp&projectname=Hyprland`.
     `solopasha/hyprland` is rawhide-only at 0.51; do not use it.
   - `dms setup`; `systemctl --user add-wants hyprland-session.target dms`; relogin.
   - Backup `~/.config/hypr` (run once, non-symlink only), symlink `repo/hypr` →
     `~/.config/hypr`, `cp -rn template/. user/`, stub loop touching
     `dms/{colors,outputs,layout,cursor,input,binds,binds-user,windowrules}.lua`.
   - **Re-running `dms setup`** warning: a full run rewrites `hyprland.lua` through the symlink and
     refills `dms/binds.lua` with DMS defaults, which then double-fire with the repo binds.
     Recovery: `git -C ~/.dotfiles/hypr-dms checkout hypr/hyprland.lua && : > ~/.dotfiles/hypr-dms/hypr/dms/binds.lua && hyprctl reload`.
     Stuck at a black screen: `hyprctl reload` from a TTY.
   - dankswitcher: clone, `./install.sh`, `dms ipc call plugin-scan scan`,
     `dms ipc call plugins enable dankswitcher`. Binds already live in `user/binds.lua` on Alt.
     Fallback line if Alt release misbehaves.
   - DMS settings tips kept: Displays, `Mod+Shift+W` window rules, `Mod+Shift+/` keybind viewer
     (functions and the resize submap show by description only).
   - Nvidia, 3 lines: open kernel modules, `nvidia_drm modeset=1`, VRAM profile JSON with
     `"matches": "Hyprland"`. Multi-GPU, 1 line: `hl.env("AQ_DRM_DEVICES", "/dev/dri/cardN")`.
   - Wallpapers: link to `niri-dms/wallpapers`.
   - fcitx5 section unchanged. OpenWhispr: install, `Alt+Space`, native Hyprland backend, no shim.
   Done: every shell block runs top to bottom on a fresh Fedora in the order written; package
   and command names verified against fetched sources; no Niri mention beyond the origin line.

3. **Review** — play. binds.lua vs README keybind text; DMS IPC targets vs the IPC reference;
   `require` list vs `.gitignore` and the stub loop. Fix inline.

4. **ROADMAP** — play. TODOs: first-boot test on hardware (Alt release path of dankswitcher,
   gesture feel, master layout defaults); wallpapers decision (link, LFS, or copy);
   layout-aware `SUPER + ALT` arrows; hyprshot if the DMS screenshot UI disappoints.
   No subfolder README: `hypr/` is the whole repo.

5. **Commit + push** — play, `/theoryy-commit`, no attribution lines. Three commits: scaffold +
   plan + ROADMAP; Lua configs; README. `gh repo create aier9500/hypr-dms --public --source . --push`.

## Sequencing

0 → {1 ‖ 2} → 3 → 4 → 5.

## Risk

- **Untested on hardware.** Mitigated by the VM load, the API-stub check, and the emergency
  binds in the entry file. ROADMAP opens the first-boot test.
- **dankswitcher on Alt.** Its QML grab confirms on Super release only; the Hyprland
  `ALT + ALT_L` release bind is the path that must work. Fallback one-liner documented.
  Plugin is 2 weeks old, one maintainer.
- **`dms setup` re-run** overwrites the entry file and default binds. README warning + recovery.
- **Layout cycle** reverts on `hyprctl reload`. Accepted.
- Reversible: new repo, no edits to `niri-dms`.

## Reference facts (verified 2026-10-17)

- Hyprland latest 0.56.2. Lua API: `hl.config{}`, `hl.bind(keys, dispatcher|fn, {flags})`,
  `hl.unbind(keys)` (earlier binds only, case-sensitive), `hl.dsp.*`, `hl.dsp.global(name)`,
  `hl.window_rule{}`, `hl.layer_rule{}`, `hl.env()`, `hl.gesture{}`, `hl.define_submap`,
  `hl.dsp.submap("reset")`, `hl.on(event, fn)`, `hl.exec_cmd()`, `hl.get_config`,
  `hl.get_active_window`. `window.resize` takes pixels, not percent. Multiple binds on one key
  all fire. `require("missing")` kills the main config.
- DMS deployer: full `dms setup` always rewrites `hyprland.lua` (backup to `.dms-backups/`) and
  `dms/binds.lua`; other fragments are skipped when non-empty. GUI keybind editor writes
  `hl.unbind` + `hl.bind` into `dms/binds-user.lua`. Keybind parser follows literal `require`
  only and parses one-line `hl.bind` calls.
- DMS IPC: `hypr openOverview|closeOverview|toggleOverview`; `keybinds toggle hyprland`;
  `window-rules toggle`; `dash toggle overview|wallpaper|media`; `dms screenshot
  [region|full|window|output|last|scroll]`.
- dankswitcher globals: `dankswitcher:next|prev|select|cancel|toggle`; layer namespace
  `dankswitcher`.
- Fedora: `lionheartp/Hyprland` COPR ships hyprland 0.56.2, hyprland-guiutils,
  xdg-desktop-portal-hyprland for f44/f45/rawhide.
