--============================================================================
-- FORMATAÇÃO DE ÍNDICE
--============================================================================
--- Formata o índice de um grupo de mensagens
return function (startIdx, endIdx)
    if startIdx == endIdx then
        return "[" .. startIdx .. "]"
    else
        return "[" .. startIdx .. "-" .. endIdx .. "]"
    end
end