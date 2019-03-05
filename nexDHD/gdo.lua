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
local alte_modem_message
local nachricht_entfernen_timer = 0

function f.reset()
  event.cancel(nachricht_entfernen_timer)
  nachricht_entfernen_timer = event.timer(120, function() text = string.rep(" ", 50) gpu.set(1, 5, text) end, 1)
end

function f.antwort(...)
  local e = {...}
  if e[6] .. string.rep(" ", 50) ~= alte_modem_message then
    f.reset()
    text = e[6] .. string.rep(" ", 50)
    computer.beep("--")
    gpu.set(1, 5, text)
    alte_modem_message = text
  end
end

function f.loop()
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
  if fs.exists("/port") then
    port = loadfile("/port")() or portstandard
  else
    print("Port? (standard: " .. portstandard .. ")")
    local eingabe = io.read()
    if type(eingabe) == "number" then
      if eingabe <= 65534 and eingabe >= 1 then
        port = math.floor(eingabe)
        local d = io.open("/port", "w")
        d:write("return " .. port)
        d:close()
      end
    else
      port = portstandard
    end
  end
  loadfile("/bin/label.lua")("-a", require("computer").getBootAddress(), "nexDHD GDO " .. port)
  os.sleep(1)
  modem.open(port)
  port = port + 1
  gpu.setResolution(50, 5)
  pcall(f.loop)
  gpu.setResolution(gpu.maxResolution())
  event.ignore("modem_message", f.antwort)
end

print(pcall(f.main))
