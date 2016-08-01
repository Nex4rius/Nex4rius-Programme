version = "2.2.3"
component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")
r = require("robot")
chunkloaderstatus = false
generatorstatus = false
serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Wither-killing-programm/"
versionTyp = "master/"
Sprache = ""

os.execute("del wither/sprache.lua")

dofile("wither/sicherNachNeustart.lua")

function schreibSicherungsdatei()
  f = io.open ("wither/sicherNachNeustart.lua", "w")
  f:write('NetherStar = ' .. NetherStar .. '\n')
  f:write('Sprache = "' .. string.lower(Sprache) .. '" -- Deutsch / English\n')
  f:close ()
end

if Sprache == "" then
  print("Sprache? / Language? Deutsch / English\n")
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

dofile("wither/sprache/" .. Sprache .. ".lua")

function checkKomponenten()
  print(pruefeKomponenten)
  if component.isAvailable("chunkloader") then
    c = component.chunkloader
    chunkloaderstatus = true
    print(chunkloaderOK)
  else
    chunkloaderstatus = false
    print(chunkloaderFehlt)
  end
  if component.isAvailable("generator") then
    g = component.generator
    generatorstatus = true
    print(generatorOK)
  else
    generatorstatus = false
    print(generatorFehlt)
  end
  if component.isAvailable("internet") then
    print(InternetOK)
    internet = true
  else
    print(InternetFehlt)
    internet = false
  end
  if component.isAvailable("inventory_controller") then
    print(inventory_controllerOK)
    inv = component.inventory_controller
    return true
  else
    print(inventory_controllerFehlt)
    return false
  end
end

function update()
  fs.makeDirectory("/wither")
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -f " .. Pfad .. "autorun.lua autorun.lua") print("")
  os.execute("wget -f " .. Pfad .. "wither/wither.lua wither/wither.lua") print("")
  os.execute("wget -f " .. Pfad .. "wither/check.lua wither/check.lua") print("")
  os.execute("wget -f " .. Pfad .. "wither/sprache.lua wither/sprache/deutsch.lua") print("")
  os.execute("wget -f " .. Pfad .. "wither/sprache.lua wither/sprache/english.lua") print("")
  os.execute("wget " .. Pfad .. "wither/sicherNachNeustart.lua wither/sicherNachNeustart.lua") print("")
  os.execute("reboot")
end

function checkServerVersion()
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -fQ " .. Pfad .. "wither/version.txt version.txt")
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
  os.execute("wget -fQ " .. Pfad .. "wither/version.txt betaVersion.txt")
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
    print(derzeitigeVersion .. version .. verfuegbareVersion .. checkServerVersion())
    if checkServerVersion() == checkBetaServerVersion() then else
      print(betaVersion .. checkBetaServerVersion())
    end
    print("\n" .. AnzahlNetherStar .. NetherStar .. "\n")
    if version == checkServerVersion() and version == checkBetaServerVersion() then
    elseif installieren == nil then
      print(aktualisierenFrage)
      antwortFrage = io.read()
      if string.lower(antwortFrage) == ja then
        print(aktualisierenJa)
        update()
      elseif antwortFrage == "beta" then
        versionTyp = "beta/"
        print(aktualisierenBeta)
        update()
      else
        print(aktualisierenNein .. antwortFrage)
      end
    end
  end
  print(laden)
  dofile("wither/wither.lua")
end
