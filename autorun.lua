-- pastebin run -f fa9gu1GJ
-- von Nex4rius

local shell = require("shell")
local args = shell.parse(...)

if type(args[1]) == "string" then
  args[1] = string.lower(args[1])
else
  args[1] = ""
end

os.execute("stargate/check.lua " .. args[1])
