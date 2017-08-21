-- pastebin run -f cyF0yhXZ
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

if fs.exists("/stargate/Sicherungsdatei.lua") then
  Sicherung = loadfile("/stargate/Sicherungsdatei.lua")()
else
  Sicherung.Sprache = ""
  Sicherung.installieren = false
end

if Sicherung.Sprache then
  if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
    sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  end
end

function Funktionen.Pfad(versionTyp)
  if versionTyp then
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Tank/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Tank/"
  end
end

function Funktionen.installieren(versionTyp)
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  require("term").clear()
  local weiter = true
  while weiter do
    print("\n\nserver (display) / client (adapter + tank)?\n")
    typ = io.read()
    if typ == "server" or typ == "client" then
      weiter = false
    else
      weiter = true
    end
  end
  Funktionen.Komponenten(typ)
  fs.makeDirectory("/tank")
  fs.makeDirectory("/update/tank")
  local updateKomplett = false
  local anzahl = 3
  local update = {}
  loadfile("/bin/pastebin.lua")("run", "-f", "63v6mQtK", versionTyp)
  update[1]   = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/autorun.lua",       "/update/autorun.lua")
  update[2]   = wget("-f", Funktionen.Pfad(versionTyp) ..        "/version.txt",       "/update/tank/version.txt")
  if typ == "client" then
    update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/auslesen.lua", "/update/tank/auslesen.lua")
    loadfile("/bin/pastebin.lua")("run", "-f", "ZbxDmMeC", versionTyp)
  else
    update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/farben.lua",   "/update/tank/farben.lua")
    update[4] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/anzeige.lua",  "/update/tank/anzeige.lua")
    update[5] = wget("-f", Funktionen.Pfad(versionTyp) .. typ .. "/tank/ersetzen.lua", "/update/tank/ersetzen.lua")
    anzahl = 5
  end
  for i = 1, anzahl do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      else
        print("Fehler " ..i)
      end
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
    copy("/update/autorun.lua",         "/autorun.lua")
    copy("/update/tank/version.txt",    "/tank/version.txt")
    if typ == "client" then
      copy("/update/tank/auslesen.lua", "/tank/auslesen.lua")
    else
      copy("/update/tank/anzeige.lua",  "/tank/anzeige.lua")
      copy("/update/tank/farben.lua",   "/tank/farben.lua")
      copy("/update/tank/ersetzen.lua", "/tank/ersetzen.lua")
    end
    f = io.open ("/tank/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/tank/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
    Sicherung.installieren = true
    --loadfile("/stargate/schreibSicherungsdatei.lua")(Sicherung)
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
  print("10s bis Neustart")
  os.sleep(10)
  require("computer").shutdown(true)
end

function Funktionen.Komponenten(typ)
  require("term").clear()
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
    print("Network Card - OK")
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
  end
  gpu.setForeground(0xFFFFFF)
  print("\npress enter to continue\n")
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
