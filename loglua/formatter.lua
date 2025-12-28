--[[
    LogLua - Módulo de Formatação de Mensagens
    
    Responsável por formatar as mensagens de log para exibição e salvamento:
    - Criação de cabeçalhos com timestamp
    - Formatação de mensagens com índice e seção
    - Agrupamento de mensagens consecutivas da mesma seção
    - Conversão de argumentos para string
    
    @module loglua.formatter
    @author pessoa736
    @license MIT
    @local
]]

--- Módulo de formatação
-- @table formatter
local formatter = {}

--============================================================================
-- CORES ANSI
--============================================================================

--- Códigos de cores ANSI para terminal
-- @table colors
formatter.colors = {
    reset = "\27[0m",
    red = "\27[31m",
    yellow = "\27[33m",
    green = "\27[32m",
    cyan = "\27[36m",
    gray = "\27[90m"
}

--- Flag para habilitar/desabilitar cores (habilitado por padrão)
formatter.useColors = true

--============================================================================
-- SEPARADORES E CABEÇALHOS
--============================================================================

---Cria uma linha separadora decorativa
---@function createSeparator
---@tparam[opt="-="] string char Caractere ou padrão para repetir
---@tparam[opt=21] number count Número de repetições
---@treturn string Linha separadora
---@usage
---  formatter.createSeparator()        -- "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
---  formatter.createSeparator("*", 10) -- "**********"
function formatter.createSeparator(char, count)
    char = char or "-="
    count = count or 21
    return string.rep(char, count)
end

--- Cria o cabeçalho formatado do log com timestamp
---@function createHeader
---@treturn string Cabeçalho com linhas separadoras e data/hora
---@usage
---   print(formatter.createHeader())
---   -- Saída:
---   -- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
---   -- --	Tue Nov 25 14:30:00 2025	--
---   -- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
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
-- FORMATAÇÃO DE ÍNDICE
--============================================================================

--- Formata o índice de um grupo de mensagens
-- @function formatIndex
-- @tparam number startIdx Índice inicial
-- @tparam number endIdx Índice final
-- @treturn string Índice formatado "[x]" ou "[x-y]"
local function formatIndex(startIdx, endIdx)
    if startIdx == endIdx then
        return "[" .. startIdx .. "]"
    else
        return "[" .. startIdx .. "-" .. endIdx .. "]"
    end
end

--============================================================================
-- FORMATAÇÃO DE MENSAGENS
--============================================================================

--- Formata uma mensagem de log padrão
-- @function formatMessage
-- @tparam number index Número sequencial da mensagem (ou string para range)
-- @tparam string message Conteúdo da mensagem
-- @tparam[opt] string section Nome da seção (nil para omitir)
-- @treturn string Mensagem formatada com quebras de linha
-- @usage
--   formatter.formatMessage(1, "Hello")              -- "[1]\n Hello\n"
--   formatter.formatMessage(2, "World", "network")   -- "[2][network]\n World\n"
function formatter.formatMessage(index, message, section)
    local indexStr = type(index) == "string" and index or ("[" .. index .. "]")
    local sectionTag = section and ("[" .. section .. "]") or ""
    return indexStr .. sectionTag .. "\n" .. message .. "\n"
end

--- Formata uma mensagem de debug (com prefixo especial)
-- @function formatDebugMessage
-- @tparam number index Número sequencial da mensagem (ou string para range)
-- @tparam string message Conteúdo da mensagem
-- @tparam[opt] string section Nome da seção (nil para omitir)
-- @treturn string Mensagem formatada com marcador de debug "__" e quebras de linha
-- @usage
--   formatter.formatDebugMessage(1, "x = 42")           -- "[1]\n__ x = 42\n"
--   formatter.formatDebugMessage(2, "y = 10", "parser") -- "[2][parser]\n__ y = 10\n"
function formatter.formatDebugMessage(index, message, section)
    local indexStr = type(index) == "string" and index or ("[" .. index .. "]")
    local sectionTag = section and ("[" .. section .. "]") or ""
    return indexStr .. sectionTag .. "\n__ " .. message .. "\n"
end

--============================================================================
-- AGRUPAMENTO DE MENSAGENS
--============================================================================

--- Agrupa mensagens consecutivas da mesma seção
-- @function groupMessages
-- @tparam table messages Lista de mensagens
-- @tparam boolean debugMode Se modo debug está ativo
-- @tparam[opt=0] number startOffset Índice inicial (usado para modo live para continuar a contagem)
-- @treturn table Lista de grupos {startIdx, endIdx, section, messages, msgType}
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

--- Formata um grupo de mensagens
-- @function formatGroup
-- @tparam table group Grupo de mensagens
-- @treturn string Grupo formatado
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

--- Converte argumentos variádicos em uma única string
-- Cada argumento é convertido para string e concatenado com espaço
-- @function argsToString
-- @param ... Argumentos de qualquer tipo
-- @treturn string Argumentos concatenados
-- @usage
--   formatter.argsToString("Hello", 42, true) -- " Hello 42 true"
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

--- Retorna o prefixo usado para mensagens de erro
-- @function formatErrorPrefix
-- @treturn string Prefixo de erro "////--error:"
function formatter.formatErrorPrefix()
    return "////--error:"
end

return formatter
