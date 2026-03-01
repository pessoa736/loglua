---@diagnostic disable: undefined-global, undefined-field

--[[
    Run with: busted spec/loglua_spec.lua
]]

local log = require("loglua")
local config = require("loglua.config")

describe("LogLua", function()
    -- Helper to count lines in a file
    local function count_lines(filepath)
        local f = io.open(filepath, "r")
        if not f then return 0 end
        local count = 0
        for _ in f:lines() do count = count + 1 end
        f:close()
        return count
    end

    setup(function()
        -- Ensure clean state before starting suite
        log.clear()
        -- Remove test files if they exist
        os.remove("test_all.log")
        os.remove("test_network.log")
        os.remove("test_multi.log")
        os.remove("log.txt")
    end)

    teardown(function()
        -- Clean up after suite
        log.clear()
        os.remove("test_all.log")
        os.remove("test_network.log")
        os.remove("test_multi.log")
        os.remove("log.txt")
    end)
    
    before_each(function()
        log.clear()
        log.deactivateDebugMode()
        if log.isLive() then log.unlive() end
        log.setDefaultSection("general")
    end)

    describe("Basic Logging", function()
        it("adds simple messages", function()
            log("Simple message")
            log.add("Message with add")
            log.add("Multiple", "values", 123, true)
            
            assert.is_true(#log.getSections() >= 0)
            assert.equals(3, config.getMessageCount())
        end)
    end)

    describe("Section System", function()
        it("registers sections correctly", function()
            log.add(log.section("network"), "Connection established")
            log.add(log.section("network"), "Data sent")
            log.add(log.section("database"), "Query executed")
            log.add(log.section("ui"), "Screen rendered")

            local sections = log.getSections()
            assert.equals(3, #sections)

            local hasNetwork = false
            local hasDatabase = false
            local hasUI = false
            for _, s in ipairs(sections) do
                if s == "network" then hasNetwork = true end
                if s == "database" then hasDatabase = true end
                if s == "ui" then hasUI = true end
            end

            assert.is_true(hasNetwork)
            assert.is_true(hasDatabase)
            assert.is_true(hasUI)
        end)
    end)

    describe("log.inSection()", function()
        it("creates logger bound to section", function()
            local netLog = log.inSection("network")
            netLog.add("Message 1")
            netLog.add("Message 2")
            netLog.error("Network error")

            local dbLog = log.inSection("database")
            dbLog.add("Query 1")
            dbLog.debug("Debug query")

            local sections = log.getSections()
            assert.equals(2, #sections)
            
            -- Verify messages are in correct sections
            local msgs = config.getMessages()
            assert.equals("network", msgs[1].section)
            assert.equals("database", msgs[4].section)
        end)

        it("supports direct call on section logger", function()
            local gameLog = log.inSection("game")
            gameLog("Direct call in section")
            gameLog("Another call")
            
            local sections = log.getSections()
            local hasGame = false
            for _, s in ipairs(sections) do
                if s == "game" then hasGame = true end
            end
            assert.is_true(hasGame)
        end)
    end)

    describe("Default Section", function()
        it("sets and uses default section", function()
            log.setDefaultSection("game")
            log.add("Player spawned")
            log.add("Score: 100")

            assert.equals("game", log.getDefaultSection())

            local sections = log.getSections()
            local hasGame = false
            for _, s in ipairs(sections) do
                if s == "game" then hasGame = true end
            end
            assert.is_true(hasGame)
            
            -- Check message content
            local msgs = config.getMessages()
            assert.equals("game", msgs[1].section)
        end)

        it("resets to general", function()
            log.setDefaultSection("general")
            assert.equals("general", log.getDefaultSection())
        end)
    end)

    describe("Debug Mode", function()
        it("starts deactivated", function()
            log.debug("Debug deactivated")
            assert.is_false(log.checkDebugMode())
            assert.equals(0, config.getMessageCount()) -- Message shouldn't be added
        end)

        it("activates correctly", function()
            log.activateDebugMode()
            assert.is_true(log.checkDebugMode())
            
            log.debug("Debug activated")
            assert.equals(1, config.getMessageCount())
        end)

        it("deactivates correctly", function()
            log.activateDebugMode()
            log.deactivateDebugMode()
            assert.is_false(log.checkDebugMode())
        end)
    end)

    describe("Error Handling", function()
        it("counts errors", function()
            log.error("Error 1")
            log.error("Error 2")
            log.error(log.section("critical"), "Critical error")
            
            assert.equals(3, config.getErrorCount())
        end)
    end)

    describe("clear()", function()
        it("clears messages and sections", function()
            log.add("Message before clear")
            log.error("Error before clear")
            
            log.clear()
            
            assert.equals(0, config.getMessageCount())
            assert.equals(0, #log.getSections())
            assert.equals(0, config.getErrorCount())
        end)
    end)

    describe("Direct Call log()", function()
        it("works as shortcut for log.add", function()
            log("Direct call 1")
            log("Direct call 2", "multiple args")
            
            assert.equals(2, config.getMessageCount())
        end)
    end)

    describe("Live Mode", function()
        it("activates and deactivates", function()
            assert.is_false(log.isLive())
            
            log.live()
            assert.is_true(log.isLive())
            
            log.unlive()
            assert.is_false(log.isLive())
        end)

        it("handles existing messages correctly", function()
            log("Message 1")
            log("Message 2")
            log("Message 3")
            
            log.live()
            -- Should mark existing messages as shown
            assert.equals(3, config._lastShownIndex)
            
            log("Message 4")
            log("Message 5")
            
            log.unlive()
            assert.equals(5, config.getMessageCount())
        end)

        it("merges groups in live mode", function()
            log.live()
            
            log("first")
            -- simulate printing happening (live mode prints directly usually, 
            -- but here we check internal state if we can access it via config)
            -- The formatting logic updates `config._lastPrintedGroupStart`
            -- We need to inspect `config` internals which are available via require("loglua.config")
            
            -- Note: In live mode, `log()` triggers `show()` automatically.
            -- So `config._lastPrintedGroupStart` should be set.
            
            local s1 = config._lastPrintedGroupStart
            local e1 = config._lastPrintedGroupEnd
            
            log("second")
            local s2 = config._lastPrintedGroupStart
            
            -- In live mode, groups SHOULD merge, so s2 should remain s1
            assert.equals(s1, s2)
            assert.is_true(config._lastPrintedGroupEnd > e1)
            
            log.unlive()
        end)
    end)

    describe("File Saving", function()
        it("saves files correctly", function()
            -- Add some content
            local net = log.inSection("network")
            local db = log.inSection("database")
            
            net("Network msg")
            db("Database msg")
            
            log.save("./", "test_all.log")
            log.save("./", "test_network.log", "network")
            log.save("./", "test_multi.log", {"network", "database"})
            
            -- Verify files exist and have content
            local f = io.open("test_all.log", "r")
            assert.is_not_nil(f)
            if f then f:close() end
            
            f = io.open("test_network.log", "r")
            assert.is_not_nil(f)
            if f then f:close() end
            
            f = io.open("test_multi.log", "r")
            assert.is_not_nil(f)
            if f then f:close() end
        end)
    end)

    describe("Console Colors and Formatting", function()
        it("enables and disables colors safely", function()
            assert.is_true(log.hasColors())
            log.disableColors()
            assert.is_false(log.hasColors())
            log.enableColors()
            assert.is_true(log.hasColors())
        end)

        it("allows custom handler header function", function()
            -- Modify header logic
            log.setHandlerHeader(function()
                return "=-", 10, "TEST"
            end)
            
            -- Check state internals
            local str, pad, title = config._HandlerHeader()
            assert.equals("=-", str)
            assert.equals(10, pad)
            assert.equals("TEST", title)
        end)
    end)

    describe("Filtering Features", function()
        it("retrieves messages from single section", function()
            log.add("general")
            log.add("general 2")
            log.add(log.section("network"), "net packet")
            log.add(log.section("db"), "db payload")

            local netMsgs = config.getMessagesBySection("network")
            assert.equals(1, #netMsgs)
            -- Substring match because formatArgs may add spaces context
            assert.is_true(string.find(netMsgs[1].message, "net packet") ~= nil)
        end)

        it("retrieves messages from multiple sections", function()
            log.add("general text")
            log.add(log.section("network"), "connected")
            log.add(log.section("db"), "started")
            log.add(log.section("ui"), "rendered")

            local multiMsgs = config.getMessagesBySections({"network", "db"})
            assert.equals(2, #multiMsgs)
            
            local hasNetworkMsg = false
            local hasDbMsg = false
            
            for _, m in ipairs(multiMsgs) do
                if m.section == "network" then hasNetworkMsg = true end
                if m.section == "db" then hasDbMsg = true end
                assert.is_not_equal("ui", m.section)
            end

            assert.is_true(hasNetworkMsg)
            assert.is_true(hasDbMsg)
        end)
    end)

    describe("Help System", function()
        it("displays help topics without throwing errors", function()
            local ok = pcall(function()
                log.help()
                log.help("LiveMode")
                log.help("SectionSystem")
            end)
            
            assert.is_true(ok)
        end)
    end)
end)
