-- Tests for user/history.lua (MRU file history behind ctrl-tab).
-- Dependency-free: run from anywhere with `lua tests/history_test.lua`.

local root = (arg and arg[0] or ""):match("^(.*)/tests/[^/]*$") or "."
package.path = root .. "/?.lua;" .. package.path

local make_history = require("user.history")

-- max_len is required; tests that aren't about the cap use an effectively unbounded one
local function new_history(max_len) return make_history(max_len or math.huge) end

---------------------------------------------------------------------------
-- tiny harness
---------------------------------------------------------------------------

local tests = {}
local function test(name, fn) table.insert(tests, { name = name, fn = fn }) end

local function fail(msg, level) error(msg, (level or 1) + 1) end

local function eq(actual, expected, msg)
    if actual ~= expected then
        fail(string.format("%s: expected %s, got %s",
            msg or "eq", tostring(expected), tostring(actual)), 2)
    end
end

local function file(path) return { path = path } end

--- paths of to_array(), in order
local function paths(h)
    local out = {}
    for i, f in ipairs(h.to_array()) do out[i] = f.path end
    return out
end

local function order_eq(h, expected, msg)
    local got = paths(h)
    local ok = #got == #expected
    for i = 1, math.max(#got, #expected) do
        if got[i] ~= expected[i] then ok = false end
    end
    if not ok then
        fail(string.format("%s: expected {%s}, got {%s}", msg or "order",
            table.concat(expected, ","), table.concat(got, ",")), 2)
    end
    if h.len() ~= #expected then
        fail(string.format("%s: len() = %d but expected %d entries",
            msg or "order", h.len(), #expected), 2)
    end
end

--- Verifies the doubly linked list through node references returned by touch.
--- `nodes` maps path -> node for every path expected in the list.
local function links_ok(h, nodes, msg)
    local arr = paths(h)
    msg = msg or "links"
    for i, p in ipairs(arr) do
        local n = nodes[p]
        if not n then fail(msg .. ": no node captured for " .. p, 2) end
        local prev, next = nodes[arr[i - 1]], nodes[arr[i + 1]]
        if n.prev ~= prev then fail(msg .. ": bad prev on " .. p, 2) end
        if n.next ~= next then fail(msg .. ": bad next on " .. p, 2) end
        if n.id ~= p then fail(msg .. ": node id " .. tostring(n.id) .. " ~= " .. p, 2) end
        if n.value.path ~= p then fail(msg .. ": node value mismatch on " .. p, 2) end
    end
end

--- touches each path in order, returning path -> node
local function touch_all(h, list, nodes)
    nodes = nodes or {}
    for _, p in ipairs(list) do nodes[p] = h.touch(file(p)) end
    return nodes
end

---------------------------------------------------------------------------
-- API surface
---------------------------------------------------------------------------

test("constructor returns the public API", function()
    local h = new_history()
    for _, name in ipairs({ "touch", "remove", "len", "to_array" }) do
        eq(type(h[name]), "function", name)
    end
end)

test("instances are independent", function()
    local a, b = new_history(), new_history()
    a.touch(file("x"))
    eq(a.len(), 1, "a.len")
    eq(b.len(), 0, "b.len")
    order_eq(b, {}, "b empty")
end)

---------------------------------------------------------------------------
-- empty history
---------------------------------------------------------------------------

test("new history is empty", function()
    local h = new_history()
    eq(h.len(), 0, "len")
    order_eq(h, {}, "to_array")
end)

test("remove on empty history returns false", function()
    local h = new_history()
    eq(h.remove(file("a")), false, "remove")
    eq(h.len(), 0, "len")
end)

---------------------------------------------------------------------------
-- touch
---------------------------------------------------------------------------

test("touch(nil) is ignored", function()
    local h = new_history()
    eq(h.touch(nil), nil, "return")
    eq(h.len(), 0, "len")
end)

test("touch of a file without a path (unnamed buffer) is ignored", function()
    local h = new_history()
    h.touch(file("a"))
    eq(h.touch({}), nil, "return")
    order_eq(h, { "a" }, "unchanged")
end)

test("touch returns the node for the file", function()
    local h = new_history()
    local f = file("a")
    local n = h.touch(f)
    eq(n.id, "a", "id")
    eq(n.value, f, "value")
    eq(n.prev, nil, "prev")
    eq(n.next, nil, "next")
end)

test("touched files are ordered most recent first", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    order_eq(h, { "c", "b", "a" })
    links_ok(h, nodes)
end)

test("ctrl-tab target (index 2) is the previously opened file", function()
    local h = new_history()
    touch_all(h, { "a", "b" })
    eq(h.to_array()[2].path, "a", "after a,b")
    h.touch(file("a"))
    eq(h.to_array()[2].path, "b", "after switching back to a")
end)

test("re-touching the head keeps order and length", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    h.touch(file("c"))
    order_eq(h, { "c", "b", "a" })
    links_ok(h, nodes)
end)

test("re-touching a middle entry moves it to the front", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    h.touch(file("b"))
    order_eq(h, { "b", "c", "a" })
    links_ok(h, nodes)
end)

test("re-touching the tail moves it to the front", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    h.touch(file("a"))
    order_eq(h, { "a", "c", "b" })
    links_ok(h, nodes)
end)

test("re-touching the only entry is stable", function()
    local h = new_history()
    local nodes = touch_all(h, { "a" })
    h.touch(file("a"))
    h.touch(file("a"))
    order_eq(h, { "a" })
    links_ok(h, nodes)
end)

test("re-touching two-element list swaps them", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b" })
    h.touch(file("a"))
    order_eq(h, { "a", "b" })
    links_ok(h, nodes)
    h.touch(file("b"))
    order_eq(h, { "b", "a" })
    links_ok(h, nodes)
end)

test("re-touch reuses the node and replaces its value with the new file", function()
    local h = new_history()
    local old, new = file("a"), file("a")
    local n1 = h.touch(old)
    h.touch(file("b"))
    local n2 = h.touch(new)
    eq(n2, n1, "same node")
    eq(n2.value, new, "value updated")
    eq(h.to_array()[1], new, "to_array returns newest object")
    eq(h.len(), 2, "len")
end)

test("identity is by path, not by file object", function()
    local h = new_history()
    h.touch(file("a"))
    h.touch(file("a"))
    h.touch({ path = "a", extra = true })
    order_eq(h, { "a" })
end)

---------------------------------------------------------------------------
-- remove
---------------------------------------------------------------------------

test("remove of an absent file returns false and changes nothing", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b" })
    eq(h.remove(file("zzz")), false, "remove")
    order_eq(h, { "b", "a" })
    links_ok(h, nodes)
end)

test("remove of a file without a path returns false", function()
    local h = new_history()
    touch_all(h, { "a" })
    eq(h.remove({}), false, "remove")
    order_eq(h, { "a" })
end)

test("remove the only entry empties the history", function()
    local h = new_history()
    touch_all(h, { "a" })
    eq(h.remove(file("a")), true, "remove")
    order_eq(h, {})
end)

test("remove the head", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    eq(h.remove(file("c")), true, "remove")
    nodes.c = nil
    order_eq(h, { "b", "a" })
    links_ok(h, nodes)
end)

test("remove a middle entry", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    eq(h.remove(file("b")), true, "remove")
    nodes.b = nil
    order_eq(h, { "c", "a" })
    links_ok(h, nodes)
end)

test("remove the tail", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    eq(h.remove(file("a")), true, "remove")
    nodes.a = nil
    order_eq(h, { "c", "b" })
    links_ok(h, nodes)
end)

test("removing twice returns false the second time", function()
    local h = new_history()
    touch_all(h, { "a", "b" })
    eq(h.remove(file("a")), true, "first")
    eq(h.remove(file("a")), false, "second")
    order_eq(h, { "b" })
end)

test("remove matches by path with a different file object", function()
    local h = new_history()
    touch_all(h, { "a", "b" })
    eq(h.remove({ path = "a" }), true, "remove")
    order_eq(h, { "b" })
end)

test("removed node has its links cleared", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    h.remove(file("b"))
    eq(nodes.b.prev, nil, "prev")
    eq(nodes.b.next, nil, "next")
end)

test("remove all entries in every order leaves a usable empty history", function()
    local perms = {
        { "a", "b", "c" }, { "a", "c", "b" }, { "b", "a", "c" },
        { "b", "c", "a" }, { "c", "a", "b" }, { "c", "b", "a" },
    }
    for _, perm in ipairs(perms) do
        local h = new_history()
        touch_all(h, { "a", "b", "c" })
        for _, p in ipairs(perm) do eq(h.remove(file(p)), true, "remove " .. p) end
        order_eq(h, {}, "emptied via " .. table.concat(perm))
        -- head/tail must be reset so the list is usable again
        local nodes = touch_all(h, { "x", "y" })
        order_eq(h, { "y", "x" }, "reuse after " .. table.concat(perm))
        links_ok(h, nodes)
    end
end)

test("a removed file re-touched is added fresh at the front", function()
    local h = new_history()
    local nodes = touch_all(h, { "a", "b", "c" })
    local old = nodes.a
    h.remove(file("a"))
    nodes.a = h.touch(file("a"))
    order_eq(h, { "a", "c", "b" })
    links_ok(h, nodes)
    if nodes.a == old then fail("expected a fresh node after remove") end
end)

---------------------------------------------------------------------------
-- to_array
---------------------------------------------------------------------------

test("to_array returns the file objects that were touched", function()
    local h = new_history()
    local a, b = file("a"), file("b")
    h.touch(a)
    h.touch(b)
    local arr = h.to_array()
    eq(arr[1], b, "[1]")
    eq(arr[2], a, "[2]")
end)

test("to_array returns a fresh table each call", function()
    local h = new_history()
    touch_all(h, { "a", "b" })
    local arr = h.to_array()
    arr[1] = nil
    table.insert(arr, file("junk"))
    order_eq(h, { "b", "a" }, "history unaffected by caller mutation")
    if h.to_array() == arr then fail("to_array returned the same table") end
end)

---------------------------------------------------------------------------
-- max_len
---------------------------------------------------------------------------

test("below max_len nothing is evicted", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b" })
    order_eq(h, { "b", "a" })
    links_ok(h, nodes)
end)

test("exactly max_len entries are all kept", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b", "c" })
    order_eq(h, { "c", "b", "a" })
    links_ok(h, nodes)
end)

test("adding past max_len evicts the least recently used", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b", "c", "d" })
    nodes.a = nil
    order_eq(h, { "d", "c", "b" })
    links_ok(h, nodes)
end)

test("eviction follows recency, not insertion order", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b", "c", "a", "d" })
    nodes.b = nil
    order_eq(h, { "d", "a", "c" })
    links_ok(h, nodes)
end)

test("evicted node has its links cleared", function()
    local h = new_history(2)
    local nodes = touch_all(h, { "a", "b", "c" })
    eq(nodes.a.prev, nil, "prev")
    eq(nodes.a.next, nil, "next")
end)

test("an evicted file is fully forgotten", function()
    local h = new_history(2)
    touch_all(h, { "a", "b", "c" })
    eq(h.remove(file("a")), false, "remove of evicted file")
    order_eq(h, { "c", "b" })
end)

test("re-touching an evicted file adds it fresh and evicts the next oldest", function()
    local h = new_history(2)
    local nodes = touch_all(h, { "a", "b", "c" })
    local old = nodes.a
    nodes.a = h.touch(file("a"))
    nodes.b = nil
    if nodes.a == old then fail("expected a fresh node for an evicted file") end
    order_eq(h, { "a", "c" })
    links_ok(h, nodes)
end)

test("re-touching existing entries at capacity never evicts", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b", "c" })
    h.touch(file("a")) -- tail
    order_eq(h, { "a", "c", "b" }, "tail to front")
    h.touch(file("c")) -- middle
    order_eq(h, { "c", "a", "b" }, "middle to front")
    h.touch(file("c")) -- head
    order_eq(h, { "c", "a", "b" }, "head stays")
    links_ok(h, nodes)
end)

test("remove at capacity frees a slot", function()
    local h = new_history(3)
    local nodes = touch_all(h, { "a", "b", "c" })
    h.remove(file("b"))
    nodes.b = nil
    touch_all(h, { "d" }, nodes)
    order_eq(h, { "d", "c", "a" })
    links_ok(h, nodes)
end)

test("max_len 1 keeps only the latest file", function()
    local h = new_history(1)
    for _, p in ipairs({ "a", "b", "c" }) do
        local n = h.touch(file(p))
        order_eq(h, { p }, "after " .. p)
        links_ok(h, { [p] = n }, "after " .. p)
    end
end)

test("sustained churn keeps len at max_len", function()
    local h = new_history(4)
    local nodes = {}
    for i = 1, 100 do
        local p = "f" .. i
        nodes[p] = h.touch(file(p))
        nodes["f" .. (i - 4)] = nil
        local expected = {}
        for j = i, math.max(1, i - 3), -1 do table.insert(expected, "f" .. j) end
        order_eq(h, expected, "after " .. p)
        links_ok(h, nodes, "after " .. p)
    end
end)

---------------------------------------------------------------------------
-- randomized differential test against a naive array model
---------------------------------------------------------------------------

test("random touch/remove sequences match a reference model", function()
    local pool = { "a", "b", "c", "d", "e", "f" }
    for _, max_len in ipairs({ math.huge, 1, 2, 3, 5 }) do
        for seed = 1, 200 do
            math.randomseed(seed)
            local h, model, nodes = new_history(max_len), {}, {}

            local function model_index(p)
                for i, v in ipairs(model) do if v == p then return i end end
            end

            for step = 1, 60 do
                local p = pool[math.random(#pool)]
                local ctx = string.format("max_len %s seed %d step %d", max_len, seed, step)
                if math.random() < 0.65 then
                    local i = model_index(p)
                    if i then table.remove(model, i) end
                    table.insert(model, 1, p)
                    if #model > max_len then nodes[table.remove(model)] = nil end
                    local n = h.touch(file(p))
                    if nodes[p] and nodes[p] ~= n then
                        fail(ctx .. ": re-touch of " .. p .. " created a new node")
                    end
                    nodes[p] = n
                else
                    local i = model_index(p)
                    if i then table.remove(model, i) end
                    eq(h.remove(file(p)), i ~= nil, ctx .. " remove " .. p)
                    nodes[p] = nil
                end
                order_eq(h, model, ctx)
                links_ok(h, nodes, ctx)
            end
        end
    end
end)

---------------------------------------------------------------------------
-- run
---------------------------------------------------------------------------

-- A broken list can form a cycle and hang to_array; turn that into a failure.
local BUDGET = 2e8 -- VM instructions per test; the full suite uses far less
local function with_budget(fn)
    local spent = 0
    debug.sethook(function()
        spent = spent + 1e6
        if spent > BUDGET then
            debug.sethook()
            error("instruction budget exceeded (cycle in the list?)")
        end
    end, "", 1e6)
    local ok, err = pcall(fn)
    debug.sethook()
    return ok, err
end

local failed = 0
for _, t in ipairs(tests) do
    local ok, err = with_budget(t.fn)
    if ok then
        io.write("ok   ", t.name, "\n")
    else
        failed = failed + 1
        io.write("FAIL ", t.name, "\n     ", tostring(err), "\n")
    end
end
io.write(string.format("\n%d tests, %d failed\n", #tests, failed))
os.exit(failed == 0 and 0 or 1)
