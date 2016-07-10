-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm

local args = require("shell").parse(...)[1]

if type(args) == "string" then
  loadfile("/stargate/check.lua")(args)
else
  loadfile("/stargate/check.lua")()
end
