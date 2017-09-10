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

local function verschieben(von, nach)
  fs.remove(nach)
  local ergebnis, grund = fs.rename(von, nach)
  if not ergebnis then
    print("<FEHLER> Verschieben nicht möglich")
    print(von .. " -> " .. nach)
    print(grund)
    os.exit()
  end
  print(string.format("%s → %s", fs.canonical(von), fs.canonical(nach)))
  if fs.exists(von) then
    print("<FEHLER> Kopieren")
    os.exit()
  end
end
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
  print("\n\n")
  local weiter = true
  if component.isAvailable("transposer") then
    print("Transposer gefunden. Client/Sensor wird heruntergeladen.")
    typ = "client"
    weiter = false
  end
  if component.isAvailable("tank_controller") then
    print("Tank Controller gefunden. Client/Sensor wird heruntergeladen.")
    typ = "client"
    weiter = false
  end
  if gpu.maxResolution() == 160 then
    print("Tier III GPU und Bildschirm gefunden. Server/Anzeige wird heruntergeladen.")
    typ = "server"
    weiter = false
  end
  if weiter then
    print("Kein Tier III GPU, Tier III Bildschirm, Tank Controller oder Transposer gefunden.")
  end
  while weiter do
    print("\n\nServer (Anzeige) / Client (Sensor)?\n")
    typ = string.lower(io.read())
    if typ == "server" or typ == "client" then
      weiter = false
    else
      weiter = true
    end
  end
  f.Komponenten(typ)
  local function ordner(...)
    while not fs.exists(...) do
      fs.makeDirectory(...)
      print("Erstelle Ordner " .. ...)
    end
  end
  ordner("/tank/client/tank")
  ordner("/update/tank/client/tank")
  print()
  local updateKomplett = false
  local function download(von, nach)
    for j = 1, 11 do
      if wget("-f", f.Pfad(versionTyp) .. von, nach) then
        return true
      elseif require("component").isAvailable("internet") and j <= 10 then
        print("\t" .. von .. "\nerneuter Downloadversuch in " .. j .. "s\n")
        os.sleep(j)
      else
        print("\n<FEHLER> Download funktioniert nicht\nProgram wird beendet\n")
        os.exit()
      end
    end
  end
  local anzahl = 3
  local update = {}
  update[1]   = download("version.txt", "/update/tank/version.txt")
  update[2]   = download(typ .. "/autorun.lua", "/update/autorun.lua")
  if typ == "client" then
    update[3] = download(typ .. "/tank/auslesen.lua", "/update/tank/auslesen.lua")
  else
    update[3] = download(typ .. "/tank/farben.lua", "/update/tank/farben.lua")
    update[4] = download(typ .. "/tank/anzeige.lua", "/update/tank/anzeige.lua")
    update[5] = download(typ .. "/tank/ersetzen.lua", "/update/tank/ersetzen.lua")
    update[6] = download("client/autorun.lua", "/update/tank/client/autorun.lua")
    update[7] = download("client/tank/auslesen.lua", "/update/tank/client/tank/auslesen.lua")
    update[8] = download("version.txt", "/update/tank/client/tank/version.txt")
    anzahl = 8
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
          kopieren(... .. i)
        end
        verschieben("/update/" .. i, "/" .. i)
      end
    end
    kopieren("/update")
    print()
    entfernen("/update")
    entfernen("/installieren.lua")
    d = io.open("/tank/version.txt", "r")
    version = d:read()
    d:close()
    if versionTyp == "beta" then
      d = io.open ("/tank/version.txt", "w")
      d:write(version .. " BETA")
      d:close()
    end
    print()
  end
  local d = io.open ("/bin/tank.lua", "w")
  d:write('-- pastebin run -f cyF0yhXZ\n')
  d:write('-- von Nex4rius\n')
  d:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
  d:write('\n')
  d:write('loadfile("/autorun.lua")(require("shell").parse(...)[1])\n')
  d:close()
  if updateKomplett then
    print("\nUpdate vollständig\n" .. version .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
  else
    print("\nERROR install / update failed\n")
  end
  for i = 10, 1, -1 do
    print("Neustart in ... " .. i)
    os.sleep(1)
  end
  require("computer").shutdown(true)
end

function f.Komponenten(typ)
  print("\nPrüfe Komponenten\n")
  if component.isAvailable("internet") then
    gpu.setForeground(0x00FF00)
    print("Internetkarte                     - OK")
  else
    gpu.setForeground(0xFF0000)
    print("Internetkarte                     - fehlt")
  end
  if component.isAvailable("modem") then
    gpu.setForeground(0x00FF00)
    if component.modem.isWireless() then
      print("WLAN-Karte                        - OK")
    else
      print("WLAN-Karte                        - fehlt")
      print("Netzwerkkarte                     - OK")
    end
  else
    gpu.setForeground(0xFF0000)
    print("Netzwerkkarte                     - fehlt")
  end
  if typ == "server" then
    if gpu.maxResolution() == 160 then
      gpu.setForeground(0x00FF00)
      print("Grafikkarte Tier III              - OK")
      print("Bildschirm Tier III               - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Grafikkarte Tier III              - fehlt")
      print("Bildschirm Tier III               - fehlt")
    end
  else
    if component.isAvailable("tank_controller") then
      gpu.setForeground(0x00FF00)
      print("Adapter + Tank Controller Upgrade - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Adapter + Tank Controller Upgrade - fehlt")
    end
    if component.isAvailable("transposer") then
      gpu.setForeground(0x00FF00)
      print("Transposer                        - OK")
    else
      gpu.setForeground(0xFF0000)
      print("Transposer                        - fehlt")
    end
  end
  print()
  gpu.setForeground(0xFFFFFF)
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
