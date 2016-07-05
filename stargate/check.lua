-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

component = require("component")
term = require("term")
event = require("event")
fs = require("filesystem")
c = require("computer")
args = require("shell").parse(...)
wget = loadfile("/bin/wget.lua")
gpu = component.getPrimary("gpu")
schreibSicherungsdatei = loadfile("/stargate/schreibSicherungsdatei.lua")
serverAdresse = "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/"
betaVersionName = ""
if fs.exists("/stargate/Sicherungsdatei.lua") then
  IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  Sprache = ""
  control = "On"
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

function checkSprache()
  print("Sprache? / Language? deutsch / english\n")
  antwortFrageSprache = io.read()
  if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
    Sprache = string.lower(antwortFrageSprache)
  else
    print("\nUnbekannte Eingabe\nStandardeinstellung = deutsch")
    Sprache = "deutsch"
  end
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
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
  return serverAdresse .. versionTyp
end

function update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  wget("-f", Pfad(versionTyp) .. "/installieren.lua", "/installieren.lua")
  installieren = true
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  f = io.open ("autorun.lua", "w")
  f:write('versionTyp = "' .. versionTyp .. '"\n')
  f:write('loadfile("installieren.lua")()')
  f:close()
  loadfile("autorun.lua")()
  os.exit()
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
        if autoUpdate == true and version ~= serverVersion then
          print(aktualisierenJa)
          update("master")
          return
        else
          print(aktualisierenFrage .. betaVersionName .. "\n")
          antwortFrage = io.read()
          if string.lower(antwortFrage) == ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
            print(aktualisierenJa)
            update("master")
            return
          elseif string.lower(antwortFrage) == "beta" then
            print(aktualisierenBeta)
            update("beta")
            return
          else
            print(aktualisierenNein .. antwortFrage)
          end
        end
      end
    end
  end
  print(laden)
  installieren = false
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  if checkDateien() then
    if fs.exists("/log") then
      loadfile("/bin/rm.lua")("/log")
    end
    loadfile("/stargate/Kontrollprogramm.lua")()
  else
    print(fehlerName .. "\n" .. DateienFehlen)
    antwortFrage = io.read()
    if string.lower(antwortFrage) == ja then
      os.execute("pastebin run -f fa9gu1GJ")
    end
  end
end

function checkDateien()
  if fs.exists("/autorun.lua") then
    if fs.exists("/stargate/Kontrollprogramm.lua") then
      if fs.exists("/stargate/Sicherungsdatei.lua") then
        if fs.exists("/stargate/adressen.lua") then
          if fs.exists("/stargate/check.lua") then
            if fs.exists("/stargate/version.txt") then
              if fs.exists("/stargate/sprache/deutsch.lua") then
                if fs.exists("/stargate/sprache/english.lua") then
                  if fs.exists("/stargate/sprache/ersetzen.lua") then
                    if fs.exists("/stargate/schreibSicherungsdatei.lua") then
                      return true
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return false
end

if Sprache == "" then
  checkSprache()
end

loadfile("/stargate/sprache/" .. Sprache .. ".lua")()

if args[1] == hilfe or args[1] == "hilfe" or args[1] == "help" then
  print(Hilfetext)
else
  if checkKomponenten() == true then
    mainCheck()
  end
end
