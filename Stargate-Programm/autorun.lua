-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")
local args = shell.parse(...)[1]

shell.setWorkingDirectory("/")

if type(args) == "string" then
  loadfile("/stargate/check.lua")(args)
else
  loadfile("/stargate/check.lua")()
end

require("shell").setWorkingDirectory(alterPfad)
