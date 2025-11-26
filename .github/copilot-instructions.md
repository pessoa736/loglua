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
├── init.lua         # API pública principal
├── config.lua       # Estado interno (mensagens, seções, contadores, modo live)
├── formatter.lua    # Formatação de mensagens, cores ANSI, agrupamento
├── file_handler.lua # Operações de arquivo (I/O)
├── help.lua         # Sistema de ajuda integrado (log.help())
└── test.lua         # Testes automatizados
```

## Ao Implementar uma Nova Feature

### Antes
- Verificar as versões atuais (rockspec, help.lua banner)
- Ler o código existente para entender o padrão
- Verificar se a feature não conflita com funcionalidades existentes

### Durante
- Seguir o padrão de documentação LDoc nos comentários
- Manter a arquitetura modular (config para estado, formatter para formatação, etc)
- Adicionar funções públicas no init.lua, lógica interna nos outros módulos

### Depois
- Rodar os testes: `cd loglua/loglua && lua test.lua`
- Adicionar novos testes para a feature em test.lua
- Atualizar documentação:
  - help.lua (adicionar tópico se necessário)
  - README.md (inglês)
  - README.pt-BR.md (português)
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
- `log.debug(...)` - mensagem de debug (requer debugMode)
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
cd loglua/loglua && lua test.lua
```

Os testes usam cores ANSI e verificam:
- Logging básico
- Sistema de seções
- log.inSection()
- Seção padrão
- Modo debug
- Contador de erros
- Função clear()
- Chamada direta log()
- Modo live
- Salvamento em arquivo
