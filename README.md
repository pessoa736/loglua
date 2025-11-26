# LogLua

Sistema de logging modular e minimalista para Lua: colete mensagens em memória, organize por seções/categorias, agrupe mensagens consecutivas automaticamente, exiba no console e salve em arquivos com cabeçalho timestamped.

## ✨ Características

- 📝 **Logging simples** - Adicione mensagens com múltiplos valores
- 🏷️ **Sistema de seções** - Organize logs por categorias
- 📦 **Agrupamento automático** - Mensagens consecutivas da mesma seção são agrupadas `[1-3][section]`
- 🔍 **Filtros** - Exiba/salve apenas seções específicas
- 🐛 **Modo debug** - Mensagens de debug condicionais
- ❌ **Rastreamento de erros** - Contador automático de erros
- 📁 **Salvamento em arquivo** - Append com timestamps
- 🧩 **Arquitetura modular** - Código bem organizado

## 📦 Instalação

### Via LuaRocks

```bash
luarocks make rockspecs/loglua-1.2-1.rockspec
```

### Manualmente

```lua
package.path = "loglua/?.lua;" .. package.path
local log = require("loglua")
```

## 🚀 Início Rápido

```lua
local log = require("loglua")

-- Log simples (aceita múltiplos valores)
log("Iniciando aplicação", "v1.0")
log.add("Usuário:", "davi")

-- Mensagem de debug (só aparece se debug mode ativo)
log.activateDebugMode()
log.debug("Variável x =", 42)

-- Registrar erro (incrementa contador interno)
log.error("Falha ao carregar recurso")

-- Exibir tudo no console
log.show()

-- Salvar em arquivo
log.save("./logs/", "app.log")
```

Saída exemplo (mensagens consecutivas da mesma seção são agrupadas):

```text
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--  Tue Nov 25 14:30:00 2025  --
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

[1-2][general]
 Iniciando aplicação v1.0
 Usuário: davi

[3][general]__
 Variável x = 42

[4][general]
////--error: Falha ao carregar recurso

Total prints:  4
Total erros:  1
Seções:  general
```

## 📦 Agrupamento Automático

Mensagens consecutivas da mesma seção são automaticamente agrupadas para melhor legibilidade:

```lua
local net = log.inSection("network")
net("Conectando...")
net("Handshake OK")
net("Autenticado")

log.add(log.section("database"), "Query executada")

net("Enviando dados")
net("Resposta recebida")
```

Saída:

```text
[1-3][network]
 Conectando...
 Handshake OK
 Autenticado

[4][database]
 Query executada

[5-6][network]
 Enviando dados
 Resposta recebida
```

## 🏷️ Sistema de Seções

Organize seus logs por categorias para facilitar a filtragem:

### Método 1: Usando `log.section()`

```lua
log.add(log.section("network"), "Conexão estabelecida")
log.error(log.section("database"), "Query falhou")
log.debug(log.section("parser"), "Token encontrado:", token)
```

### Método 2: Usando `log.inSection()`

Cria um objeto vinculado a uma seção específica:

```lua
local netLog = log.inSection("network")
netLog.add("Conectando ao servidor...")
netLog.add("Resposta recebida")
netLog.error("Timeout!")
netLog("Atalho para add")  -- pode chamar diretamente
```

### Método 3: Definindo seção padrão

```lua
log.setDefaultSection("game")
log.add("Player spawned")  -- vai para seção "game"
log.add("Score: 100")      -- vai para seção "game"
```

### Filtrando por seções

```lua
-- Mostrar apenas uma seção
log.show("network")

-- Mostrar múltiplas seções
log.show({"network", "database"})

-- Salvar com filtro
log.save("./", "network.log", "network")
log.save("./", "errors.log", {"network", "database"})

-- Listar seções disponíveis
print(table.concat(log.getSections(), ", "))
```

## 📖 API Completa

### Logging Básico

| Função | Descrição |
|--------|-----------|
| `log(...)` | Atalho para `log.add(...)` |
| `log.add(...)` | Adiciona mensagem de log |
| `log.debug(...)` | Adiciona mensagem de debug (requer `debugMode`) |
| `log.error(...)` | Adiciona mensagem de erro (incrementa contador) |

### Seções

| Função | Descrição |
|--------|-----------|
| `log.section(name)` | Cria tag de seção para usar em add/debug/error |
| `log.inSection(name)` | Retorna objeto com add/debug/error pré-configurados |
| `log.setDefaultSection(name)` | Define seção padrão para novas mensagens |
| `log.getDefaultSection()` | Retorna nome da seção padrão atual |
| `log.getSections()` | Retorna lista de todas as seções utilizadas |

### Exibição e Salvamento

| Função | Descrição |
|--------|-----------|
| `log.show([filter])` | Exibe logs no console (filtro opcional) |
| `log.save([dir], [name], [filter])` | Salva logs em arquivo (filtro opcional) |

### Configuração

| Função | Descrição |
|--------|-----------|
| `log.activateDebugMode()` | Ativa modo debug |
| `log.deactivateDebugMode()` | Desativa modo debug |
| `log.checkDebugMode()` | Verifica se debug mode está ativo |
| `log.clear()` | Limpa todas as mensagens e reseta contadores |

## 🏗️ Estrutura do Projeto

```text
loglua/
├── init.lua         # Módulo principal (API pública)
├── config.lua       # Configuração e estado (mensagens, debug, contadores)
├── formatter.lua    # Formatação de mensagens e cabeçalhos
└── file_handler.lua # Operações de arquivo (I/O)
```

### Arquitetura

- **`init.lua`**: API pública, integra todos os módulos
- **`config.lua`**: Gerencia estado interno (mensagens, seções, contadores)
- **`formatter.lua`**: Formatação de texto (cabeçalhos, mensagens, separadores)
- **`file_handler.lua`**: Operações de I/O de arquivo

## 📝 Exemplos Avançados

### Logger para múltiplos sistemas

```lua
local log = require("loglua")

-- Criar loggers específicos
local networkLog = log.inSection("network")
local dbLog = log.inSection("database")
local uiLog = log.inSection("ui")

-- Usar em diferentes partes do código
networkLog("Conectando...")
dbLog("Query executada")
uiLog("Tela carregada")

-- Salvar cada seção em arquivo separado
log.save("./logs/", "network.log", "network")
log.save("./logs/", "database.log", "database")
log.save("./logs/", "ui.log", "ui")
```

### Debug condicional

```lua
local log = require("loglua")

local DEBUG = true
if DEBUG then
    log.activateDebugMode()
end

log.debug("Esta mensagem só aparece se DEBUG=true")
```

### Limpar e reiniciar

```lua
local log = require("loglua")

log("Mensagem 1")
log("Mensagem 2")
log.show()

log.clear()  -- Limpa tudo

log("Nova sessão")
log.show()
```

## 📋 Notas

- Mensagens permanecem em memória até serem limpas com `clear()`
- Chamar `save` repetidamente faz append no arquivo (com novo timestamp)
- Mensagens de debug só aparecem se `debugMode` estiver ativo
- Seções são registradas automaticamente ao adicionar mensagens

## 🔧 Compatibilidade

- Lua >= 5.4

## 📜 Licença

MIT — veja `LICENSE`.
