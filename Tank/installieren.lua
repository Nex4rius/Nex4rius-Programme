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
local f           = {}

local verschieben = function(von, nach) fs.remove(nach) fs.rename(von, nach) print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach))) end
local entfernen   = function(datei) fs.remove(datei) print(string.format("'%s' wurde gelöscht", datei)) end

function f.Pfad(versionTyp)
  if versionTyp == "beta" then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/Tank/Tank/"
  elseif versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Tank/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Tank/"
  end
end

function f.installieren(versionTyp)
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
  f.Komponenten(typ)
  local function ordner(...)
    while not fs.exists(...) do
      fs.makeDirectory(...)
      print("Erstelle Ordner " .. ...)
    end
  end
  ordner("/tank/client")
  ordner("/update/tank")
  ordner("/update/client/tank")
  local updateKomplett = false
  local function download(von, nach)
    for j = 1, 11 do
      if wget("-f", f.Pfad(versionTyp) .. von, nach) then
        return true
      elseif require("component").isAvailable("internet") and i <= 10 then
        print(von .. "\nerneuter Downloadversuch in " .. j .. "s\n")
        os.sleep(j)
      else
        print("\n<FEHLER> Program wird beendet\n")
        os.exit()
      end
    end
  end
  local anzahl = 3
  local update = {}
  update[1]   = download(typ .. "/autorun.lua", "/update/autorun.lua")
  update[2]   = download(typ .. "/version.lua", "/update/tank/version.txt")
  if typ == "client" then
    update[3] = download(typ .. "/tank/auslesen.lua", "/update/tank/auslesen.lua")
  else
    update[3] = download(typ .. "/tank/farben.lua", "/update/tank/farben.lua")
    update[4] = download(typ .. "tank/anzeige.lua", "/update/tank/anzeige.lua")
    update[5] = download(typ .. "/tank/ersetzen.lua", "/update/tank/ersetzen.lua")
    update[6] = download("client/autorun.lua", "/update/client/autorun.lua")
    update[7] = download("client/tank/auslesen.lua", "/update/client/tank/auslesen.lua")
    anzahl = 7
  end
  for i = 1, anzahl do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      print("<Fehler> " ..i)
      local d = io.open ("/autorun.lua", "w")
      d:write('-- pastebin run -f cyF0yhXZ\n')
      d:write('-- von Nex4rius\n')
      d:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
      d:write('\n')
      d:write('local shell = require("shell")\n')
      d:write('local alterPfad = shell.getWorkingDirectory("/")\n')
      d:write('local args = shell.parse(...)[1]\n')
      d:write('\n')
      d:write('shell.setWorkingDirectory("/")\n')
      d:write('\n')
      d:write('if type(args) == "string" then\n')
      if typ == "client" then
        d:write('  loadfile("/tank/auslesen.lua")(args)\n')
        d:write('else\n')
        d:write('  loadfile("/tank/auslesen.lua")()\n')
      else
        d:write('  loadfile("/tank/anzeige.lua")(args)\n')
        d:write('else\n')
        d:write('  loadfile("/tank/anzeige.lua")()\n')
      end
      d:write('end\n')
      d:write('\n')
      d:write('shell.setWorkingDirectory(alterPfad)\n')
      d:close()
      break
    end
  end
  if updateKomplett then
    print("\nErsetze alte Dateien")
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
    d = io.open("/tank/version.txt", "r")
    version = d:read()
    d:close()
    if versionTyp == "beta" then
      d = io.open ("/tank/version.txt", "w")
      d:write(version .. " BETA")
      d:close()
    end
    Sicherung.installieren = true
    print()
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/update", "-r")
    updateKomplett = loadfile("/bin/rm.lua")("-v", "/installieren.lua")
    print("\nUpdate vollständig")
  end
  local d = io.open ("/bin/tank.lua", "w")
  d:write('-- pastebin run -f cyF0yhXZ\n')
  d:write('-- von Nex4rius\n')
  d:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
  d:write('\n')
  d:write('loadfile("/autorun.lua")(require("shell").parse(...)[1])\n')
  d:close()
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

function f.Komponenten(typ)
  print("\ncheck components\n")
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
  print()
  gpu.setForeground(0xFFFFFF)
  os.sleep(2)
end

if versionTyp == nil then
  if type(arg) == "string" then
    f.installieren(arg)
  else
    f.installieren("master")
  end
else
  f.installieren(versionTyp)
end
