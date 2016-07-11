-- pastebin run -f wLK1gCKt
-- von Nex4rius
-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm

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
local handlers              = {}
local Farben                = {}
local Funktionen            = {}
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

Farben.graueFarbe           = 6684774
Farben.roteFarbe            = 0xFF0000
Farben.weisseFarbe          = 0xFFFFFF
Farben.blaueFarbe           = 0x0000FF
Farben.schwarzeFarbe        = 0x000000
Farben.gelbeFarbe           = 16750899
Farben.brauenFarbe          = 10046464
Farben.grueneFarbe          = 39168

Farben.FehlerFarbe          = Farben.roteFarbe
Farben.Hintergrundfarbe     = Farben.graueFarbe
Farben.Trennlinienfarbe     = Farben.blaueFarbe
Farben.Textfarbe            = Farben.weisseFarbe

Farben.Adressfarbe          = Farben.brauenFarbe
Farben.Adresstextfarbe      = Farben.Textfarbe
Farben.Nachrichtfarbe       = Farben.graueFarbe
Farben.Nachrichttextfarbe   = Farben.Textfarbe
Farben.Steuerungsfarbe      = Farben.gelbeFarbe
Farben.Steuerungstextfarbe  = Farben.schwarzeFarbe
Farben.Statusfarbe          = Farben.grueneFarbe
Farben.Statustextfarbe      = Farben.Textfarbe

local AdressAnzeige
local adressen
local alte_eingabe
local anwahlEnergie
local ausgabe
local chevron
local direction
local eingabe
local energieMenge
local ergebnis
local gespeicherteAdressen
local iris
local k
local letzteNachricht
local locAddr
local mess
local mess_old
local ok
local r
local remAddr
local result
local RichtungName
local sendeAdressen
local sideNum
local state
local StatusName

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

function Funktionen.schreibeAdressen()
  f = io.open("/stargate/adressen.lua", "w")
  f:write('-- pastebin run -f wLK1gCKt\n')
  f:write('-- von Nex4rius\n')
  f:write('-- https://github.com/Nex4rius/Stargate-Programm/tree/master/Stargate-Programm\n--\n')
  f:write('-- to save press "Ctrl + S"\n')
  f:write('-- to close press "Ctrl + W"\n--\n')
  f:write('-- Put your own stargate addresses here\n')
  f:write('-- "" for no Iris Code\n--\n\n')
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

function Funktionen.setCursor(col, row)
  term.setCursor(col, row)
end

function Funktionen.pull_event()
  local Wartezeit = 1
  if state == "Idle" and checkEnergy == energy then
    if Nachrichtleer == true then
      if VersionUpdate == true then
        gpu.setBackground(Farben.schwarzeFarbe)
        gpu.setForeground(Farben.weisseFarbe)
        print(sprachen.aktualisierenJetzt)
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

local sprachen = loadfile("/stargate/sprache/" .. Sprache .. ".lua")()
local ersetzen = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)

function Funktionen.zeichenErsetzen(eingabeErsetzung)
  return string.gsub(eingabeErsetzung, "%a+", function (str) return ersetzen [str] end)
end

function Funktionen.checkReset()
  if time == "-" then else
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

function Funktionen.zeigeHier(x, y, s, h)
  if type(x) == "number" and type(y) == "number" and type(s) == "string" then
    Funktionen.setCursor(x, y)
    if not h then
      h = screen_width
    end
    term.write(s .. string.rep(" ", h - string.len(s)))
  end
end

function Funktionen.ErsetzePunktMitKomma(...)
  if Sprache == "deutsch" then
    local Punkt = string.find(..., "%.")
    if type(Punkt) == "number" then
      return string.sub(..., 0, Punkt - 1) .. "," .. string.sub(..., Punkt + 1)
    end
  end
  return ...
end

function Funktionen.getAddress(...)
  if ... == "" or ... == nil then
    return ""
  elseif string.len(...) == 7 then
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7)
  else
    return string.sub(..., 1, 4) .. "-" .. string.sub(..., 5, 7) .. "-" .. string.sub(..., 8, 9)
  end
end

function Funktionen.AdressenLesen()
  for i, na in pairs(gespeicherteAdressen) do
    if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
      AdressAnzeige = i - seite * 10
      if AdressAnzeige == 10 then
        AdressAnzeige = 0
      end
      print(AdressAnzeige .. " " .. string.sub(na[1], 1, xVerschiebung - 7))
      if string.sub(na[4], 1, 1) == "<" then
        gpu.setForeground(Farben.FehlerFarbe)
        print("   " .. na[4])
        gpu.setForeground(Farben.Adresstextfarbe)
      else
        print("   " .. na[4])
      end
    end
  end
end

function Funktionen.Infoseite()
  print(sprachen.Steuerung)
  if iris == "Offline" then else
    print("I " .. sprachen.IrisSteuerung .. sprachen.an_aus)
  end
  print("Z " .. sprachen.AdressenBearbeiten)
  print("Q " .. sprachen.beenden)
  print("L " .. sprachen.EinstellungenAendern .. "\n")
  print(sprachen.RedstoneSignale)
  gpu.setBackground(Farben.weisseFarbe)
  gpu.setForeground(Farben.schwarzeFarbe)
  print(sprachen.RedstoneWeiss)
  gpu.setBackground(Farben.roteFarbe)
  print(sprachen.RedstoneRot)
  gpu.setBackground(Farben.gelbeFarbe)
  print(sprachen.RedstoneGelb)
  gpu.setBackground(Farben.schwarzeFarbe)
  gpu.setForeground(Farben.weisseFarbe)
  print(sprachen.RedstoneSchwarz)
  gpu.setBackground(Farben.grueneFarbe)
  print(sprachen.RedstoneGruen)
  gpu.setBackground(Farben.Adressfarbe)
  gpu.setForeground(Farben.Adresstextfarbe)
  print(sprachen.versionName .. version)
  print("\n" .. sprachen.entwicklerName .. " Nex4rius")
end

function Funktionen.AdressenSpeichern()
  adressen = loadfile("/stargate/adressen.lua")()
  gespeicherteAdressen = {}
  sendeAdressen = {}
  local k = 0
  for i, na in pairs(adressen) do
    if na[2] == Funktionen.getAddress(sg.localAddress()) then
      k = -1
      sendeAdressen[i] = {}
      sendeAdressen[i][1] = na[1]
      sendeAdressen[i][2] = na[2]
    else
      local anwahlEnergie = sg.energyToDial(na[2])
      if not anwahlEnergie then
        anwahlEnergie = sprachen.fehlerName
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
      gespeicherteAdressen[i + k][4] = Funktionen.ErsetzePunktMitKomma(anwahlEnergie)
    end
    Funktionen.zeigeNachricht(sprachen.verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
    AdressenAnzahl = i
  end
  gpu.setBackground(Farben.Adressfarbe)
  gpu.setForeground(Farben.Adresstextfarbe)
  for P = 1, screen_height - 3 do
    Funktionen.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  Funktionen.zeigeMenu()
  Funktionen.zeigeNachricht("")
end

function Funktionen.zeigeMenu()
  gpu.setBackground(Farben.Adressfarbe)
  gpu.setForeground(Farben.Adresstextfarbe)
  for P = 1, screen_height - 3 do
    Funktionen.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  Funktionen.setCursor(1, 1)
  if seite == -1 then
    Funktionen.Infoseite()
  else
    if (os.time() / sectime) - letzterAdressCheck > 21600 then
      letzterAdressCheck = os.time() / sectime
      Funktionen.AdressenSpeichern()
    else
      print(sprachen.Adressseite .. seite + 1)
      Funktionen.AdressenLesen()
    end
    iris = Funktionen.getIrisState()
  end
end

function Funktionen.neueZeile(...)
  zeile = zeile + ...
end

function Funktionen.zeigeFarben()
  gpu.setBackground(Farben.Trennlinienfarbe)
  for P = 1, screen_height - 2 do
    Funktionen.zeigeHier(xVerschiebung - 2, P, "  ", 1)
  end
  Funktionen.zeigeHier(1, screen_height - 2, "", 80)
  Funktionen.zeigeHier(xVerschiebung - 2, Trennlinienhoehe, "")
  Funktionen.neueZeile(1)
end

function Funktionen.getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function Funktionen.irisClose()
  sg.closeIris()
  Funktionen.RedstoneAenderung(yellow, 255)
  Funktionen.Colorful_Lamp_Steuerung()
end

function Funktionen.irisOpen()
  sg.openIris()
  Funktionen.RedstoneAenderung(yellow, 0)
  Funktionen.Colorful_Lamp_Steuerung()
end

function Funktionen.sides()
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

function Funktionen.iriscontroller()
  if state == "Dialing" then
    messageshow = true
  end
  if direction == "Incoming" and incode == IDC and control == "Off" then
    IDCyes = true
    Funktionen.RedstoneAenderung(black, 255)
    if iris == "Closed" or iris == "Closing" or LampenRot == true then else
      Funktionen.Colorful_Lamp_Farben(992)
    end
  end
  if direction == "Incoming" and incode == IDC and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then
      sg.sendMessage("IDC Accepted Iris: Offline")
    else
      Funktionen.irisOpen()
      os.sleep(2)
      sg.sendMessage("IDC Accepted Iris: Open")
    end
    iriscontrol = "off"
    IDCyes = true
  elseif direction == "Incoming" and send == true then
    sg.sendMessage("Iris Control: " .. control .. " Iris: " .. iris, Funktionen.sendeAdressliste())
    send = false
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then else
      Funktionen.irisClose()
      Funktionen.RedstoneAenderung(red, 255)
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
      Funktionen.irisOpen()
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
    Funktionen.zeigeNachricht("")
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
      sg.sendMessage(outcode, Funktionen.sendeAdressliste())
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    Funktionen.zeigeNachricht(sprachen.nachrichtAngekommen .. codeaccepted .. "                   ")
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

function Funktionen.sendeAdressliste()
  if einmalAdressenSenden then
    einmalAdressenSenden = false
    return "Adressliste", require("serialization").serialize(sendeAdressen), version
  else
    return ""
  end
end

function Funktionen.newAddress(neueAdresse, neuerName, ...)
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
      Funktionen.schreibeAdressen()
      AddNewAddress = false
      Funktionen.AdressenSpeichern()
      Funktionen.zeigeMenu()
    end
    return true
  else
    return false
  end
end

function Funktionen.destinationName()
  if state == "Dialling" or state == "Connected" then
    if remoteName == "" and state == "Dialling" and wormhole == "in" then
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
        Funktionen.newAddress(remAddr)
      end
    end
  end
end

function Funktionen.wormholeDirection()
  if direction == "Outgoing" then
    wormhole = "out"
  end
  if wormhole == "out" and state == "Closing" then
    direction = "Outgoing"
  end
end

function Funktionen.aktualisiereStatus()
  gpu.setResolution(70, 25)
  sg                          = component.getPrimary("stargate")
  locAddr                     = Funktionen.getAddress(sg.localAddress())
  remAddr                     = Funktionen.getAddress(sg.remoteAddress())
  iris                        = Funktionen.getIrisState()
  state, chevrons, direction  = sg.stargateState()
  Funktionen.destinationName()
  Funktionen.wormholeDirection()
  Funktionen.iriscontroller()
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
      Funktionen.zeigeNachricht("")
    end
  end
end

function Funktionen.autoclose()
  if autoclosetime == false then
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.autoSchliessungAus)
  else
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function Funktionen.zeigeEnergie()
  if     energy > 10000000000 then
    energieMenge = string.format("%.3f", energy / 1000000000) .. " G"
  elseif energy > 10000000 then
    energieMenge = string.format("%.2f", energy / 1000000) .. " M"
  elseif energy > 10000 then
    energieMenge = string.format("%.1f", energy / 1000) .. " k"
  else
    energieMenge = string.format("%.f",  energy)
  end
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.energie1 .. energytype .. sprachen.energie2 .. Funktionen.ErsetzePunktMitKomma(energieMenge))
end

function Funktionen.activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time()) / sectime
    if time > 0 then
      Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zeit1 .. Funktionen.ErsetzePunktMitKomma(string.format("%.1f", time)) .. "s")
    end
  else
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zeit2)
    time = 0
  end
end

function Funktionen.zeigeSteuerung()
  Funktionen.zeigeFarben()
  gpu.setBackground(Farben.Steuerungsfarbe)
  gpu.setForeground(Farben.Steuerungstextfarbe)
  Funktionen.neueZeile(3)
  Funktionen.zeigeHier(xVerschiebung, zeile - 1, "")
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.Steuerung) Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "") Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  D " .. sprachen.abschalten)
  Funktionen.zeigeHier(xVerschiebung + 20, zeile, "E " .. sprachen.IDCeingabe) Funktionen.neueZeile(1)
  if iris == "Offline" then
    control = "Off"
  else
    Funktionen.zeigeHier(xVerschiebung, zeile, "  O " .. sprachen.oeffneIris)
    Funktionen.zeigeHier(xVerschiebung + 20, zeile, "C " .. sprachen.schliesseIris) Funktionen.neueZeile(1)
  end
  if seite >= 0 then
    if seite >= 1 then
      Funktionen.zeigeHier(xVerschiebung, zeile, "  ← " .. sprachen.vorherigeSeite)
    else
      Funktionen.zeigeHier(xVerschiebung, zeile, "  ← " .. sprachen.SteuerungName)
    end
  else
    Funktionen.zeigeHier(xVerschiebung, zeile, "")
  end
  if seite == -1 then
    Funktionen.zeigeHier(xVerschiebung + 20, zeile, "→ " .. sprachen.zeigeAdressen)
  elseif maxseiten > seite + 1 then
    Funktionen.zeigeHier(xVerschiebung + 20, zeile, "→ " .. sprachen.naechsteSeite)
  end
  Funktionen.neueZeile(1)
  for i = zeile, screen_height - 3 do
    Funktionen.zeigeHier(xVerschiebung, i, "")
  end
end

function Funktionen.RedstoneAenderung(a, b)
  if sideNum == nil then
    Funktionen.sides()
  end
  if component.isAvailable("redstone") then
    component.getPrimary("redstone").setBundledOutput(sideNum, a, b)
  end
end

function Funktionen.RedstoneKontrolle()
  if RichtungName == sprachen.RichtungNameEin then
    if redstoneIncoming == true then
      Funktionen.RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
  elseif redstoneIncoming == false and state == "Idle" then
    Funktionen.RedstoneAenderung(red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState == true then
      Funktionen.RedstoneAenderung(white, 0)
      redstoneState = false
    end
  elseif redstoneState == false then
    Funktionen.RedstoneAenderung(white, 255)
    redstoneState = true
  end
  if IDCyes == true or (IDC == "" and state == "Connected" and direction == "Incoming" and iris == "Offline") then
    if redstoneIDC == true then
      Funktionen.RedstoneAenderung(black, 255)
      redstoneIDC = false
    end
  elseif redstoneIDC == false then
    Funktionen.RedstoneAenderung(black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected == true then
      Funktionen.RedstoneAenderung(green, 255)
      redstoneConnected = false
    end
  elseif redstoneConnected == false then
    Funktionen.RedstoneAenderung(green, 0)
    redstoneConnected = true
  end
end

function Funktionen.Colorful_Lamp_Farben(eingabe, ausgabe)
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

function Funktionen.Colorful_Lamp_Steuerung()
  if iris == "Closed" or iris == "Closing" or LampenRot == true then
    Funktionen.Colorful_Lamp_Farben(31744) -- rot
  elseif redstoneIDC == false then
    Funktionen.Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneIncoming == false then
    Funktionen.Colorful_Lamp_Farben(32256) -- orange
  elseif LampenGruen == true then
    Funktionen.Colorful_Lamp_Farben(992)   -- grün
  elseif redstoneState == true then
    Funktionen.Colorful_Lamp_Farben(32736) -- gelb
  else
    Funktionen.Colorful_Lamp_Farben(32767) -- weiß
  end
  --32767  weiß
  --32736  gelb
  --32256  orange
  --31744  rot
  --992    grün
  --0      schwarz
end

function Funktionen.zeigeStatus()
  Funktionen.aktualisiereStatus()
  gpu.setBackground(Farben.Statusfarbe)
  gpu.setForeground(Farben.Statustextfarbe)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.lokaleAdresse .. locAddr) Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zielAdresseName .. zielAdresse) Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zielName .. remoteName) Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.statusName .. StatusName) Funktionen.neueZeile(1)
  Funktionen.zeigeEnergie() Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IrisName .. Funktionen.zeichenErsetzen(iris)) Funktionen.neueZeile(1)
  if iris == "Offline" then else
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IrisSteuerung .. Funktionen.zeichenErsetzen(control)) Funktionen.neueZeile(1)
  end
  if IDCyes == true then
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IDCakzeptiert) Funktionen.neueZeile(1)
  else
    Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IDCname .. incode) Funktionen.neueZeile(1)
  end
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.chevronName .. chevrons) Funktionen.neueZeile(1)
  Funktionen.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.richtung .. RichtungName) Funktionen.neueZeile(1)
  Funktionen.activetime() Funktionen.neueZeile(1)
  Funktionen.autoclose()
  Funktionen.zeigeHier(xVerschiebung, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  Funktionen.zeigeSteuerung()
  Funktionen.RedstoneKontrolle()
  Funktionen.Colorful_Lamp_Steuerung()
end

function Funktionen.zeigeNachricht(...)
  if ... == "" then
    Nachrichtleer = true
  else
    Nachrichtleer = false
  end
  letzteNachricht = ...
  letzteNachrichtZeit = os.time()
  gpu.setBackground(Farben.Nachrichtfarbe)
  gpu.setForeground(Farben.Nachrichttextfarbe)
  if VersionUpdate == true then
    Funktionen.zeigeHier(1, screen_height - 1, sprachen.aktualisierenGleich, screen_width)
  elseif fs.exists("/log") then
    Funktionen.zeigeHier(1, screen_height - 1, sprachen.fehlerName .. " /log", screen_width)
    Funktionen.zeigeHier(1, screen_height, "", 0)
    Funktionen.zeigeMenu()
  else
    Funktionen.zeigeHier(1, screen_height - 1, "", screen_width)
  end
  if ... then
    Funktionen.zeigeHier(1, screen_height, Funktionen.zeichenErsetzen(...), screen_width)
  else
    Funktionen.zeigeHier(1, screen_height, "", screen_width)
  end
  gpu.setBackground(Farben.Statusfarbe)
end

function Funktionen.schreibFehlerLog(...)
  if letzteEingabe == ... then else
    if fs.exists("/log") then
      f = io.open("log", "a")
    else
      f = io.open("log", "w")
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

function Funktionen.zeigeFehler(...)
  if ... == "" then else
    Funktionen.schreibFehlerLog(...)
    Funktionen.zeigeNachricht(string.format("%s %s", sprachen.fehlerName, ...))
  end
end

function Funktionen.dial(name, adresse)
  if state == "Idle" then
    remoteName = name
    Funktionen.zeigeNachricht(sprachen.waehlen .. "<" .. string.sub(remoteName, 1, xVerschiebung + 12) .. "> <" .. adresse .. ">")
  end
  state = "Dialling"
  wormhole = "out"
  local ok, ergebnis = sg.dial(adresse)
  if ok == nil then
    if string.sub(ergebnis, 0, 20) == "Stargate at address " then
      local AdressEnde = string.find(string.sub(ergebnis, 21), " ") + 20
      ergebnis = string.sub(ergebnis, 0, 20) .. "<" .. Funktionen.getAddress(string.sub(ergebnis, 21, AdressEnde - 1)) .. ">" .. string.sub(ergebnis, AdressEnde)
    end
    Funktionen.zeigeNachricht(ergebnis)
  end
  os.sleep(1)
end

handlers[key_event_name] = function(e)
  c = string.char(e[3])
  if entercode == true then
    if e[3] == 13 then
      entercode = false
      sg.sendMessage(enteridc)
      Funktionen.zeigeNachricht(sprachen.IDCgesendet)
    else
      enteridc = enteridc .. c
      showidc = showidc .. "*"
      Funktionen.zeigeNachricht(sprachen.IDCeingabe .. ": " .. showidc)
    end
  elseif c == "e" then
    if state == "Connected" and direction == "Outgoing" then
      enteridc = ""
      showidc = ""
      entercode = true
      Funktionen.zeigeNachricht(sprachen.IDCeingabe .. ":")
    else
      Funktionen.zeigeNachricht(sprachen.keineVerbindung)
    end
  elseif c == "d" then
    if state == "Connected" and direction == "Incoming" then
      sg.disconnect()
      sg.sendMessage("Request: Disconnect Stargate")
      Funktionen.zeigeNachricht(sprachen.senden .. sprachen.aufforderung .. ": " .. sprachen.stargateAbschalten .. " " .. sprachen.stargateName)
    else
      sg.disconnect()
      if state == "Idle" then else
        Funktionen.zeigeNachricht(sprachen.stargateAbschalten .. " " .. sprachen.stargateName)
      end
    end
  elseif c == "o" then
    if iris == "Offline" then else
      Funktionen.irisOpen()
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
      Funktionen.irisClose()
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
      Funktionen.dial(na[1], na[2])
      if na[3] == "-" then
        else outcode = na[3]
      end
    end
  elseif e[3] == 0 and e[4] == 203 then
    if seite <= -1 then else
      seite = seite - 1
      gpu.setBackground(Farben.Adressfarbe)
      gpu.setForeground(Farben.Adresstextfarbe)
      for P = 1, screen_height - 3 do
        Funktionen.zeigeHier(1, P, "", xVerschiebung - 3)
      end
      Funktionen.zeigeAnzeige()
    end
  elseif e[3] == 0 and e[4] == 205 then
    if seite + 1 < maxseiten then
      seite = seite + 1
      gpu.setBackground(Farben.Adressfarbe)
      gpu.setForeground(Farben.Adresstextfarbe)
      for P = 1, screen_height - 3 do
        Funktionen.zeigeHier(1, P, "", xVerschiebung - 3)
      end
      Funktionen.zeigeAnzeige()
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
      gpu.setBackground(Farben.schwarzeFarbe)
      gpu.setForeground(Farben.Textfarbe)
      edit("stargate/adressen.lua")
      seite = -1
      Funktionen.zeigeAnzeige()
      seite = 0
      Funktionen.AdressenSpeichern()
    elseif c == "l" then
      gpu.setBackground(Farben.schwarzeFarbe)
      gpu.setForeground(Farben.Textfarbe)
      edit("stargate/Sicherungsdatei.lua")
      IDC, autoclosetime, RF, Sprache, side, installieren, control, autoUpdate = loadfile("/stargate/Sicherungsdatei.lua")()
      Funktionen.sides()
      term.clear()
      seite = 0
      Funktionen.zeigeAnzeige()
    end
  end
end

function handlers.sgChevronEngaged(e)
  chevron = e[3]
  if chevron <= 4 then
    zielAdresse = string.sub(sg.remoteAddress(), 1, chevron)
  elseif chevron <= 7 then
    zielAdresse = string.sub(sg.remoteAddress(), 1, 4) .. "-" .. string.sub(sg.remoteAddress(), 5, chevron)
  else
    zielAdresse = string.sub(sg.remoteAddress(), 1, 4) .. "-" .. string.sub(sg.remoteAddress(), 5, 7) .. "-" .. string.sub(sg.remoteAddress(), 8, chevron)
  end
  Funktionen.zeigeNachricht(string.format("Chevron %s %s! <%s>", chevron, sprachen.aktiviert, zielAdresse))
end

function Funktionen.eventLoop()
  while running do
    Funktionen.checken(Funktionen.zeigeStatus)
    Funktionen.checken(Funktionen.checkReset)
    e = Funktionen.pull_event()
    if e[1] == nil then else
      name = e[1]
      f = handlers[name]
      if f then
        Funktionen.checken(f, e)
      end
      if string.sub(e[1],1,3) == "sgM" then
        if direction == "Outgoing" then
          codeaccepted = e[3]
        elseif direction == "Incoming" and wormhole == "in" then
          incode = e[3]
        end
        if e[4] == "Adressliste" then
          local inAdressen = require("serialization").unserialize(e[5])
          if type(inAdressen) == "table" then
            Funktionen.angekommeneAdressen(inAdressen)
          end
          if type(e[6]) == "string" then
            Funktionen.angekommeneVersion(e[6])
          end
        end
        messageshow = true
      end
    end
  end
end

function Funktionen.angekommeneAdressen(...)
  local AddNewAddress = false
  for a, b in pairs(...) do
    local neuHinzufuegen = false
    for c, d in pairs(adressen) do
      if b[2] ~= d[2] then
        neuHinzufuegen = true
      elseif b[2] == d[2] and d[1] == ">>>" .. d[2] .. "<<<" and d[1] ~= b[1] then
        if Funktionen.newAddress(b[2], b[1], true) then
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
      Funktionen.newAddress(b[2], b[1], true)
    end
  end
  if AddNewAddress == true then
    Funktionen.schreibeAdressen()
    Funktionen.AdressenSpeichern()
    Funktionen.zeigeMenu()
  end
end

function Funktionen.angekommeneVersion(...)
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

function Funktionen.checken(...)
  ok, result = pcall(...)
  if not ok then
    Funktionen.zeigeFehler(result)
  end
end

function Funktionen.zeigeAnzeige()
  Funktionen.zeigeFarben()
  Funktionen.zeigeStatus()
  Funktionen.zeigeMenu()
end

function Funktionen.redstoneAbschalten(sideNum, Farbe, printAusgabe)
  r.setBundledOutput(sideNum, Farbe, 0)
  print(sprachen.redstoneAusschalten .. printAusgabe)
end

function Funktionen.beendeAlles()
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  gpu.setBackground(Farben.schwarzeFarbe)
  gpu.setForeground(Farben.weisseFarbe)
  term.clear()
  print(sprachen.ausschaltenName .. "\n")
  Funktionen.Colorful_Lamp_Farben(0, true)
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
    Funktionen.redstoneAbschalten(sideNum, white, "white")
--    Funktionen.redstoneAbschalten(sideNum, orange, "orange")
--    Funktionen.redstoneAbschalten(sideNum, magenta, "magenta")
--    Funktionen.redstoneAbschalten(sideNum, lightblue, "lightblue")
    Funktionen.redstoneAbschalten(sideNum, yellow, "yellow")
--    Funktionen.redstoneAbschalten(sideNum, lime, "lime")
--    Funktionen.redstoneAbschalten(sideNum, pink, "pink")
--    Funktionen.redstoneAbschalten(sideNum, gray, "gray")
--    Funktionen.redstoneAbschalten(sideNum, silver, "silver")
--    Funktionen.redstoneAbschalten(sideNum, cyan, "cyan")
--    Funktionen.redstoneAbschalten(sideNum, purple, "purple")
--    Funktionen.redstoneAbschalten(sideNum, blue, "blue")
--    Funktionen.redstoneAbschalten(sideNum, brown, "brown")
    Funktionen.redstoneAbschalten(sideNum, green, "green")
    Funktionen.redstoneAbschalten(sideNum, red, "red")
    Funktionen.redstoneAbschalten(sideNum, black, "black")
  end
end

function Funktionen.main()
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "StargateComputer")
  if sg.stargateState() == "Idle" and Funktionen.getIrisState() == "Closed" then
    Funktionen.irisOpen()
  end
  term.clear()
  gpu.setResolution(70, 25)
  screen_width, screen_height = gpu.getResolution()
  Funktionen.zeigeFarben()
  Funktionen.zeigeStatus()
  seite = -1
  Funktionen.zeigeMenu()
  Funktionen.AdressenSpeichern()
  seite = 0
  Funktionen.zeigeMenu()
  Funktionen.eventLoop()
  Funktionen.beendeAlles()
end

Funktionen.checken(Funktionen.main)
