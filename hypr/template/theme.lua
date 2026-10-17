-- Rules absent from DMS windowrules: popup blur, switcher animation, OpenWhispr pill, Qt no-CSD.

hl.layer_rule({ match = { namespace = "dms:(spotlight|clipboard|settings|control-center|notifications)" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "dankswitcher" }, no_anim = true })

-- OpenWhispr dictation pill: bare, unfocused, bottom-right.
hl.window_rule({
	match = { class = "(?i)^open-whispr$", title = "^Voice Recorder$" },
	float = true,
	no_initial_focus = true,
	border_size = 0,
	no_shadow = true,
	no_blur = true,
	move = { "monitor_w-window_w-16", "monitor_h-window_h-16" },
})

hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
