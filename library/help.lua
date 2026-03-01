---@meta loglua.help
---@module "loglua.help"
---@author pessoa736
---@license MIT
---
---### LogLua - Integrated Help System
---Provides access to documentation topics directly from the console
---
---@class loglua.helpLib
local help = {}

help.__index = help

---@type function
---@param topic? "sections"|"live"|"api" The help topic to display. If omitted, shows general help.
---
---***Shows help information for a specific topic***
help.show = function(topic) end

---@type function
---
---***Deprecated: Only English is supported now.***
---This function exists for backward compatibility but does nothing.
help.setLanguage = function(lang) end

---@type function
---@return string lang The ISO language code (always "en")
---
---***Returns the current language code***
help.getLanguage = function() end

return help
