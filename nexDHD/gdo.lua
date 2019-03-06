local component = require("component")
local computer = require("computer")
local gpu = component.getPrimary("gpu")
local modem = component.getPrimary("modem")
local event = require("event")
local term = require("term")
local fs = require("filesystem")

local f = {}
local port
local portstandard = 645
local weiter = true
local text = ""
local ausschalttimer = 0

os.sleep(2)

function f.reset()
  event.cancel(ausschalttimer)
  ausschalttimer = event.timer(120, require("computer").shutdown, 1)
end

function f.antwort(...)
  local e = {...}
  if e[6] == "nexDHD" then
    return
  elseif string.len(e[6]) > 0 and e[6] .. string.rep(" ", 50) ~= text then
    f.reset()
    text = e[6] .. string.rep(" ", 50)
    computer.beep("--")
    gpu.set(1, 5, text)
  end
end

function f.loop()
  modem.setWakeMessage("nexDHD")
  modem.setStrength(20)
  while weiter do
    f.reset()
    term.clear()
    gpu.set(1, 1, "nexDHD GDO")
    gpu.set(1, 2, "IDC eingeben")
    gpu.set(1, 3, "IDC:")
    gpu.set(1, 5, text)
    term.setCursor(6, 3)
    local code = io.read()
    text = "IDC senden: '" .. code .. "'" .. string.rep(" ", 50)
    modem.broadcast(port, code)
    os.sleep(2)
    modem.broadcast(port, code)
  end
end

function f.main()
  if not component.isAvailable("tablet") then
    print("Kein Tablet")
    return
  end
  if not modem.isWireless() then
    print("Keine WLAN-Karte")
    return
  end
  modem.setStrength(math.huge)
  event.listen("modem_message", f.antwort)
  term.clear()
  if fs.exists("/port") then
    port = loadfile("/port")() or portstandard
  else
    print("Port? (standard: " .. portstandard .. ")")
    local eingabe = io.read()
    if type(eingabe) == "number" then
      if eingabe <= 65534 and eingabe >= 1 then
        port = math.floor(eingabe)
      end
    else
      port = portstandard
    end
    local d = io.open("/port", "w")
    d:write("return " .. port)
    d:close()
  end
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "nexDHD GDO " .. port)
  modem.open(port)
  port = port + 1
  gpu.setResolution(50, 5)
  pcall(f.loop)
  gpu.setResolution(gpu.maxResolution())
  event.ignore("modem_message", f.antwort)
  event.cancel(ausschalttimer)
end

print(pcall(f.main))
