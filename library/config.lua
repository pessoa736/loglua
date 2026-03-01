---@meta loglua.config
---@module "loglua.config"
---@author pessoa736
---@license MIT
---
---### LogLua - Configuration Module
---Internal module that manages the state of the logger:
--- - Storing messages
--- - Managing sections
--- - Debug mode state
--- - Live mode state
--- - Error counting
---
---***usage example:*** </br>
---```lua
---local config = require("loglua.config")
---
--- -- Debug mode
---     config.activateDebugMode()
---     print(config.isDebugMode()) --> true
---
--- -- Messages
---     config.addMessage("log", "Hello", "general")
---     config.addMessage("error", "Oops", "network")
---     print(config.getMessageCount()) --> 2
---
--- -- Sections
---     config.setDefaultSection("game")
---     local sections = config.getSections() --> { "general", "network" }
---
--- -- Live mode
---     config.activateLiveMode()
---     local newMsgs = config.getNewMessages()
---
--- -- Reset
---     config.clear()
---```
---@class loglua.configLib
local config = {}

config.__index = config

---@type fun(): string, number, string Header handler function
config._HandlerHeader = function() return "-=", 21, "title" end



---@type boolean Whether the last shown index was updated by a real show
config._lastShownPrinted = false


---@type number Start index of the last printed group
config._lastPrintedGroupStart = 0




---@type number End index of the last printed group
config._lastPrintedGroupEnd = 0




---@type string|nil Section of the last printed group
config._lastPrintedGroupSection = nil



---@type string|nil Type of the last printed group
config._lastPrintedGroupType = nil




---@type number Number of lines occupied by the last printed group
config._lastPrintedLines = 0



---@type number Index of the last shown message (live mode)
config._lastShownIndex = 0


---@class LogMessage
---@field type "log"|"debug"|"error" Message type
---@field message string Content of the message
---@field section string Section name




---@type boolean Whether debug mode is active
config.debugMode = false



---@type function
---
---***Activate debug mode*** (debug messages will be stored and displayed)
---
---example:
---```lua
---config.activateDebugMode()
---print(config.isDebugMode()) --> true
---```
config.activateDebugMode = function() end



---@type function
---@param func fun(): string, number, string Function returning (separator, padding, title)
---
---***Set the header handler function***
---
---example:
---```lua
---config.setHandlerHeader(function()
---    return "(-/", 9, "My App"
---end)
---```
config.setHandlerHeader = function(func) end



---@type function
---
---***Deactivate debug mode*** (debug messages will be ignored)
---
---example:
---```lua
---config.deactivateDebugMode()
---print(config.isDebugMode()) --> false
---```
config.deactivateDebugMode = function() end



---@type function
---@return boolean isDebugMode True if debug mode is active
---
---***Check if debug mode is active***
---
---example:
---```lua
---if config.isDebugMode() then
---    print("Debug is on")
---end
---```
config.isDebugMode = function() end



---@type function
---@return LogMessage[] messages List of all messages
---
---***Return all stored messages***
---
---example:
---```lua
---local msgs = config.getMessages()
---for _, msg in ipairs(msgs) do
---    print(msg.type, msg.section, msg.message)
---end
---```
config.getMessages = function() end




---@type function
---@param section? string Section name to filter (optional)
---@return LogMessage[] messages List of messages from the specified section
---
---***Return messages filtered by a single section***
---
---example:
---```lua
---local netMsgs = config.getMessagesBySection("network")
---print(#netMsgs) --> number of messages in "network"
---```
config.getMessagesBySection = function(section) end




---@type function
---@param sections? string[] List of section names to filter (optional)
---@return LogMessage[] messages List of messages from the specified sections
---
---***Return messages filtered by multiple sections***
---
---example:
---```lua
---local msgs = config.getMessagesBySections({"network", "database"})
---```
config.getMessagesBySections = function(sections) end



---@type function
---@param msgType "log"|"debug"|"error" Message type
---@param message string Message content
---@param section? string Section name (uses default section if not provided)
---
---***Add a new message to the log***
---
---example:
---```lua
---config.addMessage("log", "Hello world")
---config.addMessage("error", "Connection failed", "network")
---```
config.addMessage = function(msgType, message, section) end



---@type function
---@return number count Total messages stored
---
---***Return the total number of messages***
---
---example:
---```lua
---print(config.getMessageCount()) --> 5
---```
config.getMessageCount = function() end




---@type function
---@param section string Section name
---@return number count Number of messages in the section
---
---***Return the number of messages in a specific section***
---
---example:
---```lua
---print(config.getMessageCountBySection("network")) --> 3
---```
config.getMessageCountBySection = function(section) end



---@type function
---
---***Increment the error counter***
---
---example:
---```lua
---config.incrementErrorCount()
---print(config.getErrorCount()) --> 1
---```
config.incrementErrorCount = function() end



---@type function
---@return number count Total errors
---
---***Return the total number of errors registered***
---
---example:
---```lua
---print(config.getErrorCount()) --> 0
---```
config.getErrorCount = function() end



---@type function
---@return string[] sections Alphabetically sorted list of section names
---
---***Return a list of all used sections***
---
---example:
---```lua
---local sections = config.getSections()
---for _, name in ipairs(sections) do
---    print(name)
---end
---```
config.getSections = function() end



---@type function
---@param section string Default section name
---
---***Set the default section for new messages***
---
---example:
---```lua
---config.setDefaultSection("game")
---print(config.getDefaultSection()) --> "game"
---```
config.setDefaultSection = function(section) end



---@type function
---@return string section Default section name
---
---***Return the current default section name***
---
---example:
---```lua
---print(config.getDefaultSection()) --> "general"
---```
config.getDefaultSection = function() end




---@type function
---
---***Clear all messages and reset counters***
---Removes all messages, registered sections and resets error count
---
---example:
---```lua
---config.clear()
---print(config.getMessageCount()) --> 0
---print(config.getErrorCount()) --> 0
---```
config.clear = function() end



---@type function
---
---***Activate live mode***
---
---example:
---```lua
---config.activateLiveMode()
---print(config.isLiveMode()) --> true
---```
config.activateLiveMode = function() end




---@type function
---
---***Deactivate live mode***
---
---example:
---```lua
---config.deactivateLiveMode()
---print(config.isLiveMode()) --> false
---```
config.deactivateLiveMode = function() end




---@type function
---@return boolean isLive True if live mode is active
---
---***Check if live mode is active***
---
---example:
---```lua
---if config.isLiveMode() then
---    print("Live mode is on")
---end
---```
config.isLiveMode = function() end




---@type function
---@return number index Index of the last shown message
---
---***Get the index of the last shown message***
---
---example:
---```lua
---local idx = config.getLastShownIndex()
---```
config.getLastShownIndex = function() end




---@type function
---@param index number Index of the last shown message
---
---***Set the index of the last shown message***
---
---example:
---```lua
---config.setLastShownIndex(5)
---```
config.setLastShownIndex = function(index) end




---@type function
---@return LogMessage[] messages List of new messages since last show
---
---***Get new messages since last show***
---
---example:
---```lua
---local newMsgs = config.getNewMessages()
---for _, msg in ipairs(newMsgs) do
---    print(msg.message)
---end
---```
config.getNewMessages = function() end

return config
