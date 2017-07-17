-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

os.sleep(1)

OC = nil
CC = nil
if require then
  OC = true
  require("shell").setWorkingDirectory("/")
else
  CC = true
end

local fs                      = fs or require("filesystem")
local term                    = term or require("term")
local arg                     = string.lower(tostring(...))
local schreibSicherungsdatei  = loadfile("/stargate/schreibSicherungsdatei.lua")
local betaVersionName         = ""
local Sicherung               = {}
local Funktion                = {}
local component               = {}
local gpu                     = {}
local version

if OC then
  component = require("component")
  gpu = component.getPrimary("gpu")
elseif CC then
  component.getPrimary = peripheral.find
  gpu = component.getPrimary("monitor")
  gpu.setResolution = function() gpu.setTextScale(0.5) end
  gpu.setForeground = gpu.setTextColor
  gpu.setBackground = gpu.setBackgroundColor
  gpu.maxResolution = gpu.getSize
  gpu.fill = function(startX, startY, endX, endY) paintutils.drawFilledBox(startX, StartY, endX, endY, gpu.getBackgroundColor()) end
end

local kopieren = loadfile("/bin/cp.lua") or function(a, b)
  if fs.exists(b) then
    shell.run("delete " .. b)
  end
  shell.run(string.format("copy %s %s", a, b))
end
local wget = loadfile("/bin/wget.lua") or function(option, url, ziel)
  if type(url) ~= "string" and type(ziel) ~= "string" then
    return
  elseif type(option) == "string" and option ~= "-f" and type(url) == "string" then
    ziel = url
    url = option
  end
  if http.checkURL(url) then
    if fs.exists(ziel) and option ~= "-f" then
      printError("<Fehler> Ziel existiert bereits")
      return
    else
      term.write("Starte Download ... ")
      local timer = os.startTimer(30)
      http.request(url)
      while true do
        local event, id, data = os.pullEvent()
        if event == "http_success" then
          print("erfolgreich")
          local f = io.open(ziel, "w")
          f:write(data.readAll())
          f:close()
          data:close()
          print("Gespeichert unter " .. ziel)
          return true
        elseif event == "timer" and timer == id then
          printError("<Fehler> Zeitueberschreitung")
          return
        elseif event == "http_failure" then
          printError("<Fehler> Download")
          os.cancelAlarm(timer)
          return
        end
      end
    end
  else
    printError("<Fehler> URL")
    return
  end
end

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
  if OC then
    local OpenOS_Version = "OpenOS 1.6.1"
   if _OSVERSION == OpenOS_Version then
      gpu.setForeground(0x00FF00)
      print("\nOpenOS Version:        " .. _OSVERSION)
    else
      gpu.setForeground(0xFF0000)
      print("\nOpenOS Version:        " .. _OSVERSION .. " -> " .. OpenOS_Version)
    end
    gpu.setForeground(0xFFFFFF)
  elseif CC then
    print("\nCraftOS Version:       " .. os.version())
  end
end

function Funktion.checkKomponenten()
  term.clear()
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
    if sg.energyToDial(sg.localAddress()) then
      return true
    else
      gpu.setForeground(0xFF0000)
      print()
      print(sprachen.StargateNichtKomplett or "Stargate ist funktionsunfähig")
      gpu.setForeground(0xFFFFFF)
      os.sleep(5)
      return
    end
  else
    os.sleep(5)
    return
  end
end

function Funktion.update(versionTyp)
  if versionTyp == nil then
    versionTyp = "master"
  end
  --[[
  if fs.exists("/bin/github.lua") or wget("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua") then
    Sicherung.installieren = true
    if schreibSicherungsdatei(Sicherung) then
      local f = io.open ("/autorun.lua", "w")
      f:write([==[-- pastebin run -f YVqKFnsP]==] .. "\n")
      f:write([==[-- von Nex4rius]==] .. "\n")
      f:write([==[-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm]==] .. "\n")
      f:write("\n")
      f:write([==[if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua") then]==] .. "\n")
      f:write([==[  return loadfile("/bin/github.lua")("Nex4rius", "Nex4rius-Programme", "]==] .. versionTyp .. [==[", "Stargate-Programm")]==] .. "\n")
      f:write([==[end]==] .. "\n")
      f:close()
      if loadfile("/autorun.lua")() and version and versionTyp == "BETA" then
        local f = io.open ("/stargate/version.txt", "a")
        f:write(" BETA")
        f:close()
      end
    else
      io.write(sprachen.fehlerName or "<FEHLER>")
      print(" /stargate/schreibSicherungsdatei.lua")
    end
  else
    io.write(sprachen.fehlerName or "<FEHLER>")
    print(" /bin/github.lua and GitHub download")
  end
  require("computer").shutdown(true)
  ]]
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
  local f = io.open ("/bin/stargate.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n')
  f:write('\n')
  f:write('if not pcall(loadfile("/autorun.lua"), require("shell").parse(...)[1]) then\n')
  f:write('   loadfile("/bin/wget-lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua")\n')
  f:write('   loadfile("/bin/github.lua")("Nex4rius", "Nex4rius-Programme", "master", "Stargate-Programm")\n')
  f:write('end\n')
--[[
  f:write([==[-- pastebin run -f YVqKFnsP]==] .. "\n")
  f:write([==[-- von Nex4rius]==] .. "\n")
  f:write([==[-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm]==] .. "\n")
  f:write("\n")
  f:write([==[if not pcall(loadfile("/autorun.lua"), require("shell").parse(...)[1]) then]==] .. "\n")
  f:write([==[    if loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/Nex4rius/Nex4rius-Programme/master/GitHub-Downloader/github.lua", "/bin/github.lua") then]==] .. "\n")
  f:write([==[        loafile("/bin/github.lua")("Nex4rius", "Nex4rius-Programme", "master", "Stargate-Programm")]==] .. "\n")
  f:write([==[    end]==] .. "\n")
  f:write([==[end]==])
--]]
  f:close()
  local dateien = {
    "autorun.lua",
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
      io.write(sprachen.fehlerName or "<FEHLER>")
      print(" Datei fehlt: " .. dateien[i])
      if component.isAvailable("internet") then
        if not wget("-f", Funktion.Pfad(versionTyp) .. dateien[1], "/" .. dateien[1]) then
          return
        end
      else
        return
      end
    end
  end
  if not fs.exists("/einstellungen") then
    fs.makeDirectory("/einstellungen")
  end
  if not fs.exists("/einstellungen/adressen.lua") then
    kopieren("-n", "/stargate/adressen.lua", "/einstellungen/adressen.lua")
  end
  if not fs.exists("/einstellungen/Sicherungsdatei.lua") then
    kopieren("-n", "/stargate/Sicherungsdatei.lua", "/einstellungen/Sicherungsdatei.lua")
  end
  local alleSprachen = {"deutsch", "english", "russian", "czech", tostring(Sicherung.Sprache)}
  for i in pairs(alleSprachen) do
    if fs.exists("/stargate/sprache/" .. alleSprachen[i] .. ".lua") then
      return true
    elseif component.isAvailable("internet") then
      for i in pairs(alleSprachen) do
        if wget("-f", Funktion.Pfad(versionTyp) .. "stargate/sprache/" .. alleSprachen[i] .. ".lua", "/stargate/sprache/" .. alleSprachen[i] .. ".lua") then
          return true
        end
      end
    end
  end
  print("<FEHLER> keine Sprachdatei gefunden")
  return
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
  if OC then
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(6684774)
  elseif CC then
    gpu.setForeground(1)
    gpu.setBackground(256)
  end
  if gpu.maxResolution() == 160 then
    gpu.setBackground(0x333333)
  end
  gpu.fill(1, 1, 70, 25, " ")
  term.clear()
  Funktion.checkDateien()
  if fs.exists("/stargate/version.txt") then
    local f = io.open ("/stargate/version.txt", "r")
    version = f:read()
    f:close()
  else
    version = sprachen.fehlerName
  end
  if fs.exists("/einstellungen/Sicherungsdatei.lua") then
    Sicherung = loadfile("/einstellungen/Sicherungsdatei.lua")()
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
    if OC then
      gpu.setForeground(0x000000)
      gpu.setBackground(0xFFFFFF)
    elseif CC then
      gpu.setForeground(32768)
      gpu.setBackground(1)
    end
    print(sprachen.Hilfetext or [==[
      Verwendung: autorun [...]
      ja    -> Aktualisierung zur stabilen Version
      nein  -> keine Aktualisierung
      beta  -> Aktualisierung zur Beta-Version
      hilfe -> zeige diese Nachricht nochmal]==])
  else
    if Funktion.checkKomponenten() then
      Funktion.checkOpenOS()
      Funktion.mainCheck()
    else
      print("\n")
      io.write(sprachen.fehlerName or "<FEHLER>")
      print(" kein Stargate")
      os.sleep(5)
    end
  end
  if OC then
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
  elseif CC then
    gpu.setForeground(32768)
    gpu.setBackground(1)
  end
  term.clear()
  gpu.setResolution(gpu.maxResolution())
end

Funktion.main()
