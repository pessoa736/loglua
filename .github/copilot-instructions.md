# LogLua - Copilot Instructions

## Sobre o Projeto

LogLua é um sistema de logging modular e minimalista para Lua com:
- Logging simples com múltiplos valores
- Sistema de seções/categorias
- Agrupamento automático de mensagens consecutivas
- Modo live para monitoramento em tempo real
- Cores ANSI (vermelho para errors, amarelo para debug)
- Filtros por seção
- Salvamento em arquivo com timestamps

## Estrutura do Projeto

```
loglua/
├── init.lua           # API pública principal
├── config.lua         # Estado interno (mensagens, seções, contadores, modo live)
├── formatter.lua      # Formatação de mensagens, cores ANSI, agrupamento
├── file_handler.lua   # Operações de arquivo (I/O)
├── help.lua           # Sistema de ajuda integrado (log.help())
├── constants/
│   └── ANSIColors.lua # Constantes de cores ANSI
└── utils/
    └── formatIndex.lua # Utilitário de formatação de índice

library/               # Arquivos de definição de tipos (LuaLS / lua-language-server)
├── loglua.lua         # Definições da API pública (logluaLib)
├── config.lua         # Definições do módulo config (loglua.configLib)
├── formatter.lua      # Definições do módulo formatter
└── help.lua           # Definições do módulo help

spec/
└── loglua_spec.lua    # Testes automatizados (busted)

rockspecs/             # Rockspecs para publicação no LuaRocks
```

## Importações

Os módulos usam importações diretas com caminho completo:
```lua
local config = require("loglua.config")
```
**NÃO** usar resolução dinâmica de path com `(...)`.

## Arquivos de Definição (library/)

- Usados pelo lua-language-server para autocomplete e type-checking
- Seguem o padrão `---@meta` e `---@class`
- Cada função deve ter: `---@type function`, `---@param`, `---@return` e um bloco `example:` com código Lua
- Não colocar anotações `---@type` no código fonte (init.lua, config.lua, etc) — as definições ficam apenas em `library/`

## Ao Implementar uma Nova Feature

### Antes
- Verificar as versões atuais (rockspec, help.lua banner)
- Ler o código existente para entender o padrão
- Verificar se a feature não conflita com funcionalidades existentes

### Durante
- Manter a arquitetura modular (config para estado, formatter para formatação, etc)
- Adicionar funções públicas no init.lua, lógica interna nos outros módulos
- Atualizar os arquivos de definição em `library/` com tipos e exemplos

### Depois
- Rodar os testes: `busted spec/loglua_spec.lua`
- Adicionar novos testes para a feature em spec/loglua_spec.lua
- Atualizar documentação:
  - help.lua (adicionar tópico se necessário)
  - library/ (definições de tipos e exemplos)
  - README.md (inglês)
  - README.pt-BR.md (português)
  - README.es.md (espanhol)
- Se tudo passar, fazer upload

## Upload / Release

### Commits
- Separar commits por tipo de mudança (feat, docs, test, release)
- Commits informais, num parágrafo só, detalhando o que foi feito
- Exemplo: `feat: modo live pra monitorar logs em tempo real - agora dá pra usar log.live() pra ativar...`

### Processo de Release
1. Criar novo rockspec em `rockspecs/loglua-X.Y-Z.rockspec`
2. Fazer commits separados:
   - `feat:` para código novo
   - `docs:` para documentação
   - `test:` para testes
   - `release:` para rockspec
3. Criar tag: `git tag vX.Y`
4. Push: `git push origin master --tags`
5. Upload LuaRocks: `luarocks upload rockspecs/loglua-X.Y-Z.rockspec --api-key=<KEY>`

## Versionamento

Padrão: `X.Y-Z` (ex: 1.4-1)

| Mudança | Ação |
|---------|------|
| Feature adicionada | `X.(Y+1)-1` (ex: 1.4 → 1.5) |
| Bug corrigido | `X.Y-(Z+1)` (ex: 1.4-1 → 1.4-2) |
| Breaking change | `(X+1).0-1` (ex: 1.4 → 2.0) |

## API Atual

### Logging
- `log(...)` / `log.add(...)` - adiciona mensagem
- `log.debug(...)` - mensagem de debug (requer debugMode, retorna imediatamente se inativo)
- `log.error(...)` - mensagem de erro

### Seções
- `log.section(name)` - cria tag de seção
- `log.inSection(name)` - cria logger vinculado a seção
- `log.setDefaultSection(name)` / `log.getDefaultSection()`
- `log.getSections()` - lista seções usadas

### Exibição
- `log.show([filter])` - exibe logs (filtro opcional)
- `log.save([dir], [name], [filter])` - salva em arquivo

### Modo Live
- `log.live()` - ativa modo live
- `log.unlive()` - desativa modo live
- `log.isLive()` - verifica estado

### Cores
- `log.enableColors()` - habilita cores ANSI
- `log.disableColors()` - desabilita cores
- `log.hasColors()` - verifica estado

### Configuração
- `log.activateDebugMode()` / `log.deactivateDebugMode()`
- `log.checkDebugMode()`
- `log.setHandlerHeader(func)` - customiza header do log
- `log.clear()` - limpa tudo

### Ajuda
- `log.help()` - ajuda geral
- `log.help("sections")` - sistema de seções
- `log.help("live")` - modo live
- `log.help("api")` - API completa

## Compatibilidade

- Lua >= 5.4
- LuaRocks para distribuição

## Testes

Rodar testes:
```bash
busted spec/loglua_spec.lua
```

Os testes (busted) verificam:
- Logging básico
- Sistema de seções
- log.inSection()
- Seção padrão
- Modo debug (começa desativado, não adiciona mensagem quando inativo)
- Contador de erros
- Função clear()
- Chamada direta log()
- Modo live (merge de grupos)
- Salvamento em arquivo
