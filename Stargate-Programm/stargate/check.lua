-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local component               = require("component")
local fs                      = require("filesystem")
local arg                     = string.lower(tostring(require("shell").parse(...)[1]))
local gpu                     = component.getPrimary("gpu")
local wget                    = loadfile("/bin/wget.lua")
local schreibSicherungsdatei  = loadfile("/stargate/schreibSicherungsdatei.lua")
local betaVersionName         = ""
local Sicherung               = {}
local Funktionen              = {}
local version

function Funktionen.Pfad(versionTyp)
  return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/" .. versionTyp .. "/Stargate-Programm/"
end

function Funktionen.checkSprache()
  if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
    return true
  else
    print("Sprache? / Language? deutsch / english\n")
    antwortFrageSprache = io.read()
    if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" or wget("-f", Funktionen.Pfad(versionTyp) .. "stargate/sprache/" .. antwortFrageSprache .. ".lua", "/update/stargate/sprache/" .. antwortFrageSprache .. ".lua") then
      Sicherung.Sprache = string.lower(antwortFrageSprache)
      schreibSicherungsdatei(Sicherung)
      print("")
      return true
    else
      return false
    end
  end
end

function Funktionen.checkKomponenten()
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
  else
    print(sprachen.InternetFehlt)
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

function Funktionen.update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  if wget("-f", Funktionen.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua") then
    Sicherung.installieren = true
    schreibSicherungsdatei(Sicherung)
    local f = io.open ("autorun.lua", "w")
    f:write('loadfile("installieren.lua")("' .. versionTyp .. '")')
    f:close()
    loadfile("autorun.lua")()
  elseif versionTyp == "master" then
    loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
  end
  os.exit()
end

function Funktionen.checkServerVersion()
  if wget("-fQ", Funktionen.Pfad("master") .. "stargate/version.txt", "/serverVersion.txt") then
    local f = io.open ("/serverVersion.txt", "r")
    serverVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/serverVersion.txt")
  else
    serverVersion = sprachen.fehlerName
  end
  return serverVersion
end

function Funktionen.checkBetaServerVersion()
  if wget("-fQ", Funktionen.Pfad("beta") .. "stargate/version.txt", "/betaVersion.txt") then
    local f = io.open ("/betaVersion.txt", "r")
    betaServerVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/betaVersion.txt")
  else
    betaServerVersion = sprachen.fehlerName
  end
  return betaServerVersion
end

function Funktionen.checkDateien()
  if fs.exists("/autorun.lua") and fs.exists("/stargate/Kontrollprogramm.lua") then
    if fs.exists("/stargate/Sicherungsdatei.lua") and fs.exists("/stargate/adressen.lua") then
      if fs.exists("/stargate/check.lua") and fs.exists("/stargate/version.txt") then
        if fs.exists("/stargate/sprache/deutsch.lua") and fs.exists("/stargate/sprache/english.lua") then
          if fs.exists("/stargate/sprache/ersetzen.lua") and fs.exists("/stargate/schreibSicherungsdatei.lua") then
            return true
  end end end end end
  return false
end

function Funktionen.mainCheck()
  if component.isAvailable("internet") then
    local serverVersion = Funktionen.checkServerVersion()
    local betaServerVersion = Funktionen.checkBetaServerVersion()
    print(sprachen.derzeitigeVersion .. version .. sprachen.verfuegbareVersion .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(sprachen.betaVersion .. betaServerVersion .. " BETA")
      if betaServerVersion == sprachen.fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if arg == sprachen.ja or arg == "ja" or arg == "yes" then
      print(sprachen.aktualisierenJa)
      Funktionen.update("master")
    elseif arg == sprachen.nein or arg == "nein" or arg == "no" then
      -- nichts
    elseif arg == "beta" then
      print(sprachen.aktualisierenBeta)
      Funktionen.update("beta")
    elseif version ~= serverVersion or version ~= betaServerVersion then
      if Sicherung.installieren == false then
        local EndpunktVersion = string.len(version)
        if Sicherung.autoUpdate == true and version ~= serverVersion and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" then
          print(sprachen.aktualisierenJa)
          Funktionen.update("master")
          return
        else
          print(sprachen.aktualisierenFrage .. betaVersionName .. "\n")
          antwortFrage = io.read()
          if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
            print(sprachen.aktualisierenJa)
            Funktionen.update("master")
            return
          elseif string.lower(antwortFrage) == "beta" then
            print(sprachen.aktualisierenBeta)
            Funktionen.update("beta")
            return
          else
            print(sprachen.aktualisierenNein .. antwortFrage)
          end
        end
      end
    end
  end
  print(sprachen.laden)
  Sicherung.installieren = false
  schreibSicherungsdatei(Sicherung)
  if Funktionen.checkDateien() then
    if fs.exists("/log") then
      loadfile("/bin/edit.lua")("-r", "/log")
      loadfile("/bin/rm.lua")("/log")
    end
    loadfile("/stargate/Kontrollprogramm.lua")(Funktionen.update, Funktionen.checkServerVersion, version)
  else
    print(sprachen.fehlerName .. "\n" .. sprachen.DateienFehlen)
    antwortFrage = io.read()
    if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
      loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
    end
  end
end

function Funktionen.main()
  gpu.setResolution(70, 25)
  gpu.setBackground(6684774)
  gpu.setForeground(0xFFFFFF)
  require("term").clear()
  if fs.exists("/stargate/version.txt") then
    local f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
  else
    version = sprachen.fehlerName
  end
  if fs.exists("/stargate/Sicherungsdatei.lua") then
    Sicherung = loadfile("/stargate/Sicherungsdatei.lua")()
  else
    Sicherung.installieren = false
  end
  if Funktionen.checkSprache() then
    sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  else
    print("\nUnbekannte Sprache\nStandardeinstellung = deutsch")
    if fs.exists("/stargate/sprache/deutsch.lua") then
      sprachen = loadfile("/stargate/sprache/deutsch.lua")()
    else
      print(sprachen.fehlerName)
    end
  end
  if arg == sprachen.hilfe or arg == "hilfe" or arg == "help" then
    print(sprachen.Hilfetext)
  else
    if Funktionen.checkKomponenten() then
      Funktionen.mainCheck()
    end
  end
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  gpu.setResolution(gpu.maxResolution())
end

Funktionen.main()
