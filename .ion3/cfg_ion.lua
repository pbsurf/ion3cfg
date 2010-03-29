--
-- Ion main configuration file
--
-- This file only includes some settings that are rather frequently altered.
-- The rest of the settings are in cfg_ioncore.lua and individual modules'
-- configuration files (cfg_modulename.lua). 
--
-- When any binding and other customisations that you want are minor, it is 
-- recommended that you include them in a copy of this file in ~/.ion3/.
-- Simply create or copy the relevant settings at the end of this file (from
-- the other files), recalling that a key can be unbound by passing 'nil' 
-- (without the quotes) as the callback. For more information, please see 
-- the Ion configuration manual available from the Ion Web page.
--

-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
-- These may be defined in /etc/default/ion3, loaded as cfg_debian.
dopath("cfg_debian")
-- use Windows key (Mod4) instead of Alt(Mod1)
META="Mod4+"
--ALTMETA=""

-- Terminal emulator
--XTERM="xterm"

-- Some basic settings
ioncore.set{
    -- this doesn't NOT allow focus to be changed by clicking
    --mousefocus = "disabled",

    -- Maximum delay between clicks in milliseconds to be considered a
    -- double click.
    --dblclick_delay=250,

    -- For keyboard resize, time (in milliseconds) to wait after latest
    -- key press before automatically leaving resize mode (and doing
    -- the resize in case of non-opaque move).
    --kbresize_delay=1500,

    -- Opaque resize?
    --opaque_resize=false,

    -- Movement commands warp the pointer to frames instead of just
    -- changing focus. Enabled by default.
    --warp=true,
    
    -- Switch frames to display newly mapped windows
    --switchto=true,
    
    -- Default index for windows in frames: one of 'last', 'next' (for
    -- after current), or 'next-act' (for after current and anything with
    -- activity right after it).
    --frame_default_index='next',
    
    -- Auto-unsqueeze transients/menus/queries.
    --unsqueeze=true,
    
    -- Display notification tooltips for activity on hidden workspace.
    --screen_notify=true,
}


-- Load default settings. The file cfg_defaults loads all the files
-- commented out below, except mod_dock. If you do not want to load
-- something, comment out this line, and uncomment the lines corresponding
-- the the modules or configuration files that you want, below.
-- The modules' configuration files correspond to the names of the 
-- modules with 'mod' replaced by 'cfg'.
dopath("cfg_defaults")

-- Load configuration of the Ion 'core'. Most bindings are here.
--dopath("cfg_ioncore")

-- Load some kludges to make apps behave better.
--dopath("cfg_kludges")

-- Define some layouts. 
--dopath("cfg_layouts")

-- Load some modules. Bindings and other configuration specific to modules
-- are in the files cfg_modulename.lua.
--dopath("mod_query")
--dopath("mod_menu")
--dopath("mod_tiling")
--dopath("mod_statusbar")
--dopath("mod_dock")
--dopath("mod_sp")


--
-- Common customisations
--

dopath("cfg_mouse")

-- Uncommenting the following lines should get you plain-old-menus instead
-- of query-menus.

--defbindings("WScreen", {
--    kpress(ALTMETA.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
--})
--
--Change ion3 bindings to use Windows Key and unmap Fn key binding
defbindings("WMPlex.toplevel", {
    bdoc("Run a terminal emulator."),
    kpress("Mod4+C", "ioncore.exec_on(_, XTERM or 'x-terminal-emulator')"),
    kpress("F2", nil),

    bdoc("Query for command line to execute."),
    kpress("Mod4+R", "mod_query.query_exec(_)"),
    kpress("F3", nil)
--    kpress(META.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),
})

-- maintain EWMH _NET_CLIENT_LIST property - necessary for viewglob
dopath("net_client_list")

