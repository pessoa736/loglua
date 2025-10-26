# loglua

Um helper de logging minimalista em Lua para acumular mensagens em memória, exibi-las no console e salvá-las em arquivo com um cabeçalho de data/hora.

## Instalação

Você pode instalar localmente via LuaRocks a partir do rockspec incluso no repositório:

```bash
luarocks make rockspecs/loglua-1.0-1.rockspec
```

Após instalar, importe o módulo com:

```lua
local log = require("loglua")
```

Durante o desenvolvimento (sem instalar), carregue diretamente a pasta do projeto ajustando `package.path`:

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

-- Mensagem de debug (só aparece se log.debugMode for true)
log.debug("variável x=", 42)

-- Registra um erro (incrementa contador interno)
log.error("falha ao carregar recurso")

-- Exibe tudo e o total de mensagens/erros
log.show()

-- Salva em arquivo. Use: log.save(dir, name)
--   - dir: diretório (pode ser string vazia para diretório atual).
--   - name: nome do arquivo (padrão: "log.txt").
-- Ex.: log.save("/tmp/", "meu_log.txt") ou log.save("", "meu_log.txt")
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
- `log.debug(...)`: adiciona uma mensagem de debug (gravada/exibida apenas se `log.debugMode = true`).
- `log.error(...)`: adiciona uma mensagem do tipo `error` e incrementa `log._NErrors`.
- `log.show()`: imprime um cabeçalho com data/hora e as mensagens acumuladas.
- `log.save(dir, name)`: escreve as mensagens em arquivo no modo append. Passe `dir` como diretório (pode ser `""`) e `name` o nome do arquivo (padrão: `"log.txt"`).

Observações:
- As mensagens ficam em memória até você exibir/salvar. Repetir `save` escreverá novamente o mesmo bloco (com novo cabeçalho).
- Para salvar usando apenas um caminho completo, chame `log.save(dir, name)` com `dir` sendo o diretório (ou `""`) e `name` o nome do arquivo.

## Configurações úteis

- `log.debugMode` (boolean): quando `true`, mensagens de `log.debug(...)` serão exibidas e gravadas. Por padrão fica desligado até você definir `log.debugMode = true`.

## Compatibilidade

- Lua >= 5.1

## Desenvolvimento

- Código-fonte principal: `loglua/init.lua`.
- Exemplo simples de execução durante o desenvolvimento:

```bash
lua -e 'package.path="loglua/?.lua;"..package.path; local log=require("loglua"); log("hello"); log.show()'
```

- Há um `loglua/test/init.lua` de exemplo; ajuste o `package.path` conforme seu ambiente se necessário.

## Licença

MIT — veja o arquivo `LICENSE`.
