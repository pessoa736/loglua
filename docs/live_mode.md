# Live Mode (Real-Time)

Live mode allows monitoring logs in real-time, displaying only new messages since the last `log.show()` call.

```mermaid
sequenceDiagram
    participant Code as User Script
    participant LL as LogLua
    participant Terminal
    
    Code->>LL: log.live()
    Code->>LL: log("Event 1")
    Code->>LL: log("Event 2")
    Note over LL: Both grouped in memory
    
    Code->>+LL: log.show()
    LL->>-Terminal: Prints Event 1 & 2
    
    Code->>LL: log("Event 3")
    Note over LL: New events pending
    
    Code->>+LL: log.show()
    LL->>-Terminal: Prints ONLY Event 3
```

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