-- hypr-dms: the defaults DMS Settings can't set.
-- ~/.config/hypr/hyprland.lua requires this in place of dms.binds, so DMS GUI overrides (dms.binds-user) load after it.

require("user.binds")
require("user.workspaces")

-- Chinese input. DMS rewrites only hyprland.lua's DMS_STARTUP block; autostarts live here.
hl.env("XMODIFIERS", "@im=fcitx")
hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5 -d")
end)

hl.config({
	binds = { scroll_event_delay = 500 }, -- Super+scroll: one workspace per 500 ms
	gestures = { workspace_swipe_min_speed_to_force = 5 }, -- slow swipes still switch
})

-- iOS easing, cubic-bezier(0.32, 0.72, 0, 1). Stock hyprland.lua sets these leaves itself; global alone misses them.
hl.curve("apple", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
for _, leaf in ipairs({ "global", "windowsIn", "windowsOut", "windowsMove", "workspaces", "fade", "border" }) do
	hl.animation({ leaf = leaf, enabled = true, speed = 4, bezier = "apple" })
end

-- Screen-share picker opens at 0,0: off-screen when no monitor sits there.
hl.window_rule({
	name = "center-share-picker",
	match = { class = "^hyprland-share-picker$" },
	float = true,
	center = true,
})

-- Personal additions outside the repo: ~/.config/hypr/local.lua, loaded if present.
local ok, err = pcall(require, "local")
if not ok and not tostring(err):find("module 'local' not found", 1, true) then
	error(err, 0)
end
