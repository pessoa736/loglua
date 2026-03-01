# Advanced Examples

## Logger for multiple systems

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

## Conditional debug

```lua
local log = require("loglua")

local DEBUG = true
if DEBUG then
    log.activateDebugMode()
end

log.debug("This message only shows if DEBUG=true")
```

## Clear and restart

```lua
local log = require("loglua")

log("Message 1")
log("Message 2")
log.show()

log.clear()  -- Clears everything

log("New session")
log.show()
```