version = "1.9.4"
component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")
c = require("computer")
gpu = component.getPrimary("gpu")
serverAddresse = "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/"
versionTyp = "master/"
Sprache = ""
control = "On"
firstrun = -2
Sprache = ""
installieren = false

dofile("/stargate/sicherNachNeustart.lua")

os.execute("label -a " .. c.getBootAddress() .. " StargateOS")

term.clear()

function schreibSicherungsdatei()
  f = io.open ("/stargate/sicherNachNeustart.lua", "w")
  f:write('control = "' .. control .. '"\n')
  f:write('firstrun = ' .. firstrun .. '\n')
  f:write('Sprache = "' .. Sprache .. '" -- deutsch / english\n')
  f:write('installieren = ' .. tostring(installieren) .. '\n')
  f:close ()
end

function checkSprache()
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
  if gpu.maxResolution() == 80 then
    print(gpuOK2T)
  elseif gpu.maxResolution() == 160 then
    graphicT3 = true
    print(gpuOK3T)
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
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -f " .. Pfad .. "installieren.lua installieren.lua")
  installieren = true
  schreibSicherungsdatei()
  f = io.open ("autorun.lua", "w")
  f:write('versionTyp = "' .. versionTyp .. '"\n')
  f:write('dofile("installieren.lua")')
  f:close ()
  os.execute("reboot")
end

function checkServerVersion()
  Pfad = serverAddresse .. versionTyp
  os.execute("wget -fQ " .. Pfad .. "stargate/version.txt version.txt")
  f = io.open ("/version.txt", "r")
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
  f = io.open ("/betaVersion.txt", "r")
  betaServerVersion = f:read(5)
  f:close ()
  os.execute("del /betaVersion.txt")
  if betaServerVersion == nil then
    betaServerVersion = "<ERROR>"
  end
  return betaServerVersion
end

function mainCheck()
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
    elseif installieren == false then
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
  installieren = false
  schreibSicherungsdatei()
  dofile("/stargate/Kontrollprogramm.lua")
end

if Sprache == "" then
  checkSprache()
end

dofile("/stargate/sprache/" .. Sprache .. ".lua")

if checkKomponenten() == true then
  mainCheck()
end
