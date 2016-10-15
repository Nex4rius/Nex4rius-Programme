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
    end
  end
end

function Funktionen.checkKomponenten()
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
    print(sprachen.gpuOK3T or "- GPU Tier3            ok - WARNUNG optimiert für T2 Bildschirme")
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

function Funktionen.update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  if wget("-f", Funktionen.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua") then
    Sicherung.installieren = true
    if schreibSicherungsdatei(Sicherung) then
      local f = io.open ("autorun.lua", "w")
      f:write('loadfile("installieren.lua")("' .. versionTyp .. '")')
      f:close()
      loadfile("autorun.lua")()
    else
      print(sprachen.fehlerName or "<FEHLER>")
    end
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
    print(sprachen.derzeitigeVersion .. version .. sprachen.verfuegbareVersion .. serverVersion or "\nDerzeitige Version:    " .. version .. "\nVerfügbare Version:    " .. serverVersion)
    if serverVersion == betaServerVersion then else
      print(sprachen.betaVersion .. betaServerVersion .. " BETA" or "Beta-Version:          " .. betaServerVersion .. " BETA")
      if betaServerVersion == sprachen.fehlerName then else
        betaVersionName = "/beta"
      end
    end
    if arg == sprachen.ja or arg == "ja" or arg == "yes" then
      print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
      Funktionen.update("master")
    elseif arg == sprachen.nein or arg == "nein" or arg == "no" then
      -- nichts
    elseif arg == "beta" then
      print(sprachen.aktualisierenBeta or "\nAktualisieren: Beta-Version\n")
      Funktionen.update("beta")
    elseif version ~= serverVersion or version ~= betaServerVersion then
      if Sicherung.installieren == false then
        local EndpunktVersion = string.len(version)
        if Sicherung.autoUpdate == true and version ~= serverVersion and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" then
          print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
          Funktionen.update("master")
          return
        else
          print(sprachen.aktualisierenFrage .. betaVersionName .. "\n" or "\nAktualisieren? ja/nein" .. betaVersionName .. "\n")
          if Sicherung.autoUpdate then
            print(sprachen.autoUpdateAn or "automatische Aktualisierungen sind aktiviert")
            os.sleep(2)
            Funktionen.update("master")
            return
          else
            antwortFrage = io.read()
            if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
              print(sprachen.aktualisierenJa or "\nAktualisieren: Ja\n")
              Funktionen.update("master")
              return
            elseif string.lower(antwortFrage) == "beta" then
              print(sprachen.aktualisierenBeta or "\nAktualisieren: Beta-Version\n")
              Funktionen.update("beta")
              return
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
  if Funktionen.checkDateien() then
    if fs.exists("/log") and component.isAvailable("keyboard") and Sicherung.debug then
      loadfile("/bin/edit.lua")("-r", "/log")
      loadfile("/bin/rm.lua")("/log")
    end
    loadfile("/stargate/Kontrollprogramm.lua")(Funktionen.update, Funktionen.checkServerVersion, version)
  else
    print(string.format("%s\n%s %s/%s", sprachen.fehlerName, sprachen.DateienFehlen, sprachen.ja, sprachen.nein) or "<FEHLER>\nDateien fehlen\nAlles neu herunterladen? ja/nein")
    if Sicherung.autoUpdate then
      print(sprachen.autoUpdateAn or "automatische Aktualisierungen sind aktiviert")
      os.sleep(2)
      loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
    else
      antwortFrage = io.read()
      if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
        loadfile("/bin/pastebin.lua")("run", "-f", "wLK1gCKt")
      end
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
      print(sprachen.fehlerName or "<FEHLER>")
    end
  end
  if arg == sprachen.hilfe or arg == "hilfe" or arg == "help" then
    print(sprachen.Hilfetext or "Verwendung: autorun [...]\nja\t-> Aktualisierung zur stabilen Version\nnein\t-> keine Aktualisierung\nbeta\t-> Aktualisierung zur Beta-Version\nhilfe\t-> zeige diese Nachricht nochmal")
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
