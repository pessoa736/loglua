return  [[

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
  log.help("SectionSystem")    Help about sections
  log.help("LiveMode")         Help about live mode
  log.help("CompleteAPI")      Complete API list


More info: https://github.com/pessoa736/loglua
]]