version = "1.8.4"
component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")
gpu = component.getPrimary("gpu")
serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
versionTyp = "master/"
Sprache = ""

dofile("stargate/sicherNachNeustart.lua")

function schreibSicherungsdatei()
  f = io.open ("stargate/sicherNachNeustart.lua", "w")
  f:write('control = "' .. control .. '"\n')
  f:write('firstrun = ' .. firstrun .. '\n')
  f:write('Sprache = "' .. Sprache .. '" -- deutsch / english\n')
  f:close ()
end

if Sprache == "" then
  print("Sprache? / Language? deutsch / english\n")
  antwortFrageSprache = io.read()
  if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
    Sprache = string.lower(antwortFrageSprache)
  else
    print("\nUnbekannte Eingabe\nStandardeinstellung = deutsch")
    Sprache = "deutsch"
  end
  schreibSicherungsdatei()
  print("")
end

dofile("stargate/sprache/" .. Sprache .. ".lua")

function checkKomponenten()
  print(pruefeKomponenten)
  if component.isAvailable("redstone") then
    print(redstoneOK)
    r = component.getPrimary("redstone")
    redst = true
  else
    print(redstoneFehlt)
    r = nil
    redst = false
  end
  if gpu.maxResolution() > 50 then
    print(gpuOK)
  else
    print(gpuFehlt)
  end
  if component.isAvailable("internet") then
    print(InternetOK)
    internet = true
  else
    print(InternetFehlt)
    internet = false
  end
  if component.isAvailable("stargate") then
    print(StargateOK)
    sg = component.getPrimary("stargate")
    return true
  else
    print(StargateOK)
    return false
  end
end

function update()
  fs.makeDirectory("/stargate")
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -f " .. Pfad .. "autorun.lua autorun.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/Kontrollprogramm.lua stargate/Kontrollprogramm.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/compat.lua stargate/compat.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/config.lua stargate/config.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/check.lua stargate/check.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/sprache/deutsch.lua stargate/sprache/deutsch.lua") print("")
  os.execute("wget -f " .. Pfad .. "stargate/sprache/english.lua stargate/sprache/english.lua") print("")
  os.execute("wget " .. Pfad .. "stargate/adressen.lua stargate/adressen.lua") print("")
  os.execute("wget " .. Pfad .. "sicherNachNeustart.lua stargate/sicherNachNeustart.lua") print("")
  f = io.open ("stargate/adressen.lua", "r")
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
    f = io.open ("stargate/adressen.lua", "a")
    f:seek ("end", -1)
    f:write("")
    f:close ()
  end
  dofile("stargate/sprache/" .. Sprache .. ".lua")
  print(laden)
  dofile("stargate/Kontrollprogramm.lua")
end

function checkServerVersion()
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -fQ " .. Pfad .. "stargate/version.txt version.txt")
  f = io.open ("version.txt", "r")
  serverVersion = f:read(5)
  f:close ()
  os.execute("del version.txt")
  if serverVersion == nil then
    serverVersion = "<ERROR>"
  end
  return serverVersion
end

function checkBetaServerVersion()
  Pfad = serverAddresse .. "beta/"
  os.execute("wget -fQ " .. Pfad .. "stargate/version.txt betaVersion.txt")
  f = io.open ("betaVersion.txt", "r")
  betaServerVersion = f:read(5)
  f:close ()
  os.execute("del betaVersion.txt")
  if betaServerVersion == nil then
    betaServerVersion = "<ERROR>"
  end
  return betaServerVersion
end

if checkKomponenten() == true then
  if internet == true then
    serverVersion = checkServerVersion()
    betaServerVersion = checkBetaServerVersion()
    if serverVersion == betaServerVersion then
      print(derzeitigeVersion .. version .. verfuegbareVersion .. serverVersion)
    else
      print(derzeitigeVersion .. version .. verfuegbareVersion .. serverVersion)
      print(betaVersion .. betaServerVersion)
    end
    if version == serverVersion and version == betaServerVersion then
    elseif installieren == nil then
      print(aktualisierenFrage)
      antwortFrage = io.read()
      if string.lower(antwortFrage) == ja then
        print(aktualisierenJa)
        update()
        return
      elseif antwortFrage == "beta" then
        versionTyp = "beta/"
        print(aktualisierenBeta)
        update()
        return
      else
        print(aktualisierenNein .. antwortFrage)
      end
    end
  end
  print(laden)
  dofile("stargate/Kontrollprogramm.lua")
end
