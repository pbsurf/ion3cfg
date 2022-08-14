-- Cut and paste of:
-- look_newviolet for Notion's default drawing engine.
-- Based on look_cleanviolet
-- ... with font sizes increased for high DPI displays

-- ideally, we wouldn't have to cut and paste entire style (and dopath("lookcommon_clean") does seem to work)
--  but multiple defstyles() create multiple instances of a style and a derived style, e.g. "tab-frame", will
--  link to matching parent (e.g. "tab") that exists at that time, so any future "tab" styles will have no
--  effect.  There is a branch of notion with Xft support, although we would still need to override style to
--  use Xft fonts.

if not gr.select_engine("de") then
    return
end

de.reset()

de.defstyle("*", {
    highlight_colour = "#e7e7ff",
    shadow_colour = "#e7e7ff",
    background_colour = "#b8b8c8",
    foreground_colour = "#000000",

    shadow_pixels = 1,
    highlight_pixels = 2,
    padding_pixels = 1,
    spacing = 1,
    border_style = "elevated",
    border_sides = "tb",

    --font = "-*-helvetica-bold-r-normal-*-25-*-*-*-*-*-*-*",
    font = "xft:Tahoma:pixelsize=24",
    text_align = "center",
})


de.defstyle("tab", {
    font = "xft:Tahoma:pixelsize=24",
    --font = "xft:Tahoma:style=Bold:size=12",
    --font = "-*-helvetica-medium-r-normal-*-18-*-*-*-*-*-*-*",

    de.substyle("active-selected", {
        highlight_colour = "#aaaacc",
        shadow_colour = "#aaaacc",
        background_colour = "#666699",
        foreground_colour = "#eeeeee",
    }),

    de.substyle("inactive-selected", {
        highlight_colour = "#cfcfdf",
        shadow_colour = "#cfcfdf",
        background_colour = "#9999bb",
        foreground_colour = "#000000",
    }),
})


de.defstyle("input", {
    text_align = "left",
    highlight_colour = "#eeeeff",
    shadow_colour = "#eeeeff",

    de.substyle("*-selection", {
        background_colour = "#666699",
        foreground_colour = "#000000",
    }),

    de.substyle("*-cursor", {
        background_colour = "#000000",
        foreground_colour = "#b8b8c8",
    }),
})


de.defstyle("input-menu", {
    highlight_pixels = 0,
    shadow_pixels = 0,
    padding_pixels = 0,
})

--dopath("lookcommon_clean")
-- Common settings for the "clean" styles

de.defstyle("frame", {
    background_colour = "#000000",
    de.substyle("quasiactive", {
        -- Something detached from the frame is active
        padding_colour = "#901010",
    }),
    de.substyle("userattr1", {
        -- For user scripts
        padding_colour = "#009010",
    }),
    -- moved from look_newviolet frame style
    shadow_pixels = 1,
    highlight_pixels = 1,
    padding_pixels = 0,
    border_sides = "all",
    spacing = 0
})

de.defstyle("frame-tiled", {
    shadow_pixels = 0,
    highlight_pixels = 0,
    spacing = 1,
    -- no border or padding on sides, so that mouse input (esp. scroll wheel) at screen edge goes to
    --  application and not notion (note that there is still the problem with VMware grabbing cursor at edge)
    padding_pixels = 0,
    border_sides = "tb",
})

--de.defstyle("frame-tiled-alt", {
--    bar = "none",
--})

de.defstyle("frame-floating", {
    --bar = "shaped",
    padding_pixels = 0,
})

de.defstyle("frame-transient", {
    --bar = "none",
    padding_pixels = 0,
})

-- previously we cut and paste this file here - do that again if any problems
dopath("lookcommon_clean_tab")

-- Status bar apperance - need to set monospace font
--dopath("lookcommon_clean_stdisp")
de.defstyle("stdisp-statusbar", {
    shadow_pixels = 0,
    highlight_pixels = 0,
    text_align = "left",
    background_colour = "#000000",
    foreground_colour = "grey",
    --xlsfonts -fn <name> to look up these old X logical font names
    --font = "-*-lucidatypewriter-medium-r-normal-*-18-*-*-*-*-*-*-*",
    font = "xft:DejaVu Sans Mono:style=Bold:pixelsize=24",

    de.substyle("important", {
        foreground_colour = "green",
    }),

    de.substyle("critical", {
        foreground_colour = "red",
    }),
})

-- Refresh objects' brushes.
gr.refresh()
