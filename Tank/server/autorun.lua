-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")
local args = ...

shell.setWorkingDirectory("/")

if type(args) == "string" then
  loadfile("/tank/anzeige.lua")(args)
else
  loadfile("/tank/anzeige.lua")()
end

shell.setWorkingDirectory(alterPfad)
