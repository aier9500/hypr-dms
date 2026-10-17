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

-- Later wins. hl.unbind removes only earlier binds, so DMS GUI edits (dms.binds-user) load last.
require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.input")
require("dms.binds")
require("dms.windowrules")
require("user.misc")
require("user.inputs")
require("user.theme")
require("user.fcitx5")
require("user.binds")
require("dms.binds-user")
