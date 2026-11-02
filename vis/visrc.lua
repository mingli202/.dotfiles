-- load standard vis module, providing parts of the Lua API
require("vis")
local oil = require("user.oil")
local bs = require("user.backspace")


vis.events.subscribe(vis.events.INIT, function()
    -- Your global configuration 
    vis.options.ai = true

    vis:map(vis.modes.INSERT, "jk", "<Escape>")
    vis:map(vis.modes.NORMAL, " o", function (keys)
        oil.open_oil()
    end)
end)

local two_tab_width_ext = {
    "c",
    "cpp",
    "java",
    "javascript",
    "nix",
    "caml",
    "typescript",
}
local two_tab_width_ext_map = {}
for i, v in ipairs(two_tab_width_ext) do
    two_tab_width_ext_map[v] = true
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
    -- Your per window configuration options e.g.
    -- vis:command('set number')    
    vis:command "set rnu on" -- relative numbers
    vis:command "set cul on" -- cursorline
    vis:command "set ic on" -- ignorecase
    vis:command "set cc 100" -- cursorcolumn
    vis:command "set nuw 3" -- number width
    vis:command "set et on" -- expand tab to spaces

    -- tab width
    if win.syntax and two_tab_width_ext_map[win.syntax] then
       vis:command "set tw 2"
    else
       vis:command "set tw 4"
    end

    -- windows with actual files
    if not win.file.path then
        return
    end

    win:map(vis.modes.INSERT, "<Backspace>", bs.backspace(win), "Backspace tab")
end)

require("user.commands")