--[[
    LogLua - Módulo de Configuração e Estado
    
    Gerencia o estado interno do sistema de logging:
    - Armazenamento de mensagens
    - Modo debug
    - Contadores de erros
    - Sistema de seções/categorias
    
    @module loglua.config
    @author pessoa736
    @license MIT
    @local
]]

--- Estado interno do módulo
-- @table config
-- @field _debugMode boolean Indica se modo debug está ativo
-- @field _messages table Lista de mensagens armazenadas
-- @field _errorCount number Contador de erros
-- @field _sections table Seções registradas (lookup table)
-- @field _defaultSection string Nome da seção padrão
-- @field _lastShownIndex number Índice da última mensagem exibida (para modo live)
-- @field _liveMode boolean Indica se modo live está ativo
local config = {
    _debugMode = false,
    _messages = {},
    _errorCount = 0,
    _sections = {},
    _defaultSection = "general",
    _lastShownIndex = 0,
    _lastShownPrinted = false, -- se o índice foi atualizado por um show real
    _liveMode = false
}

--============================================================================
-- MODO DEBUG
--============================================================================

--- Ativa o modo debug
-- Quando ativo, mensagens de debug serão exibidas e salvas
-- @function activateDebugMode
function config.activateDebugMode()
    config._debugMode = true
end

--- Desativa o modo debug
-- Mensagens de debug serão ignoradas ao exibir/salvar
-- @function deactivateDebugMode
function config.deactivateDebugMode()
    config._debugMode = false
end

--- Verifica se o modo debug está ativo
-- @function isDebugMode
-- @treturn boolean true se modo debug está ativo
function config.isDebugMode()
    return config._debugMode
end

--============================================================================
-- GERENCIAMENTO DE MENSAGENS
--============================================================================

--- Retorna todas as mensagens armazenadas
-- @function getMessages
-- @treturn table Lista de todas as mensagens
function config.getMessages()
    return config._messages
end

--- Retorna mensagens filtradas por uma única seção
-- @function getMessagesBySection
-- @tparam string section Nome da seção para filtrar
-- @treturn table Lista de mensagens da seção especificada
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

--- Retorna mensagens filtradas por múltiplas seções
-- @function getMessagesBySections
-- @tparam table sections Lista de nomes de seções para filtrar
-- @treturn table Lista de mensagens das seções especificadas
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

--- Adiciona uma nova mensagem ao log
-- @function addMessage
-- @tparam string msgType Tipo da mensagem ("log", "debug" ou "error")
-- @tparam string message Conteúdo da mensagem
-- @tparam[opt] string section Nome da seção (usa _defaultSection se não informado)
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

--- Retorna o número total de mensagens
-- @function getMessageCount
-- @treturn number Quantidade de mensagens armazenadas
function config.getMessageCount()
    return #config._messages
end

--- Retorna o número de mensagens em uma seção específica
-- @function getMessageCountBySection
-- @tparam string section Nome da seção
-- @treturn number Quantidade de mensagens na seção
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

--- Incrementa o contador de erros
-- @function incrementErrorCount
function config.incrementErrorCount()
    config._errorCount = config._errorCount + 1
end

--- Retorna o número total de erros registrados
-- @function getErrorCount
-- @treturn number Quantidade de erros
function config.getErrorCount()
    return config._errorCount
end

--============================================================================
-- GERENCIAMENTO DE SEÇÕES
--============================================================================

--- Retorna lista de todas as seções utilizadas
-- @function getSections
-- @treturn table Lista ordenada alfabeticamente de nomes de seções
function config.getSections()
    local sections = {}
    for section, _ in pairs(config._sections) do
        table.insert(sections, section)
    end
    table.sort(sections)
    return sections
end

--- Define a seção padrão para novas mensagens
-- @function setDefaultSection
-- @tparam string section Nome da seção padrão
function config.setDefaultSection(section)
    config._defaultSection = section
end

--- Retorna o nome da seção padrão atual
-- @function getDefaultSection
-- @treturn string Nome da seção padrão
function config.getDefaultSection()
    return config._defaultSection
end

--============================================================================
-- RESET
--============================================================================

--- Limpa todas as mensagens e reseta contadores
-- Remove todas as mensagens, seções registradas e zera contador de erros
-- @function clear
function config.clear()
    config._messages = {}
    config._sections = {}
    config._errorCount = 0
    config._lastShownIndex = 0
end

--============================================================================
-- MODO LIVE
--============================================================================

--- Ativa o modo live (ao-vivo)
-- @function activateLiveMode
function config.activateLiveMode()
    config._liveMode = true
    config._lastShownIndex = #config._messages
    config._lastShownPrinted = false
end

--- Desativa o modo live
-- @function deactivateLiveMode
function config.deactivateLiveMode()
    config._liveMode = false
end

--- Verifica se o modo live está ativo
-- @function isLiveMode
-- @treturn boolean true se modo live está ativo
function config.isLiveMode()
    return config._liveMode
end

--- Retorna o índice da última mensagem exibida
-- @function getLastShownIndex
-- @treturn number Índice da última mensagem exibida
function config.getLastShownIndex()
    return config._lastShownIndex
end

--- Define o índice da última mensagem exibida
-- @function setLastShownIndex
-- @tparam number index Novo índice
function config.setLastShownIndex(index)
    config._lastShownIndex = index
end

--- Retorna apenas as novas mensagens (desde o último show)
-- @function getNewMessages
-- @treturn table Lista de novas mensagens
function config.getNewMessages()
    local newMessages = {}
    for i = config._lastShownIndex + 1, #config._messages do
        table.insert(newMessages, config._messages[i])
    end
    return newMessages
end

return config
