--[[
    LogLua - Sistema de logging modular para Lua
    
    Um sistema de logging simples e flexível que permite:
    - Adicionar mensagens de log, debug e erro
    - Organizar logs por seções/categorias
    - Filtrar logs ao exibir ou salvar
    - Salvar logs em arquivos
    
    @module loglua
    @author pessoa736
    @license MIT
    @usage
        local log = require("loglua")
        
        -- Log simples
        log("Mensagem simples")
        log.add("Outra mensagem")
        
        -- Log com seção
        log.add(log.section("network"), "Conexão estabelecida")
        
        -- Usando inSection para múltiplos logs
        local netLog = log.inSection("network")
        netLog.add("Enviando dados")
        netLog.error("Timeout!")
        
        -- Exibir logs
        log.show()              -- todos
        log.show("network")     -- apenas seção "network"
        log.show({"network", "database"})  -- múltiplas seções
        
        -- Salvar logs
        log.save("./logs/", "app.log")
        log.save("./logs/", "network.log", "network")
        
        -- Ajuda
        log.help()              -- ajuda geral
        log.help("sections")    -- ajuda sobre seções
        log.help("api")         -- lista da API
]]

-- Importa módulos internos
local path = (...):match("(.+)%.[^%.]+$") or (...)
local config = require(path .. ".config")
local formatter = require(path .. ".formatter")
local fileHandler = require(path .. ".file_handler")
local helpModule = require(path .. ".help")

--- Módulo principal de logging
-- @table log
local log = {}

--- Flag para mostrar dica de ajuda (só uma vez)
local showHelpTip = true

--============================================================================
-- CONFIGURAÇÃO DE DEBUG
--============================================================================

--- Ativa o modo debug (mensagens de debug serão exibidas/salvas)
-- @function activateDebugMode
-- @usage log.activateDebugMode()
log.activateDebugMode = config.activateDebugMode

--- Desativa o modo debug
-- @function deactivateDebugMode
-- @usage log.deactivateDebugMode()
log.deactivateDebugMode = config.deactivateDebugMode

--- Verifica se o modo debug está ativo
-- @function checkDebugMode
-- @treturn boolean true se modo debug está ativo
-- @usage if log.checkDebugMode() then print("Debug ativo") end
log.checkDebugMode = config.isDebugMode

-- Aliases para manter compatibilidade com typos antigos (deprecated)
log.activateDebubMode = config.activateDebugMode
log.deactivateDebubMode = config.deactivateDebugMode

--============================================================================
-- CONFIGURAÇÃO DE CORES
--============================================================================

--- Habilita cores ANSI na saída (errors em vermelho, debug em amarelo)
-- @function enableColors
-- @usage log.enableColors()
function log.enableColors()
    formatter.useColors = true
end

--- Desabilita cores ANSI na saída
-- @function disableColors
-- @usage log.disableColors()
function log.disableColors()
    formatter.useColors = false
end

--- Verifica se cores estão habilitadas
-- @function hasColors
-- @treturn boolean true se cores estão habilitadas
function log.hasColors()
    return formatter.useColors
end

--============================================================================
-- GERENCIAMENTO DE ESTADO
--============================================================================

--- Limpa todas as mensagens e reseta contadores
-- @function clear
-- @usage log.clear()
log.clear = config.clear

--============================================================================
-- GERENCIAMENTO DE SEÇÕES
--============================================================================

--- Define a seção padrão para novas mensagens
-- @function setDefaultSection
-- @tparam string section Nome da seção padrão
-- @usage log.setDefaultSection("game")
log.setDefaultSection = config.setDefaultSection

--- Retorna o nome da seção padrão atual
-- @function getDefaultSection
-- @treturn string Nome da seção padrão
-- @usage local section = log.getDefaultSection()
log.getDefaultSection = config.getDefaultSection

--- Retorna lista de todas as seções utilizadas
-- @function getSections
-- @treturn table Lista ordenada de nomes de seções
-- @usage local sections = log.getSections()
log.getSections = config.getSections

--============================================================================
-- MODO LIVE (AO-VIVO)
--============================================================================

--- Ativa o modo live (ao-vivo)
-- No modo live, log.show() exibe apenas as novas mensagens desde a última chamada
-- @function live
-- @usage
--   log.live()     -- ativa modo live
--   log("msg1")
--   log.show()     -- mostra só msg1
--   log("msg2")
--   log.show()     -- mostra só msg2
log.live = config.activateLiveMode

--- Desativa o modo live
-- @function unlive
-- @usage log.unlive()  -- volta ao modo normal
log.unlive = config.deactivateLiveMode

--- Verifica se o modo live está ativo
-- @function isLive
-- @treturn boolean true se modo live está ativo
log.isLive = config.isLiveMode

--============================================================================
-- EXIBIÇÃO DE LOGS
--============================================================================

--- Exibe o log no console com filtro opcional de seção
-- Mensagens consecutivas da mesma seção são agrupadas com índice [x-y]
-- No modo live, exibe apenas as novas mensagens desde a última chamada
-- @function show
-- @tparam[opt] string|table filter Nome da seção ou tabela com múltiplas seções
-- @usage
--   log.show()                        -- mostra todos (ou novos no modo live)
--   log.show("network")               -- filtra por seção "network"
--   log.show({"network", "database"}) -- filtra por múltiplas seções
function log.show(filter)
    -- Obtém mensagens baseado no modo (live ou normal)
    local messages
    local isLive = config.isLiveMode()
    
    if isLive then
        -- Modo live: pega só as novas mensagens
        messages = config.getNewMessages()
        
        if #messages == 0 then
            return -- Nada novo pra mostrar
        end
    else
        -- Modo normal: pega todas as mensagens
        print(formatter.createHeader())
        
        if type(filter) == "string" then
            messages = config.getMessagesBySection(filter)
            print("Filtro: [" .. filter .. "]\n")
        elseif type(filter) == "table" then
            messages = config.getMessagesBySections(filter)
            print("Filtro: [" .. table.concat(filter, ", ") .. "]\n")
        else
            messages = config.getMessages()
        end
    end
    
    -- Aplica filtro de seção se especificado (modo live também)
    if isLive and filter then
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
    
    -- Agrupa mensagens consecutivas da mesma seção
    local groups = formatter.groupMessages(messages, config.isDebugMode())
    
    -- Exibe cada grupo formatado
    for _, group in ipairs(groups) do
        print(formatter.formatGroup(group))
    end
    
    -- Atualiza índice da última mensagem exibida (modo live)
    if isLive then
        config.setLastShownIndex(#config.getMessages())
    else
        -- Exibe estatísticas apenas no modo normal
        print("\nTotal prints: ", #messages)
        print("Total erros: ", config.getErrorCount())
        
        -- Mostra seções disponíveis se não houver filtro
        if not filter then
            local sections = config.getSections()
            if #sections > 0 then
                print("Seções: ", table.concat(sections, ", "))
            end
        end
        
        -- Mostra dica de ajuda (só uma vez)
        if showHelpTip then
            local lang = helpModule.getLanguage()
            local tip
            if lang == "en" then
                tip = "💡 Tip: log.help() for help | log.setLanguage('pt'|'es') to change language"
            elseif lang == "es" then
                tip = "💡 Consejo: log.help() para ayuda | log.setLanguage('pt'|'en') para cambiar idioma"
            else
                tip = "💡 Dica: log.help() para ajuda | log.setLanguage('en'|'es') para mudar idioma"
            end
            print("\n" .. tip)
            showHelpTip = false
        end
    end
end

--============================================================================
-- SALVAMENTO DE LOGS
--============================================================================

--- Salva o log em arquivo com filtro opcional de seção
-- Mensagens consecutivas da mesma seção são agrupadas com índice [x-y]
-- @function save
-- @tparam[opt=""] string logDirFile Diretório onde salvar o arquivo
-- @tparam[opt="log.txt"] string name Nome do arquivo
-- @tparam[opt] string|table filter Nome da seção ou tabela com múltiplas seções
-- @usage
--   log.save()                                    -- salva em "log.txt"
--   log.save("./logs/", "app.log")               -- salva em "./logs/app.log"
--   log.save("./", "net.log", "network")         -- salva apenas seção "network"
--   log.save("./", "multi.log", {"net", "db"})   -- salva múltiplas seções
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
    fileHandler.write(file, formatter.createHeader())
    if filter then
        local filterText = type(filter) == "table" and table.concat(filter, ", ") or filter
        fileHandler.write(file, "Filtro: [" .. filterText .. "]\n\n")
    end
    
    -- Agrupa mensagens consecutivas da mesma seção
    local groups = formatter.groupMessages(messages, config.isDebugMode())
    
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

--- Adiciona uma mensagem de log
-- @function add
-- @tparam[opt] table options Tabela com _section para definir seção (use log.section())
-- @param ... Valores a serem logados (serão convertidos para string)
-- @usage
--   log.add("Mensagem simples")
--   log.add("Valor:", 42, "resultado")
--   log.add(log.section("network"), "Conexão OK")
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

--- Adiciona uma mensagem de debug (só aparece se debugMode estiver ativo)
-- @function debug
-- @tparam[opt] table options Tabela com _section para definir seção (use log.section())
-- @param ... Valores a serem logados (serão convertidos para string)
-- @usage
--   log.activateDebugMode()
--   log.debug("Variável x =", x)
--   log.debug(log.section("parser"), "Token encontrado:", token)
function log.debug(...)
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

--- Adiciona uma mensagem de erro (incrementa contador de erros)
-- @function error
-- @tparam[opt] table options Tabela com _section para definir seção (use log.section())
-- @param ... Valores a serem logados (serão convertidos para string)
-- @usage
--   log.error("Falha ao conectar")
--   log.error(log.section("database"), "Query inválida:", query)
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

--- Cria uma tag de seção para usar em add/debug/error
-- @function section
-- @tparam string sectionName Nome da seção
-- @treturn table Tabela com _section definido
-- @usage log.add(log.section("network"), "Mensagem na seção network")
function log.section(sectionName)
    return {_section = sectionName}
end

--- Cria metatable para objetos de seção (uso interno)
-- @local
local function meta(s)
    return setmetatable(s, {
            __call = function(_, ...)
                s.add(...)
            end
        }
    )
end

--- Cria um objeto de log vinculado a uma seção específica
-- @function inSection
-- @tparam string sectionName Nome da seção
-- @treturn table Objeto com métodos add, debug e error pré-configurados
-- @usage
--   local netLog = log.inSection("network")
--   netLog.add("Conectando...")       -- vai para seção "network"
--   netLog.error("Falha!")            -- vai para seção "network"
--   netLog("Atalho para add")         -- pode chamar diretamente
function log.inSection(sectionName)
    return meta({
        add = function(...)
            log.add(log.section(sectionName), ...)
        end,
        debug = function(...)
            log.debug(log.section(sectionName), ...)
        end,
        error = function(...)
            log.error(log.section(sectionName), ...)
        end
    })
end

--============================================================================
-- AJUDA E IDIOMA
--============================================================================

--- Define o idioma da ajuda
-- @function setLanguage
-- @tparam string lang Código do idioma ("pt", "en", "es")
-- @usage
--   log.setLanguage("en")  -- English
--   log.setLanguage("pt")  -- Português
--   log.setLanguage("es")  -- Español
function log.setLanguage(lang)
    helpModule.setLanguage(lang)
end

--- Retorna o idioma atual da ajuda
-- @function getLanguage
-- @treturn string Código do idioma ("pt", "en", "es")
function log.getLanguage()
    return helpModule.getLanguage()
end

--- Exibe ajuda sobre o uso do LogLua
-- @function help
-- @tparam[opt] string topic Tópico de ajuda ("sections", "live", "api")
-- @usage
--   log.help()            -- ajuda geral
--   log.help("sections")  -- ajuda sobre seções
--   log.help("api")       -- lista completa da API
function log.help(topic)
    helpModule.show(topic)
end

--============================================================================
-- METATABLE (permite chamar log diretamente como função)
--============================================================================

--- Permite chamar log diretamente como função (atalho para log.add)
-- @usage log("Mensagem") -- equivalente a log.add("Mensagem")
return meta(log)