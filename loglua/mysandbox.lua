
local scriptDir = debug.getinfo(1, "S").source:match("@(.*/)") or "./"

package.path = scriptDir .. "../?.lua;" ..
               scriptDir .. "../?/init.lua;" ..
               scriptDir .. "?.lua;" ..
               package.path

local log = require("loglua")

log("a")
log("b")
