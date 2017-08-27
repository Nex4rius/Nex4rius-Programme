-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme

os.sleep(2)

local shell = require("shell")
local alterPfad = shell.getWorkingDirectory("/")
local args = ...

shell.setWorkingDirectory("/")

if type(args) ~= "string" then
  args = ""
end

local ergebnis, grund = pcall(loadfile("/tank/auslesen.lua"), args)

if not ergebnis then
  print("<FEHLER>")
  print(grund)
  os.sleep(10)
end

shell.setWorkingDirectory(alterPfad)
