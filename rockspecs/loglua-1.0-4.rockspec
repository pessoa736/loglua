rockspec_format = "3.0"
package = "loglua"
version = "1.0-4"
source = {
   url = "git+https://github.com/pessoa736/loglua.git",
   branch = "master"
}
description = {
   summary = "Minimalistic logging helper for Lua.",
   detailed = [[
loglua is a tiny helper to collect messages in-memory and either print them or
append them to a file. It provides a simple API to add messages, display them
in order, and persist them with a timestamp block header.
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
      loglua = "loglua/init.lua"
   }
}
