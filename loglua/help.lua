local insert<const> = table.insert

---@type loglua.helpLib
local help <const> = {}


help.languages = {}
help.currentLanguage = nil
help.defaultLanguage = nil
help.pagesNameList = {}

function help:addToPageList(...)
   local names = {...}
   for _, name in ipairs(names) do
      insert(self.pagesNameList, name)
   end
end

function help:add_language(language, texts)
   local mapContentPages = {}
   
   if type(texts) == "table" then
      for _, pageName in ipairs(self.pagesNameList) do
         local t = texts[pageName]

         assert(type(t)=="string", "invalid table")
         
         mapContentPages[pageName] = t
      end

   elseif type(texts) == "function" then   
      for _, pageName in ipairs(self.pagesNameList) do
         local t = texts(language, pageName)
         assert(type(t)=="string", "invalid function or invalid return")
         
         mapContentPages[pageName] = t
      end

   else
      error("not got texts")
   end


   if #self.languages == 0 then 
      help.defaultLanguage = language
      help.currentLanguage = language
   end

   self.languages[language] = mapContentPages
end

function help.show(topic, language)
   local texts <const> = help.languages[language or help.currentLanguage or help.defaultLanguage] or {}

   local key = topic or "__default"

   if texts[key] then
      print(texts[key])
   else
      print("\n\nnot found helpers pages\n\n")
   end
end


help:addToPageList(
   "LiveMode", 
   "SectionSystem", 
   "CompleteAPI", 
   "Surface", 
   "__default"
)

-- help:add_language("en", {
--    live        = require "loglua.constants.helper.en.Livemode";
--    section     = require "loglua.constants.helper.en.sectionSystem";
--    api         = require "loglua.constants.helper.en.CompleteApi";
--    surface     = require "loglua.constants.helper.en.surface";
--    __default   = require "loglua.constants.helper.en.surface";
-- })

help:add_language("en", function (lan, pageName)
   local p = "loglua.constants.helper." .. lan .. "."
   
   if pageName == "__default" then
      p = p .. "Surface"
   else
      p = p .. pageName
   end
   
   return require(p)
end)

return help
