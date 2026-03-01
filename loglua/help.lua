local help = {}

help.en = {}

help.en.text = [[
╔══════════════════════════════════════════════════════════════╗
║                      LogLua v1.5                             ║
║          Modular logging system for Lua                      ║
╚══════════════════════════════════════════════════════════════╝

📝 BASIC LOGGING
  log("message")               Add log (shortcut)
  log.add("message")           Add log
  log.debug("message")         Add debug (requires debugMode)
  log.error("message")         Add error

🏷️ SECTIONS
  log.section("name")          Create section tag
  log.inSection("name")        Create logger bound to section
  log.setDefaultSection("x")   Set default section
  log.getDefaultSection()      Get default section
  log.getSections()            List used sections

📺 DISPLAY
  log.show()                   Show all logs
  log.show("section")          Filter by section
  log.show({"a", "b"})         Filter by multiple sections

🔴 LIVE MODE (Real-Time)
  log.live()                   Activate live mode
  log.unlive()                 Deactivate live mode
  log.isLive()                 Check if live mode is active

💾 SAVING
  log.save()                   Save to "log.txt"
  log.save("./", "app.log")    Save to specific file

🎨 COLORS
  log.enableColors()           Enable ANSI colors
  log.disableColors()          Disable colors

⚙️ CONFIGURATION
  log.activateDebugMode()      Activate debug mode
  log.deactivateDebugMode()    Deactivate debug mode
  log.clear()                  Clear all logs

❓ HELP
  log.help()                   Show this help
  log.help("sections")         Help about sections
  log.help("live")             Help about live mode
  log.help("api")              Complete API list

More info: https://github.com/pessoa736/loglua
]]

help.en.sections = [[
╔══════════════════════════════════════════════════════════════╗
║                    Section System                            ║
╚══════════════════════════════════════════════════════════════╝

Sections allow organizing logs by category (network, database, etc).

🔹 METHOD 1: log.section()
   log.add(log.section("network"), "connecting...")
   log.error(log.section("database"), "query failed")

🔹 METHOD 2: log.inSection()
   local net = log.inSection("network")
   net("message 1")
   net("message 2")
   net.error("failed!")

🔹 METHOD 3: Default section
   log.setDefaultSection("game")
   log("player spawned")  -- goes to "game" section

🔹 FILTERING
   log.show("network")           -- only network
   log.show({"network", "db"})   -- network and db
   log.save("./", "net.log", "network")

🔹 GROUPING
   Consecutive messages from same section group automatically:
   [1-3][network] instead of [1][network], [2][network], [3][network]
]]

help.en.live = [[
╔══════════════════════════════════════════════════════════════╗
║                      Live Mode                               ║
╚══════════════════════════════════════════════════════════════╝

Live mode allows monitoring logs in real-time, displaying only
new messages since the last log.show() call.

🔹 ACTIVATING LIVE MODE
   log.live()                  -- activate live mode
   
🔹 DEACTIVATING
   log.unlive()                -- back to normal mode
   
🔹 CHECKING STATE
   if log.isLive() then
       print("Live mode active!")
   end

🔹 USAGE EXAMPLE
   log.live()                  -- activate live mode
   
   while running do
       log("event happened")
       log.show()              -- shows only new logs
       sleep(1)
   end
   
   log.unlive()                -- deactivate

🔹 BEHAVIOR
   - Live mode: log.show() displays only new messages
   - Normal mode: log.show() displays all messages with header
   - Filters work in both modes
]]

help.en.api = [[
╔══════════════════════════════════════════════════════════════╗
║                      Complete API                            ║
╚══════════════════════════════════════════════════════════════╝

FUNCTION                        DESCRIPTION
─────────────────────────────────────────────────────────────────
log(...)                        Shortcut for log.add(...)
log.add(...)                    Add log message
log.debug(...)                  Add debug message
log.error(...)                  Add error message

log.section(name)               Create section tag
log.inSection(name)             Create logger for specific section
log.setDefaultSection(name)     Set default section
log.getDefaultSection()         Get current default section
log.getSections()               List all used sections

log.show([filter])              Display logs (optional filter)
log.save([dir], [name], [flt])  Save logs to file

log.live()                      Activate live mode (real-time)
log.unlive()                    Deactivate live mode
log.isLive()                    Check if live mode is active

log.enableColors()              Enable ANSI colors
log.disableColors()             Disable colors
log.hasColors()                 Check if colors are enabled

log.activateDebugMode()         Activate debug mode
log.deactivateDebugMode()       Deactivate debug mode
log.checkDebugMode()            Check debug mode state
log.clear()                     Clear logs and counters

log.help([topic])               Show help
─────────────────────────────────────────────────────────────────

HELP TOPICS
  log.help()            General help
  log.help("sections")  Section system
  log.help("live")      Live mode (real-time)
  log.help("api")       This list
]]

-- Keep functions but remove language switching logic since it's only English now
function help.setLanguage(lang)
    -- Deprecated: Only English is supported now
end

function help.getLanguage()
    return "en"
end

function help.show(topic)
    local texts = help.en
    
    if topic == "sections" or topic == "section" then
        print(texts.sections)
    elseif topic == "live" or topic == "realtime" then
        print(texts.live)
    elseif topic == "api" then
        print(texts.api)
    else
        print(texts.text)
    end
end

return help
