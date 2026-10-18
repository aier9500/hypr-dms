-- DMS_STARTUP_BEGIN
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
end)
-- DMS_STARTUP_END

-- Emergency binds: a broken user file still yields a terminal.
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F4", hl.dsp.exit())

-- Binds stack: two hl.bind on one key both fire. hl.unbind before rebinding.
-- dms/*.lua is written by DMS and absent on a fresh clone; pcall skips missing files.
-- dms.binds (DMS default keybinds) is not loaded; user/binds.lua replaces it.
pcall(require, "dms.colors")
pcall(require, "dms.outputs")
pcall(require, "dms.layout")
pcall(require, "dms.cursor")
pcall(require, "dms.input")
pcall(require, "dms.windowrules")
require("user.misc")
require("user.inputs")
require("user.theme")
require("user.autostart")
require("user.binds")
pcall(require, "dms.binds-user")
