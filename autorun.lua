-- pastebin run -f fa9gu1GJ
-- von Nex4rius

local shell = require("shell")
local args = shell.parse(...)

if type(args[1]) == "string" then
  args[1] = string.lower(args[1])
else
  args[1] = nil
end

if not args[1] then
  os.execute("stargate/check.lua")
else
  os.execute("stargate/check.lua " .. args[1])
end
