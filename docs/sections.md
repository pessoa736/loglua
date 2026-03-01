# Section System

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