hl.config({
	general = { layout = "master" },
	misc = { disable_hyprland_logo = true },
})

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("NIXOS_OZONE_WL", "1")
