-- pastebin run -f fa9gu1GJ
-- von Nex4rius

component = require("component")
sides = require("sides")
term = require("term")
event = require("event")
fs = require("filesystem")
c = require("computer")
shell = require("shell")
wget = loadfile("/bin/wget.lua")
gpu = component.getPrimary("gpu")
args = shell.parse(...)
serverAddresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"
versionTyp = "master"
Sprache = ""
control = "On"
firstrun = -2
Sprache = ""
installieren = false
betaVersionName = ""

if fs.exists("/stargate/version.txt") then
  f = io.open ("/stargate/version.txt", "r")
  version = f:read()
  f:close()
else
  version = fehlerName
end

dofile("/stargate/sicherNachNeustart.lua")

os.execute("label -a " .. c.getBootAddress() .. " StargateOS")

term.clear()

function schreibSicherungsdatei()
  f = io.open ("/stargate/sicherNachNeustart.lua", "w")
  f:write('control = "' .. control .. '"\n')
  f:write('firstrun = ' .. firstrun .. '\n')
  f:write('Sprache = "' .. Sprache .. '" -- deutsch / english\n')
  f:write('installieren = ' .. tostring(installieren) .. '\n')
  f:close()
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
    print(StargateFehlt)
    return false
  end
end

function Pfad()
  return serverAddresse .. versionTyp
end

function update(versionTyp)
  wget("-f", Pfad() .. "/installieren.lua", "/installieren.lua")
  installieren = true
  schreibSicherungsdatei()
  f = io.open ("autorun.lua", "w")
  f:write('versionTyp = "' .. versionTyp .. '"\n')
  f:write('dofile("installieren.lua")')
  f:close()
  os.execute("reboot")
end

function checkServerVersion()
  versionTyp = "master"
  wget("-fQ", Pfad() .. "/stargate/version.txt", "/serverVersion.txt")
  if fs.exists("/serverVersion.txt") then
    f = io.open ("/serverVersion.txt", "r")
    serverVersion = f:read()
    f:close()
    os.execute("del serverVersion.txt")
  else
    serverVersion = fehlerName
  end
  return serverVersion
end

function checkBetaServerVersion()
  versionTyp = "beta"
  wget("-fQ", Pfad() .. "/stargate/version.txt", "/betaVersion.txt")
  if fs.exists("/betaVersion.txt") then
    f = io.open ("/betaVersion.txt", "r")
    betaServerVersion = f:read()
    f:close()
    os.execute("del /betaVersion.txt")
  else
    betaServerVersion = fehlerName
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
      print(betaVersion .. betaServerVersion .. " BETA")
      if betaServerVersion == fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if args[1] == ja then
      update("master")
    elseif args[1] == nein then
      -- nichts
    elseif args[1] == "beta" then
      update("beta")
    else
      if version == serverVersion and version == betaServerVersion then
      elseif installieren == false then
        print(aktualisierenFrage .. betaVersionName .. "\n")
        antwortFrage = io.read()
      end
      if string.lower(antwortFrage) == ja then
        print(aktualisierenJa)
        update("master")
        return
      elseif antwortFrage == "beta" then
        print(aktualisierenBeta)
        update("beta")
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

if args[1] == hilfe then
  print(Hilfetext)
else
  if checkKomponenten() == true then
    mainCheck()
  end
end
