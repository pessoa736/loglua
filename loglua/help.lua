--[[
    LogLua - Módulo de Ajuda
    
    Exibe informações sobre a API e como usar o sistema de logging.
    
    @module loglua.help
    @author pessoa736
    @license MIT
    @local
]]

local help = {}

--- Texto de ajuda principal
help.text = [[
╔══════════════════════════════════════════════════════════════╗
║                      LogLua v1.4                             ║
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

  Exemplos:
    log.add(log.section("network"), "conectando...")
    local net = log.inSection("network")
    net("mensagem")

📺 EXIBIÇÃO
  log.show()                   Mostra todos os logs
  log.show("section")          Filtra por seção
  log.show({"a", "b"})         Filtra por múltiplas seções

🔴 MODO LIVE (Tempo Real)
  log.live()                   Ativa modo live
  log.unlive()                 Desativa modo live
  log.isLive()                 Verifica se modo live está ativo

  No modo live, log.show() exibe apenas as novas mensagens
  desde a última chamada, ideal para monitoramento em tempo real.

💾 SALVAMENTO
  log.save()                   Salva em "log.txt"
  log.save("./", "app.log")    Salva em arquivo específico
  log.save("./", "x.log", "s") Salva com filtro de seção

⚙️ CONFIGURAÇÃO
  log.activateDebugMode()      Ativa modo debug
  log.deactivateDebugMode()    Desativa modo debug
  log.checkDebugMode()         Verifica se debug está ativo
  log.clear()                  Limpa todos os logs

❓ AJUDA
  log.help()                   Mostra esta ajuda
  log.help("sections")         Ajuda sobre seções
  log.help("live")             Ajuda sobre modo live
  log.help("api")              Lista completa da API

📦 Mensagens consecutivas da mesma seção são agrupadas: [1-3][section]

Mais info: https://github.com/pessoa736/loglua
]]

--- Texto de ajuda sobre seções
help.sections = [[
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

--- Texto de ajuda do modo live
help.live = [[
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
   
   -- loop de monitoramento
   while running do
       -- seu código que gera logs...
       log("evento aconteceu")
       
       log.show()              -- mostra só os novos logs
       sleep(1)
   end
   
   log.unlive()                -- desativa

🔹 COMPORTAMENTO
   - Modo live: log.show() exibe apenas mensagens novas
   - Modo normal: log.show() exibe todas as mensagens com header
   - Filtros funcionam em ambos os modos
   - log.clear() reseta o contador de mensagens vistas

🔹 CASOS DE USO
   - Monitoramento de servidor em tempo real
   - Debug de aplicações em execução
   - Streaming de logs para console
   - Integração com sistemas de alerta
]]

--- Texto de ajuda da API
help.api = [[
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

log.activateDebugMode()         Ativa modo debug
log.deactivateDebugMode()       Desativa modo debug
log.checkDebugMode()            Verifica estado do debug mode
log.clear()                     Limpa logs e contadores

log.help([topic])               Mostra ajuda
─────────────────────────────────────────────────────────────────

TÓPICOS DE AJUDA
  log.help()            Ajuda geral
  log.help("sections")  Sistema de seções
  log.help("live")      Modo live (tempo real)
  log.help("api")       Esta lista
]]

--- Exibe ajuda
-- @function show
-- @tparam[opt] string topic Tópico de ajuda ("sections", "live", "api")
function help.show(topic)
    if topic == "sections" or topic == "seções" or topic == "section" then
        print(help.sections)
    elseif topic == "live" or topic == "ao-vivo" or topic == "realtime" then
        print(help.live)
    elseif topic == "api" then
        print(help.api)
    else
        print(help.text)
    end
end

return help
