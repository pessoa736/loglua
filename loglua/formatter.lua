
    ---LogLua - Módulo de Formatação de Mensagens
    --- Responsável por formatar as mensagens de log para exibição e salvamento:
    --- - Criação de cabeçalhos com timestamp
    --- - Formatação de mensagens com índice e seção
    --- - Agrupamento de mensagens consecutivas da mesma seção
    --- - Conversão de argumentos para string
    ---@module "loglua.formatter"
    ---@author pessoa736
    ---@license MIT

--utils
local formatIndex = require "loglua.utils.formatIndex"


--- Módulo de formatação

---@type loglua.formatterLib
local formatter <const> = {}

--============================================================================
-- CORES ANSI
--============================================================================


formatter.colors = require("loglua.constants.ANSIColors")
formatter.useColors = true

--============================================================================
-- SEPARADORES E CABEÇALHOS
--============================================================================

function formatter.createSeparator(char, count)
    char = char or "-="
    count = count or 21
    return string.rep(char, count)
end



function formatter.createHeader(handlerHeader)
    local char, count, text
    if type(handlerHeader) == "function" then
        char, count, text = handlerHeader()
    else
        -- Fallback padrão quando nenhum handler é fornecido
        char, count, text = "-=", 21, nil
    end
    local line = formatter.createSeparator(char, count)
    local header = '\n' .. line .. "\n"
    header = header .. "--\t" .. (text or os.date()) .. "\t--\n"
    header = header .. line .. "\n\n"
    return header
end

--============================================================================
-- FORMATAÇÃO DE MENSAGENS
--============================================================================

function formatter.formatMessage(index, message, section)
    local indexStr = type(index) == "string" and index or ("[" .. index .. "]")
    local sectionTag = section and ("[" .. section .. "]") or ""
    return indexStr .. sectionTag .. "\n" .. message .. "\n"
end



function formatter.formatDebugMessage(index, message, section)
    local indexStr = type(index) == "string" and index or ("[" .. index .. "]")
    local sectionTag = section and ("[" .. section .. "]") or ""
    return indexStr .. sectionTag .. "\n__ " .. message .. "\n"
end

--============================================================================
-- AGRUPAMENTO DE MENSAGENS
--============================================================================


function formatter.groupMessages(messages, debugMode, startOffset)
    local groups = {}
    local currentGroup = nil
    local index = startOffset or 0
    
    for _, msg in ipairs(messages) do
        -- Verifica se deve incluir a mensagem
        local include = (msg.type == "log" or msg.type == "error") or 
                       (msg.type == "debug" and debugMode)
        
        if include then
            index = index + 1
            
            -- Verifica se pode agrupar com o grupo atual (mesmo tipo e seção)
            if currentGroup and 
               currentGroup.section == msg.section and 
               currentGroup.msgType == msg.type then
                -- Adiciona ao grupo atual
                currentGroup.endIdx = index
                table.insert(currentGroup.messages, msg.message)
            else
                -- Inicia novo grupo
                if currentGroup then
                    table.insert(groups, currentGroup)
                end
                currentGroup = {
                    startIdx = index,
                    endIdx = index,
                    section = msg.section,
                    messages = {msg.message},
                    msgType = msg.type
                }
            end
        end
    end
    
    -- Adiciona último grupo
    if currentGroup then
        table.insert(groups, currentGroup)
    end
    
    return groups
end


function formatter.formatGroup(group)
    local indexStr = formatIndex(group.startIdx, group.endIdx)
    local sectionTag = group.section and ("[" .. group.section .. "]") or ""
    local typeTag = ""
    local color = ""
    local reset = ""
    
    -- Aplica cores se habilitado
    if formatter.useColors then
        reset = formatter.colors.reset
        if group.msgType == "debug" then
            color = formatter.colors.yellow
            typeTag = "__"
        elseif group.msgType == "error" then
            color = formatter.colors.red
        end
    else
        if group.msgType == "debug" then
            typeTag = "__"
        end
    end
    
    local content = table.concat(group.messages, "\n")
    
    return color .. indexStr .. sectionTag .. typeTag .. "\n" .. content .. reset .. "\n"
end

--============================================================================
-- CONVERSÃO DE ARGUMENTOS
--============================================================================


function formatter.argsToString(...)
    local message = ""
    for _, v in ipairs({...}) do
        message = message .. " " .. tostring(v)
    end
    return message
end

--============================================================================
-- PREFIXOS ESPECIAIS
--============================================================================


function formatter.formatErrorPrefix()
    return "////--error:"
end

return formatter
