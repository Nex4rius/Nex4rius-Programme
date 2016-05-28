fs = require("filesystem")
fs.makeDirectory("/stargate/sprache")
serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
if versionTyp == nil then
  versionTyp = "master/"
end
print("")
Pfad = serverAddresse .. versionTyp
os.execute("wget -f " .. Pfad .. "autorun.lua autorun.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/Kontrollprogramm.lua /stargate/Kontrollprogramm.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/compat.lua /stargate/compat.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/config.lua /stargate/config.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/check.lua /stargate/check.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/sprache/deutsch.lua /stargate/sprache/deutsch.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/sprache/english.lua /stargate/sprache/english.lua") print("")
os.execute("wget -f " .. Pfad .. "stargate/sprache/ersetzen.lua /stargate/sprache/ersetzen.lua") print("")
os.execute("wget " .. Pfad .. "stargate/adressen.lua /stargate/adressen.lua") print("")
os.execute("wget " .. Pfad .. "stargate/sicherNachNeustart.lua /stargate/sicherNachNeustart.lua") print("")
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
f:close ()
if string.sub(readAddresses, AdressesLength, AdressesLength) == " " then
  f = io.open ("/stargate/adressen.lua", "a")
  f:seek ("end", -1)
  f:write("")
  f:close ()
end
installieren = true
os.execute("del -v installieren.lua")
print("\n\n" .. Neustart)
os.execute("autorun.lua")
