-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local fs = require("filesystem")
local wget = loadfile("/bin/wget.lua")
local move = loadfile("/bin/mv.lua")
local serverAdresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"

if fs.exists("/stargate/Sicherungsdatei.lua") then
  local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  local Sprache = ""
  local control = "On"
  local autoUpdate = false
  local installieren = false
end

local function Pfad(versionTyp)
  return serverAdresse .. versionTyp
end

local function installieren()
  fs.makeDirectory("/update/stargate/sprache")
  if versionTyp == nil then
    local versionTyp = "master"
  end
  local update = {}
  local updateKomplett = false
  update[1] = wget("-f", Pfad(versionTyp) .. "/autorun.lua",                        "/update/autorun.lua")
  update[2] = wget("-f", Pfad(versionTyp) .. "/stargate/check.lua",                 "/update/stargate/check.lua")
  update[3] = wget("-f", Pfad(versionTyp) .. "/stargate/version.txt",               "/update/stargate/version.txt")
  update[4] = wget("-f", Pfad(versionTyp) .. "/stargate/Kontrollprogramm.lua",      "/update/stargate/Kontrollprogramm.lua")
  update[5] = wget("-f", Pfad(versionTyp) .. "/stargate/schreibSicherungsdatei.lua","/update/stargate/schreibSicherungsdatei.lua")
  update[6] = wget("-f", Pfad(versionTyp) .. "/stargate/sprache/deutsch.lua",       "/update/stargate/sprache/deutsch.lua")
  update[7] = wget("-f", Pfad(versionTyp) .. "/stargate/sprache/english.lua",       "/update/stargate/sprache/english.lua")
  update[8] = wget("-f", Pfad(versionTyp) .. "/stargate/sprache/ersetzen.lua",      "/update/stargate/sprache/ersetzen.lua")
  update[9] = wget("-f", Pfad(versionTyp) .. "/stargate/adressen.lua",              "/update/stargate/adressen.lua")
  update[10]= wget("-f", Pfad(versionTyp) .. "/stargate/Sicherungsdatei.lua",       "/update/stargate/Sicherungsdatei.lua")
  for i = 1, 10 do
    if update[i] == true then
      updateKomplett = true
    else
      updateKomplett = false
      break
    end
  end
  if updateKomplett == true then
    fs.makeDirectory("/stargate/sprache")
    move("-f", "/update/autorun.lua",                         "/autorun.lua")
    move("-f", "/update/stargate/check.lua",                  "/stargate/check.lua")
    move("-f", "/update/stargate/version.txt",                "/stargate/version.txt")
    move("-f", "/update/stargate/Kontrollprogramm.lua",       "/stargate/Kontrollprogramm.lua")
    move("-f", "/update/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
    move("-f", "/update/stargate/sprache/deutsch.lua",        "/stargate/sprache/deutsch.lua")
    move("-f", "/update/stargate/sprache/english.lua",        "/stargate/sprache/english.lua")
    move("-f", "/update/stargate/sprache/ersetzen.lua",       "/stargate/sprache/ersetzen.lua")
    move(      "/update/stargate/adressen.lua",               "/stargate/adressen.lua")
    move(      "/update/stargate/Sicherungsdatei.lua",        "/stargate/Sicherungsdatei.lua")
  end
  loadfile("/bin/rm.lua")("-v", "/update")
  if versionTyp == "beta" then
    f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
    f = io.open ("/stargate/version.txt", "w")
    f:write(version .. " BETA")
    f:close()
  end
  installieren = true
  loadfile("/stargate/schreibSicherungsdatei.lua")(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  loadfile("/bin/rm.lua")("-v", "installieren.lua")
  --loadfile("/autorun.lua")("no")
  --os.exit()
  require("computer").shutdown(true)
end

if fs.exists("/stargate/sicherNachNeustart.lua") then
  if fs.exists("/stargate/adressen.lua") then
    dofile("/stargate/adressen.lua")
  end
  f = io.open("/stargate/adressen.lua", "w")
  f:write('-- pastebin run -f fa9gu1GJ\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n')
  f:write('-- Put your own stargate addresses here\n')
  f:write('-- "" for no Iris Code\n')
  f:write('--\n\n')
  f:write('return {\n')
  f:write('--{"<Name>","<Adresse>","<IDC>"},\n')
  for k in pairs(adressen) do
    f:write("  " .. require("serialization").serialize(adressen[k]) .. ",\n")
  end
  f:write('}')
  f:close()
  dofile("/stargate/sicherNachNeustart.lua")
  loadfile("/bin/rm.lua")("/stargate/sicherNachNeustart.lua")
end

installieren()
