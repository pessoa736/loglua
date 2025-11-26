--[[
    LogLua - Módulo de Ajuda Multilíngue
    
    Exibe informações sobre a API e como usar o sistema de logging.
    Suporta: Português (pt), English (en), Español (es)
    
    @module loglua.help
    @author pessoa736
    @license MIT
    @local
]]

local help = {}

--- Idioma atual (padrão: português)
help.lang = "pt"

--============================================================================
-- TEXTOS EM PORTUGUÊS
--============================================================================

help.pt = {}

help.pt.text = [[
╔══════════════════════════════════════════════════════════════╗
║                      LogLua v1.5                             ║
║         Sistema de logging modular para Lua                  ║
╚══════════════════════════════════════════════════════════════╝

📝 LOGGING BÁSICO
  log("mensagem")              Adiciona log (atalho)
  log.add("mensagem")          Adiciona log
  log.debug("mensagem")        Adiciona debug (requer debugMode)
  log.error("mensagem")        Adiciona erro

🏷️ SEÇÕES
  log.section("nome")          Cria tag de seção
  log.inSection("nome")        Cria logger vinculado a seção
  log.setDefaultSection("x")   Define seção padrão
  log.getDefaultSection()      Retorna seção padrão
  log.getSections()            Lista seções usadas

📺 EXIBIÇÃO
  log.show()                   Mostra todos os logs
  log.show("section")          Filtra por seção
  log.show({"a", "b"})         Filtra por múltiplas seções

🔴 MODO LIVE (Tempo Real)
  log.live()                   Ativa modo live
  log.unlive()                 Desativa modo live
  log.isLive()                 Verifica se modo live está ativo

💾 SALVAMENTO
  log.save()                   Salva em "log.txt"
  log.save("./", "app.log")    Salva em arquivo específico

🎨 CORES
  log.enableColors()           Habilita cores ANSI
  log.disableColors()          Desabilita cores

⚙️ CONFIGURAÇÃO
  log.activateDebugMode()      Ativa modo debug
  log.deactivateDebugMode()    Desativa modo debug
  log.clear()                  Limpa todos os logs

🌐 IDIOMA
  log.setLanguage("pt")        Português
  log.setLanguage("en")        English
  log.setLanguage("es")        Español

❓ AJUDA
  log.help()                   Mostra esta ajuda
  log.help("sections")         Ajuda sobre seções
  log.help("live")             Ajuda sobre modo live
  log.help("api")              Lista completa da API

Mais info: https://github.com/pessoa736/loglua
]]

help.pt.sections = [[
╔══════════════════════════════════════════════════════════════╗
║                   Sistema de Seções                          ║
╚══════════════════════════════════════════════════════════════╝

Seções permitem organizar logs por categoria (network, database, etc).

🔹 MÉTODO 1: log.section()
   log.add(log.section("network"), "conectando...")
   log.error(log.section("database"), "query falhou")

🔹 MÉTODO 2: log.inSection()
   local net = log.inSection("network")
   net("mensagem 1")
   net("mensagem 2")
   net.error("falhou!")

🔹 MÉTODO 3: Seção padrão
   log.setDefaultSection("game")
   log("player spawned")  -- vai pra seção "game"

🔹 FILTRANDO
   log.show("network")           -- só network
   log.show({"network", "db"})   -- network e db
   log.save("./", "net.log", "network")

🔹 AGRUPAMENTO
   Mensagens consecutivas da mesma seção agrupam automaticamente:
   [1-3][network] ao invés de [1][network], [2][network], [3][network]
]]

help.pt.live = [[
╔══════════════════════════════════════════════════════════════╗
║                      Modo Live                               ║
╚══════════════════════════════════════════════════════════════╝

O modo live permite monitorar logs em tempo real, exibindo apenas
as novas mensagens desde a última chamada de log.show().

🔹 ATIVANDO O MODO LIVE
   log.live()                  -- ativa o modo live
   
🔹 DESATIVANDO
   log.unlive()                -- volta ao modo normal
   
🔹 VERIFICANDO ESTADO
   if log.isLive() then
       print("Modo live ativo!")
   end

🔹 EXEMPLO DE USO
   log.live()                  -- ativa modo live
   
   while running do
       log("evento aconteceu")
       log.show()              -- mostra só os novos logs
       sleep(1)
   end
   
   log.unlive()                -- desativa

🔹 COMPORTAMENTO
   - Modo live: log.show() exibe apenas mensagens novas
   - Modo normal: log.show() exibe todas as mensagens com header
   - Filtros funcionam em ambos os modos
]]

help.pt.api = [[
╔══════════════════════════════════════════════════════════════╗
║                      API Completa                            ║
╚══════════════════════════════════════════════════════════════╝

FUNÇÃO                          DESCRIÇÃO
─────────────────────────────────────────────────────────────────
log(...)                        Atalho para log.add(...)
log.add(...)                    Adiciona mensagem de log
log.debug(...)                  Adiciona mensagem de debug
log.error(...)                  Adiciona mensagem de erro

log.section(name)               Cria tag de seção
log.inSection(name)             Cria logger para seção específica
log.setDefaultSection(name)     Define seção padrão
log.getDefaultSection()         Retorna seção padrão atual
log.getSections()               Lista todas as seções usadas

log.show([filter])              Exibe logs (filtro opcional)
log.save([dir], [name], [flt])  Salva logs em arquivo

log.live()                      Ativa modo live (tempo real)
log.unlive()                    Desativa modo live
log.isLive()                    Verifica se modo live está ativo

log.enableColors()              Habilita cores ANSI
log.disableColors()             Desabilita cores
log.hasColors()                 Verifica se cores estão ativas

log.activateDebugMode()         Ativa modo debug
log.deactivateDebugMode()       Desativa modo debug
log.checkDebugMode()            Verifica estado do debug mode
log.clear()                     Limpa logs e contadores

log.setLanguage(lang)           Define idioma (pt/en/es)
log.help([topic])               Mostra ajuda
─────────────────────────────────────────────────────────────────

TÓPICOS DE AJUDA
  log.help()            Ajuda geral
  log.help("sections")  Sistema de seções
  log.help("live")      Modo live (tempo real)
  log.help("api")       Esta lista
]]

--============================================================================
-- TEXTOS EM INGLÊS
--============================================================================

help.en = {}

help.en.text = [[
╔══════════════════════════════════════════════════════════════╗
║                      LogLua v1.5                             ║
║          Modular logging system for Lua                      ║
╚══════════════════════════════════════════════════════════════╝

📝 BASIC LOGGING
  log("message")               Add log (shortcut)
  log.add("message")           Add log
  log.debug("message")         Add debug (requires debugMode)
  log.error("message")         Add error

🏷️ SECTIONS
  log.section("name")          Create section tag
  log.inSection("name")        Create logger bound to section
  log.setDefaultSection("x")   Set default section
  log.getDefaultSection()      Get default section
  log.getSections()            List used sections

📺 DISPLAY
  log.show()                   Show all logs
  log.show("section")          Filter by section
  log.show({"a", "b"})         Filter by multiple sections

🔴 LIVE MODE (Real-Time)
  log.live()                   Activate live mode
  log.unlive()                 Deactivate live mode
  log.isLive()                 Check if live mode is active

💾 SAVING
  log.save()                   Save to "log.txt"
  log.save("./", "app.log")    Save to specific file

🎨 COLORS
  log.enableColors()           Enable ANSI colors
  log.disableColors()          Disable colors

⚙️ CONFIGURATION
  log.activateDebugMode()      Activate debug mode
  log.deactivateDebugMode()    Deactivate debug mode
  log.clear()                  Clear all logs

🌐 LANGUAGE
  log.setLanguage("en")        English
  log.setLanguage("pt")        Português
  log.setLanguage("es")        Español

❓ HELP
  log.help()                   Show this help
  log.help("sections")         Help about sections
  log.help("live")             Help about live mode
  log.help("api")              Complete API list

More info: https://github.com/pessoa736/loglua
]]

help.en.sections = [[
╔══════════════════════════════════════════════════════════════╗
║                    Section System                            ║
╚══════════════════════════════════════════════════════════════╝

Sections allow organizing logs by category (network, database, etc).

🔹 METHOD 1: log.section()
   log.add(log.section("network"), "connecting...")
   log.error(log.section("database"), "query failed")

🔹 METHOD 2: log.inSection()
   local net = log.inSection("network")
   net("message 1")
   net("message 2")
   net.error("failed!")

🔹 METHOD 3: Default section
   log.setDefaultSection("game")
   log("player spawned")  -- goes to "game" section

🔹 FILTERING
   log.show("network")           -- only network
   log.show({"network", "db"})   -- network and db
   log.save("./", "net.log", "network")

🔹 GROUPING
   Consecutive messages from same section group automatically:
   [1-3][network] instead of [1][network], [2][network], [3][network]
]]

help.en.live = [[
╔══════════════════════════════════════════════════════════════╗
║                      Live Mode                               ║
╚══════════════════════════════════════════════════════════════╝

Live mode allows monitoring logs in real-time, displaying only
new messages since the last log.show() call.

🔹 ACTIVATING LIVE MODE
   log.live()                  -- activate live mode
   
🔹 DEACTIVATING
   log.unlive()                -- back to normal mode
   
🔹 CHECKING STATE
   if log.isLive() then
       print("Live mode active!")
   end

🔹 USAGE EXAMPLE
   log.live()                  -- activate live mode
   
   while running do
       log("event happened")
       log.show()              -- shows only new logs
       sleep(1)
   end
   
   log.unlive()                -- deactivate

🔹 BEHAVIOR
   - Live mode: log.show() displays only new messages
   - Normal mode: log.show() displays all messages with header
   - Filters work in both modes
]]

help.en.api = [[
╔══════════════════════════════════════════════════════════════╗
║                      Complete API                            ║
╚══════════════════════════════════════════════════════════════╝

FUNCTION                        DESCRIPTION
─────────────────────────────────────────────────────────────────
log(...)                        Shortcut for log.add(...)
log.add(...)                    Add log message
log.debug(...)                  Add debug message
log.error(...)                  Add error message

log.section(name)               Create section tag
log.inSection(name)             Create logger for specific section
log.setDefaultSection(name)     Set default section
log.getDefaultSection()         Get current default section
log.getSections()               List all used sections

log.show([filter])              Display logs (optional filter)
log.save([dir], [name], [flt])  Save logs to file

log.live()                      Activate live mode (real-time)
log.unlive()                    Deactivate live mode
log.isLive()                    Check if live mode is active

log.enableColors()              Enable ANSI colors
log.disableColors()             Disable colors
log.hasColors()                 Check if colors are enabled

log.activateDebugMode()         Activate debug mode
log.deactivateDebugMode()       Deactivate debug mode
log.checkDebugMode()            Check debug mode state
log.clear()                     Clear logs and counters

log.setLanguage(lang)           Set language (pt/en/es)
log.help([topic])               Show help
─────────────────────────────────────────────────────────────────

HELP TOPICS
  log.help()            General help
  log.help("sections")  Section system
  log.help("live")      Live mode (real-time)
  log.help("api")       This list
]]

--============================================================================
-- TEXTOS EM ESPANHOL
--============================================================================

help.es = {}

help.es.text = [[
╔══════════════════════════════════════════════════════════════╗
║                      LogLua v1.5                             ║
║         Sistema de logging modular para Lua                  ║
╚══════════════════════════════════════════════════════════════╝

📝 LOGGING BÁSICO
  log("mensaje")               Agrega log (atajo)
  log.add("mensaje")           Agrega log
  log.debug("mensaje")         Agrega debug (requiere debugMode)
  log.error("mensaje")         Agrega error

🏷️ SECCIONES
  log.section("nombre")        Crea tag de sección
  log.inSection("nombre")      Crea logger vinculado a sección
  log.setDefaultSection("x")   Define sección por defecto
  log.getDefaultSection()      Retorna sección por defecto
  log.getSections()            Lista secciones usadas

📺 VISUALIZACIÓN
  log.show()                   Muestra todos los logs
  log.show("section")          Filtra por sección
  log.show({"a", "b"})         Filtra por múltiples secciones

🔴 MODO LIVE (Tiempo Real)
  log.live()                   Activa modo live
  log.unlive()                 Desactiva modo live
  log.isLive()                 Verifica si modo live está activo

💾 GUARDADO
  log.save()                   Guarda en "log.txt"
  log.save("./", "app.log")    Guarda en archivo específico

🎨 COLORES
  log.enableColors()           Habilita colores ANSI
  log.disableColors()          Deshabilita colores

⚙️ CONFIGURACIÓN
  log.activateDebugMode()      Activa modo debug
  log.deactivateDebugMode()    Desactiva modo debug
  log.clear()                  Limpia todos los logs

🌐 IDIOMA
  log.setLanguage("es")        Español
  log.setLanguage("en")        English
  log.setLanguage("pt")        Português

❓ AYUDA
  log.help()                   Muestra esta ayuda
  log.help("sections")         Ayuda sobre secciones
  log.help("live")             Ayuda sobre modo live
  log.help("api")              Lista completa de la API

Más info: https://github.com/pessoa736/loglua
]]

help.es.sections = [[
╔══════════════════════════════════════════════════════════════╗
║                  Sistema de Secciones                        ║
╚══════════════════════════════════════════════════════════════╝

Secciones permiten organizar logs por categoría (network, database, etc).

🔹 MÉTODO 1: log.section()
   log.add(log.section("network"), "conectando...")
   log.error(log.section("database"), "query falló")

🔹 MÉTODO 2: log.inSection()
   local net = log.inSection("network")
   net("mensaje 1")
   net("mensaje 2")
   net.error("falló!")

🔹 MÉTODO 3: Sección por defecto
   log.setDefaultSection("game")
   log("player spawned")  -- va a sección "game"

🔹 FILTRANDO
   log.show("network")           -- solo network
   log.show({"network", "db"})   -- network y db
   log.save("./", "net.log", "network")

🔹 AGRUPACIÓN
   Mensajes consecutivos de la misma sección se agrupan automáticamente:
   [1-3][network] en lugar de [1][network], [2][network], [3][network]
]]

help.es.live = [[
╔══════════════════════════════════════════════════════════════╗
║                      Modo Live                               ║
╚══════════════════════════════════════════════════════════════╝

El modo live permite monitorear logs en tiempo real, mostrando solo
los nuevos mensajes desde la última llamada de log.show().

🔹 ACTIVANDO EL MODO LIVE
   log.live()                  -- activa el modo live
   
🔹 DESACTIVANDO
   log.unlive()                -- vuelve al modo normal
   
🔹 VERIFICANDO ESTADO
   if log.isLive() then
       print("Modo live activo!")
   end

🔹 EJEMPLO DE USO
   log.live()                  -- activa modo live
   
   while running do
       log("evento ocurrió")
       log.show()              -- muestra solo los nuevos logs
       sleep(1)
   end
   
   log.unlive()                -- desactiva

🔹 COMPORTAMIENTO
   - Modo live: log.show() muestra solo mensajes nuevos
   - Modo normal: log.show() muestra todos los mensajes con header
   - Filtros funcionan en ambos modos
]]

help.es.api = [[
╔══════════════════════════════════════════════════════════════╗
║                      API Completa                            ║
╚══════════════════════════════════════════════════════════════╝

FUNCIÓN                         DESCRIPCIÓN
─────────────────────────────────────────────────────────────────
log(...)                        Atajo para log.add(...)
log.add(...)                    Agrega mensaje de log
log.debug(...)                  Agrega mensaje de debug
log.error(...)                  Agrega mensaje de error

log.section(name)               Crea tag de sección
log.inSection(name)             Crea logger para sección específica
log.setDefaultSection(name)     Define sección por defecto
log.getDefaultSection()         Retorna sección por defecto actual
log.getSections()               Lista todas las secciones usadas

log.show([filter])              Muestra logs (filtro opcional)
log.save([dir], [name], [flt])  Guarda logs en archivo

log.live()                      Activa modo live (tiempo real)
log.unlive()                    Desactiva modo live
log.isLive()                    Verifica si modo live está activo

log.enableColors()              Habilita colores ANSI
log.disableColors()             Deshabilita colores
log.hasColors()                 Verifica si colores están activos

log.activateDebugMode()         Activa modo debug
log.deactivateDebugMode()       Desactiva modo debug
log.checkDebugMode()            Verifica estado del debug mode
log.clear()                     Limpia logs y contadores

log.setLanguage(lang)           Define idioma (pt/en/es)
log.help([topic])               Muestra ayuda
─────────────────────────────────────────────────────────────────

TÓPICOS DE AYUDA
  log.help()            Ayuda general
  log.help("sections")  Sistema de secciones
  log.help("live")      Modo live (tiempo real)
  log.help("api")       Esta lista
]]

--============================================================================
-- FUNÇÕES
--============================================================================

--- Define o idioma da ajuda
-- @function setLanguage
-- @tparam string lang Código do idioma ("pt", "en", "es")
function help.setLanguage(lang)
    if lang == "pt" or lang == "en" or lang == "es" then
        help.lang = lang
    end
end

--- Retorna o idioma atual
-- @function getLanguage
-- @treturn string Código do idioma atual
function help.getLanguage()
    return help.lang
end

--- Exibe ajuda
-- @function show
-- @tparam[opt] string topic Tópico de ajuda ("sections", "live", "api")
function help.show(topic)
    local texts = help[help.lang] or help.pt
    
    if topic == "sections" or topic == "seções" or topic == "secciones" or topic == "section" then
        print(texts.sections)
    elseif topic == "live" or topic == "ao-vivo" or topic == "realtime" or topic == "tiempo-real" then
        print(texts.live)
    elseif topic == "api" then
        print(texts.api)
    else
        print(texts.text)
    end
end

return help
