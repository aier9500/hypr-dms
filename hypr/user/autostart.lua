-- Programs started with Hyprland. hyprland.lua's DMS block starts the session target first.
-- dms.service needs graphical-session.target active; one systemctl call orders both.

hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland-session.target dms.service")
	hl.exec_cmd("fcitx5 -d")
end)

hl.env("XMODIFIERS", "@im=fcitx")
