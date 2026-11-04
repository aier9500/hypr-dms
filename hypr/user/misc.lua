hl.config({
	misc = { 
        disable_hyprland_logo = true,
        disable_splash_rendering = true
    },
	-- auto-HDR on fullscreen video makes OLED look wrong
	render = { cm_auto_hdr = 0 },
})

-- screen-share picker opens at 0,0: off-screen when the Dell (at 0x0) is unplugged
hl.window_rule({
	name = "center-share-picker",
	match = { class = "^hyprland-share-picker$" },
	float = true,
	center = true,
})

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
