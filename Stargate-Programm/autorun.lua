-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local alterPfad = require("shell").setWorkingDirectory("/")
local args = require("shell").parse(...)[1]

require("shell").setWorkingDirectory("/")

if type(args) == "string" then
  loadfile("/stargate/check.lua")(args)
else
  loadfile("/stargate/check.lua")()
end

require("shell").setWorkingDirectory(alterPfad)
