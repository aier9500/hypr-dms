-- Per-device fixes, on by default. Edit or delete lines for your hardware.

-- DMS probes touchpads only at shell start; a hotplugged Magic Trackpad gets flat mouse accel and is unusable.
hl.device({ name = "apple-inc.-magic-trackpad", accel_profile = "adaptive" })

-- Auto-HDR on fullscreen video washes out colours on OLED panels. No effect on SDR screens.
hl.config({ render = { cm_auto_hdr = 0 } })
