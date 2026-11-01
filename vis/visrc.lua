-- load standard vis module, providing parts of the Lua API
require("vis")

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis.options.ai = true

	vis:map(vis.modes.INSERT, "jk", "<Escape>")
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

	vis:command "set rnu on"
	vis:command "set cul on"
	vis:command "set ic on"
	vis:command "set cc 100"
	vis:command "set nuw 3"

	if win.syntax and two_tab_width_ext_map[win.syntax] then
	   vis:command "set tw 2"
	else
	   vis:command "set tw 4"
	end

	vis:command "set et on"
end)


local function backspace(win)
    return function ()
        local file = win.file
        local tw = win.options.tw
        local deletions = {}

        for sel in win:selections_iterator() do
            local col = sel.col
            local line = sel.line
            local pos = sel.pos

            local n = 1
            if col > 1 then
                local line_content = file.lines[line]:sub(1, col - 1)

                if line_content:match("^ +$") and (col - 1) % tw == 0 then
                    n = tw
                end
            end

            if pos > 0 then
                n = math.min(n, pos)
                vis:info("pos: " .. tostring(pos) .. "; n: " .. tostring(n))
                table.insert(deletions, {pos - n, n})
            end

        end


        table.sort(deletions, function (a, b) return a[1] > b[1] end)
        for _, v in ipairs(deletions) do
            file:delete(v[1], v[2])
        end
        win:draw()

        return 0
    end
end

vis.events.subscribe(vis.events.WIN_OPEN, function (win)
	if not win.file.path then
	   return
	end

    vis:map(vis.modes.INSERT, "<Backspace>", backspace(win), "Backspace tab")
end)

vis:command_register("syntax?", function (argv, force, win) 
    vis:info("syntax: " .. (win.syntax or "none"))
    return true
end, "Show the syntax of the current window")
