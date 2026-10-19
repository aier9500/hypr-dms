-- DMS_STARTUP_BEGIN
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd("dms run")
	hl.exec_cmd("hyprshell run")
end)

hl.env("XMODIFIERS", "@im=fcitx")
-- DMS_STARTUP_END

-- Emergency binds: a broken user file can sitll open the terminal
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F4", hl.dsp.exit())

pcall(require, "dms.binds-user")
pcall(require, "dms.colors")
pcall(require, "dms.cursor")
pcall(require, "dms.input")
pcall(require, "dms.layout")
pcall(require, "dms.outputs")
pcall(require, "dms.windowrules")
require("user.binds")
require("user.inputs")
require("user.misc")
require("user.theme")
