local component = require("component")
local computer = require("computer")
local gpu = component.getPrimary("gpu")
local modem = component.getPrimary("modem")
local event = require("event")
local term = require("term")
local fs = require("filesystem")

local f = {}
local port
local weiter = true
local text = ""

function f.antwort(...)
  local e = {...}
  text = e[6] .. string.rep(" ", 50)
  computer.beep("-")
  gpu.set(1, 5, text)
end

function f.loop()
  while weiter do
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
    port = loadfile("/port")() or 645
  else
    print("Port? (standard: 645)")
    local eingabe = io.read()
    if type(eingabe) == "number" then
      if eingabe <= 65534 and eingabe >= 1 then
        port = math.floor(eingabe)
        local d = io.open("/port", "w")
        d:write("return " .. port)
        d:close()
      end
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
