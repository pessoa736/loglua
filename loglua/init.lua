
local config        = require("loglua.config")
local formatter     = require("loglua.formatter")
local fileHandler   = require("loglua.file_handler")
local helpModule    = require("loglua.help")

--- Módulo principal de logging
---@type logluaLib 
local log = {}
log.__index = log
log.__call = function (s, ...) s.add(...) end

local showHelpTip = true

--============================================================================
-- CONFIGURAÇÃO DE DEBUG
--============================================================================
log.activateDebugMode = config.activateDebugMode
log.deactivateDebugMode = config.deactivateDebugMode
log.checkDebugMode = config.isDebugMode

log.setHandlerHeader = config.setHandlerHeader

--============================================================================
-- CONFIGURAÇÃO DE CORES
--============================================================================
function log.enableColors()  formatter.useColors = true end
function log.disableColors() formatter.useColors = false end

function log.hasColors()
    return formatter.useColors
end

--============================================================================
-- GERENCIAMENTO DE ESTADO
--============================================================================
log.clear = config.clear

--============================================================================
-- GERENCIAMENTO DE SEÇÕES
--============================================================================
log.setDefaultSection = config.setDefaultSection
log.getDefaultSection = config.getDefaultSection
log.getSections = config.getSections

--============================================================================
-- MODO LIVE (AO-VIVO)
--============================================================================
log.live = config.activateLiveMode
log.unlive = config.deactivateLiveMode
log.isLive = config.isLiveMode

--============================================================================
-- EXIBIÇÃO DE LOGS
--============================================================================

function log.show(filter)
    local messages
    local isLive = config.isLiveMode()
    
    if isLive then
        -- Modo live: pega só as novas mensagens
        messages = config.getNewMessages()
        
        if #messages == 0 then
            return -- Nada novo pra mostrar
        end
        
        -- Aplica filtro de seção
        if filter then
            local filtered = {}
            local sectionLookup = {}
            
            if type(filter) == "string" then
                sectionLookup[filter] = true
            elseif type(filter) == "table" then
                for _, s in ipairs(filter) do
                    sectionLookup[s] = true
                end
            end
            
            for _, msg in ipairs(messages) do
                if sectionLookup[msg.section] then
                    table.insert(filtered, msg)
                end
            end
            messages = filtered
            
            if #messages == 0 then
                return -- Nada novo na seção filtrada
            end
        end
    else
        -- Modo normal: pega todas as mensagens (com filtro)
        if type(filter) == "string" then
            messages = config.getMessagesBySection(filter)
        elseif type(filter) == "table" then
            messages = config.getMessagesBySections(filter)
        else
            messages = config.getMessages()
        end
    end
    
    -- Header
    if not isLive then
        print(formatter.createHeader(config._HandlerHeader))
    end
    
    -- Filtro label
    if filter then
        local filterText = type(filter) == "table" and table.concat(filter, ", ") or filter
        print("Filtro: [" .. filterText .. "]\n")
    end
    
    -- Agrupa mensagens consecutivas da mesma seção
    local startOffset = 0
    if isLive then
        startOffset = config.getLastShownIndex()
    end
    local groups = formatter.groupMessages(messages, config.isDebugMode(), startOffset)
    
    -- Exibe cada grupo formatado
    for i, group in ipairs(groups) do
        local canMerge = false
        local output = ""
        
        -- Verifica se podemos mesclar com o último grupo impresso no modo live
        if isLive and i == 1 and config._lastShownPrinted then
            if group.section == config._lastPrintedGroupSection and 
               group.msgType == config._lastPrintedGroupType and
               group.startIdx == config._lastPrintedGroupEnd + 1 then
                   canMerge = true
            end
        end
        
        if canMerge then
            -- Reconstrói o grupo completo (antigo + novo)
            local allMessages = config.getMessages()
            local mergedGroup = {
                startIdx = config._lastPrintedGroupStart,
                endIdx = group.endIdx,
                section = group.section,
                msgType = group.msgType,
                messages = {}
            }
            
            for idx = mergedGroup.startIdx, mergedGroup.endIdx do
                table.insert(mergedGroup.messages, allMessages[idx].message)
            end
            
            output = formatter.formatGroup(mergedGroup)
            
            -- Apaga saída anterior se possível
            if config._lastPrintedLines and config._lastPrintedLines > 0 then
                -- Move cursor para cima N linhas
                io.write("\27[" .. config._lastPrintedLines .. "A")
                -- Limpa da posição do cursor até o fim da tela
                io.write("\27[J")
            end
            print(output)
            
            -- Atualiza variáveis de estado
            config._lastPrintedGroupEnd = mergedGroup.endIdx
        else
            output = formatter.formatGroup(group)
            print(output)
            
            if isLive then
                config._lastPrintedGroupStart = group.startIdx
                config._lastPrintedGroupEnd = group.endIdx
                config._lastPrintedGroupSection = group.section
                config._lastPrintedGroupType = group.msgType
            end
        end
        
        -- Atualiza contagem de linhas impressas (para poder apagar na próxima)
        if isLive then
            -- Conta quebras de linha na string formatada
            local _, count = output:gsub("\n", "\n")
            -- print() adiciona mais uma quebra de linha no final
            -- formatGroup já termina com \n, então print adiciona uma linha em branco extra
            config._lastPrintedLines = count + 1
        end
    end

    -- Stats (only in normal mode)
    if not isLive then
        print("\nTotal prints: ", #messages)
        print("Total erros: ", config.getErrorCount())
        
        if not filter then
            local sections = config.getSections()
            if #sections > 0 then
                print("Seções: ", table.concat(sections, ", "))
            end
        end
        
        -- Dica de ajuda (só uma vez)
        if showHelpTip then
            local tip = "💡 Tip: log.help() for help"
            print("\n" .. tip)
            showHelpTip = false
        end
    end

    -- Atualiza índice da última mensagem exibida (modo live)
    if isLive then
        config.setLastShownIndex(#config.getMessages())
        config._lastShownPrinted = true
    end
end




--============================================================================
-- SALVAMENTO DE LOGS
--============================================================================
function log.save(logDirFile, name, filter)
    local filepath = fileHandler.buildPath(logDirFile, name)
    local file = fileHandler.openForWrite(filepath)
    
    -- Desabilita cores temporariamente para salvar em arquivo
    local hadColors = formatter.useColors
    formatter.useColors = false
    
    -- Obtém mensagens filtradas
    local messages
    if type(filter) == "string" then
        messages = config.getMessagesBySection(filter)
    elseif type(filter) == "table" then
        messages = config.getMessagesBySections(filter)
    else
        messages = config.getMessages()
    end
    
    -- Escreve cabeçalho
    fileHandler.write(file, formatter.createHeader(config._HandlerHeader))
    if filter then
        local filterText = type(filter) == "table" and table.concat(filter, ", ") or filter
        fileHandler.write(file, "Filtro: [" .. filterText .. "]\n\n")
    end
    
    -- Agrupa mensagens consecutivas da mesma seção
    local groups = formatter.groupMessages(messages, config.isDebugMode(), 0)
    
    -- Escreve cada grupo formatado
    for _, group in ipairs(groups) do
        fileHandler.write(file, formatter.formatGroup(group) .. "\n")
    end
    
    fileHandler.close(file)
    
    -- Restaura configuração de cores
    formatter.useColors = hadColors
    
    print("Log saved")
end



--============================================================================
-- ADIÇÃO DE MENSAGENS
--============================================================================
function log.add(...)
    local args = {...}
    local section = nil
    local message
    
    -- Verifica se o primeiro argumento é uma tabela de opções
    if type(args[1]) == "table" and args[1]._section then
        section = args[1]._section
        table.remove(args, 1)
    end
    
    message = formatter.argsToString(table.unpack(args))
    config.addMessage("log", message, section)
    if log.isLive() then log.show() end
end

function log.debug(...)
    if not config.isDebugMode() then return end

    local args = {...}
    local section = nil
    local message
    
    if type(args[1]) == "table" and args[1]._section then
        section = args[1]._section
        table.remove(args, 1)
    end
    
    message = formatter.argsToString(table.unpack(args))
    config.addMessage("debug", message, section)
    if log.isLive() then log.show() end
end

function log.error(...)
    local args = {...}
    local section = nil
    local message
    
    if type(args[1]) == "table" and args[1]._section then
        section = args[1]._section
        table.remove(args, 1)
    end
    
    config.incrementErrorCount()
    message = formatter.formatErrorPrefix() .. formatter.argsToString(table.unpack(args))
    config.addMessage("error", message, section)
    if log.isLive() then log.show() end
end



--============================================================================
-- HELPERS DE SEÇÃO
--============================================================================
function log.section(sectionName)
    return {_section = sectionName}
end


function log.inSection(sectionName)
    return setmetatable({
        add = function(...)
            log.add(log.section(sectionName), ...)
        end,
        debug = function(...)
            log.debug(log.section(sectionName), ...)
        end,
        error = function(...)
            log.error(log.section(sectionName), ...)
        end
    }, log)
end

--============================================================================
-- AJUDA E IDIOMA
--============================================================================
function log.help(topic)
    helpModule.show(topic)
end



--============================================================================
-- METATABLE (permite chamar log diretamente como função)
--============================================================================


---@type logluaLib
return setmetatable(log, log)