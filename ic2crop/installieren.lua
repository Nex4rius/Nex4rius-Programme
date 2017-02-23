-- pastebin run -f 5Rpn3MZb
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

require("shell").setWorkingDirectory("/")

local fs          = require("filesystem")
local arg         = require("shell").parse(...)[1]
local wget        = loadfile("/bin/wget.lua")
local copy        = loadfile("/bin/cp.lua")
local component   = require("component")
local gpu         = component.gpu
local Sicherung   = {}
local Funktionen  = {}
local sprachen

Sicherung.Sprache = ""
Sicherung.installieren = false

function Funktionen.Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/ic2crop/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/ic2crop/"
  end
end

function Funktionen.installieren(versionTyp)
  Funktionen.Komponenten()
  local updateKomplett = false
  local update = {}
  fs.makeDirectory("/update")
  update[1] = wget("-f", Funktionen.Pfad(versionTyp) .. "autorun.lua",  "/update/autorun.lua")
  update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "ic2crops.lua", "/update/ic2crops.lua")
  update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. "version.txt",  "/update/version.txt")
  for i = 1, 3 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      else
        print("Fehler " ..i)
      end
      break
    end
  end
  if updateKomplett then
    copy("/update/autorun.lua",  "/autorun.lua")
    copy("/update/ic2crops.lua", "/ic2crops.lua")
    copy("/update/version.txt",  "/version.txt")
    f = io.open ("/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
    Sicherung.installieren = true
    print()
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/update", "-r")
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  end
  local f = io.open ("/bin/ic2crops.lua", "w")
  f:write('-- pastebin run -f 5Rpn3MZb\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
  f:write('\n')
  f:write('loadfile("/autorun.lua")(require("shell").parse(...)[1])\n')
  f:close()
  if updateKomplett then
    print("\nUpdate komplett\n" .. tostring(version) .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
    loadfile("/autorun.lua")()
  else
    print("\nERROR install / update failed\n")
  end
  print("10s bis Neustart")
  os.sleep(10)
  require("computer").shutdown(true)
end

function Funktionen.abfrage(name, text)
  if component.isAvailable(name) then
    gpu.setForeground(0x00FF00)
    print(text .. " - OK")
  else
    gpu.setForeground(0xFF0000)
    print(text .. " - ERROR")
  end
  os.sleep(0.1)
end

function Funktionen.Komponenten(typ)
  require("term").clear()
  print("Checke Komponenten\n")
  Funktionen.abfrage("internet", "Internet Card")
  Funktionen.abfrage("inventory_controller", "Inventory Controller")
  Funktionen.abfrage("tractor_beam", "Tractor Beam")
  Funktionen.abfrage("redstone", "Redstone Card")
  Funktionen.abfrage("gpu", "GPU")
  Funktionen.abfrage("screen", "Screen")
  Funktionen.abfrage("robot", "Robot")
  gpu.setForeground(0xFFFFFF)
  print("\nEnter drücken\n")
  require("term").read()
end

if versionTyp == nil then
  if type(arg) == "string" then
    Funktionen.installieren(arg)
  else
    Funktionen.installieren("master")
  end
else
  Funktionen.installieren(versionTyp)
end
