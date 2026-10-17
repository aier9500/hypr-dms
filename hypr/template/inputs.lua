-- Cursor warp, middle-click paste, scroll delay and gestures; DMS Settings covers none.
-- Touchpad keys here override Settings > Mouse & Touchpad.

hl.config({
	input = { touchpad = { natural_scroll = true, clickfinger_behavior = true } },
	cursor = { warp_on_change_workspace = 1, warp_on_toggle_special = 1 },
	misc = { middle_click_paste = false },
	binds = { scroll_event_delay = 500 },
})

local function toggle_overview()
	hl.exec_cmd("dms ipc call hypr toggleOverview")
end

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up", action = toggle_overview })
hl.gesture({ fingers = 3, direction = "pinchin", action = "special", workspace_name = "scratch" })
