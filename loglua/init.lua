local log = {}

log = {
    _messages = {},
    _NErrors = 0,
    _debugMode = false,

    activateDebubMode = function()
        log._debugMode =true
    end,
    deactivateDebubMode = function()
        log._debugMode = false
    end,
    checkDebugMode = function()
        return log._debugMode
    end,
    
    show = function ()

        local line = string.rep("-=",21)
        print('\n'.. line)
        print("--\t" ..  os.date() .. "\t--") 
        print(line .."\n\n")

        local index = 0
        for i, v in ipairs(log._messages) do
                if v.type == "log" then
                    index = index + 1
                    print("[".. index.."]".. v.message)
                elseif v.type == "debug" and log.checkDebugMode() then
                    index = index + 1
                    print("[".. index.."]".. "__ " .. v.message)
                end
        end 
        print("\nTotal prints: ", #log._messages)
        print("Total erros: ", log._NErrors)
    end,

    save = function (logDirFile, name)
    local base = (logDirFile or "") .. (name or "log.txt")
        
        local Checkfile <close> = io.open(base, "r+")
        local exist = Checkfile ~= nil
        if Checkfile then Checkfile:close() end

        local file <close> = io.open(base, not Checkfile and "w+" or "a+")
        if not file then
            error("save erro")
        else
            local index = 0
            for i, v in ipairs(log._messages) do
                if i <= 1 then
                    local line = string.rep("-=",21)
                    file:write('\n\n'.. line .."\n")
                    file:write("--\t\t" ..  os.date() .. "\t\t--\n") 
                    file:write(line .."\n\n")
                end
                if v.type == "log" then
                    index = index + 1
                    file:write("[".. index.."]".. v.message .. "\n")
                elseif v.type == "debug" and log.checkDebugMode() then
                    index = index + 1
                    file:write("[".. index.."]".. "__ " .. v.message .. "\n")
                end
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
        
        table.insert(log._messages, {type="log", message = message})
    end,
    
    debug = function (...)
        local message = ""

        for i, v in ipairs({...}) do
            message = message .. " " .. tostring(v)
        end
        
        table.insert(log._messages, {type="debug", message = message})
    end,

    error = function(...)
    log._NErrors = log._NErrors + 1
        local message = ""

        for i, v in ipairs({...}) do
            message = message .. " " .. tostring(v)
        end
        table.insert(log._messages, {type="error", message = message})
    end
} 

return setmetatable(log, {
    __call = function(_, ...)
        log.add(...)
    end
})