-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")
local args = shell.parse(...)[1]

shell.setWorkingDirectory("/")

if type(args) == "string" then
  loadfile("/tank/auslesen.lua")(args)
else
  loadfile("/tank/auslesen.lua")()
end

require("shell").setWorkingDirectory(alterPfad)
