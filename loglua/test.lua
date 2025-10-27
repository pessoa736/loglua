
package.path = ";".. package.path .. ";./../?.lua"

--global 
log = require("init")

soma = function(...)
    local args = {...}
    local res = 0
    for k, v in ipairs(args) do
        res = res + v
    end

    return res
end

local n1 = 2
local n2 = 5
log(n1, n2)

local s = soma(n1, n2)
log(s)

log.debug("debug message")
log("a")

log.error("erro test")

log.show()
log.activateDebubMode()
log.show()

log.save("./")
