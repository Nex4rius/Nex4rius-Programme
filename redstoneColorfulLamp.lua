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

print("weiss")
weiss()
os.sleep(2)
print("rot")
rot()
os.sleep(2)
print("gelb")
gelb()
os.sleep(2)
print("orange")
orange()
os.sleep(2)
print("gruen")
gruen()
os.sleep(2)
print("weiss")
weiss()
