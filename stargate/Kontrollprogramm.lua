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

gpu.setBackground(0x333333)

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
      if i >= 1 + seite * 9 and i <= 9 + seite * 9 then
        print(i - seite * 9 .. " " .. na[1])
        if sg.energyToDial(na[2]) == nil then
          gpu.setForeground(0xFF0000)
          print("   " .. errorName)
          gpu.setForeground(0xFFFFFF)
        else
          print("   ".. string.format("%.1f", (sg.energyToDial(na[2])*energymultiplicator)/1000).." k")
        end
      end
      maxseiten = i / 9
    end
    iris = sg.irisState()
  end
end

function getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function irisClose()
  sg.closeIris()
  if redst == true then
    r.setBundledOutput(sideNum, yellow, 255)
  end
  IrisZustandName = irisNameSchliessend
end

function irisOpen()
  sg.openIris()
  if redst == true then
    r.setBundledOutput(sideNum, yellow, 0)
  end
  IrisZustandName = irisNameOeffnend
  zeigeHier(40, 6, IrisName .. IrisZustandName)
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
    gpu.setForeground(0xFF0000)
    zeigeNachricht(nachrichtAngekommen .. codeaccepted .. "                   ")
    gpu.setForeground(0xFFFFFF)
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
  gpu.setBackground(0x333333)
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
  else
    IrisZustandName = irisNameOffline
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
  aktualisiereStatus()
        zeigeHier(1, 4, "control hier " .. control)
        zeigeHier(1, 5, "iriscontrol hier " .. iriscontrol)
        zeigeHier(1, 6, "wormhole hier " .. wormhole)
        zeigeHier(1, 7, "state hier " .. state)
        zeigeHier(1, 8, "iris hier " .. iris)
  zeigeHier(40, zeile, lokaleAdresse .. locAddr) neueZeile(1)
  zeigeHier(40, zeile, zielAdresse .. remAddr) neueZeile(1)
  zeigeHier(40, zeile, zielName .. remoteName) neueZeile(1)
  zeigeHier(40, zeile, statusName .. StatusName) neueZeile(1)
  zeigeEnergie() neueZeile(1)
  zeigeHier(40, zeile, IrisName .. IrisZustandName) neueZeile(1)
  if iris == "Offline" then else
    zeigeHier(40, zeile, IrisSteuerung .. irisKontrolleName) neueZeile(1)
  end
  if IDCyes == true then
    zeigeHier(40, zeile, IDCakzeptiert) neueZeile(1)
  else
    zeigeHier(40, zeile, IDCname .. incode) neueZeile(1)
  end
  zeigeHier(40, zeile, chevronName .. chevrons) neueZeile(1)
  zeigeHier(40, zeile, richtung .. RichtungName) neueZeile(1)
  activetime() neueZeile(1)
  autoclose() neueZeile(1)
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
  neueZeile(2)
  zeigeHier(40, zeile, Steuerung) neueZeile(1)
  zeigeHier(40, zeile, "D " .. abschalten) neueZeile(1)
  if iris == "Offline" then
    control = "Off"
  else
    zeigeHier(40, zeile, "O " .. oeffneIris) neueZeile(1)
    zeigeHier(40, zeile, "C " .. schliesseIris) neueZeile(1)
  end
  zeigeHier(40, zeile, "E " .. IDCeingabe) neueZeile(1)
  if seite == -1 then
    zeigeHier(40, zeile, "→ " .. zeigeAdressen) neueZeile(1)
  elseif maxseiten > seite + 1 then
    zeigeHier(40, zeile, "→ " .. naechsteSeite) neueZeile(1)
  end
  if seite >= 0 then
    if seite >= 1 then
      zeigeHier(40, zeile, "← " .. vorherigeSeite)
    else
      zeigeHier(40, zeile, "← " .. SteuerungName)
    end
    neueZeile(1)
  end
end

function autoclose()
  if autoclosetime == false then
    zeigeHier(40, zeile, autoSchliessungAus)
  else
    zeigeHier(40, zeile, autoSchliessungAn .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function zeigeEnergie()
  if energy < 10000000 then
    zeigeHier(40, zeile, energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000) .. " k")
  else
    zeigeHier(40, zeile, energie1 .. energytype .. energie2 .. string.format("%.1f", energy/1000000) .. " M")
  end
end

function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time())/sectime
    if time > 0 then
      zeigeHier(40, zeile, zeit1 .. string.format("%.1f", time) .. "s")
    end
  else
    zeigeHier(40, zeile, zeit2)
  end
end

function zeigeHier(x, y, s, h)
  setCursor(x, y)
  if h == nil then
    write(pad(s, 50))
  else
    write(pad(s, 1))
  end
end

function zeigeNachricht(mess)
  zeigeHier(1, screen_height, mess)
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
  zeigeNachricht(waehlen .. name .. " (" .. addr .. ")")
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
  elseif c >= "1" and c <= "9" then
    c = c + seite * 9
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
    zeigeMenu()
  elseif c == "l" then
    term.clear()
    print(spracheAendern .. "\n")
    antwortFrageSprache = io.read()
    if string.lower(antwortFrageSprache) == "deutsch" or string.lower(antwortFrageSprache) == "english" then
      Sprache = string.lower(antwortFrageSprache)
      dofile("stargate/sprache/" .. Sprache .. ".lua")
      schreibSicherungsdatei()
    else
      print(errorName)
    end
    seite = 0
    term.clear()
    zeigeStatus()
    zeigeMenu()
  elseif e[3] == 0 and e[4] == 203 then
    if seite <= -1 then else
      seite = seite - 1
      term.clear()
      zeigeStatus()
      zeigeMenu()
    end
  elseif e[3] == 0 and e[4] == 205 then
    if seite + 1 < maxseiten then
      seite = seite + 1
      term.clear()
      zeigeStatus()
      zeigeMenu()
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

function main()
  term.clear()
  zeigeStatus()
  zeigeMenu()
  eventLoop()
  gpu.setBackground(0x00000)
  term.clear()
  setCursor(1, 1)
end

if sg.stargateState() == "Idle" and sg.irisState() == "Closed" then
  irisOpen()
end

messageshow = true

running = true

main()
