-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

require("shell").setWorkingDirectory("/")

local component               = require("component")
local fs                      = require("filesystem")
local arg                     = string.lower(tostring(require("shell").parse(...)[1]))
local gpu                     = component.getPrimary("gpu")
local wget                    = loadfile("/bin/wget.lua")
local schreibSicherungsdatei  = loadfile("/stargate/schreibSicherungsdatei.lua")
local betaVersionName         = ""
local Sicherung               = {}
local Funktion                = {}
local version

function Funktion.Pfad(versionTyp)
  return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Stargate-Programm/"
end

function Funktion.checkSprache()
  if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
    return true
  else
    local alleSprachen = ""
    for i in fs.list("/stargate/sprache") do
      local Ende = string.len(i)
      i = string.sub(i, 1, Ende - 4)
      if i ~= "ersetzen" then
        if alleSprachen == "" then
          alleSprachen = string.format("%s", i)
        else
          alleSprachen = string.format("%s / %s", alleSprachen, i)
        end
      end
    end
    print("Sprache? / Language?")
    io.write(alleSprachen .. "\n\n")
    antwortFrageSprache = io.read()
    if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" or wget("-f", Funktion.Pfad(versionTyp) .. "stargate/sprache/" .. antwortFrageSprache .. ".lua", "/update/stargate/sprache/" .. antwortFrageSprache .. ".lua") then
      Sicherung.Sprache = string.lower(antwortFrageSprache)
      schreibSicherungsdatei(Sicherung)
      print("")
      return true
    end
  end
end

function Funktion.checkKomponenten()
  print(sprachen.pruefeKomponenten or "Prüfe Komponenten\n")
  if component.isAvailable("redstone") then
    print(sprachen.redstoneOK or "- Redstone Card        ok - optional")
    r = component.getPrimary("redstone")
  else
    print(sprachen.redstoneFehlt or "- Redstone Card        fehlt - optional")
    r = nil
  end
  if component.isAvailable("internet") then
    print(sprachen.InternetOK or "- Internet             ok - optional")
  else
    print(sprachen.InternetFehlt or "- Internet             fehlt - optional")
  end
  if component.isAvailable("world_sensor") then
    print(sprachen.SensorOK or "- World Sensor         ok - optional")
  else
    print(sprachen.SensorFehlt or "- World Sensor         fehlt - optional")
  end
  if gpu.maxResolution() == 80 then
    print(sprachen.gpuOK2T or "- GPU Tier2            ok")
  elseif gpu.maxResolution() == 160 then
    graphicT3 = true
    gpu.setBackground(0x333333)
    print(sprachen.gpuOK3T or "- GPU Tier3            ok - Tier2 ist ausreichend")
  else
    print(sprachen.gpuFehlt or "- GPU Tier2            fehlt")
  end
  if component.isAvailable("stargate") then
    print(sprachen.StargateOK or "- Stargate             ok\n")
    sg = component.getPrimary("stargate")
    return true
  else
    print(sprachen.StargateFehlt or "- Stargate             fehlt\n")
    return false
  end
end

function Funktion.update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  if wget("-f", Funktion.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua") then
    Sicherung.installieren = true
    if schreibSicherungsdatei(Sicherung) then
      local f = io.open ("/autorun.lua", "w")
      f:write('loadfile("/installieren.lua")("' .. versionTyp .. '")')
      f:close()
      loadfile("/autorun.lua")()
    else
      print(sprachen.fehlerName or "<FEHLER>")
    end
  elseif versionTyp == "master" then
    loadfile("/bin/pastebin.lua")("run", "-f", "YVqKFnsP")
  end
  os.exit()
end

function Funktion.checkServerVersion()
  if wget("-fQ", Funktion.Pfad("master") .. "stargate/version.txt", "/serverVersion.txt") then
    local f = io.open ("/serverVersion.txt", "r")
    serverVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/serverVersion.txt")
  else
    serverVersion = sprachen.fehlerName
  end
  return serverVersion
end

function Funktion.checkBetaServerVersion()
  if wget("-fQ", Funktion.Pfad("beta") .. "stargate/version.txt", "/betaVersion.txt") then
    local f = io.open ("/betaVersion.txt", "r")
    betaServerVersion = f:read()
    f:close()
    loadfile("/bin/rm.lua")("/betaVersion.txt")
  else
    betaServerVersion = sprachen.fehlerName
  end
  return betaServerVersion
end

function Funktion.checkDateien()
  if fs.exists("/autorun.lua") and fs.exists("/stargate/Kontrollprogramm.lua") then
    if fs.exists("/stargate/Sicherungsdatei.lua") and fs.exists("/stargate/adressen.lua") then
      if fs.exists("/stargate/check.lua") and fs.exists("/stargate/version.txt") then
        if fs.exists("/stargate/sprache/deutsch.lua") and fs.exists("/stargate/sprache/english.lua") then
          if fs.exists("/stargate/sprache/ersetzen.lua") and fs.exists("/stargate/schreibSicherungsdatei.lua") then
            return true
  end end end end end
  return false
end

function Funktion.mainCheck()
  if component.isAvailable("internet") then
    local serverVersion = Funktion.checkServerVersion()
    local betaServerVersion = Funktion.checkBetaServerVersion()
    print(sprachen.derzeitigeVersion .. version .. sprachen.verfuegbareVersion .. serverVersion or "\nDerzeitige Version:    " .. version .. "\nVerfügbare Version:    " .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(sprachen.betaVersion .. betaServerVersion .. " BETA" or "Beta-Version:          " .. betaServerVersion .. " BETA")
      if betaServerVersion == sprachen.fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if (arg == sprachen.ja or arg == "ja" or arg == "yes") and serverVersion ~= sprachen.fehlerName then
      print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
      Funktion.update("master")
    elseif arg == sprachen.nein or arg == "nein" or arg == "no" then
      -- nichts
    elseif arg == "beta" and betaServerVersion ~= sprachen.fehlerName then
      print(sprachen.aktualisierenBeta or "\nAktualisieren: Beta-Version\n")
      Funktion.update("beta")
    elseif version ~= serverVersion or version ~= betaServerVersion then
      if Sicherung.installieren == false then
        local EndpunktVersion = string.len(version)
        if Sicherung.autoUpdate == true and version ~= serverVersion and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" and serverVersion ~= sprachen.fehlerName then
          print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
          Funktion.update("master")
        elseif serverVersion ~= sprachen.fehlerName then
          print(sprachen.aktualisierenFrage .. betaVersionName .. "\n" or "\nAktualisieren? ja/nein" .. betaVersionName .. "\n")
          if Sicherung.autoUpdate and version ~= serverVersion then
            print(sprachen.autoUpdateAn or "automatische Aktualisierungen sind aktiviert")
            print()
            os.sleep(2)
            Funktion.update("master")
          else
            antwortFrage = io.read()
            if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
              print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
              Funktion.update("master")
            elseif string.lower(antwortFrage) == "beta" then
              print(sprachen.aktualisierenBeta or "\nAktualisieren: Beta-Version\n")
              Funktion.update("beta")
            else
              print(sprachen.aktualisierenNein .. antwortFrage or "\nAntwort: " .. antwortFrage)
            end
          end
        end
      end
    end
  end
  print(sprachen.laden or "\nLaden...")
  Sicherung.installieren = false
  schreibSicherungsdatei(Sicherung)
  if Funktion.checkDateien() then
    if fs.exists("/log") and component.isAvailable("keyboard") and Sicherung.debug then
      loadfile("/bin/edit.lua")("-r", "/log")
      loadfile("/bin/rm.lua")("/log")
    end
    loadfile("/stargate/Kontrollprogramm.lua")(Funktion.update, Funktion.checkServerVersion, version, graphicT3)
  else
    print(string.format("%s\n%s %s/%s", sprachen.fehlerName, sprachen.DateienFehlen, sprachen.ja, sprachen.nein) or "<FEHLER>\nDateien fehlen\nAlles neu herunterladen? ja/nein")
    if Sicherung.autoUpdate then
      print(sprachen.autoUpdateAn or "automatische Aktualisierungen sind aktiviert")
      os.sleep(2)
      loadfile("/bin/pastebin.lua")("run", "-f", "YVqKFnsP")
    else
      antwortFrage = io.read()
      if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
        loadfile("/bin/pastebin.lua")("run", "-f", "YVqKFnsP")
      end
    end
  end
end

function Funktion.main()
  gpu.setResolution(70, 25)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(6684774)
  if gpu.maxResolution() == 160 then
    gpu.setBackground(0x333333)
  end
  if gpu then
    gpu.fill(1, 1, 160, 80, " ")
  end
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
  if Funktion.checkSprache() then
    sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  else
    print("\nUnbekannte Sprache\nStandardeinstellung = deutsch")
    if fs.exists("/stargate/sprache/deutsch.lua") then
      sprachen = loadfile("/stargate/sprache/deutsch.lua")()
    else
      print(sprachen.fehlerName or "<FEHLER>")
    end
  end
  if arg == sprachen.hilfe or arg == "hilfe" or arg == "help" or arg == "?" then
    print(sprachen.Hilfetext or "Verwendung: autorun [...]\nja\t-> Aktualisierung zur stabilen Version\nnein\t-> keine Aktualisierung\nbeta\t-> Aktualisierung zur Beta-Version\nhilfe\t-> zeige diese Nachricht nochmal")
  else
    if Funktion.checkKomponenten() then
      Funktion.mainCheck()
    end
  end
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  gpu.setResolution(gpu.maxResolution())
end

Funktion.main()
