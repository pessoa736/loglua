# loglua (pt-BR)

Um helper de logging minimalista em Lua para acumular mensagens em memória, exibi-las no console e salvá-las em arquivo com um cabeçalho de data/hora.

## Instalação

Instale localmente via LuaRocks usando o rockspec incluído no repositório:

```bash
luarocks make rockspecs/loglua-1.0-3.rockspec
```

Depois, importe o módulo no seu código:

```lua
local log = require("loglua")
```

Durante o desenvolvimento (sem instalar), carregue diretamente a pasta do projeto ajustando o `package.path`:

```lua
package.path = "loglua/?.lua;" .. package.path
local log = require("loglua")
```

## Uso básico

```lua
local log = require("loglua")

-- Adiciona mensagens (aceita múltiplos valores)
log("Iniciando processamento", 123)
log.add("Usuário:", "davi")

-- Mensagem de debug (só aparece/salva se log.debugMode for true)
log.debug("variável x=", 42)

-- Registra um erro (incrementa contador interno)
log.error("falha ao carregar recurso")

-- Exibe tudo e os totais
log.show()

-- Salva em arquivo. Use: log.save(dir, name)
--   - dir: diretório (pode ser string vazia para diretório atual)
--   - name: nome do arquivo (padrão: "log.txt")
-- Exemplos: log.save("/tmp/", "meu_log.txt") ou log.save("", "meu_log.txt")
log.save("", "meu_log.txt")
```

Saída típica no console ao chamar `show()`:

```
-= - = - = - = - = - = - = - = - = - = -
--	2025-10-26 12:34:56	--
-= - = - = - = - = - = - = - = - = - = -

[1] Iniciando processamento 123
[2] Usuário: davi

Total prints: 3
Total erros: 1
```

## API

- `log(...)` / `log.add(...)`: adiciona uma nova mensagem. Aceita múltiplos valores; cada valor é convertido para string e concatenado.
- `log.debug(...)`: adiciona uma mensagem de debug. Exibida/salva apenas quando `log.debugMode = true`.
- `log.error(...)`: adiciona uma mensagem do tipo `error` e incrementa `log._NErrors`.
- `log.show()`: imprime um cabeçalho com data/hora e as mensagens acumuladas.
- `log.save(dir, name)`: grava as mensagens em arquivo (append) com um cabeçalho de bloco (timestamp). Passe `dir` (pode ser `""`) e `name` (padrão: `"log.txt"`).

Observações:
- As mensagens ficam em memória até você exibir/salvar. Repetir `save` escreve novamente o mesmo bloco (com novo cabeçalho).
- Entradas do tipo `error` são contabilizadas; por padrão, apenas mensagens `log` são exibidas/salvas, e `debug` apenas quando `log.debugMode = true`.

## Configuração

- `log.debugMode` (boolean): quando `true`, mensagens de `log.debug(...)` serão exibidas e salvas. Por padrão fica `false` até você definir `log.debugMode = true`.

## Compatibilidade

- Lua >= 5.4 

## Desenvolvimento

- Arquivo principal: `loglua/init.lua`.
- Teste rápido durante o desenvolvimento:

```bash
lua -e 'package.path="loglua/?.lua;"..package.path; local log=require("loglua"); log("hello"); log.show()'
```

- Há um exemplo simples em `loglua/test/init.lua`; ajuste `package.path` se necessário.

## Licença

MIT — veja `LICENSE`.
