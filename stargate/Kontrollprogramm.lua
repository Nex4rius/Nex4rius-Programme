--
--  Interactive stargate control program
--  Shows stargate state and allows dialling
--  addresses selected from a list
--  with automated Iris control
--
--  pastebin run -f fa9gu1GJ
--  von Nex4rius

dofile("/stargate/adressen.lua")

local ZeitBeimEinschalten   = os.time()
os.sleep(1)
local sectime               = ZeitBeimEinschalten - os.time()
local letzteNachricht       = os.time()
local letzterAdressCheck    = os.time() / sectime
local enteridc              = ""
local showidc               = ""
local remoteName            = ""
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
local zeile                 = 1
local energymultiplicator   = 20
local xVerschiebung         = 33
local AddNewAddress         = true
local messageshow           = true
local running               = true
local send                  = true
local IDCyes                = false
local entercode             = false
local redstoneConnected     = false
local redstoneIncoming      = false
local redstoneState         = false
local redstoneIDC           = false
local IrisZustandName       = irisNameOffline

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

local ZeitBeimEinschalten   = nil

if redst == true then
  local white               = 0
  r.setBundledOutput(0, white, 0)
--  local orange              = 1
--  r.setBundledOutput(0, orange, 0)
--  local magenta             = 2
--  r.setBundledOutput(0, magenta, 0)
--  local lightblue           = 3
--  r.setBundledOutput(0, lightblue, 0)
  local yellow              = 4
  r.setBundledOutput(0, yellow, 0)
--  local lime                = 5
--  r.setBundledOutput(0, lime, 0)
--  local pink                = 6
--  r.setBundledOutput(0, pink, 0)
--  local gray                = 7
--  r.setBundledOutput(0, gray, 0)
--  local silver              = 8
--  r.setBundledOutput(0, silver, 0)
--  local cyan                = 9
--  r.setBundledOutput(0, cyan, 0)
--  local purple              = 10
--  r.setBundledOutput(0, purple, 0)
--  local blue                = 11
--  r.setBundledOutput(0, blue, 0)
--  local brown               = 12
--  r.setBundledOutput(0, brown, 0)
  local green               = 13
  r.setBundledOutput(0, green, 0)
  local red                 = 14
  r.setBundledOutput(0, red, 0)
  local black               = 15
  r.setBundledOutput(0, black, 0)
end

if RF == true then
  local energytype          = "RF"
  local energymultiplicator = 80
end

if sg.irisState() == "Offline" then
  local Trennlinienhoehe    = 13
else
  local Trennlinienhoehe    = 14
end

dofile("/stargate/compat.lua")
dofile("/stargate/sicherNachNeustart.lua")
dofile("/stargate/sprache/" .. Sprache .. ".lua")
dofile("/stargate/sprache/ersetzen.lua")

function pad(s, n)
  return s .. string.rep(" ", n - string.len(s))
end

function zeichenErsetzen(eingabeErsetzung)
  return string.gsub(eingabeErsetzung, "%a+", function (str) return ersetzen [str] end)
end

function checkReset()
  if not time == "-" then
    if time > 500 then
      zeigeNachricht("")
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
      AdressenSpeichern()
      letzterAdressCheck = os.time() / sectime
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
  if not iris == "Offline" then
    print("I " .. IrisSteuerung .. an_aus)
  end
  print("Z " .. AdressenBearbeiten)
  print("Q " .. beenden)
  print("L " .. spracheAendern .. "\n" .. verfuegbareSprachen)
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
end

function AdressenSpeichern()
  dofile("/stargate/adressen.lua")
  gespeicherteAdressen = {}
  local k = 0
  for i, na in pairs(adressen) do
    gespeicherteAdressen[i + k] = {}
    if na[2] == getAddress(sg.localAddress()) then
      k = -1
    else
      gespeicherteAdressen[i + k][1] = na[1]
      gespeicherteAdressen[i + k][2] = na[2]
      gespeicherteAdressen[i + k][3] = na[3]
      local anwahlEnergie = sg.energyToDial(na[2])
      if not anwahlEnergie then
        gespeicherteAdressen[i + k][4] = fehlerName
      else
        if anwahlEnergie > 10000000 then
          gespeicherteAdressen[i + k][4] = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000000) .. " M"
        elseif anwahlEnergie > 10000 then
          gespeicherteAdressen[i + k][4] = string.format("%.1f", (sg.energyToDial(na[2]) * energymultiplicator) / 1000) .. " k"
        else
          gespeicherteAdressen[i + k][4] = string.format("%.f" , (sg.energyToDial(na[2]) * energymultiplicator))
        end
      end
    end
    zeigeNachricht(verarbeiteAdressen .. "<" .. na[2] .. "> <" .. na[1] .. ">")
    maxseiten = (i + k) / 10
  end
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", xVerschiebung - 3)
  end
  zeigeMenu()
  zeigeNachricht("")
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
  if redst then
    if not sideNum then
      sides()
    end
    r.setBundledOutput(sideNum, yellow, 255)
  end
  Colorful_Lamp_Farben(31744)
  IrisZustandName = irisNameSchliessend
end

function irisOpen()
  sg.openIris()
  if redst then
    if not sideNum then
      sides()
    end
    r.setBundledOutput(sideNum, yellow, 0)
  end
  IrisZustandName = irisNameOeffnend
  iris = "Opening"
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
    if redst then
      r.setBundledOutput(sideNum, black, 255)
    end
    Colorful_Lamp_Farben(992)
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
  elseif direction == "Incoming" and send then
    sg.sendMessage("Iris Control: "..control.." Iris: "..iris)
    send = false
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and control == "On" then
    if not iris == "Offline" then
      irisClose()
      if redst then
        r.setBundledOutput(sideNum, red, 255)
      end
      redstoneIncoming = false
    end
    k = "close"
  end
  if iris == "Closing" and control == "On" then
    k = "open"
  end
  if state == "Idle" and k == "close" and control == "On" then
    outcode = nil
    if not iris == "Offline" then
      irisOpen()
    end
    iriscontrol = "on"
    wormhole = "in"
    codeaccepted = "-"
    activationtime = 0
    entercode = false
    showidc = ""
  end
  if state == "Idle" and control == "On" then
    iriscontrol = "on"
  end
  if state == "Closing" then
    send = true
    incode = "-"
    zeigeNachricht("")
    IDCyes = false
    AddNewAddress = true
    LampenGruen = false
    LampenRot = false
  end
  if state == "Idle" then
    incode = "-"
    wormhole = "in"
    LampenGruen = false
    LampenRot = false
  end
  if state == "Closing" and control == "On" then
    k = "close"
  end
  if state == "Connected" and direction == "Outgoing" and send then
    if outcode == "-" or not outcode then else
      sg.sendMessage(outcode)
      send = false
    end
  end
  if codeaccepted == "-" or not codeaccepted then
  elseif messageshow then
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
  end
end

function neueZeile(b)
  zeile = zeile + b
end

function newAddress(g)
  if AddNewAddress then
    f = io.open ("stargate/adressen.lua", "a")
    f:seek ("end", firstrun)
    f:write('  {"' .. g .. '", "' .. g .. '", ""},\n}')
    f:close ()
    AddNewAddress = false
    firstrun = -1
    schreibSicherungsdatei()
    dofile("/stargate/adressen.lua")
    sides()
    zeigeMenu()
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

function getAddress(A)
  if A == "" or not A then
    return ""
  else
    return string.sub(A, 1, 4) .. "-" .. string.sub(A, 5, 7) .. "-" .. string.sub(A, 8, 9)
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
  sg = component.getPrimary("stargate")
  locAddr = getAddress(sg.localAddress())
  remAddr = getAddress(sg.remoteAddress())
  destinationName()
  state, chevrons, direction = sg.stargateState()
  wormholeDirection()
  iris = sg.irisState()
  iriscontroller()
  if direction == "Outgoing" then
    RichtungName = RichtungNameAus
  elseif direction == "Incoming" then
    RichtungName = RichtungNameEin
  else
    RichtungName = ""
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
  if (letzteNachricht - os.time()) / sectime > 45 then
    zeigeNachricht("                                                                                                        ")
  end
end

function zeigeStatus()
  gpu.setBackground(Statusfarbe)
  gpu.setForeground(Statustextfarbe)
  aktualisiereStatus()
  zeigeHier(xVerschiebung, zeile, "  " .. lokaleAdresse .. locAddr) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielAdresse .. remAddr) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. zielName .. remoteName) neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. statusName .. StatusName) neueZeile(1)
  zeigeEnergie() neueZeile(1)
  zeigeHier(xVerschiebung, zeile, "  " .. IrisName .. zeichenErsetzen(iris)) neueZeile(1)
  if not iris == "Offline" then
    zeigeHier(xVerschiebung, zeile, "  " .. IrisSteuerung .. zeichenErsetzen(control)) neueZeile(1)
  end
  if IDCyes then
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
  if redst then
    r.setBundledOutput(sideNum, a, b)
  end
end

function RedstoneKontrolle()
  if component.isAvailable("redstone") then
    r = component.getPrimary("redstone")
  end
  if not sideNum then
    sides()
  end
  if direction == "Incoming" then
    if redstoneIncoming then
      RedstoneAenderung(red, 255)
      redstoneIncoming = false
    end
  elseif not redstoneIncoming and state == "Idle" then
    RedstoneAenderung(red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState then
      RedstoneAenderung(white, 0)
      redstoneState = false
    end
  elseif not redstoneState then
    RedstoneAenderung(white, 255)
    redstoneState = true
  end
  if IDCyes then
    if redstoneIDC then
      RedstoneAenderung(black, 255)
      redstoneIDC = false
    end
  elseif not redstoneIDC then
    RedstoneAenderung(black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected then
      RedstoneAenderung(green, 255)
      redstoneConnected = false
    end
  elseif not redstoneConnected then
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
  if not autoclosetime then
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAus)
  else
    zeigeHier(xVerschiebung, zeile, "  " .. autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function zeigeEnergie()
  if energy > 10000000 then
    zeigeHier(xVerschiebung, zeile, "  " .. energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000000) .. " M")
  elseif energy > 10000 then
    zeigeHier(xVerschiebung, zeile, "  " .. energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000) .. " k")
  else
    zeigeHier(xVerschiebung, zeile, "  " .. energie1 .. energytype .. energie2 .. string.format("%.f", energy))
  end
end

function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time()) / sectime
    if time > 0 then
      zeigeHier(xVerschiebung, zeile, "  " .. zeit1 .. string.format("%.1f", time) .. "s")
    end
  else
    zeigeHier(xVerschiebung, zeile, "  " .. zeit2)
  end
end

function zeigeHier(x, y, s, h)
  setCursor(x, y)
  if not h then
    write(pad(s, 80))
  else
    write(pad(s, h))
  end
end

function zeigeNachricht(mess)
  letzteNachricht = os.time()
  gpu.setBackground(Nachrichtfarbe)
  gpu.setForeground(Nachrichttextfarbe)
  zeigeHier(1, screen_height - 1, "", 80)
  zeigeHier(1, screen_height, zeichenErsetzen(mess), 80)
  gpu.setBackground(Statusfarbe)
end

function zeigeFehler(mess)
  i = string.find(mess, ": ")
  if i then
    mess = fehlerName .. " " .. string.sub(mess, i + 2)
  end
  if not mess == "" then
    zeigeNachricht(mess)
    schreibFehlerLog()
  end
end

function schreibFehlerLog()
  if not mess_old == mess then
    if fs.exists("/log") then
      f = io.open("log", "a")
    else
      f = io.open("log", "w")
    end
    f:write(mess)
    f:write("\n\n" .. os.time() .. string.rep("-",max_Bildschirmbreite - string.len(os.time())) .. "\n\n")
    f:close()
  end
  mess_old = mess
end

handlers = {}

function dial(name, addr)
  zeigeNachricht(waehlen .. string.sub(name, 1, xVerschiebung + 12) .. " (" .. addr .. ")")
  remoteName = name
  state = "Dialling"
  checken(sg.dial, addr)
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if e[3] == 13 then
    entercode = false
    sg.sendMessage(enteridc)
  elseif entercode then
    enteridc = enteridc .. c
    showidc = showidc .. "*"
    zeigeNachricht(IDCeingabe .. ": " .. showidc)
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
    end
  elseif c == "o" then
    if not iris == "Offline" then
      irisOpen()
      if wormhole == "in" then
        if not iris == "Offline" then
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
    if not iris == "Offline" then
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
      if not iris == "Offline" then
        send = true
        if control == "On" then
          control = "Off"
          schreibSicherungsdatei()
        else
          control = "On"
          schreibSicherungsdatei()
        end
      end
    elseif c == "z" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      os.execute("edit stargate/adressen.lua")
      dofile("/stargate/adressen.lua")
      sides()
      seite = 0
      zeigeAnzeige()
      AdressenSpeichern()
    elseif c == "l" then
      gpu.setBackground(0x333333)
      gpu.setForeground(Textfarbe)
      term.clear()
      print(spracheAendern .. "\n" .. verfuegbareSprachen .. "\n")
      antwortFrageSprache = io.read()
      if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
        Sprache = string.lower(antwortFrageSprache)
        dofile("/stargate/sprache/" .. Sprache .. ".lua")
        dofile("/stargate/sprache/ersetzen.lua")
        schreibSicherungsdatei()
      else
        print(fehlerName)
      end
      seite = 0
      zeigeAnzeige()
    end
  end
end

function handlers.sgChevronEngaged(e)
  chevron = e[3]
  symbol = e[4]
  zeigeNachricht(string.format("Chevron %s %s! (%s)", chevron, aktiviert, symbol))
end

function eventLoop()
  while running do
    checken(zeigeStatus)
    checken(checkReset)
    e = {pull_event()}
    if e[1] == nil then else
      name = e[1]
      f = handlers[name]
      if f then
        zeigeNachricht("")
        checken(f, e)
      end
      if string.sub(e[1],1,3) == "sgM" and direction == "Incoming" and wormhole == "in" then
        if e[3] == "" then else
          incode = e[3]
          messageshow = true
        end
      end
      if string.sub(e[1],1,3) == "sgM" and direction == "Outgoing" then
        codeaccepted = e[3]
        messageshow = true
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
  if iris == "Closed" or iris == "Closing" or LampenRot then
    Colorful_Lamp_Farben(31744)
  elseif not redstoneIDC then
    Colorful_Lamp_Farben(992)
  elseif not redstoneIncoming then
    Colorful_Lamp_Farben(32256)
  elseif LampenGruen then
    Colorful_Lamp_Farben(992)
  elseif redstoneState then
    Colorful_Lamp_Farben(32736)
  else
    Colorful_Lamp_Farben(32767)
  end
end

function Colorful_Lamp_Farben(eingabe, ausgabe)
  for k in component.list("colorful_lamp") do
    component.proxy(k).setLampColor(eingabe)
    if ausgabe then
      print(colorfulLampAusschalten .. k)
    end
  end
end

function zeigeAnzeige()
  gpu.setResolution(70, 25)
  zeigeFarben()
  zeigeStatus()
  zeigeMenu()
end

function beendeAlles()
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  term.clear()
  print(ausschaltenName .. "\n")
  Colorful_Lamp_Farben(0, true)
  if redst then
    r.setBundledOutput(0, white, 0) print(redstoneAusschalten .. "white")
--    r.setBundledOutput(0, orange, 0) print(redstoneAusschalten .. "orange")
--    r.setBundledOutput(0, magenta, 0) print(redstoneAusschalten .. "magenta")
--    r.setBundledOutput(0, lightblue, 0) print(redstoneAusschalten .. "lightblue")
    r.setBundledOutput(0, yellow, 0) print(redstoneAusschalten .. "yellow")
--    r.setBundledOutput(0, lime, 0) print(redstoneAusschalten .. "lime")
--    r.setBundledOutput(0, pink, 0) print(redstoneAusschalten .. "pink")
--    r.setBundledOutput(0, gray, 0) print(redstoneAusschalten .. "gray")
--    r.setBundledOutput(0, silver, 0) print(redstoneAusschalten .. "silver")
--    r.setBundledOutput(0, cyan, 0) print(redstoneAusschalten .. "cyan")
--    r.setBundledOutput(0, purple, 0) print(redstoneAusschalten .. "purple")
--    r.setBundledOutput(0, blue, 0) print(redstoneAusschalten .. "blue")
--    r.setBundledOutput(0, brown, 0) print(redstoneAusschalten .. "brown")
    r.setBundledOutput(0, green, 0) print(redstoneAusschalten .. "green")
    r.setBundledOutput(0, red, 0) print(redstoneAusschalten .. "red")
    r.setBundledOutput(0, black, 0) print(redstoneAusschalten .. "black")
  end
end

function main()
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
