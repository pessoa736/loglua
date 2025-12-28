
local scriptDir = debug.getinfo(1, "S").source:match("@(.*/)") or "./"

package.path = scriptDir .. "../?.lua;" ..
               scriptDir .. "../?/init.lua;" ..
               scriptDir .. "?.lua;" ..
               package.path

local log = require("loglua")
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