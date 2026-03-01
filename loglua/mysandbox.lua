
local log = require "loglua"
log.setHandlerHeader(
    function()
        return "_", 18, "test" 
    end
)

log.live()
log("a")
log("b")

log.unlive()

log.show()