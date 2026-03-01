return [[

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
  log.help()                General help
  log.help("SectionSystem") Section system
  log.help("LiveMode")      Live mode (real-time)
  log.help("CompleteAPI")   This list


]]