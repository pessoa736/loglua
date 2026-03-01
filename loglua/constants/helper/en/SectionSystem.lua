return [[

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