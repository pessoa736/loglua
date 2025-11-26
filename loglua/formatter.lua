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
-- SEPARADORES E CABEÇALHOS
--============================================================================

--- Cria uma linha separadora decorativa
-- @function createSeparator
-- @tparam[opt="-="] string char Caractere ou padrão para repetir
-- @tparam[opt=21] number count Número de repetições
-- @treturn string Linha separadora
-- @usage
--   formatter.createSeparator()        -- "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
--   formatter.createSeparator("*", 10) -- "**********"
function formatter.createSeparator(char, count)
    char = char or "-="
    count = count or 21
    return string.rep(char, count)
end

--- Cria o cabeçalho formatado do log com timestamp
-- @function createHeader
-- @treturn string Cabeçalho com linhas separadoras e data/hora
-- @usage
--   print(formatter.createHeader())
--   -- Saída:
--   -- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--   -- --	Tue Nov 25 14:30:00 2025	--
--   -- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function formatter.createHeader()
    local line = formatter.createSeparator()
    local header = '\n' .. line .. "\n"
    header = header .. "--\t" .. os.date() .. "\t--\n"
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
--   formatter.formatDebugMessage(1, "x = 42")           -- "[1]__\n x = 42\n"
--   formatter.formatDebugMessage(2, "y = 10", "parser") -- "[2][parser]__\n y = 10\n"
function formatter.formatDebugMessage(index, message, section)
    local indexStr = type(index) == "string" and index or ("[" .. index .. "]")
    local sectionTag = section and ("[" .. section .. "]") or ""
    return indexStr .. sectionTag .. "__\n" .. message .. "\n"
end

--============================================================================
-- AGRUPAMENTO DE MENSAGENS
--============================================================================

--- Agrupa mensagens consecutivas da mesma seção
-- @function groupMessages
-- @tparam table messages Lista de mensagens
-- @tparam boolean debugMode Se modo debug está ativo
-- @treturn table Lista de grupos {startIdx, endIdx, section, messages, isDebug}
function formatter.groupMessages(messages, debugMode)
    local groups = {}
    local currentGroup = nil
    local index = 0
    
    for _, msg in ipairs(messages) do
        -- Verifica se deve incluir a mensagem
        local include = (msg.type == "log" or msg.type == "error") or 
                       (msg.type == "debug" and debugMode)
        
        if include then
            index = index + 1
            local isDebug = msg.type == "debug"
            
            -- Verifica se pode agrupar com o grupo atual
            if currentGroup and 
               currentGroup.section == msg.section and 
               currentGroup.isDebug == isDebug then
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
                    isDebug = isDebug
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
    local debugTag = group.isDebug and "__" or ""
    
    local content = table.concat(group.messages, "\n")
    
    return indexStr .. sectionTag .. debugTag .. "\n" .. content .. "\n"
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
