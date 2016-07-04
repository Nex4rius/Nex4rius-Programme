-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

fs = require("filesystem")
wget = loadfile("/bin/wget.lua")
serverAdresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"

if fs.exists("/stargate/Sicherungsdatei.lua") then
  IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  Sprache = ""
  control = "On"
  autoUpdate = false
  installieren = false
end

function Pfad(versionTyp)
  return serverAdresse .. versionTyp
end

function installieren()
  fs.makeDirectory("/stargate/sprache")
  if versionTyp == nil then
    versionTyp = "master"
  end
  wget("-f", Pfad(versionTyp) .. "/autorun.lua", "autorun.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/check.lua", "/stargate/check.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/version.txt", "/stargate/version.txt")
  wget("-f", Pfad(versionTyp) .. "/stargate/Kontrollprogramm.lua", "/stargate/Kontrollprogramm.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/schreibSicherungsdatei.lua", "/stargate/schreibSicherungsdatei.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/sprache/deutsch.lua", "/stargate/sprache/deutsch.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/sprache/english.lua", "/stargate/sprache/english.lua")
  wget("-f", Pfad(versionTyp) .. "/stargate/sprache/ersetzen.lua", "/stargate/sprache/ersetzen.lua")
  if not fs.exists("/stargate/adressen.lua") then
    wget(Pfad(versionTyp) .. "/stargate/adressen.lua", "/stargate/adressen.lua")
  end
  if not fs.exists("/stargate/Sicherungsdatei.lua") then
    wget(Pfad(versionTyp) .. "/stargate/Sicherungsdatei.lua", "/stargate/Sicherungsdatei.lua")
  end
  if versionTyp == "beta" then
    f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
    f = io.open ("/stargate/version.txt", "w")
    f:write(version .. " BETA")
    f:close()
  end
  loadfile("/bin/rm.lua")("-v", "installieren.lua")
  installieren = true
  loadfile("/stargate/schreibSicherungsdatei.lua")(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
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
  for k, v in pairs(adressen) do
    f:write("  " .. require("serialization").serialize(adressen[k]) .. ",\n")
  end
  f:write('}')
  f:close()
  dofile("/stargate/sicherNachNeustart.lua")
  loadfile("/bin/rm.lua")("/stargate/sicherNachNeustart.lua")
end

installieren()
