-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

component = require("component")
term = require("term")
event = require("event")
fs = require("filesystem")
c = require("computer")
shell = require("shell")
wget = loadfile("/bin/wget.lua")
gpu = component.getPrimary("gpu")
args = shell.parse(...)
serverAddresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"
betaVersionName = ""
if fs.exists("/stargate/Sicherungsdatei.lua") then
  IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun = loadfile("/stargate/Sicherungsdatei.lua")()
else
  Sprache = ""
  control = "On"
  firstrun = -2
  installieren = false
end

if fs.exists("/stargate/version.txt") then
  f = io.open ("/stargate/version.txt", "r")
  version = f:read()
  f:close()
else
  version = fehlerName
end

term.clear()

function schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun)
  f = io.open ("/stargate/Sicherungsdatei.lua", "w")
  f:write('-- pastebin run -f fa9gu1GJ\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n\n')
  f:write('local IDC = "' .. tostring(IDC) .. '" -- Iris Deactivation Code\n')
  f:write('local autoclosetime = ' .. tostring(autoclosetime) .. ' -- in seconds -- false for no autoclose\n')
  f:write('local RF = ' .. tostring(RF) .. ' -- show energy in RF instead of EU\n')
  f:write('local Sprache = "' .. tostring(Sprache) .. '" -- deutsch / english\n')
  f:write('local side = "' .. tostring(side) .. '" -- bottom, top, back, front, right or left\n\n')
  f:write(string.rep("-", 70) .. '\n\n')
  f:write('local installieren = ' .. tostring(installieren) .. '\n')
  f:write('local control = "' .. tostring(control) .. '"\n')
  f:write('local firstrun = ' .. tostring(firstrun) .. '\n\n')
  f:write(string.rep("-", 70) .. '\n\n')
  f:write('if type(IDC) ~= "string" then\n  IDC = ""\nend\n')
  f:write('if type(autoclosetime) ~= "number" then\n  autoclosetime = false\nend\n')
  f:write('if type(RF) ~= "boolean" then\n  RF = false\nend\n')
  f:write('if type(Sprache) ~= "string" then\n  Sprache = ""\nend\n')
  f:write('if type(side) ~= "string" then\n  side = "unten"\nend\n')
  f:write('if type(installieren) ~= "boolean" then\n  installieren = false\nend\n')
  f:write('if type(control) ~= "string" then\n  control = "On"\nend\n')
  f:write('if type(firstrun) ~= "number" then\n  firstrun = -2\nend\n')
  f:write('if type(IDC) ~= "string" then\n  IDC = ""\nend\n\n')
  f:write('return IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun\n')
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
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun)
  print("")
end

function checkKomponenten()
  print(pruefeKomponenten)
  if component.isAvailable("redstone") then
    print(redstoneOK)
    r = component.getPrimary("redstone")
  else
    print(redstoneFehlt)
    r = nil
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

function Pfad(versionTyp)
  return serverAddresse .. versionTyp
end

function update(versionTyp)
  wget("-f", Pfad(versionTyp) .. "/installieren.lua", "/installieren.lua")
  installieren = true
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun)
  f = io.open ("autorun.lua", "w")
  f:write('versionTyp = "' .. versionTyp .. '"\n')
  f:write('dofile("installieren.lua")')
  f:close()
  os.execute("reboot")
end

function checkServerVersion()
  wget("-fQ", Pfad("master") .. "/stargate/version.txt", "/serverVersion.txt")
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
  wget("-fQ", Pfad("beta") .. "/stargate/version.txt", "/betaVersion.txt")
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
    print(derzeitigeVersion .. version .. verfuegbareVersion .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(betaVersion .. betaServerVersion .. " BETA")
      if betaServerVersion == fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if args[1] == ja or args[1] == "ja" or args[1] == "yes" then
      print(aktualisierenJa)
      update("master")
    elseif args[1] == nein or args[1] == "nein" or args[1] == "no" then
      -- nichts
    elseif args[1] == "beta" then
      print(aktualisierenBeta)
      update("beta")
    elseif version == serverVersion and version == betaServerVersion then else
      if installieren == false then
        print(aktualisierenFrage .. betaVersionName .. "\n")
        antwortFrage = io.read()
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
  end
  print(laden)
  installieren = false
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, firstrun)
  dofile("/stargate/Kontrollprogramm.lua")
end

if Sprache == "" then
  checkSprache()
end

dofile("/stargate/sprache/" .. Sprache .. ".lua")

if args[1] == hilfe or args[1] == "hilfe" or args[1] == "help" then
  print(Hilfetext)
else
  if checkKomponenten() == true then
    mainCheck()
  end
end
