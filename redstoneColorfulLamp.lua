component = require("component")
event = require("event")
r = component.getPrimary("redstone")
Richtung = 0

a = true

function rot()
  for i = 15, 11, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function gelb()
  for i = 15, 6, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function orange()
  for i = 10, 15 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function gruen()
  for i = 10, 6, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function weiss()
  for i = 15, 0, -1 do
    r.setBundledOutput(Richtung, i, 255)
  end
end

function redstone()
end

weiss()

--while a do
--for a = 0, 20 do
  --redstone()
  --event.pull(300)
--end

weiss()
os.sleep(5)
rot()
os.sleep(5)
gelb()
os.sleep(5)
orange()
os.sleep(5)
gruen()
os.sleep(5)
weiss()
