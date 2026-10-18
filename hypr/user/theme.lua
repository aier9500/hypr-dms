-- iOS style easing, cubic-bezier(0.32, 0.72, 0, 1): fast start, soft landing. DMS sets no animations.
hl.curve("apple", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "apple" })