-- pastebin run -f cyF0yhXZ
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/

require("shell").setWorkingDirectory("/")

local fs          = require("filesystem")
local arg         = require("shell").parse(...)[1]
local wget        = loadfile("/bin/wget.lua")
local copy        = loadfile("/bin/cp.lua")
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
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Tank/" .. typ .. "/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Tank/" .. typ .. "/"
  end
end

function Funktionen.installieren(versionTyp)
  if versionTyp == "server" or versionTyp == "client" then
    typ = versionTyp
    versionTyp = "master"
  else
    local weiter = true
    while weiter do
      print("server or client?")
      weiter = io.read()
      if weiter == "server" or weiter == "client" then
        typ = weiter
      else
        weiter = true
      end
    end
  end
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local update = {}
  update[1]   = wget("-f", Funktionen.Pfad(versionTyp) .. "autorun.lua",   "/update/autorun.lua")
  if typ == "client" then
    update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "auslesen.lua", "/update/tank/auslesen.lua")
  else
    update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "anzeige.lua",  "/update/tank/anzeige.lua")
  end
  update[3]   = wget("-f", Funktionen.Pfad(versionTyp) .. "version.txt",  "/update/tank/version.txt")
  for i = 1, 3 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
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
      f:write('require("shell").setWorkingDirectory(alterPfad)\n')
      f:close()
      break
    end
  end
  if updateKomplett then
    copy("/update/autorun.lua",       "/autorun.lua")
    copy("/update/tank/version.txt",  "/tank/version.txt")
    if typ == "client" then
      copy("/update/tank/auslesen.lua", "/tank/auslesen.lua")
    else
      copy("/update/tank/anzeige.lua",  "/tank/anzeige.lua")
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
  if fs.exists("/home") then
    local f = io.open ("/home/tank", "w")
    f:write('-- pastebin run -f cyF0yhXZ\n')
    f:write('-- von Nex4rius\n')
    f:write('-- https://github.com/Nex4rius/Nex4rius-Programme\n')
    f:write('\n')
    f:write('loadfile("/autorun.lua")(require("shell").parse(...)[1])\n')
    f:close()
  end
  if updateKomplett then
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
    require("computer").shutdown(true)
  else
    print("\nERROR install / update failed\n")
  end
end

if versionTyp == nil then
  if type(arg) == "string" then
    if arg == "client" or arg == "server" then else
      arg = "master"
    end
    Funktionen.installieren(arg)
  else
    Funktionen.installieren("master")
  end
else
  Funktionen.installieren(versionTyp)
end
