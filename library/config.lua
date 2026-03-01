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
---@class loglua.configLib
local config = {}

config.__index = config


---@class LogMessage
---@field type "log"|"debug"|"error" Message type
---@field message string Content of the message
---@field section string Section name




---@type boolean Whether debug mode is active
config.debugMode = false



---@type function
---
---***Activate debug mode*** (debug messages will be stored and displayed)
config.activateDebugMode = function() end



---@type function
---@param func fun(): string, number, string Function returning (separator, padding, title)
---
---***Set the header handler function***
config.setHandlerHeader = function(func) end



---@type function
---
---***Deactivate debug mode*** (debug messages will be ignored)
config.deactivateDebugMode = function() end



---@type function
---@return boolean isDebugMode True if debug mode is active
---
---***Check if debug mode is active***
config.isDebugMode = function() end



---@type function
---@return LogMessage[] messages List of all messages
---
---***Return all stored messages***
config.getMessages = function() end




---@type function
---@param section? string Section name to filter (optional)
---@return LogMessage[] messages List of messages from the specified section
---
---***Return messages filtered by a single section***
config.getMessagesBySection = function(section) end




---@type function
---@param sections? string[] List of section names to filter (optional)
---@return LogMessage[] messages List of messages from the specified sections
---
---***Return messages filtered by multiple sections***
config.getMessagesBySections = function(sections) end



---@type function
---@param msgType "log"|"debug"|"error" Message type
---@param message string Message content
---@param section? string Section name (uses default section if not provided)
---
---***Add a new message to the log***
config.addMessage = function(msgType, message, section) end



---@type function
---@return number count Total messages stored
---
---***Return the total number of messages***
config.getMessageCount = function() end




---@type function
---@param section string Section name
---@return number count Number of messages in the section
---
---***Return the number of messages in a specific section***
config.getMessageCountBySection = function(section) end



---@type function
---
---***Increment the error counter***
config.incrementErrorCount = function() end



---@type function
---@return number count Total errors
---
---***Return the total number of errors registered***
config.getErrorCount = function() end



---@type function
---@return string[] sections Alphabetically sorted list of section names
---
---***Return a list of all used sections***
config.getSections = function() end



---@type function
---@param section string Default section name
---
---***Set the default section for new messages***
config.setDefaultSection = function(section) end



---@type function
---@return string section Default section name
---
---***Return the current default section name***
config.getDefaultSection = function() end




---@type function
---
---***Clear all messages and reset counters***
---Removes all messages, registered sections and resets error count
config.clear = function() end



---@type function
---
---***Activate live mode***
config.activateLiveMode = function() end




---@type function
---
---***Deactivate live mode***
config.deactivateLiveMode = function() end




---@type function
---@return boolean isLive True if live mode is active
---
---***Check if live mode is active***
config.isLive = function() end



return config
