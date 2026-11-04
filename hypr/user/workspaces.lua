-- Per-monitor workspaces 1-10, numbered on the focused monitor (hyprsplit, vendored in ../hyprsplit).
-- force_monitor_priority: monitors ranked by name, so a lone monitor always owns 1-10; with two, DP-* gets 1-10, eDP-1 11-20.
local hs = require("hyprsplit")
hs.config({ num_workspaces = 10, force_monitor_priority = true })

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hs.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hs.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + Page_Down", hs.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + Page_Up", hs.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + CTRL + right", hs.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + CTRL + left", hs.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hs.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + Page_Up", hs.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + CTRL + SHIFT + right", hs.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + CTRL + SHIFT + left", hs.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + mouse_down", hs.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + mouse_up", hs.dsp.focus({ workspace = "-1" }))

-- Windows stranded outside every monitor's range (e.g. after turning a screen off) move here.
hl.bind("SUPER + G", hs.dsp.grab_rogue_windows(), { description = "Pull windows from turned-off screens onto this workspace" })
