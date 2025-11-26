--[[
    LogLua - Módulo de Operações de Arquivo
    
    Gerencia todas as operações de I/O de arquivo:
    - Verificação de existência de arquivos
    - Abertura para escrita (novo ou append)
    - Escrita e fechamento de arquivos
    - Construção de caminhos
    
    @module loglua.file_handler
    @author pessoa736
    @license MIT
    @local
]]

--- Módulo de operações de arquivo
-- @table fileHandler
local fileHandler = {}

--============================================================================
-- VERIFICAÇÃO DE ARQUIVOS
--============================================================================

--- Verifica se um arquivo existe
-- @function exists
-- @tparam string filepath Caminho completo do arquivo
-- @treturn boolean true se o arquivo existe, false caso contrário
-- @usage
--   if fileHandler.exists("./log.txt") then
--       print("Arquivo existe!")
--   end
function fileHandler.exists(filepath)
    local file = io.open(filepath, "r")
    if file then
        file:close()
        return true
    end
    return false
end

--============================================================================
-- ABERTURA E ESCRITA
--============================================================================

--- Abre um arquivo para escrita
-- Se o arquivo já existe, abre em modo append (a+)
-- Se não existe, cria um novo arquivo (w+)
-- @function openForWrite
-- @tparam string filepath Caminho completo do arquivo
-- @treturn file Handle do arquivo aberto
-- @raise Erro se não conseguir abrir o arquivo
-- @usage
--   local file = fileHandler.openForWrite("./log.txt")
--   fileHandler.write(file, "Conteúdo")
--   fileHandler.close(file)
function fileHandler.openForWrite(filepath)
    local mode = fileHandler.exists(filepath) and "a+" or "w+"
    local file, err = io.open(filepath, mode)
    if not file then
        error("Erro ao abrir arquivo: " .. (err or "desconhecido"))
    end
    return file
end

--- Escreve conteúdo em um arquivo aberto
-- @function write
-- @tparam file file Handle do arquivo (retornado por openForWrite)
-- @tparam string content Conteúdo a ser escrito
-- @usage
--   fileHandler.write(file, "Linha de log\n")
function fileHandler.write(file, content)
    file:write(content)
end

--- Fecha um arquivo aberto
-- @function close
-- @tparam file file Handle do arquivo a ser fechado
-- @usage fileHandler.close(file)
function fileHandler.close(file)
    if file then
        file:close()
    end
end

--============================================================================
-- UTILITÁRIOS
--============================================================================

--- Constrói o caminho completo do arquivo
-- Concatena diretório e nome do arquivo
-- @function buildPath
-- @tparam[opt=""] string directory Diretório onde o arquivo será salvo
-- @tparam[opt="log.txt"] string filename Nome do arquivo
-- @treturn string Caminho completo do arquivo
-- @usage
--   fileHandler.buildPath()                    -- "log.txt"
--   fileHandler.buildPath("./logs/")           -- "./logs/log.txt"
--   fileHandler.buildPath("./logs/", "app.log") -- "./logs/app.log"
function fileHandler.buildPath(directory, filename)
    directory = directory or ""
    filename = filename or "log.txt"
    return directory .. filename
end

return fileHandler
