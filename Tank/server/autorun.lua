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
  require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
  require("term").clear()
  print("<FEHLER>")
  print(grund)
  for i = 10, 1, -1 do
    print("Neustart in ... " .. i)
    os.sleep(i)
  end
  for i = 1, math.huge do
    os.execute("pastebin run -f cyF0yhXZ Tank")
    print("<FEHLER> Warte " .. i .. "s")
    os.sleep(i)
  end
end

shell.setWorkingDirectory(alterPfad)
