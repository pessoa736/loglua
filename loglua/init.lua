local log = {}

log = {
    _messages = {},
    _NErrors = 0,
    show = function ()
        for i, v in ipairs(log._messages) do
            print(v)
        end 
        print("\nTotal prints: ", #log._messages)
        print("Total erros: ", log._NErrors)
    end,

    save = function (logDirFile, name)
        local base = logDirFile .. (name or "log.txt")
        
        local Checkfile <close> = io.open(base, "r+")
        local exist = Checkfile ~= nil
        if Checkfile then Checkfile:close() end

        local file = io.open(base, not Checkfile and "w+" or "a+")
        if not file then
            error("save erro")
        else
            for i, v in ipairs(log._messages) do
                if i <= 1 then
                    local line = string.rep("-=",21)
                    file:write('\n\n'.. line .."\n")
                    file:write("--\t\t" ..  os.date() .. "\t\t--\n") 
                    file:write(line .."\n\n")
                end
                file:write(v .. "\n")
            end
        end

        file:close()
        print("Log saved")
    end,
    
    add = function (...)
        local message = ""


        for i, v in ipairs({...}) do
            message = message .. " " .. tostring(v)
        end
        
        local text = "[ ".. (#log._messages + 1) .." ]".. message
        
        table.insert(log._messages, text)
    end,
    error = function(...)
        log._NErrors = log._NErrors + 1
        log.add("///-- Error: ", ...)
    end
} 

return setmetatable(log, {
    __index = function(s, k)
        return log[k]
    end,
    __call = function(_, ...)
        log.add(...)
    end
})