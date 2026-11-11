-- hypr-dms: the defaults DMS Settings can't set.
-- ~/.config/hypr/hyprland.lua requires this in place of dms.binds, so DMS GUI overrides (dms.binds-user) load after it.

require("user.binds")
require("user.workspaces")
pcall(require, "user.local")


-- Fcitx5 for CJK. Other autostarts: DMS Settings → Autostart.
hl.env("XMODIFIERS", "@im=fcitx")
hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5 -d")
end)

hl.config({
	binds = { scroll_event_delay = 500 }, -- Super+scroll: one workspace per 500 ms
	gestures = { workspace_swipe_min_speed_to_force = 5 }, -- slow swipes still switch
	input = { focus_on_close = 1 }, -- after a close, focus the window now under the cursor, not the layout's pick
})

-- iOS easing, cubic-bezier(0.32, 0.72, 0, 1). Stock hyprland.lua sets these leaves itself; global alone misses them.
hl.curve("apple", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
for _, leaf in ipairs({ "global", "windowsIn", "windowsOut", "windowsMove", "workspaces", "fade", "border" }) do
	hl.animation({ leaf = leaf, enabled = true, speed = 4, bezier = "apple" })
end
