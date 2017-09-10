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

local ergebnis, grund = pcall(loadfile("/tank/anzeige.lua"), args)

if not ergebnis then
  require("term").clear()
  print("<FEHLER>")
  print(grund)
  for i = 10, 1, -1 do
    print("Neustart in ... " i)
  end
  os.execute("pastebin run -f cyF0yhXZ Tank")
end

shell.setWorkingDirectory(alterPfad)
