return [[

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