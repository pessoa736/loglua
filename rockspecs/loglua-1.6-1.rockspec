rockspec_format = "3.0"
package = "loglua"
version = "1.6-1"
source = {
   url = "git+https://github.com/pessoa736/loglua.git",
   tag = "v1.6-1"
}
description = {
   summary = "Minimalistic logging helper for Lua with multi-language support.",
   detailed = [[
loglua is a tiny helper to collect messages in-memory and either print them or
append them to a file. Features include: multiple values per log, sections/categories,
automatic grouping, live mode for real-time monitoring, ANSI colors for errors/debug,
section filters, file saving with timestamps, and multi-language help (pt/en/es).
	]],
   homepage = "https://github.com/pessoa736/loglua",
   license = "MIT",
   maintainer = "Davi dos Santos Passos"
}
dependencies = {
   "lua >= 5.4"
}
build = {
   type = "builtin",
   modules = {
      loglua = "loglua/init.lua",
      ["loglua.config"] = "loglua/config.lua",
      ["loglua.formatter"] = "loglua/formatter.lua",
      ["loglua.file_handler"] = "loglua/file_handler.lua",
      ["loglua.help"] = "loglua/help.lua"
   }
}
