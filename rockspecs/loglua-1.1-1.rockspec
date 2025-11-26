rockspec_format = "3.0"
package = "loglua"
version = "1.1-1"
source = {
   url = "git+https://github.com/pessoa736/loglua.git",
   tag = "v1.1"
}
description = {
   summary = "Modular logging system for Lua with sections/categories support.",
   detailed = [[
LogLua is a modular and minimalist logging system for Lua that allows you to:
- Collect log, debug, and error messages in memory
- Organize logs by sections/categories for easy filtering
- Display logs in the console with optional section filters
- Save logs to files with timestamped headers
- Filter logs by single or multiple sections when displaying/saving

Features:
- Simple API: log(), log.add(), log.debug(), log.error()
- Section system: log.section(), log.inSection(), log.setDefaultSection()
- Filtering: log.show("section"), log.show({"sec1", "sec2"})
- Debug mode: only show debug messages when activated
- Error tracking: automatic error counter
   ]],
   homepage = "https://github.com/pessoa736/loglua",
   license = "MIT",
   maintainer = "Davi dos Santos Passos",
   labels = {"logging", "log", "debug", "modular"}
}
dependencies = {
   "lua >= 5.4"
}
build = {
   type = "builtin",
   modules = {
      ["loglua"] = "loglua/init.lua",
      ["loglua.config"] = "loglua/config.lua",
      ["loglua.formatter"] = "loglua/formatter.lua",
      ["loglua.file_handler"] = "loglua/file_handler.lua"
   }
}
