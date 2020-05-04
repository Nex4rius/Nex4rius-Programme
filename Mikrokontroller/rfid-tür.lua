local component = component
local red = component.proxy(component.list("redstone")())
local rfid = component.proxy(component.list("os_rfidreader")())
local f = {}

for side = 0, 5 do
  red.setOutput(side, 0)
end

function f.redstone_changed()
  f.rfid(rfid.scan(5))
end

function f.rfid(rfid)
end

function f.main()
  local event = {computer.pullSignal()}
  if f[event[1]] then
    f[event[1]](event)
  end
end

function f.loop()
  while true do
    main()
  end
end

while true do
  pcall(f.loop)
end
