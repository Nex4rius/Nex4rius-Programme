-- pastebin run -f YVqKFnsP
-- nexDHD von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD

if require then
  OC = true
  CC = nil
  require("shell").setWorkingDirectory("/")
else
  OC = nil
  CC = true
end

local component                 = {}
local event                     = {}
local term                      = term or require("term")
local fs                        = fs or require("filesystem")
local shell                     = shell or require("shell")
_G.shell = shell
local print                     = print

local gpu, serialization, sprachen, unicode, ID

if OC then
  serialization = require("serialization")
  component = require("component")
  event = require("event")
  unicode = require("unicode")
  gpu = component.getPrimary("gpu")
  local a = gpu.setForeground
  local b = gpu.setBackground
  gpu.setForeground = function(code) if code then a(code) end end
  gpu.setBackground = function(code) if code then b(code) end end
elseif CC then
  component.getPrimary = peripheral.find
  component.isAvailable = function(name)
    cc_immer = {}
    cc_immer.internet = function() return http end
    cc_immer.redstone = function() return true end
    if cc_immer[name] then
      return cc_immer[name]()
    end
    return peripheral.find(name)
  end
  gpu = component.getPrimary("monitor")
  term.redirect(gpu)
  gpu.setResolution = function() gpu.setTextScale(0.5) end
  gpu.setForeground = function(code) if code then gpu.setTextColor(code) end end
  gpu.setBackground = function(code) if code then gpu.setBackgroundColor(code) end end
  gpu.maxResolution = gpu.getSize
  gpu.getResolution = gpu.getSize
  gpu.fill = function() term.clear() end
  fs.remove = fs.remove or fs.delete
  term.setCursor = term.setCursorPos
end

local entfernen                 = fs.remove or fs.delete
local kopieren                  = fs.copy
local edit                      = loadfile("/bin/edit.lua") or function(datei) shell.run("edit " .. datei) end
local schreibSicherungsdatei    = loadfile("/stargate/schreibSicherungsdatei.lua")

if not pcall(loadfile("/einstellungen/Sicherungsdatei.lua")) then
  print("Fehler Sicherungsdatei.lua")
end

local Sicherung                 = loadfile("/einstellungen/Sicherungsdatei.lua")()
local gist                      = loadfile("/stargate/gist.lua")

if not pcall(loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")) then
  print(string.format("Fehler %s.lua", Sicherung.Sprache))
end

do
  local neu = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
  sprachen = loadfile("/stargate/sprache/deutsch.lua")()
  for i in pairs(sprachen) do
    if neu[i] then
      sprachen[i] = neu[i]
    end
  end
  sprachen = sprachen or neu
end

local ersetzen                  = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)

local sg                        = component.getPrimary("stargate")
local screen                    = component.getPrimary("screen") or {}

local Bildschirmbreite, Bildschirmhoehe = gpu.getResolution()
local max_Bildschirmbreite, max_Bildschirmhoehe = gpu.maxResolution()

local enteridc                  = ""
local showidc                   = ""
local remoteName                = ""
local zielAdresse               = ""
local time                      = "-"
local incode                    = "-"
local codeaccepted              = "-"
local wormhole                  = "in"
local iriscontrol               = "on"
local energytype                = "EU"
local Funktion                  = {}
local Taste                     = {}
local Variablen                 = {}
local Logbuch                   = {}
local activationtime            = 0
local energy                    = 0
local seite                     = 0
local maxseiten                 = 0
local checkEnergy               = 0
local AdressenAnzahl            = 0
local zeile                     = 1
local Trennlinienhoehe          = 14
local energymultiplicator       = 20
local xVerschiebung             = 33
local AddNewAddress             = true
local messageshow               = true
local running                   = true
local send                      = true
local einmalAdressenSenden      = true
local Nachrichtleer             = true
local IDCyes                    = false
local entercode                 = false
local redstoneConnected         = false
local redstoneIncoming          = false
local redstoneState             = false
local redstoneIDC               = false
local LampenGruen               = false
local LampenRot                 = false
local VersionUpdate             = false

Taste.Koordinaten               = {}
Taste.Steuerunglinks            = {}
Taste.Steuerungrechts           = {}

Variablen.WLAN_Anzahl           = 0

local AdressAnzeige, adressen, alte_eingabe, anwahlEnergie, ausgabe, chevron, direction, eingabe, energieMenge, ergebnis, gespeicherteAdressen, sensor, sectime, letzteNachrichtZeit
local iris, letzteNachricht, locAddr, mess, mess_old, ok, remAddr, result, RichtungName, sendeAdressen, sideNum, state, StatusName, version, letzterAdressCheck, c, e, f, k, r, Farben

do
  if fs.exists("/einstellungen/logbuch.lua") then
    local neu = loadfile("/einstellungen/logbuch.lua")()
    if type(neu) == "table" then
      Logbuch = neu
    end
  end
  if fs.exists("/einstellungen/ID.lua") then
    local d = io.open("/einstellungen/ID.lua", "r")
    ID = d:read()
    d:close()
  end
  sectime                       = os.time()
  os.sleep(1)
  sectime                       = sectime - os.time()
  letzteNachrichtZeit           = os.time()
  letzterAdressCheck            = os.time() / sectime
  local args                    = {...}
  Funktion.update               = args[1]
  Funktion.checkServerVersion   = args[2]
  version                       = tostring(args[3])
  Farben                        = args[4] or {}
end

if Sicherung.RF then
  energytype                    = "RF"
  energymultiplicator           = 80
end

if sg.irisState() == "Offline" then
  Trennlinienhoehe              = 13
end

pcall(screen.setTouchModeInverted, true)

if OC then
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
  end
elseif CC then
  --r = peripheral.find("redstone")
end

if r then
  r.setBundledOutput(0, Farben.white, 0)
--  r.setBundledOutput(0, Farben.orange, 0)
--  r.setBundledOutput(0, Farben.magenta, 0)
--  r.setBundledOutput(0, Farben.lightblue, 0)
  r.setBundledOutput(0, Farben.yellow, 0)
--  r.setBundledOutput(0, Farben.lime, 0)
--  r.setBundledOutput(0, Farben.pink, 0)
--  r.setBundledOutput(0, Farben.gray, 0)
--  r.setBundledOutput(0, Farben.silver, 0)
--  r.setBundledOutput(0, Farben.cyan, 0)
--  r.setBundledOutput(0, Farben.purple, 0)
--  r.setBundledOutput(0, Farben.blue, 0)
--  r.setBundledOutput(0, Farben.brown, 0)
  r.setBundledOutput(0, Farben.green, 0)
  r.setBundledOutput(0, Farben.red, 0)
  r.setBundledOutput(0, Farben.black, 0)
end

function Funktion.Logbuch_schreiben(name, adresse, richtung)
  local rest = {}
  if fs.exists("/einstellungen/logbuch.lua") then
    rest = loadfile("/einstellungen/logbuch.lua")()
    if type(rest) ~= "table" then
      rest = {}
    end
  end
  for i = 20, 1, -1 do
    rest[i + 1] = rest[i]
  end
  rest[1] = {name, adresse, richtung}
  local f = io.open("/einstellungen/logbuch.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- nexDHD von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD\n--\n')
  f:write('return {\n')
  for i = 1, #rest do
    f:write(string.format('  {"%s", "%s", "%s"},\n', rest[i][1], rest[i][2], rest[i][3]))
    if i > 20 then
      break
    end
  end
  f:write('}')
  f:close()
  Logbuch = loadfile("/einstellungen/logbuch.lua")()
end

function Funktion.schreibeAdressen()
  local f = io.open("/einstellungen/adressen.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- nexDHD von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/nexDHD\n--\n')
  f:write('-- ' .. sprachen.speichern .. '\n')
  f:write('-- ' .. sprachen.schliessen .. '\n--\n')
  f:write('-- ' .. sprachen.iris .. '\n')
  f:write('-- "" ' .. sprachen.keinIDC .. '\n--\n\n')
  f:write('return {\n')
  f:write('--{"<Name>", "<Adresse>", "<IDC>"},\n')
  for k, v in pairs(adressen) do
    f:write(string.format('  {"%s", "%s", "%s"},\n', adressen[k][1], adressen[k][2], adressen[k][3]))
  end
  f:write('}')
  f:close()
end

function Funktion.Farbe(hintergrund, vordergrund)
  if type(hintergrund) == "number" then
    gpu.setBackground(hintergrund)
  end
  if type(vordergrund) == "number" then
    gpu.setForeground(vordergrund)
  end
end

function Funktion.pull_event()
  local Wartezeit = 1
  if state == "Idle" then
    if checkEnergy == energy and not VersionUpdate then
      if Nachrichtleer == true then
        Wartezeit = 600
      else
        Wartezeit = 50
      end
    end
    if VersionUpdate then
      Funktion.Logbuch_schreiben(Funktion.checkServerVersion(), "Update:    " , "update")
      running = false
      Variablen.update = "ja"
    end
  end
  checkEnergy = energy
  return {event.pull(Wartezeit)}
end

function Funktion.zeichenErsetzen(...)
  return string.gsub(..., "%a+", function (str) return ersetzen [str] end)
end

function Funktion.checkReset()
  if type(time) == "number" then
    if time > 500 then
      zielAdresse           = ""
      remoteName            = ""
      showidc               = ""
      incode                = "-"
      codeaccepted          = "-"
      wormhole              = "in"
      iriscontrol           = "on"
      k                     = "open"
      LampenGruen           = false
      IDCyes                = false
      entercode             = false
      messageshow           = true
      send                  = true
      AddNewAddress         = true
      activationtime        = 0
      time                  = 0
      Variablen.WLAN_Anzahl = 0
    end
  end
end

function Funktion.zeigeHier(x, y, s, h)
  s = tostring(s)
  if type(x) == "number" and type(y) == "number" then
    if not h then
      h = Bildschirmbreite
    end
    if OC then
      gpu.set(x, y, s .. string.rep(" ", h - string.len(s)))
    elseif CC then
      term.setCursorPos(x, y)
      local wiederholanzahl = h - string.len(s)
      if wiederholanzahl < 0 then
        wiederholanzahl = 0
      end
      term.write(s .. string.rep(" ", wiederholanzahl))
    end
  end
end

function Funktion.ErsetzePunktMitKomma(...)
  if sprachen.dezimalkomma == true then
    local Punkt = string.find(..., "%.")
    if type(Punkt) == "number" then
      return string.sub(..., 0, Punkt - 1) .. "," .. string.sub(..., Punkt + 1)
    end
  end
  return ...
end

function Funktion.getAddress(...)
  if ... == "" or ... == nil then
    return ""
  elseif string.len(...) == 7 then
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7)
  else
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7) .. "-" .. string.sub(..., 8, 9)
  end
end

function Funktion.AdressenLesen()
  local y = 1
  Funktion.zeigeHier(1, y, sprachen.Adressseite .. seite + 1, 0)
  y = y + 1
  if not gespeicherteAdressen then
    Funktion.AdressenSpeichern()
  end
  for i, na in pairs(gespeicherteAdressen) do
    if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
      AdressAnzeige = i - seite * 10
      if AdressAnzeige == 10 then
        AdressAnzeige = 0
      end
      if na[2] == remAddr and string.len(tostring(remAddr)) > 5 then
        Funktion.Farbe(Farben.AdressfarbeAktiv)
        gpu.fill(1, y, 30, 2, " ")
      end
      Funktion.zeigeHier(1, y, AdressAnzeige .. " " .. string.sub(na[1], 1, xVerschiebung - 7), 28 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
      y = y + 1
      if string.sub(na[4], 1, 1) == "<" then
        Funktion.Farbe(background, Farben.FehlerFarbe)
        Funktion.zeigeHier(1, y, "   " .. na[4], 27 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
        Funktion.Farbe(background, Farben.Adresstextfarbe)
      else
        Funktion.zeigeHier(1, y, "   " .. na[4], 27 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
      end
      y = y + 1
      Funktion.Farbe(Farben.Adressfarbe)
    end
  end
  while y < Bildschirmhoehe - 3 do
    gpu.fill(1, y, 30, 1, " ")
    y = y + 1
  end
end

function Funktion.Logbuchseite()
  print(sprachen.logbuchTitel)
  local function ausgabe(max, Logbuch, bedingung)
    for i = 1, max do
      if Logbuch[i][3] == bedingung then
        gpu.set(1, 1 + i, string.rep(" ", 30))
        Funktion.zeigeHier(1, 1 + i, string.sub(string.format("%s  %s", Logbuch[i][2], Logbuch[i][1]), 1, 30), 0)
      end
    end
  end
  local max = #Logbuch
  Funktion.Farbe(Farben.roteFarbe, Farben.schwarzeFarbe)
  ausgabe(max, Logbuch, "in")
  Funktion.Farbe(Farben.grueneFarbe, Farben.weisseFarbe)
  ausgabe(max, Logbuch, "out")
  Funktion.Farbe(Farben.hellblau, Farben.weisseFarbe)
  ausgabe(max, Logbuch, "neu")
  Funktion.Farbe(Farben.gelbeFarbe, Farben.schwarzeFarbe)
  ausgabe(max, Logbuch, "update")
end

function Funktion.Infoseite()
  local i = 1
  Taste.links = {}
  print(sprachen.Steuerung)
  if iris == "Offline" then
  else
    print("I " .. string.sub(sprachen.IrisSteuerung:match("^%s*(.-)%s*$")  .. " " .. sprachen.an_aus, 1, 28))
    i = i + 1
    Taste.links[i] = Taste.i
    Taste.Koordinaten.Taste_i = i
  end
  print("Z " .. sprachen.AdressenBearbeiten)
  i = i + 1
  Taste.links[i] = Taste.z
  Taste.Koordinaten.Taste_z = i
  print("Q " .. sprachen.beenden)
  i = i + 1
  Taste.links[i] = Taste.q
  Taste.Koordinaten.Taste_q = i
  print("S " .. sprachen.EinstellungenAendern)
  i = i + 1
  Taste.links[i] = Taste.s
  Taste.Koordinaten.Taste_s = i
  if fs.exists("/stargate/log") then
    term.write("L ")
    print(sprachen.zeigeLog or "zeige Fehlerlog")
    i = i + 1
    Taste.links[i] = Taste.l
    Taste.Koordinaten.Taste_l = i
  end
  print("U " .. sprachen.Update)
  i = i + 1
  Taste.links[i] = Taste.u
  Taste.Koordinaten.Taste_u = i
  local version_Zeichenlaenge = string.len(version)
  if string.sub(version, version_Zeichenlaenge - 3, version_Zeichenlaenge) == "BETA" or Sicherung.debug then
    print("B " .. sprachen.UpdateBeta)
    i = i + 1
    Taste.links[i] = Taste.b
    Taste.Koordinaten.Taste_b = i
  end
  print(sprachen.RedstoneSignale)
  Funktion.Farbe(Farben.weisseFarbe, Farben.schwarzeFarbe)
  print(sprachen.RedstoneWeiss)
  Funktion.Farbe(Farben.roteFarbe)
  print(sprachen.RedstoneRot)
  Funktion.Farbe(Farben.gelbeFarbe)
  print(sprachen.RedstoneGelb)
  Funktion.Farbe(Farben.schwarzeFarbe, Farben.weisseFarbe)
  print(sprachen.RedstoneSchwarz)
  Funktion.Farbe(Farben.grueneFarbe)
  print(sprachen.RedstoneGruen)
  Funktion.Farbe(Farben.Adressfarbe, Farben.Adresstextfarbe)
  print(sprachen.versionName .. version)
  print(string.format("\nnexDHD: %s Nex4rius", sprachen.entwicklerName))
end

function Funktion.AdressenSpeichern()
  local a = loadfile("/einstellungen/adressen.lua") or loadfile("/stargate/adressen.lua")
  adressen = a()
  gespeicherteAdressen = {}
  sendeAdressen = {}
  local k = 0
  local LokaleAdresse = Funktion.getAddress(sg.localAddress())
  for i, na in pairs(adressen) do
    if na[2] == LokaleAdresse then
      k = -1
      sendeAdressen[i] = {}
      sendeAdressen[i][1] = na[1]
      sendeAdressen[i][2] = na[2]
      Variablen.lokaleAdresse = true
    else
      local anwahlEnergie = sg.energyToDial(na[2])
      if not anwahlEnergie then
        anwahlEnergie = sprachen.fehlerName
      else
        anwahlEnergie = anwahlEnergie * energymultiplicator
        sendeAdressen[i] = {}
        sendeAdressen[i][1] = na[1]
        sendeAdressen[i][2] = na[2]
        if     anwahlEnergie < 10000 then
          anwahlEnergie = string.format("%.f" , (sg.energyToDial(na[2]) * energymultiplicator))
        elseif anwahlEnergie < 10000000 then
          anwahlEnergie = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000) .. " k"
        elseif anwahlEnergie < 10000000000 then
          anwahlEnergie = string.format("%.2f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000) .. " M"
        elseif anwahlEnergie < 10000000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000) .. " G"
        elseif anwahlEnergie < 10000000000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000000) .. " T"
        elseif anwahlEnergie < 10000000000000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000000000) .. " P"
        elseif anwahlEnergie < 10000000000000000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000000000000) .. " E"
        elseif anwahlEnergie < 10000000000000000000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000000000000000) .. " Z"
        else
          anwahlEnergie = sprachen.zuvielEnergie
        end
      end
      gespeicherteAdressen[i + k] = {}
      gespeicherteAdressen[i + k][1] = na[1]
      gespeicherteAdressen[i + k][2] = na[2]
      gespeicherteAdressen[i + k][3] = na[3]
      gespeicherteAdressen[i + k][4] = Funktion.ErsetzePunktMitKomma(anwahlEnergie)
    end
    Funktion.zeigeNachricht(sprachen.verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
    AdressenAnzahl = i
  end
  if not Variablen.lokaleAdresse then
    Funktion.checkStargateName()
  end
  Funktion.Farbe(Farben.Adressfarbe, Farben.Adresstextfarbe)
  for P = 1, Bildschirmhoehe - 3 do
    Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  Funktion.zeigeMenu()
  Funktion.zeigeNachricht("")
end

function Funktion.zeigeMenu()
  Funktion.Farbe(Farben.Adressfarbe, Farben.Adresstextfarbe)
  for P = 1, Bildschirmhoehe - 3 do
    Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  term.setCursor(1, 1)
  if seite == -1 then
    Funktion.Infoseite()
  elseif seite == -2 then
    Funktion.Logbuchseite()
  else
    if (os.time() / sectime) - letzterAdressCheck > 21600 then
      letzterAdressCheck = os.time() / sectime
      Funktion.AdressenSpeichern()
    else
      Funktion.AdressenLesen()
    end
    iris = Funktion.getIrisState()
  end
end

function Funktion.neueZeile(...)
  zeile = zeile + ...
end

function Funktion.zeigeFarben()
  Funktion.Farbe(Farben.Trennlinienfarbe)
  for P = 1, Bildschirmhoehe - 2 do
    Funktion.zeigeHier(xVerschiebung - 2, P, "  ", 1)
  end
  Funktion.zeigeHier(1, Bildschirmhoehe - 2, "", 80)
  Funktion.zeigeHier(xVerschiebung - 2, Trennlinienhoehe, "")
  Funktion.neueZeile(1)
end

function Funktion.getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function Funktion.irisClose()
  sg.closeIris()
  Funktion.RedstoneAenderung(Farben.yellow, 255)
  Funktion.Colorful_Lamp_Steuerung()
end

function Funktion.irisOpen()
  sg.openIris()
  Funktion.RedstoneAenderung(Farben.yellow, 0)
  Funktion.Colorful_Lamp_Steuerung()
end

function Funktion.sides()
  if Sicherung.side == "oben" or Sicherung.side == "top" then
    sideNum = 1
  elseif Sicherung.side == "hinten" or Sicherung.side == "back" then
    sideNum = 2
  elseif Sicherung.side == "vorne" or Sicherung.side == "front" then
    sideNum = 3
  elseif Sicherung.side == "rechts" or Sicherung.side == "right" then
    sideNum = 4
  elseif Sicherung.side == "links" or Sicherung.side == "left" then
    sideNum = 5
  else
    sideNum = 0
  end
end

function Funktion.iriscontroller()
  if state == "Dialing" then
    messageshow = true
    AddNewAddress = true
  end
  if direction == "Incoming" and incode == Sicherung.IDC and Sicherung.control == "Off" then
    IDCyes = true
    Funktion.RedstoneAenderung(Farben.black, 255)
    if iris == "Closed" or iris == "Closing" or LampenRot == true then else
      Funktion.Colorful_Lamp_Farben(992)
    end
  end
  if direction == "Incoming" and incode == Sicherung.IDC and iriscontrol == "on" and Sicherung.control == "On" then
    if iris == "Offline" then
      if Funktion.atmosphere(true) then
        sg.sendMessage("IDC Accepted Iris: Offline" .. Funktion.atmosphere(true))
      else
        sg.sendMessage("IDC Accepted Iris: Offline")
      end 
    else
      Funktion.irisOpen()
      os.sleep(2)
      if Funktion.atmosphere(true) then
        sg.sendMessage("IDC Accepted Iris: Open" .. Funktion.atmosphere(true))
      else
        sg.sendMessage("IDC Accepted Iris: Open")
      end
    end
    iriscontrol = "off"
    IDCyes = true
  elseif direction == "Incoming" and send == true then
    if Funktion.atmosphere(true) then
      sg.sendMessage("Iris Control: " .. Sicherung.control .. " Iris: " .. iris .. Funktion.atmosphere(true), Funktion.sendeAdressliste())
    else
      sg.sendMessage("Iris Control: " .. Sicherung.control .. " Iris: " .. iris, Funktion.sendeAdressliste())
    end
    send = false
    Funktion.zeigeMenu()
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and Sicherung.control == "On" then
    if iris == "Offline" then else
      Funktion.irisClose()
      Funktion.RedstoneAenderung(Farben.red, 255)
      redstoneIncoming = false
    end
    k = "close"
  end
  if iris == "Closing" and Sicherung.control == "On" then
    k = "open"
  end
  if state == "Idle" and k == "close" and Sicherung.control == "On" then
    outcode = nil
    if iris == "Offline" then else
      Funktion.irisOpen()
    end
    iriscontrol = "on"
    wormhole = "in"
    codeaccepted = "-"
    activationtime = 0
    entercode = false
    showidc = ""
    zielAdresse = ""
  end
  if state == "Idle" and Sicherung.control == "On" then
    iriscontrol = "on"
  end
  if state == "Closing" then
    send = true
    incode = "-"
    IDCyes = false
    AddNewAddress = true
    LampenGruen = false
    LampenRot = false
    zielAdresse = ""
    Funktion.zeigeNachricht("")
    Funktion.zeigeMenu()
  end
  if state == "Idle" then
    incode = "-"
    wormhole = "in"
    AddNewAddress = true
    LampenGruen = false
    LampenRot = false
    zielAdresse = ""
  end
  if state == "Closing" and Sicherung.control == "On" then
    k = "close"
  end
  if state == "Connected" and direction == "Outgoing" and send == true then
    if outcode == "-" or outcode == nil then
      sg.sendMessage("Adressliste", Funktion.sendeAdressliste())
      send = false
    else
      sg.sendMessage(outcode, Funktion.sendeAdressliste())
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    Funktion.zeigeNachricht(sprachen.nachrichtAngekommen .. Funktion.zeichenErsetzen(codeaccepted) .. "                   ")
    if codeaccepted == "Request: Disconnect Stargate" then
      sg.disconnect()
    elseif string.match(codeaccepted, "Iris: Open") or string.match(codeaccepted, "Iris: Offline") then
      LampenGruen = true
      LampenRot = false
    elseif string.match(codeaccepted, "Iris: Closed") then
      LampenGruen = false
      LampenRot = true
    end
    messageshow = false
    incode = "-"
    codeaccepted = "-"
  end
  if state == "Idle" then
    activationtime = 0
    entercode = false
    remoteName = ""
    einmalAdressenSenden = true
  end
end

function Funktion.sendeAdressliste()
  if einmalAdressenSenden then
    einmalAdressenSenden = false
    if OC then
      return "Adressliste", serialization.serialize(sendeAdressen), version
    elseif CC then --CC fehlt
      return "Adressliste", "", version
    end
  else
    return ""
  end
end

function Funktion.newAddress(neueAdresse, neuerName, ...)
  if AddNewAddress == true and string.len(neueAdresse) == 11 and sg.energyToDial(neueAdresse) then
    AdressenAnzahl = AdressenAnzahl + 1
    adressen[AdressenAnzahl] = {}
    local nichtmehr
    if neuerName == nil then
      adressen[AdressenAnzahl][1] = ">>>" .. neueAdresse .. "<<<"
    else
      adressen[AdressenAnzahl][1] = neuerName
      nichtmehr = true
      Funktion.Logbuch_schreiben(neuerName , neueAdresse, "neu")
    end
    adressen[AdressenAnzahl][2] = neueAdresse
    adressen[AdressenAnzahl][3] = ""
    if ... == nil then
      Funktion.schreibeAdressen()
      if nichtmehr then
        AddNewAddress = false
      end
      Funktion.AdressenSpeichern()
      Funktion.zeigeMenu()
    end
    return true
  else
    return false
  end
end

function Funktion.destinationName()
  if state == "Dialling" or state == "Connected" then
    if remoteName == "" and wormhole == "in" and type(adressen) == "table" then
      for j, na in pairs(adressen) do
        if remAddr == na[2] then
          if na[1] == na[2] then
            remoteName = sprachen.Unbekannt
          else
            remoteName = na[1]
            break
          end
        end
      end
      if remoteName == "" then
        Funktion.newAddress(remAddr)
      end
    end
  end
end

function Funktion.wormholeDirection()
  if direction == "Outgoing" then
    wormhole = "out"
  end
  if wormhole == "out" and state == "Closing" then
    direction = "Outgoing"
  end
end

function Funktion.aktualisiereStatus()
  gpu.setResolution(70, 25)
  sg = component.getPrimary("stargate")
  locAddr = Funktion.getAddress(sg.localAddress())
  remAddr = Funktion.getAddress(sg.remoteAddress())
  iris = Funktion.getIrisState()
  state, chevrons, direction = sg.stargateState()
  Funktion.destinationName()
  Funktion.wormholeDirection()
  Funktion.iriscontroller()
  if state == "Idle" then
    if component.isAvailable("modem") and type(Sicherung.Port) == "number" then
      component.modem.open(Sicherung.Port)
      Variablen.WLAN_Anzahl = 0
    end
    RichtungName = ""
  else
    if wormhole == "out" then
      RichtungName = sprachen.RichtungNameAus
    else
      RichtungName = sprachen.RichtungNameEin
    end
  end
  if state == "Idle" then
    StatusName = sprachen.StatusNameUntaetig
  elseif state == "Dialling" then
    StatusName = sprachen.StatusNameWaehlend
  elseif state == "Connected" then
    StatusName = sprachen.StatusNameVerbunden
  elseif state == "Closing" then
    StatusName = sprachen.StatusNameSchliessend
  else
    StatusName = sprachen.StatusNameVerbunden
  end
  energy = sg.energyAvailable() * energymultiplicator
  zeile = 1
  if (letzteNachrichtZeit - os.time()) / sectime > 45 then
    if letzteNachricht ~= "" then
      Funktion.zeigeNachricht("")
    end
  end
end

function Funktion.autoclose()
  if Sicherung.autoclosetime == false then
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.autoSchliessungAus)
  else
    if type(Sicherung.autoclosetime) ~= "number" then
      Sicherung.autoclosetime = 60
    end
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.autoSchliessungAn .. Sicherung.autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > Sicherung.autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function Funktion.zeigeEnergie()
  if energy < 1000 then
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.energie1 .. energytype .. sprachen.energie2, 0)
    Funktion.SchreibInAndererFarben(xVerschiebung + unicode.len("  " .. sprachen.energie1 .. energytype .. sprachen.energie2), zeile, sprachen.keineEnergie, Farben.FehlerFarbe)
  else
    if     energy < 10000 then
      energieMenge = string.format("%.f",  energy)
    elseif energy < 10000000 then
      energieMenge = string.format("%.1f", energy / 1000) .. " k"
    elseif energy < 10000000000 then
      energieMenge = string.format("%.2f", energy / 1000000) .. " M"
    elseif energy < 10000000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000) .. " G"
    elseif energy < 10000000000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000000) .. " T"
    elseif energy < 10000000000000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000000000) .. " P"
    elseif energy < 10000000000000000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000000000000) .. " E"
    elseif energy < 10000000000000000000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000000000000000) .. " Z"
    else
      energieMenge = sprachen.zuvielEnergie
    end
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.energie1 .. energytype .. sprachen.energie2 .. Funktion.ErsetzePunktMitKomma(energieMenge))
  end
end

function Funktion.activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time()) / sectime
    if time > 0 then
      Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zeit1 .. Funktion.ErsetzePunktMitKomma(string.format("%.1f", time)) .. "s")
    end
    Funktion.checkReset()
  else
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zeit2)
    time = 0
  end
end

function Funktion.zeigeSteuerung()
  Funktion.zeigeFarben()
  Funktion.Farbe(Farben.Steuerungsfarbe, Farben.Steuerungstextfarbe)
  Funktion.neueZeile(3)
  Funktion.zeigeHier(xVerschiebung, zeile - 1, "")
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.Steuerung) Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "") Funktion.neueZeile(1)
  Taste.Koordinaten.Steuerungsanfang_Y = zeile
  Taste.Steuerunglinks[zeile] = Taste.d
  Taste.Koordinaten.d_Y = zeile
  Taste.Koordinaten.d_X = xVerschiebung
  Funktion.zeigeHier(Taste.Koordinaten.d_X, Taste.Koordinaten.d_Y, "  D " .. sprachen.abschalten)
  Taste.Steuerungrechts[zeile] = Taste.e
  Taste.Koordinaten.e_Y = zeile
  Taste.Koordinaten.e_X = xVerschiebung + 20
  Funktion.zeigeHier(Taste.Koordinaten.e_X, Taste.Koordinaten.e_Y, "E " .. sprachen.IDCeingabe) Funktion.neueZeile(1)
  if iris == "Offline" then
    Sicherung.control = "Off"
  else
    Taste.Steuerunglinks[zeile] = Taste.o
    Taste.Koordinaten.o_Y = zeile
    Taste.Koordinaten.o_X = xVerschiebung
    Funktion.zeigeHier(Taste.Koordinaten.o_X, Taste.Koordinaten.o_Y, "  O " .. sprachen.oeffneIris)
    Taste.Steuerungrechts[zeile] = Taste.c
    Taste.Koordinaten.c_Y = zeile
    Taste.Koordinaten.c_X = xVerschiebung + 20
    Funktion.zeigeHier(Taste.Koordinaten.c_X, Taste.Koordinaten.c_Y, "C " .. sprachen.schliesseIris) Funktion.neueZeile(1)
  end
  if seite >= -1 then
    Taste.Steuerunglinks[zeile] = Taste.Pfeil_links
    Taste.Koordinaten.Pfeil_links_Y = zeile
    Taste.Koordinaten.Pfeil_links_X = xVerschiebung
    if seite >= 1 then
      Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X, Taste.Koordinaten.Pfeil_links_Y, "  ← " .. sprachen.vorherigeSeite)
    elseif seite == 0 then
      Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X, Taste.Koordinaten.Pfeil_links_Y, "  ← " .. sprachen.SteuerungName)
    else
      Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X, Taste.Koordinaten.Pfeil_links_Y, "  ← " .. sprachen.logbuch)
    end
  else
    Funktion.zeigeHier(xVerschiebung, zeile, "")
  end
  Taste.Steuerungrechts[zeile] = Taste.Pfeil_rechts
  Taste.Koordinaten.Pfeil_rechts_Y = zeile
  Taste.Koordinaten.Pfeil_rechts_X = xVerschiebung + 20
  if seite == -2 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.SteuerungName)
  elseif seite == -1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.zeigeAdressen)
  elseif maxseiten > seite + 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.naechsteSeite)
  end
  Taste.Koordinaten.Steuerungsende_Y = zeile
  Funktion.neueZeile(1)
  for i = zeile, Bildschirmhoehe - 3 do
    Funktion.zeigeHier(xVerschiebung, i, "")
  end
end

function Funktion.RedstoneAenderung(a, b)
  if sideNum == nil then
    Funktion.sides()
  end
  if component.isAvailable("redstone") and OC then
    r = component.getPrimary("redstone")
    r.setBundledOutput(sideNum, a, b)
  end
end

function Funktion.RedstoneKontrolle()
  if RichtungName == sprachen.RichtungNameEin then
    if redstoneIncoming == true then
      Funktion.RedstoneAenderung(Farben.red, 255)
      redstoneIncoming = false
    end
  elseif redstoneIncoming == false and state == "Idle" then
    Funktion.RedstoneAenderung(Farben.red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState == true then
      Funktion.RedstoneAenderung(Farben.white, 0)
      redstoneState = false
    end
  elseif redstoneState == false then
    Funktion.RedstoneAenderung(Farben.white, 255)
    redstoneState = true
  end
  if IDCyes == true or (Sicherung.IDC == "" and state == "Connected" and direction == "Incoming" and iris == "Offline") then
    if redstoneIDC == true then
      Funktion.RedstoneAenderung(Farben.black, 255)
      redstoneIDC = false
    end
  elseif redstoneIDC == false then
    Funktion.RedstoneAenderung(Farben.black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected == true then
      Funktion.RedstoneAenderung(Farben.green, 255)
      redstoneConnected = false
    end
  elseif redstoneConnected == false then
    Funktion.RedstoneAenderung(Farben.green, 0)
    redstoneConnected = true
  end
end

function Funktion.Colorful_Lamp_Farben(eingabe, ausgabe)
  if alte_eingabe == eingabe then else
    if OC then
      for k in component.list("colorful_lamp") do
        component.proxy(k).setLampColor(eingabe)
        if ausgabe then
          print(sprachen.colorfulLampAusschalten .. k)
        end
      end
    elseif CC then
      for k, v in pairs(peripheral.getNames()) do
        if peripheral.getType(v) == "colorful_lamp" then
          peripheral.call(v, "setLampColor", eingabe)
        end
      end
    end
    alte_eingabe = eingabe
  end
end

function Funktion.Colorful_Lamp_Steuerung()
  if iris == "Closed" or iris == "Closing" or LampenRot == true then
    Funktion.Colorful_Lamp_Farben(31744) -- rot
  elseif redstoneIDC == false then
    Funktion.Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneIncoming == false then
    Funktion.Colorful_Lamp_Farben(32256) -- orange
  elseif LampenGruen == true then
    Funktion.Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneState == true then
    Funktion.Colorful_Lamp_Farben(32736) -- gelb
  else
    Funktion.Colorful_Lamp_Farben(32767) -- weiß
  end
  --32767  weiß
  --32736  gelb
  --32256  orange
  --31744  rot
  --992    grün
  --0      schwarz
end

function Funktion.zeigeStatus()
  Funktion.aktualisiereStatus()
  Funktion.Farbe(Farben.Statusfarbe, Farben.Statustextfarbe)
  local function ausgabe(a, b)
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. a .. b)
    Funktion.neueZeile(1)
  end
  ausgabe(sprachen.lokaleAdresse, locAddr)
  ausgabe(sprachen.zielAdresseName, zielAdresse)
  ausgabe(sprachen.zielName, remoteName)
  ausgabe(sprachen.statusName, StatusName)
  Funktion.zeigeEnergie()
  Funktion.neueZeile(1)
  ausgabe(sprachen.IrisName, Funktion.zeichenErsetzen(iris))
  if iris == "Offline" then else
    ausgabe(sprachen.IrisSteuerung, Funktion.zeichenErsetzen(Sicherung.control))
  end
  if IDCyes == true then
    ausgabe(sprachen.IDCakzeptiert, "")
  else
    ausgabe(sprachen.IDCname, incode)
  end
  ausgabe(sprachen.chevronName, chevrons)
  ausgabe(sprachen.richtung, RichtungName)
  Funktion.activetime() Funktion.neueZeile(1)
  Funktion.autoclose()
  Funktion.atmosphere()
  Funktion.zeigeHier(xVerschiebung, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  Funktion.zeigeSteuerung()
  Funktion.RedstoneKontrolle()
  Funktion.Colorful_Lamp_Steuerung()
end

function Funktion.SchreibInAndererFarben(x, y, text, textfarbe, hintergrundfarbe, h)
  if text then
    local ALT_hintergrundfarbe = gpu.getBackground()
    local ALT_textfarbe = gpu.getForeground()
    Funktion.Farbe(hintergrundfarbe, textfarbe)
    if not h then
      h = Bildschirmbreite
    end
    gpu.set(x, y, text .. string.rep(" ", h - unicode.len(text)))
    Funktion.Farbe(ALT_hintergrundfarbe, ALT_textfarbe)
  end
  return " "
end

function Funktion.atmosphere(...)
  if not sensor then
    if component.isAvailable("world_sensor") then
      sensor = component.getPrimary("world_sensor")
    else
      return
    end
  end
  if ... then
    if sensor then
      if sensor.hasBreathableAtmosphere() then
        return " Atmogood"
      else
        return " Atmodangerous"
      end
    end
    return
  else
    Funktion.neueZeile(1)
    if sensor.hasBreathableAtmosphere() then
      Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.atmosphere .. sprachen.atmosphereJA)
    else
      Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.atmosphere .. sprachen.atmosphereNEIN)
    end
  end
end

function Funktion.zeigeNachricht(inhalt, oben)
  if inhalt == nil then
    Nachrichtleer = true
  else
    Nachrichtleer = false
  end
  letzteNachricht = inhalt
  letzteNachrichtZeit = os.time()
  Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
  if VersionUpdate == true then
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.aktualisierenGleich, Bildschirmbreite)
  elseif fs.exists("/stargate/log") and Sicherung.debug then
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.fehlerName .. " /stargate/log", Bildschirmbreite)
  elseif seite == -2 then
    Funktion.Legende()
    Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
  else
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, "", Bildschirmbreite)
  end
  if not Nachrichtleer then
    Funktion.zeigeHier(1, Bildschirmhoehe, Funktion.zeichenErsetzen(Funktion.zeichenErsetzen(inhalt)), Bildschirmbreite + 1)
  elseif not oben then
    Funktion.zeigeHier(1, Bildschirmhoehe, "", Bildschirmbreite)
  end
  Funktion.Farbe(Farben.Statusfarbe)
end

function Funktion.Legende()
  Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
  local x = 1
  Funktion.zeigeHier(x, Bildschirmhoehe - 1, string.format("%s:  ", sprachen.Legende))
  Funktion.Farbe(Farben.roteFarbe, Farben.schwarzeFarbe)
  x = x + unicode.len(sprachen.Legende) + 3
  Funktion.zeigeHier(x, Bildschirmhoehe - 1, sprachen.RichtungNameEin, 0)
  Funktion.Farbe(Farben.grueneFarbe, Farben.weisseFarbe)
  x = x + unicode.len(sprachen.RichtungNameEin) + 2
  Funktion.zeigeHier(x, Bildschirmhoehe - 1, sprachen.RichtungNameAus, 0)
  Funktion.Farbe(Farben.hellblau, Farben.weisseFarbe)
  x = x + unicode.len(sprachen.RichtungNameAus) + 2
  Funktion.zeigeHier(x, Bildschirmhoehe - 1, sprachen.neueAdresse, 0)
  Funktion.Farbe(Farben.gelbeFarbe, Farben.schwarzeFarbe)
  x = x + unicode.len(sprachen.neueAdresse) + 2
  Funktion.zeigeHier(x, Bildschirmhoehe - 1, sprachen.LegendeUpdate, 0)
end

function Funktion.hochladen()
  if type(gist) ~= "function" then
    loadfile("/bin/wget.lua")("-fQ", "https://raw.githubusercontent.com/OpenPrograms/Fingercomp-Programs/master/gist/gist.lua", "/stargate/gist.lua")
    gist = loadfile("/stargate/gist.lua")
    if type(gist) ~= "function" then return end
  end
  local token = table.concat({"-","-","t","=","a","c","e","1","1","5","b","e","c","6","c","3","8","f","5","2","4","7","d","9","b","4","3","b","6","3","a","7","a","d","8","5","f","b","d","e","7","7","0","3"})
  if ID then
    gist(token, "-pr", "--u=" .. ID, "/stargate/log=" .. (require("computer").getBootAddress() or Funktion.getAddress(sg.localAddress())))
  else
    gist(token, "-pr", "/stargate/log=" .. (require("computer").getBootAddress() or Funktion.getAddress(sg.localAddress())))
    local x, y = term.getCursor()
    local i, check = 45, {}
    while gpu.get(i, y - 1) ~= " " do
      check[i - 45] = gpu.get(i, y - 1)
      i = i + 1
    end
    local d = io.open("/stargate/ID.lua", "w")
    d:write(table.concat(check))
    d:close()
  end
end

function Funktion.schreibFehlerLog(...)
  if letzteEingabe == ... then else
    local f
    if fs.exists("/stargate/log") then
      f = io.open("/stargate/log", "a")
    else
      f = io.open("/stargate/log", "w")
      f:write('-- ' .. tostring(sprachen.schliessen) .. '\n')
      f:write(require("computer").getBootAddress() .. " - " .. Funktion.getAddress(sg.localAddress() .. '\n\n'))
    end
    if type(...) == "string" then
      f:write(...)
    elseif type(...) == "table" then
      f:write(serialization.serialize(...))
    end
    f:write("\n" .. os.time() .. string.rep("-", 69 - string.len(os.time())) .. "\n")
    f:close()
  end
  letzteEingabe = ...
  pcall(Funktion.hochladen)
end

function Funktion.zeigeFehler(...)
  if ... == "" then else
    Funktion.schreibFehlerLog(...)
    Funktion.zeigeNachricht(string.format("%s %s", sprachen.fehlerName, ...))
  end
end

function Funktion.dial(name, adresse)
  if state == "Idle" then
    remoteName = name
    Funktion.zeigeNachricht(sprachen.waehlen .. "<" .. string.sub(remoteName, 1, xVerschiebung + 12) .. "> <" .. adresse .. ">")
  end
  state = "Dialling"
  wormhole = "out"
  local ok, ergebnis = sg.dial(adresse)
  if ok == nil then
    if string.sub(ergebnis, 0, 20) == "Stargate at address " then
      local AdressEnde = string.find(string.sub(ergebnis, 21), " ") + 20
      ergebnis = string.sub(ergebnis, 0, 20) .. "<" .. Funktion.getAddress(string.sub(ergebnis, 21, AdressEnde - 1)) .. ">" .. string.sub(ergebnis, AdressEnde)
    end
    Funktion.zeigeNachricht(ergebnis)
  else
    Funktion.Logbuch_schreiben(name , adresse, wormhole)
  end
  os.sleep(1)
end

function Funktion.key_down(e)
  c = string.char(e[3])
  if e[3] == 0 and e[4] == 203 then
    Taste.Pfeil_links()
  elseif e[3] == 0 and e[4] == 205 then
    Taste.Pfeil_rechts()
  elseif c >= "0" and c <= "9" and seite >= 0 then
    Taste.Zahl(c)
  else
    local f = Taste[c]
    if f then
      Funktion.checken(f)
    end
  end
end

function Taste.Pfeil_links()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  if seite >= 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.vorherigeSeite, 0)
  elseif seite == 0 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.SteuerungName, 0)
  elseif seite == -1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.logbuch, 0)
    Funktion.Legende()
  end
  if seite <= -2 then else
    seite = seite - 1
    Funktion.Farbe(Farben.Adressfarbe, Farben.Adresstextfarbe)
    for P = 1, Bildschirmhoehe - 3 do
      Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
    end
    Funktion.zeigeAnzeige()
  end
end

function Taste.Pfeil_rechts()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  if seite == -1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.zeigeAdressen, 0)
  elseif seite == -2 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.SteuerungName, 0)
    event.timer(0.1, function() Funktion.zeigeNachricht(nil, true) end, 0)
  elseif maxseiten > seite + 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.naechsteSeite, 0)
  end
  if seite + 1 < maxseiten then
    seite = seite + 1
    Funktion.Farbe(Farben.Adressfarbe, Farben.Adresstextfarbe)
    for P = 1, Bildschirmhoehe - 3 do
      Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
    end
    Funktion.zeigeAnzeige()
  end
end

function Taste.q()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_q, "Q " .. sprachen.beenden, 0)
    running = false
  end
end

function Taste.d()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.d_X + 2, Taste.Koordinaten.d_Y, "D " .. sprachen.abschalten, 0)
  if state == "Connected" and direction == "Incoming" then
    sg.disconnect()
    sg.sendMessage("Request: Disconnect Stargate")
    Funktion.zeigeNachricht(sprachen.senden .. sprachen.aufforderung .. ": " .. sprachen.stargateAbschalten .. " " .. sprachen.stargateName)
  else
    sg.disconnect()
    if state == "Idle" then else
      Funktion.zeigeNachricht(sprachen.stargateAbschalten .. " " .. sprachen.stargateName)
    end
  end
  event.timer(1, Funktion.zeigeMenu, 1)
end

function Taste.e()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.e_X, Taste.Koordinaten.e_Y, "E " .. sprachen.IDCeingabe, 0)
  if Funktion.Tastatur() then
    if state == "Connected" and direction == "Outgoing" then
      term.setCursor(1, Bildschirmhoehe)
      Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
      term.clearLine()
      term.write(sprachen.IDCeingabe .. ":")
      local timerID = event.timer(1, function() Funktion.zeigeStatus() Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe) end, math.huge)
      pcall(screen.setTouchModeInverted, false)
      local eingabe = term.read(nil, false, nil, "*")
      pcall(screen.setTouchModeInverted, true)
      sg.sendMessage(string.sub(eingabe, 1, string.len(eingabe) - 1))
      event.cancel(timerID)
      Funktion.zeigeNachricht(sprachen.IDCgesendet)
    else
      Funktion.zeigeNachricht(sprachen.keineVerbindung)
    end
  end
end

function Taste.o()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.o_X + 2, Taste.Koordinaten.o_Y, "O " .. sprachen.oeffneIris, 0)
  if iris == "Offline" then else
    Funktion.irisOpen()
    if wormhole == "in" then
      if iris == "Offline" then else
        os.sleep(2)
        if Funktion.atmosphere(true) then
          sg.sendMessage("Manual Override: Iris: Open" .. Funktion.atmosphere(true))
        else
          sg.sendMessage("Manual Override: Iris: Open")
        end 
      end
    end
    if state == "Idle" then
      iriscontrol = "on"
    else
      iriscontrol = "off"
    end
  end
end

function Taste.c()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.c_X, Taste.Koordinaten.c_Y, "C " .. sprachen.schliesseIris, 0)
  if iris == "Offline" then else
    Funktion.irisClose()
    iriscontrol = "off"
    if wormhole == "in" then
      if Funktion.atmosphere(true) then
        sg.sendMessage("Manual Override: Iris: Closed" .. Funktion.atmosphere(true))
      else
        sg.sendMessage("Manual Override: Iris: Closed")
      end 
    end
  end
end

function Taste.i()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_i, "I " .. string.sub(sprachen.IrisSteuerung:match("^%s*(.-)%s*$") .. " " .. sprachen.an_aus, 1, 28), 0)
    event.timer(2, Funktion.zeigeMenu, 1)
    if iris == "Offline" then else
      send = true
      if Sicherung.control == "On" then
        Sicherung.control = "Off"
      else
        Sicherung.control = "On"
      end
      schreibSicherungsdatei(Sicherung)
    end
  end
end

function Taste.z()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_z, "Z " .. sprachen.AdressenBearbeiten, 0)
    if Funktion.Tastatur() then
      Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Textfarbe)
      pcall(screen.setTouchModeInverted, false)
      kopieren("/einstellungen/adressen.lua", "/einstellungen/adressen-bearbeiten")
      edit("/einstellungen/adressen-bearbeiten")
      if pcall(loadfile("/einstellungen/adressen-bearbeiten")) then
        entfernen("/einstellungen/adressen.lua")
        kopieren("/einstellungen/adressen-bearbeiten", "/einstellungen/adressen.lua")
      else
        Funktion.zeigeNachricht("Syntax Fehler")
        os.sleep(2)
      end
      entfernen("/einstellungen/adressen-bearbeiten")
      pcall(screen.setTouchModeInverted, true)
      seite = -1
      Funktion.zeigeAnzeige()
      seite = 0
      Funktion.AdressenSpeichern()
    else
      event.timer(2, Funktion.zeigeMenu, 1)
    end
  end
end

function Taste.s()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_s, "S " .. sprachen.EinstellungenAendern, 0)
    if Funktion.Tastatur() then
      Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Textfarbe)
      schreibSicherungsdatei(Sicherung)
      pcall(screen.setTouchModeInverted, false)
      kopieren("/einstellungen/Sicherungsdatei.lua", "/einstellungen/Sicherungsdatei-bearbeiten")
      edit("/einstellungen/Sicherungsdatei-bearbeiten")
      if pcall(loadfile("/einstellungen/Sicherungsdatei-bearbeiten")) then
        entfernen("/einstellungen/Sicherungsdatei.lua")
        kopieren("/einstellungen/Sicherungsdatei-bearbeiten", "/einstellungen/Sicherungsdatei.lua")
      else
        Funktion.zeigeNachricht("Syntax Fehler")
        os.sleep(2)
      end
      entfernen("/einstellungen/Sicherungsdatei-bearbeiten")
      pcall(screen.setTouchModeInverted, true)
      local a = Sicherung.RF
      Sicherung = loadfile("/einstellungen/Sicherungsdatei.lua")()
      if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
        local neu = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
        sprachen = loadfile("/stargate/sprache/deutsch.lua")()
        for i in pairs(sprachen) do
          if neu[i] then
            sprachen[i] = neu[i]
          end
        end
        sprachen = sprachen or neu
        ersetzen = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)
      else
        print("\nUnbekannte Sprache\nStandardeinstellung = deutsch")
        sprachen = loadfile("/stargate/sprache/deutsch.lua")()
        ersetzen = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)
        Sicherung.Sprache = ""
        os.sleep(1)
      end
      if Sicherung.RF then
        energytype          = "RF"
        energymultiplicator = 80
      else
        energytype          = "EU"
        energymultiplicator = 20
      end
      if a ~= Sicherung.RF then
        Funktion.AdressenSpeichern()
      end
      schreibSicherungsdatei(Sicherung)
      Funktion.sides()
      gpu.setBackground(Farben.Nachrichtfarbe)
      seite = 0
      Funktion.zeigeAnzeige()
    else
      event.timer(2, Funktion.zeigeMenu, 1)
    end
  end
end

function Taste.l()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_l, "L " .. sprachen.zeigeLog, 0)
    if Funktion.Tastatur() then
      pcall(screen.setTouchModeInverted, false)
      Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Textfarbe)
      os.sleep(0.1)
      edit("-r", "/stargate/log")
      pcall(screen.setTouchModeInverted, true)
      seite = 0
    else
      event.timer(2, Funktion.zeigeMenu, 1)
    end
  end
end

function Taste.u()
  if seite == -1 then
    Funktion.zeigeNachricht(sprachen.Update)
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_u, "U " .. sprachen.Update, 0)
    if component.isAvailable("internet") then
      local serverVersion = Funktion.checkServerVersion()
      if version ~= serverVersion then
        Funktion.Logbuch_schreiben(serverVersion, "Update:    " , "update")
        running = false
        Variablen.update = "ja"
      else
        Funktion.zeigeNachricht(sprachen.bereitsNeusteVersion)
        event.timer(2, Funktion.zeigeMenu, 1)
      end
    else
      Funktion.zeigeNachricht(sprachen.keinInternet)
      event.timer(2, Funktion.zeigeMenu, 1)
    end
  end
end

function Taste.b()
  if seite == -1 then
    Funktion.zeigeNachricht(sprachen.UpdateBeta)
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_b, "B " .. sprachen.UpdateBeta, 0)
    if component.isAvailable("internet") then
      Funktion.Logbuch_schreiben(serverVersion .. " BETA", "Update:    " , "update")
      running = false
      Variablen.update = "beta"
    end
  end
end

function Taste.Zahl(c)
  event.timer(2, Funktion.zeigeMenu, 1)
  Funktion.Farbe(Farben.mittelblau, Farben.Adresstextfarbe)
  if c == "0" then
    c = 10
  end
  local y = c
  c = c + seite * 10
  na = gespeicherteAdressen[tonumber(c)]
  if na then
    Funktion.zeigeHier(1, y * 2, "", 30)
    local Nummer = y
    if y == 10 then
      Nummer = 0
    end
    Funktion.zeigeHier(1, y * 2, Nummer .. " " .. string.sub(na[1], 1, xVerschiebung - 7), 0)
    if string.sub(na[4], 1, 1) == "<" then
      gpu.setForeground(Farben.FehlerFarbe)
      Funktion.zeigeHier(1, y * 2 + 1, "", 30)
      Funktion.zeigeHier(1, y * 2 + 1, "   " .. na[4], 0)
    else
      Funktion.zeigeHier(1, y * 2 + 1, "", 30)
      Funktion.zeigeHier(1, y * 2 + 1, "   " .. na[4], 0)
    end
    iriscontrol = "off"
    wormhole = "out"
    if na then
      Funktion.dial(na[1], na[2])
      if string.sub(na[4], 1, 1) == "<" and sg.energyToDial(na[2]) then
        Funktion.AdressenSpeichern()
      end
      if na[3] == "-" then
      else
        outcode = na[3]
      end
    end
  end
end

function Funktion.Tastatur()
  if component.isAvailable("keyboard") then
    return true
  else
    Funktion.zeigeNachricht(sprachen.TastaturFehlt)
    return false
  end
end

function Funktion.sgChevronEngaged(e)
  chevron = e[3]
  local remAdr = sg.remoteAddress()
  if remAdr then
    if chevron <= 4 then
      zielAdresse = string.sub(remAdr, 1, chevron)
    elseif chevron <= 7 then
      zielAdresse = string.sub(remAdr, 1, 4) .. "-" .. string.sub(remAdr, 5, chevron)
    else
      zielAdresse = string.sub(remAdr, 1, 4) .. "-" .. string.sub(remAdr, 5, 7) .. "-" .. string.sub(remAdr, 8, chevron)
    end
  else
    zielAdresse = sprachen.fehlerName
  end
  Funktion.zeigeNachricht(string.format("Chevron %s %s! <%s>", chevron, sprachen.aktiviert, zielAdresse))
end

function Funktion.modem_message(e)
  if OC then
    component.modem.close()
  elseif CC then
    local modem = peripheral.find("modem")
    if modem then
      modem.closeAll()
    end
  end
  Variablen.WLAN_Anzahl = Variablen.WLAN_Anzahl + 1
  if Variablen.WLAN_Anzahl < 5 then
    Funktion.sgMessageReceived({e[1], e[2], e[6]})
    event.timer(5, Funktion.openModem, 0)
  end
end

function Funktion.openModem()
  if component.isAvailable("modem") and type(Sicherung.Port) == "number" then
    component.modem.open(Sicherung.Port)
  end
end

function Funktion.sgMessageReceived(e)
  if direction == "Outgoing" then
    codeaccepted = e[3]
  elseif direction == "Incoming" and wormhole == "in" then
    if e[3] == "Adressliste" then
    else
      incode = tostring(e[3])
    end
  end
  if e[4] == "Adressliste" then
    local inAdressen = serialization.unserialize(e[5])
    if type(inAdressen) == "table" then
      Funktion.angekommeneAdressen(inAdressen)
    end
    if type(e[6]) == "string" then
      Funktion.angekommeneVersion(e[6])
    end
  end
  messageshow = true
end

function Funktion.touch(e)
  local x = e[3]
  local y = e[4]
  if x <= 30 then
    if seite >= 0 then
      if y > 1 and y <= 21 then
        Taste.Zahl(math.floor(((y - 1) / 2) + 0.5))
      end
    elseif seite == -1 then
      if Taste.links[y] then
        Taste.links[y](y)
      end
    end
  elseif x >= 35 and y >= Taste.Koordinaten.Steuerungsanfang_Y and y <= Taste.Koordinaten.Steuerungsende_Y then
    if x <= 52 then
      if Taste.Steuerunglinks[y] then
        Taste.Steuerunglinks[y]()
      end
    else
      if Taste.Steuerungrechts[y] then
        Taste.Steuerungrechts[y]()
      end
    end
  end
end

function Funktion.sgDialIn()
  wormhole = "in"
  Funktion.Logbuch_schreiben(remoteName , Funktion.getAddress(sg.remoteAddress()), wormhole)
end

function Funktion.sgDialOut()
  state = "Dialling"
  wormhole = "out"
  direction = "Outgoing"
end

function Funktion.eventLoop()
  while running do
    Funktion.checken(Funktion.zeigeStatus)
    e = Funktion.pull_event()
    if not e then
    elseif not e[1] then
    else
      f = Funktion[e[1]]
      if f then
        Funktion.checken(f, e)
      end
    end
    Funktion.zeigeAnzeige()
  end
end

function Funktion.angekommeneAdressen(...)
  local AddNewAddress = false
  for a, b in pairs(...) do
    local neuHinzufuegen = false
    for c, d in pairs(adressen) do
      if d[2] == "XXXX-XXX-XX" then
        adressen[c] = nil
      elseif b[2] ~= d[2] then
        neuHinzufuegen = true
      elseif b[2] == d[2] and d[1] == ">>>" .. d[2] .. "<<<" and d[1] ~= b[1] then
        if Funktion.newAddress(b[2], b[1], true) then
          adressen[c] = nil
        end
        AddNewAddress = true
        neuHinzufuegen = false
        break
      else
        neuHinzufuegen = false
        break
      end
    end
    if neuHinzufuegen == true then
      AddNewAddress = true
      Funktion.newAddress(b[2], b[1], true)
    end
  end
  if AddNewAddress == true then
    Funktion.schreibeAdressen()
    Funktion.AdressenSpeichern()
    Funktion.zeigeMenu()
  end
end

function Funktion.checkStargateName()
  Sicherung = loadfile("/einstellungen/Sicherungsdatei.lua")()
  if type(Sicherung.StargateName) ~= "string" or Sicherung.StargateName == "" then
    Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
    gpu.set(1, Bildschirmhoehe - 1, sprachen.FrageStargateName)
    term.setCursor(1, Bildschirmhoehe)
    term.clearLine()
    term.write(sprachen.neuerName .. ": ")
    local eingabe = term.read(nil, false)
    Sicherung.StargateName = string.sub(eingabe, 1, string.len(eingabe) - 1)
    schreibSicherungsdatei(Sicherung)
    Funktion.newAddress(Funktion.getAddress(sg.localAddress()), Sicherung.StargateName)
  end
end

function Funktion.angekommeneVersion(...)
  local Endpunkt = string.len(...)
  local EndpunktVersion = string.len(version)
  if string.sub(..., Endpunkt - 3, Endpunkt) ~= "BETA" and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" and version ~= ... and Sicherung.autoUpdate == true then
    if component.isAvailable("internet") then
      if version ~= Funktion.checkServerVersion() then
        VersionUpdate = true
        Funktion.zeigeNachricht(nil, true)
        event.timer(10, function() event.push("test") end, math.huge)
      end
    end
  end
end

function Funktion.checken(...)
  ok, result = pcall(...)
  if not ok then
    Funktion.zeigeFehler(result)
  end
end

function Funktion.zeigeAnzeige()
  Funktion.zeigeFarben()
  Funktion.zeigeStatus()
  Funktion.zeigeMenu()
end

function Funktion.redstoneAbschalten(sideNum, Farbe, printAusgabe)
  r.setBundledOutput(sideNum, Farbe, 0)
  print(sprachen.redstoneAusschalten .. printAusgabe)
end

function Funktion.beendeAlles()
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  Funktion.Farbe(Farben.schwarzeFarbe, Farben.weisseFarbe)
  gpu.fill(1, 1, 160, 80, " ")
  term.setCursor(1, 1)
  print(sprachen.ausschaltenName .. "\n")
  Funktion.Colorful_Lamp_Farben(0, true)
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
    Funktion.redstoneAbschalten(sideNum, Farben.white, "white")
--    Funktion.redstoneAbschalten(sideNum, Farben.orange, "orange")
--    Funktion.redstoneAbschalten(sideNum, Farben.magenta, "magenta")
--    Funktion.redstoneAbschalten(sideNum, Farben.lightblue, "lightblue")
    Funktion.redstoneAbschalten(sideNum, Farben.yellow, "yellow")
--    Funktion.redstoneAbschalten(sideNum, Farben.lime, "lime")
--    Funktion.redstoneAbschalten(sideNum, Farben.pink, "pink")
--    Funktion.redstoneAbschalten(sideNum, Farben.gray, "gray")
--    Funktion.redstoneAbschalten(sideNum, Farben.silver, "silver")
--    Funktion.redstoneAbschalten(sideNum, Farben.cyan, "cyan")
--    Funktion.redstoneAbschalten(sideNum, Farben.purple, "purple")
--    Funktion.redstoneAbschalten(sideNum, Farben.blue, "blue")
--    Funktion.redstoneAbschalten(sideNum, Farben.brown, "brown")
    Funktion.redstoneAbschalten(sideNum, Farben.green, "green")
    Funktion.redstoneAbschalten(sideNum, Farben.red, "red")
    Funktion.redstoneAbschalten(sideNum, Farben.black, "black")
  end
  pcall(screen.setTouchModeInverted, false)
  os.sleep(0.2)
end

function Funktion.main()
  if OC then
    loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Stargate OS")
  elseif CC then
    shell.run("label set Stargate-OS")
  end
  Funktion.schreibFehlerLog("\nStarten ...")
  print(pcall(Funktion.hochladen))
  io.read()
  if sg.stargateState() == "Idle" and Funktion.getIrisState() == "Closed" then
    Funktion.irisOpen()
  end
  gpu.setResolution(70, 25)
  Bildschirmbreite, Bildschirmhoehe = gpu.getResolution()
  Funktion.zeigeFarben()
  Funktion.zeigeStatus()
  seite = -1
  Funktion.zeigeMenu()
  Funktion.AdressenSpeichern()
  seite = 0
  Funktion.zeigeMenu()
  Funktion.openModem()
  while running do
    if not pcall(Funktion.eventLoop) then
      os.sleep(5)
    end
  end
  Funktion.beendeAlles()
end

Funktion.checken(Funktion.main)

local update = Funktion.update
Funktion = nil

if Variablen.update == "ja" then
  print(sprachen.aktualisierenJetzt)
  print(sprachen.schliesseIris .. "...\n")
  sg.closeIris()
  update("master")
elseif Variablen.update == "beta" then
  print(sprachen.aktualisierenJetzt)
  print(sprachen.schliesseIris .. "...\n")
  sg.closeIris()
  update("beta")
end
