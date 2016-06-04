component = require("component")
event = require("event")
r = component.getPrimary("redstone")

--a = true

function rot(k)
  
end

function weiss()
  for i = 0, 15 do
    r.setBundledOutput(0, i, 255)
  end
end

function redstone()
end

weiss()

while a do
  redstone()
  event.pull(300)
end
