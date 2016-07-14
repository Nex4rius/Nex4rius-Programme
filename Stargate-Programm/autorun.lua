-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/blob/beta/Stargate-Programm

local args = require("shell").parse(...)[1]

if type(args) == "string" then
  loadfile("/stargate/check.lua")(args)
else
  loadfile("/stargate/check.lua")()
end
