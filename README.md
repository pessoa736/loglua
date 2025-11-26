# LogLua

**🌐 Language:** [English](README.md) | [Español](README.es.md) | [Português](README.pt-BR.md)

A modular and minimalist logging system for Lua: collect messages in memory, organize by sections/categories, automatically group consecutive messages, monitor in real-time with live mode, display in console and save to files with timestamped headers.

## ✨ Features

- 📝 **Simple logging** - Add messages with multiple values
- 🏷️ **Section system** - Organize logs by categories
- 📦 **Auto grouping** - Consecutive messages from same section are grouped `[1-3][section]`
- 🔴 **Live Mode** - Monitor logs in real-time
- 🔍 **Filters** - Display/save only specific sections
- 🐛 **Debug mode** - Conditional debug messages
- ❌ **Error tracking** - Automatic error counter
- 📁 **File saving** - Append with timestamps
- 🧩 **Modular architecture** - Well organized code

## 📦 Installation

### Via LuaRocks

```bash
luarocks make rockspecs/loglua-1.5-1.rockspec
```

### Manually

```lua
package.path = "loglua/?.lua;" .. package.path
local log = require("loglua")
```

## 🚀 Quick Start

```lua
local log = require("loglua")

-- Simple log (accepts multiple values)
log("Starting application", "v1.0")
log.add("User:", "davi")

-- Debug message (only shows if debug mode is active)
log.activateDebugMode()
log.debug("Variable x =", 42)

-- Register error (increments internal counter)
log.error("Failed to load resource")

-- Display everything in console
log.show()

-- Save to file
log.save("./logs/", "app.log")
```

Example output (consecutive messages from same section are grouped):

```text
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--  Tue Nov 25 14:30:00 2025  --
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

[1-2][general]
 Starting application v1.0
 User: davi

[3][general]__
 Variable x = 42

[4][general]
////--error: Failed to load resource

Total prints:  4
Total errors:  1
Sections:  general
```

## 📦 Auto Grouping

Consecutive messages from the same section are automatically grouped for better readability:

```lua
local net = log.inSection("network")
net("Connecting...")
net("Handshake OK")
net("Authenticated")

log.add(log.section("database"), "Query executed")

net("Sending data")
net("Response received")
```

Output:

```text
[1-3][network]
 Connecting...
 Handshake OK
 Authenticated

[4][database]
 Query executed

[5-6][network]
 Sending data
 Response received
```

## 🏷️ Section System

Organize your logs by categories for easy filtering:

### Method 1: Using `log.section()`

```lua
log.add(log.section("network"), "Connection established")
log.error(log.section("database"), "Query failed")
log.debug(log.section("parser"), "Token found:", token)
```

### Method 2: Using `log.inSection()`

Creates an object bound to a specific section:

```lua
local netLog = log.inSection("network")
netLog.add("Connecting to server...")
netLog.add("Response received")
netLog.error("Timeout!")
netLog("Shortcut for add")  -- can call directly
```

### Method 3: Setting default section

```lua
log.setDefaultSection("game")
log.add("Player spawned")  -- goes to "game" section
log.add("Score: 100")      -- goes to "game" section
```

### Filtering by sections

```lua
-- Show only one section
log.show("network")

-- Show multiple sections
log.show({"network", "database"})

-- Save with filter
log.save("./", "network.log", "network")
log.save("./", "errors.log", {"network", "database"})

-- List available sections
print(table.concat(log.getSections(), ", "))
```

## 🔴 Live Mode (Real-Time)

Live mode allows monitoring logs in real-time, displaying only new messages since the last `log.show()` call.

### Activating and deactivating

```lua
log.live()      -- activate live mode
log.unlive()    -- deactivate live mode
log.isLive()    -- returns true if live mode is active
```

### Monitoring example

```lua
local log = require("loglua")

-- Activate live mode
log.live()

-- Simulate running application
for i = 1, 10 do
    log("Event " .. i)
    
    if i % 3 == 0 then
        log.show()  -- shows only new logs (last 3)
    end
end

log.unlive()  -- back to normal mode
log.show()    -- now shows all logs with header
```

### Continuous monitoring

```lua
log.live()

local running = true
while running do
    -- your code that generates logs...
    processEvents()
    
    log.show()  -- shows only new messages
    sleep(1)
end
```

### Live mode with filters

```lua
log.live()

-- Monitor only network logs
log.show("network")

-- Or multiple sections
log.show({"network", "database"})
```

### Behavior

| Mode | `log.show()` behavior |
|------|------------------------------|
| Normal | Displays all messages with header and statistics |
| Live | Displays only new messages since last call |

## 📖 Complete API

### Basic Logging

| Function | Description |
|--------|-----------|
| `log(...)` | Shortcut for `log.add(...)` |
| `log.add(...)` | Adds log message |
| `log.debug(...)` | Adds debug message (requires `debugMode`) |
| `log.error(...)` | Adds error message (increments counter) |

### Sections

| Function | Description |
|--------|-----------|
| `log.section(name)` | Creates section tag to use in add/debug/error |
| `log.inSection(name)` | Returns object with pre-configured add/debug/error |
| `log.setDefaultSection(name)` | Sets default section for new messages |
| `log.getDefaultSection()` | Returns current default section name |
| `log.getSections()` | Returns list of all used sections |

### Display and Saving

| Function | Description |
|--------|-----------|
| `log.show([filter])` | Displays logs in console (optional filter) |
| `log.save([dir], [name], [filter])` | Saves logs to file (optional filter) |

### Live Mode

| Function | Description |
|--------|-----------|
| `log.live()` | Activates live mode (real-time) |
| `log.unlive()` | Deactivates live mode |
| `log.isLive()` | Checks if live mode is active |

### Configuration

| Function | Description |
|--------|-----------|
| `log.activateDebugMode()` | Activates debug mode |
| `log.deactivateDebugMode()` | Deactivates debug mode |
| `log.checkDebugMode()` | Checks if debug mode is active |
| `log.clear()` | Clears all messages and resets counters |

### Help

| Function | Description |
|--------|-----------|
| `log.help()` | Displays general help |
| `log.help("sections")` | Help about section system |
| `log.help("live")` | Help about live mode |
| `log.help("api")` | Complete API list |

## 🏗️ Project Structure

```text
loglua/
├── init.lua         # Main module (public API)
├── config.lua       # Configuration and state (messages, debug, counters)
├── formatter.lua    # Message and header formatting
├── file_handler.lua # File operations (I/O)
└── help.lua         # Built-in help system
```

### Architecture

- **`init.lua`**: Public API, integrates all modules
- **`config.lua`**: Manages internal state (messages, sections, counters)
- **`formatter.lua`**: Text formatting (headers, messages, separators)
- **`file_handler.lua`**: File I/O operations
- **`help.lua`**: Built-in documentation accessible via `log.help()`

## 📝 Advanced Examples

### Logger for multiple systems

```lua
local log = require("loglua")

-- Create specific loggers
local networkLog = log.inSection("network")
local dbLog = log.inSection("database")
local uiLog = log.inSection("ui")

-- Use in different parts of code
networkLog("Connecting...")
dbLog("Query executed")
uiLog("Screen loaded")

-- Save each section to separate file
log.save("./logs/", "network.log", "network")
log.save("./logs/", "database.log", "database")
log.save("./logs/", "ui.log", "ui")
```

### Conditional debug

```lua
local log = require("loglua")

local DEBUG = true
if DEBUG then
    log.activateDebugMode()
end

log.debug("This message only shows if DEBUG=true")
```

### Clear and restart

```lua
local log = require("loglua")

log("Message 1")
log("Message 2")
log.show()

log.clear()  -- Clears everything

log("New session")
log.show()
```

## 📋 Notes

- Messages stay in memory until cleared with `clear()`
- Calling `save` repeatedly appends to file (with new timestamp)
- Debug messages only show if `debugMode` is active
- Sections are automatically registered when adding messages

## 🔧 Compatibility

- Lua >= 5.4

## 📜 License

MIT — see `LICENSE`.
