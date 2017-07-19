-- pastebin run -f YVqKFnsP
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

OC = nil
CC = nil
if require then
  OC = true
  require("shell").setWorkingDirectory("/")
else
  CC = true
end

local component                 = {}
local event                     = {}
local term                      = term or require("term")
local fs                        = fs or require("filesystem")
local shell                     = shell or require("shell")
_G.shell = shell

if OC then
  component = require("component")
  event = require("event")
elseif CC then
  component.getPrimary = peripheral.find
end

local entfernen                 = fs.remove or fs.delete
local kopieren                  = fs.copy
local edit                      = loadfile("/bin/edit.lua") or function(datei) shell.run("edit " .. datei) end
local schreibSicherungsdatei    = loadfile("/stargate/schreibSicherungsdatei.lua")

if not pcall(loadfile("/einstellungen/Sicherungsdatei.lua")) then
  print("Fehler Sicherungsdatei.lua")
end

local Sicherung                 = loadfile("/einstellungen/Sicherungsdatei.lua")()

if not pcall(loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")) then
  print(string.format("Fehler %s.lua", Sicherung.Sprache))
end

local sprachen                  = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
local ersetzen                  = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)

local sg                        = component.getPrimary("stargate")
local screen                    = component.getPrimary("screen") or {}

local gpu                       = component.getPrimary("gpu") or component.getPrimary("monitor")
gpu.getResolution               = gpu.getResolution or gpu.getSize
gpu.maxResolution               = gpu.maxResolution or gpu.getSize

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
local Farben                    = {}
local Funktion                  = {}
local Taste                     = {}
local Variablen                 = {}
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

local AdressAnzeige, adressen, alte_eingabe, anwahlEnergie, ausgabe, chevron, direction, eingabe, energieMenge, ergebnis, gespeicherteAdressen, sensor, sectime, letzteNachrichtZeit
local iris, letzteNachricht, locAddr, mess, mess_old, ok, remAddr, result, RichtungName, sendeAdressen, sideNum, state, StatusName, version, letzterAdressCheck, c, e, f, k, r, graphicT3

do
  sectime                       = os.time()
  os.sleep(1)
  sectime                       = sectime - os.time()
  letzteNachrichtZeit           = os.time()
  letzterAdressCheck            = os.time() / sectime
  local args                    = {...}
  Funktion.update               = args[1]
  Funktion.checkServerVersion   = args[2]
  version                       = tostring(args[3])
  graphicT3                     = args[4]
end

local Farben = loadfile("/stargate/farben.lua")(OC, CC, graphicT3)

if Sicherung.RF then
  energytype          = "RF"
  energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  Trennlinienhoehe    = 13
end

pcall(screen.setTouchModeInverted, true)

if component.isAvailable("redstone") then
  r = component.getPrimary("redstone")
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

function Funktion.schreibeAdressen()
  local f = io.open("/einstellungen/adressen.lua", "w")
  f:write('-- pastebin run -f YVqKFnsP\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm\n--\n')
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
  if state == "Idle" and checkEnergy == energy then
    if Nachrichtleer == true then
      if VersionUpdate == true then
        running = false
        Variablen.update = "ja"
        Taste.q()
      end
      Wartezeit = 600
    else
      Wartezeit = 50
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
      zielAdresse     = ""
      remoteName      = ""
      showidc         = ""
      incode          = "-"
      codeaccepted    = "-"
      wormhole        = "in"
      iriscontrol     = "on"
      k               = "open"
      LampenGruen     = false
      IDCyes          = false
      entercode       = false
      messageshow     = true
      send            = true
      AddNewAddress   = true
      activationtime  = 0
      time            = 0
    end
  end
end

function Funktion.zeigeHier(x, y, s, h)
  if type(x) == "number" and type(y) == "number" and type(s) == "string" then
    if not h then
      h = Bildschirmbreite
    end
    gpu.set(x, y, s .. string.rep(" ", h - string.len(s)))
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
  print("L " .. sprachen.EinstellungenAendern)
  i = i + 1
  Taste.links[i] = Taste.l
  Taste.Koordinaten.Taste_l = i
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
  print("\n" .. sprachen.entwicklerName .. " Nex4rius")
end

function Funktion.AdressenSpeichern()
  adressen = loadfile("/einstellungen/adressen.lua")()
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
        if     anwahlEnergie > 10000000000 then
          anwahlEnergie = string.format("%.3f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000000) .. " G"
        elseif anwahlEnergie > 10000000 then
          anwahlEnergie = string.format("%.2f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000) .. " M"
        elseif anwahlEnergie > 10000 then
          anwahlEnergie = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000) .. " k"
        else
          anwahlEnergie = string.format("%.f" , (sg.energyToDial(na[2]) * energymultiplicator))
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
    return "Adressliste", require("serialization").serialize(sendeAdressen), version
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
  if energy == 0 then
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.energie1 .. energytype .. sprachen.energie2, 0)
    Funktion.SchreibInAndererFarben(xVerschiebung + string.len("  " .. sprachen.energie1 .. energytype .. sprachen.energie2), zeile, sprachen.keineEnergie, Farben.FehlerFarbe)
  else
    if     energy > 10000000000 then
      energieMenge = string.format("%.3f", energy / 1000000000) .. " G"
    elseif energy > 10000000 then
      energieMenge = string.format("%.2f", energy / 1000000) .. " M"
    elseif energy > 10000 then
      energieMenge = string.format("%.1f", energy / 1000) .. " k"
    else
      energieMenge = string.format("%.f",  energy)
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
  if seite >= 0 then
    Taste.Steuerunglinks[zeile] = Taste.Pfeil_links
    Taste.Koordinaten.Pfeil_links_Y = zeile
    Taste.Koordinaten.Pfeil_links_X = xVerschiebung
    if seite >= 1 then
      Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X, Taste.Koordinaten.Pfeil_links_Y, "  ← " .. sprachen.vorherigeSeite)
    else
      Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X, Taste.Koordinaten.Pfeil_links_Y, "  ← " .. sprachen.SteuerungName)
    end
  else
    Funktion.zeigeHier(xVerschiebung, zeile, "")
  end
  Taste.Steuerungrechts[zeile] = Taste.Pfeil_rechts
  Taste.Koordinaten.Pfeil_rechts_Y = zeile
  Taste.Koordinaten.Pfeil_rechts_X = xVerschiebung + 20
  if seite == -1 then
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
  if component.isAvailable("redstone") then
    component.getPrimary("redstone").setBundledOutput(sideNum, a, b)
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
    for k in component.list("colorful_lamp") do
      component.proxy(k).setLampColor(eingabe)
      if ausgabe then
        print(sprachen.colorfulLampAusschalten .. k)
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
    gpu.set(x, y, text .. string.rep(" ", h - string.len(text)))
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

function Funktion.zeigeNachricht(...)
  if ... == "" then
    Nachrichtleer = true
  else
    Nachrichtleer = false
  end
  letzteNachricht = ...
  letzteNachrichtZeit = os.time()
  Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
  if VersionUpdate == true then
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.aktualisierenGleich, Bildschirmbreite)
  elseif fs.exists("/log") and Sicherung.debug then
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.fehlerName .. " /log", Bildschirmbreite)
  else
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, "", Bildschirmbreite)
  end
  if ... then
    Funktion.zeigeHier(1, Bildschirmhoehe, Funktion.zeichenErsetzen(Funktion.zeichenErsetzen(...)), Bildschirmbreite)
  else
    Funktion.zeigeHier(1, Bildschirmhoehe, "", Bildschirmbreite)
  end
  Funktion.Farbe(Farben.Statusfarbe)
end

function Funktion.schreibFehlerLog(...)
  if letzteEingabe == ... then else
    local f
    if fs.exists("/log") then
      f = io.open("/log", "a")
    else
      f = io.open("/log", "w")
      f:write('-- "Ctrl + W" to exit\n\n')
    end
    if type(...) == "string" then
      f:write(...)
    elseif type(...) == "table" then
      f:write(require("serialization").serialize(...))
    end
    f:write("\n\n" .. os.time() .. string.rep("-", max_Bildschirmbreite - string.len(os.time())) .. "\n\n")
    f:close()
  end
  letzteEingabe = ...
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
  end
  os.sleep(1)
end

function Funktion.key_down(e)
  c = string.char(e[3])
  if entercode == true then
    Taste.eingabe_enter()
  elseif e[3] == 0 and e[4] == 203 then
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

function Taste.eingabe_enter()
  if e[3] == 13 then
    entercode = false
    sg.sendMessage(enteridc)
    Funktion.zeigeNachricht(sprachen.IDCgesendet)
  else
    enteridc = enteridc .. c
    showidc = showidc .. "*"
    Funktion.zeigeNachricht(sprachen.IDCeingabe .. ": " .. showidc)
  end
end

function Taste.Pfeil_links()
  Funktion.Farbe(Farben.Steuerungstextfarbe, Farben.Steuerungsfarbe)
  if seite >= 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.vorherigeSeite, 0)
  elseif seite == -1 then
  else
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.SteuerungName, 0)
  end
  if seite <= -1 then else
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
      enteridc = ""
      showidc = ""
      entercode = true
      Funktion.zeigeNachricht(sprachen.IDCeingabe .. ":")
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

function Taste.l()
  if seite == -1 then
    Funktion.Farbe(Farben.AdressfarbeAktiv, Farben.Adresstextfarbe)
    Funktion.zeigeHier(1, Taste.Koordinaten.Taste_l, "L " .. sprachen.EinstellungenAendern, 0)
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
        sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
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
      term.clear()
      seite = 0
      Funktion.zeigeAnzeige()
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
      if version ~= Funktion.checkServerVersion() then
        running = false
        Variablen.update = "ja"
      else
        Funktion.zeigeNachricht(sprachen.bereitsNeusteVersion)
        event.timer(2, Funktion.zeigeMenu, 1)
      end
    else
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
  if chevron <= 4 then
    zielAdresse = string.sub(sg.remoteAddress(), 1, chevron)
  elseif chevron <= 7 then
    zielAdresse = string.sub(sg.remoteAddress(), 1, 4) .. "-" .. string.sub(sg.remoteAddress(), 5, chevron)
  else
    zielAdresse = string.sub(sg.remoteAddress(), 1, 4) .. "-" .. string.sub(sg.remoteAddress(), 5, 7) .. "-" .. string.sub(sg.remoteAddress(), 8, chevron)
  end
  Funktion.zeigeNachricht(string.format("Chevron %s %s! <%s>", chevron, sprachen.aktiviert, zielAdresse))
end

function Funktion.sgMessageReceived(e)
  if direction == "Outgoing" then
    codeaccepted = e[3]
  elseif direction == "Incoming" and wormhole == "in" then
    if e[3] == "Adressliste" then
    else
      incode = e[3]
    end
  end
  if e[4] == "Adressliste" then
    local inAdressen = require("serialization").unserialize(e[5])
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
  if Sicherung.StargateName ~= "string" or Sicherung.StargateName == "" then
    Funktion.Farbe(Farben.Nachrichtfarbe, Farben.Nachrichttextfarbe)
    term.clear()
    print(sprachen.FrageStargateName .. "\n")
    Sicherung.StargateName = io.read()
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
end

function Funktion.main()
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "Stargate OS")
  if sg.stargateState() == "Idle" and Funktion.getIrisState() == "Closed" then
    Funktion.irisOpen()
  end
  term.clear()
  gpu.setResolution(70, 25)
  Bildschirmbreite, Bildschirmhoehe = gpu.getResolution()
  Funktion.zeigeFarben()
  Funktion.zeigeStatus()
  seite = -1
  Funktion.zeigeMenu()
  Funktion.AdressenSpeichern()
  seite = 0
  Funktion.zeigeMenu()
  while running do
    if not pcall(Funktion.eventLoop) then
      os.sleep(5)
    end
  end
  os.sleep(2)
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
