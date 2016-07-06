-- pastebin run -f 1pbsaeCQ
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

term.clear()

if Sprache == "" then
  checkSprache()
end

if fs.exists("/stargate/version.txt") then
  f = io.open ("/stargate/version.txt", "r")
  version = f:read()
  f:close()
else
  version = sprachen.fehlerName
end

sprachen = loadfile("/stargate/sprache/" .. Sprache .. ".lua")()

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
  print(sprachen.pruefeKomponenten)
  if component.isAvailable("redstone") then
    print(sprachen.redstoneOK)
    r = component.getPrimary("redstone")
  else
    print(sprachen.redstoneFehlt)
    r = nil
  end
  if component.isAvailable("internet") then
    print(sprachen.InternetOK)
    internet = true
  else
    print(sprachen.InternetFehlt)
    internet = false
  end
  if gpu.maxResolution() == 80 then
    print(sprachen.gpuOK2T)
  elseif gpu.maxResolution() == 160 then
    graphicT3 = true
    print(sprachen.gpuOK3T)
  else
    print(sprachen.gpuFehlt)
  end
  if component.isAvailable("stargate") then
    print(sprachen.StargateOK)
    sg = component.getPrimary("stargate")
    return true
  else
    print(sprachen.StargateFehlt)
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
    print(sprachen.derzeitigeVersion .. version .. sprachen.verfuegbareVersion .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(sprachen.betaVersion .. betaServerVersion .. " BETA")
      if betaServerVersion == fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if args[1] == sprachen.ja or args[1] == "ja" or args[1] == "yes" then
      print(sprachen.aktualisierenJa)
      update("master")
    elseif args[1] == sprachen.nein or args[1] == "nein" or args[1] == "no" then
      -- nichts
    elseif args[1] == "beta" then
      print(sprachen.aktualisierenBeta)
      update("beta")
    elseif version == serverVersion and version == betaServerVersion then else
      if installieren == false then
        local EndpunktVersion = string.len(version)
        if autoUpdate == true and version ~= serverVersion and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" then
          print(sprachen.aktualisierenJa)
          update("master")
          return
        else
          print(sprachen.aktualisierenFrage .. betaVersionName .. "\n")
          antwortFrage = io.read()
          if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
            print(sprachen.aktualisierenJa)
            update("master")
            return
          elseif string.lower(antwortFrage) == "beta" then
            print(sprachen.aktualisierenBeta)
            update("beta")
            return
          else
            print(sprachen.aktualisierenNein .. antwortFrage)
          end
        end
      end
    end
  end
  print(sprachen.laden)
  installieren = false
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  if checkDateien() then
    if fs.exists("/log") then
      loadfile("/bin/rm.lua")("/log")
    end
    loadfile("/stargate/Kontrollprogramm.lua")()
  else
    print(sprachen.fehlerName .. "\n" .. sprachen.DateienFehlen)
    antwortFrage = io.read()
    if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
      os.execute("pastebin run -f 1pbsaeCQ")
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

if args[1] == sprachen.hilfe or args[1] == "hilfe" or args[1] == "help" then
  print(Hilfetext)
else
  if checkKomponenten() == true then
    mainCheck()
  end
end
