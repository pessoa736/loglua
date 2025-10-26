# loglua

Minimalistic logging helper for Lua: collect messages in-memory, print them to the console, and append them to a file with a timestamped header.

## Installation

Install locally via LuaRocks using the rockspec included in this repository:

```bash
luarocks make rockspecs/loglua-1.0-3.rockspec
```

Then require the module in your code:

```lua
local log = require("loglua")
```

During development (without installing), load the project folder directly by tweaking `package.path`:

```lua
package.path = "loglua/?.lua;" .. package.path
local log = require("loglua")
```

## Quick start

```lua
local log = require("loglua")

-- Add messages (accepts multiple values)
log("Starting process", 123)
log.add("User:", "davi")

-- Debug message (visible/saved only if log.debugMode is true)
log.debug("x=", 42)

-- Register an error (increments internal counter)
log.error("failed to load resource")

-- Print everything and totals
log.show()

-- Save to a file: log.save(dir, name)
--   - dir: directory (use empty string for current directory)
--   - name: filename (default: "log.txt")
-- Examples: log.save("/tmp/", "my_log.txt") or log.save("", "my_log.txt")
log.save("", "my_log.txt")
```

Example console output from `show()`:

```
-= - = - = - = - = - = - = - = - = - = -
--	2025-10-26 12:34:56	--
-= - = - = - = - = - = - = - = - = - = -

[1] Starting process 123
[2] User: davi

Total prints: 3
Total errors: 1
```

## API

- `log(...)` / `log.add(...)`: add a new message. Accepts multiple values; each value is stringified and concatenated.
- `log.debug(...)`: add a debug message. Displayed/saved only when `log.debugMode = true`.
- `log.error(...)`: add an error message and increment `log._NErrors`.
- `log.show()`: print a timestamped header and the accumulated messages.
- `log.save(dir, name)`: append the messages to a file with a timestamped block header. Pass `dir` (can be `""`) and `name` (default `"log.txt"`).

Notes:
- Messages remain in memory until you print/save them. Calling `save` repeatedly will append the same block again (with a fresh timestamp header).
- Error entries are counted; by default, only regular `log` messages are displayed/saved, and `debug` messages are included only if `log.debugMode = true`.

## Configuration

- `log.debugMode` (boolean): when `true`, `log.debug(...)` messages are printed and saved. Off by default until you set `log.debugMode = true`.

## Compatibility

- Lua >= 5.4 

## Development

- Main source file: `loglua/init.lua`.
- Quick test during development:

```bash
lua -e 'package.path="loglua/?.lua;"..package.path; local log=require("loglua"); log("hello"); log.show()'
```

- There is a simple example at `loglua/test/init.lua`; adjust `package.path` if needed.

## License

MIT — see `LICENSE`.
