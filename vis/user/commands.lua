vis:command_register("syntax?", function (argv, force, win) 
    vis:info("syntax: " .. (win.syntax or "none"))
    return true
end, "Show the syntax of the current window")
