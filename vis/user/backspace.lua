--- backspace by tabs if at a multiple of tabwdith
--- and go back by tabs if only space before
---@param win vis.Window the window to attach this keymap
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

            if pos and pos > 0 then
                n = math.min(n, pos)
                table.insert(deletions, {pos - n, n, sel})
            end

        end


        table.sort(deletions, function (a, b) return a[1] > b[1] end)
        for _, v in ipairs(deletions) do
            file:delete(v[1], v[2])
        end

        -- file:delete does not move cursors; place each one at its deletion
        -- start, shifted left by everything deleted before it
        local shift = 0
        for i = #deletions, 1, -1 do
            local v = deletions[i]
            v[3].pos = v[1] - shift
            shift = shift + v[2]
        end

        for w in vis:windows() do
            if w.file.path == file.path then
                w:draw()
            end
        end

        return 0
    end
end

return { backspace = backspace }
