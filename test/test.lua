
package.path = ";".. package.path .. "/src/?.lua;"

log = require("log")

soma = function(...)
    local args = {...}
    local res = 0
    for k, v in ipairs(args) do
        res = res + v
    end

    return res
end

n1 = 2
n2 = 5
log(n1, n2)

s = soma(n1, n2)
log(s)
