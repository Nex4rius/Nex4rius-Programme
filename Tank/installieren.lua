-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

require("shell").setWorkingDirectory("/")

local fs          = require("filesystem")
local term        = require("term")
local arg         = ...
local wget        = loadfile("/bin/wget.lua")
local component   = require("component")
local gpu         = component.gpu
local Funktionen  = {}

local verschieben = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen   = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

function Funktionen.Pfad(versionTyp)
  if versionTyp == "beta" then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/"
  elseif versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Tank/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Tank/"
  end
end

function Funktionen.installieren(versionTyp)
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  term.clear()
  local weiter = true
  if component.isAvailable("transposer") then
    print("Transposer detected downloading client (sensor).")
    typ = "client"
    weiter = false
  end
  if component.isAvailable("tank_controller") then
    print("Tank Controller detected downloading client (sensor).")
    typ = "client"
    weiter = false
  end
  if gpu.maxResolution() == 160 then
    print("Tier III GPU and Screen detected downloading server (display).")
    typ = "server"
    weiter = false
  end
  if weiter then
    print("Unable to detect a Tier III GPU, a Tier III Screen, a Tank Controller or a Transposer.")
  end
  while weiter do
    print("\n\nserver (display) / client (adapter + tank)?\n")
    typ = io.read()
    if typ == "server" or typ == "client" then
      weiter = false
    else
      weiter = true
    end
  end
  os.sleep(2)
  Funktionen.Komponenten(typ)
  fs.makeDirectory("/tank/client")
  fs.makeDirectory("/update/tank")
  fs.makeDirectory("/update/client/tank")
  local updateKomplett = false
  local anzahl = 3
  local update = {}
  update[1]   = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/autorun.lua",       "/update/autorun.lua")
  update[2]   = wget("-f", Funktionen.Pfad(versionTyp) ..        "/version.txt",       "/update/tank/version.txt")
  if typ == "client" then
    update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/auslesen.lua", "/update/tank/auslesen.lua")
  else
    update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/farben.lua",   "/update/tank/farben.lua")
    update[4] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/anzeige.lua",  "/update/tank/anzeige.lua")
    update[5] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/ersetzen.lua", "/update/tank/ersetzen.lua")
    local typ = "client"
    update[6] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/autorun.lua",       "/update/client/autorun.lua")
    update[7] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/auslesen.lua", "/update/client/tank/auslesen.lua")
    anzahl = 7
  end
  for i = 1, anzahl do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      print("<Fehler> " ..i)
      local f = io.open ("/autorun.lua", "w")
      f:write('-- pastebin run -f cyF0yhXZ\n')
      f:write('-- von Nex4rius\n')
      f:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
      f:write('\n')
      f:write('local shell = require("shell")\n')
      f:write('local alterPfad = shell.getWorkingDirectory("/")\n')
      f:write('local args = shell.parse(...)[1]\n')
      f:write('\n')
      f:write('shell.setWorkingDirectory("/")\n')
      f:write('\n')
      f:write('if type(args) == "string" then\n')
      if typ == "client" then
        f:write('  loadfile("/tank/auslesen.lua")(args)\n')
        f:write('else\n')
        f:write('  loadfile("/tank/auslesen.lua")()\n')
      else
        f:write('  loadfile("/tank/anzeige.lua")(args)\n')
        f:write('else\n')
        f:write('  loadfile("/tank/anzeige.lua")()\n')
      end
      f:write('end\n')
      f:write('\n')
      f:write('shell.setWorkingDirectory(alterPfad)\n')
      f:close()
      break
    end
  end
  if updateKomplett then
    print("Ersetze alte Dateien")
    local function kopieren(...)
      for i in fs.list(...) do
        if fs.isDirectory(i) then
          kopieren(i)
        end
        verschieben("/update/" .. i, "/" .. i)
      end
    end
    kopieren("/update")
    entfernen("/update")
    print("Update vollständig")
    f = io.open ("/tank/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/tank/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
    Sicherung.installieren = true
    print()
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/update", "-r")
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  end
  local f = io.open ("/bin/tank.lua", "w")
  f:write('-- pastebin run -f cyF0yhXZ\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
  f:write('\n')
  f:write('loadfile("/autorun.lua")(require("shell").parse(...)[1])\n')
  f:close()
  if updateKomplett then
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
    pcall(loadfile("/autorun.lua"))
  else
    print("\nERROR install / update failed\n")
  end
  for i = 10, 0, -1 do
    print(i .. "s bis Neustart")
    os.sleep(1)
  end
  require("computer").shutdown(true)
end

function Funktionen.Komponenten(typ)
  term.clear()
  print("check components\n")
  if component.isAvailable("internet") then
    gpu.setForeground(0x00FF00)
    print("Internet Card - OK")
  else
    gpu.setForeground(0xFF0000)
    print("Internet Card - ERROR")
  end
  if component.isAvailable("modem") then
    gpu.setForeground(0x00FF00)
    if component.modem.isWireless() then
      print("Wireless Network Card - OK")
    else
      print("Wireless Network Card - ERROR")
      print("Network Card - OK")
    end
  else
    gpu.setForeground(0xFF0000)
    print("Network Card - ERROR")
  end
  if typ == "server" then
    if gpu.maxResolution() == 160 then
      gpu.setForeground(0x00FF00)
      print("Graphic Card T3 - OK")
      print("Screen T3 - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Graphic Card T3 - ERROR")
      print("Screen T3 - ERROR")
    end
  else
    if component.isAvailable("tank_controller") then
      gpu.setForeground(0x00FF00)
      print("Adapter + Tank Controller Upgrade - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Adapter + Tank Controller Upgrade - ERROR")
    end
    if component.isAvailable("transposer") then
      gpu.setForeground(0x00FF00)
      print("Transposer - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Transposer - ERROR")
    end
  end
  gpu.setForeground(0xFFFFFF)
  os.sleep(2)
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
