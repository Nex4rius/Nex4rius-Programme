-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")
local args = shell.parse(...)[1]

shell.setWorkingDirectory("/")

if type(args) ~= "string" then
  args = nil
end

if not pcall(loadfile("/stargate/check.lua"), args) then
  print("check.lua hat einen Fehler")
  loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Stargate-Programm/installieren.lua", "/installieren.lua")
  loadfile("/installieren.lua")()
end

require("shell").setWorkingDirectory(alterPfad)
