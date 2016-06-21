-- pastebin run -f fa9gu1GJ
-- von Nex4rius

fs = require("filesystem")
wget = loadfile("/bin/wget.lua")
Sprache = ""
control = "On"
firstrun = -2
Sprache = ""
installieren = false
serverAddresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"

if fs.exists("/stargate/sicherNachNeustart.lua") then
  dofile("/stargate/sicherNachNeustart.lua")
end

function Pfad()
  return serverAddresse .. versionTyp
end

function installieren()
  fs.makeDirectory("/stargate/sprache")
  if versionTyp == nil then
    versionTyp = "master"
  end
  wget("-f", Pfad() .. "/autorun.lua", "autorun.lua")
  wget("-f", Pfad() .. "/stargate/Kontrollprogramm.lua", "/stargate/Kontrollprogramm.lua")
  wget("-f", Pfad() .. "/stargate/compat.lua", "/stargate/compat.lua")
  wget("-f", Pfad() .. "/stargate/config.lua", "/stargate/config.lua")
  wget("-f", Pfad() .. "/stargate/check.lua", "/stargate/check.lua")
  wget("-f", Pfad() .. "/stargate/version.txt", "/stargate/version.txt")
  wget("-f", Pfad() .. "/stargate/sprache/deutsch.lua", "/stargate/sprache/deutsch.lua")
  wget("-f", Pfad() .. "/stargate/sprache/english.lua", "/stargate/sprache/english.lua")
  wget("-f", Pfad() .. "/stargate/sprache/ersetzen.lua", "/stargate/sprache/ersetzen.lua")
  if not fs.exists("/stargate/adressen.lua") then
    wget(Pfad() .. "/stargate/adressen.lua", "/stargate/adressen.lua")
  end
  if not fs.exists("/stargate/sicherNachNeustart.lua") then
    wget(Pfad() .. "/stargate/sicherNachNeustart.lua", "/stargate/sicherNachNeustart.lua")
  end
  f = io.open ("/stargate/adressen.lua", "r")
  addressRead = true
  leseLaenge = 1000
  while addressRead == true do
    readAddresses = f:read(leseLaenge)
    AdressesLength = string.len(readAddresses)
    if AdressesLength == leseLaenge then
      leseLaenge = leseLaenge * 2
    else
      addressRead = false
    end
  end
  f:close()
  if string.sub(readAddresses, AdressesLength, AdressesLength) == " " then
    f = io.open ("/stargate/adressen.lua", "a")
    f:seek ("end", -1)
    f:write("")
    f:close()
  end
  if versionTyp == "beta" then
    f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
    f = io.open ("/stargate/version.txt", "w")
    f:write(version .. " BETA")
    f:close()
  end
  os.execute("del -v installieren.lua")
  installieren = true
  schreibSicherungsdatei()
  os.execute("reboot")
end

function schreibSicherungsdatei()
  f = io.open ("/stargate/sicherNachNeustart.lua", "w")
  f:write('control = "' .. control .. '"\n')
  f:write('firstrun = ' .. firstrun .. '\n')
  f:write('Sprache = "' .. Sprache .. '" -- deutsch / english\n')
  f:write('installieren = ' .. tostring(installieren) .. '\n')
  f:close()
end

installieren()
