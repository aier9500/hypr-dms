-- Rules absent from DMS windowrules: layer blur, switcher animation, OpenWhispr pill, Qt no-CSD.
-- Blur samples the windows beneath (no xray). Settings > Compositor Layout > Dank Bar Xray must stay off.

hl.layer_rule({ match = { namespace = "^dms:(bar|dankisland|spotlight|clipboard|settings|control-center|notifications)$" }, blur = true, ignore_alpha = 0 })
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

-- iOS sheet easing, cubic-bezier(0.32, 0.72, 0, 1): fast start, soft landing. DMS sets no animations.
hl.curve("apple", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "apple" })

hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
