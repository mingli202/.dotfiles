-- load standard vis module, providing parts of the Lua API
require("vis")

local plug_path = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/vis/plugins/vis-plug"
if not pcall(require, "plugins/vis-plug") then
	os.execute('git clone --quiet https://github.com/erf/vis-plug "' .. plug_path .. '"')
end
local plug = require("plugins/vis-plug")

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis.options.ai = true

	vis:map(vis.modes.INSERT, "jk", "<Escape>")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	-- vis:command('set number')
end)
