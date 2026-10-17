-- fcitx5 IME (Rime/Cantonese); DMS does not start it.

hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5 -d")
end)

hl.env("XMODIFIERS", "@im=fcitx")
