-- pastebin run -f fa9gu1GJ
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm

local component             = require("component")
local term                  = require("term")
local event                 = require("event")
local fs                    = require("filesystem")
local edit                  = loadfile("/bin/edit.lua")
local schreibSicherungsdatei= loadfile("/stargate/schreibSicherungsdatei.lua")
local IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
local gpu                   = component.getPrimary("gpu")
local sg                    = component.getPrimary("stargate")

local sectime               = os.time()
os.sleep(1)
sectime                     = sectime - os.time()
local letzteNachrichtZeit   = os.time()
local letzterAdressCheck    = os.time() / sectime
local enteridc              = ""
local showidc               = ""
local remoteName            = ""
local zielAdresse           = ""
local time                  = "-"
local incode                = "-"
local codeaccepted          = "-"
local wormhole              = "in"
local iriscontrol           = "on"
local energytype            = "EU"
local activationtime        = 0
local energy                = 0
local seite                 = 0
local maxseiten             = 0
local checkEnergy           = 0
local AdressenAnzahl        = 0
local zeile                 = 1
local Trennlinienhoehe      = 14
local energymultiplicator   = 20
local xVerschiebung         = 33
local AddNewAddress         = true
local messageshow           = true
local running               = true
local send                  = true
local einmalAdressenSenden  = true
local Nachrichtleer         = true
local IDCyes                = false
local entercode             = false
local redstoneConnected     = false
local redstoneIncoming      = false
local redstoneState         = false
local redstoneIDC           = false
local LampenGruen           = false
local LampenRot             = false
local VersionUpdate         = false

local graueFarbe            = 6684774
local roteFarbe             = 0xFF0000
local weisseFarbe           = 0xFFFFFF
local blaueFarbe            = 0x0000FF
local schwarzeFarbe         = 0x00000
local gelbeFarbe            = 16750899
local brauenFarbe           = 10046464
local grueneFarbe           = 39168

local FehlerFarbe           = roteFarbe
local Hintergrundfarbe      = graueFarbe
local Trennlinienfarbe      = blaueFarbe
local Textfarbe             = weisseFarbe

local Adressfarbe           = brauenFarbe
local Adresstextfarbe       = Textfarbe
local Nachrichtfarbe        = graueFarbe
local Nachrichttextfarbe    = Textfarbe
local Steuerungsfarbe       = gelbeFarbe
local Steuerungstextfarbe   = schwarzeFarbe
local Statusfarbe           = grueneFarbe
local Statustextfarbe       = Textfarbe

local letzteNachricht
local adressen
local sideNum
local k
local AdressAnzeige
local gespeicherteAdressen
local sendeAdressen
local ok
local result
local ergebnis
local state
local chevron
local direction
local iris
local locAddr
local remAddr
local RichtungName
local StatusName
local energieMenge
local mess
local mess_old
local eingabe
local alte_eingabe
local ausgabe
local anwahlEnergie
local angekommeneVersion

local white                 = 0
--local orange                = 1
--local magenta               = 2
--local lightblue             = 3
local yellow                = 4
--local lime                  = 5
--local pink                  = 6
--local gray                  = 7
--local silver                = 8
--local cyan                  = 9
--local purple                = 10
--local blue                  = 11
--local brown                 = 12
local green                 = 13
local red                   = 14
local black                 = 15
  
if component.isAvailable("redstone") then
  r = component.getPrimary("redstone")
  r.setBundledOutput(0, white, 0)
--  r.setBundledOutput(0, orange, 0)
--  r.setBundledOutput(0, magenta, 0)
--  r.setBundledOutput(0, lightblue, 0)
  r.setBundledOutput(0, yellow, 0)
--  r.setBundledOutput(0, lime, 0)
--  r.setBundledOutput(0, pink, 0)
--  r.setBundledOutput(0, gray, 0)
--  r.setBundledOutput(0, silver, 0)
--  r.setBundledOutput(0, cyan, 0)
--  r.setBundledOutput(0, purple, 0)
--  r.setBundledOutput(0, blue, 0)
--  r.setBundledOutput(0, brown, 0)
  r.setBundledOutput(0, green, 0)
  r.setBundledOutput(0, red, 0)
  r.setBundledOutput(0, black, 0)
end

local function schreibeAdressen()
  f = io.open("/stargate/adressen.lua", "w")
  f:write('-- pastebin run -f fa9gu1GJ\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n')
  f:write('-- Put your own stargate addresses here\n')
  f:write('-- "" for no Iris Code\n')
  f:write('--\n\n')
  f:write('return {\n')
  f:write('--{"<Name>", "<Adresse>", "<IDC>"},\n')
  for k, v in pairs(adressen) do
    f:write(string.format('  {"%s", "%s", "%s"},\n', adressen[k][1], adressen[k][2], adressen[k][3]))
  end
  f:write('}')
  f:close()
end

if RF == true then
  energytype          = "RF"
  energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  Trennlinienhoehe    = 13
end

local function try(func, ...)
  local ok, result = pcall(func, ...)
  if not ok then
    print("Error: " .. result)
  end
end

local function check(...)
  local values = {...}
  if values[1] == nil then
    error(values[2], 0)
  end
  return ...
end

local function setCursor(col, row)
  term.setCursor(col, row)
end

local function write(s)
  term.write(s)
end

local function pull_event()
  local Wartezeit = 1
  if state == "Idle" and checkEnergy == energy then
    if Nachrichtleer == true then
      if VersionUpdate == true then
        VersionUpdate = false
        zeigeNachricht(aktualisierenJetzt)
        gpu.setBackground(schwarzeFarbe)
        gpu.setForeground(weisseFarbe)
        update("master")
      end
      Wartezeit = 300
    else
      Wartezeit = 50
    end
  end
  checkEnergy = energy
  local eventErgebnis = {event.pull(Wartezeit)}
  if eventErgebnis[1] == "component_removed" or eventErgebnis[1] == "component_added" then
    schreibFehlerLog(eventErgebnis)
  end
  return eventErgebnis
end

local screen_width, screen_height = gpu.getResolution()
local max_Bildschirmbreite, max_Bildschirmhoehe = gpu.maxResolution()
local key_event_name = "key_down"

local function key_event_char(e)
  return string.char(e[3])
end

loadfile("/stargate/sprache/" .. Sprache .. ".lua")()
loadfile("/stargate/sprache/ersetzen.lua")()

local Adressseite               = Adressseite;              _ENV.Adressseite              = nil
local Unbekannt                 = Unbekannt;                _ENV.Unbekannt                = nil
local waehlen                   = waehlen;                  _ENV.waehlen                  = nil
local energie1                  = energie1;                 _ENV.energie1                 = nil
local energie2                  = energie2;                 _ENV.energie2                 = nil
local keineVerbindung           = keineVerbindung;          _ENV.keineVerbindung          = nil
local Steuerung                 = Steuerung;                _ENV.Steuerung                = nil
local IrisSteuerung             = IrisSteuerung;            _ENV.IrisSteuerung            = nil
local an_aus                    = an_aus;                   _ENV.an_aus                   = nil
local AdressenBearbeiten        = AdressenBearbeiten;       _ENV.AdressenBearbeiten       = nil
local beenden                   = beenden;                  _ENV.beenden                  = nil
local nachrichtAngekommen       = nachrichtAngekommen;      _ENV.nachrichtAngekommen      = nil
local RedstoneSignale           = RedstoneSignale;          _ENV.RedstoneSignale          = nil
local RedstoneWeiss             = RedstoneWeiss;            _ENV.RedstoneWeiss            = nil
local RedstoneRot               = RedstoneRot;              _ENV.RedstoneRot              = nil
local RedstoneGelb              = RedstoneGelb;             _ENV.RedstoneGelb             = nil
local RedstoneSchwarz           = RedstoneSchwarz;          _ENV.RedstoneSchwarz          = nil
local RedstoneGruen             = RedstoneGruen;            _ENV.RedstoneGruen            = nil
local versionName               = versionName;              _ENV.versionName              = nil
local fehlerName                = fehlerName;               _ENV.fehlerName               = nil
local SteuerungName             = SteuerungName;            _ENV.SteuerungName            = nil
local lokaleAdresse             = lokaleAdresse;            _ENV.lokaleAdresse            = nil
local zielAdresseName           = zielAdresseName;          _ENV.zielAdresseName          = nil
local zielName                  = zielName;                 _ENV.zielName                 = nil
local statusName                = statusName;               _ENV.statusName               = nil
local IrisName                  = IrisName;                 _ENV.IrisName                 = nil
local IrisSteuerung             = IrisSteuerung;            _ENV.IrisSteuerung            = nil
local IDCakzeptiert             = IDCakzeptiert;            _ENV.IDCakzeptiert            = nil
local IDCname                   = IDCname;                  _ENV.IDCname                  = nil
local chevronName               = chevronName;              _ENV.chevronName              = nil
local richtung                  = richtung;                 _ENV.richtung                 = nil
local autoSchliessungAus        = autoSchliessungAus;       _ENV.autoSchliessungAus       = nil
local autoSchliessungAn         = autoSchliessungAn;        _ENV.autoSchliessungAn        = nil
local zeit1                     = zeit1;                    _ENV.zeit1                    = nil
local zeit2                     = zeit2;                    _ENV.zeit2                    = nil
local abschalten                = abschalten;               _ENV.abschalten               = nil
local oeffneIris                = oeffneIris;               _ENV.oeffneIris               = nil
local schliesseIris             = schliesseIris;            _ENV.schliesseIris            = nil
local IDCeingabe                = IDCeingabe;               _ENV.IDCeingabe               = nil
local naechsteSeite             = naechsteSeite;            _ENV.naechsteSeite            = nil
local vorherigeSeite            = vorherigeSeite;           _ENV.vorherigeSeite           = nil
local senden                    = senden;                   _ENV.senden                   = nil
local aufforderung              = aufforderung;             _ENV.aufforderung             = nil
local manueller                 = manueller;                _ENV.manueller                = nil
local Eingriff                  = Eingriff;                 _ENV.Eingriff                 = nil
local stargateName              = stargateName;             _ENV.stargateName             = nil
local stargateAbschalten        = stargateAbschalten;       _ENV.stargateAbschalten       = nil
local aktiviert                 = aktiviert;                _ENV.aktiviert                = nil
local zeigeAdressen             = zeigeAdressen;            _ENV.zeigeAdressen            = nil
local EinstellungenAendern      = EinstellungenAendern;     _ENV.EinstellungenAendern     = nil
local irisNameOffen             = irisNameOffen;            _ENV.irisNameOffen            = nil
local irisNameOeffnend          = irisNameOeffnend;         _ENV.irisNameOeffnend         = nil
local irisNameGeschlossen       = irisNameGeschlossen;      _ENV.irisNameGeschlossen      = nil
local irisNameSchliessend       = irisNameSchliessend;      _ENV.irisNameSchliessend      = nil
local irisNameOffline           = irisNameOffline;          _ENV.irisNameOffline          = nil
local irisKontrolleNameAn       = irisKontrolleNameAn;      _ENV.irisKontrolleNameAn      = nil
local irisKontrolleNameAus      = irisKontrolleNameAus;     _ENV.irisKontrolleNameAus     = nil
local RichtungNameEin           = RichtungNameEin;          _ENV.RichtungNameEin          = nil
local RichtungNameAus           = RichtungNameAus;          _ENV.RichtungNameAus          = nil
local StatusNameUntaetig        = StatusNameUntaetig;       _ENV.StatusNameUntaetig       = nil
local StatusNameWaehlend        = StatusNameWaehlend;       _ENV.StatusNameWaehlend       = nil
local StatusNameVerbunden       = StatusNameVerbunden;      _ENV.StatusNameVerbunden      = nil
local StatusNameSchliessend     = StatusNameSchliessend;    _ENV.StatusNameSchliessend    = nil
local Neustart                  = Neustart;                 _ENV.Neustart                 = nil
local IrisSteuerungName         = IrisSteuerungName;        _ENV.IrisSteuerungName        = nil
local ausschaltenName           = ausschaltenName;          _ENV.ausschaltenName          = nil
local redstoneAusschalten       = redstoneAusschalten;      _ENV.redstoneAusschalten      = nil
local colorfulLampAusschalten   = colorfulLampAusschalten;  _ENV.colorfulLampAusschalten  = nil
local verarbeiteAdressen        = verarbeiteAdressen;       _ENV.verarbeiteAdressen       = nil
local Hilfetext                 = Hilfetext;                _ENV.Hilfetext                = nil
local ersetzen                  = ersetzen;                 _ENV.ersetzen                 = nil
local IrisZustandName           = irisNameOffline;          _ENV.irisNameOffline          = nil
local Sprachaenderung           = Sprachaenderung;          _ENV.Sprachaenderung          = nil
local entwicklerName            = entwicklerName;           _ENV.entwicklerName           = nil
local IDCgesendet               = IDCgesendet;              _ENV.IDCgesendet              = nil
local aktualisierenJetzt        = aktualisierenJetzt;       _ENV.aktualisierenJetzt       = nil
local aktualisierenGleich       = aktualisierenGleich;      _ENV.aktualisierenGleich      = nil

function pad(s, n)
  return s .. string.rep(" ", n - string.len(s))
end

function zeichenErsetzen(eingabeErsetzung)
  return string.gsub(eingabeErsetzung, "%a+", function (str) return ersetzen [str] end)
end

function checkReset()
  if time == "-" then else
    if time > 500 then
      messageshow = true
      IDCyes = false
      send = true
      incode = "-"
      AddNewAddress = true
      entercode = false
      showidc = ""
      wormhole = "in"
      codeaccepted = "-"
      k = "open"
      iriscontrol = "on"
      remoteName = ""
      activationtime = 0
      LampenGruen = false
      zielAdresse = ""
    end
  end
end

function zeigeMenu()
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", xVerschiebung - 3)
  end
  setCursor(1, 1)
  if seite == -1 then
    Infoseite()
  else
    if (os.time() / sectime) - letzterAdressCheck > 21600 then
      letzterAdressCheck = os.time() / sectime
      AdressenSpeichern()
    end
    print(Adressseite .. seite + 1)
    AdressenLesen()
    iris = sg.irisState()
  end
end

function AdressenLesen()
  for i, na in pairs(gespeicherteAdressen) do
    if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
      AdressAnzeige = i - seite * 10
      if AdressAnzeige == 10 then
        AdressAnzeige = 0
      end
      print(AdressAnzeige .. " " .. string.sub(na[1], 1, xVerschiebung - 7))
      if string.sub(na[4], 1, 1) == "<" then
        gpu.setForeground(FehlerFarbe)
        print("   " .. na[4])
        gpu.setForeground(Adresstextfarbe)
      else
        print("   " .. na[4])
      end
    end
  end
end

function Infoseite()
  print(Steuerung)
  if iris == "Offline" then else
    print("I " .. IrisSteuerung .. an_aus)
  end
  print("Z " .. AdressenBearbeiten)
  print("Q " .. beenden)
  print("L " .. EinstellungenAendern .. "\n")
  print(RedstoneSignale)
  gpu.setBackground(weisseFarbe)
  gpu.setForeground(schwarzeFarbe)
  print(RedstoneWeiss)
  gpu.setBackground(roteFarbe)
  print(RedstoneRot)
  gpu.setBackground(gelbeFarbe)
  print(RedstoneGelb)
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  print(RedstoneSchwarz)
  gpu.setBackground(grueneFarbe)
  print(RedstoneGruen)
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  print(versionName .. version)
  print("\n" .. entwicklerName .. " Nex4rius")
end

function AdressenSpeichern()
  adressen = loadfile("/stargate/adressen.lua")()
  gespeicherteAdressen = {}
  sendeAdressen = {}
  local k = 0
  for i, na in pairs(adressen) do
    if na[2] == getAddress(sg.localAddress()) then
      k = -1
    else
      local anwahlEnergie = sg.energyToDial(na[2])
      if not anwahlEnergie then
        anwahlEnergie = fehlerName
      else
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
      gespeicherteAdressen[i + k][4] = ErsetzePunktMitKomma(anwahlEnergie)
    end
    zeigeNachricht(verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
    AdressenAnzahl = i
  end
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", xVerschiebung - 3)
  end
  zeigeMenu()
  zeigeNachricht("")
end

function ErsetzePunktMitKomma(...)
  if Sprache == "deutsch" then
    local Punkt = string.find(..., "%.")
    if type(Punkt) == "number" then
      return string.sub(..., 0, Punkt - 1) .. "," .. string.sub(..., Punkt + 1)
    end
  end
  return ...
end

function zeigeFarben()
  gpu.setBackground(Trennlinienfarbe)
  for P = 1, screen_height - 2 do
    zeigeHier(xVerschiebung - 2, P, "  ", 1)
  end
  zeigeHier(1, screen_height - 2, "", 80)
  zeigeHier(xVerschiebung - 2, Trennlinienhoehe, "")
  neueZeile(1)
end

function getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function irisClose()
  sg.closeIris()
  RedstoneAenderung(yellow, 255)
  Colorful_Lamp_Steuerung()
end

function irisOpen()
  sg.openIris()
  RedstoneAenderung(yellow, 0)
  Colorful_Lamp_Steuerung()
end

function sides()
  if side == "oben" or side == "top" then
    sideNum = 1
  elseif side == "hinten" or side == "back" then
    sideNum = 2
  elseif side == "vorne" or side == "front" then
    sideNum = 3
  elseif side == "rechts" or side == "right" then
    sideNum = 4
  elseif side == "links" or side == "left" then
    sideNum = 5
  else
    sideNum = 0
  end
end

function iriscontroller()
  if state == "Dialing" then
    messageshow = true
  end
  if direction == "Incoming" and incode == IDC and control == "Off" then
    IDCyes = true
    RedstoneAenderung(black, 255)
    if iris == "Closed" or iris == "Closing" or LampenRot == true then else
      Colorful_Lamp_Farben(992)
    end
  end
  if direction == "Incoming" and incode == IDC and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then
      sg.sendMessage("IDC Accepted Iris: Offline")
    else
      irisOpen()
      os.sleep(2)
      sg.sendMessage("IDC Accepted Iris: Open")
    end
    iriscontrol = "off"
    IDCyes = true
  elseif direction == "Incoming" and send == true then
    sg.sendMessage("Iris Control: " .. control .. " Iris: " .. iris, sendeAdressliste())
    send = false
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then else
      irisClose()
      RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
    k = "close"
  end
  if iris == "Closing" and control == "On" then
    k = "open"
  end
  if state == "Idle" and k == "close" and control == "On" then
    outcode = nil
    if iris == "Offline" then else
      irisOpen()
    end
    iriscontrol = "on"
    wormhole = "in"
    codeaccepted = "-"
    activationtime = 0
    entercode = false
    showidc = ""
    zielAdresse = ""
  end
  if state == "Idle" and control == "On" then
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
    zeigeNachricht("")
  end
  if state == "Idle" then
    incode = "-"
    wormhole = "in"
    AddNewAddress = true
    LampenGruen = false
    LampenRot = false
    zielAdresse = ""
  end
  if state == "Closing" and control == "On" then
    k = "close"
  end
  if state == "Connected" and direction == "Outgoing" and send == true then
    if outcode == "-" or outcode == nil then else
      sg.sendMessage(outcode, sendeAdressliste())
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    zeigeNachricht(nachrichtAngekommen .. codeaccepted .. "                   ")
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

function sendeAdressliste()
  if einmalAdressenSenden then
    einmalAdressenSenden = false
    return "Adressliste", require("serialization").serialize(sendeAdressen), version
  else
    return ""
  end
end

function neueZeile(b)
  zeile = zeile + b
end

function newAddress(neueAdresse, neuerName, ...)
  if AddNewAddress == true and string.len(neueAdresse) == 11 then
    AdressenAnzahl = AdressenAnzahl + 1
    adressen[AdressenAnzahl] = {}
    if neuerName == nil then
      adressen[AdressenAnzahl][1] = ">>>" .. neueAdresse .. "<<<"
    else
      adressen[AdressenAnzahl][1] = neuerName
    end
    adressen[AdressenAnzahl][2] = neueAdresse
    adressen[AdressenAnzahl][3] = ""
    if ... == nil then
      schreibeAdressen()
      AddNewAddress = false
      AdressenSpeichern()
      zeigeMenu()
    end
  end
end

function destinationName()
  if state == "Dialling" or state == "Connected" then
    if remoteName == "" and state == "Dialling" and wormhole == "in" then
      for j, na in pairs(adressen) do
        if remAddr == na[2] then
          if na[1] == na[2] then
            remoteName = Unbekannt
          else
            remoteName = na[1]
            break
          end
        end
      end
      if remoteName == "" then
        newAddress(remAddr)
      end
    end
  end
end

function getAddress(...)
  if ... == "" or ... == nil then
    return ""
  elseif string.len(...) == 7 then
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7)
  else
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7) .. "-" .. string.sub(..., 8, 9)
  end
end

function wormholeDirection()
  if direction == "Outgoing" then
    wormhole = "out"
  end
  if wormhole == "out" and state == "Closing" then
    direction = "Outgoing"
  end
end

function aktualisiereStatus()
  gpu.setResolution(70, 25)
  sg = component.getPrimary("stargate")
  locAddr = getAddress(sg.localAddress())
  remAddr = getAddress(sg.remoteAddress())
  destinationName()
  state, chevrons, direction = sg.stargateState()
  wormholeDirection()
  iris = sg.irisState()
  iriscontroller()
  if state == "Idle" then
    RichtungName = ""
  else
    if wormhole == "out" then
      RichtungName = RichtungNameAus
    else
      RichtungName = RichtungNameEin
    end
  end
  if state == "Idle" then
    StatusName = StatusNameUntaetig
  elseif state == "Dialling" then
    StatusName = StatusNameWaehlend
  elseif state == "Connected" then
    StatusName = StatusNameVerbunden
  elseif state == "Closing" then
    StatusName = StatusNameSchliessend
  else
    StatusName = StatusNameVerbunden
  end
  energy = sg.energyAvailable() * energymultiplicator
  zeile = 1
  if (letzteNachrichtZeit - os.time()) / sectime > 45 then
    if letzteNachricht ~= "" then
      zeigeNachricht("")
    end
  end
end

function zeigeStatus()
  aktualisiereStatus()
  gpu.setBackground(Statusfarbe)
  gpu.setForeground(Statustextfarbe)
  zeigeHier(xVerschiebung, zeile, "  " .. lokaleAdresse .. locAddr) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielAdresseName .. zielAdresse) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielName .. remoteName) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. statusName .. StatusName) neueZeile(1)
  zeigeEnergie() neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. IrisName .. zeichenErsetzen(iris)) neueZeile(1)
  if iris == "Offline" then else
    zeigeHier(xVerschiebung, zeile, "  " .. IrisSteuerung .. zeichenErsetzen(control)) neueZeile(1)
  end
  if IDCyes == true then
    zeigeHier(xVerschiebung, zeile, "  " .. IDCakzeptiert) neueZeile(1)
  else
    zeigeHier(xVerschiebung, zeile, "  " .. IDCname .. incode) neueZeile(1)
  end
  zeigeHier(xVerschiebung, zeile, "  " .. chevronName .. chevrons) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. richtung .. RichtungName) neueZeile(1)
  activetime() neueZeile(1)
  autoclose()
  zeigeHier(xVerschiebung, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  zeigeSteuerung()
  RedstoneKontrolle()
  Colorful_Lamp_Steuerung()
end

function RedstoneAenderung(a, b)
  if sideNum == nil then
    sides()
  end
  if component.isAvailable("redstone") then
    component.getPrimary("redstone").setBundledOutput(sideNum, a, b)
  end
end

function RedstoneKontrolle()
  if RichtungName == RichtungNameEin then
    if redstoneIncoming == true then
      RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
  elseif redstoneIncoming == false and state == "Idle" then
    RedstoneAenderung(red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState == true then
      RedstoneAenderung(white, 0)
      redstoneState = false
    end
  elseif redstoneState == false then
    RedstoneAenderung(white, 255)
    redstoneState = true
  end
  if IDCyes == true or (IDC == "" and state == "Connected" and direction == "Incoming" and iris == "Offline") then
    if redstoneIDC == true then
      RedstoneAenderung(black, 255)
      redstoneIDC = false
    end
  elseif redstoneIDC == false then
    RedstoneAenderung(black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected == true then
      RedstoneAenderung(green, 255)
      redstoneConnected = false
    end
  elseif redstoneConnected == false then
    RedstoneAenderung(green, 0)
    redstoneConnected = true
  end
end

function zeigeSteuerung()
  zeigeFarben()
  gpu.setBackground(Steuerungsfarbe)
  gpu.setForeground(Steuerungstextfarbe)
  neueZeile(3)
  zeigeHier(xVerschiebung, zeile - 1, "")
  zeigeHier(xVerschiebung, zeile, "  " .. Steuerung) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "") neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  D " .. abschalten)
  zeigeHier(xVerschiebung + 20, zeile, "E " .. IDCeingabe) neueZeile(1)
  if iris == "Offline" then
    control = "Off"
  else
    zeigeHier(xVerschiebung, zeile, "  O " .. oeffneIris)
    zeigeHier(xVerschiebung + 20, zeile, "C " .. schliesseIris) neueZeile(1)
  end
  if seite >= 0 then
    if seite >= 1 then
      zeigeHier(xVerschiebung, zeile, "  ← " .. vorherigeSeite)
    else
      zeigeHier(xVerschiebung, zeile, "  ← " .. SteuerungName)
    end
  else
    zeigeHier(xVerschiebung, zeile, "")
  end
  if seite == -1 then
    zeigeHier(xVerschiebung + 20, zeile, "→ " .. zeigeAdressen)
  elseif maxseiten > seite + 1 then
    zeigeHier(xVerschiebung + 20, zeile, "→ " .. naechsteSeite)
  end
  neueZeile(1)
  for i = zeile, screen_height - 3 do
    zeigeHier(xVerschiebung, i, "")
  end
end

function autoclose()
  if autoclosetime == false then
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAus)
  else
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function zeigeEnergie()
  if     energy > 10000000000 then
    energieMenge = string.format("%.3f", energy / 1000000000) .. " G"
  elseif energy > 10000000 then
    energieMenge = string.format("%.2f", energy / 1000000) .. " M"
  elseif energy > 10000 then
    energieMenge = string.format("%.1f", energy / 1000) .. " k"
  else
    energieMenge = string.format("%.f", energy)
  end
  zeigeHier(xVerschiebung, zeile, "  " .. energie1 .. energytype .. energie2 .. ErsetzePunktMitKomma(energieMenge))
end

function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time()) / sectime
    if time > 0 then
      zeigeHier(xVerschiebung, zeile, "  " .. zeit1 .. ErsetzePunktMitKomma(string.format("%.1f", time)) .. "s")
    end
  else
    zeigeHier(xVerschiebung, zeile, "  " .. zeit2)
    time = 0
  end
end

function zeigeHier(x, y, s, h)
  setCursor(x, y)
  if h == nil then
    h = 70
  end
  write(pad(s, h))
end

function zeigeNachricht(...)
  if ... == "" then
    Nachrichtleer = true
  else
    Nachrichtleer = false
  end
  letzteNachricht = ...
  letzteNachrichtZeit = os.time()
  gpu.setBackground(Nachrichtfarbe)
  gpu.setForeground(Nachrichttextfarbe)
  if VersionUpdate == true then
    zeigeHier(1, screen_height - 1, aktualisierenGleich, screen_width)
    zeigeMenu()
  elseif fs.exists("/log") then
    zeigeHier(1, screen_height - 1, fehlerName .. " /log", screen_width)
  else
    zeigeHier(1, screen_height - 1, "", screen_width)
  end
  if ... then
    zeigeHier(1, screen_height, zeichenErsetzen(...), screen_width)
  else
    zeigeHier(1, screen_height, "", screen_width)
  end
  gpu.setBackground(Statusfarbe)
end

function zeigeFehler(...)
  if ... == "" then else
    schreibFehlerLog(...)
    zeigeNachricht(string.format("%s %s", fehlerName, ...))
  end
end

function schreibFehlerLog(...)
  if letzteEingabe == ... then else
    if fs.exists("/log") then
      f = io.open("log", "a")
    else
      f = io.open("log", "w")
    end
    if type(...) == "string" then
      if string.len(...) > max_Bildschirmbreite then
        local rest = string.len(...)
        local a = 0
        while rest > max_Bildschirmbreite do
          f:write(string.sub(..., a, a + max_Bildschirmbreite) .. "\n")
          rest = string.len(string.sub(..., a + max_Bildschirmbreite))
          a = a + max_Bildschirmbreite + 1
        end
        f:write(string.sub(..., a) .. "\n")
      else
        f:write(...)
      end
    elseif type(...) == "table" then
      f:write(require("serialization").serialize(...))
    end
    f:write("\n\n" .. os.time() .. string.rep("-", max_Bildschirmbreite - string.len(os.time())) .. "\n\n")
    f:close()
  end
  letzteEingabe = ...
end

handlers = {}

function dial(name, adresse)
  if state == "Idle" then
    remoteName = name
    zeigeNachricht(waehlen .. "<" .. string.sub(remoteName, 1, xVerschiebung + 12) .. "> <" .. adresse .. ">")
  end
  state = "Dialling"
  wormhole = "out"
  local ok, ergebnis = sg.dial(adresse)
  if ok == nil then
    if string.sub(ergebnis, 0, 20) == "Stargate at address " then
      local AdressEnde = string.find(string.sub(ergebnis, 21), " ") + 20
      ergebnis = string.sub(ergebnis, 0, 20) .. "<" .. getAddress(string.sub(ergebnis, 21, AdressEnde - 1)) .. ">" .. string.sub(ergebnis, AdressEnde)
    end
    zeigeNachricht(ergebnis)
  end
  os.slee(1)
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if entercode == true then
    if e[3] == 13 then
      entercode = false
      sg.sendMessage(enteridc)
      zeigeNachricht(IDCgesendet)
    else
      enteridc = enteridc .. c
      showidc = showidc .. "*"
      zeigeNachricht(IDCeingabe .. ": " .. showidc)
    end
  elseif c == "e" then
    if state == "Connected" and direction == "Outgoing" then
      enteridc = ""
      showidc = ""
      entercode = true
      zeigeNachricht(IDCeingabe .. ":")
    else
      zeigeNachricht(keineVerbindung)
    end
  elseif c == "d" then
    if state == "Connected" and direction == "Incoming" then
      sg.disconnect()
      sg.sendMessage("Request: Disconnect Stargate")
      zeigeNachricht(senden .. aufforderung .. ": " .. stargateAbschalten .. " " .. stargateName)
    else
      sg.disconnect()
      if state == "Idle" then else
        zeigeNachricht(stargateAbschalten .. " " .. stargateName)
      end
    end
  elseif c == "o" then
    if iris == "Offline" then else
      irisOpen()
      if wormhole == "in" then
        if iris == "Offline" then else
          os.sleep(2)
          sg.sendMessage("Manual Override: Iris: Open")
        end
      end
      if state == "Idle" then
        iriscontrol = "on"
      else
        iriscontrol = "off"
      end
    end
  elseif c == "c" then
    if iris == "Offline" then else
      irisClose()
      iriscontrol = "off"
      if wormhole == "in" then
        sg.sendMessage("Manual Override: Iris: Closed")
      end
    end
  elseif c >= "0" and c <= "9" then
    if c == "0" then
      c = 10
    end
    c = c + seite * 10
    na = gespeicherteAdressen[tonumber(c)]
    iriscontrol = "off"
    wormhole = "out"
    if na then
      dial(na[1], na[2])
      if na[3] == "-" then
        else outcode = na[3]
      end
    end
  elseif e[3] == 0 and e[4] == 203 then
    if seite <= -1 then else
      seite = seite - 1
      gpu.setBackground(Adressfarbe)
      gpu.setForeground(Adresstextfarbe)
      for P = 1, screen_height - 3 do
        zeigeHier(1, P, "", xVerschiebung - 3)
      end
      zeigeAnzeige()
    end
  elseif e[3] == 0 and e[4] == 205 then
    if seite + 1 < maxseiten then
      seite = seite + 1
      gpu.setBackground(Adressfarbe)
      gpu.setForeground(Adresstextfarbe)
      for P = 1, screen_height - 3 do
        zeigeHier(1, P, "", xVerschiebung - 3)
      end
      zeigeAnzeige()
    end
  elseif seite == -1 then
    if c == "q" then
      running = false
    elseif c == "i" then
      if iris == "Offline" then else
        send = true
        if control == "On" then
          control = "Off"
          _ENV.control = "Off"
          schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
        else
          control = "On"
          _ENV.control = "On"
          schreibSicherungsdatei(IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate)
        end
      end
    elseif c == "z" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      edit("stargate/adressen.lua")
      seite = -1
      zeigeAnzeige()
      seite = 0
      AdressenSpeichern()
    elseif c == "l" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      edit("stargate/Sicherungsdatei.lua")
      IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
      sides()
      term.clear()
      seite = 0
      zeigeAnzeige()
    end
  end
end

function handlers.sgChevronEngaged(e)
  chevron = e[3]
  if chevron == 1 then
    zielAdresse = e[4]
  elseif chevron == 5 or chevron == 8 then
    zielAdresse = zielAdresse .. "-" .. e[4]
  else
    zielAdresse = zielAdresse .. e[4]
  end
  if string.len(zielAdresse) < 7 and state == "Connected" then
    zielAdresse = getAddress(sg.remoteAddress())
  end
  zeigeNachricht(string.format("Chevron %s %s! <%s>", chevron, aktiviert, zielAdresse))
end

function eventLoop()
  while running do
    checken(zeigeStatus)
    checken(checkReset)
    e = pull_event()
    if e[1] == nil then else
      name = e[1]
      f = handlers[name]
      if f then
        checken(f, e)
      end
      if string.sub(e[1],1,3) == "sgM" then
        if direction == "Outgoing" then
          codeaccepted = e[3]
        elseif direction == "Incoming" and wormhole == "in" then
          incode = e[3]
        end
        if e[4] == "Adressliste" then
          local a = require("serialization").unserialize(e[5])
          if type(a) == "table" then
            angekommeneAdressen(a)
          end
          if type(e[6]) == "string" then
            angekommeneVersion(e[6])
          end
        end
        messageshow = true
      end
    end
  end
end

function angekommeneAdressen(...)
  local AddNewAddress = false
  for a, b in pairs(...) do
    local neuHinzufuegen = false
    for c, d in pairs(adressen) do
      if b[2] ~= d[2] then
        neuHinzufuegen = true
      elseif b[2] == d[2] and d[1] == ">>>" .. d[2] .. "<<<" then
        adressen[c][1] = b[1]
        schreibeAdressen()
        AdressenSpeichern()
        zeigeMenu()
        break
      else
        neuHinzufuegen = false
        break
      end
    end
    if neuHinzufuegen == true then
      AddNewAddress = true
      newAddress(b[2], b[1], true)
    end
  end
  if AddNewAddress == true then
    schreibeAdressen()
    AdressenSpeichern()
    zeigeMenu()
  end
end

function angekommeneVersion(...)
  local Endpunkt = string.len(...)
  local EndpunktVersion = string.len(version)
  if string.sub(..., Endpunkt - 3, Endpunkt) ~= "BETA" and string.sub(version, EndpunktVersion - 3, EndpunktVersion) ~= "BETA" and version ~= ... and autoUpdate == true then
    if component.isAvailable("internet") then
      if version ~= checkServerVersion() then
        VersionUpdate = true
      end
    end
  end
end

function checken(...)
  ok, result = pcall(...)
  if not ok then
    zeigeFehler(result)
  end
end

function Colorful_Lamp_Steuerung()
  if iris == "Closed" or iris == "Closing" or LampenRot == true then
    Colorful_Lamp_Farben(31744) -- rot
  elseif redstoneIDC == false then
    Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneIncoming == false then
    Colorful_Lamp_Farben(32256) -- orange
  elseif LampenGruen == true then
    Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneState == true then
    Colorful_Lamp_Farben(32736) -- gelb
  else
    Colorful_Lamp_Farben(32767) -- weiß
  end
  --32767  weiß
  --32736  gelb
  --32256  orange
  --31744  rot
  --992    grün
  --0      schwarz
end

function Colorful_Lamp_Farben(eingabe, ausgabe)
  if alte_eingabe == eingabe then else
    for k in component.list("colorful_lamp") do
      component.proxy(k).setLampColor(eingabe)
      if ausgabe then
        print(colorfulLampAusschalten .. k)
      end
    end
    alte_eingabe = eingabe
  end
end

function zeigeAnzeige()
  zeigeFarben()
  zeigeStatus()
  zeigeMenu()
end

function redstoneAbschalten(sideNum, Farbe, printAusgabe)
  r.setBundledOutput(sideNum, Farbe, 0)
  print(redstoneAusschalten .. printAusgabe)
end

function beendeAlles()
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  term.clear()
  print(ausschaltenName .. "\n")
  Colorful_Lamp_Farben(0, true)
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
    redstoneAbschalten(sideNum, white, "white")
--    redstoneAbschalten(sideNum, orange, "orange")
--    redstoneAbschalten(sideNum, magenta, "magenta")
--    redstoneAbschalten(sideNum, lightblue, "lightblue")
    redstoneAbschalten(sideNum, yellow, "yellow")
--    redstoneAbschalten(sideNum, lime, "lime")
--    redstoneAbschalten(sideNum, pink, "pink")
--    redstoneAbschalten(sideNum, gray, "gray")
--    redstoneAbschalten(sideNum, silver, "silver")
--    redstoneAbschalten(sideNum, cyan, "cyan")
--    redstoneAbschalten(sideNum, purple, "purple")
--    redstoneAbschalten(sideNum, blue, "blue")
--    redstoneAbschalten(sideNum, brown, "brown")
    redstoneAbschalten(sideNum, green, "green")
    redstoneAbschalten(sideNum, red, "red")
    redstoneAbschalten(sideNum, black, "black")
  end
end

function main()
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "StargateOS")
  if sg.stargateState() == "Idle" and sg.irisState() == "Closed" then
    irisOpen()
  end
  term.clear()
  gpu.setResolution(70, 25)
  zeigeFarben()
  zeigeStatus()
  seite = -1
  zeigeMenu()
  AdressenSpeichern()
  seite = 0
  zeigeMenu()
  eventLoop()
  beendeAlles()
end

checken(main)
