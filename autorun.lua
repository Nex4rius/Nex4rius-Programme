--
--  Interactive stargate control program
--  Shows stargate state and allows dialling
--  addresses selected from a list
--  with automated Iris control
--

dofile("config.lua")
dofile("compat.lua")
dofile("addresses.lua")

function pad(s, n)
  return s .. string.rep(" ", n - string.len(s))
end

function showMenu()
  setCursor(1, 1)
  for i, na in pairs(addresses) do
    print(string.format("%d %s", i, na[1]))
    if sg.energyToDial(na[2]) == nil then
      print("  Error")
    else
      print("  ".. string.format("%.1f", (sg.energyToDial(na[2])*energymultiplicator)/1000).." k")
    end
  end
  iris = sg.irisState()
  print("")
  print("D Disconnect")
  if iris == "Offline" then
    control = "Off"
  else
    print("O Open Iris")
    print("C Close Iris")
    print("I Iris Control On/Off")
  end
  print("E Enter IDC")
--  print("Q Quit")
end

function getIrisState()
  ok, result = pcall(sg.irisState)
  return result
end

function iriscontroller()
  if codeaccepted == "Request: Disconnect Stargate" then
    sg.disconnect()
  end
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
      sg.openIris()
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
      sg.closeIris()
    end
    k = "close"
  end
  if iris == "Closing" and control == "On" then k = "open" end
  if state == "Idle" and k == "close" and control == "On" then
    outcode = nil
    if iris == "Offline" then else
      sg.openIris()
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
    showMessage("")
    IDCyes = false
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
    showMessage("Message received: "..codeaccepted)
    messageshow = false
    incode = "-"
    codeaccepted = "-"
  end
  if state == "Idle" then
    activationtime = 0
    entercode = false
    showAt(40, 3,  "Remote Name:               ")
  end
end

function showState()
  locAddr = sg.localAddress()
  remAddr = sg.remoteAddress()
  state, chevrons, direction = sg.stargateState()
  iris = sg.irisState()
  iriscontroller()
  energy = sg.energyAvailable()*energymultiplicator
  showAt(40, 1,  "Local Addr:   " .. locAddr)
  showAt(40, 2,  "Remote Addr:  " .. remAddr)
  showAt(40, 4,  "State:        " .. state)
  showenergy()
  showAt(40, 6,  "Iris:         " .. iris)
  showAt(40, 7,  "Iris Control: " .. control)
  if IDCyes == true then
    showAt(40, 8, "IDC:          Accepted")
  else
    showAt(40, 8, "IDC:          " .. incode)
  end
  showAt(40, 9,  "Engaged:      " .. chevrons)
  showAt(40, 10,  "Direction:    " .. direction)
  activetime()
  autoclose()
  showAt(40, 13, "Version:      1.3.0")
end

function autoclose()
  if autoclosetime == false then
    showAt(40, 12, "Autoclose:    off")
  else
    showAt(40, 12, "Autoclose:    " .. autoclosetime .. "s")
    if (activationtime - os.time()) / sectime > autoclosetime and state == "Connected" then
      sg.disconnect()
    end
  end
end

function showenergy()
  if energy < 10000000 then
    showAt(40, 5, "Energy "..energytype..":    " .. string.format("%.1f", energy/1000) .. " k")
  else
    showAt(40, 5, "Energy "..energytype..":    " .. string.format("%.1f", energy/1000000) .. " M")
  end
end

function activetime()
  if state == "Connected" then
    if activationtime == 0 then
      activationtime = os.time()
    end
    time = (activationtime - os.time())/sectime
    if time > 0 then
      showAt(40, 11, "Time:         " .. string.format("%.1f", time) .. "s")
    end
  else
    showAt(40, 11, "Time:               ")
  end
end

function showAt(x, y, s)
  setCursor(x, y)
  write(pad(s, 50))
end

function showMessage(mess)
  showAt(1, screen_height, mess)
end

function showError(mess)
  i = string.find(mess, ": ")
  if i then
    mess = "Error: " .. string.sub(mess, i + 2)
  end
  showMessage(mess)
end

handlers = {}

function dial(name, addr)
  showMessage(string.format("Dialling %s (%s)", name, addr))
  showAt(40, 3,  "Remote Name:  " .. name)--string.format("%s", name))
  sg.dial(addr)
end

handlers[key_event_name] = function(e)
  c = key_event_char(e)
  if e[3] == 13 then
    entercode = false
    sg.sendMessage(enteridc)
  elseif entercode == true then
    enteridc = enteridc .. c
    showidc = showidc .. "*"
    showMessage("Enter IDC: " .. showidc)
  elseif c == "e" then
    if state == "Connected" and direction == "Outgoing" then
      enteridc = ""
      showidc = ""
      entercode = true
      showMessage("Enter IDC:")
    else
      showMessage("Stargate not Connected")
    end
  elseif c == "d" then
    if state == "Connected" and direction == "Incoming" then
        sg.sendMessage("Request: Disconnect Stargate")
    else
        sg.disconnect()
    end
  elseif c == "o" then
    if iris == "Offline" then else
      sg.openIris()
      if wormhole == "in" then
        if iris == "Offline" then
        else
          os.sleep(2)
          sg.sendMessage("Manual Override: Iris Open")
        end
      end
      if state == "Idle" then
        iriscontrol = "on"
      else iriscontrol = "off"
      end
    end
  elseif c == "c" then
    if iris == "Offline" then else
      sg.closeIris()
      iriscontrol = "off"
      if wormhole == "in" then
        sg.sendMessage("Manual Override: Iris Closed")
      end
    end
  elseif c == "q" then
    running = false
  elseif c >= "1" and c <= "9" then
    na = addresses[tonumber(c)]
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
      else
        control = "On"
      end
    end
  end
end

function handlers.sgChevronEngaged(e)
  chevron = e[3]
  symbol = e[4]
  showMessage(string.format("Chevron %s engaged! (%s)", chevron, symbol))
end

function eventLoop()
  while running do
    showState()
    e = {pull_event()}
    if e[1] == nil then
    else
      name = e[1]
      f = handlers[name]
      if f then
        showMessage("")
        ok, result = pcall(f, e)
        if not ok then
          showError(result)
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
  showMenu()
  eventLoop()
  term.clear()
  setCursor(1, 1)
end

if sg.stargateState() == "Idle" and sg.irisState() == "Closed" then
  sg.openIris()
end

showAt(40, 3,  "Remote Name:")
messageshow = true

running = true
main()

