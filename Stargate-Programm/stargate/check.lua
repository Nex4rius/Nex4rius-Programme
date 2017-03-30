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
  if versionTyp == nil then
    versionTyp = "master"
  end
  return "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/" .. versionTyp .. "/Stargate-Programm/"
end

function Funktion.checkSprache()
  if Sicherung.Sprache and Sicherung.Sprache ~= "" then
    if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
      return true
    elseif wget("-f", Funktion.Pfad(versionTyp) .. "stargate/sprache/" .. Sicherung.Sprache .. ".lua", "/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
      return true
    end
  else
    local alleSprachen = {}
    local j = 1
    for i in fs.list("/stargate/sprache") do
      local Ende = string.len(i)
      i = string.sub(i, 1, Ende - 4)
      if i ~= "ersetzen" then
        alleSprachen[j] = i
        j = j + 1
      end
    end
    local weiter = true
    while weiter do
      print("Sprache? / Language?")
      for i in pairs(alleSprachen) do
        io.write(alleSprachen[i] .. "   ")
      end
      io.write("\n\n")
      antwortFrageSprache = string.lower(tostring(io.read()))
      for i in pairs(alleSprachen) do
        if antwortFrageSprache == alleSprachen[i] then
          weiter = false
          break
        end
      end
    end
    Sicherung.Sprache = antwortFrageSprache
    schreibSicherungsdatei(Sicherung)
    print("")
    return true
  end
end

function Funktion.checkOpenOS()
  local OpenOS_Version = "OpenOS 1.6.1"
  if _OSVERSION == OpenOS_Version then
    gpu.setForeground(0x00FF00)
    print("\nOpenOS Version:        " .. _OSVERSION)
  else
    gpu.setForeground(0xFF0000)
    print("\nOpenOS Version:        " .. _OSVERSION .. " -> " .. OpenOS_Version)
  end
  gpu.setForeground(0xFFFFFF)
end

function Funktion.checkKomponenten()
  require("term").clear()
  print(sprachen.pruefeKomponenten or "Prüfe Komponenten\n")
  local function check(eingabe)
    if component.isAvailable(eingabe[1]) then
      gpu.setForeground(0x00FF00)
      print(eingabe[2])
    else
      gpu.setForeground(0xFF0000)
      print(eingabe[3])
    end
  end
  local alleKomponenten = {
    {"internet",      sprachen.InternetOK,  sprachen.InternetFehlt},
    {"world_sensor",  sprachen.SensorOK,    sprachen.SensorFehlt},
    {"redstone",      sprachen.redstoneOK,  sprachen.redstoneFehlt},
    {"stargate",      sprachen.StargateOK,  sprachen.StargateFehlt},
  }
  for i in pairs(alleKomponenten) do
    check(alleKomponenten[i])
  end
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
  else
    r = nil
  end
  if gpu.maxResolution() == 80 then
    gpu.setForeground(0x00FF00)
    print(sprachen.gpuOK2T)
  elseif gpu.maxResolution() == 160 then
    graphicT3 = true
    gpu.setForeground(0xFF7F24)
    print(sprachen.gpuOK3T)
  else
    gpu.setForeground(0xFF0000)
    print(sprachen.gpuFehlt)
  end
  gpu.setForeground(0xFFFFFF)
  if component.isAvailable("stargate") then
    sg = component.getPrimary("stargate")
    return true
  else
    os.sleep(5)
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
    wget("-f", Funktion.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
    loadfile("/installieren.lua")()
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
  local dateien = {
    "autorun.lua",
    "bin/stargate.lua",
    "stargate/Kontrollprogramm.lua",
    "stargate/Sicherungsdatei.lua",
    "stargate/adressen.lua",
    "stargate/check.lua",
    "stargate/version.txt",
    "stargate/schreibSicherungsdatei.lua",
    "stargate/sprache/ersetzen.lua",
  }
  for i in pairs(dateien) do
    if not fs.exists("/" .. dateien[i]) then
      print("<FEHLER> Datei fehlt: " .. dateien[i])
      if component.isAvailable("internet") then
        if not wget("-f", Funktion.Pfad(versionTyp) .. dateien[1], "/" .. dateien[1]) then
          return false
        end
      else
        return false
      end
    end
  end
  local alleSprachen = {"deutsch", "english", "russian", "czech", tostring(Sicherung.Sprache)}
  local Sprachdateien = false
  for i in pairs(alleSprachen) do
    if fs.exists("/stargate/sprache/" .. alleSprachen[i] .. ".lua") then
      Sprachdateien = true
      break
    end
  end
  if Sprachdateien then
    return true
  else
    if component.isAvailable("internet") then
      for i in pairs(alleSprachen) do
        if wget("-f", Funktion.Pfad(versionTyp) .. "stargate/sprache/" .. alleSprachen[i] .. ".lua", "/stargate/sprache/" .. alleSprachen[i] .. ".lua") then
          return true
        end
      end
    end
    print("<FEHLER> keine Sprachdatei gefunden")
    return false
  end
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
    elseif arg == "neu" then
      print(sprachen.neuinstallation or "\nNeuinstallation")
      wget("-f", Funktion.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
      loadfile("/installieren.lua")("neu")
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
    if not pcall(loadfile("/stargate/Kontrollprogramm.lua"), Funktion.update, Funktion.checkServerVersion, version, graphicT3) then
      print("Kontrollprogramm.lua hat einen Fehler")
    end
  else
    print(string.format("%s\n%s %s/%s", sprachen.fehlerName, sprachen.DateienFehlen, sprachen.ja, sprachen.nein) or "\nAlles neu herunterladen? ja/nein")
    if Sicherung.autoUpdate then
      print(sprachen.autoUpdateAn or "automatische Aktualisierungen sind aktiviert")
      os.sleep(2)
      wget("-f", Funktion.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
      loadfile("/installieren.lua")()
    else
      antwortFrage = io.read()
      if string.lower(antwortFrage) == sprachen.ja or string.lower(antwortFrage) == "ja" or string.lower(antwortFrage) == "yes" then
        wget("-f", Funktion.Pfad(versionTyp) .. "installieren.lua", "/installieren.lua")
        loadfile("/installieren.lua")()
      end
    end
  end
end

function Funktion.main()
  os.sleep(0.5)
  gpu.setResolution(70, 25)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(6684774)
  if gpu.maxResolution() == 160 then
    gpu.setBackground(0x333333)
  end
  gpu.fill(1, 1, 160, 80, " ")
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
  if arg == "master" or arg == "beta" then
    versionTyp = arg
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
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    print(sprachen.Hilfetext or "Verwendung: autorun [...]\nja\t-> Aktualisierung zur stabilen Version\nnein\t-> keine Aktualisierung\nbeta\t-> Aktualisierung zur Beta-Version\nhilfe\t-> zeige diese Nachricht nochmal")
  else
    if Funktion.checkKomponenten() then
      Funktion.checkOpenOS()
      Funktion.mainCheck()
    end
  end
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  gpu.setResolution(gpu.maxResolution())
end

Funktion.main()
