---@meta loglua.help
---@module "loglua.help"
---@author pessoa736
---@license MIT
---
---### LogLua - Integrated Help System
---Provides access to documentation topics directly from the console.
---Supports multiple languages and lazy-loading of help pages.
---
---***usage example:*** </br>
---```lua
---local help = require("loglua.help")
---
--- -- Show default help
---     help.show()
---
--- -- Show specific topic
---     help.show("LiveMode")
---     help.show("SectionSystem")
---     help.show("CompleteAPI")
---
--- -- Show help in a specific language
---     help.show("Surface", "en")
---
--- -- Add a new language
---     help:add_language("pt", function(lang, pageName)
---         return require("loglua.constants.helper." .. lang .. "." .. pageName)
---     end)
---```
---@class loglua.helpLib
local help = {}
help.__index = help



---@type table<string, table<string, string>> Map of language code to page content tables
help.languages = {}



---@type string|nil Current language code
help.currentLanguage = nil



---@type string|nil Default language code (first language added)
help.defaultLanguage = nil



---@type string[] List of registered page names
help.pagesNameList = {}





---@type function
---@param ... string Page names to register
---
---***Register page names to the help system***
---
---example:
---```lua
---help:addToPageList("LiveMode", "SectionSystem", "CompleteAPI", "Surface", "__default")
---```
help.addToPageList = function(self, ...) end






---@type function
---@param language string Language code (e.g. "en", "pt")
---@param texts table|fun(lang: string, pageName: string): string Table of page contents or a loader function
---
---***Add a language with its help pages***
---
---Using a table:
---```lua
---help:add_language("en", {
---    LiveMode      = "...",
---    SectionSystem = "...",
---    CompleteAPI    = "...",
---    Surface       = "...",
---    __default     = "...",
---})
---```
---
---Using a loader function:
---```lua
---help:add_language("en", function(lang, pageName)
---    local p = "YourPathPages" .. lang .. "."
---    if pageName == "__default" then
---        p = p .. "YourDefaultPage"
---    else
---        p = p .. pageName
---    end
---    return require(p)
---end)
---```
help.add_language = function(self, language, texts) end




---@type function
---@param topic? "LiveMode"|"SectionSystem"|"CompleteAPI"|"Surface"|string The help topic to display. If omitted, shows default page.
---@param language? string Language code to use (defaults to currentLanguage)
---
---***Shows help information for a specific topic***
---
---example:
---```lua
---help.show()                    -- shows default help page
---help.show("LiveMode")          -- help about live mode
---help.show("SectionSystem")     -- help about sections
---help.show("CompleteAPI")       -- complete API list
---help.show("Surface", "en")    -- surface page in English
---```
help.show = function(topic, language) end


return help
