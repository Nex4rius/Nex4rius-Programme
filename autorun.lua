-- pastebin run -f ySJv3YyT
local shell = require("shell")
local args = shell.parse(...)
if not args[1] then
  os.execute("stargate/check.lua")
else
  os.execute("stargate/check.lua " .. args[1])
end
