-- Look and feel configuration

local activeBorder1 = "rgba(33ccffee)"
local activeBorder2 = "rgba(00ff99ee)"
local inactiveBorder = "rgba(595959aa)"

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
        col = {
            active_border = {
                colors = { activeBorder1, activeBorder2 },
                angle = 45,
            },
            inactive_border = inactiveBorder,
        },
    },
    group = {
        col = {
            border_active = CACHYLBLUE,
            border_inactive = CACHYGRAY,
            border_locked_active = CACHYDBLUE,
            border_locked_inactive = CACHYGRAY,
        },
        groupbar = {
            col = {
                active = CACHYLGREEN,
                inactive = CACHYGRAY,
                locked_active = CACHYDBLUE,
                locked_inactive = CACHYGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            special = true,
            vibrancy = 0.1696,
        },
    },
})
