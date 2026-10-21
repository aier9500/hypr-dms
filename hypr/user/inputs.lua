-- Cursor warp, middle-click paste, scroll delay and gestures; DMS Settings covers none.
-- A workspace swipe commits past 25% of workspace_swipe_distance (Hyprland default 50%).
-- DMS Settings > Mouse & Touchpad does not write Hyprland config; touchpad keys live here.
-- Hyprland ignores fcitx5's layout switch; kb_variant sets Colemak-DH for every keyboard.

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "colemak_dh",
		accel_profile = "flat",
		touchpad = { natural_scroll = true, clickfinger_behavior = true },
	},
	misc = { middle_click_paste = false },
	binds = { scroll_event_delay = 500 },
	gestures = { workspace_swipe_min_speed_to_force = 5 },
})

-- List of trackpads to keep acceleration
-- "hyprctl devices" to find and add trackpad to list
for _, name in ipairs({ "ascf1a01:00-2808:0234-touchpad", "apple-inc.-magic-trackpad" }) do
	hl.device({ name = name, accel_profile = "adaptive" })
end

local function toggle_overview()
	hl.exec_cmd("dms ipc call hypr toggleOverview")
end

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = toggle_overview })
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratch" })
