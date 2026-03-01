---@meta loglua
---@module "loglua"
---@author pessoa736
---@license MIT
---
---### LogLua - Modular logging system for Lua
---A simple and flexible logging system that allows:
--- - Adding log, debug and error messages
--- - Organizing logs by sections/categories
--- - Filtering logs when showing or saving
--- - Saving logs to files---
--- 
---***usage example:*** </br>
---```lua
---local log = require("loglua")
--- -- Simple log
---     log("Simple message")
---     log.add("Another message")
---     
--- -- Log with section
---     log.add(log.section("network"), "Connection established")
--- 
--- -- Using inSection for multiple logs
---     local netLog = log.inSection("network")
---     
---     netLog.add("Sending data")
---     netLog.error("Timeout!")
--- 
--- -- Show logs
---     log.show()              -- all
---     log.show("network")     -- only "network" section
---     log.show({"network", "database"})  -- multiple sections
--- 
--- -- Save logs
---     log.save("./logs/", "app.log")
---     log.save("./logs/", "network.log", "network")
--- 
--- -- Help
---     log.help()              -- general help
---     log.help("sections")    -- help about sections
---     log.help("api")         -- API list
---```
---@class logluaLib
---@overload fun(...: any)
local log = {}

log.__index = log

log.__call = function () end

---@type function
---@param self? logluaLib
---
---***Activate debugMode*** (will showing and saving de debug message) 
log.activateDebugMode = function(self) end



---@type function
---@param self? logluaLib
---***deactivate the DebugMode*** (debugs message will not showing/saved)
log.deactivateDebugMode = function (self) end



---@type function
---@param self? logluaLib
---@return boolean true if debugmode is on
--- ***Check if the debugMode is on***
---
---Example: </br> 
---```lua
--- if log.checkDebugMode() then 
---     log("Debug ativo") 
--- end
--- ```
log.checkDebugMode = function (self) end



---@param Handler function
---
---***What is it for?***
---
--- Set a Handler function for rendering Header Log
--- </br>
--- </br>
---
---***Example:*** </br> 
---
---```lua
--- log.setHandlerHeader(function()
---     return "(-/", 9
--- end)
---```
---
---***This prints to the terminal:***
---
---```sh
--- (-/(-/(-/(-/(-/(-/(-/(-/(-/(-/
--- title
--- (-/(-/(-/(-/(-/(-/(-/(-/(-/(-/
---```
log.setHandlerHeader = function (Handler)end



---@type function
---
---***Enable ANSI colors*** </br>
---
log.enableColors = function ()end



---@type function
---@param self? logluaLib
---
---***disable ANSI colors*** </br>
---
function log.disableColors(self) end



---@type function 
---@return boolean true if colors are enabled
---
---***Check if ANSI colors are enable*** </br>
--- 
function log.hasColors() end


---@type function
---
---***clear message and reset counts***
log.clear = function () end



--- @type function setDefaultSection
--- @param section string Name of the default section
--- @return logluaLib SectionLogSystem 
--- 
--- ***Define the default section for new messages***
--- 
--- example:
--- ```lua
--- log.setDefaultSection("game") --- set "game" as default section   
--- ``` 
log.setDefaultSection = function (section) end


--- @type function getDefaultSection
--- @return string DefaultSectionName
--- 
--- ***Return the current default section name***
--- 
---example:
---```lua
---local name = log.getDefaultSection() --> "general"
--- 
---log.setDefaultSection("new default section")
---
---local newName = log.getDefaultSection() --> "new default section"
---```
log.getDefaultSection = function () end



--- @type function getSections
--- @return string[] SectionsNamesList
--- ***Return a list of all used section names***
--- 
--- example:
---```lua
--- log.add(log.section("section1"), "message1")
--- 
--- local section2 = log.inSection 'section2'
--- section2("message2")
---
--- local sections = log.getSections() --> { "section1", "section2" }
---```
log.getSections =function () end



--- @type function live
--- 
--- ***Activate live mode***
--- In live mode, `log.show()` displays only the new messages since the last call.
---
--- example:
---```lua
--- log.live()     -- activate live mode
--- log("msg1")
--- log.show()     -- shows only msg1
--- log("msg2")
--- log.show()     -- shows only msg2
---```
log.live = function() end




--- @type function unlive
--- 
--- ***Deactivate live mode***
---
--- example:
---```lua
--- log.unlive()  -- return to normal mode
---```
log.unlive = function() end




--- @type function isLive
--- @return boolean true if live mode is active
--- ***Check if live mode is active***
log.isLive = function() end




--- @type function show
--- @param filter? string|table Section name or table of sections to filter
--- ***Display logs in the console with an optional section filter***</br>
--- Consecutive messages from the same section are grouped. </br>
--- In live mode, it displays only new messages since the last call.
---
--- example:
---```lua
--- log.show()                        -- show all (or new in live mode)
--- log.show("network")               -- filter by "network" section
--- log.show({"network", "database"}) -- filter by multiple sections
---```
log.show = function(filter) end




--- @type function save
--- @param logDirFile? string Directory to save the file (default: "")
--- @param name? string Name of the file (default: "log.txt")
--- @param filter? string|table Section name or table of sections to filter
--- 
--- ***Save logs to a file with an optional section filter*** </br>
--- Consecutive messages from the same section are grouped. </br>
---
--- example:
---```lua
--- log.save()                                    -- saves to "log.txt"
--- log.save("./logs/", "app.log")               -- saves to "./logs/app.log"
--- log.save("./", "net.log", "network")         -- saves only "network" section
--- log.save("./", "multi.log", {"net", "db"})   -- saves multiple sections
---```
log.save = function(logDirFile, name, filter) end




--- @type function add
--- @param ... any Values to be logged (will be converted to string)
--- ***Add a standard log message*** </br>
--- You can use a table with `_section` as the first argument to define a section. </br>
---
--- example:
---```lua
--- log.add("Simple message")
--- log.add("Value:", 42, "result")
--- log.add(log.section("network"), "Connection OK")
--- log.add({_section = "localstorage"}, "20% used")
--- local section = log.inSection("section")
--- section.add("message")
---```
log.add = function(...) end




--- @type function debug
--- @param ... any Values to be logged (will be converted to string)
--- ***Add a debug message (only appears if debugMode is active)***</br>
--- You can use a table with `_section` as the first argument to define a section.</br>
---
--- example:
---```lua
--- if __DEBUG then log.activateDebugMode() end
--- log.debug("Variable x =", x)
--- log.debug(log.section("parser"), "Token found:", token)
---```
log.debug = function(...) end




--- @type function error
--- @param ... any Values to be logged (will be converted to string)</br>
--- ***Add an error message (increments error counter)***</br>
--- You can use a table with `_section` as the first argument to define a section.</br>
---
--- example:
---```lua
--- log.error("Connection failed")
--- log.error(log.section("database"), "Invalid query:", query)
---```
log.error = function(...) end




--- @type function section
--- @param sectionName string Name of the section
--- @return table Table with _section defined
--- ***Create a section tag to use in add/debug/error*** </br>
---
--- example:
---```lua
--- local tag = log.section("network")
--- log.add(tag, "Message in network section")
---```
log.section = function(sectionName) end





--- @type function inSection
--- @param sectionName string Name of the section
--- @return table Object with `add`, `debug` and `error` methods pre-configured
--- ***Create a log object bound to a specific section*** </br>
---
--- example:
---```lua
--- local netLog = log.inSection("network")
--- netLog.add("Connecting...")       -- goes to "network" section
--- netLog.error("Failed!")            -- goes to "network" section
--- netLog("Shortcut for add")         -- can be called directly
---```
log.inSection = function(sectionName) end





--- @type function setLanguage
--- @deprecated Help is now English-only
--- @param lang string Any language code
log.setLanguage = function(lang) end




--- @type function getLanguage
--- @deprecated Help is now English-only
--- @return string Returns "en"
log.getLanguage = function() end




--- @type function help
--- @param topic? string Help topic ("sections", "live", "api")
--- ***Show help about using LogLua***
---
--- example:
---```lua
--- log.help()            -- general help
--- log.help("sections")  -- help about sections
--- log.help("api")       -- complete API list
---```
log.help = function(topic) end




return log