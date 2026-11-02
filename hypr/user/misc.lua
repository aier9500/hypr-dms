hl.config({
	misc = { 
        disable_hyprland_logo = true,
        disable_splash_rendering = true
    },
	-- auto-HDR on fullscreen video makes OLED look wrong
	render = { cm_auto_hdr = 0 },
})

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("NIXOS_OZONE_WL", "1")
