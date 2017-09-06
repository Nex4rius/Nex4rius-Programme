local r = component.proxy(component.list("redstone")())
local typ, uuid, side, signal
local Farben = {}
local f = {}

Farben.weiss   = 0  --außen piston
Farben.schwarz = 15 --außen schalter
Farben.rot     = 14 --innen piston
Farben.blau    = 11 --innen schalter

function f.start()
  for side = 0, 5 do
    local ausgabe = {}
    for i = 0, 15 do
       ausgabe[i] = 0
    end
    ausgabe[Farben.weiss] = 255
    ausgabe[Farben.rot] = 255
    r.setBundledOutput(side, ausgabe)
  end
end

local function sleep(...)
  local start = computer.uptime()
  while start + ... > computer.uptime() do end
end

function f.main()
  typ, uuid, side = computer.pullSignal()
  if typ == "redstone_changed" then
    local ausgabe = {}
    signal = r.getBundledInput(side)
    if signal[Farben.schwarz] > 0 and signal[Farben.blau] == 0 then
      r.setBundledOutput(side, Farben.rot, 255)
      sleep(0.1)
      r.setBundledOutput(side, Farben.weiss, 0)
    elseif signal[Farben.schwarz] == 0 and signal[Farben.blau] > 0 then
      r.setBundledOutput(side, Farben.weiss, 255)
      sleep(0.1)
      r.setBundledOutput(side, Farben.rot, 0)
    end
    sleep(1)
  end
end

f.start()

function f.loop()
  while true do
    main()
  end
end

while true do
  pcall(f.loop)
end
