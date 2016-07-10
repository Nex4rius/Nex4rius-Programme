-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm

local component               = require("component")
local fs                      = require("filesystem")
local args                    = require("shell").parse(...)
local gpu                     = component.getPrimary("gpu")
local wget                    = loadfile("/bin/wget.lua")
local schreibSicherungsdatei  = loadfile("/stargate/schreibSicherungsdatei.lua")
local betaVersionName         = ""

require("term").clear()

local function Pfad(versionTyp)
  return "https://raw.githubusercontent.com/Nex4rius/Stargate-Programm/" .. versionTyp .. "/Stargate-Programm"
end

if fs.exists("/stargate/version.txt") then
  f = io.open ("/stargate/version.txt", "r")
  version = f:read()
  f:close()
else
  version = sprachen.fehlerName
end

local function checkSprache()
  print("Sprache? / Language? deutsch / english\n")
  antwortFrageSprache = io.read()
  if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" or wget("-f", Pfad(versionTyp) .. "/stargate/sprache/" .. antwortFrageSprache .. ".lua", "/update/stargate/sprache/" .. antwortFrageSprache .. ".lua") then
    Sprache = string.lower(antwortFrageSprache)
  else
    print("\nUnbekannte Eingabe\nStandardeinstellung = deutsch")
    Sprache = "deutsch"
  end
  schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
  print("")
end

if fs.exists("/stargate/Sicherungsdatei.lua") then
  local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
else
  checkSprache()
  local installieren = false
  local control = "On"
end

sprachen = loadfile("/stargate/sprache/" .. Sprache .. ".lua")()

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

function update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  if wget("-f", Pfad(versionTyp) .. "/installieren.lua", "/installieren.lua") then
    installieren = true
    schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
    f = io.open ("autorun.lua", "w")
    f:write('versionTyp = "' .. versionTyp .. '"\n')
    f:write('loadfile("installieren.lua")(' .. versionTyp .. ')')
    f:close()
    loadfile("autorun.lua")()
  elseif versionTyp == "master" then
    loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
  end
  os.exit()
end

function checkServerVersion()
  if wget("-fQ", Pfad("master") .. "/stargate/version.txt", "/serverVersion.txt") then
    f = io.open ("/serverVersion.txt", "r")
    serverVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/serverVersion.txt")
  else
    serverVersion = sprachen.fehlerName
  end
  return serverVersion
end

function checkBetaServerVersion()
  if wget("-fQ", Pfad("beta") .. "/stargate/version.txt", "/betaVersion.txt") then
    f = io.open ("/betaVersion.txt", "r")
    betaServerVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/betaVersion.txt")
  else
    betaServerVersion = sprachen.fehlerName
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
      if betaServerVersion == sprachen.fehlerName then else
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
      loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
    end
  end
end

local function checkDateien()
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
  if checkKomponenten() then
    mainCheck()
  end
end
