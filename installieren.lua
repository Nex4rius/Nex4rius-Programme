Sprache = ""
control = "On"
firstrun = -2
Sprache = ""
installieren = false
fs = require("filesystem")

if fs.exists("/stargate/sicherNachNeustart.lua") then
  dofile("/stargate/sicherNachNeustart.lua")
end

function Pfad()
  return serverAddresse .. versionTyp
end

function installieren()
  fs.makeDirectory("/stargate/sprache")
  serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
  if versionTyp == nil then
    versionTyp = "master"
  end
  os.execute("wget -f " .. Pfad() .. "/autorun.lua autorun.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/Kontrollprogramm.lua /stargate/Kontrollprogramm.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/compat.lua /stargate/compat.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/config.lua /stargate/config.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/check.lua /stargate/check.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/version.txt /stargate/version.txt") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/sprache/deutsch.lua /stargate/sprache/deutsch.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/sprache/english.lua /stargate/sprache/english.lua") print("")
  os.execute("wget -f " .. Pfad() .. "/stargate/sprache/ersetzen.lua /stargate/sprache/ersetzen.lua") print("")
  os.execute("wget    " .. Pfad() .. "/stargate/adressen.lua /stargate/adressen.lua") print("")
  os.execute("wget    " .. Pfad() .. "/stargate/sicherNachNeustart.lua /stargate/sicherNachNeustart.lua") print("")
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
  print(versionTyp)
  os.sleep(2)
  if versionTyp == "beta" then
    print("jap")
    f = io.open ("/version.txt", "r")
    version = f:read()
    print(version)
    os.sleep(2)
    f:close()
    f = io.open ("/version.txt", "w")
    f:write(version .. " Beta")
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
