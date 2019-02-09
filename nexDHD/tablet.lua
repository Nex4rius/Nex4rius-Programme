local component = require("component")
local gpu = component.getPrimary("gpu")
local modem = component.getPrimary("modem")
local event = require("event")
local term = require("term")
local fs = require("filesystem")

local f = {}
local port = 645
local weiter = true
local text = ""

function f.antwort(...)

end

function f.loop()
  while weiter do
    term.clear()
    gpu.set(1, 1, "IDC eingeben")
    gpu.set(1, 2, "IDC:")
    gpu.set(1, 4, text)
    term.setCursor(6, 2)
    modem.broadcast(port, io.read())
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
--  gpu.setResolution(40, 4)
  modem.setStrength(math.huge)
  event.listen("modem_message", f.antwort)
  if fs.exists("/port") then
    port = loadfile("/port")() or 645
  else
    print("Port? (standard: 645)")
    local eingabe = io.read()
    if type(eingabe) == "number" then
      if eingabe <= 65535 and eingabe >= 1 then
        port = math.floor(eingabe)
        local d = io.open("/port", "w")
        d:write("return " .. port)
        d:close()
      end
    end
  end
  os.sleep(1)
  modem.open(port)
  pcall(f.loop)
  gpu.setResolution(gpu.maxResolution())
  event.ignore("modem_message")
end

print(pcall(f.main))
