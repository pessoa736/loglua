
---@type loglua.configLib
local config = {
    _debugMode = false,
    _messages = {},
    _errorCount = 0,
    _sections = {},
    _defaultSection = "general",
    _lastShownIndex = 0,
    _lastShownPrinted = false, -- se o índice foi atualizado por um show real
    _lastPrintedGroupStart = 0,
    _lastPrintedGroupEnd = 0,
    _lastPrintedGroupSection = nil,
    _lastPrintedGroupType = nil,
    _lastPrintedLines = 0,     -- número de linhas ocupadas pelo último grupo impresso
    _liveMode = false,
    _HandlerHeader = function() return "-=", 21, "title"  end
}



--============================================================================
-- MODO DEBUG
--============================================================================
function config.activateDebugMode() config._debugMode = true end
function config.setHandlerHeader(func) config._HandlerHeader = func end
function config.deactivateDebugMode() config._debugMode = false end

function config.isDebugMode()
    return config._debugMode
end



--============================================================================
-- GERENCIAMENTO DE MENSAGENS
--============================================================================
function config.getMessages()
    return config._messages
end


function config.getMessagesBySection(section)
    if not section then
        return config._messages
    end
    
    local filtered = {}
    for _, msg in ipairs(config._messages) do
        if msg.section == section then
            table.insert(filtered, msg)
        end
    end
    return filtered
end


function config.getMessagesBySections(sections)
    if not sections or #sections == 0 then
        return config._messages
    end
    
    -- Converte para lookup table para performance O(1)
    local sectionLookup = {}
    for _, s in ipairs(sections) do
        sectionLookup[s] = true
    end
    
    local filtered = {}
    for _, msg in ipairs(config._messages) do
        if sectionLookup[msg.section] then
            table.insert(filtered, msg)
        end
    end
    return filtered
end



function config.addMessage(msgType, message, section)
    section = section or config._defaultSection
    -- Registra a seção automaticamente
    config._sections[section] = true
    table.insert(config._messages, {
        type = msgType, 
        message = message,
        section = section
    })
end



function config.getMessageCount()
    return #config._messages
end



function config.getMessageCountBySection(section)
    local count = 0
    for _, msg in ipairs(config._messages) do
        if msg.section == section then
            count = count + 1
        end
    end
    return count
end



--============================================================================
-- GERENCIAMENTO DE ERROS
--============================================================================
function config.incrementErrorCount()
    config._errorCount = config._errorCount + 1
end

function config.getErrorCount()
    return config._errorCount
end


--============================================================================
-- GERENCIAMENTO DE SEÇÕES
--============================================================================
function config.getSections()
    local sections = {}
    for section, _ in pairs(config._sections) do
        table.insert(sections, section)
    end
    table.sort(sections)
    return sections
end

function config.setDefaultSection(section)
    config._defaultSection = section
end

function config.getDefaultSection()
    return config._defaultSection
end



--============================================================================
-- RESET
--============================================================================
function config.clear()
    config._messages = {}
    config._sections = {}
    config._errorCount = 0
    config._lastShownIndex = 0
end



--============================================================================
-- MODO LIVE
--============================================================================
function config.activateLiveMode()
    config._liveMode = true
    config._lastShownIndex = #config._messages
    config._lastShownPrinted = false
end

function config.deactivateLiveMode()
    config._liveMode = false
end

function config.isLiveMode()
    return config._liveMode
end

function config.getLastShownIndex()
    return config._lastShownIndex
end

function config.setLastShownIndex(index)
    config._lastShownIndex = index
end

function config.getNewMessages()
    local newMessages = {}
    for i = config._lastShownIndex + 1, #config._messages do
        table.insert(newMessages, config._messages[i])
    end
    return newMessages
end





return config
