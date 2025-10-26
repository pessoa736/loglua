# loglua

Um helper de logging minimalista em Lua para acumular mensagens em memória, exibi-las no console e salvá-las em arquivo com um cabeçalho de data/hora.

## Instalação

Você pode usar o módulo de duas formas: instalando via LuaRocks (recomendado) ou carregando diretamente do diretório `src/` durante o desenvolvimento.

### Via LuaRocks (local a partir do repositório)

Instale a partir do rockspec incluso no repositório:

```bash
luarocks make rockspecs/loglua-1.0-1.rockspec
```

Após instalar, importe com:

```lua
local log = require("loglua")
```

### Usando diretamente do `src/` (sem instalar)

Adicione `src/` ao `package.path` e carregue o arquivo do módulo:

```lua
package.path = "src/?.lua;" .. package.path
local log = require("log")
```

## Uso básico

```lua
local log = require("loglua") -- ou, durante dev: require("log")

-- Adiciona mensagens (aceita múltiplos valores)
log("Iniciando processamento", 123)
log("Usuário:", "davi")

-- Exibe tudo e o total de mensagens
log.show()

-- Salva em arquivo (acrescenta no final e inclui um cabeçalho com data/hora)
log.save("meu_log.txt")
```

Saída típica no console ao chamar `show()`:

```
[ 0 ] Iniciando processamento 123
[ 1 ] Usuário: davi
Total messages: 2
```

## API

- `log(...)` (alias de `log.add(...)`): adiciona uma nova mensagem. Qualquer valor é convertido para string.
- `log.add(...)`: mesmo comportamento de `log(...)`.
- `log.show()`: imprime as mensagens acumuladas, na ordem, e o total ao fim.
- `log.save(path)`: abre (modo append) o arquivo `path` e escreve todas as mensagens, precedidas por um cabeçalho com `os.date()` na primeira linha do bloco.

Observações:
- As mensagens ficam em memória até você exibir/salvar. Repetir `save` escreverá novamente o mesmo bloco (com novo cabeçalho).
- O índice mostrado em cada mensagem é baseado no tamanho atual da lista quando a mensagem é adicionada.

## Compatibilidade

- Lua >= 5.1

## Desenvolvimento

- Código-fonte principal: `src/log.lua`.
- Exemplo simples de execução durante o desenvolvimento:

```bash
lua -e 'package.path="src/?.lua;"..package.path; local log=require("log"); log("hello"); log.show()'
```

- Há um `test/test.lua` de exemplo; ajuste o `package.path` conforme seu ambiente se necessário.

## Licença

MIT — veja o arquivo `LICENSE`.
