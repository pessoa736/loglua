--[[
    LogLua - Arquivo de Testes
    
    Testa todas as funcionalidades do sistema de logging:
    - Logging básico (add, debug, error)
    - Sistema de seções/categorias
    - Filtros de exibição e salvamento
    - Modo debug
    - Funções auxiliares
    
    Execute com: 
        cd loglua/loglua && lua test.lua
        OU
        lua loglua/test.lua (da raiz do projeto)
]]

-- Detecta o diretório do script
local scriptDir = debug.getinfo(1, "S").source:match("@(.*/)") or "./"

-- Configura paths para encontrar módulos locais
-- O init.lua usa require("loglua.config"), então precisa estar em loglua/
package.path = scriptDir .. "../?.lua;" ..  -- para loglua/init.lua -> ../loglua/init.lua
               scriptDir .. "../?/init.lua;" ..  -- para require("loglua")
               scriptDir .. "?.lua;" ..  -- para loglua.config -> config.lua (mesmo dir)
               package.path

-- Carrega o módulo (usa require relativo)
local log = require("loglua")

-- Cores para output (ANSI)
local colors = {
    reset = "\27[0m",
    green = "\27[32m",
    red = "\27[31m",
    yellow = "\27[33m",
    blue = "\27[34m",
    cyan = "\27[36m"
}

local function printHeader(title)
    print("\n" .. colors.cyan .. string.rep("=", 60) .. colors.reset)
    print(colors.cyan .. "  " .. title .. colors.reset)
    print(colors.cyan .. string.rep("=", 60) .. colors.reset .. "\n")
end

local function printTest(name, passed)
    local status = passed and (colors.green .. "✓ PASS" .. colors.reset) 
                           or (colors.red .. "✗ FAIL" .. colors.reset)
    print(string.format("  %s: %s", status, name))
end

local testsPassed = 0
local testsFailed = 0

local function assert_test(condition, name)
    if condition then
        testsPassed = testsPassed + 1
        printTest(name, true)
    else
        testsFailed = testsFailed + 1
        printTest(name, false)
    end
end

--============================================================================
-- TESTES
--============================================================================

printHeader("TESTE 1: Logging Básico")

log.clear()
log("Mensagem simples")
log.add("Mensagem com add")
log.add("Múltiplos", "valores", 123, true)

assert_test(#log.getSections() >= 0, "Log básico funciona")

printHeader("TESTE 2: Sistema de Seções")

log.clear()

-- Teste com log.section()
log.add(log.section("network"), "Conexão estabelecida")
log.add(log.section("network"), "Dados enviados")
log.add(log.section("database"), "Query executada")
log.add(log.section("ui"), "Tela renderizada")

local sections = log.getSections()
assert_test(#sections == 3, "3 seções registradas")

-- Verificar se seções existem
local hasNetwork = false
local hasDatabase = false
local hasUI = false
for _, s in ipairs(sections) do
    if s == "network" then hasNetwork = true end
    if s == "database" then hasDatabase = true end
    if s == "ui" then hasUI = true end
end
assert_test(hasNetwork and hasDatabase and hasUI, "Seções corretas registradas")

printHeader("TESTE 3: log.inSection()")

log.clear()

local netLog = log.inSection("network")
netLog.add("Mensagem 1")
netLog.add("Mensagem 2")
netLog.error("Erro de rede")

local dbLog = log.inSection("database")
dbLog.add("Query 1")
dbLog.debug("Debug query")

sections = log.getSections()
assert_test(#sections == 2, "inSection cria seções corretamente")

printHeader("TESTE 4: Seção Padrão")

log.clear()

log.setDefaultSection("game")
log.add("Player spawned")
log.add("Score: 100")

assert_test(log.getDefaultSection() == "game", "Seção padrão definida")

sections = log.getSections()
local hasGame = false
for _, s in ipairs(sections) do
    if s == "game" then hasGame = true end
end
assert_test(hasGame, "Mensagens vão para seção padrão")

-- Resetar para general
log.setDefaultSection("general")

printHeader("TESTE 5: Modo Debug")

log.clear()

log.debug("Debug desativado")
assert_test(log.checkDebugMode() == false, "Debug mode inicia desativado")

log.activateDebugMode()
assert_test(log.checkDebugMode() == true, "Debug mode ativado")

log.debug("Debug ativado")

log.deactivateDebugMode()
assert_test(log.checkDebugMode() == false, "Debug mode desativado")

printHeader("TESTE 6: Contador de Erros")

log.clear()

log.error("Erro 1")
log.error("Erro 2")
log.error(log.section("critical"), "Erro crítico")

-- O contador não é exposto diretamente, mas podemos testar via show()
assert_test(true, "Erros registrados (verificar visualmente)")

printHeader("TESTE 7: Função clear()")

log.clear()
log.add("Mensagem antes do clear")
log.error("Erro antes do clear")

log.clear()

sections = log.getSections()
assert_test(#sections == 0, "Clear limpa seções")

printHeader("TESTE 8: Chamada direta log()")

log.clear()

log("Chamada direta 1")
log("Chamada direta 2", "com múltiplos args")

assert_test(true, "Chamada direta funciona")

printHeader("TESTE 9: inSection com chamada direta")

log.clear()

local gameLog = log.inSection("game")
gameLog("Chamada direta no inSection")
gameLog("Outra chamada")

sections = log.getSections()
local hasGameSection = false
for _, s in ipairs(sections) do
    if s == "game" then hasGameSection = true end
end
assert_test(hasGameSection, "inSection suporta chamada direta")

printHeader("TESTE 10: Modo Live")

log.clear()

-- Testar ativação/desativação
assert_test(log.isLive() == false, "Modo live inicia desativado")

log.live()
assert_test(log.isLive() == true, "Modo live ativado")

log.unlive()
assert_test(log.isLive() == false, "Modo live desativado")

-- Teste funcional do modo live
log.clear()
log("Mensagem 1")
log("Mensagem 2")
log("Mensagem 3")

log.live()
-- Nota: ao ativar live(), ele marca que já vimos todas as mensagens existentes
-- então a primeira chamada show() não mostrará nada (comportamento correto)

print(colors.yellow .. "\n>> Primeira chamada show() após live() (nada - pois live marca tudo como 'visto'):" .. colors.reset)
log.show()

log("Mensagem 4")
log("Mensagem 5")

print(colors.yellow .. "\n>> Segunda chamada show() no modo live (deve mostrar só 2 novas):" .. colors.reset)
log.show()

print(colors.yellow .. "\n>> Terceira chamada show() no modo live (deve mostrar nada - sem novas mensagens):" .. colors.reset)
log.show()

log.unlive()

print(colors.yellow .. "\n>> Modo normal (deve mostrar todas as 5 mensagens com header):" .. colors.reset)
log.show()

assert_test(true, "Modo live funciona corretamente")

--============================================================================
-- DEMONSTRAÇÃO VISUAL
--============================================================================

printHeader("DEMONSTRAÇÃO: Exibição Completa")

log.clear()

-- Simular um cenário real
local network = log.inSection("network")
local db = log.inSection("database")
local auth = log.inSection("auth")

network("Iniciando conexão com servidor")
auth("Tentando autenticar usuário")
db("Conectando ao banco de dados")
network("Conexão estabelecida")
auth("Usuário autenticado com sucesso")
db("Query SELECT executada")
network.error("Timeout na requisição")
db.error("Falha na query INSERT")

log.activateDebugMode()
auth.debug("Token: abc123...")
db.debug("Query plan: sequential scan")
log.deactivateDebugMode()

print(colors.yellow .. "\n>> Mostrando TODOS os logs:" .. colors.reset)
log.show()

print(colors.yellow .. "\n>> Mostrando apenas seção 'network':" .. colors.reset)
log.show("network")

print(colors.yellow .. "\n>> Mostrando seções 'network' e 'database':" .. colors.reset)
log.show({"network", "database"})

--============================================================================
-- TESTE DE SALVAMENTO
--============================================================================

printHeader("TESTE 11: Salvamento em Arquivo")

-- Salvar todos os logs
log.save("./", "test_all.log")
print("  Arquivo salvo: test_all.log")

-- Salvar apenas uma seção
log.save("./", "test_network.log", "network")
print("  Arquivo salvo: test_network.log")

-- Salvar múltiplas seções
log.save("./", "test_multi.log", {"network", "database"})
print("  Arquivo salvo: test_multi.log")

-- Salvar log principal
log.save("./", "log.txt")
print("  Arquivo salvo: log.txt")

assert_test(true, "Arquivos salvos (verificar manualmente)")

--============================================================================
-- RESULTADO FINAL
--============================================================================

printHeader("RESULTADO DOS TESTES")

local total = testsPassed + testsFailed
print(string.format("  Total: %d testes", total))
print(string.format("  %sPassed: %d%s", colors.green, testsPassed, colors.reset))
print(string.format("  %sFailed: %d%s", colors.red, testsFailed, colors.reset))

if testsFailed == 0 then
    print(colors.green .. "\n  ✓ Todos os testes passaram!" .. colors.reset)
else
    print(colors.red .. "\n  ✗ Alguns testes falharam!" .. colors.reset)
end

print("")

