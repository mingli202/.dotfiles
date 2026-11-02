--- makes a new history
--- made up of a map and a double linked list
local new_history = function()
    -- type Node = {next: Node | nil, prev: Node | nil, id: string, value: File}
    -- map of id to node
    local map = {}

    -- the head of the list will be the most recently used
    -- keeps the prev of head and next of tail nil
    local dlist = {
        head = nil,
        tail = nil,
        len = 0,
    }

    --- clears all the links of the given node
    --- from the dlist
    local unlink = function(node) 
        local prev = node.prev
        local next = node.next
        if prev then
            prev.next = next
        else
            dlist.head = next
        end
        if next then
            next.prev = prev
        else
            dlist.tail = prev
        end
        -- clear node data to not be able to reuse them
        node.prev = nil
        node.next = nil
    end

    --- puts the given node to the front of the dlist
    local link_front = function(node) 
        node.next = dlist.head
        node.prev = nil
        if dlist.head then
            dlist.head.prev = node
        else
            dlist.tail = node
        end
        dlist.head = node
    end

    --- removes the given file from the dlist
    --- @returns whether the dlist changed
    local remove = function(file) 
        local node = map[file.path]

        if node == nil then return false end

        unlink(node)

        dlist.len = dlist.len - 1
        map[node.id] = nil

        return true
    end

    --- called when opening the file
    --- adds the file, or moves it to the front if already presenty
    local touch = function(file)
        if not file then return nil end

        local id = file.path
        if not id then return nil end

        local node = map[id]

        if node then
            unlink(node)
            node.value = file
        else
            node = { id = id, value = file }
            dlist.len = dlist.len + 1
            map[id] = node
        end
        link_front(node)
        return node
    end

    --- gets the length of the dlist
    local len = function() return dlist.len end

    --- whether the dlist has the given file
    local has = function(file) return map[file.path] ~= nil end

    --- returns an array of the files sorted by recency
    local to_array = function() 
        local arr = {}
        local cursor = dlist.head

        while cursor ~= nil do
            table.insert(arr, cursor.value)
            cursor = cursor.next
        end

        return arr
    end


    return {
        push_front = push_front,
        remove = remove,
        touch = touch,
        len = len,
        to_array = to_array,
    }
end

return new_history
