-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

require("shell").setWorkingDirectory("/")

local fs          = require("filesystem")
local arg         = require("shell").parse(...)[1]
local wget        = loadfile("/bin/wget.lua")
local kopieren    = loadfile("/bin/cp.lua")
local Sicherung   = {}
local Funktionen  = {}
local sprachen
local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate

if not fs.exists("/einstellungen") then
    fs.makeDirectory("/einstellungen")
end
if not fs.exists("/einstellungen/adressen.lua") then
    kopieren("-n", "/stargate/adressen.lua", "/einstellungen/adressen.lua")
end
if not fs.exists("/einstellungen/Sicherungsdatei.lua") then
    kopieren("-n", "/stargate/Sicherungsdatei.lua", "/einstellungen/Sicherungsdatei.lua")
end

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

local Sprachliste = {"deutsch", "english", "russian", "czech", Sicherung.Sprache}

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

function Funktionen.schreibAutorun()
  local f = io.open ("/autorun.lua", "w")
  f:write([[
  -- pastebin run -f YVqKFnsP
  -- von Nex4rius
  -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

  local shell = require("shell")
  local alterPfad = shell.getWorkingDirectory("/")
  local args = shell.parse(...)[1]

  shell.setWorkingDirectory("/")
  
  if type(args) == "string" then
    loadfile("/stargate/check.lua")(args)
  else
    loadfile("/stargate/check.lua")()
  end

  require("shell").setWorkingDirectory(alterPfad)
  ]])
  f:close()
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
  update[8] = wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  for s in pairs(Sprachliste) do
    if Sprachliste[s] ~= "" then
      if wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/" .. Sprachliste[s] .. ".lua", "/update/stargate/sprache/" .. Sprachliste[s] .. ".lua") then
        update[9] = true
      end
    end
  end
  for i = 1, 9 do
    if update[i] then
      updateKomplett = true
    else
      updateKomplett = false
      if sprachen then
        print(sprachen.fehlerName .. " " .. i)
      end
      Funktionen.schreibAutorun()
      break
    end
  end
  if updateKomplett then
    fs.makeDirectory("/stargate/sprache")
    kopieren("/update/autorun.lua",                         "/autorun.lua")
    kopieren("/update/stargate/check.lua",                  "/stargate/check.lua")
    kopieren("/update/stargate/version.txt",                "/stargate/version.txt")
    if fs.exists("/stargate/adressen.lua") == false then
      kopieren("/update/stargate/adressen.lua",              "/stargate/adressen.lua", "-n")
    end
    if fs.exists("/stargate/Sicherungsdatei.lua") == false then
      kopieren("/update/stargate/Sicherungsdatei.lua",       "/stargate/Sicherungsdatei.lua", "-n")
    end
    kopieren("/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    kopieren("/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    kopieren("/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    for s in pairs(Sprachliste) do
      if Sprachliste[s] ~= "" then
        kopieren("/update/stargate/sprache/" .. Sprachliste[s] .. ".lua", "/stargate/sprache/" .. Sprachliste[s] .. ".lua")
      end
    end
    f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
    if versionTyp == "beta" then
      f = io.open ("/stargate/version.txt", "w")
      f:write(version .. " BETA")
      f:close()
    end
    Sicherung.installieren = true
    loadfile("/stargate/schreibSicherungsdatei.lua")(Sicherung)
    print()
  end
  local f = io.open ("/bin/stargate.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n')
  f:write('\n')
  f:write('if not pcall(loadfile("/autorun.lua"), require("shell").parse(...)[1]) then\n')
  f:write('   loadfile("/bin/wget-lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua")\n')
  f:write('   loadfile("/bin/github.lua")("Nex4rius", "Nex4rius-Programme", "master", "Stargate-Programm")\n')
  f:write('end\n')
  f:close()
  if updateKomplett then
    loadfile("/bin/rm.lua")("-v", "/update", "-r")
    loadfile("/bin/rm.lua")("-v", "/installieren.lua")
    print("\nUpdate komplett\n" .. version .. " " .. string.upper(tostring(versionTyp)))
    os.sleep(2)
  else
    print("\nERROR install / update failed\n")
    print("10s bis Neustart")
    os.sleep(10)
  end  
  if _OSVERSION ~= "OpenOS 1.6.1" then
    --print("\nUpdating OpenOS\n")
    --os.sleep(5)
    --loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/OpenOS-Updater/updater.lua", "/updater.lua")
    --loadfile("/updater.lua")()
    --
    --loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua")
    --loadfile("/bin/github.lua")("MightyPirates", "OpenComputers", "master-MC1.7.10", "src/main/resources/assets/opencomputers/loot/openos/", "41acf2fa06990dcc4d740490cccd9d2bcec97edd")
  end
  require("computer").shutdown(true)
end

if versionTyp == nil then
  if arg == "neu" then
    loadfile("/bin/rm.lua")("-v", "/stargate", "-r")
    loadfile("/bin/rm.lua")("-v", "/update", "-r")
    local f = io.open ("/autorun.lua", "w")
    f:write([[
      -- pastebin run -f YVqKFnsP
      -- von Nex4rius
      -- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm
      
      wget("-f", Funktionen.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
      loadfile("/installieren.lua")()
    ]])
    f:close()
    Funktionen.installieren("master")
  elseif type(arg) == "string" then
    Funktionen.installieren(arg)
  else
    Funktionen.installieren("master")
  end
else
  Funktionen.installieren(versionTyp)
end
