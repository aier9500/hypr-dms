-- All keybinds. DMS GUI edits go to dms/binds-user.lua, loaded after this file.
-- Dropped from Niri: toggle-keyboard-shortcuts-inhibit, center-column, center-visible-columns, move-workspace-up/down, switch-preset-column-width, reset-window-height, per-bind cooldown-ms.

-- Take over the emergency binds from hyprland.lua.
hl.unbind("SUPER + Return")
hl.unbind("SUPER + Q")
hl.unbind("SUPER + F4")

local layouts = { "master", "dwindle", "scrolling" }

local function toggle_float_centered()
	hl.dispatch(hl.dsp.window.float())
	local w = hl.get_active_window()
	if w and w.floating and w.monitor then
		local m = w.monitor
		hl.dispatch(hl.dsp.window.resize({ x = math.floor(m.width / m.scale * 0.5), y = math.floor(m.height / m.scale * 0.65) }))
		hl.dispatch(hl.dsp.window.center())
	end
end

-- Reverts to misc.lua's layout on reload.
local function cycle_layout()
	local current = hl.get_config("general.layout")
	local index = 1
	for i, name in ipairs(layouts) do
		if name == current then
			index = i % #layouts + 1
		end
	end
	hl.config({ ["general.layout"] = layouts[index] })
end

-- Apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("flatpak run io.missioncenter.MissionCenter"))
hl.bind("ALT + space", hl.dsp.exec_cmd("dbus-send --session --type=method_call --dest=com.openwhispr.App /com/openwhispr/App com.openwhispr.App.Toggle"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("flatpak run com.dec05eba.gpu_screen_recorder/x86_64/stable"))

-- DMS components
hl.bind("SUPER + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("dms ipc call dash toggle overview"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("dms ipc call control-center toggle"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc call window-rules toggle"))
hl.bind("SUPER + CTRL + SHIFT + D", hl.dsp.exec_cmd("dms ipc call theme toggle"))

-- Session
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind("SUPER + F4", hl.dsp.exit())

-- Overview and window switcher
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))
hl.bind("SUPER + SHIFT + Tab", hl.dsp.exec_cmd("dms ipc call hypr closeOverview"))
hl.bind("ALT + Tab", hl.dsp.global("dankswitcher:next"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.global("dankswitcher:prev"))
hl.bind("ALT + ALT_L", hl.dsp.global("dankswitcher:select"), { release = true })
hl.bind("ALT + ALT_R", hl.dsp.global("dankswitcher:select"), { release = true })
-- Without dankswitcher: hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))

-- Windows
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + T", toggle_float_centered, { description = "Float, 50% x 65%, centered" })
hl.bind("SUPER + SHIFT + T", hl.dsp.window.cycle_next({ floating = true }))
hl.bind("SUPER + SHIFT + space", cycle_layout, { description = "Cycle layout: master, dwindle, scrolling" })

-- Focus and move
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + Home", hl.dsp.layout("focusmaster"))
hl.bind("SUPER + End", hl.dsp.layout("swapwithmaster"))
hl.bind("SUPER + ALT + left", hl.dsp.layout("consume_or_expel prev"))
hl.bind("SUPER + ALT + right", hl.dsp.layout("consume_or_expel next"))

-- Sizing
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + minus", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + equal", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind("SUPER + R", hl.dsp.submap("resize"), { description = "Resize mode" })
hl.define_submap("resize", function()
	hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
	hl.bind("Escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Monitors
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + CTRL + up", hl.dsp.focus({ monitor = "u" }))
hl.bind("SUPER + CTRL + down", hl.dsp.focus({ monitor = "d" }))
hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + CTRL + SHIFT + up", hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + CTRL + SHIFT + down", hl.dsp.window.move({ monitor = "d" }))

-- Workspaces
for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + mouse_right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + mouse_left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + grave", hl.dsp.workspace.toggle_special("scratch"))
hl.bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratch" }))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("XF86Launch1", hl.dsp.exec_cmd("dms screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("CTRL + XF86Launch1", hl.dsp.exec_cmd("dms screenshot full"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"))
hl.bind("ALT + XF86Launch1", hl.dsp.exec_cmd("dms screenshot window"))

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("dms ipc call mpris playPause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("dms ipc call mpris previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("dms ipc call mpris next"), { locked = true })
hl.bind("CTRL + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call mpris increment 3"), { locked = true, repeating = true })
hl.bind("CTRL + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call mpris decrement 3"), { locked = true, repeating = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })
