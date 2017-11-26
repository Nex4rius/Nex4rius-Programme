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

local ergebnis, grund, a, b = pcall(loadfile("/tank/anzeige.lua"), args)

if not ergebnis then
  require("component").getPrimary("gpu").setResolution(require("component").getPrimary("gpu").maxResolution())
  require("term").clear()
  print("<FEHLER> /tank/anzeige.lua")
  print(grund, a, b)
  for i = 10, 1, -1 do
    print("Neustart in " .. i .. "s")
    os.sleep(1)
  end
  for i = 1, math.huge do
    if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/installieren.lua", "/installieren.lua") then --hier auf master
      print(pcall(loadfile("/installieren.lua"), "Tank"))
    end
    print("<FEHLER> Warte " .. i .. "s")
    os.sleep(i)
  end
end

shell.setWorkingDirectory(alterPfad)
