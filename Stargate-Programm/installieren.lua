-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local fs          = require("filesystem")
local arg         = require("shell").parse(...)[1]
local wget        = loadfile("/bin/wget.lua")
local move        = loadfile("/bin/mv.lua")
local Sicherung   = {}
local Funktionen  = {}
local sprachen
local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate

if fs.exists("/stargate/Sicherungsdatei.lua") then
  Sicherung = loadfile("/stargate/Sicherungsdatei.lua")()
  if type(Sicherung) == "string" then
    Sicherung = {}
    Sicherung.IDC, Sicherung.autoclosetime, Sicherung.RF, Sicherung.Sprache, Sicherung.side, Sicherung.installieren, Sicherung.control, Sicherung.autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
  end
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
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Stargate-Programm/"
  else
    return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/Stargate-Programm/"
  end
end

function Funktionen.installieren(versionTyp)
  fs.makeDirectory("/update/stargate/sprache")
  local updateKomplett = false
  local update = {}
  update[1] = wget("-f", Funktionen.Pfad(versionTyp) .. "autorun.lua",                        "/update/autorun.lua")
  update[2] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/check.lua",                 "/update/stargate/check.lua")
  update[3] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/version.txt",               "/update/stargate/version.txt")
  update[4] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/adressen.lua",              "/update/stargate/adressen.lua")
  update[5] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/Sicherungsdatei.lua",       "/update/stargate/Sicherungsdatei.lua")
  update[6] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/Kontrollprogramm.lua",      "/update/stargate/Kontrollprogramm.lua")
  update[7] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/schreibSicherungsdatei.lua","/update/stargate/schreibSicherungsdatei.lua")
  update[8] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/deutsch.lua",       "/update/stargate/sprache/deutsch.lua")
  update[9] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/english.lua",       "/update/stargate/sprache/english.lua")
  update[10]= wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  for i = 1, 10 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      end
      local f = io.open ("/autorun.lua", "w")
      f:write('-- pastebin run -f Dkt9dn4S\n')
      f:write('-- von Nex4rius\n')
      f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n\n')
      f:write('local args = require("shell").parse(...)[1]\n\n')
      f:write('if type(args) == "string" then\n')
      f:write('  loadfile("/stargate/check.lua")(args)\n')
      f:write('else\n')
      f:write('  loadfile("/stargate/check.lua")()\n')
      f:write('end\n\n')
      f:close()
      break
    end
  end
  if updateKomplett then
    fs.makeDirectory("/stargate/sprache")
    --if sprachen then
    --  print(sprachen.Update)
    --end
    move("-f", "/update/autorun.lua",                         "/autorun.lua")
    move("-f", "/update/stargate/check.lua",                  "/stargate/check.lua")
    move("-f", "/update/stargate/version.txt",                "/stargate/version.txt")
    if fs.exists("/stargate/adressen.lua") == false then
      move(    "/update/stargate/adressen.lua",               "/stargate/adressen.lua")
    end
    if fs.exists("/stargate/Sicherungsdatei.lua") == false then
      move(    "/update/stargate/Sicherungsdatei.lua",        "/stargate/Sicherungsdatei.lua")
    end
    move("-f", "/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    move("-f", "/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    move("-f", "/update/stargate/sprache/deutsch.lua",        "/stargate/sprache/deutsch.lua")
    move("-f", "/update/stargate/sprache/english.lua",        "/stargate/sprache/english.lua")
    move("-f", "/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/stargate/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
  end
  Sicherung.installieren = true
  loadfile("/stargate/schreibSicherungsdatei.lua")(Sicherung)
  print()
  loadfile("/bin/rm.lua")("-v", "/update")
  loadfile("/bin/rm.lua")("-v", "/installieren.lua")
  --loadfile("/autorun.lua")("no")
  --os.exit()
  if updateKomplett then
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
  end
  os.sleep(2)
  require("computer").shutdown(true)
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
