--
--  Interactive stargate control program
--  Shows stargate state and allows dialling
--  addresses selected from a list
--  with automated Iris control
--  by DarknessShadow
--
-- install by typing this
-- wget -f "https://raw.githubusercontent.com/DarknessShadow/Stargate-Programm/master/installieren.lua" installieren.lua
-- installieren
--

dofile("stargate/adressen.lua")
dofile("stargate/config.lua")
dofile("stargate/compat.lua")
dofile("stargate/sicherNachNeustart.lua")

function pad(s, n)
  return s .. string.rep(" ", n - string.len(s))
end

function checkReset()
  if time == "-" then else
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
    end
  end
end

function zeigeMenu()
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", 35)
  end
  setCursor(1, 1)
  if seite == -1 then
    print(Steuerung)
    print("I " .. IrisSteuerung .. an_aus)
    print("Z " .. AdressenBearbeiten)
    print("Q " .. beenden)
    print("L " .. spracheAendern)
    print(RedstoneSignale)
    print(versionName .. version)
  else
    print(Adressseite .. seite + 1)
    for i, na in pairs(adressen) do
      if i >= 1 + seite * 10 and i <= 10 + seite * 10 then
        AdressAnzeige = i - seite * 10
        if AdressAnzeige == 10 then
          AdressAnzeige = 0
        end
        print(AdressAnzeige .. " " .. string.sub(na[1], 1, 31))
        if sg.energyToDial(na[2]) == nil then
          gpu.setForeground(ErrorFarbe)
          print("   " .. errorName)
          gpu.setForeground(Adresstextfarbe)
        else
          print("   ".. string.format("%.1f", (sg.energyToDial(na[2])*energymultiplicator)/1000).." k")
        end
      end
      maxseiten = i / 10
    end
    iris = sg.irisState()
  end
end

function FarbenLeer()
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  for P = 1, screen_height - 3 do
    zeigeHier(1, P, "", 35)
  end
  if sg.irisState() == "Offline" then
    gpu.setBackground(Statusfarbe)
    gpu.setForeground(Statustextfarbe)
    for P = 1, screen_height - 13 do
      zeigeHier(38, P, "")
    end
    gpu.setBackground(Steuerungsfarbe)
    gpu.setForeground(Steuerungstextfarbe)
    for P = screen_height - 11, screen_height - 3 do
      zeigeHier(38, P, "")
    end
  else
    gpu.setBackground(Statusfarbe)
    gpu.setForeground(Statustextfarbe)
    for P = 1, screen_height - 12 do
      zeigeHier(38, P, "")
    end
    gpu.setBackground(Steuerungsfarbe)
    gpu.setForeground(Steuerungstextfarbe)
    for P = screen_height - 10, screen_height - 3 do
      zeigeHier(38, P, "")
    end
  end
  gpu.setBackground(Nachrichtfarbe)
  gpu.setForeground(Nachrichttextfarbe)
  for P = screen_height - 1, screen_height do
    zeigeHier(1, P, "")
  end
  gpu.setBackground(Adressfarbe)
  gpu.setForeground(Adresstextfarbe)
  zeigeFarben()
end

function zeigeFarben()
  gpu.setBackground(Trennlinienfarbe)
  for P = 1, screen_height - 2 do
    zeigeHier(36, P, "  ", 1)
  end
  zeigeHier(1, screen_height - 2, "", 80)
  zeigeHier(36, Trennlinienhoehe, "")
  neueZeile(1)
end

function getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function irisClose()
  sg.closeIris()
  if redst == true then
    if sideNum == nil then
      sides()
    end
    r.setBundledOutput(sideNum, yellow, 255)
  end
  IrisZustandName = irisNameSchliessend
end

function irisOpen()
  sg.openIris()
  if redst == true then
    if sideNum == nil then
      sides()
    end
    r.setBundledOutput(sideNum, yellow, 0)
  end
  IrisZustandName = irisNameOeffnend
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
    r.setBundledOutput(sideNum, black, 255)
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
    sg.sendMessage("Iris Control: "..control.." Iris: "..iris)
    send = false
  end
  if wormhole == "in" and state == "Dialling" and iriscontrol == "on" and control == "On" then
    if iris == "Offline" then else
      irisClose()
      if redst == true then
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
    if iris == "Offline" then else
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
  end
  if state == "Idle" then
    incode = "-"
    wormhole = "in"
  end
  if state == "Closing" and control == "On" then
    k = "close"
  end
  if state == "Connected" and direction == "Outgoing" and send == true then
    if outcode == "-" or outcode == nil then else
      sg.sendMessage(outcode)
      send = false
    end
  end
  if codeaccepted == "-" or codeaccepted == nil then
  elseif messageshow == true then
    zeigeNachricht(nachrichtAngekommen .. codeaccepted .. "                   ")
    if codeaccepted == "Request: Disconnect Stargate" then
      os.sleep(1)
      sg.disconnect()
      os.sleep(1)
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
  if AddNewAddress == true then
    f = io.open ("stargate/adressen.lua", "a")
    f:seek ("end", firstrun)
    f:write('  {"' .. g .. '", "' .. g .. '", ""},\n}')
    f:close ()
    AddNewAddress = false
    firstrun = -1
    schreibSicherungsdatei()
    dofile("stargate/adressen.lua")
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
  if A == "" or A == nil then
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
  locAddr = getAddress(sg.localAddress())
  remAddr = getAddress(sg.remoteAddress())
  destinationName()
  state, chevrons, direction = sg.stargateState()
  wormholeDirection()
  iris = sg.irisState()
  iriscontroller()
  if     iris == "Open" then
    IrisZustandName = irisNameOffen
  elseif iris == "Opening" then
    IrisZustandName = irisNameOeffnend
  elseif iris == "Closed" then
    IrisZustandName = irisNameGeschlossen
  elseif iris == "Closing" then
    IrisZustandName = irisNameSchliessend
  end
  if control == "On" then
    irisKontrolleName = irisKontrolleNameAn
  else
    irisKontrolleName = irisKontrolleNameAus
  end
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
  energy = sg.energyAvailable()*energymultiplicator
  zeile = 1
end

function zeigeStatus()
  gpu.setBackground(Statusfarbe)
  gpu.setForeground(Statustextfarbe)
  aktualisiereStatus()
  zeigeHier(38, zeile, "  " .. lokaleAdresse .. locAddr) neueZeile(1)
  zeigeHier(38, zeile, "  " .. zielAdresse .. remAddr) neueZeile(1)
  zeigeHier(38, zeile, "  " .. zielName .. string.sub(remoteName, 1, 22)) neueZeile(1)
  zeigeHier(38, zeile, "  " .. statusName .. StatusName) neueZeile(1)
  zeigeEnergie() neueZeile(1)
  zeigeHier(38, zeile, "  " .. IrisName .. IrisZustandName) neueZeile(1)
  if iris == "Offline" then else
    zeigeHier(38, zeile, "  " .. IrisSteuerung .. irisKontrolleName) neueZeile(1)
  end
  if IDCyes == true then
    zeigeHier(38, zeile, "  " .. IDCakzeptiert) neueZeile(1)
  else
    zeigeHier(38, zeile, "  " .. IDCname .. string.sub(incode, 1, 22)) neueZeile(1)
  end
  zeigeHier(38, zeile, "  " .. chevronName .. chevrons) neueZeile(1)
  zeigeHier(38, zeile, "  " .. richtung .. RichtungName) neueZeile(1)
  activetime() neueZeile(1)
  autoclose()
  zeigeHier(38, zeile + 1, "")
  Trennlinienhoehe = zeile + 2
  zeigeSteuerung()
  if redst == true then
    RedstoneKontrolle()
  end
end

function RedstoneKontrolle()
  if sideNum == nil then
    sides()
  end
  if direction == "Incoming" then
    if redstoneIncoming == true then
      r.setBundledOutput(sideNum, red, 255)
      redstoneIncoming = false
    end
  elseif redstoneIncoming == false and state == "Idle" then
    r.setBundledOutput(sideNum, red, 0)
    redstoneIncoming = true
  end
  if state == "Idle" then
    if redstoneState == true then
      r.setBundledOutput(sideNum, white, 0)
      redstoneState = false
    end
  elseif redstoneState == false then
    r.setBundledOutput(sideNum, white, 255)
    redstoneState = true
  end
  if IDCyes == true then
    if redstoneIDC == true then
      r.setBundledOutput(sideNum, black, 255)
      redstoneIDC = false
    end
  elseif redstoneIDC == false then
    r.setBundledOutput(sideNum, black, 0)
    redstoneIDC = true
  end
  if state == "Connected" then
    if redstoneConnected == true then
      r.setBundledOutput(sideNum, green, 255)
      redstoneConnected = false
    end
  elseif redstoneConnected == false then
    r.setBundledOutput(sideNum, green, 0)
    redstoneConnected = true
  end
end

function zeigeSteuerung()
  zeigeFarben()
  gpu.setBackground(Steuerungsfarbe)
  gpu.setForeground(Steuerungstextfarbe)
  for P = screen_height - 10, screen_height - 3 do
    zeigeHier(38, P, "")
  end
  neueZeile(3)
  zeigeHier(40, zeile, Steuerung) neueZeile(2)
  zeigeHier(40, zeile, "D " .. abschalten)
  zeigeHier(58, zeile, "E " .. IDCeingabe) neueZeile(1)
  if iris == "Offline" then
    control = "Off"
  else
    zeigeHier(40, zeile, "O " .. oeffneIris)
    zeigeHier(58, zeile, "C " .. schliesseIris) neueZeile(1)
  end
  if seite >= 0 then
    if seite >= 1 then
      zeigeHier(40, zeile, "← " .. vorherigeSeite)
    else
      zeigeHier(40, zeile, "← " .. SteuerungName)
    end
  end
  if seite == -1 then
    zeigeHier(58, zeile, "→ " .. zeigeAdressen)
  elseif maxseiten > seite + 1 then
    zeigeHier(58, zeile, "→ " .. naechsteSeite)
  end
  neueZeile(1)
end

function autoclose()
  if autoclosetime == false then
    zeigeHier(38, zeile, "  " .. autoSchliessungAus)
  else
    zeigeHier(38, zeile, "  " .. autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function zeigeEnergie()
  if energy < 10000000 then
    zeigeHier(38, zeile, "  " .. energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000) .. " k")
  else
    zeigeHier(38, zeile, "  " .. energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000000) .. " M")
  end
end

function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time())/sectime
    if time > 0 then
      zeigeHier(38, zeile, "  " .. zeit1 .. string.format("%.1f", time) .. "s")
    end
  else
    zeigeHier(38, zeile, "  " .. zeit2)
  end
end

function zeigeHier(x, y, s, h)
  setCursor(x, y)
  if h == nil then
    write(pad(s, 80))
  else
    write(pad(s, h))
  end
end

function zeigeNachricht(mess)
  gpu.setBackground(Nachrichtfarbe)
  gpu.setForeground(Nachrichttextfarbe)
  zeigeHier(1, screen_height - 1, "", 80)
  zeigeHier(1, screen_height, mess)
  gpu.setBackground(Statusfarbe)
end

function zeigeError(mess)
  i = string.find(mess, ": ")
  if i then
    mess = "Error: " .. string.sub(mess, i + 2)
  end
  zeigeNachricht(mess)
end

handlers = {}

function dial(name, addr)
  zeigeNachricht(waehlen .. string.sub(name, 1, 50) .. " (" .. addr .. ")")
  remoteName = name
  check(sg.dial(addr))
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if e[3] == 13 then
    entercode = false
    sg.sendMessage(enteridc)
  elseif entercode == true then
    enteridc = enteridc .. c
    showidc = showidc .. "*"
    zeigeNachricht("Enter IDC: " .. showidc)
  elseif c == "e" then
    if state == "Connected" and direction == "Outgoing" then
      enteridc = ""
      showidc = ""
      entercode = true
      zeigeNachricht("Enter IDC:")
    else
      zeigeNachricht(keineVerbindung)
    end
  elseif c == "d" then
    if state == "Connected" and direction == "Incoming" then
        sg.sendMessage("Request: Disconnect Stargate")
        zeigeNachricht(aufforderung)
    else
        sg.disconnect()
    end
  elseif c == "o" then
    if iris == "Offline" then else
      irisOpen()
      if wormhole == "in" then
        if iris == "Offline" then else
          os.sleep(2)
          sg.sendMessage("Manual Override: Iris Open")
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
        sg.sendMessage("Manual Override: Iris Closed")
      end
    end
  elseif c == "q" then
    running = false
  elseif c >= "0" and c <= "9" then
    if c == "0" then
      c = 10
    end
    c = c + seite * 10
    na = adressen[tonumber(c)]
    iriscontrol = "off"
    wormhole = "out"
    if na then
      dial(na[1], na[2])
      if na[3] == "-" then
        else outcode = na[3]
      end
    end
  elseif c == "i" then
    if iris == "Offline" then else
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
    os.execute("edit stargate/adressen.lua")
    dofile("stargate/adressen.lua")
    sides()
    gpu.setBackground(schwarzeFarbe)
    gpu.setForeground(weisseFarbe)
    zeigeStatus()
    zeigeMenu()
  elseif c == "l" then
    term.clear()
    print(spracheAendern .. "\n")
    gpu.setBackground(Adressfarbe)
    gpu.setForeground(Adresstextfarbe)
    antwortFrageSprache = io.read()
    if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
      Sprache = string.lower(antwortFrageSprache)
      dofile("stargate/sprache/" .. Sprache .. ".lua")
      schreibSicherungsdatei()
    else
      print(errorName)
    end
    seite = 0
    zeigeAnzeige()
  elseif e[3] == 0 and e[4] == 203 then
    if seite <= -1 then else
      seite = seite - 1
      zeigeAnzeige()
    end
  elseif e[3] == 0 and e[4] == 205 then
    if seite + 1 < maxseiten then
      seite = seite + 1
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
    zeigeStatus()
    checkReset()
    e = {pull_event()}
    if e[1] == nil then else
      name = e[1]
      f = handlers[name]
      if f then
        zeigeNachricht("")
        ok, result = pcall(f, e)
        if not ok then
          zeigeError(result)
        end
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

function zeigeAnzeige()
  FarbenLeer()
  zeigeStatus()
  zeigeMenu()
end

function main()
  zeigeAnzeige()
  eventLoop()
  gpu.setBackground(schwarzeFarbe)
  gpu.setForeground(weisseFarbe)
  gpu.setResolution(max_Bildschirmbreite, max_Bildschirmhoehe)
  term.clear()
  setCursor(1, 1)
end

if sg.stargateState() == "Idle" and sg.irisState() == "Closed" then
  irisOpen()
end

main()
