---@meta loglua.formatter
---@module "loglua.formatter"
---@author pessoa736
---@license MIT
---
---### LogLua - Message Formatting Module
---Responsible for formatting log messages for display and saving:
--- - Formatting messages with index, section, and timestamps
--- - Grouping consecutive messages
--- - ANSI color support
--- - Argument conversion
---
---@class loglua.formatterLib
local formatter = {}

formatter.__index = formatter

---@class loglua.formatter.colors
---@field reset string
---@field red string
---@field yellow string
---@field green string
---@field cyan string
---@field gray string

---@type loglua.formatter.colors
formatter.colors = {}

---@type boolean
---
---Flag to enable/disable colors (enabled by default)
formatter.useColors = true

---@type function
---@param char? string The character to use (default: "-=")
---@param count? number The number of repetitions (default: 21)
---@return string separator The generated separator string
---
---***Creates a decorative separator line***
---
---example:
---```lua
---local sep = formatter.createSeparator("=-", 10)
---print(sep) --> "=-=-=-=-=-=-=-=-=-=-"
---```
formatter.createSeparator = function(char, count) end

---@type function
---@param handlerHeader? function Optional function to generate custom header parts
---@return string header The complete formatted header string
---
---***Creates a formatted log header with timestamp***
---
---example:
---```lua
---local header = formatter.createHeader()
---print(header)
--- -- -=-=-=-=-=-=-=-=-=-=-
--- -- title
--- -- -=-=-=-=-=-=-=-=-=-=-
---```
formatter.createHeader = function(handlerHeader) end

---@type function
---@param index number|string The message index or range string
---@param message string The message content
---@param section? string The section name (optional)
---@return string formatted The formatted message with newlines
---
---***Formats a standard log message***
---
---example:
---```lua
---local out = formatter.formatMessage(1, "Hello world", "general")
---print(out) --> "[1][general]\n Hello world"
---```
formatter.formatMessage = function(index, message, section) end

---@type function
---@param index number|string The message index or range string
---@param message string The message content
---@param section? string The section name (optional)
---@return string formatted The formatted debug message with "__" marker
---
---***Formats a debug message (with special prefix)***
---
---example:
---```lua
---local out = formatter.formatDebugMessage(3, "x = 42", "parser")
---print(out) --> "__[3][parser]\n x = 42"
---```
formatter.formatDebugMessage = function(index, message, section) end

---@type function
---@param messages table The list of message objects
---@param debugMode boolean Whether debug mode is active
---@param startOffset? number Initial index offset (for live mode)
---@return table groups List of grouped message objects
---
---***Groups consecutive messages from the same section***
---
---example:
---```lua
---local msgs = {
---    {type = "log", message = "msg1", section = "net"},
---    {type = "log", message = "msg2", section = "net"},
---    {type = "log", message = "msg3", section = "db"},
---}
---local groups = formatter.groupMessages(msgs, false, 0)
--- -- groups[1] has msgs 1-2 (section "net")
--- -- groups[2] has msg 3 (section "db")
---```
formatter.groupMessages = function(messages, debugMode, startOffset) end

---@type function
---@param group table The message group object
---@return string formatted The formatted group string
---
---***Formats a group of messages***
---
---example:
---```lua
---local group = {
---    startIdx = 1, endIdx = 2,
---    section = "net", msgType = "log",
---    messages = {"msg1", "msg2"}
---}
---print(formatter.formatGroup(group))
--- -- [1-2][net]
--- --  msg1
--- --  msg2
---```
formatter.formatGroup = function(group) end

---@type function
---@vararg any
---@return string message Concatenated arguments
---
---***Converts variadic arguments into a single string***
---
---example:
---```lua
---local s = formatter.argsToString("Value:", 42, true)
---print(s) --> "Value: 42 true"
---```
formatter.argsToString = function(...) end

---@type function
---@return string prefix The error prefix string
---
---***Returns the prefix used for error messages***
---
---example:
---```lua
---local prefix = formatter.formatErrorPrefix()
---print(prefix) --> "[!] "
---```
formatter.formatErrorPrefix = function() end

return formatter
