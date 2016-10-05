-- pastebin run -f Dkt9dn4S
-- von Nex4rius
-- https://github.com/Nex4rius/Nex4rius-Programme/tree/master/Stargate-Programm

local component                 = require("component")
local term                      = require("term")
local event                     = require("event")
local fs                        = require("filesystem")
local edit                      = loadfile("/bin/edit.lua")
local schreibSicherungsdatei    = loadfile("/stargate/schreibSicherungsdatei.lua")
local Sicherung                 = loadfile("/stargate/Sicherungsdatei.lua")()
local gpu                       = component.getPrimary("gpu")
local sg                        = component.getPrimary("stargate")
local screen                    = component.getPrimary("screen")

local sectime                   = os.time()
os.sleep(1)
sectime                         = sectime - os.time()
local letzteNachrichtZeit       = os.time()
local letzterAdressCheck        = os.time() / sectime
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

Farben.graueFarbe               = 6684774
Farben.hellblau                 = 0x606060
Farben.hellgrau                 = 8421504
Farben.roteFarbe                = 0xFF0000
Farben.weisseFarbe              = 0xFFFFFF
Farben.blaueFarbe               = 0x0000FF
Farben.schwarzeFarbe            = 0x000000
Farben.gelbeFarbe               = 16750899
Farben.brauenFarbe              = 10046464
Farben.grueneFarbe              = 39168

Farben.FehlerFarbe              = Farben.roteFarbe
Farben.Hintergrundfarbe         = Farben.graueFarbe
Farben.Trennlinienfarbe         = Farben.blaueFarbe
Farben.Textfarbe                = Farben.weisseFarbe

Farben.Adressfarbe              = Farben.brauenFarbe
Farben.AdressfarbeAktiv         = Farben.hellblau
Farben.Adresstextfarbe          = Farben.Textfarbe
Farben.Nachrichtfarbe           = Farben.graueFarbe
Farben.Nachrichttextfarbe       = Farben.Textfarbe
Farben.Steuerungsfarbe          = Farben.gelbeFarbe
Farben.Steuerungstextfarbe      = Farben.schwarzeFarbe
Farben.Statusfarbe              = Farben.grueneFarbe
Farben.Statustextfarbe          = Farben.Textfarbe

Farben.white                    = 0
--Farben.orange                   = 1
--Farben.magenta                  = 2
--Farben.lightblue                = 3
Farben.yellow                   = 4
--Farben.lime                     = 5
--Farben.pink                     = 6
--Farben.gray                     = 7
--Farben.silver                   = 8
--Farben.cyan                     = 9
--Farben.purple                   = 10
--Farben.blue                     = 11
--Farben.brown                    = 12
Farben.green                    = 13
Farben.red                      = 14
Farben.black                    = 15

Taste.Koordinaten               = {}
Taste.Steuerunglinks            = {}
Taste.Steuerungrechts           = {}

local AdressAnzeige, adressen, alte_eingabe, anwahlEnergie, ausgabe, c, chevron, direction, eingabe, energieMenge, ergebnis, gespeicherteAdressen
local iris, k, letzteNachricht, locAddr, mess, mess_old, ok, r, remAddr, result, RichtungName, sendeAdressen, sideNum, state, StatusName, version

do
  local args                    = require("shell").parse(...)
  Funktion.update               = args[1]
  Funktion.checkServerVersion   = args[2]
  version                       = tostring(args[3])
end
  
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

if Sicherung.RF == true then
  energytype          = "RF"
  energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  Trennlinienhoehe    = 13
end

screen.setTouchModeInverted(true)

function Funktion.schreibeAdressen()
  local f = io.open("/stargate/adressen.lua", "w")
  f:write('-- pastebin run -f Dkt9dn4S\n')
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

function Funktion.setCursor(col, row)
  term.setCursor(col, row)
end

function Funktion.pull_event()
  local Wartezeit = 1
  if state == "Idle" and checkEnergy == energy then
    if Nachrichtleer == true then
      if VersionUpdate == true then
        gpu.setBackground(Farben.schwarzeFarbe)
        gpu.setForeground(Farben.weisseFarbe)
        print(sprachen.aktualisierenJetzt)
        Funktion.update("master")
      end
      Wartezeit = 300
    else
      Wartezeit = 50
    end
  end
  checkEnergy = energy
  local eventErgebnis = {event.pull(Wartezeit)}
  return eventErgebnis
end

local Bildschirmbreite, Bildschirmhoehe = gpu.getResolution()
local max_Bildschirmbreite, max_Bildschirmhoehe = gpu.maxResolution()
local key_event_name = "key_down"

local sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
local ersetzen = loadfile("/stargate/sprache/ersetzen.lua")(sprachen)

function Funktion.zeichenErsetzen(eingabeErsetzung)
  return string.gsub(eingabeErsetzung, "%a+", function (str) return ersetzen [str] end)
end

function Funktion.touchscreen(x, y)
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
    Funktion.setCursor(x, y)
    if not h then
      h = Bildschirmbreite
    end
    term.write(s .. string.rep(" ", h - string.len(s)))
  end
end

function Funktion.ErsetzePunktMitKomma(...)
  if Sicherung.Sprache == "deutsch" then
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
  for i, na in pairs(gespeicherteAdressen) do
    if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
      AdressAnzeige = i - seite * 10
      if AdressAnzeige == 10 then
        AdressAnzeige = 0
      end
      if na[2] == remAddr and string.len(tostring(remAddr)) > 5 then
        gpu.setBackground(Farben.AdressfarbeAktiv)
        Funktion.zeigeHier(1, y , "", 30)
        Funktion.zeigeHier(1, y + 1, "", 30)
      end
      Funktion.zeigeHier(1, y, AdressAnzeige .. " " .. string.sub(na[1], 1, xVerschiebung - 7), 28 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
      y = y + 1
      if string.sub(na[4], 1, 1) == "<" then
        gpu.setForeground(Farben.FehlerFarbe)
        Funktion.zeigeHier(1, y, "   " .. na[4], 27 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
        gpu.setForeground(Farben.Adresstextfarbe)
      else
        Funktion.zeigeHier(1, y, "   " .. na[4], 27 - string.len(string.sub(na[1], 1, xVerschiebung - 7)))
      end
      y = y + 1
      gpu.setBackground(Farben.Adressfarbe)
    end
  end
end

function Funktion.Infoseite()
  local i = 1
  Taste.links = {}
  print(sprachen.Steuerung)
  if iris == "Offline" then
  else
    print("I " .. sprachen.IrisSteuerung .. sprachen.an_aus)
    i = i + 1
    Taste.links[i] = Taste.i
  end
  print("Z " .. sprachen.AdressenBearbeiten)
  i = i + 1
  Taste.links[i] = Taste.z
  print("Q " .. sprachen.beenden)
  i = i + 1
  Taste.links[i] = Taste.q
  print("L " .. sprachen.EinstellungenAendern)
  i = i + 1
  Taste.links[i] = Taste.l
  print("U " .. sprachen.Update)
  i = i + 1
  Taste.links[i] = Taste.u
  local version_Zeichenlaenge = string.len(version)
  if string.sub(version, version_Zeichenlaenge - 3, version_Zeichenlaenge) == "BETA" then
    print("B " .. sprachen.UpdateBeta)
    i = i + 1
    Taste.links[i] = Taste.b
  end
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

function Funktion.AdressenSpeichern()
  adressen = loadfile("/stargate/adressen.lua")()
  gespeicherteAdressen = {}
  sendeAdressen = {}
  local k = 0
  for i, na in pairs(adressen) do
    if na[2] == Funktion.getAddress(sg.localAddress()) then
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
      gespeicherteAdressen[i + k][4] = Funktion.ErsetzePunktMitKomma(anwahlEnergie)
    end
    Funktion.zeigeNachricht(sprachen.verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
    AdressenAnzahl = i
  end
  gpu.setBackground(Farben.Adressfarbe)
  gpu.setForeground(Farben.Adresstextfarbe)
  for P = 1, Bildschirmhoehe - 3 do
    Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  Funktion.zeigeMenu()
  Funktion.zeigeNachricht("")
end

function Funktion.zeigeMenu()
  gpu.setBackground(Farben.Adressfarbe)
  gpu.setForeground(Farben.Adresstextfarbe)
  for P = 1, Bildschirmhoehe - 3 do
    Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
  end
  Funktion.setCursor(1, 1)
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
  gpu.setBackground(Farben.Trennlinienfarbe)
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
      sg.sendMessage("IDC Accepted Iris: Offline")
    else
      Funktion.irisOpen()
      os.sleep(2)
      sg.sendMessage("IDC Accepted Iris: Open")
    end
    iriscontrol = "off"
    IDCyes = true
  elseif direction == "Incoming" and send == true then
    sg.sendMessage("Iris Control: " .. Sicherung.control .. " Iris: " .. iris, Funktion.sendeAdressliste())
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
    if outcode == "-" or outcode == nil then else
      sg.sendMessage(outcode, Funktion.sendeAdressliste())
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    Funktion.zeigeNachricht(sprachen.nachrichtAngekommen .. codeaccepted .. "                   ")
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
  if AddNewAddress == true and string.len(neueAdresse) == 11 then
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
  gpu.setBackground(Farben.Steuerungsfarbe)
  gpu.setForeground(Farben.Steuerungstextfarbe)
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
  gpu.setBackground(Farben.Statusfarbe)
  gpu.setForeground(Farben.Statustextfarbe)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.lokaleAdresse .. locAddr) Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zielAdresseName .. zielAdresse) Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.zielName .. remoteName) Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.statusName .. StatusName) Funktion.neueZeile(1)
  Funktion.zeigeEnergie() Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IrisName .. Funktion.zeichenErsetzen(iris)) Funktion.neueZeile(1)
  if iris == "Offline" then else
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IrisSteuerung .. Funktion.zeichenErsetzen(Sicherung.control)) Funktion.neueZeile(1)
  end
  if IDCyes == true then
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IDCakzeptiert) Funktion.neueZeile(1)
  else
    Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.IDCname .. incode) Funktion.neueZeile(1)
  end
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.chevronName .. chevrons) Funktion.neueZeile(1)
  Funktion.zeigeHier(xVerschiebung, zeile, "  " .. sprachen.richtung .. RichtungName) Funktion.neueZeile(1)
  Funktion.activetime() Funktion.neueZeile(1)
  Funktion.autoclose()
  Funktion.zeigeHier(xVerschiebung, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  Funktion.zeigeSteuerung()
  Funktion.RedstoneKontrolle()
  Funktion.Colorful_Lamp_Steuerung()
end

function Funktion.zeigeNachricht(...)
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
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.aktualisierenGleich, Bildschirmbreite)
    Funktion.zeigeMenu()
  elseif fs.exists("/log") then
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, sprachen.fehlerName .. " /log", Bildschirmbreite)
    Funktion.zeigeHier(1, Bildschirmhoehe, "", 0)
  else
    Funktion.zeigeHier(1, Bildschirmhoehe - 1, "", Bildschirmbreite)
  end
  if ... then
    Funktion.zeigeHier(1, Bildschirmhoehe, Funktion.zeichenErsetzen(...), Bildschirmbreite)
  else
    Funktion.zeigeHier(1, Bildschirmhoehe, "", Bildschirmbreite)
  end
  gpu.setBackground(Farben.Statusfarbe)
end

function Funktion.schreibFehlerLog(...)
  if letzteEingabe == ... then else
    local f
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

Funktion[key_event_name] = function(e)
  c = string.char(e[3])
  if entercode == true then
    Taste.eingabe_enter()
  elseif e[3] == 0 and e[4] == 203 then
    Taste.Pfeil_links()
  elseif e[3] == 0 and e[4] == 205 then
    Taste.Pfeil_rechts()
  elseif c == "e" then
    Taste.e()
  elseif c == "d" then
    Taste.d()
  elseif c == "o" then
    Taste.o()
  elseif c == "c" then
    Taste.c()
  elseif seite == -1 then
    if c == "q" then
      Taste.q()
    elseif c == "i" then
      Taste.i()
    elseif c == "z" then
      Taste.z()
    elseif c == "l" then
      Taste.l()
    elseif c == "u" then
      Taste.u()
    elseif c == "b" then
      Taste.b()
    end
  elseif c >= "0" and c <= "9" and seite >= 0 then
    Taste.Zahl(c)
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
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
  if seite >= 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.vorherigeSeite, 0)
  else
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_links_X + 2, Taste.Koordinaten.Pfeil_links_Y, "← " .. sprachen.SteuerungName, 0)
  end
  if seite <= -1 then else
    seite = seite - 1
    gpu.setBackground(Farben.Adressfarbe)
    gpu.setForeground(Farben.Adresstextfarbe)
    for P = 1, Bildschirmhoehe - 3 do
      Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
    end
    Funktion.zeigeAnzeige()
  end
end

function Taste.Pfeil_rechts()
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
  if seite == -1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.zeigeAdressen, 0)
  elseif maxseiten > seite + 1 then
    Funktion.zeigeHier(Taste.Koordinaten.Pfeil_rechts_X, Taste.Koordinaten.Pfeil_rechts_Y, "→ " .. sprachen.naechsteSeite, 0)
  end
  if seite + 1 < maxseiten then
    seite = seite + 1
    gpu.setBackground(Farben.Adressfarbe)
    gpu.setForeground(Farben.Adresstextfarbe)
    for P = 1, Bildschirmhoehe - 3 do
      Funktion.zeigeHier(1, P, "", xVerschiebung - 3)
    end
    Funktion.zeigeAnzeige()
  end
end

function Taste.q(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "Q " .. sprachen.beenden), 0)
  --event.timer(2, Funktion.Infoseite)
  running = false
end

function Taste.d()
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
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
  event.timer(1, Funktion.zeigeMenu)
end

function Taste.e()
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.e_X, Taste.Koordinaten.e_Y, "E " .. sprachen.IDCeingabe, 0)
  if state == "Connected" and direction == "Outgoing" then
    enteridc = ""
    showidc = ""
    entercode = true
    Funktion.zeigeNachricht(sprachen.IDCeingabe .. ":")
  else
    Funktion.zeigeNachricht(sprachen.keineVerbindung)
  end
end

function Taste.o()
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.o_X + 2, Taste.Koordinaten.o_Y, "O " .. sprachen.oeffneIris, 0)
  if iris == "Offline" then else
    Funktion.irisOpen()
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
end

function Taste.c()
  gpu.setBackground(Farben.Steuerungstextfarbe)
  gpu.setForeground(Farben.Steuerungsfarbe)
  Funktion.zeigeHier(Taste.Koordinaten.c_X, Taste.Koordinaten.c_Y, "C " .. sprachen.schliesseIris, 0)
  if iris == "Offline" then else
    Funktion.irisClose()
    iriscontrol = "off"
    if wormhole == "in" then
      sg.sendMessage("Manual Override: Iris: Closed")
    end
  end
end

function Taste.i(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "I " .. sprachen.IrisSteuerung .. sprachen.an_aus), 0)
  --event.timer(2, Funktion.Infoseite)
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

function Taste.z(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "Z " .. sprachen.AdressenBearbeiten), 0)
  --event.timer(2, Funktion.Infoseite)
  if Funktion.Tastatur() then
    gpu.setBackground(Farben.Nachrichtfarbe)
    gpu.setForeground(Farben.Textfarbe)
    edit("stargate/adressen.lua")
    seite = -1
    Funktion.zeigeAnzeige()
    seite = 0
    Funktion.AdressenSpeichern()
  end
end

function Taste.l(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "L " .. sprachen.EinstellungenAendern), 0)
  --event.timer(2, Funktion.Infoseite)
  if Funktion.Tastatur() then
    gpu.setBackground(Farben.Nachrichtfarbe)
    gpu.setForeground(Farben.Textfarbe)
    schreibSicherungsdatei(Sicherung)
    edit("stargate/Sicherungsdatei.lua")
    Sicherung = loadfile("/stargate/Sicherungsdatei.lua")()
    if fs.exists("/stargate/sprache/" .. Sicherung.Sprache .. ".lua") then
      sprachen = loadfile("/stargate/sprache/" .. Sicherung.Sprache .. ".lua")()
    else
      print("\nUnbekannte Sprache\nStandardeinstellung = deutsch")
      sprachen = loadfile("/stargate/sprache/deutsch.lua")()
      os.sleep(1)
    end
    schreibSicherungsdatei(Sicherung)
    Funktion.sides()
    gpu.setBackground(Farben.Nachrichtfarbe)
    term.clear()
    seite = 0
    Funktion.zeigeAnzeige()
  end
end

function Taste.u(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "U " .. sprachen.Update), 0)
  --event.timer(2, Funktion.Infoseite)
  if component.isAvailable("internet") then
    if version ~= Funktion.checkServerVersion() then
      Funktion.beendeAlles()
      loadfile("/autorun.lua")("ja")
    else
      Funktion.zeigeNachricht(sprachen.bereitsNeusteVersion)
    end
  end
end

function Taste.b(y)
  gpu.setBackground(Farben.AdressfarbeAktiv)
  gpu.setForeground(Farben.Adresstextfarbe)
  Funktion.zeigeHier(1, y, "B " .. sprachen.UpdateBeta), 0)
  --event.timer(2, Funktion.Infoseite)
  if component.isAvailable("internet") then
    Funktion.beendeAlles()
    loadfile("/autorun.lua")("beta")
  end
end

function Taste.Zahl(c)
  event.timer(2, Funktion.zeigeMenu)
  gpu.setBackground(Farben.hellgrau)
  gpu.setForeground(Farben.Adresstextfarbe)
  if c == "0" then
    c = 10
  end
  local y = c
  c = c + seite * 10
  na = gespeicherteAdressen[tonumber(c)]
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
    if na[3] == "-" then
    else
      outcode = na[3]
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

function Funktion.eventLoop()
  while running do
    Funktion.checken(Funktion.zeigeStatus)
    e = Funktion.pull_event()
    if not e then
    elseif not e[1] then
    elseif e[1] == "touch" then
      Funktion.touchscreen(e[3], e[4])
    else
      name = e[1]
      f = Funktion[name]
      if f then
        Funktion.checken(f, e)
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
            Funktion.angekommeneAdressen(inAdressen)
          end
          if type(e[6]) == "string" then
            Funktion.angekommeneVersion(e[6])
          end
        end
        messageshow = true
      end
    end
  end
end

function Funktion.angekommeneAdressen(...)
  local AddNewAddress = false
  for a, b in pairs(...) do
    local neuHinzufuegen = false
    for c, d in pairs(adressen) do
      if b[2] ~= d[2] then
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
  gpu.setBackground(Farben.schwarzeFarbe)
  gpu.setForeground(Farben.weisseFarbe)
  term.clear()
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
  screen.setTouchModeInverted(false)
end

function Funktion.main()
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "StargateComputer")
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
  Funktion.eventLoop()
  Funktion.beendeAlles()
end

Funktion.checken(Funktion.main)
